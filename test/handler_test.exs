defmodule HandlerTest do
    use ExUnit.Case, async: true
    import Servy.Handler, only: [handle: 1]
    alias Servy.Wildthings

    test "GET /widlthings" do
        response =
            """
            GET /wildthings HTTP/1.1\r
            Host: example.com\r
            User-Agent: ExampleBrowser/1.0\r
            Accept: */*\r
            \r
            """
            |> handle

        assert response == """
        HTTP/1.1 200 OK\r
        Content-Type: text/html\r
        Content-Length: 20\r
        \r
        Bears, Lions, Tigers
        """
    end

    test "DELETE /bears/:id" do
        response =
            """
            DELETE /bears/1 HTTP/1.1\r
            Host: example.com\r
            User-Agent: ExampleBrowser/1.0\r
            Accept: */*\r
            \r
            """
            |> handle

        assert response == """
        HTTP/1.1 403 Forbidden\r
        Content-Type: text/html\r
        Content-Length: 28\r
        \r
        Deleting a bear is forbidden
        """
    end

    test "GET /api/bears" do
        response =
            """
            GET /api/bears HTTP/1.1\r
            Host: example.com\r
            User-Agent: ExampleBrowser/1.0\r
            Accept: */*\r
            \r
            """
            |> handle
            |> String.trim

        things = Poison.encode! Wildthings.bears

        expected_response =
            """
            HTTP/1.1 200 OK\r
            Content-Type: application/json\r
            Content-Length: #{byte_size things}\r
            \r
            #{things}
            """
            |> String.trim

        assert response == expected_response
    end
end