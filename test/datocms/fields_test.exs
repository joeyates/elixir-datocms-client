defmodule DatoCMS.FieldsTest do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    [site: site]
  end

  test "it extracts fields from site info", context do
    {:ok, fields} = DatoCMS.Fields.from(context[:site])

    assert(length(fields) == 6)


    assert(%{"id" => "1234", "type" => "field"} = Enum.fetch!(fields, 0))
  end
end
