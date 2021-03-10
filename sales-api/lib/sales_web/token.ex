defmodule SalesWeb.Token do
  use Joken.Config

  alias Joken.Signer

  @impl true
  def token_config do
    default_claims(skip: [:iss, :aud])
  end

end