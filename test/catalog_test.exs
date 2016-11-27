defmodule CatalogTests do
  use ExUnit.Case, async: true

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Slate.Catalog)
  end

  test "createn an image" do
    # Use the repository as usual
    assert %Image{} = Slate.Catalog.insert!(%Image{id: 1})
  end
end
