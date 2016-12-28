defmodule Slate.Admin.Router do
  use Web
  use Plug.Router
  use Plug.Builder
  alias Slate.Catalog
  use Slate.Admin.Security

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

  match _ do
    not_found(conn)
  end
end
