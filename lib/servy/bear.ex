defmodule Servy.Bear do
    defstruct id: nil, name: "", type: "", hibernating: false
    
    def grizzly(bears) when is_list(bears) do
        Enum.filter bears, &grizzly?/1
    end

    def grizzly?(bear) do
        bear.type === "Grizzly"
    end

    def order_asc_by_name(bears) do
        Enum.sort bears, &(&1 <= &2)
    end
end