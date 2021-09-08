defmodule TueOfuroGame.WebsocketHandler do
  @moduledoc """
  TueOfuroGame.WebsocketHandler
  """

  @idle_timeout_milliseconds 120000 # 2 min
  @tick_interval_milliseconds 1000 # 1 sec

  require Logger

  def init(req, state) do
    opts = %{idle_timeout: @idle_timeout_milliseconds}

    {:cowboy_websocket, req, state, opts}
  end

  def websocket_init(state) do
    Logger.info("websocket_init.")

    Registry.register(:client_registry, :clients, [])
    Process.send_after(self(), {:tick, self()}, @tick_interval_milliseconds)

    {:ok, state}
  end

  def websocket_info({:broadcast, message}, state) do
    {:reply, {:text, message}, state}
  end

  def websocket_info({:tick, pid}, state) do
    Process.send_after(pid, {:tick, pid}, @tick_interval_milliseconds)
    {:reply, {:text, "tick"}, state}
  end

  def websocket_handle({:text, "to:all:" <> message}, state) do
    broadcast(message)
    {:ok, state}
  end

  def websocket_handle({:text, message}, state) do
    {:reply, {:text, message}, state}
  end


  def websocket_handle(_data, state) do
    {:ok, state}
  end

  def terminate(_reason, _req, _state) do
    Logger.info("terminated")
    :ok
  end


  def broadcast(message) do
    Registry.dispatch(:client_registry, :clients, fn entries ->
      for {pid, _} <- entries do
        send(pid, {:broadcast, message})
      end
    end)
  end
end
