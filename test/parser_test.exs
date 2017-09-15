defmodule ParserTest do
    use ExUnit.Case, async: true
    doctest Servy.Parser

    alias Servy.Parser

    test "parses a list of header fields into  map" do
        headers = 
        [ "A: 1", "B: 2"]
        |> Parser.parse_headers
        
        assert headers == %{"A" => "1", "B" => "2"}
    end
end