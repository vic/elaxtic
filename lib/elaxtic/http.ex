defmodule Elaxtic.HTTP do
  use HTTPoison.Base

  def process_url(url) when is_binary(url) do
    url
  end

  def process_request_headers(headers) do
    headers
    |> Dict.put(:"Content-Type", "application/json; charset=UTF-8")
  end

  def process_request_body(x) when is_binary(x), do: x

  def process_request_body(kw) when is_list(kw) do
    kw |> to_map |> process_request_body
  end

  defp to_map(value) when is_binary(value), do: value
  defp to_map(value) when is_list(value) do
    if Keyword.keyword?(value) do
      Enum.into(value, %{}, fn {k, v} -> {k, to_map(v)} end)
    else
      value
    end
  end
  defp to_map(value), do: value

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_response_body(body) do
    case body |> to_string |> Poison.decode do
      {:error, _} -> body
      {:ok, decoded} -> decoded
    end
  end

  def response({x, response}), do: {x, response.body}
end
