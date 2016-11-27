defmodule Gallery do
  use Ecto.Schema

  schema "galleries" do
    field :title,       :string
    field :subtitle,    :string
    field :description, :string
    field :images,      :any, virtual: true
    field :date,        Ecto.Date
    timestamps
  end
end
