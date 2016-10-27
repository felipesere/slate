defmodule ViewTest do
  use ExUnit.Case

  test "truth" do
    result = ExampleView.render(:index, [where: "there"])
    assert result == "Hello there\n"
  end
end
