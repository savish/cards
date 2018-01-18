defmodule Cards do
  @moduledoc """
  Playing cards management application
  """

  use Application

  alias Cards.Deck
  alias Cards.DeckSupervisor, as: Decks

  @doc false
  def start(_type, _args) do
    Cards.Supervisor.start_link(name: Cards.Supervisor)
  end

  ## API

  @doc """
  Create a new deck of cards.

  Each deck of cards is uniquely identified by a `name`, which can be a 
  `string` or an `atom`. If cards are assigned to a deck, they must be cards 
  generated from a module that implements the `Cards.Set` behaviour.

  Once a deck has been created it can be further modified using the functions 
  defined in the `Cards.Deck` module.

  ## Params 
  - `name` name assigned to the deck of cards
  - `cards` initial set of cards assigned to the deck

  An example of usage is given below:

      Cards.create_deck(:game, [:spade, :clover])
      {:ok, :game}
      Cards.create_deck(:game, [])
      {:error, :deck_exists}

  """
  @spec create_deck(Deck.t(), list) :: {:ok, Deck.t()} | {:error, term}
  def create_deck(name, cards \\ nil) do
    Decks.create_deck(name, cards)
  end

  def find_deck(name) do
    :unimplemented
  end

  @doc """
  List all active decks

  ## Examples

      Cards.create_deck(:new_game)
      {:ok, :new_game}
      Cards.create_deck(:old_game)
      {:ok, :old_game}
      Cards.list_decks()
      [:new_game, :old_game]

  """
  @spec list_decks() :: [Deck.t()]
  def list_decks do
    Decks.list_decks()
  end
end
