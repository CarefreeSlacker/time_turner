defmodule TimeTurner.Plugs.ParamsToSession do
  @moduledoc """
  The only way to pass params to phoenix live view is via `live "/", OperatorLive, session: [:request_params]`
  This plug fetches request params and put them to session
  """
  import Plug.Conn

  def init(options), do: options

  def call(%{params: params} = conn, _opts) do
    conn
    |> put_session(:request_params, params)
  end
end
