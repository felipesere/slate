defmodule Slate.Admin.Router do
  use Plug.Router
  use Plug.Builder
  alias Slate.Catalog


  plug :put_secret_key_base
  def put_secret_key_base(conn, _) do
    put_in conn.secret_key_base, "2iSeS9fRD2JNnoIEWx5OvlGD1KNi5BUsdgB18CluqCnvCscIVvBh2LfEJyfWYtfs"
  end

  plug Plug.SSL, hsts: false
  plug Slate.Admin.ProtectedHost, host: "slate-blog.herokuapp.com"
  plug Plug.Session,
    store: :cookie,
    key: "_hello_phoenix_key",
    signing_salt: "Jk7pxAMf"

  plug Slate.Admin.Authentication, exclude: ["/admin/login"]
  plug :match
  plug :dispatch


  get "/login" do
    Admin.View.within_layout("login")
    |> respond(conn)
  end

  post "/login" do
    conn = conn |> fetch_query_params

    %{"username" => user, "password" => password} = conn.body_params

    if user == "Felipe" and password == "Sere" do
      conn
      |> Plug.Conn.fetch_session
      |> Plug.Conn.put_session(:authenticated, true)
      |> redirect(to: "/admin")
    else
      conn
      |> redirect(to: "/admin/login")
    end
  end

  get "/" do
    conn = fetch_query_params(conn)
    edited_entity = Map.get(conn.params, "entity", :none)
    "index"
    |> Admin.View.within_layout([entities: Catalog.all, edited_entity: Catalog.find!(edited_entity)])
    |> respond(conn)
  end

  #post "/gallery" do
  #  conn = fetch_query_params(conn)
  #  params = conn.params
  #  Catalog.create(%Image{ description: params["description"],
  #                      exif: params["extract_exif"],
  #                      title: params["title"],
  #                      date: params["when"]})

  #  redirect(conn, to: "/admin")
  #end

   def redirect(conn, [to: to]) do
    conn
    |> Plug.Conn.put_resp_header("location", to)
    |> Plug.Conn.resp(302, "")
    |> Plug.Conn.halt
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end
end
