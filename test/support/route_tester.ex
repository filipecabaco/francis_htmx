defmodule Support.RouteTester do
  @moduledoc """
  Generates test modules with Francis to test routes in isolation
  """
  def generate_module(mod, handlers, plugs \\ []) do
    ast =
      quote context: mod do
        defmodule unquote(mod) do
          use Francis, plugs: unquote(plugs)
          import FrancisHtmx
          unquote(handlers)
        end
      end

    Code.compile_quoted(ast)
    mod
  end

end
