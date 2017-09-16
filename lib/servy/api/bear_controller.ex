defmodule Servy.Api.BearController do
    @moduledoc """
    It houses the actions that respond to the Bear API routes
    """

    @doc """
    Responds with list of `%Bear{}` in json

    # Examples
        iex> conv = %Servy.Conv{ method: "GET", path: "/api/bears" }
        iex> body = Poison.encode! Servy.Wildthings.bears
        Poison.encode! Servy.Wildthings.bears
        iex> Servy.Api.BearController.index conv
        %Servy.Conv{ conv | resp_body: body, resp_content_type: "application/json", status: 200 }
    """

    def index(conv) do
        json = Servy.Wildthings.bears
        |> Poison.encode!

        %{ conv | status: 200, resp_body: json, resp_content_type: "application/json" }
    end
end