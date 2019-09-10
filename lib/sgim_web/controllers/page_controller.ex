defmodule SgimWeb.PageController do
  use SgimWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
