defmodule FrancisHtmxTest do
  use ExUnit.Case
  alias FrancisHtmx

  describe "htmx/1" do
    test "renders html content with htmx loaded and renders assigns" do
      response = Req.get!("/", plug: FrancisHtmxTestHandler)

      assert response.status == 200
      assert response.headers["content-type"] == ["text/html; charset=utf-8"]

      body = response.body
      html = Floki.parse_document!(body)

      assert html
             |> Floki.find("script")
             |> Floki.attribute("src") == [
               "https://cdn.tailwindcss.com",
               "https://unpkg.com/htmx.org/dist/htmx.js"
             ]

      assert html
             |> Floki.find("link")
             |> Floki.attribute("href") == ["/app.css"]

      assert html
             |> Floki.find("title")
             |> Floki.text() == "Testing HTMX"

      assert html
             |> Floki.find("body")
             |> Floki.find("div")
             |> Floki.text() == "test"
    end
  end
end

defmodule FrancisHtmxTestHandler do
  use Francis
  import FrancisHtmx

  htmx(
    fn _ ->
      assigns = %{title: "test"}

      ~E"""
      <div><%= @title %></div>
      """
    end,
    title: "Testing HTMX",
    head: """
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="/app.css" rel="stylesheet">
    """
  )
end
