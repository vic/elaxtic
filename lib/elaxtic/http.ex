defmodule Elaxtic.HTTP do
  use HTTPoison.Base

  def process_url(url) do
    url
  end

  def process_request_headers(headers) do
    headers
    |> Dict.put(:"Content-Type", "application/json; charset=UTF-8")
  end

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
