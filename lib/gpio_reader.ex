defmodule GpioReader do
  @moduledoc """
  Feed some random data into the :gpio_state Agent as a placeholder
  """
  use GenServer

  @interval 1

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(state) do
    Process.send_after(self(), :work, @interval)
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Set pin 1 to a random value
    Agent.update(:gpio_state, &(Map.put(&1, 1, Enum.random([0,1]))))

    Process.send_after(self(), :work, @interval)
    {:noreply, state}
  end
end
