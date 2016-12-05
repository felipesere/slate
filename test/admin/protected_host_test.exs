defmodule Slate.Admin.ProtectedHostTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Slate.Admin.ProtectedHost

  test "pass-through for the right host" do
    conn = conn(:get, "/", "") |> put_req_header("host", "really.secure.com")

    conn = ProtectedHost.call(conn, host: "really.secure.com")

    refute conn.halted
  end

  test "keeps any path params" do
    conn = conn(:get, "/foo", "") |> put_req_header("host", "not.really.secure.com")

    conn = ProtectedHost.call(conn, host: "really.secure.com")

    assert conn.status == 302
    assert Plug.Conn.get_resp_header(conn, "location") == ["http://really.secure.com/foo"]
    assert conn.halted
  end

  test "redirects if accessing on unsecure host" do
    conn = conn(:get, "/", "") |> put_req_header("host", "not.really.secure")

    conn = ProtectedHost.call(conn, host: "really.secure.com")

    assert conn.halted
    assert conn.status == 302
    assert Plug.Conn.get_resp_header(conn, "location") == ["http://really.secure.com/"]
  end
end
