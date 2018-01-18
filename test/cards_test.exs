defmodule CardsTest do
  use ExUnit.Case

  doctest Cards

  alias Cards.Deck

  test "can create a new, empty, named deck" do
    {:ok, name} = Cards.create_deck(:new_empty)
    assert name === :new_empty
    assert Deck.list_cards(name) |> length === 0
  end

  test "can create a new deck with cards" do
    {:ok, name} = Cards.create_deck(:new_full, [3, 4, 5])
    assert name === :new_full
    assert Deck.list_cards(name) |> length === 3
  end

  test "blocks attempts to create an existing deck" do
    {:ok, _} = Cards.create_deck(:existing)
    {:error, message} = Cards.create_deck(:existing)
    assert message === :deck_exists
  end

  test "can list active decks" do
    {:ok, _} = Cards.create_deck(:first)
    {:ok, _} = Cards.create_deck(:second)
    assert Cards.list_decks() |> length > 1
  end
end
