defmodule Slate.Admin.AuthenticationTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Slate.Admin.Authentication

  @username "Bob"
  @password "Foo"
  @basic_auth Base.encode64("#{@username}:#{@password}")

  test "requires authentication headers" do
    conn = conn(:get, "/admin", "")
    result = Authentication.call(conn, [exclude: [], username: @username, password: @password])

    assert result.halted
  end

  test "allows authenticated acces" do
    conn = conn(:get, "/admin", "") |> put_req_header("authorization", "Basic #{@basic_auth}")
    result = Authentication.call(conn, [exclude: [], username: @username, password: @password])

    refute result.halted
  end

  test "denies the wrong username/password combo" do
    conn = conn(:get, "/admin", "") |> put_req_header("authorization", "Basic #{@basic_auth}")
    result = Authentication.call(conn, [exclude: [], username: "Somebody", password: "Else"])

    assert result.halted
    assert result.status == 401
  end

  test "can exclude certain paths" do
    conn = conn(:get, "/login", "")
    result = Authentication.call(conn, [exclude: ["/login"], username: @username, password: @password])

    refute result.halted
  end
end
