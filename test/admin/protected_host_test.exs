defmodule Slate.Admin.ProtectedHostTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Slate.Admin.ProtectedHost

  test "redirects if accessing on unsecure host" do
    conn = conn(:get, "/", "") |> put_req_header("host", "not.really.secure")

    conn = ProtectedHost.call(conn, host: "really.secure.com")

    assert conn.halted
    assert conn.status == 301
    assert Plug.Conn.get_resp_header(conn, "location") == ["really.secure.com"]
  end
end
