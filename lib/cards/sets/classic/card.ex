defmodule Cards.Sets.Classic.Card do
  @enforce_keys [:suit, :value, :name]
  defstruct [:suit, :value, :name]
end

defimpl Cards.Protocols.Display, for: Cards.Sets.Classic.Card do
  def display(card, _opts) do
    card.name <> " of " <> Atom.to_string(card.suit) <> "s"
  end
end
