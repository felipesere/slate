defmodule Slate.Admin.Router do
  use Web
  use Plug.Router
  use Plug.Builder
  alias Slate.Catalog


  plug :put_secret_key_base
  def put_secret_key_base(conn, _) do
    put_in conn.secret_key_base, "2iSeS9fRD2JNnoIEWx5OvlGD1KNi5BUsdgB18CluqCnvCscIVvBh2LfEJyfWYtfs"
  end

  if Mix.env == :prod do
    plug Slate.Admin.ProtectedHost, host: "slate-blog.herokuapp.com", scheme: "https"
  end

  if Mix.env != :test do
    plug Plug.Session,
    store: :cookie,
    key: "_hello_phoenix_key",
    signing_salt: "Jk7pxAMf"

    plug Slate.Admin.Authentication, exclude: ["/admin/login"]
  end

  plug :match
  plug :dispatch

  forward "/login", to: Slate.Admin.Login

  get "/" do
    conn = fetch_query_params(conn)
    edited_entity = Map.get(conn.params, "entity", :none)

    "index"
    |> Admin.View.within_layout([entities: Catalog.all, edited_entity: Catalog.find!(edited_entity)])
    |> respond(conn)
  end

  post "/gallery" do
    conn = fetch_query_params(conn)
    params = conn.params |> clean()


    Catalog.update_image(params["id"], params)

    redirect(conn, to: "/admin")
  end

  defp clean(%{"date" => date} = params) when is_list(date) do
    %{ params | "date" => Date.from_iso8601!(date) }
  end
  defp clean(x), do: x

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end
end
