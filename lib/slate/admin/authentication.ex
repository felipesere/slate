defmodule Slate.Admin.Authentication do
  def init(opts) do

    config = Application.get_env(:slate, Slate.Admin.Authentication)
    user = configure(opts, config, :username)
    pwd = configure(opts, config, :password)
    paths = configure(opts, config, :exclude)
    [exclude: paths, username: user, password: pwd]
  end

  defp configure(options, config, key) do
    options
    |> Keyword.merge(config)
    |> Keyword.get(key)
    |> check(key)
  end

  defp check(nil, key), do: raise "Could not configure #{__MODULE__} because #{key} is missing"
  defp check(thing, _), do: thing

  def call(conn, [exclude: paths, username: user, password: pwd]) do
    if conn.request_path in paths do
      conn
    else
      auth_header = Plug.Conn.get_req_header(conn, "authorization")

      if auth_header == [] do
        deny(conn)
      else
        [username, password] = extract_credentials(auth_header)
        if username == user && password == pwd do
          conn
        else
          deny(conn)
        end
      end
    end
  end

  defp extract_credentials([auth_header]) do
    auth_header
    |> String.replace_prefix("Basic ", "")
    |> Base.decode64!
    |> String.split(":")
  end

  defp deny(conn) do
    conn
    |> Plug.Conn.send_resp(401, "Unauthorized")
    |> Plug.Conn.halt
  end
end
