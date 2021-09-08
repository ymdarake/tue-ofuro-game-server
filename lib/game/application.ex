defmodule TueOfuroGame do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: TueOfuroGame.GameRegistry},
      TueOfuroGame.GameSupervisor
    ]

    :ets.new(:games_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: TueOfuroGame.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
