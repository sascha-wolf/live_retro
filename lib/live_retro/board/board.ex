defmodule LiveRetro.Board do
  alias __MODULE__.{Card, Registry, Storage}

  @pubsub LiveRetroWeb.Endpoint

  def subscribe(board) do
    with {:ok, _} <- Registry.lookup(board) do
      @pubsub.subscribe("board-#{board}")
    end
  end

  def exists?(board) do
    match?({:ok, _}, Registry.lookup(board))
  end

  def new(board \\ generate_name()) do
    with {:ok, _} <- Registry.new(board) do
      {:ok, board}
    end
  end

  defp generate_name do
    Mnemonic.generate()
    |> String.split()
    |> Enum.take(6)
    |> Enum.join("-")
  end

  def all_cards(board) do
    with {:ok, pid} <- Registry.lookup(board) do
      Storage.all_cards(pid)
    end
  end

  def add_or_update_card(board, %Card{} = card) do
    with {:ok, pid} <- Registry.lookup(board) do
      :ok = Storage.add_or_update_card(pid, card)
      :ok = broadcast(board, "add_or_update", card)

      :ok
    end
  end

  def delete_card(board, %Card{} = card) do
    with {:ok, pid} <- Registry.lookup(board) do
      :ok = Storage.delete_card(pid, card)
      :ok = broadcast(board, "delete", card)

      :ok
    end
  end

  defp broadcast(board, event, payload) do
    @pubsub.broadcast_from(self(), "board-#{board}", event, payload)
  end
end
