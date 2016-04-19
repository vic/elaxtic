defmodule Elaxtic.DocumentTest do

  use ExUnit.Case
  use Elaxtic.TestSetup

  alias Elaxtic.Document
  alias Elaxtic.TestSetup.{Repo, Doc}

  test "id extracts id field from data" do
    assert "one" == Document.id(%{id: "one"})
    assert "two" == Document.id(id: "two")
  end

  test "id extracts from elastic result" do
    assert "one" == Document.id(%{"_id" => "one"})
  end

  test "source extract from elastic result" do
    assert "foo" === Document.source(%{"_source" => "foo"})
  end

  @tag :drop_index
  @tag :create_index
  @tag :put_mapping
  test "indexing a document without id generates an id" do
    assert {:ok, %{"created" => true, "_id" => id}} =
      Repo.Document.index Doc, [name: "homer"]
    assert id
  end

  @tag :drop_index
  @tag :create_index
  @tag :put_mapping
  test "indexing a document with id" do
    assert {:ok, %{"created" => true, "_id" => id}} =
      Repo.Document.index Doc, [id: "simpson", name: "homer"]
    assert id == "simpson"
  end


end
