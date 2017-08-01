defmodule IndexEntities.Test do
  use ExUnit.Case, async: true

  describe ".by_id" do
    test "indexes entities by id" do
      ent1 = %{id: 33}
      ent2 = %{id: 99}
      entities = [ent1, ent2]
      indexed = IndexEntities.by_id(entities)

      assert(indexed[:"33"] == ent1)
      assert(indexed[:"99"] == ent2)
    end
  end

  describe ".by_key" do
    test "indexes entities by the given key" do
      ent1 = %{foo: 33}
      ent2 = %{foo: 99}
      entities = [ent1, ent2]
      indexed = IndexEntities.by_key(entities, :foo)

      assert(indexed[:"33"] == ent1)
      assert(indexed[:"99"] == ent2)
    end
  end
end
