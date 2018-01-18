defmodule Cards.DeckSupervisor do
  @moduledoc false

  use Supervisor

  @deck_registry_name :deck_registry

  def start_link(_opts), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def create_deck(name, cards \\ nil) do
    case Supervisor.start_child(__MODULE__, [name, cards]) do
      {:ok, _pid} -> {:ok, name}
      {:error, {:already_started, _pid}} -> {:error, :deck_exists}
      other -> {:error, other}
    end
  end

  def list_decks do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, pid, _, _} ->
      Registry.keys(@deck_registry_name, pid)
      |> List.first()
    end)
    |> Enum.sort()
  end

  def init(:ok), do: Supervisor.init([Cards.Deck], strategy: :simple_one_for_one)
end
