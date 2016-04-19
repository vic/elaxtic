defmodule Elaxtic.URL do

  def url(fragments, query \\ []) do
    path(fragments) |> join(query)
  end

  def index_url(repo, type, fragments \\ [], query \\ []) do
    url([url: repo, index: {repo, type}] ++ fragments, query)
  end

  def type_url(repo, type, fragments \\ [], query \\ []) do
    url([url: repo, index: {repo, type}, type: type] ++ fragments, query)
  end

  def doc_url(repo, type, data, fragments \\ [], query \\ []) do
    if id = doc_id(data) do
      type_url(repo, type, [id] ++ fragments, query)
    else
      type_url(repo, type, fragments, query)
    end
  end

  defp path(fragments) do
    fragments
    |> Stream.map(&elastic_path/1)
    |> Stream.filter(&(&1))
  end

  defp doc_id(data) do
    get_in(data, [:id]) || get_in(data, ["id"]) ||
      get_in(data, [:_id]) || get_in(data, ["_id"])
  end

  defp elastic_path(path) when is_binary(path), do: path
  defp elastic_path({:_, path}) when is_binary(path), do: path

  defp elastic_path({:index, {repo, type}}) do
    path(index_prefix: repo, index: type) |> Enum.join("-")
  end

  defp elastic_path({name, module}) when is_atom(module) do
    elastic_path({name, module.elastic})
  end

  defp elastic_path({attr, data}) when is_list(attr) do
    get_in(data, attr)
  end

  defp elastic_path({attr, data}) do
    get_in(data, [attr])
  end

  defp elastic_path(x), do: x

  defp join(paths, query) do
    Enum.join(paths, "/") <> query_string(query)
  end

  defp query_string([]), do: ""
  defp query_string(query = [_ | _]) do
    "?" <> Enum.map_join(query, "&", fn {k, v} -> "#{k}=#{v}" end)
  end

end
