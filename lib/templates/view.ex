defmodule View do
  def image(name) do
    "public/images/#{name}"
  end

  def partial(template, params \\ []) do
     EEx.eval_file "#{__DIR__}/#{template}.html.eex", params
  end
end
