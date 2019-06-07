defmodule LiveRetroWeb.BoardLive do
  use Phoenix.LiveView

  alias LiveRetro.Board
  alias LiveRetro.Board.Card
  alias Phoenix.Socket.Broadcast

  def render(assigns) do
    LiveRetroWeb.BoardView.render("index.html", assigns)
  end

  def mount(board, socket) do
    if connected?(socket), do: LiveRetroWeb.Endpoint.subscribe("cards")

    cards = Board.all_cards(board)

    {:ok, assign(socket, board: board, cards: cards, create_new_for: nil, editable: nil)}
  end

  def handle_event("add", type, socket) do
    type = String.to_existing_atom(type)

    {:noreply, assign(socket, create_new_for: type, editable: nil)}
  end

  def handle_event("create", %{"text" => text, "type" => type}, socket) do
    board = socket.assigns[:board]
    text = String.trim(text)
    type = String.to_existing_atom(type)
    card = Card.new(text: text, type: type)

    socket =
      socket
      |> assign(:create_new_for, nil)
      |> update(:cards, &add_card(board, &1, card))

    {:noreply, socket}
  end

  def handle_event("edit", id, socket) do
    {:noreply, assign(socket, editable: id, create_new_for: nil)}
  end

  def handle_event("update", %{"id" => id, "text" => text}, socket) do
    board = socket.assigns[:board]
    text = String.trim(text)

    socket =
      socket
      |> assign(:editable, nil)
      |> update(:cards, &update_card(board, &1, id, text))

    {:noreply, socket}
  end

  defp add_card(board, cards, %{id: id} = card) do
    cards = Map.put(cards, id, card)

    :ok = Board.add_or_update_card(board, card)

    cards
  end

  defp update_card(board, cards, id, text) do
    cards = Map.update!(cards, id, &%{&1 | text: text})
    card = Map.get(cards, id)

    :ok = Board.add_or_update_card(board, card)

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
