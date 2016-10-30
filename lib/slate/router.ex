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
    3 => %Image{id: 3,
      image: "spring.jpg",
      title: "Spring",
      subtitle: "April 4, 2016"},
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
      subtitle: "August 29, 2015"},
    8 => %Image{id: 8,
      image: "rocks.jpg",
      title: "Rocks",
      subtitle: "August 31, 2014"},
    2 => %Gallery{id: 2,
      images: [8, 7, 5, 6],
      title: "Madeira",
      subtitle: "March 16, 2015"},
    4 => %Gallery{id: 4,
      images: [8, 7, 5, 6],
      title: "Tenerife",
      subtitle: "November 7, 2014"}
    }

  get "/" do
    all = Enum.map(Map.values(@images),
                   fn(%Gallery{} = g) -> expand(g)
                      (x) -> x end)

    render_template(conn, "index", [entities: all])
  end

  def expand(gallery = %Gallery{images: image_ids}) do
    %{ gallery | images: Enum.map(image_ids, fn(id) -> Map.fetch!(@images, id) end)}
  end

  get "/gallery/:id" do
    {id, _} = Integer.parse(id)
    case Map.fetch(@images, id) do
      {:ok, gallery} -> View.within_layout("gallery", [gallery: expand(gallery)]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  get "/solo-image/:id" do
    {id, _} = Integer.parse(id)
    case Map.fetch(@images, id) do
      {:ok, image} -> View.within_layout("solo-image", [image: image]) |> respond(conn)
      _ -> not_found(conn)
    end
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
