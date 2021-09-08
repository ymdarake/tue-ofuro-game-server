defmodule TueOfuroGame.GameServer do
  @moduledoc """
  A game server process that holds a `Game` struct as its state.
  """

  use GenServer

  require Logger

  @timeout :timer.minutes(30)

  # Client (Public) Interface

  @doc """
  Spawns a new game server process registered under the given `game_name`.
  """
  def start_link(game_name, size) do
    GenServer.start_link(
      __MODULE__,
      {game_name, size},
      name: via_tuple(game_name)
    )
  end

  def summary(game_name) do
    GenServer.call(via_tuple(game_name), :summary)
  end

  def mark(game_name, target_id, player) do
    GenServer.call(via_tuple(game_name), {:mark, target_id, player})
  end

  @doc """
  Returns a tuple used to register and lookup a game server process by name.
  """
  def via_tuple(game_name) do
    {:via, Registry, {TueOfuroGame.GameRegistry, game_name}}
  end

  @doc """
  Returns the `pid` of the game server process registered under the
  given `game_name`, or `nil` if no process is registered.
  """
  def game_pid(game_name) do
    game_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  # Server Callbacks

  def init({game_name, size}) do
    game =
      case :ets.lookup(:games_table, game_name) do
        [] ->
          game = TueOfuroGame.Game.new(size)
          :ets.insert(:games_table, {game_name, game})
          game

        [{^game_name, game}] ->
          game
      end

    Logger.info("Spawned game server process named '#{game_name}'.")

    {:ok, game, @timeout}
  end

  def handle_call(:summary, _from, game) do
    {:reply, summarize(game), game, @timeout}
  end

  def handle_call({:mark, target_id, player}, _from, game) do
    new_game = TueOfuroGame.Game.mark(game, target_id, player)

    :ets.insert(:games_table, {my_game_name(), new_game})

    {:reply, summarize(new_game), new_game, @timeout}
  end

  def summarize(game) do
    %{
      targets: game.targets,
      scores: game.scores,
      winner: game.winner
    }
  end

  def handle_info(:timeout, game) do
    {:stop, {:shutdown, :timeout}, game}
  end

  def terminate({:shutdown, :timeout}, _game) do
    :ets.delete(:games_table, my_game_name())
    :ok
  end

  def terminate(_reason, _game) do
    :ok
  end

  defp my_game_name do
    Registry.keys(TueOfuroGame.GameRegistry, self()) |> List.first()
  end
end
