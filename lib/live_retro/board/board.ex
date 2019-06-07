defmodule LiveRetro.Board do
  use Agent

  alias __MODULE__.Card

  @name __MODULE__
  @pubsub LiveRetroWeb.Endpoint

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def all_cards do
    Agent.get(@name, & &1)
  end

  def add_or_update_card(%Card{id: id} = card) do
    @pubsub.broadcast_from(self(), "cards", "add_or_update", card)

    Agent.update(@name, &Map.put(&1, id, card))
  end
end
