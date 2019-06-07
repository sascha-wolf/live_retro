defmodule LiveRetroWeb.BoardView do
  use LiveRetroWeb, :view

  @column_names_by_type %{}

  defp column_types, do: [:good, :bad, :action]

  defp title_for(:good), do: "Went good 👍"
  defp title_for(:bad), do: "To improve 😩"
  defp title_for(:action), do: "Actions 😎"

  defp color_for(:good), do: "green"
  defp color_for(:bad), do: "red"
  defp color_for(:action), do: "blue"

  defp cards_for(type, from: cards_by_type), do: Map.get(cards_by_type, type, [])
end
