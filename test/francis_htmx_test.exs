defmodule FrancisHtmxTest do
  use ExUnit.Case
  alias FrancisHtmx

  describe "htmx/1" do
    test "renders html content with htmx loaded and renders assigns" do
      body = Req.get!("/", plug: FrancisHtmxTestHandler).body
      html = Floki.parse_document!(body)

      assert html
             |> Floki.find("script")
             |> Floki.attribute("src") == ["https://unpkg.com/htmx.org/dist/htmx.js"]

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

  htmx(fn _ ->
    assigns = %{title: "test"}

    ~E"""
    <div><%= @title %></div>
    """
  end)
end
