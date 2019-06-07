defmodule LiveRetro.Board.Registry do
  use Supervisor

  alias LiveRetro.Board.Storage, as: Board

  @registry __MODULE__
  @supervisor __MODULE__.Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [])
  end

  @impl true
  def init(_) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: @supervisor},
      {Registry, keys: :unique, name: @registry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def new(board) do
    name = name_for(board)

    DynamicSupervisor.start_child(@supervisor, {Board, name})
  end

  def name_for(board), do: {:via, Registry, {@registry, board}}

  def lookup(board) do
    @registry
    |> Registry.lookup(board)
    |> case do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end
end
