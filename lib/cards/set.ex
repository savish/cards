defmodule Cards.Set do
  @moduledoc """
  Defines a common set of behaviours for playing cards.

  Games based on playing cards expect the cards to be encoded with information
  relevant to the game. For instance, the classic playing card deck has cards
  with a suit and a value. A sample implementation of such a card might look 
  like:

      %{suit: :spade, value: 13, display: "K"}

  In the same vein, a playing card from the game _Dominion_ might be 
  represented by:

      %{type: treasure, name: gold, cost: 6, details: [value: 3]}

  Using this module, card games can define the structure of `Card`s they 
  require and provide an initial set from which decks can be drawn. 
  """

  @doc """
  Initialize a default set of cards

  This callback should return the full set of `Card`s required by a specific 
  card game. 
    
  """
  @callback init() :: list

  @doc """
  Initialize a set of cards

  This callback should return the full set of `Card`s required by a specific 
  card game. 

  ## Params
  - `opts` these parameters can be used to configure the generation of the 
    `Card` set. For instance, initializing a classic deck of cards might 
    require a parameter that determines how many jokers should be in the set, 
    if any.
    
  """
  @callback init(opts :: map) :: list
end
