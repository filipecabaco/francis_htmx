defmodule Example do
  use Francis
  import FrancisHtmx

  htmx("""
  <style>
  .smooth { transition: all 1s ease-in; font-size: 8rem;}
  </style>
  <div
    id="color-demo"
    class="smooth"
    style="color:red"
    hx-get="/colors"
    hx-swap="outerHTML"
    hx-trigger="every 1s">
    Color Swap Demo
  </div>
  """)

  get("/colors", fn _ ->
    new_color = 3 |> :crypto.strong_rand_bytes() |> Base.encode16() |> then(&"##{&1}")
    """
    <div
      id="color-demo"
      class="smooth"
      style="color:#{new_color}"
      hx-get="/colors"
      hx-swap="outerHTML"
      hx-trigger="every 1s">
      Color Swap Demo
    </div>
    """
  end)

end
