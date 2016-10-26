defmodule View do

  def image(name) do
    "#{Application.fetch_env!(:slate, :image_host)}/slate-inbox/#{name}"
  end

  def render(template, params \\ []) do
    inner = partial(template, params )
    partial("layout", [content: inner])
  end

  def partial(template, params \\ []) do
    if String.ends_with?(template, ".html") do
      EEx.eval_file("#{__DIR__}/#{template}.eex", params, [])
    else
      EEx.eval_file("#{__DIR__}/#{template}.html.eex", params, [])
    end
  end

  def render_many(collection, [element: name, in: template]) do
    Enum.map(collection, &partial(template, Keyword.new([{name, &1}])))
  end
end
