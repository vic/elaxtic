defmodule Elaxtic.HTTPTest do

  use ExUnit.Case
  import Elaxtic.HTTP

  test "converts keyword data to json" do
    json = process_request_body(foo: [bar: "baz", moo: [1, 2]])
    assert json == process_request_body(%{foo: %{bar: "baz", moo: [1, 2]}})
  end

end
