defmodule AmazinWeb.ProductLive.Index do
  use AmazinWeb, :live_view

  alias Amazin.Store
  alias Amazin.Store.Product

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Store.subscribe_to_product_events()

    {:ok, stream(socket, :products, Store.list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Store.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "All Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({AmazinWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_info({:product_updated, updated_product}, socket) do
    {:noreply, stream_insert(socket, :products, updated_product)}
  end

  @impl true
  def handle_info({:product_created, created_product}, socket) do
    {:noreply, stream_insert(socket, :products, created_product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Store.get_product!(id)
    {:ok, _} = Store.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
