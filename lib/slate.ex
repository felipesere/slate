defmodule Slate do
  use Application

  @images %{
    1 => %Image{id: 1,
      image: "london.jpg",
      title: "London",
      date: ~D[2015-03-01],
      subtitle: "March 1, 2015"},
    3 => %Image{id: 3,
      image: "spring.jpg",
      title: "Spring",
      date: ~D[2016-04-04],
      subtitle: "April 4, 2016"},
    5 => %Image{id: 5,
      image: "waves.jpg",
      title: "Waves",
      date: ~D[2014-03-23],
      subtitle: "March 23, 2014"},
    6 => %Image{id: 6,
      image: "outcropping.jpg",
      title: "Outcropping",
      subtitle: "July 17, 2014",
      date: ~D[2014-07-17],
      description: "This pictures was shot very early in the morning on the other side of Madeira from where we were staying. I like how the large rock looks as if were standing calmly almost proudly over the water. The clouds help in giving the entire scene a heroic atmosphere.",
      exif: %Exif{aperture: 11,
                  camera: "Canon EOS 70D",
                  focal_length: 10,
                  iso: 100,
                  shutter_speed: "30s"
                }

    },
    7 => %Image{id: 7,
      image: "beach.jpg",
      title: "Beach",
      date: ~D[2015-08-29],
      subtitle: "August 29, 2015"},
    8 => %Image{id: 8,
      image: "rocks.jpg",
      title: "Rocks",
      date: ~D[2014-08-31],
      subtitle: "August 31, 2014"},
    2 => %Gallery{id: 2,
      images: [8, 7, 5, 6],
      title: "Madeira",
      date: ~D[2015-03-16],
      subtitle: "March 16, 2015"},
    4 => %Gallery{id: 4,
      images: [8, 7, 5, 6],
      title: "Tenerife",
      date: ~D[2015-11-07],
      subtitle: "November 7, 2014"}
    }

  def start(_type, _args) do
    IO.puts "Starting..."
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Slate.Router, [], [port: port()]),
      worker(Slate.Repo, [@images]),
      worker(Slate.Catalog, [])
    ]

    opts = [strategy: :one_for_one, name: Slate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def port do
    case System.get_env("PORT") do
      nil -> 4000
      x -> Integer.parse(x) |> elem(0)
    end
  end
end
