defmodule TueOfuroGameTest do
  use ExUnit.Case
  doctest TueOfuroGame

  require Logger

  # TODO:
  test "runs a game" do
    TueOfuroGame.GameSever.start_link("test-game", 10)
    gyo = TueOfuroGame.Player.new("Gyo", "orange")
    summary = TueOfuroGame.GameServer.mark("test-game", 4, gyo)
    Logger.info(summary)
  end
end
