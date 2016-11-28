defmodule Slate.Catalog do
  use Ecto.Repo, otp_app: :slate
  import Ecto.Query, only: [from: 2]

  def gallery(id) do
    one(from g in Gallery, where: g.id == ^id, preload: [:images])
  end
end
