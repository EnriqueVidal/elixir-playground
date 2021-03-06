defmodule Servy.Plugins do
    alias Servy.Conv

    require Logger

    def track(%Conv{status: 404, path: path} = conv) do
        if Mix.env != :test do
            Logger.warn "#{path} is on the loose!"
        end

        conv
    end

    def track(%Conv{ method: method, path: path} = conv) do
        if Mix.env != :test do
            Logger.info "#{method}: #{path}"
        end

        conv
    end

    def rewrite_path(%Conv{path: "/wildlife"} = conv) do
        %{ conv | path: "/wildthings" }
    end

    def rewrite_path(%Conv{path: path} = conv) do
        ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
        |> Regex.named_captures(path)
        |> rewrite_path_captures(conv)
    end

    def rewrite_path(%Conv{} = conv), do: conv

    defp rewrite_path_captures(%{"id" => id, "thing" => thing}, %Conv{} = conv) do
        %{ conv | path: "/#{thing}/#{id}" }
    end

    defp rewrite_path_captures(nil, %Conv{} = conv), do: conv
end