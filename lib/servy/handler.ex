defmodule Servy.Handler do
    import Servy.Conv, only: [full_status: 1]
    import Servy.FileHandler, only: [handle_file: 2]
    import Servy.Parser, only: [parse: 1]
    import Servy.Plugins, only: [rewrite_path: 1, track: 1]

    alias Servy.Conv

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

   def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
   end

   def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
   end

   def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{ conv | status: 403, resp_body: "Deleting a bear is forbidden" }
   end

   def route(%Conv{method: _method, path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
   end

   def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size conv.resp_body}

    #{conv.resp_body}
    """
   end
end

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose


request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose

request = """
GET /pages/form HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

respose = Servy.Handler.handle(request)
IO.puts respose