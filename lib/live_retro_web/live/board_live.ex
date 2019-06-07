defmodule LiveRetroWeb.BoardLive do
  use Phoenix.LiveView

  alias LiveRetro.Board
  alias LiveRetro.Board.Card
  alias Phoenix.Socket.Broadcast

  def render(assigns) do
    LiveRetroWeb.BoardView.render("index.html", assigns)
  end

  def mount(_, socket) do
    if connected?(socket), do: LiveRetroWeb.Endpoint.subscribe("cards")

    cards = Board.all_cards()

    {:ok, assign(socket, cards: cards, create_new_for: nil, editable: nil)}
  end

  def handle_event("add", type, socket) do
    type = String.to_existing_atom(type)

    {:noreply, assign(socket, create_new_for: type, editable: nil)}
  end

  def handle_event("create", %{"text" => text, "type" => type}, socket) do
    type = String.to_existing_atom(type)
    card = Card.new(text: text, type: type)

    socket =
      socket
      |> assign(:create_new_for, nil)
      |> update(:cards, &add_card(&1, card))

    {:noreply, socket}
  end

  def handle_event("edit", id, socket) do
    {:noreply, assign(socket, editable: id, create_new_for: nil)}
  end

  def handle_event("update", %{"id" => id, "text" => text}, socket) do
    socket =
      socket
      |> assign(:editable, nil)
      |> update(:cards, &update_card(&1, id, text))

    {:noreply, socket}
  end

  defp add_card(cards, %{id: id} = card) do
    cards = Map.put(cards, id, card)

    Board.add_or_update_card(card)

    cards
  end

  defp update_card(cards, id, text) do
    cards = Map.update!(cards, id, &%{&1 | text: text})

    cards
    |> Map.get(id)
    |> Board.add_or_update_card()

    cards
  end

  def handle_info(%Broadcast{event: "add_or_update", payload: card}, socket) do
    socket =
      update(socket, :cards, fn cards ->
        Map.put(cards, card.id, card)
      end)

    {:noreply, socket}
  end
end
