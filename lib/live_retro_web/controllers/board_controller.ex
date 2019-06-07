defmodule LiveRetroWeb.BoardController do
  use LiveRetroWeb, :controller

  alias LiveRetro.Board
  alias LiveRetroWeb.BoardLive

  def index(conn, _params) do
    cards = Board.all_cards()

    live_render(conn, BoardLive, session: cards)
  end
end
