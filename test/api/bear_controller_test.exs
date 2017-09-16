defmodule Api.BearControllerTest do
    use ExUnit.Case, async: true
    doctest Servy.Api.BearController

    import Servy.Wildthings, only: [bears: 0]
    import Servy.Parser, only: [parse: 1]

    alias Servy.Api
    alias Servy.Conv

    test "GET /api/bears" do
        conv = 
            """
            GET /api/bears HTTP/1.1\r
            Host: example.com\r
            User-Agent: ExampleBrowser/1.0\r
            Accept: */*\r
            \r
            """
            |> parse

        json = bears() |> Poison.encode!

        assert Api.BearController.index(conv) == %Conv{
            conv |
            status: 200, 
            resp_body: json,
            resp_content_type: "application/json",
        }
    end
end