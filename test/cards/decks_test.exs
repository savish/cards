defmodule Cards.DecksTest do
  use ExUnit.Case

  alias Cards.Deck

  doctest Cards.Decks

  test "can create a new, empty, named deck" do
    {:ok, name} = Cards.Decks.create_deck(:new_empty)
    assert name === :new_empty
    assert Deck.list_cards(name) |> length === 0
  end

  test "can create a new deck with cards" do
    {:ok, name} = Cards.Decks.create_deck(:new_full, [3, 4, 5])
    assert name === :new_full
    assert Deck.list_cards(name) |> length === 3
  end

  test "blocks attempts to create an existing deck" do
    {:ok, _} = Cards.Decks.create_deck(:existing)
    {:error, message} = Cards.Decks.create_deck(:existing)
    assert message === :deck_exists
  end

  test "can list active decks" do
    {:ok, _} = Cards.Decks.create_deck(:first)
    {:ok, _} = Cards.Decks.create_deck(:second)
    assert Cards.Decks.list_decks() |> length > 1
  end
end
