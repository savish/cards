defprotocol Cards.Protocols.Display do
  @doc """
  Displays a `Card` as a string

  Allows for customisation of the display via options
  """
  def display(card, opts \\ nil)
end

defimpl Cards.Protocols.Display, for: Any do
  def display(card, _opts), do: inspect(card)
end
