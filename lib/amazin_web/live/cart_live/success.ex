defmodule AmazinWeb.CartLive.Success do
  @moduledoc """
  Success live view.
  """

  use AmazinWeb, :live_view

  alias Amazin.Store

  @impl true
  def mount(_params, session, socket) do
    cart = Store.get_cart(session["cart_id"])

    {:ok, assign(socket, :cart, cart)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 px-6 max-w-2xl mx-auto" id="cart_items" phx-update="stream">
      <h1 class="text-4xl pb-6 font-semibold">You did it!</h1>
      <p>Thanks for your business!</p>
    </div>
    """
  end
end
