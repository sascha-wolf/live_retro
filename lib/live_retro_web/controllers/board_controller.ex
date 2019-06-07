defmodule LiveRetroWeb.BoardController do
  use LiveRetroWeb, :controller

  alias LiveRetro.Board
  alias LiveRetroWeb.BoardLive

  def create(conn, _) do
    with {:ok, board} <- Board.new() do
      redirect(conn, to: Routes.board_path(conn, :show, board))
    end
  end

  def show(conn, %{"id" => id}) do
    if Board.exists?(id) do
      live_render(conn, BoardLive, session: id)
    else
      resp(conn, :not_found, "Not Found")
    end
  end
end
