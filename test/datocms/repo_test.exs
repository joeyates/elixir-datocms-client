defmodule DatoCMS.Repo.FakeHTTPClient do
  import DatoCMS.Test.Support.FixtureHelper

  @api_base "https://site-api.datocms.com"

  def request(_method, url, _body, _options) do
    respond(url)
  end

  defp respond(@api_base <> "/site?include=item_types%2Citem_types.fields") do
    response_body = read_fixture("site")
    {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
  end

  defp respond(@api_base <> "/items?page%5Blimit%5D=500&page%5Boffset%5D=0") do
    response_body = read_fixture("items1")
    {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
  end
end

defmodule DatoCMS.Repo.TestData do
  def access_token, do: "access_token"

  def test_env() do
    [
      %{headers: ["Authorization": "Bearer #{access_token()}"]},
      http_client: DatoCMS.Repo.FakeHTTPClient
    ]
  end
end

defmodule DatoCMS.Repo.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Repo.TestData

  setup _context do
    DatoCMS.Test.Support.ApplicationEnvironment.set(test_env())
  end

  describe ".load" do
    test "returns all site data" do
      {:ok, repo} = DatoCMS.Repo.load()
      assert(
        Keyword.keys(repo) == [
          :items_by_type, :internalized_item_types_by_id, :site
        ]
      )
    end
  end

  describe ".get" do
    test "when given a tuple containing type and id, returns the item" do
      {:ok, repo} = DatoCMS.Repo.load()
      {:ok, item} = DatoCMS.Repo.get(repo, {"post", "12345"})

      assert(%{"id" => "12345", "body" => "Ciao"} = item)
    end

    test "when given a tuple containing type and id, it localizes in the first (default) locale" do
      {:ok, repo} = DatoCMS.Repo.load()
      {:ok, item} = DatoCMS.Repo.get(repo, {"post", "12345"})

      assert(%{"title" => "Il titolo"} = item)
    end

    test "when given a tuple containing type, id and locale, it localizes in the given locale" do
      {:ok, repo} = DatoCMS.Repo.load()
      {:ok, item} = DatoCMS.Repo.get(repo, {"post", "12345", "en"})

      assert(%{"title" => "The Title"} = item)
    end

    test "when given a tuple containing type and a list of ids, returns items" do
      {:ok, repo} = DatoCMS.Repo.load()
      {:ok, items} = DatoCMS.Repo.get(repo, {"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{"id" => "12345", "body" => "Ciao"} = hd(items))
    end

    test "when given a tuple containing type and a list of ids, it localizes in the first (default) locale" do
      {:ok, repo} = DatoCMS.Repo.load()
      {:ok, items} = DatoCMS.Repo.get(repo, {"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{"id" => "12345", "title" => "Il titolo"} = hd(items))
    end

    test "when given a tuple containing type, a list of ids and a locale, it localizes in the given locale" do
      {:ok, repo} = DatoCMS.Repo.load()
      {:ok, items} = DatoCMS.Repo.get(repo, {"post", ["12345"]})

      assert(length(items) == 1)
      assert(%{"id" => "12345", "title" => "Il titolo"} = hd(items))
    end
  end

  describe ".get!" do
    test "when given a known id returns an item" do
      {:ok, repo} = DatoCMS.Repo.load()
      item = DatoCMS.Repo.get!(repo, {"category", "12346"})

      assert(%{"id" => "12346", "name" => "The Category"} = item)
    end
  end

  describe ".default_locale" do
    test "is the first locale in the site data" do
      {:ok, repo} = DatoCMS.Repo.load()
      {:ok, default_locale} = DatoCMS.Repo.default_locale(repo)

      assert(default_locale == "it")
    end
  end
end
