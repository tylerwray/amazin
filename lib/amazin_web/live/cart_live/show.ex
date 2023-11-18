defmodule AmazinWeb.CartLive.Show do
  use AmazinWeb, :live_view

  alias Amazin.Store

  @impl true
  def mount(_params, session, socket) do
    cart_items = Store.list_cart_items(session["cart_id"])

    total =
      cart_items
      |> Enum.map(fn ci -> ci.product.amount * ci.quantity end)
      |> Enum.sum()
      |> Money.new()

    socket =
      socket
      |> assign(:cart_id, session["cart_id"])
      |> assign(:total, total)
      |> stream(:cart_items, cart_items)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("checkout", _params, socket) do
    cart_items = Store.list_cart_items(socket.assigns.cart_id)

    line_items =
      Enum.map(cart_items, fn ci ->
        %{
          price_data: %{
            currency: "usd",
            product_data: %{
              name: ci.product.name,
              description: ci.product.description,
              images: [ci.product.thumbnail]
            },
            unit_amount: ci.product.amount
          },
          quantity: ci.quantity
        }
      end)

    {:ok, checkout_session} =
      Stripe.Checkout.Session.create(%{
        line_items: line_items,
        mode: :payment,
        success_url: url(~p"/cart/success"),
        cancel_url: url(~p"/cart"),
        metadata: %{"cart_id" => socket.assigns.cart_id}
      })

    {:noreply, redirect(socket, external: checkout_session.url)}
  end
end
