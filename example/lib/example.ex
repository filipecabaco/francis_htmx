defmodule Example do
  use Francis
  import FrancisHtmx

  htmx(fn _conn -> File.read!("static/root.html") end)

  get("/colors", fn _ ->
    new_color = 3 |> :crypto.strong_rand_bytes() |> Base.encode16() |> then(&"##{&1}")
    assigns = %{new_color: new_color}
    ~E"""
    <p id="color-demo" class="smooth" style="<%= "color:#{@new_color}"%>">
    Color Swap Demo
    </p>
    """
  end)
end
