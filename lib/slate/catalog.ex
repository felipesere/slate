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

  defp convert(nil), do: :none
  defp convert(thing), do: thing
end
