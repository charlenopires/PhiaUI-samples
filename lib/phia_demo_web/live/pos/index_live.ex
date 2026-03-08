defmodule PhiaDemoWeb.Demo.Pos.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Pos.Layout

  @products [
    %{id: 1,  name: "Espresso",       category: "Coffee", price: 3.50, emoji: "☕"},
    %{id: 2,  name: "Cappuccino",     category: "Coffee", price: 4.50, emoji: "☕"},
    %{id: 3,  name: "Latte",          category: "Coffee", price: 5.00, emoji: "🥛"},
    %{id: 4,  name: "Americano",      category: "Coffee", price: 3.00, emoji: "☕"},
    %{id: 5,  name: "Cold Brew",      category: "Coffee", price: 5.50, emoji: "🧊"},
    %{id: 6,  name: "Croissant",      category: "Food",   price: 3.50, emoji: "🥐"},
    %{id: 7,  name: "Avocado Toast",  category: "Food",   price: 9.00, emoji: "🥑"},
    %{id: 8,  name: "Blueberry Muffin", category: "Food", price: 4.00, emoji: "🫐"},
    %{id: 9,  name: "Granola Bowl",   category: "Food",   price: 7.50, emoji: "🥣"},
    %{id: 10, name: "Green Tea",      category: "Tea",    price: 3.00, emoji: "🍵"},
    %{id: 11, name: "Chai Latte",     category: "Tea",    price: 4.50, emoji: "🍵"},
    %{id: 12, name: "Mineral Water",  category: "Drinks", price: 2.00, emoji: "💧"}
  ]

  @category_colors %{
    "Coffee" => "bg-amber-100 dark:bg-amber-900/30",
    "Food"   => "bg-green-100 dark:bg-green-900/30",
    "Tea"    => "bg-emerald-100 dark:bg-emerald-900/30",
    "Drinks" => "bg-blue-100 dark:bg-blue-900/30"
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Point of Sale")
     |> assign(:products, @products)
     |> assign(:category_colors, @category_colors)
     |> assign(:cart, [])
     |> assign(:category, "All")
     |> assign(:checkout_open, false)}
  end

  @impl true
  def handle_event("set-category", %{"cat" => cat}, socket) do
    {:noreply, assign(socket, :category, cat)}
  end

  def handle_event("add-to-cart", %{"id" => id}, socket) do
    product_id = String.to_integer(id)
    product = Enum.find(socket.assigns.products, &(&1.id == product_id))
    cart = socket.assigns.cart
    existing = Enum.find(cart, &(&1.product.id == product_id))
    new_cart = if existing,
      do: Enum.map(cart, fn i -> if i.product.id == product_id, do: %{i | qty: i.qty + 1}, else: i end),
      else: cart ++ [%{product: product, qty: 1}]
    {:noreply, assign(socket, :cart, new_cart)}
  end

  def handle_event("remove-from-cart", %{"id" => id}, socket) do
    product_id = String.to_integer(id)
    cart = socket.assigns.cart
    existing = Enum.find(cart, &(&1.product.id == product_id))
    new_cart = cond do
      is_nil(existing) -> cart
      existing.qty == 1 -> Enum.reject(cart, &(&1.product.id == product_id))
      true -> Enum.map(cart, fn i -> if i.product.id == product_id, do: %{i | qty: i.qty - 1}, else: i end)
    end
    {:noreply, assign(socket, :cart, new_cart)}
  end

  def handle_event("clear-cart", _params, socket) do
    {:noreply, assign(socket, :cart, [])}
  end

  def handle_event("checkout", _params, socket) do
    {:noreply, assign(socket, :checkout_open, true)}
  end

  def handle_event("close-checkout", _params, socket) do
    {:noreply, assign(socket, checkout_open: false, cart: [])}
  end

  @impl true
  def render(assigns) do
    categories = ["All" | Enum.uniq(Enum.map(assigns.products, & &1.category))]
    category_colors = assigns[:category_colors] || %{}
    filtered = if assigns.category == "All",
      do: assigns.products,
      else: Enum.filter(assigns.products, &(&1.category == assigns.category))

    subtotal = Enum.reduce(assigns.cart, 0.0, fn i, acc -> acc + i.product.price * i.qty end)
    tax = Float.round(subtotal * 0.08, 2)
    total = Float.round(subtotal + tax, 2)

    assigns = assign(assigns,
      categories: categories,
      category_colors: category_colors,
      filtered: filtered,
      subtotal: subtotal,
      tax: tax,
      total: total
    )

    ~H"""
    <Layout.layout current_path="/pos">
      <div class="flex flex-col lg:flex-row h-full phia-animate">

        <%!-- Products panel --%>
        <div class="flex-1 flex flex-col min-w-0 p-3 sm:p-4 lg:p-5 space-y-4 overflow-auto">
          <%!-- Category filter --%>
          <div class="flex gap-2 flex-wrap">
            <%= for cat <- @categories do %>
              <button
                phx-click="set-category"
                phx-value-cat={cat}
                class={[
                  "rounded-lg px-4 py-2.5 sm:py-2 text-sm font-medium transition-all border min-h-[44px] sm:min-h-0",
                  if(@category == cat,
                    do: "bg-primary text-primary-foreground border-primary shadow-sm",
                    else: "border-border text-muted-foreground hover:border-primary/40 hover:bg-accent"
                  )
                ]}
              >
                {cat}
              </button>
            <% end %>
          </div>

          <%!-- Product grid --%>
          <div class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
            <%= for product <- @filtered do %>
              <% bg = Map.get(@category_colors, product.category, "bg-primary/10") %>
              <button
                phx-click="add-to-cart"
                phx-value-id={product.id}
                class="group flex flex-col items-center gap-3 rounded-2xl border border-border/60 bg-card p-5 shadow-sm hover:shadow-lg hover:border-primary/40 hover:-translate-y-0.5 transition-all duration-200 text-center active:scale-95"
              >
                <div class={"flex h-14 w-14 items-center justify-center rounded-2xl text-2xl transition-all duration-200 group-hover:scale-110 " <> bg}>
                  {product.emoji}
                </div>
                <div>
                  <p class="text-sm font-bold text-foreground">{product.name}</p>
                  <p class="text-[10px] text-muted-foreground uppercase tracking-wide">{product.category}</p>
                </div>
                <p class="text-base font-bold text-primary">${:erlang.float_to_binary(product.price, decimals: 2)}</p>
              </button>
            <% end %>
          </div>
        </div>

        <%!-- Cart panel --%>
        <div class="w-full lg:w-80 shrink-0 border-t lg:border-t-0 lg:border-l border-border/60 flex flex-col bg-card/50">
          <div class="p-4 border-b border-border/60 flex items-center justify-between">
            <div class="flex items-center gap-2">
              <.icon name="shopping-cart" size={:sm} class="text-primary" />
              <h2 class="text-sm font-semibold text-foreground">Cart</h2>
              <.badge :if={@cart != []} variant={:default}>{length(@cart)}</.badge>
            </div>
            <button :if={@cart != []} phx-click="clear-cart" class="text-xs text-muted-foreground hover:text-destructive transition-colors">
              Clear
            </button>
          </div>

          <div class="flex-1 overflow-y-auto p-3 space-y-2">
            <.empty :if={@cart == []} class="py-12">
              <:icon><.icon name="shopping-cart" /></:icon>
              <:title>Cart is empty</:title>
              <:description>Add products to get started</:description>
            </.empty>
            <%= for item <- @cart do %>
              <div class="flex items-center gap-3 rounded-lg border border-border/40 bg-background p-3">
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-medium text-foreground truncate">{item.product.name}</p>
                  <p class="text-xs text-muted-foreground">${:erlang.float_to_binary(item.product.price, decimals: 2)} each</p>
                </div>
                <div class="flex items-center gap-1.5 shrink-0">
                  <button
                    phx-click="remove-from-cart"
                    phx-value-id={item.product.id}
                    class="h-8 w-8 sm:h-7 sm:w-7 flex items-center justify-center rounded border border-border text-muted-foreground hover:border-primary hover:text-primary transition-colors"
                    aria-label={"Decrease quantity of " <> item.product.name}
                  >
                    <.icon name="minus" size={:xs} />
                  </button>
                  <span class="w-6 text-center text-sm font-semibold text-foreground">{item.qty}</span>
                  <button
                    phx-click="add-to-cart"
                    phx-value-id={item.product.id}
                    class="h-8 w-8 sm:h-7 sm:w-7 flex items-center justify-center rounded border border-border text-muted-foreground hover:border-primary hover:text-primary transition-colors"
                    aria-label={"Increase quantity of " <> item.product.name}
                  >
                    <.icon name="plus" size={:xs} />
                  </button>
                </div>
                <span class="text-sm font-semibold text-primary shrink-0 w-12 text-right">
                  ${:erlang.float_to_binary(Float.round(item.product.price * item.qty, 2), decimals: 2)}
                </span>
              </div>
            <% end %>
          </div>

          <%!-- Order summary --%>
          <div :if={@cart != []} class="p-4 border-t border-border/60 space-y-3">
            <div class="space-y-1.5 text-sm">
              <div class="flex justify-between">
                <span class="text-muted-foreground">Subtotal</span>
                <span class="font-medium text-foreground">${:erlang.float_to_binary(@subtotal, decimals: 2)}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-muted-foreground">Tax (8%)</span>
                <span class="font-medium text-foreground">${:erlang.float_to_binary(@tax, decimals: 2)}</span>
              </div>
              <div class="flex justify-between pt-2 border-t border-border/60">
                <span class="font-semibold text-foreground">Total</span>
                <span class="font-bold text-primary text-base">${:erlang.float_to_binary(@total, decimals: 2)}</span>
              </div>
            </div>
            <.button class="w-full" phx-click="checkout">
              <.icon name="circle-check" size={:xs} class="mr-1.5" />
              Checkout · ${:erlang.float_to_binary(@total, decimals: 2)}
            </.button>
          </div>
        </div>

      </div>

      <%!-- Checkout dialog --%>
      <.alert_dialog id="checkout-dialog" open={@checkout_open}>
        <.alert_dialog_header>
          <.alert_dialog_title>Order Complete!</.alert_dialog_title>
          <.alert_dialog_description>Payment processed successfully</.alert_dialog_description>
        </.alert_dialog_header>
        <div class="text-center py-6">
          <div class="flex h-16 w-16 mx-auto items-center justify-center rounded-full bg-green-500/10 mb-4">
            <.icon name="circle-check" size={:sm} class="text-green-500" />
          </div>
          <p class="text-2xl font-bold text-foreground">${:erlang.float_to_binary(@total, decimals: 2)}</p>
          <p class="text-muted-foreground mt-1">Total charged</p>
        </div>
        <.alert_dialog_footer>
          <.alert_dialog_action phx-click="close-checkout" class="w-full">New Order</.alert_dialog_action>
        </.alert_dialog_footer>
      </.alert_dialog>
    </Layout.layout>
    """
  end
end
