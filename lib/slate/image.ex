  defmodule Image do
    use Ecto.Schema

    schema "images" do
      field :image,       :string
      field :title,       :string
      field :subtitle,    :string
      field :description, :string
      embeds_one :exif,   Exif
      field :date,        Ecto.Date
      belongs_to :gallery, Gallery
      timestamps
    end
  end

  defmodule Exif do
    use Ecto.Schema

    embedded_schema do
      field :aperture, :integer
      field :camera, :string
      field :focal_length, :integer
      field :iso, :integer
      field :shutter_speed, :string
    end
  end
