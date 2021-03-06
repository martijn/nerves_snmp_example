defmodule NervesSnmpExample.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi"

  def project do
    [app: :nerves_snmp_example,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],
     
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {NervesSnmpExample, []},
     applications: [:logger, :snmp]]
  end

  def deps do
    [{:nerves, "~> 0.4.0"}]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
