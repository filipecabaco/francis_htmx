defmodule FrancisHtmx do
  @moduledoc """
  Provides a macro to render htmx content by loading htmx.js.
  Also provides a sigil to render EEx content similar to ~H from Phoenix.LiveView

  Usage:
  ```elixir
    defmodule Example do
      use Francis
      import FrancisHtmx

      htmx(fn _conn ->
        assigns = %{}
        ~E\"\"\"
        <style>
          .smooth {   transition: all 1s ease-in; font-size: 8rem; }
        </style>
        <div hx-get="/colors" hx-trigger="every 1s">
          <p id="color-demo" class="smooth">Color Swap Demo</p>
        </div>
        \"\"\"
      end)

      get("/colors", fn _ ->
        new_color = 3 |> :crypto.strong_rand_bytes() |> Base.encode16() |> then(&"\#{&1}")
        assigns = %{new_color: new_color}

        ~E\"\"\"
        <p id="color-demo" class="smooth" style="<%= "color:\#{@new_color}"%>">
        Color Swap Demo
        </p>
        \"\"\"
      end)
    end
  ```

  In this scenario we are loading serving an HTML that has the htmx.js library loaded and serves the root content given by htmx/1
  """
  @doc """
  Renders htmx content by loading htmx.js and rendering binary content.
  """
  defmacro htmx(content, opts \\ []) do
    quote location: :keep do
      get("/", fn conn ->
        root(unquote(content).(conn), unquote(opts))
      end)
    end
  end

  @doc """
  Provides a sigil to render EEx content similar to ~H from Phoenix.LiveView

  Requires a variable named "assigns" to exist and be set to a map.
  """
  defmacro sigil_E(content, _opts \\ []) do
    unless Macro.Env.has_var?(__CALLER__, {:assigns, nil}) do
      raise "~E requires a variable named \"assigns\" to exist and be set to a map"
    end

    quote location: :keep do
      unquote(content)
      |> EEx.eval_string([assigns: var!(assigns)], engine: Phoenix.HTML.Engine)
      |> then(fn {:safe, content} -> Enum.join(content) end)
    end
  end

  @doc """
  Renders the root content with htmx.js loaded required for the htmx/1 macro.
  """
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
