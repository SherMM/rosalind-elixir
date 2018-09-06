defmodule RevcTest do
  use ExUnit.Case
  doctest Revc

  test "greets the world" do
    assert Revc.hello() == :world
  end
end
