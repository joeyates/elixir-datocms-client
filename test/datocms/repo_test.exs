defmodule DatoCMS.Repo.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    %{"data" => items} = load_fixture("items1")

    {:ok, state} = DatoCMS.Internalizer.internalize(site, items)

    [state: state]
  end

  describe ".get" do
    test "when given a tuple containing type and id, returns the item", context do
      {:ok, item} = DatoCMS.Repo.get(context[:state], {"post", "12345"})

      assert(%{"id" => "12345", "body" => "Ciao"} = item)
    end

    test "when given a tuple containing type and id, it localizes in the first (default) locale", context do
      {:ok, item} = DatoCMS.Repo.get(context[:state], {"post", "12345"})

      assert(%{"title" => "Il titolo"} = item)
    end

    test "when given a tuple containing type, id and locale, it localizes in the given locale", context do
      {:ok, item} = DatoCMS.Repo.get(context[:state], {"post", "12345", "en"})

      assert(%{"title" => "The Title"} = item)
    end

    test "when given a tuple containing type and a list of ids, returns items", context do
      {:ok, items} = DatoCMS.Repo.get(context[:state], {"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{"id" => "12345", "body" => "Ciao"} = hd(items))
    end

    test "when given a tuple containing type and a list of ids, it localizes in the first (default) locale", context do
      {:ok, items} = DatoCMS.Repo.get(context[:state], {"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{"id" => "12345", "title" => "Il titolo"} = hd(items))
    end

    test "when given a tuple containing type, a list of ids and a locale, it localizes in the given locale", context do
      {:ok, items} = DatoCMS.Repo.get(context[:state], {"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{"id" => "12345", "title" => "Il titolo"} = hd(items))
    end
  end

  describe ".get!" do
    test "when given a known id returns an item", context do
      item = DatoCMS.Repo.get!(context[:state], {"category", "12346"})

      assert(%{"id" => "12346", "name" => "The Category"} = item)
    end
  end

  describe ".default_locale" do
    test "is the first locale in the site data", context do
      {:ok, default_locale} = DatoCMS.Repo.default_locale(context[:state])

      assert(default_locale == "it")
    end
  end
end
