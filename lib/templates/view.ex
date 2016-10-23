defmodule View do
  def image(name) do
    "public/images/#{name}"
  end

  def partial(template, params \\ []) do
    EEx.eval_file("#{__DIR__}/#{template}.html.eex", params, [])
  end

  def render_many(collection, [element: name, in: template]) do
    Enum.map(collection, fn(element) ->
      partial(template, Keyword.new([{name, element}]))
    end)
  end
end
