defmodule HandlerTest do
    use ExUnit.Case, async: true
    import Servy.Handler, only: [handle: 1]

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
end