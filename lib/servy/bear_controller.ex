defmodule Servy.BearController do
    alias Servy.Wildthings
    alias Servy.Bear

    import View, only: [render: 3]

    def index(conv) do
        bears =
            Wildthings.bears
            |> Bear.grizzly
            |> Bear.order_asc_by_name

        render conv, "index", bears: bears
    end

    def show(conv, %{"id" => id}) do
        bear = Wildthings.get_bear id

        render conv, "show", bear: bear
    end

    def create(conv, %{"name" => name, "type" => type}) do
        render conv, 201, "Create a #{type} bear named #{name}"
    end

    def destroy(conv) do
        render conv, 403, "Deleting a bear is forbidden"
    end
end