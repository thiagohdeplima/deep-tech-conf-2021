defmodule Sales.Repo do
  use Ecto.Repo,
    otp_app: :sales,
    adapter: Ecto.Adapters.Postgres
end
