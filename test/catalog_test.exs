defmodule CatalogTests do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Slate.Catalog)
  end

  test "createn an image" do
    assert %Image{} = Slate.Catalog.insert!(%Image{title: "Some day", image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])})
  end

  test "create a gallery" do
    assert %Gallery{} = Slate.Catalog.insert!(%Gallery{title: "Some day", date: Ecto.Date.cast!(~D[2016-11-26])})
  end
end
