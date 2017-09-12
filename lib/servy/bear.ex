defmodule Servy.Bear do
    defstruct id: nil, name: "", type: "", hibernating: false
    
    def grizzly(bears) when is_list(bears) do
        bears
        |> Enum.filter(&grizzly(&1))
    end

    def grizzly(bear) do
        bear.type === "Grizzly"
    end

    def order_asc_by_name(bears) do
        bears
        |> Enum.sort(fn(b1, b2) -> b1 <= b2 end)
    end
end