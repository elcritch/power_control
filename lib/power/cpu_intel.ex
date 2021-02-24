
defmodule PowerControl.CPU.Intel do

  def set_frequency_all(freq) when is_integer(freq) do
    {:ok, cpus} = PowerControl.list_cpus()

    governors =
      for cpu <- cpus, into: [] do
        {:ok, governor} = cpu |> PowerControl.get_cpu_governor()
        governor
      end
      |> Enum.uniq()

    unless governors == [:performance], do:
      raise "all governors must be set to 'performance' on Intel's to configure the frequency"

    for cpu <- cpus, into: %{} do
      {cpu, PowerControl.CPU.set_parameter(cpu, :scaling_max_freq, freq)}
    end
  end

end
