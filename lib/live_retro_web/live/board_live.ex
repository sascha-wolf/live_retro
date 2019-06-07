defmodule LiveRetroWeb.BoardLive do
  use Phoenix.LiveView

  def render(assigns) do
    LiveRetroWeb.BoardView.render("index.html", assigns)
  end

  def mount(cards, socket) do
    cards = Enum.group_by(cards, & &1[:id])

    {:ok, assign(socket, cards: cards, create_new_for: nil)}
  end

  def handle_event("add", type, socket) do
    type = String.to_existing_atom(type)

    {:noreply, assign(socket, :create_new_for, type)}
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

  # def handle_event("edit", id, socket) do
  #   {:noreply, assign(socket, :editable, true)}
  # end

  # def handle_event("update", %{"text" => text}, socket) do
  #   {:noreply, assign(socket, text: text, editable: false)}
  # end

  defp new_card(props) do
    Enum.into(props, %{
      id: UUID.uuid4(),
      created_at: NaiveDateTime.utc_now() |> NaiveDateTime.to_erl()
    })
  end

  defp add_card(cards_by_type, card) do
    Map.update(cards_by_type, card[:type], [card], &[card | &1])
  end
end
