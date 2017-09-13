defmodule Servy.Parser do
    alias Servy.Conv

    def parse(request) do
        [top, params_string] = String.split request, "\n\n"
        [request_line | header_lines] = String.split top, "\n"
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

    defp parse_headers(header_lines) do
        Enum.reduce header_lines, %{}, &to_map/2
    end

    defp to_map(row, map) do
        [key, val] = String.split row, ": "
        Map.put map, key, val
    end

    defp parse_params("application/x-www-form-urlencoded", param_string) do
        param_string
        |> String.trim
        |> URI.decode_query
    end

    defp parse_params(_, _), do: %{}
end