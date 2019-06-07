defmodule LiveRetroWeb.CardsLive do
  use Phoenix.LiveView

  @column_order [:good, :bad, :action]
  @column_names_by_type %{
    good: "Went good 👍",
    bad: "To improve 😩",
    action: "Actions 😎"
  }

  def render(assigns) do
    ~L"""
    <div class="row">
      <%= for column <- as_columns(@cards) do %>
        <%= render_column(column) %>
      <% end %>
    </div>
    """
  end

  defp as_columns(cards) do
    grouped = Enum.group_by(cards, &Map.get(&1, :type))

    for type <- @column_order do
      %{
        title: @column_names_by_type[type],
        type: type,
        cards: grouped[type]
      }
    end
  end

  defp render_column(assigns) do
    ~L"""
    <section>
      <div class="col s4">
        <h5><%= @title %></h5>

        <a class="btn waves-effect waves-light green"
           style="width: 100%"
           phx-click="add"
           phx-value="<%= @type %>">
          Add Card
        </a>

        <%= for card <- @cards do %>
          <%= render_card(card) %>
        <% end %>
      </div>
    </section>
    """
  end

  defp render_card(assigns) do
    ~L"""
    <item>
      <div class="card blue darken-1">
        <div class="card-content white-text">
          <%= @text %>
        </div>

        <div class="card-action">
          <a href="#" phx-click="edit" phx-value="<%= @id %>">
            Edit
          </a>
        </div>
      </div>
    </item>
    """
  end

  def mount(_session, socket) do
    cards = [
      new_card(type: :good),
      new_card(type: :bad),
      new_card(type: :action)
    ]

    {:ok, assign(socket, cards: cards)}
  end

  defp new_card(props) do
    Enum.into(props, %{
      id: UUID.uuid4(),
      text: "I'm a new card"
    })
  end

  def handle_event("add", type, socket) do
    type = String.to_existing_atom(type)

    {:noreply, update(socket, :cards, &[new_card(type: type) | &1])}
  end

  def handle_event("edit", _id, socket) do
    {:noreply, socket}
  end
end
