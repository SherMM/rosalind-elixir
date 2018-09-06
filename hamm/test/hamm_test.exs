defmodule HammTest do
  use ExUnit.Case
  doctest Hamm

  test "greets the world" do
    assert Hamm.hello() == :world
  end
end
