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
    index(repo, type, data, id(data))
  end

  def index(repo, type, data, nil) do
    URL.type_url(repo, type)
    |> HTTP.post(source(data))
    |> HTTP.response
  end

  def index(repo, type, data, id) do
    URL.type_url(repo, type, [id])
    |> HTTP.put(source(data))
    |> HTTP.response
  end

  def search(repo, type, query) do
    URL.type_url(repo, type, ["_search"])
    |> HTTP.post(query)
    |> HTTP.response
  end

  def id(data) do
    get_in(data, [:id]) || get_in(data, [:_id]) ||
    if is_map(data) do
      get_in(data, ["id"]) || get_in(data, ["_id"])
    end
  end

  def source(%{"_source" => source}), do: source
  def source(data), do: data

end
