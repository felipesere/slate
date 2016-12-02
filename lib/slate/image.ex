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

    def simple(file, title, date) do
      subtitle = date |> Timex.to_datetime |> Timex.format!("{Mfull} {D}, {YYYY}")
      %Image{image: file,
        title: title,
        date: Ecto.Date.cast!(date),
        subtitle: subtitle
        }
    end

    def description(%Image{} = image, description), do: %{ image | description: description}
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

    def add(%Image{} = image, %Exif{} = exif), do: %{ image | exif: exif}
  end
