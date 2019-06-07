defmodule LiveRetroWeb.BoardView do
  use LiveRetroWeb, :view

  @column_types [:good, :bad, :action]

  defp as_columns(cards) do
    grouped =
      cards
      |> Map.values()
      |> List.flatten()
      |> Enum.sort_by(&Map.get(&1, :created_at))
      |> Enum.group_by(&Map.get(&1, :type))

    for type <- @column_types do
      %{
        color: color_for(type),
        title: title_for(type),
        type: type,
        cards: grouped[type] || []
      }
    end
  end

  defp color_for(:good), do: "green"
  defp color_for(:bad), do: "red"
  defp color_for(:action), do: "blue"

  defp title_for(:good), do: "Went good 👍"
  defp title_for(:bad), do: "To improve 😩"
  defp title_for(:action), do: "Actions 😎"

  defp create_new?(nil, _column), do: false
  defp create_new?(expected, %{type: type}), do: type == expected

  defp render_new(for_type) do
    render("card-new.html", type: for_type)
  end

  defp render_card(%{editable: true} = card) do
    render("card-editable.html", card)
  end

  defp render_card(card), do: render("card.html", card)
end
