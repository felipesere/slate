defmodule ViewTest do
  use ExUnit.Case

  test "truth" do
    result = ExampleView.render(:index, [])
    assert result == "Hello there"
  end
end
