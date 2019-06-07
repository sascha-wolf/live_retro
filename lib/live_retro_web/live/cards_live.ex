defmodule LiveRetroWeb.CardsLive do
  use Phoenix.LiveView

  def render(%{columns: columns} = assigns) do
    column_size = calculate_column_size(columns)

    ~L"""
    <div class="row">
      <%= for column <- @columns do %>
        <section>
          <div class="col s<%= column_size %>">
            <div class="row">
              <div class="col s8">
                <h5><%= column[:title] %></h5>

              </div>
            </div>

            <%= for card <- column[:cards] do %>
              <item>
                <div class="card blue-grey darken-1">
                  <div class="card-content white-text">
                    <%= card %>
                  </div>
                </div>
              </item>
            <% end %>
          </div>
        </section>
      <% end %>
    </div>
    """
  end

  defp calculate_column_size(columns) do
    12
    |> div(length(columns))
    |> max(2)
  end

  def mount(_session, socket) do
    columns = [
      %{
        title: "First Row!",
        cards: [
          "Hello, I am a card!"
        ]
      },
      %{
        title: "Second Row!",
        cards: [
          "Hello, I am a card!"
        ]
      },
      %{
        title: "Third Row!",
        cards: [
          "Hello, I am a card!"
        ]
      }
    ]

    {:ok, assign(socket, columns: columns)}
  end
end
