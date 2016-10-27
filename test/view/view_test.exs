defmodule ViewTest do
  use ExUnit.Case

  test "creates the proper function" do
    result = ExampleView.render(:index, [where: "there"])
    assert result == "Hello there\n"
  end

  test "creates more than one function" do
    result = ExampleView.render(:foo, [bar: "Banana"])
    assert result == "Banana is the way to go.\n"
  end
end
