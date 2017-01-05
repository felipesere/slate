defmodule Slate.Catalog do
  use Ecto.Repo, otp_app: :slate
  import Ecto.Query, only: [from: 2]

  def find(:none), do: :none
  def find(id) do
    case image(id) do
      :none -> gallery(id)
      entity -> entity
    end
  end
  def find!(id) do
    case find(id) do
      {:ok, entity} -> entity
      _ -> :none
    end
  end

  def update_image(id, changes) do
    {:ok, image} = image(id)
    image
    |> Ecto.Changeset.cast(changes, [:title, :description, :subtitle, :image, :date])
    |> update!()
    |> convert()
  end

  def gallery(id) do
    one(from g in Gallery, where: g.id == ^id, preload: [:images]) |> convert
  end

  def image(id) do
    one(from i in Image, where: i.id == ^id) |> convert
  end

  def all, do: all_galleries() ++ all_images()

  defp all_galleries(), do: all(from g in Gallery, preload: [:images])

  defp all_images(), do: all(from i in Image, where: is_nil(i.gallery_id))

  def create(_), do: :not_implemented

  defp convert(nil), do: :none
  defp convert(%{date: %Ecto.Date{} = date} = entity) do
    {:ok, %{ entity | date: date |> Ecto.Date.to_erl |> Date.from_erl! }}
  end
  defp convert(entity), do: {:ok, entity}
end
