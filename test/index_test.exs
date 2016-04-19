defmodule Elaxtic.IndexTest do

  use ExUnit.Case
  use Elaxtic.TestSetup

  alias Elaxtic.TestSetup.{Repo, Doc}

  @tag :drop_index
  test "drop and create index" do
    assert {:ok, %{"acknowledged" => true}} = Repo.Index.create Doc
  end

  @tag :drop_index
  @tag :create_index
  test "create mapping" do
    x = Repo.Index.put_mapping(Doc, Doc.elastic[:mapping])
    assert {:ok, %{"acknowledged" => true}} = x
  end

  @tag :drop_index
  @tag :create_index
  test "refresh index" do
    assert {:ok, _} = Repo.Index.refresh(Doc)
  end


end
