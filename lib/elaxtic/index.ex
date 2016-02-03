defmodule Elaxtic.Index do

  alias Elaxtic.{HTTP, URL}

  use Elaxtic.RepoFunctions, [
    reset(type),
    delete(type),
    create(type),
    refresh(type)
  ]

  def reset(repo, type) do
    {:ok, _} = delete(repo, type)
    {:ok, _} = create(repo, type)
  end

  def delete(repo, type) do
    URL.index(repo, type)
    |> HTTP.delete
    |> HTTP.response
  end

  def create(repo, type) do
    URL.index(repo, type)
    |> HTTP.put(type.elastic(:mappings))
    |> HTTP.response
  end

  def refresh(repo, type) do
    URL.index(repo, type)
    |> URL.append("_refresh")
    |> HTTP.post(%{})
    |> HTTP.response
  end

end
