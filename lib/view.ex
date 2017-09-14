defmodule View do
    @templates_path Path.expand("../templates", __DIR__)

    def render(conv, action, locals) when is_binary(action) and is_list(locals) do
        content =
            @templates_path
            |> Path.join(action <> ".eex")
            |> EEx.eval_file(locals)

        %{ conv | status: 200, resp_body: content }
    end

    def render(conv, status, response) when is_integer(status) and is_binary(response) do
        %{ conv | status: status, resp_body: response }
    end
end