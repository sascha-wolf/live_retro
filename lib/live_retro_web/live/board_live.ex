defmodule LiveRetroWeb.BoardLive do
  use Phoenix.LiveView

  def render(assigns) do
    IO.inspect(assigns)
    LiveRetroWeb.BoardView.render("index.html", assigns)
  end

  def mount(cards, socket) do
    IO.puts("MOUNT")

    by_type = Enum.group_by(cards, & &1[:type])

    {:ok, assign(socket, cards_by_type: by_type)}
  end

  def handle_event("add", type, socket) do
    type = String.to_existing_atom(type)

    {:noreply, update(socket, :cards_by_type, &add_card(&1, type))}
  end

  defp add_card(cards_by_type, type) do
    card = new_card(type: type)

    Map.update(cards_by_type, type, [card], &[card | &1])
  end

  defp new_card(props) do
    Enum.into(props, %{
      id: UUID.uuid4(),
      text: "",
      editable: true
    })
  end
end
