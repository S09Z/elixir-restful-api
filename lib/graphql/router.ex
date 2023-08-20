defmodule Insur3.Graphql.Router do
  use Insur3.Graphql.Helper, :router
  alias Insur3.Graphql.Api

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:api)

    get("/management/health", Api, :healthz)

    forward("/graphql", Absinthe.Plug, schema: Insur3.Graphql.Schema)
  end
end
