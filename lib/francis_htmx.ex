defmodule FrancisHtmx do
  defmacro htmx(content, opts \\ []) do
    quote location: :keep do
      get("/", fn conn -> root(unquote(content).(conn), unquote(opts)) end)
    end
  end

  defmacro sigil_E(content, _opts \\ []) do
    unless Macro.Env.has_var?(__CALLER__, {:assigns, nil}) do
      raise "~E requires a variable named \"assigns\" to exist and be set to a map"
    end

    quote do
      unquote(content)
      |> EEx.eval_string([assigns: var!(assigns)], engine: Phoenix.HTML.Engine)
      |> then(fn {:safe, content} -> Enum.join(content) end)
    end
  end

  def root(content, opts) when is_binary(content) do
    title = Keyword.get(opts, :title, "")

    """
    <!DOCTYPE html>
    <html>
      <head>
        <title>#{title}</title>
        <script src="https://unpkg.com/htmx.org/dist/htmx.js"></script>
      </head>
      <body>
        #{content}
      </body>
    </html>
    """
  end
end
