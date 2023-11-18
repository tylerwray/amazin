defmodule AmazinWeb.Plugs.SessionCart do
  @moduledoc """
  Plug to ensure an open cart is assigned to the session.
  """
  @behaviour Plug

  import Plug.Conn

  alias Amazin.Store

  @impl true
  def init(default), do: default

  @impl true
  def call(conn, _config) do
    case get_session(conn, :cart_id) do
      nil ->
        {:ok, %{id: cart_id}} = Store.create_cart()
        put_session(conn, :cart_id, cart_id)

      cart_id ->
        case Store.get_cart(cart_id) do
          %{status: :open} ->
            conn

          _cart ->
            {:ok, %{id: cart_id}} = Store.create_cart()
            put_session(conn, :cart_id, cart_id)
        end
    end
  end
end
