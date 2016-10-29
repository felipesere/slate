defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder
  alias ExAws.S3

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug :match
  plug :dispatch

  @images [%Image{image: "london.jpg",
                  title: "London",
                  subtitle: "March 1, 2015"},
           %Gallery{images: ["rocks.jpg", "beach.jpg", "waves.jpg", "outcropping.jpg"],
                    title: "Madeira",
                    subtitle: "March 16, 2015"},
           %Image{image: "spring.jpg",
                  title: "Spring",
                  subtitle: "April 4, 2016"},
           %Gallery{images: ["rocks.jpg", "beach.jpg", "waves.jpg", "outcropping.jpg"],
                    title: "Tenerife",
                    subtitle: "November 7, 2014"},
           %Image{image: "waves.jpg",
                  title: "Waves",
                  subtitle: "March 23, 2014"},
           %Image{image: "outcropping.jpg",
                  title: "Outcropping",
                  subtitle: "July 17, 2014"},
           %Image{image: "beach.jpg",
                  title: "Beach",
                  subtitle: "August 29, 2015"}
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
