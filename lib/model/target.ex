defmodule TueOfuroGame.Target do
  defstruct [:id, :points, :marked_by]

  def generate(size) when is_integer(size) do
    Enum.to_list(1..size)
    |> Enum.map(fn id ->
      %TueOfuroGame.Target{id: id, points: :rand.uniform(5)}
    end)
  end
end
