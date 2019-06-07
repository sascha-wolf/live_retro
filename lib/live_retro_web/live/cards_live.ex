defmodule LiveRetroWeb.CardsLive do
  use Phoenix.LiveView

  @max_grid_size 12
  @min_column_size 2

  def render(%{columns: columns} = assigns) do
    column_size =
      @max_grid_size
      |> div(length(columns))
      |> max(@min_column_size)

    ~L"""
    <div class="row">
      <%= for column <- @columns do %>
        <%=
          column
          |> Map.put(:column_size, column_size)
          |> render_column()
        %>
      <% end %>
    </div>
    """
  end

  defp render_column(assigns) do
    ~L"""
    <section>
      <div class="col s<%= @column_size %>">
        <h5><%= @title %></h5>

        <a class="btn waves-effect waves-light green"
           style="width: 100%"
           phx-click="add"
           phx-value="<%= @id %>">
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
      </div>
    </item>
    """
  end

  def mount(_session, socket) do
    columns = [
      %{
        id: "1",
        title: "First Row!",
        cards: [
          %{text: "Hello, I am a card!"},
          %{text: "Hello, I am a card!"}
        ]
      },
      %{
        id: "2",
        title: "Second Row!",
        cards: [
          %{text: "Hello, I am a card!"}
        ]
      },
      %{
        id: "3",
        title: "Third Row!",
        cards: [
          %{text: "Hello, I am a card!"}
        ]
      }
    ]

    {:ok, assign(socket, columns: columns)}
  end

  def handle_event("add", id, socket) do
    {:noreply, update(socket, :columns, &add_card_to_column(&1, id))}
  end

  defp add_card_to_column(columns, id) when is_list(columns) do
    Enum.map(columns, fn
      %{id: ^id, cards: cards} = col -> %{col | cards: [new_card() | cards]}
      other_col -> other_col
    end)
  end

  defp new_card do
    %{text: "I'm a new card"}
  end
end
