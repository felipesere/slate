defmodule Slate.Admin.AuthenticationTest do
  use WebCase
  alias Slate.Admin.Authentication
  alias Slate.Admin.Credentials

  @username "Bob"
  @password "Foo"
  @basic_auth Base.encode64("#{@username}:#{@password}")

  setup do
    Credentials.set(username: @username, password: @password)
  end

  test "requires authentication headers" do
    conn = conn(:get, "/admin", "") |> add_session()

    result = Authentication.call(conn, [])

    assert result.halted
    assert Plug.Conn.get_resp_header(result, "x-redirect-reason") == ["auth-denied"]
  end

  test "allows authenticated acces" do
    conn = conn(:get, "/admin", "") |> add_session() |> put_req_header("authorization", "Basic #{@basic_auth}")
    result = Authentication.call(conn, [])

    refute result.halted
  end

  test "cookie is as good as authentication" do
    conn = conn(:get, "/admin", "")
           |> authenticated()

    result = Authentication.call(conn, [])

    refute result.halted
  end

  test "denies the wrong username/password combo" do
    Credentials.set(username: "Somebody", password: "Else")
    conn = conn(:get, "/admin", "")
           |> add_session()
           |> put_req_header("authorization", "Basic #{@basic_auth}")

    result = Authentication.call(conn, [])

    assert result.halted
    assert result.status == 302
    assert location(result) == "/admin/login"
  end

  test "can exclude certain paths" do
    conn = conn(:get, "/login", "")
    result = Authentication.call(conn, [exclude: ["/login"]])

    refute result.halted
  end
end
