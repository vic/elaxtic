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
    end
  end

  def index(repo, type, data) do
    URL.index_url(repo, type)
    |> HTTP.post(type.to_elastic(data))
    |> HTTP.response
  end

  def search(repo, type, query) do
    URL.type_url(repo, type, ["_search"])
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
