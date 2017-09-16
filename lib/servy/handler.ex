defmodule Servy.Handler do
    import Servy.Conv, only: [full_status: 1]
    import Servy.FileHandler, only: [handle_file: 2]
    import Servy.Parser, only: [parse: 1]
    import Servy.Plugins, only: [rewrite_path: 1, track: 1]

    alias Servy.Conv
    alias Servy.BearController
    alias Servy.Api

    @pages_path Path.expand("../../pages", __DIR__)

    def handle(request) do
        request
        |> parse
        |> rewrite_path
        |> route
        |> track
        |> format_response
    end
    
    defp page(filename) do
        @pages_path
        |> Path.join(filename <> ".html")
        |> File.read
    end

    def route(%Conv{method: "GET", path: "/about"} = conv) do
        page("about")
        |> handle_file(conv)
    end

    def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
        page("form")
        |> handle_file(conv)
    end

    def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
        page(file)
        |> handle_file(conv)
    end

    def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
        %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
    end

    def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
        Api.BearController.index conv
    end

    def route(%Conv{method: "GET", path: "/bears"} = conv) do
        BearController.index conv
    end

    def route(%Conv{method: "GET", path: "/bears/" <> id, params: params} = conv) do\
        params = Map.put params, "id", id
        BearController.show conv, params
    end

    def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
        BearController.destroy conv
    end

    def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
        BearController.create conv, params
    end

    def route(%Conv{method: _method, path: path} = conv) do
        %{ conv | status: 404, resp_body: "No #{path} here!"}
    end

    def format_response(%Conv{} = conv) do
        """
        HTTP/1.1 #{full_status(conv)}\r
        Content-Type: #{conv.resp_content_type}\r
        Content-Length: #{byte_size conv.resp_body}\r
        \r
        #{conv.resp_body}
        """
    end
end
