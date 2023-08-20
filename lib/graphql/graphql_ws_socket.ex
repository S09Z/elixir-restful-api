defmodule Insur3.Graphql.GraphqlWSSocket do
  use Absinthe.GraphqlWS.Socket,
    schema: Insur3.Graphql.Schema

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil

  @impl Absinthe.GraphqlWS.Socket
  def handle_message(messages, _socket) do
    IO.inspect(messages)
    {:ok, messages}
  end
end
