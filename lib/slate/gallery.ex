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
end
