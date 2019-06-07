defmodule LiveRetro.Board.Storage do
  use Agent

  def start_link(name) do
    Agent.start_link(fn -> %{} end, name: name)
  end

  def all_cards(agent) do
    Agent.get(agent, & &1)
  end

  def add_or_update_card(agent, %{id: id} = card) do
    Agent.update(agent, &Map.put(&1, id, card))
  end
end
