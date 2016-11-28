defmodule Slate.Catalog do
  use Ecto.Repo, otp_app: :slate
  import Ecto.Query, only: [from: 2]

  def gallery(id) do
    one(from g in Gallery, where: g.id == ^id, preload: [:images])
                                        |> convert
  end

  def image(id) do
    one(from i in Image, where: i.id == ^id)
                                        |> convert
  end

  def all do
    all_galleries() ++ all_images()
  end

  defp all_galleries(), do: all(from g in Gallery, preload: [:images])

  defp all_images(), do: all(from i in Image, where: is_nil(i.gallery_id))

  defp convert(nil), do: :none
  defp convert(thing), do: thing
end
