defmodule OpenIDClientWeb.PageController do
  use OpenIDClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
