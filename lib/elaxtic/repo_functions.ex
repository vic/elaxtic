defmodule Elaxtic.RepoFunctions do

  defmacro __using__(repo_functions) do
    repo_functions = Macro.escape(repo_functions)
    quote do
      defmacro __using__(:repo_functions) do
        Elaxtic.RepoFunctions.delegate(
          unquote(repo_functions), __MODULE__, __CALLER__.module)
      end
    end
  end

  def delegate(calls, to, from) do
    repo = repo_module(from)
    calls |> Enum.map(&repo_delegate(&1, to, repo))
  end

  defp repo_module(module) do
    module |> Module.split |> List.delete_at(-1) |> Module.concat
  end

  defp repo_delegate(call, to, repo) do
    {:def, [], [clean_call(call), [do: repo_call(to, repo, call)]]}
  end

  defp clean_call(call) do
    {local, args} = Macro.decompose_call(call)
    args = Enum.reject(args, fn x ->
      case x do
        {:__MODULE__, _, _} -> true
        _ -> false
      end
    end)
    {local, [], args}
  end

  defp repo_call(remote, repo, call) do
    {local, args} = Macro.decompose_call(call)
    {{:., [], [remote, local]}, [], [repo | args]}
  end

end
