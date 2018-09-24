defmodule SubsTest do
  use ExUnit.Case
  doctest Subs

  test "greets the world" do
    assert Subs.hello() == :world
  end
end
