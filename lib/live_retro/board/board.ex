defmodule LiveRetro.Board do
  alias __MODULE__.{Card, Registry, Storage}

  @pubsub LiveRetroWeb.Endpoint

  def exists?(board) do
    match?({:ok, _}, Registry.lookup(board))
  end

  def new(board) do
    with {:ok, _} <- Registry.new(board) do
      :ok
    end
  end

  def all_cards(board) do
    with {:ok, pid} <- Registry.lookup(board) do
      Storage.all_cards(pid)
    end
  end

  def add_or_update_card(board, %Card{id: id} = card) do
    with {:ok, pid} <- Registry.lookup(board) do
      :ok = Storage.add_or_update_card(pid, card)
      :ok = @pubsub.broadcast_from(self(), "cards", "add_or_update", card)

      :ok
    end
  end
end
