defmodule GCTest do
  use ExUnit.Case
  doctest GC

  test "greets the world" do
    assert GC.hello() == :world
  end
end
