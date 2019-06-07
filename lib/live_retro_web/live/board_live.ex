defmodule LiveRetroWeb.BoardLive do
  use Phoenix.LiveView

  def render(assigns) do
    LiveRetroWeb.BoardView.render("index.html", assigns)
  end

  def mount(cards, socket) do
    cards = Enum.group_by(cards, & &1[:id])

    {:ok, assign(socket, cards: cards, create_new_for: nil, editable: nil)}
  end

  def handle_event("add", type, socket) do
    type = String.to_existing_atom(type)

    {:noreply, assign(socket, create_new_for: type, editable: nil)}
  end

  def handle_event("create", %{"text" => text, "type" => type}, socket) do
    type = String.to_existing_atom(type)
    card = new_card(text: text, type: type)

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

  defp new_card(props) do
    Enum.into(props, %{
      id: UUID.uuid4(),
      created_at: NaiveDateTime.utc_now() |> NaiveDateTime.to_erl()
    })
  end

  defp add_card(cards, %{id: id} = card) do
    Map.put(cards, id, card)
  end

  defp update_card(cards, id, text) do
    Map.update!(cards, id, &%{&1 | text: text})
  end
end
