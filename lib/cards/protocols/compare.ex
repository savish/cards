defprotocol Cards.Protocols.Compare do
  @moduledoc """
  Functions concerned with the comparison of two cards

  The structure of a card is left up to the implementing client. However, a number of methods 
  defined on the `Cards.Deck` module are dependent on the comparison of card values. The 
  functions necessary for these comparisons are defined here and can be implemented as required
  """

  @doc """
  Return `true` if both `Card`s are equivalent, `false` otherwise
  """
  @spec equal?(card :: struct, other :: struct) :: boolean
  def equal?(card, other)

  @doc """
  Return `true` if the first `Card` is greater than the other, otherwise `false`
  """
  @spec greater?(card :: struct, other :: struct) :: boolean
  def greater?(card, other)

  @doc """
  Return `true` if the first `Card` is less than the other, `false` otherwise
  """
  @spec less?(card :: struct, other :: struct) :: boolean
  def less?(card, other)

  @doc """
  Return `true` if the first `Card` is greater than or equal to the other, else `false`
  """
  @spec greater_or_equal?(card :: struct, other :: struct) :: boolean
  def greater_or_equal?(card, other)

  @doc """
  Return `true` if the first `Card` is less than or equal to the other, else `false`
  """
  @spec less_or_equal?(card :: struct, other :: struct) :: boolean
  def less_or_equal?(card, other)
end

defimpl Cards.Protocols.Compare, for: Any do
  def equal?(card, other), do: card === other
  def greater?(card, other), do: card > other
  def less?(card, other), do: card < other
  def greater_or_equal?(card, other), do: card >= other
  def less_or_equal?(card, other), do: card <= other
end
