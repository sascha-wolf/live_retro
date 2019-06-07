defmodule LiveRetroWeb.PageController do
  use LiveRetroWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
