defmodule FrancisHtmx do
  defmacro __using__(_opts \\ []) do
    quote location: :keep do
      unmatched(fn _ -> "not found" end)
    end
  end
  defmacro htmx(content, opts\\[]) do
    quote location: :keep do
      get("/", fn conn -> root(unquote(content).(conn), unquote(opts)) end)
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
