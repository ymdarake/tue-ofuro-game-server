defmodule TueOfuroGame.GameStateChecker do
  def completed?(game) do
    Enum.all?(game.targets, fn target ->
      !is_nil(target.marked_by)
    end)
  end
end
