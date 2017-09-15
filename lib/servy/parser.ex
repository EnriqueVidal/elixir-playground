defmodule Servy.Parser do
    alias Servy.Conv

    def parse(request) do
        [top, params_string] = String.split request, "\r\n\r\n"
        [request_line | header_lines] = String.split top, "\r\n"
        [method, path, _] = String.split request_line, " "

        headers = parse_headers header_lines
        params = parse_params headers["Content-Type"], params_string

        %Conv{
            headers: headers,
            method: method,
            path: path,
            params: params,
        }
    end

    @doc """
    parses a given list of headers in the form `["Content-Type: application/json"]`
    into a map with corresponding keys and values

    ## Examples
        iex> header_lines = ["Content-Type: application/json"]
        iex> Servy.Parser.parse_headers header_lines
        %{"Content-Type" => "application/json"}
    """
    def parse_headers(header_lines) do
        Enum.reduce header_lines, %{}, &to_map/2
    end

    defp to_map(row, map) do
        [key, val] = String.split row, ": "
        Map.put map, key, val
    end

    @doc """
    Parses the given param string of the form `key1=value1&key2=value2`
    into a map with corresponding keys and values

    ## Examples
        iex> params_string = "name=Baloo&type=Brown"
        iex> Servy.Parser.parse_params "application/x-www-form-urlencoded", params_string
        %{"name" => "Baloo", "type" => "Brown"}
        iex> Servy.Parser.parse_params "multipart/form-data", params_string
        %{}
    """
    def parse_params("application/x-www-form-urlencoded", param_string) do
        param_string
        |> String.trim
        |> URI.decode_query
    end

    def parse_params(_, _), do: %{}
end