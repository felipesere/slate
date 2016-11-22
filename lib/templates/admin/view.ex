defmodule Admin.View do
  use Templating, layout: "../layout"
  use Images

  def render(:title, _opts) do
    "Admin"
  end
end
