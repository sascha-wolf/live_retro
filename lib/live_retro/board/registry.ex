defmodule LiveRetro.Board.Registry do
  @registry __MODULE__

  def child_spec([]) do
    %{
      id: @registry,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def start_link do
    Registry.start_link(keys: :unique, name: @registry)
  end

  def new(board) do
    {:ok, pid} = LiveRetro.Board.Storage.start_link(name_for(board))
  end

  def lookup(board) do
    name = name_for(board)

    @registry
    |> Registry.lookup(name)
    |> case do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end

  def name_for(board), do: {:via, Registry, {@registry, board}}
end
