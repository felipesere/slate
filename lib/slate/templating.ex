defmodule Templating do

  def expand(layout, caller) do
    dir = Path.dirname(caller.file)
    "#{dir}/#{layout}.html.eex"
  end

  defmacro __using__(opts) do
    layout = opts
             |> Keyword.get(:layout, "layout")
             |> expand(__CALLER__)

    compiled_layout = EEx.compile_file(layout, [engine: EEx.SmartEngine])

    quote do
      @before_compile Templating
      @compile :nowarn_unused_vars
      @external_resource unquote(layout)

      def render_many(collection, opts) do
        name = Keyword.fetch!(opts, :name)
        extras = fn(element) ->  expand_extras(opts, name, element) end
        predicate = Keyword.get(opts, :selecting, fn(_) -> Keyword.fetch!(opts, :in) end)
        template = Keyword.fetch(opts, :in)
        Enum.map(collection, &render(predicate.(&1), extras.(&1)))
      end

      defp expand_extras(opts, name, element) do
        opts
        |> Keyword.get(:assigns, [])
        |> Keyword.merge(to_list(name, element))
      end

      defp to_list(name, value), do: Keyword.new([{name, value}])

      def within_layout(name, assigns \\ []) do
        inner = render(name, assigns)
        render(unquote(layout), [content: inner])
      end

      def render(unquote(layout), var!(assigns)), do: unquote(compiled_layout)
      def render(template), do: render(template, [])
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
    filename
    |> String.split(".")
    |> List.first
  end
end
