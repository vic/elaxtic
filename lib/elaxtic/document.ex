defmodule Elaxtic.Document do

  alias Elaxtic.{HTTP, URL}

  use Elaxtic.RepoFunctions, [
    index(type, model),
    search(type, query),
    ids(hits)
  ]

  defmacro __using__(opts) do
    quote do
      @elastic unquote(opts)
      def elastic, do: @elastic
      def elastic(key, v \\ nil), do: Keyword.get(elastic, key, v)
    end
  end

  def index(repo, type, model) do
    URL.document(repo, type, model)
    |> HTTP.post(type.cast(model))
    |> HTTP.response
  end

  def search(repo, type, query) do
    URL.type(repo, type)
    |> URL.append("_search")
    |> HTTP.post(query)
    |> HTTP.response
  end

  def ids(repo, []), do: []

  def ids(repo, %{"hits" => %{"hits" => hits}}) do
    ids(repo, hits)
  end

  def ids(repo, hits)  do
    hits |> Enum.map(fn %{"_id" => id} -> id end)
  end

end
