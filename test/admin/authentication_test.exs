defmodule Slate.Admin.AuthenticationTest do
  use WebCase
  alias Slate.Admin.Authentication

  @username "Bob"
  @password "Foo"
  @basic_auth Base.encode64("#{@username}:#{@password}")

  test "requires authentication headers" do
    conn = conn(:get, "/admin", "") |> add_session()

    result = Authentication.call(conn, [exclude: [], username: @username, password: @password])

    assert result.halted
  end

  test "allows authenticated acces" do
    conn = conn(:get, "/admin", "")
           |> add_session()
           |> put_req_header("authorization", "Basic #{@basic_auth}")
    result = Authentication.call(conn, [exclude: [], username: @username, password: @password])

    refute result.halted
  end

  test "cookie is as good as authentication" do
    conn = conn(:get, "/admin", "")
           |> authenticated()

    result = Authentication.call(conn, [exclude: [], username: @username, password: @password])

    refute result.halted
  end

  test "denies the wrong username/password combo" do
    conn = conn(:get, "/admin", "")
           |> add_session()
           |> put_req_header("authorization", "Basic #{@basic_auth}")

    result = Authentication.call(conn, [exclude: [], username: "Somebody", password: "Else"])

    assert result.halted
    assert result.status == 302
    assert location(result) == "/admin/login"
  end

  test "can exclude certain paths" do
    conn = conn(:get, "/login", "")
    result = Authentication.call(conn, [exclude: ["/login"], username: @username, password: @password])

    refute result.halted
  end
end
