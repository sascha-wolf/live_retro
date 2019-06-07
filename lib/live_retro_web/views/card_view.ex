defmodule LiveRetroWeb.CardView do
  use LiveRetroWeb, :view

  defp color_for(:good), do: "green"
  defp color_for(:bad), do: "red"
  defp color_for(:action), do: "blue"
end
