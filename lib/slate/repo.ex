defmodule Slate.Repo do

    def start_link(images \\ %{}) do
      Agent.start_link(fn -> images end, name: __MODULE__)
    end

    def clear() do
      Agent.update(__MODULE__, fn _ -> %{} end)
    end

    def create(%{id: id} = image) when not is_nil(id) do
      Agent.update(__MODULE__, fn state -> Map.put(state, id, image) end)
    end

    def create(image) do
      Agent.update(__MODULE__, fn state ->
        next = Enum.count(state) +1
        Map.put(state, next, %{image | id: next})
      end)
    end

    def all do
      Agent.get(__MODULE__, fn images ->
      images
      |> Map.values
      |> Enum.map(fn(%Gallery{} = g) -> expand(images, g)
                    (x) -> x end)
      end)
    end

    def find(:none), do: :none
    def find(id) do
      Agent.get(__MODULE__, fn images ->
        case Integer.parse(id) do
          {entity_id, ""} -> Map.get(images, entity_id, :none)
          _ -> :none
        end
      end)
    end

    def expand(images, gallery = %Gallery{images: image_ids}) do
      %{ gallery | images: Enum.map(image_ids, fn(id) -> Map.fetch!(images, id) end)}
    end

    def gallery(id) do
      Agent.get(__MODULE__, fn images ->
        case Map.fetch(images, id) do
          {:ok, %Gallery{} = gallery} -> {:ok, expand(images, gallery)}
          _ -> :not_found
        end
      end)
    end

    def image(id) do
      Agent.get(__MODULE__, fn images ->
        case Map.fetch(images, id) do
          {:ok, %Image{} = image} -> {:ok, image}
          _ -> :not_found
        end
      end)
    end
end
