defmodule Elaxtic.TestSetup do

  defmodule Repo do
    use Elaxtic.Repo, url: "http://localhost:9200",
      index_prefix: "elaxtic-test"
  end

  defmodule Doc do
    use Elaxtic.Document,
      index: "foo",
      type: "bar",
      mapping: %{properties: %{name: %{type: "string", index: "not_analyzed"}}}
  end

  defmacro __using__(_) do
    quote do

      setup(tags) do
        if tags[:drop_index], do: Repo.Index.delete Doc
        if tags[:create_index], do: assert {:ok, _} = Repo.Index.create Doc
        if tags[:put_mapping] do
          assert {:ok, _} = Repo.Index.put_mapping Doc
        end
        {:ok, %{}}
      end

    end
  end

end
