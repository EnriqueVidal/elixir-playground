defmodule Servy.BearController do
    alias Servy.Wildthings
    alias Servy.Bear

    defp to_list(bears) do
        bears
        |> Enum.map(fn(bear) -> "<li>#{bear.name} - #{bear.type}</li>" end)
        |> Enum.join
    end

    def index(conv) do
        items = Wildthings.list_bears()
        |> Bear.grizzly
        |> Bear.order_asc_by_name
        |> to_list

        %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
    end

    def show(conv, %{"id" => id} = _params) do
        bear = Wildthings.get_bear(id)

        %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
    end

    def create(conv, %{"name" => name, "type" => type} = _params) do
        %{ 
            conv | 
            status: 201, 
            resp_body: "Create a #{type} bear named #{name}" 
        }
    end
end