defmodule OpenIDClientWeb.PageController do
  use OpenIDClientWeb, :controller

  def index(conn, _params) do
    redirect(conn, external: OpenIDConnect.authorization_uri(:poc))
  end

  def show(conn, %{"code" => code}) do
    with {:ok, tokens} <- OpenIDConnect.fetch_tokens(:poc, code),
         {:ok, id_token} <- OpenIDConnect.verify(:poc, tokens["id_token"]),
         {:ok, access_token} <- OpenIDConnect.verify(:poc, tokens["access_token"])
    do
      render(conn, "index.html",
        tokens: tokens,
        id_token: id_token,
        access_token: access_token
      )
    else
      _ ->
        render(conn, "index.html",
          tokens: %{},
          id_token: nil,
          access_token: nil
        )
    end
  end
end
