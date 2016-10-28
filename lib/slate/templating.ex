defmodule Templating do

  defmacro __using__([templates: location]) do
    quote do
      @templates unquote(location)
      @before_compile Templating

      def render_many(collection, [name: name, in: template]) do
        Enum.map(collection, &render(template, Keyword.new([{name, &1}])))
      end

      def within_layout(name, assigns) do
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
      path ="#{current_dir}/#{file}"
      compiled = EEx.compile_file(path, [engine: EEx.SmartEngine])

      quote do
        @external_resource unquote(path)
        def render(unquote(file_param), var!(assigns)), do: unquote(compiled)
      end
    end)
  end

  def to_atom(filename) do
    String.split(filename, ".")
    |> List.first
  end
end
