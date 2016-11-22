defmodule Gallery.View do
  use Templating, layout: "../layout"
  use Images

  def render(:title, _opts) do
    "Gallery"
  end
end
