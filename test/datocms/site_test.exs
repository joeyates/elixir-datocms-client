defmodule DatoCMS.SiteTest.FakeHTTPClient do
  import DatoCMS.Test.Support.FixtureHelper

  @api_base "https://site-api.datocms.com"

  def request(_method, url, _body, _options) do
    respond(url)
  end

  defp respond(@api_base <> "/site?include=item_types%2Citem_types.fields") do
    response_body = read_fixture("site")
    {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
  end
end

defmodule DatoCMS.SiteTest.TestData do
  def access_token, do: "access_token"

  def test_env() do
    [
      access_token: access_token(),
      http_client: DatoCMS.SiteTest.FakeHTTPClient
    ]
  end
end

defmodule DatoCMS.SiteTest do
  use ExUnit.Case, async: true
  import DatoCMS.SiteTest.TestData
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    DatoCMS.Test.Support.ApplicationEnvironment.set(test_env())
    site = load_fixture("site")
    [site: site]
  end

  test "it returns site data", context do
    {:ok, site} = DatoCMS.Site.fetch()

    assert(site == context[:site])
  end
end
