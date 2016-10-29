defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder
  alias ExAws.S3

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug :match
  plug :dispatch

  @images [%Image{image: "london.jpg"},
           %Gallery{images: ["rocks.jpg", "beach.jpg", "waves.jpg", "outcropping.jpg"],
                    title: "Madeira",
                    subtitle: "March 16, 2015"},
           %Image{image: "spring.jpg"},
           %Gallery{images: ["rocks.jpg", "beach.jpg", "waves.jpg", "outcropping.jpg"],
                    title: "Tenerife",
                    subtitle: "November 7, 2014"},
           %Image{image: "waves.jpg"},
           %Image{image: "outcropping.jpg"},
           %Image{image: "beach.jpg"}
         ]

  get "/" do
    render_template(conn, "index", [entities: @images])
  end

  get "/gallery" do
    render_template(conn, "gallery")
  end

  get "/gallery-image" do
    render_template(conn, "gallery-image")
  end

  get "/index" do
    render_template(conn, "index", [entities: @images])
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
    send_resp(conn, 404, "oops")
  end
end
