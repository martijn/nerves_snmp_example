defmodule NervesSnmpExample do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def my_name(:get) do
    {:value, 'Martijn'}
  end

  def gpio_value(:get) do
    {:value, Agent.get(:gpio_state, &(&1[1] || 0))}
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    [ok: _] = Enum.map(['./snmp/mib/NERVES-EXAMPLE-MIB'], &(:snmpc.compile(&1)))
    :ok = :snmpa.load_mibs(:snmp_master_agent, ['NERVES-EXAMPLE-MIB'])

    # Define workers and child supervisors to be supervised
    children = [
      worker(Agent, [fn -> %{} end, [name: :gpio_state]]),
      worker(GpioReader, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NervesSnmpExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
