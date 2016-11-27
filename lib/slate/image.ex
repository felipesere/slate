  defmodule Image do
    use Ecto.Schema

    schema "catalog" do
      field :image,       :string
      field :title,       :string
      field :subtitle,    :string
      field :description, :string
      field :exif,        :boolean, default: false
      field :date,        Ecto.Date
      timestamps
    end
  end

  defmodule Exif do
    defstruct [:aperture, :camera, :focal_length, :iso, :shutter_speed]
  end
