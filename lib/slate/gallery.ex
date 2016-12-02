defmodule Gallery do
  use Ecto.Schema

  schema "galleries" do
    field :title,       :string
    field :subtitle,    :string
    field :description, :string
    has_many :images,   Image
    field :date,        Ecto.Date
    timestamps
  end

  def simple(title, date, opts) do
    images = Keyword.get(opts, :images, [])
    subtitle = date |> Timex.to_datetime |> Timex.format!("{Mfull} {D}, {YYYY}")
    %Gallery{title: title, date: Ecto.Date.cast!(date), subtitle: subtitle, images: images}
  end
end
