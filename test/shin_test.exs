defmodule ShinTest do
  use ExUnit.Case
  doctest Shin

  test "greets the world" do
    assert Shin.hello() == :world
  end
end
