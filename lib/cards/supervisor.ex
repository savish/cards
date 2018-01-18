defmodule Cards.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Registry, [keys: :unique, name: :deck_registry]},
      Cards.DeckSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
