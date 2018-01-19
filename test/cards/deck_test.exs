defmodule Cards.DeckTest do
  use ExUnit.Case
  doctest Cards.Deck

  alias Cards.Deck

  test "shuffling a deck always returns a new order for the deck" do
    Cards.Decks.create_deck(:shuffle_deck, [1, 2, 3, 4, 5])
    pre_suffle = Deck.list_cards(:shuffle_deck)
    Deck.shuffle(:shuffle_deck)
    post_shuffle = Deck.list_cards(:shuffle_deck)

    assert Enum.zip([pre_suffle, post_shuffle])
           |> Enum.reduce(0, fn {a, b}, acc -> acc + :math.pow(a - b, 2) end) != 0.0
  end
end
