defmodule Elaxtic.Index do

  alias Elaxtic.{HTTP, URL}

  use Elaxtic.RepoFunctions, [
    reset(type),
    delete(type),
    create(type),
    refresh(type),
    put_mapping(type),
    put_mapping(type, mapping)
  ]

  def reset(repo, type) do
    {:ok, _} = delete(repo, type)
    {:ok, _} = create(repo, type)
  end

  def delete(repo, type) do
    URL.index_url(repo, type)
    |> HTTP.delete
    |> HTTP.response
  end

  def create(repo, type, data \\ %{}) do
    URL.index_url(repo, type)
    |> HTTP.put(data)
    |> HTTP.response
  end

  def put_mapping(repo, type) do
    put_mapping(repo, type, type.elastic[:mapping])
  end

  def put_mapping(repo, type, mapping) do
    URL.url(url: repo, index: {repo, type}, _: "_mapping", type: type)
    |> HTTP.put(mapping)
    |> HTTP.response
  end

  def refresh(repo, type) do
    URL.index_url(repo, type, ["_refresh"])
    |> HTTP.post(%{})
    |> HTTP.response
  end

end
