defmodule Elaxtic.Repo do

  defmacro __using__(opts) do
    quote do
      @elastic unquote(opts)
      Module.register_attribute __MODULE__, :documents, accumulate: true, persist: true
      def elastic, do: @elastic

      defmodule Index do
        use Elaxtic.Index, :repo_functions
      end

      defmodule Document do
        use Elaxtic.Document, :repo_functions
      end
    end
  end

end
