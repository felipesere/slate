defmodule Slate.Admin.Credentials do
  def start_link(opts \\ []) do
    config = Application.get_env(:slate, Slate.Admin.Authentication)
    user = read(opts, config, :username)
    password = read(opts, config, :password)

    Agent.start_link(fn -> %{username: user, password: password} end, name: __MODULE__)
  end

  defp read(opts, config, key) do
    config
    |> Keyword.merge(opts)
    |> Keyword.get(key)
    |> verify(key)
  end

  defp verify(nil, key), do: raise "Could not configure #{__MODULE__} because #{key} is missing"
  defp verify(thing, _), do: thing

  def check(username, password) do
    Agent.get(__MODULE__, fn %{username: u, password: p} ->
      u == username && p == password
    end)
  end

  def set([username: user, password: pass]) do
    Agent.update(__MODULE__, fn _ -> 
      %{username: user, password: pass}
    end)
  end
end
