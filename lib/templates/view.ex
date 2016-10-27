defmodule View do
  use Templating, templates: "."

  def image(name) do
    "#{Application.fetch_env!(:slate, :image_host)}/slate-inbox/#{name}"
  end
end
