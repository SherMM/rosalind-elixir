defmodule RnaTest do
  use ExUnit.Case
  doctest Rna

  test "greets the world" do
    assert Rna.hello() == :world
  end
end
