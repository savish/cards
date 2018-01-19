defmodule Cards.Deck do
  @moduledoc """
  Deck of cards
  """

  use Agent, restart: :temporary, start: {__MODULE__, :create, []}

  @typedoc """
  The name assigned to a deck of cards
  """
  @type t :: String.t() | atom

  @deck_registry_name :deck_registry

  defp via_tuple(deck_name), do: {:via, Registry, {@deck_registry_name, deck_name}}

  @doc """
  Create a deck of cards
  """
  @spec create(t, list | nil) :: Agent.on_start()
  def create(name, cards \\ nil) do
    Agent.start_link(fn -> cards || [] end, name: via_tuple(name))
  end

  def create([], name, cards) do
    create(name, cards)
  end

  @doc """
  List all the cards in a deck
  """
  @spec list_cards(t) :: list
  def list_cards(deck) do
    Agent.get(via_tuple(deck), & &1)
  end

  @doc """
  Return the number of cards in the deck
  """
  @spec count(t) :: integer
  def count(deck) do
    deck |> list_cards |> length
  end

  @doc """
  Replace all the cards in a deck
  """
  def set_cards(deck, cards) do
    Agent.update(via_tuple(deck), fn _cards -> cards end)
  end

  @doc """
  Peek at the top cards on a deck
  """
  @spec peek_top(t, integer) :: {:ok, list} | {:error, String.t()}
  def peek_top(deck, number \\ 1) do
    cards = list_cards(deck)

    if length(cards) > 0 do
      {:ok, Enum.take(cards, number)}
    else
      {:error, "Can't peek into an empty deck"}
    end
  end

  @doc """
  Peek at the top cards on a deck
  """
  @spec peek_top!(t, integer) :: list
  def peek_top!(deck, number \\ 1) do
    case peek_top(deck, number) do
      {:ok, cards} -> cards
      {:error, message} -> raise message
    end
  end

  @doc """
  Draw cards from a deck

  ## Params
  - `deck` source deck
  - `number` number of cards to draw
  - `location` where to draw the cards from. There are 3 options for the 
    location:
      - `:top` - draw cards from the top of the deck
      - `:bottom` - draws cards from the bottom of the deck
      - `:random` - draws cards randomly from the deck

  ## Errors
  `{:error, :empty_deck}` - attempting to draw cards from an empty deck

  ## Examples
      iex> Cards.Decks.create_deck(:draw_top, [3,4,5])
      iex> Cards.Deck.draw_cards(:draw_top, 1)
      {:ok, [3]}
      iex> Cards.Deck.list_cards(:draw_top)
      [4, 5]

      iex> Cards.Decks.create_deck(:draw_bot, [3,4,5])
      iex> Cards.Deck.draw_cards(:draw_bot, 1, :bottom)
      {:ok, [5]}
      iex> Cards.Deck.list_cards(:draw_bot)
      [3, 4]

      iex> Cards.Decks.create_deck(:draw_random, [3,4,5,6])
      iex> {:ok, drawn} = Cards.Deck.draw_cards(:draw_random, 2, :random)
      iex> length(drawn)
      2
      iex> Cards.Deck.list_cards(:draw_random) |> length
      2

      iex> Cards.Decks.create_deck(:draw_empty, [])
      iex> Cards.Deck.draw_cards(:draw_empty)
      {:error, :empty_deck}

  """
  @spec draw_cards(t(), integer(), :top | :bottom | :random) :: {:ok, list()} | {:error, atom()}
  def draw_cards(deck, number \\ 1, location \\ :top)

  def draw_cards(deck, number, location) when location === :top do
    cards = list_cards(deck)

    if length(cards) > 0 do
      {drawn, remaining} = Enum.split(cards, number)
      set_cards(deck, remaining)
      {:ok, drawn}
    else
      {:error, :empty_deck}
    end
  end

  def draw_cards(deck, number, location) when location === :bottom do
    cards = list_cards(deck)

    if length(cards) > 0 do
      {remaining, drawn} = Enum.split(list_cards(deck), -1 * number)
      set_cards(deck, remaining)
      {:ok, drawn}
    else
      {:error, :empty_deck}
    end
  end

  def draw_cards(deck, number, location) when location === :random do
    cards = list_cards(deck)

    if length(cards) > 0 do
      {drawn, remaining} = draw_card(cards, number, [])
      set_cards(deck, remaining)
      {:ok, drawn}
    else
      {:error, :empty_deck}
    end
  end

  # Draw a single, random card from a list of cards
  defp draw_card(cards, number, drawn) do
    rand_index = :rand.uniform(length(cards)) - 1
    drawn = drawn ++ [Enum.at(cards, rand_index)]
    cards = List.delete_at(cards, rand_index)

    if number === 1 do
      {drawn, cards}
    else
      draw_card(cards, number - 1, drawn)
    end
  end

  @doc """
  Draw cards from a deck

  Similar to `draw_cards/3`, but raises an error on failure.
  """
  @spec draw_cards!(t(), integer(), :top | :bottom | :random) :: list()
  def draw_cards!(deck, number \\ 1, location \\ :top) do
    case draw_cards(deck, number, location) do
      {:ok, cards} -> cards
      {:error, message} -> raise message
    end
  end

  @doc """
  Take specific cards from a deck

  ## Examples
      iex> Cards.Decks.create_deck(:taken_cards, Cards.Sets.Classic.init())
      iex> top_card = Cards.Deck.peek_top!(:taken_cards) |> hd()
      iex> {:ok, taken} = Cards.Deck.take_cards(:taken_cards, [top_card])
      iex> taken_card = taken |> hd
      iex> Cards.Protocols.Display.display(taken_card)
      "Ace of spades"
      iex> Cards.Deck.list_cards(:taken_cards) |> length()
      51

  """
  def take_cards(deck, cards) do
    deck_cards = list_cards(deck)

    if length(deck_cards) === 0 do
      {:error, :empty_deck}
    else
      # TODO: Replace equality with protocol method
      indices = Enum.map(cards, fn card -> Enum.find_index(deck_cards, &(&1 === card)) end)
      taken_cards = Enum.map(indices, fn ix -> Enum.at(deck_cards, ix) end)
      deck_cards = Enum.reject(deck_cards, fn card -> card in taken_cards end)
      set_cards(deck, deck_cards)
      {:ok, taken_cards}
    end
  end

  @doc """
  Take specific cards from a deck

  Similar to `take_cards/2`, but raises an exception in the case of an error response.
  """
  def take_cards!(deck, cards) do
    case take_cards(deck, cards) do
      :ok -> :ok
      {:error, message} -> raise message
    end
  end

  @doc """
  Place cards onto / into a deck

  ## Params
  - `deck` destination deck
  - `cards` list of cards to place
  - `location` where to place the cards. There are 3 options for the location:
      - `:top` - place cards on the top of the deck
      - `:bottom` - place cards on the bottom of the deck
      - `:random` - insert cards randomly into the deck

  ## Examples
      iex> Cards.Decks.create_deck(:place_top, [3, 4, 5])
      iex> Cards.Deck.place_cards(:place_top, [2])
      :ok
      iex> Cards.Deck.list_cards(:place_top)
      [2, 3, 4, 5]

      iex> Cards.Decks.create_deck(:place_bot, [3, 4, 5])
      iex> Cards.Deck.place_cards(:place_bot, [6], :bottom)
      :ok
      iex> Cards.Deck.list_cards(:place_bot)
      [3, 4, 5, 6]

      iex> Cards.Decks.create_deck(:place_random, [3, 4, 5, 6])
      iex> Cards.Deck.place_cards(:place_random, [2, 7], :random)
      :ok
      iex> Cards.Deck.count(:place_random)
      6

  """
  def place_cards(deck, cards, location \\ :top)

  def place_cards(deck, cards, location) when location === :top do
    set_cards(deck, cards ++ list_cards(deck))
  end

  def place_cards(deck, cards, location) when location === :bottom do
    set_cards(deck, list_cards(deck) ++ cards)
  end

  def place_cards(deck, cards, location) when location === :random do
    set_cards(deck, place_card(list_cards(deck), cards))
  end

  defp place_card(deck_cards, cards) do
    if length(cards) === 1 do
      List.insert_at(deck_cards, :rand.uniform(length(deck_cards)) - 1, hd(cards))
    else
      deck_cards = List.insert_at(deck_cards, :rand.uniform(length(deck_cards)) - 1, hd(cards))
      place_card(deck_cards, tl(cards))
    end
  end

  @doc """
  Shuffles a deck of cards

  ## Example
      iex> Cards.Decks.create_deck(:shuffle)
      iex> Cards.Deck.shuffle(:shuffle)
      :ok

  """
  @spec shuffle(t()) :: :ok
  def shuffle(deck) do
    set_cards(deck, Enum.shuffle(list_cards(deck)))
    :ok
  end
end
