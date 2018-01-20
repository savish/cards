defmodule Cards do
  @moduledoc """
  Playing cards

  Create sets of playing cards that can be managed and used in any game that requires them. An 
  example of a set of cards (classic 52+ card set) is included in the `Cards.Sets.Classic` module
  """

  use Application

  @doc false
  def start(_type, _args) do
    Cards.Supervisor.start_link(name: Cards.Supervisor)
  end
end
