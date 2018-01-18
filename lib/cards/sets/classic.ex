defmodule Cards.Sets.Classic do
  @moduledoc """
  Classic set of cards

  The classic set of cards consists of at least 52 cards, separated into 4 
  suits, each with 13 cards. Additionally, the set may contain a number of 
  *Joker* cards.

  A card in this set is represented by the following structure:

      %{suit: :diamond, value: 11, name: "Jack"}

  ## Implements
  `Cards.Set`
  """

  @behaviour Cards.Set

  @typedoc """
  Defines the structure of a `Card` in this set
  """
  @type t :: %{
          suit: atom,
          value: integer,
          name: String.t(),
          set: atom
        }

  @doc """
  Initialize a set of playing cards

  Returns a list of at least 52 playing cards. Based on options passed to this 
  function, there may be 0 or more *Joker* cards in the set as well.

  ## Params
  - `opts` these options can be used to configure the generation of the `Card` 
    set.
      - `jokers` the number of jokers to include in the set

  ## Examples

      iex> Cards.Sets.Classic.init(%{jokers: 3}) |> length
      55

  """
  @spec init(opts :: map) :: [t()]
  def init(%{jokers: jokers} = _opts) do
    generate_set(jokers)
  end

  @doc """
  Initialize a default set of playing cards

  Returns a list of 52 playing cards, without any *Joker* cards

  ## Examples

      iex> Cards.Sets.Classic.init() |> length
      52

  """
  @spec init() :: [t]
  def init do
    generate_set(0)
  end

  @doc """
  Determines if two cards in the set are equal

  Cards are determined to be equal if they are of the same suit and have the same value.

  ## Example
      iex> first = Cards.Sets.Classic.init() |> List.first()
      iex> Cards.Sets.Classic.equals?(first, %{suit: :spade, value: 1, name: "Ace"})
      true

  """
  def equals?(first, other) do
    display(first) === display(other)
  end

  @doc """
  Return a string representation of a card

  ## Example
      iex> Cards.Sets.Classic.init() |> List.first() |> Cards.Sets.Classic.display()
      "Ace of spades"

  """
  def display(card) do
    display(card, nil)
  end

  @doc """
  Return a string representation of a card

  Options passed to this function allow for customisation of the card representation.

  ## Example
      iex> Cards.Sets.Classic.init() |> List.first() |> Cards.Sets.Classic.display()
      "Ace of spades"

  """
  def display(card, _opts) do
    card.name <> " of " <> Atom.to_string(card.suit) <> "s"
  end

  @spec generate_set(jokers :: integer) :: [t]
  defp generate_set(jokers) do
    cards =
      Enum.flat_map([:spade, :heart, :diamond, :clover], fn suit ->
        Enum.map(1..13, &generate_card(suit, &1))
      end)

    cards =
      if jokers > 0 do
        cards ++ Enum.map(1..jokers, fn _val -> generate_card(:joker) end)
      else
        cards
      end

    cards
  end

  @spec generate_card(suit :: atom, value :: integer | nil) :: t
  defp generate_card(suit, value \\ 0) do
    %{suit: suit, value: value, name: value_name(value), set: __MODULE__}
  end

  @spec value_name(value :: integer) :: String.t()
  defp value_name(value) do
    case value do
      0 -> "Joker"
      1 -> "Ace"
      val when val in 2..10 -> Integer.to_string(value)
      11 -> "Jack"
      12 -> "Queen"
      13 -> "King"
      true -> ""
    end
  end
end
