defmodule View do
  use Templating, templates: "."

  def image(%{image: name}), do: image(name)
  def image({_, [image: name]}), do: image(name)
  def image(name) do
    "#{Application.fetch_env!(:slate, :image_host)}/slate-inbox/images/#{name}"
  end
end
