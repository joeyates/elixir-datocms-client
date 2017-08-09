defmodule DatoCMS.Test.Support.FixtureHelper do
  def fixtures_path, do: Path.join("test", "fixtures")

  def read_fixture(name) do
    Path.join(fixtures_path(), name <> ".json")
    |> File.read!
  end

  def load_fixture(name) do
    {:ok, data} = read_fixture(name)
    |> JSX.decode!
    |> Morphix.atomorphiform
    data
  end
end
