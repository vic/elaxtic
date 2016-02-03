defmodule Elaxtic.Repo do

  defmacro __using__(opts) when is_list(opts) do
    quote do
      Module.register_attribute __MODULE__, :documents, accumulate: true, persist: true

      def elastic, do: unquote(opts)
      def elastic(key, v \\ nil), do: Keyword.get(elastic, key, v)

      defmodule Index do
        use Elaxtic.Index, :repo_functions
      end

      defmodule Document do
        use Elaxtic.Document, :repo_functions
      end
    end
  end

end