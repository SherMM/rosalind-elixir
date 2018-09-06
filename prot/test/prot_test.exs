defmodule ProtTest do
  use ExUnit.Case
  doctest Prot

  test "greets the world" do
    assert Prot.hello() == :world
  end
end
