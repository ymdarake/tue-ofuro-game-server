defmodule TueOfuroGame.Game do
  @enforce_keys [:targets]
  defstruct targets: nil, scores: %{}, winner: nil

  alias TueOfuroGame.{Game, Target}

  @doc """
  Creates a game with a `size` x `size` collection of squares
  taken randomly from the given list of `buzzwords` where
  each buzzword is of the form `%{phrase: "Upsell", points: 10}`.
  """
  def new() do
    %Game{targets: Target.generate(10)}
  end

  def generate_targets() do
  end

  def mark(game, target_id, player) do
    game
    |> update_target(target_id, player)
    |> update_scores()
    |> assign_winner_if_completed(player)
  end

  def update_target(game, target_id, player) do
    new_targets =
      game.targets
      |> Enum.map(fn target ->
        case target.id == target_id do
          true -> %Target{target | marked_by: player}
          false -> target
        end
      end)

    %{game | targets: new_targets}
  end

  def update_scores(game) do
    scores =
      game.targets
      |> Enum.reject(&is_nil(&1.marked_by))
      |> Enum.map(fn s -> {s.marked_by.name, s.points} end)
      |> Enum.reduce(%{}, fn {name, points}, scores ->
        Map.update(scores, name, points, &(&1 + points))
      end)

    %{game | scores: scores}
  end

  def assign_winner_if_completed(game, player) do
    case TueOfuroGame.GameStateChecker.completed?(game) do
      true -> %{game | winner: player}
      false -> game
    end
  end
end
