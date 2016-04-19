defmodule Elaxtic.URLTest do

  use ExUnit.Case
  import Elaxtic.URL

  test "concats path fragments with query string" do
    assert url(["foo", "bar"], [qux: "mux"]) == "foo/bar?qux=mux"
  end

  defmodule Repo do
    use Elaxtic.Repo, url: "http://fake.elastic", index_prefix: "foo"
  end

  defmodule Doc do
    use Elaxtic.Document, index: "bar", type: "moo", mapping: []
  end

  test "index_url" do
    assert index_url(Repo, Doc) == "http://fake.elastic/foo-bar"
  end

  test "type_url" do
    assert type_url(Repo, Doc) == "http://fake.elastic/foo-bar/moo"
  end

  test "doc_url without id" do
    assert doc_url(Repo, Doc, %{}) == "http://fake.elastic/foo-bar/moo"
  end

  test "doc_url with id" do
    assert doc_url(Repo, Doc, %{id: 1}) == "http://fake.elastic/foo-bar/moo/1"
  end

  test "doc_url with _id" do
    assert doc_url(Repo, Doc, %{_id: 1}) == "http://fake.elastic/foo-bar/moo/1"
  end

end
