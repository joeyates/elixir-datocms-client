defmodule FakeWithHelpers do
  use DatoCMS
end

defmodule DatoCMS.Test do
  use ExUnit.Case, async: false
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    on_exit fn ->
      DatoCMS.Repo.put(nil)
    end

    site = load_fixture("site")
    %{data: items} = load_fixture("items1")

    {:ok, state} = DatoCMS.Transformer.internalize(site, items)
    DatoCMS.Repo.put(state)

    :ok
  end

  describe ".dato_get/2" do
    describe "when given a tuple containing just a type and then a locale" do
    test "when given a tuple containing just a type and then a locale, returns the item" do
      item = FakeWithHelpers.dato_get({:post}, :it)

      assert(%{id: "12345", body: "Ciao"} = item)
    end
    end
  end

  describe ".dato_get/1" do
    test "when given a tuple containing type and id, returns the item" do
      item = FakeWithHelpers.dato_get({:post, "12345"})

      assert(%{id: "12345", body: "Ciao"} = item)
    end
  end
end
