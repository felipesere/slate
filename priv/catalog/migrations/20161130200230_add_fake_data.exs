defmodule Slate.Catalog.Migrations.AddFakeData do
  use Ecto.Migration

  def change do
    alter table(:images) do
      remove :description
      add :description, :text
    end
    flush

    london = insert!(Image.simple("london.jpg", "London", ~D[2015-03-01]))
    spring = insert!(Image.simple("spring.jpg", "Spring", ~D[2016-04-04]))
    waves = insert!(Image.simple("waves.jpg", "Waves", ~D[2014-03-23]))
    outcropping = Image.simple("outcropping.jpg", "Outcropping", ~D[2014-07-17])
                  |> Image.description("This pictures was shot very early in the morning on the other side of Madeira from where we were staying. I like how the large rock looks as if were standing calmly almost proudly over the water. The clouds help in giving the entire scene a heroic atmosphere.")
                  |> Exif.add(%Exif{aperture: 11, camera: "Canon EOS 70D", focal_length: 10, iso: 100, shutter_speed: "30s" })
                  |> insert!()

    beach = insert!(Image.simple("beach.jpg", "Beach", ~D[2015-08-29]))
    rocks = insert!(Image.simple("rocks.jpg", "Rocks", ~D[2014-08-03]))

    gallery = insert!(Gallery.simple("Madeira",~D[2015-03-16], images: [beach, rocks, waves, outcropping]))
  end

  defp insert!(thing), do: Slate.Catalog.insert!(thing)
end
