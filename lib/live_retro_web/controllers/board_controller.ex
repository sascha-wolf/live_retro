defmodule LiveRetroWeb.BoardController do
  use LiveRetroWeb, :controller

  alias LiveRetroWeb.BoardLive

  def index(conn, _params) do
    cards = []

    live_render(conn, BoardLive, session: cards)
  end
end
