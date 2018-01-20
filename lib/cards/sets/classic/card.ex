defmodule Cards.Sets.Classic.Card do
  @moduledoc """
  Classic card

  Represents a card in the classic 52 playing card set.

  ## Keys
  - `suit` one of `:spade`, `:heart`, `:clover`, `:diamond` or `:joker`
  - `value` numerical value of the `Card` (defaults to 0)

  ## Implements
  `Cards.Protocols.Display`

      iex> alias Cards.Sets.Classic.Card
      iex> alias Cards.Protocols.Display
      iex> Display.display(%Card{suit: :spade, value: 11})
      "Jack of spades"

  `Cards.Protocols.Compare`

  For suit comparison, the order is `:spade`, `:heart`, `:diamond`,
  `:clover` and finally `:joker` (from highest to lowest)

      iex> alias Cards.Sets.Classic.Card
      iex> alias Cards.Protocols.Compare
      iex> #
      iex> cd1 = %Card{suit: :heart, value: 3}
      iex> cd2 = %Card{suit: :spade, value: 5}
      iex> cd3 = %Card{suit: :joker}
      iex> cd4 = %Card{suit: :heart, value: 13}
      iex> #
      iex> Compare.equal?(cd2, cd2)
      true
      iex> Compare.greater?(cd2, cd1)
      true
      iex> Compare.less?(cd1, cd3)
      false
      iex> Compare.greater_or_equal?(cd2, cd1)
      true
      iex> Compare.less_or_equal?(cd3, cd4)
      true

  See also:
  `Cards.Sets.Classic`
  """

  @enforce_keys [:suit]
  defstruct [:suit, value: 0]

  @typedoc """
  Classic card type
  """
  @type t :: %__MODULE__{suit: atom, value: integer}

  defimpl Cards.Protocols.Display do
    def display(card, _opts),
      do: value_name(card.value) <> " of " <> Atom.to_string(card.suit) <> "s"

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

  defimpl Cards.Protocols.Compare, for: Cards.Sets.Classic.Card do
    @suit_order [:spade, :heart, :diamond, :clover, :joker]

    def equal?(card, other), do: card.suit === other.suit and card.value === other.value
    def greater?(card, other), do: suit_comp(card, other) > 0 and card.value > other.value
    def less?(card, other), do: suit_comp(card, other) < 0 and card.value < other.value

    def greater_or_equal?(card, other),
      do: suit_comp(card, other) >= 0 and card.value >= other.value

    def less_or_equal?(card, other), do: suit_comp(card, other) <= 0 and card.value <= other.value

    # Comparing suits will return a number. A + number indicates greater than.
    defp suit_comp(card, other) do
      Enum.find_index(@suit_order, &(&1 === other.suit)) -
        Enum.find_index(@suit_order, &(&1 === card.suit))
    end
  end
end
