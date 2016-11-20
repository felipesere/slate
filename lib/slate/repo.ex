defmodule Repo do
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
      subtitle: "July 17, 2014",
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

    def all do
      @images
      |> Map.values
      |> Enum.map(fn(%Gallery{} = g) -> expand(g)
                    (x) -> x end)
    end

    def find(:none), do: :none
    def find(id) do
      case Integer.parse(id) do
        {entity_id, ""} -> Map.get(@images, entity_id, :none)
        _ -> :none
      end
    end

    def expand(gallery = %Gallery{images: image_ids}) do
      %{ gallery | images: Enum.map(image_ids, fn(id) -> Map.fetch!(@images, id) end)}
    end

    def gallery(id) do
      case Map.fetch(@images, id) do
        {:ok, %Gallery{} = gallery} -> {:ok, expand(gallery)}
        _ -> :not_found
      end
    end

    def image(id) do
      case Map.fetch(@images, id) do
        {:ok, %Image{} = image} -> {:ok, image}
        _ -> :not_found
      end
    end
end
