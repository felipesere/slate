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

  test "template within template" do
    result = ExampleView.render(:super, [where: "there", bar: "Banana"])
    assert result == ~S"""
This is large
Hello there

Banana is the way to go.

"""
  end

  test "render many" do
    result = ExampleView.render(:render_many, [numbers: [1,2,3]])
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
end
