defmodule Cards do
  @moduledoc """
  Playing cards management application
  """
  use Application

  @doc false
  def start(_type, _args) do
    Cards.Supervisor.start_link(name: Cards.Supervisor)
  end
end
