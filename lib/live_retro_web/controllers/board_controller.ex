defmodule LiveRetroWeb.BoardController do
  use LiveRetroWeb, :controller

  alias LiveRetro.Board
  alias LiveRetroWeb.BoardLive

  def index(conn, %{"id" => id}) do
    if Board.exists?(id) do
      live_render(conn, BoardLive, session: id)
    else
      resp(conn, :not_found, "Not Found")
    end
  end
end
