defmodule Mix.Tasks.Watcher do
  use ExFSWatch, dirs: ["lib/"]
  use Mix.Task

  def run(_) do
    Application.ensure_all_started(:slate)
    Code.compiler_options(ignore_module_conflict: true)
    {:ok, watcher} = Mix.Tasks.Watcher.start
    Process.monitor(watcher)
    :timer.sleep(:infinity)
  end

  def callback(file, events) do
    if Enum.member?(events, :modified) do
      reload(file)
    end
  end

  def reload(file) do

    case Path.extname(file) do
      ".ex" -> reload_regular_file(file)
      ".eex" -> reload_template(file)
      _ -> IO.puts file
    end
  end

  def reload_regular_file(file) do
    try do
      Code.load_file(file)
    rescue
      e -> IO.inspect(e)
    end
  end

  def reload_template(_file) do
    Code.load_file("lib/templates/gallery/view.ex")
    Code.load_file("lib/templates/admin/view.ex")
  end
end
