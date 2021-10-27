defmodule TueOfuroGame.Server do
  use Application
  require Logger

  # TODO: interact with the GameServer
  def start(_start_type, _start_args) do
    dispatch =
      :cowboy_router.compile([
        {:_,
         [
           {"/websocket", TueOfuroGame.WebsocketHandler, []}
         ]}
      ])

    {port, _} =
      System.get_env("PORT", "8888")
      |> Integer.parse()

    Logger.info("start listening on port " <> Integer.to_string(port))

    :cowboy.start_clear(:http_listener, [{:port, port}], %{env: %{dispatch: dispatch}})
  end

  def stop(_state) do
    :ok
  end
end
