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
        <div class="row">
          <div class="col s8">
            <h5><%= @title %></h5>
          </div>
        </div>

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
      <div class="card blue-grey darken-1">
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
        title: "First Row!",
        cards: [
          %{text: "Hello, I am a card!"}
        ]
      },
      %{
        title: "Second Row!",
        cards: [
          %{text: "Hello, I am a card!"}
        ]
      },
      %{
        title: "Third Row!",
        cards: [
          %{text: "Hello, I am a card!"}
        ]
      }
    ]

    {:ok, assign(socket, columns: columns)}
  end
end
