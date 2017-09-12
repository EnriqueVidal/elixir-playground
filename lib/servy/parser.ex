defmodule Servy.Parser do
    alias Servy.Conv

    def parse(request) do
        [top, params_string] = String.split request, "\n\n"
        [request_line | header_lines] = String.split top, "\n"
        [method, path, _] = String.split request_line, " "

        headers = parse_headers header_lines, %{}
        params = parse_params headers["Content-Type"], params_string

        %Conv{
            headers: headers,
            method: method,
            path: path,
            params: params,
        }
    end

    defp parse_headers([head | tail], headers) do
        [key, value] = String.split head, ": "
        parse_headers tail, Map.put(headers, key, value)
    end

    defp parse_headers([], headers), do: headers

    defp parse_params("application/x-www-form-urlencoded", param_string) do
        param_string
        |> String.trim
        |> URI.decode_query
    end

    defp parse_params(_, _), do: %{}
end