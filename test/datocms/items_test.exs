defmodule DatoCMS.ItemsTest.FakeHTTPClient do
  import DatoCMS.Test.Support.FixtureHelper

  @api_base "https://site-api.datocms.com"

  def request(_method, url, _body, _options) do
    respond(url)
  end

  defp respond(@api_base <> "/items?page%5Blimit%5D=500&page%5Boffset%5D=0") do
    response_body = read_fixture("items1")
    {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
  end
end

defmodule DatoCMS.ItemsTest.TestData do
  def access_token, do: "access_token"

  def test_env() do
    [
      access_token: access_token(),
      http_client: DatoCMS.ItemsTest.FakeHTTPClient
    ]
  end
end

defmodule DatoCMS.ItemsTest do
  use ExUnit.Case, async: true
  import DatoCMS.ItemsTest.TestData
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    DatoCMS.Test.Support.ApplicationEnvironment.set(test_env())
    items = load_fixture("items1")
    [items: items]
  end

  test "it returns item data", context do
    {:ok, items} = DatoCMS.Items.fetch()

    assert(items == context[:items]["data"])
  end
end
