defmodule LiveRetroWeb.BoardController do
  use LiveRetroWeb, :controller

  alias LiveRetro.Board
  alias LiveRetroWeb.BoardLive

  def index(conn, %{"id" => id}) do
    live_render(conn, BoardLive, session: id)
  end
end
