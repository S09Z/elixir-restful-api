defmodule Insur3.Graphql.Api do
  use Insur3.Graphql.Helper, :controller

  def healthz(conn, _params) do
    send_resp(conn, 200, "OK")
  end
end
