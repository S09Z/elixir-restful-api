defmodule ElixirRestfulapiBoilerplate.Repo do
  use Ecto.Repo,
    otp_app: :elixir_restfulapi_boilerplate,
    adapter: Ecto.Adapters.Postgres
end
