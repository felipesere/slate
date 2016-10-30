  defmodule Image do
    defstruct id: nil, image: nil,
              title: nil, subtitle: nil,
              description: false,
              exif: false
  end

  defmodule Exif do
    defstruct [:aperture, :camera, :focal_length, :iso, :shutter_speed]
  end
