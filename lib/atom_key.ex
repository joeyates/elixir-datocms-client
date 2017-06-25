defmodule AtomKey do
  def to_atom(a) when is_atom(a) do
    a
  end
  def to_atom(n) when is_integer(n) do
    :"#{n}"
  end
  def to_atom(s) when is_binary(s) do
    String.to_atom(s)
  end
end
