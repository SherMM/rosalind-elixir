defmodule ConsTest do
  use ExUnit.Case
  doctest Cons

  test "greets the world" do
    assert Cons.hello() == :world
  end
end
