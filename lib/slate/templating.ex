defmodule Templating do

  defmacro __using__([templates: location]) do
    quote do
      @templates unquote(location)
      @before_compile Templating

      def render_many(collection, [name: name, in: template]) do
          Enum.map(collection, &render(template, Keyword.new([{name, &1}])))
      end

      def render(name, assigns, 1) do
        inner = render(name, assigns)
        render("layout", [content: inner])
      end
    end
  end

  defmacro __before_compile__(env) do
    current_dir = Path.dirname(env.file)

    current_dir
    |> File.ls!
    |> Enum.filter(&String.ends_with?(&1, ".html.eex"))
    |> Enum.map(fn file ->
      file_param = to_atom(file)
      compiled = EEx.compile_file("#{current_dir}/#{file}", [engine: EEx.SmartEngine])

      quote do
        def render(unquote(file_param), var!(assigns)), do: unquote(compiled)
      end
    end)
  end

  def to_atom(filename) do
    String.split(filename, ".")
    |> List.first
  end

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
