defmodule LiveRetro.Board.Card do
  defstruct [:id, :text, :type, :created_at]

  def new(props \\ []) do
    props =
      Keyword.merge(props,
        id: UUID.uuid4(),
        created_at: NaiveDateTime.utc_now() |> NaiveDateTime.to_erl()
      )

    struct(__MODULE__, props)
  end
end
