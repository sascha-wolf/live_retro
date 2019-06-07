defmodule LiveRetro.Board do
  use Agent

  @name __MODULE__
  @pubsub LiveRetroWeb.Endpoint

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def all_cards() do
    Agent.get(@name, & &1)
  end

  def add_card(card) do
    @pubsub.broadcast_from(self(), "cards", "add", card)

    Agent.update(@name, &[card | &1])
  end

  def update_card(card) do
    @pubsub.broadcast_from(self(), "cards", "update", card)

    Agent.update(@name, &update_card(&1, card[:id], card[:text]))
  end

  defp update_card([%{id: id} = card | cards], id, text) do
    [%{card | text: text, editable: false} | cards]
  end

  defp update_card([other_card | cards], id, text) do
    [other_card | update_card(cards, id, text)]
  end
end
