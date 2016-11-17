defmodule ViewTest do
  use ExUnit.Case

  test "renders within a template" do
    result = ExampleView.within_layout("index", [where: "there"])
    assert result == "<within>Hello there\n</within>\n"
  end

  test "creates the proper function" do
    result = ExampleView.render("index", [where: "there"])
    assert result == "Hello there\n"
  end

  test "creates more than one function" do
    result = ExampleView.render("foo", [bar: "Banana"])
    assert result == "Banana is the way to go.\n"
  end

  test "template within template" do
    result = ExampleView.render("super", [where: "there", bar: "Banana"])
    assert result == ~S"""
This is large
Hello there

Banana is the way to go.

"""
  end

  test "render many" do
    result = ExampleView.render("render_many", [numbers: [1,2,3]])
    assert result == ~S"""
<li>
  1
</li>
<li>
  2
</li>
<li>
  3
</li>

"""
  end

  test "render different template based on predicate" do
    result = ExampleView.render("predicate", [digits: [1,2,3,4]])
    assert result == "1 is odd.\n2 is even.\n3 is odd.\n4 is even.\n\n\n\n"
  end
end
