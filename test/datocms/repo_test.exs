defmodule DatoCMS.Repo.Test do
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

  describe ".get" do
    test "when given a tuple containing type and id, returns the item" do
      {:ok, item} = DatoCMS.Repo.get({:post, "12345"})

      assert(%{id: "12345", body: "Ciao"} = item)
    end

    test "when given a tuple containing type and id, it localizes in the first (default) locale" do
      {:ok, item} = DatoCMS.Repo.get({:post, "12345"})

      assert(%{title: "Il titolo"} = item)
    end

    test "when given a tuple containing type, id and locale, it localizes in the given locale" do
      {:ok, item} = DatoCMS.Repo.get({:post, "12345"}, :en)

      assert(%{title: "The Title"} = item)
    end

    test "when given a tuple containing type and a list of ids, returns items" do
      {:ok, items} = DatoCMS.Repo.get({"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{id: "12345", body: "Ciao"} = hd(items))
    end

    test "when given a tuple containing type and a list of ids, it localizes in the first (default) locale" do
      {:ok, items} = DatoCMS.Repo.get({"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{id: "12345", title: "Il titolo"} = hd(items))
    end

    test "when given a tuple containing type, a list of ids and a locale, it localizes in the given locale" do
      {:ok, items} = DatoCMS.Repo.get({"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{id: "12345", title: "Il titolo"} = hd(items))
    end
  end

  describe ".get!" do
    test "when given a known id returns an item" do
      item = DatoCMS.Repo.get!({:category, "12346"})

      assert(%{id: "12346", name: "The Category", item_type: :category} = item)
    end
  end
end
