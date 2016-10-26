defmodule S3Tests do
  use ExUnit.Case
  alias ExAws.S3

  test "lists all files from S3" do
    S3.list_objects("inbox")
    |> ExAws.request!
    |> extract
    |> IO.inspect
  end

  test "read a single file from S3" do
    S3.get_object("inbox", "waves.jpg")
    |> ExAws.request!
    |> IO.inspect
  end



  def extract(%{body: %{contents: content}}) do
    Enum.map(content, &file_name/1)
  end

  def file_name(%{key: name}), do: name
end
