defmodule TueOfuroGame.Application do
  use Application

  def start(_start_type, _start_args) do
    children = [
      %{
        id: TueOfuroGame.Server,
        start: {TueOfuroGame.Server, :start, [[], []]}
      },
      {Registry, keys: :duplicate, name: :client_registry}
    ]

    opts = [strategy: :one_for_one, name: TueOfuroGame.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
