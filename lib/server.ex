defmodule TueOfuroGame.Server do
  use Application
  require Logger

  def start(_start_type, _start_args) do
    dispatch =
      :cowboy_router.compile([
        {:_,
         [
           {"/websocket", TueOfuroGame.WebsocketHandler, []}
         ]}
      ])

    Logger.info("Started listening on port $port...")

    :cowboy.start_clear(:http_listener, [{:port, 5984}], %{env: %{dispatch: dispatch}})
  end

  def stop(_state) do
    :ok
  end
end
