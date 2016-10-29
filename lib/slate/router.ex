defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder
  alias ExAws.S3

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug :match
  plug :dispatch

  @images %{
    1 => %Image{id: 1,
      image: "london.jpg",
      title: "London",
      subtitle: "March 1, 2015"},
    2 => %Gallery{id: 2,
      images: ["rocks.jpg", "beach.jpg", "waves.jpg", "outcropping.jpg"],
      title: "Madeira",
      subtitle: "March 16, 2015"},
    3 => %Image{id: 3,
      image: "spring.jpg",
      title: "Spring",
      subtitle: "April 4, 2016"},
    4 => %Gallery{id: 4,
      images: ["rocks.jpg", "beach.jpg", "waves.jpg", "outcropping.jpg"],
      title: "Tenerife",
      subtitle: "November 7, 2014"},
    5 => %Image{id: 5,
      image: "waves.jpg",
      title: "Waves",
      subtitle: "March 23, 2014"},
    6 => %Image{id: 6,
      image: "outcropping.jpg",
      title: "Outcropping",
      subtitle: "July 17, 2014"},
    7 => %Image{id: 7,
      image: "beach.jpg",
      title: "Beach",
      subtitle: "August 29, 2015"}
  }

  get "/" do
    render_template(conn, "index", [entities: Map.values(@images)])
  end

  get "/gallery" do
    render_template(conn, "gallery", [gallery: Map.fetch!(@images, 2)])
  end

  get "/gallery/:id" do
    {id, _} = Integer.parse(id)
    case Map.fetch(@images, id) do
      {:ok, gallery} -> View.within_layout("gallery", [gallery: gallery]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  get "/gallery-image" do
    render_template(conn, "gallery-image")
  end

  get "/index" do
    render_template(conn, "index", [entities: Map.values(@images)])
  end

  get "/solo-image" do
    render_template(conn, "solo-image")
  end

  def render_template(conn, name, assigns \\ []) do
    name
    |> View.within_layout(assigns)
    |> respond(conn)
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end
end
