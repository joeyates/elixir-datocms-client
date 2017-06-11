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
      access_token: access_token(),
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

  test ".load returns all site data" do
    {:ok, repo} = DatoCMS.Repo.load()
    assert(
      Keyword.keys(repo) == [
        :items_by_type, :internalized_item_types_by_id, :site
      ]
    )
  end

  test "when given a tuple containing a type and id, .get! returns an item" do
    {:ok, repo} = DatoCMS.Repo.load()
    item = DatoCMS.Repo.get!(repo, {"category", "12346"})

    assert(%{"id" => "12346", "name" => "The Category"} = item)
  end

  test "when given a tuple containing a type and array, .get! returns items" do
    {:ok, repo} = DatoCMS.Repo.load()
    items = DatoCMS.Repo.get!(repo, {"tag", ["12347"]})

    assert(length(items) == 1)
    assert(%{"id" => "12347", "name" => "A Tag"} = hd(items))
  end
end
