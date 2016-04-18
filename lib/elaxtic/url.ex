defmodule Elaxtic.URL do

  def index(repo, type) do
    index = [repo.elastic(:index_prefix), type.elastic(:index)] |>
      Stream.filter(&(&1)) |> Enum.join("-")
    [repo.elastic(:url), index] |> join
  end

  def document(repo, type, %{id: id}) do
    [document(repo, type), id] |> Stream.filter(&(&1)) |> join
  end

  def document(repo, type, %{}) do
    document(repo, type)
  end

  def document(repo, type) when is_atom(type) do
    type(repo, type)
  end

  def type(repo, type) do
    [index(repo, type), type.elastic(:type)] |> join
  end

  def append(url, parts, query \\ []) do
    [url, parts] |> List.flatten |> join(query)
  end

  def join(url), do: join(url, [])

  def join(url, query) when is_binary(url) do
    url <> query_string(query)
  end

  def join(paths, query) do
    Enum.join(paths, "/") <> query_string(query)
  end

  def query_string([]), do: ""
  def query_string(query = [_ | _]) do
    "?" <> Enum.map_join(query, "&", fn {k, v} -> "#{k}=#{v}" end)
  end

end
