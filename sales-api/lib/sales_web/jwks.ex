defmodule SalesWeb.Jwks do
  require Logger

  import Plug.Conn

  alias Joken.Signer

  def init(opts), do: opts

  def call(conn, _opts) do
    get_req_header(conn, "authorization")
    |> extract_token()
    |> validate_token(conn)
  end

  defp extract_token([<<_bearer::bytes-size(6), " ">> <> token]),
    do: {:ok, token}
  defp extract_token(_),
    do: :error

  defp validate_token(:error, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, ~s({"error":"unauthorized","reason":"authentication_failed"}))
    |> halt()
  end

  defp validate_token({:ok, token}, conn) do
    case run(token) |> IO.inspect(label: "TOKEN") do
      {:ok, %{"sub" => sub}} ->
        assign(conn, :sub, sub)

      {:error, _reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, ~s({"error":"unauthorized","reason": "authentication_failed"}))
        |> halt()
    end
  end


  def run(jwt_token) when is_binary(jwt_token) do
    jwt_token
    |> get_kid()
    |> fetch_key()
    |> create_signer()
    |> validate(jwt_token)
  end

  defp get_kid(jwt_token) do
    Joken.peek_header(jwt_token)
    |> case do
      {:ok, %{"kid" => kid}} ->
        {:ok, kid}

      {:ok, _} ->
        {:error, :token_without_kid}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp fetch_key({:error, reason}),
    do: {:error, reason}
  defp fetch_key({:ok, kid}) do
    try do
      __MODULE__
      |> :ets.lookup(:keys)
      |> case do
        [] ->
          fetch_key()

        [keys: keys] -> keys
      end
    rescue
      _ ->
        :ets.new(__MODULE__, [:named_table])
        fetch_key()
    end
    |> Enum.reduce_while({:error, :kid_does_not_match}, fn item, acc ->
        case item do
          %{"kid" => ^kid} ->
            {:halt, {:ok, item}}

          _another ->
            {:cont, acc}
        end
    end)
  end
  defp fetch_key do
    Logger.info("fetching keys from server")

    url = "http://keycloak:8080/auth/realms/master/protocol/openid-connect/certs"

    with {:ok, %{body: body}} <- Tesla.get(url),
         {:ok, %{"keys" => keys}} <- Jason.decode(body),
         true <- :ets.insert(__MODULE__, {:keys, keys})
    do
      keys
    else
      {:ok, nil} -> {:error, :config_missing}
      {:error, reason} -> {:error, reason}
    end
  end

  defp create_signer({:error, reason}),
    do: {:error, reason}
  defp create_signer({:ok, %{"alg" => alg} = public_key}),
    do: Signer.create(alg, public_key)

  defp validate({:error, reason}, _),
    do: {:error, reason}
  defp validate(%Signer{} = signer, jwt_token),
    do: SalesWeb.Token.verify_and_validate(jwt_token, signer)
end
