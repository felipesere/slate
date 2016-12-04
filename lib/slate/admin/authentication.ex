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
    if needs_no_auth?(conn, paths) || has_cookie?(conn) || has_header_auth?(conn, user, pwd) do
      conn
    else
      deny(conn)
    end
  end

  defp needs_no_auth?(conn, paths), do: conn.request_path in paths

  defp has_cookie?(conn) do
    conn
    |> Plug.Conn.fetch_session
    |> Plug.Conn.get_session(:authenticated)
  end

  defp has_header_auth?(conn, user, pwd) do
    with [auth_header] <- Plug.Conn.get_req_header(conn, "authorization"),
         [username, password] <- extract_credentials(auth_header),
         matching <- username == user && password == pwd
         do 
           matching
    else
      _ -> false
    end
  end

  defp extract_credentials(auth_header) do
    auth_header
    |> String.replace_prefix("Basic ", "")
    |> Base.decode64!
    |> String.split(":")
  end

  defp deny(conn) do
    conn
    |> Plug.Conn.put_resp_header("location", "/admin/login")
    |> Plug.Conn.send_resp(302, "Unauthorized")
    |> Plug.Conn.halt
  end
end
