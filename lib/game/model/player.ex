defmodule TueOfuroGame.Player do
  defstruct [:name, :color]

  def new(name, color) do
    %TueOfuroGame.Player{name: name, color: color}
  end
end
