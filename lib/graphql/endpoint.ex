defmodule Insur3.Graphql.Endpoint do
  use Phoenix.Endpoint, otp_app: :insur3
  use Absinthe.Phoenix.Endpoint

  @session_options [
    store: :cookie,
    key: "_graphql_key",
    signing_salt: "eHhtSHxD",
    same_site: "Lax"
  ]

  socket("/graphql-ws", Insur3.Graphql.GraphqlWSSocket,
    websocket: [
      path: "",
      subprotocols: ["graphql-transport-ws"],
      compress: true
    ],
    longpoll: false
  )

  plug(Plug.Static,
    at: "/",
    from: :insur3,
    gzip: true
  )

  if code_reloading? do
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Corsica, origins: "*", allow_methods: :all, allow_headers: :all)
  plug(Plug.Session, @session_options)
  plug(Insur3.Graphql.Router)
end
