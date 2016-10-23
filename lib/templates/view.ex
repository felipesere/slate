defmodule View do
  def image(name) do
    "public/images/#{name}"
  end

  def partial(template) do
     EEx.eval_file "#{__DIR__}/#{template}"
  end
end
