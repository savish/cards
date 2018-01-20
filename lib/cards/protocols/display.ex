defprotocol Cards.Protocols.Display do
  @moduledoc """
  Functions concerned with the display of a `Card` struct.

  String representations of cards can be used to compare them with each other.
  """

  @doc """
  Displays a `Card` as a string

  As their structures are fully customizable, this protocol defines functions that allow for a 
  simple representation of a `Card` struct. Options can be provided to customise the display 
  further.
  """
  @spec display(struct, map) :: String.t()
  def display(card, opts \\ nil)
end

defimpl Cards.Protocols.Display, for: Any do
  def display(card, _opts), do: inspect(card)
end
