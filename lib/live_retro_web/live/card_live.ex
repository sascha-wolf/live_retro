defmodule LiveRetroWeb.CardLive do
  use Phoenix.LiveView

  alias LiveRetroWeb.CardView

  def render(%{editable: true} = assigns) do
    CardView.render("editable.html", assigns)
  end

  def render(assigns) do
    CardView.render("card.html", assigns)
  end

  def mount(card, socket) do
    IO.inspect(card)

    {:ok, assign(socket, card)}
  end

  def handle_event("edit", id, socket) do
    {:noreply, assign(socket, :editable, true)}
  end

  def handle_event("update", %{"text" => text}, socket) do
    {:noreply, assign(socket, text: text, editable: false)}
  end
end
