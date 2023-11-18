defmodule Amazin.Store do
  @moduledoc """
  The Store context.
  """

  import Ecto.Query, warn: false
  alias Amazin.Repo

  alias Amazin.Store.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    result =
      %Product{}
      |> Product.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, new_product} ->
        broadcast_product_event(:product_created, new_product)
        {:ok, new_product}

      error ->
        error
    end
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    result =
      product
      |> Product.changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, updated_product} ->
        broadcast_product_event(:product_updated, updated_product)
        {:ok, updated_product}

      error ->
        error
    end
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  @doc """
  Subscribes you to product events.

  ## Examples

      iex> subscribe_to_product_events()
      :ok

  """
  def subscribe_to_product_events do
    Phoenix.PubSub.subscribe(Amazin.PubSub, "products")
  end

  @doc """
  Broadcast a product event.

  ## Examples

      iex> broadcast_product_event(:product_updated, %Stripe.Product{})
      :ok

  """
  def broadcast_product_event(event, product) do
    Phoenix.PubSub.broadcast(Amazin.PubSub, "products", {event, product})
  end

  alias Amazin.Store.Cart

  @doc """
  Create a cart.

  ## Examples

      iex> create_cart()
      {:ok, %Cart{}}

  """
  def create_cart do
    Repo.insert(%Cart{status: :open})
  end

  @doc """
  Get a cart by id.

  ## Examples

      iex> get_cart(1)
      %Cart{}

  """
  def get_cart(id) do
    Repo.get(Cart, id)
  end

  alias Amazin.Store.CartItem

  @doc """
  List products in a cart.

  ## Examples

      iex> list_cart_items(344)
      [%CartItem{}, %CartItem{}]
  """
  def list_cart_items(cart_id) do
    CartItem
    |> where([ci], ci.cart_id == ^cart_id)
    |> preload(:product)
    |> Repo.all()
  end

  @doc """
  Add a product to a cart. Increments quantity on conflict.

  ## Examples

      iex> add_item_to_cart(1, %Product{})
      {:ok, %Product{}}
  """
  def add_item_to_cart(cart_id, product) do
    Repo.insert(%CartItem{cart_id: cart_id, product: product, quantity: 1},
      conflict_target: [:cart_id, :product_id],
      on_conflict: [inc: [quantity: 1]]
    )
  end

  alias Amazin.Store.Order

  @doc """
  Create an order and complete a cart.

  ## Examples

      iex> crate_order(1)
      {:ok, %Order{}}
  """
  def create_order(cart_id) do
    cart_id
    |> get_cart()
    |> Cart.changeset(%{status: :completed})
    |> Repo.update()

    Repo.insert(%Order{cart_id: cart_id})
  end
end
