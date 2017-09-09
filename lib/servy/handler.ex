defmodule Servy.Handler do
   def handle(request) do
    request 
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> emojify
    |> format_response
   end 

   def parse(request) do
    [method, path, _] = 
        request 
        |> String.split("\n") 
        |> List.first
        |> String.split
    
    %{ 
        method: method, 
        path: path, 
        resp_body: "",
        status: nil
    }
   end

   def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
   end

   def track(conv), do: conv

   def rewrite_path(%{ path: path } = conv) do
       ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
       |> Regex.named_captures(path)
       |> rewrite_path_captures(conv)
   end

   def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
    end

    def rewrite_path(conv), do: conv 

   defp rewrite_path_captures(%{"id" => id, "thing" => thing} = captures, conv) do
    %{ conv | path: "/#{thing}/#{id}" }       
   end

   defp rewrite_path_captures(nil, conv), do: conv

   def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
   end

   def route(%{method: "GET", path: "/bears"} = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
   end

   def route(%{method: "GET", path: "/bears/" <> id} = conv) do
       %{ conv | status: 200, resp_body: "Bear #{id}" }
   end

   def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
       %{ conv | status: 403, resp_body: "Deleting a bear is forbidden" }
   end

   def route(%{method: _method, path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
   end

   defp status_reason(code) do
       %{
           200 => "OK",
           201 => "Created",
           401 => "Unauthorized",
           403 => "Forbidden",
           404 => "Not Found",
           500 => "Internal Server Error"
       }[code]
   end

   def emojify(%{status: 200, resp_body: resp_body} = conv) do
    %{ conv | resp_body: ";) #{resp_body} :)"}
   end

   def emojify(conv), do: conv

   def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason conv.status}
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