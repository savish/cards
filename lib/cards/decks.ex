defmodule Cards.Decks do
  @moduledoc """
  Manage card decks

  This module contains functionality concerned with the overall management of a `Deck`s lifecycle
  from creation to deletion.

  Functionality concerned with a single `Deck` lives in the `Cards.Deck` module.
  """
  use Supervisor

  alias Cards.Deck

  @deck_registry_name :deck_registry

  @doc false
  def start_link(_opts), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @doc """
  List the names of all active decks

  Each deck is identifiable by a _unique_ name.

  ## Examples

      iex> Cards.Decks.create_deck(:list_1)
      iex> Cards.Decks.create_deck(:list_2)
      iex> length(Cards.Decks.list_decks) > 1
      true
  """
  @spec list_decks :: list
  def list_decks do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, pid, _, _} -> @deck_registry_name |> Registry.keys(pid) |> List.first() end)
    |> Enum.sort()
  end

  @doc """
  Get or create a deck with the specified name

  If the deck already exists, it is returned as is. Otherwise a new deck is created and returned. 
  """
  @spec get_or_create_deck(Deck.t()) :: {:ok, Deck.t()} | {:error, term}
  def get_or_create_deck(name) do
    case create_deck(name) do
      {:error, {:already_started, _pid}} -> {:ok, name}
      other -> other
    end
  end

  @doc """
  Create a new deck

  If a list or cards is provided to the function, they will be used as the initial state of the 
  deck, otherwise it starts out empty.

  ## Errors
  `{:error, :deck_exists}` - prevents creating decks with duplicate names

  ## Examples

      iex> Cards.Decks.create_deck(:create)
      {:ok, :create}
      iex> Cards.Decks.create_deck(:create)
      {:error, :deck_exists}

  """
  @spec create_deck(Deck.t(), list) :: {:ok, Deck.t()} | {:error, term}
  def create_deck(name, cards \\ nil) do
    case Supervisor.start_child(__MODULE__, [name, cards]) do
      {:ok, _pid} -> {:ok, name}
      {:error, {:already_started, _pid}} -> {:error, :deck_exists}
      other -> {:error, other}
    end
  end

  @doc false
  def delete_deck(_name) do
    :unimplemented
  end

  @doc false
  def split_deck(_name, _into \\ 2) do
    :unimplemented
  end

  @doc false
  def init(:ok), do: Supervisor.init([Deck], strategy: :simple_one_for_one)
end
