defmodule PhiaDemoWeb.Demo.Dashboard.Orders do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.Demo.Dashboard.Layout

  @page_size 4

  @impl true
  def mount(_params, _session, socket) do
    orders = FakeData.recent_orders()
    summary = FakeData.order_summary()

    {:ok,
     socket
     |> assign(:page_title, "Orders")
     |> assign(:orders, orders)
     |> assign(:status_filter, :all)
     |> assign(:paid_count, Enum.count(orders, &(&1.status == :paid)))
     |> assign(:pending_count, Enum.count(orders, &(&1.status == :pending)))
     |> assign(:cancelled_count, Enum.count(orders, &(&1.status == :cancelled)))
     |> assign(:summary, summary)
     |> assign(:page, 1)
     |> update_filtered_orders()}
  end

  @impl true
  def handle_event("filter-status", %{"status" => status}, socket) do
    atom = String.to_existing_atom(status)
    {:noreply, socket |> assign(:status_filter, atom) |> assign(:page, 1) |> update_filtered_orders()}
  end

  @impl true
  def handle_event("page-changed", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, String.to_integer(page))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/dashboard/orders">
      <div class="p-3 sm:p-4 lg:p-6 space-y-6 max-w-screen-2xl mx-auto">

        <%!-- Header --%>
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 phia-animate">
          <div>
            <h1 class="text-xl font-bold text-foreground tracking-tight">Orders</h1>
            <p class="text-sm text-muted-foreground mt-0.5">{length(@orders)} orders found</p>
          </div>
          <.button_group>
            <.button variant={:outline} size={:sm}>
              <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
              </svg>
              CSV
            </.button>
            <.button variant={:outline} size={:sm}>
              <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              PDF
            </.button>
          </.button_group>
        </div>

        <%!-- Stats --%>
        <.metric_grid cols={4}>
          <.stat_card title="Paid" value={to_string(@paid_count)} trend={:up} trend_value="+3 today" description="paid orders" class="border-border/60 shadow-sm" />
          <.stat_card title="Pending" value={to_string(@pending_count)} trend={:neutral} trend_value="open" description="awaiting payment" class="border-border/60 shadow-sm" />
          <.stat_card title="Cancelled" value={to_string(@cancelled_count)} trend={:down} trend_value="-1 vs yesterday" description="cancelled orders" class="border-border/60 shadow-sm" />
          <.stat_card title="Total Revenue" value={@summary.total_revenue} trend={:up} trend_value="+8.4%" description={"avg ticket #{@summary.avg_ticket}"} class="border-border/60 shadow-sm" />
        </.metric_grid>

        <%!-- Status filter --%>
        <.collapsible id="order-filters">
          <.collapsible_trigger collapsible_id="order-filters"
            class="flex w-full items-center justify-between rounded-lg border bg-card px-4 py-3 text-sm font-medium shadow-sm hover:bg-accent/50 transition-colors">
            <div class="flex items-center gap-2">
              <svg class="h-4 w-4 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z" />
              </svg>
              <span>Filter by Status</span>
            </div>
            <svg class="h-4 w-4 text-muted-foreground transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
          </.collapsible_trigger>
          <.collapsible_content id="order-filters-content">
            <div class="mt-2 rounded-lg border bg-card px-4 py-3 shadow-sm">
              <div class="flex flex-wrap gap-2">
                <%= for {label, val} <- [{"All", :all}, {"Paid", :paid}, {"Pending", :pending}, {"Cancelled", :cancelled}] do %>
                  <button
                    phx-click="filter-status"
                    phx-value-status={val}
                    class={[
                      "inline-flex items-center rounded-md border px-3 py-1 text-xs font-semibold transition-colors min-h-[36px] sm:min-h-0",
                      filter_btn_class(val, @status_filter)
                    ]}
                  >
                    {label}
                  </button>
                <% end %>
              </div>
            </div>
          </.collapsible_content>
        </.collapsible>

        <%!-- Orders table --%>
        <.card class="border-border/60 shadow-sm">
          <.card_header>
            <.card_title>All Orders</.card_title>
            <.card_description>Page {@page} of {@total_pages} — {length(@filtered_orders)} shown</.card_description>
          </.card_header>
          <.card_content class="p-0">
            <.table>
              <.table_header>
                <.table_row class="hover:bg-transparent">
                  <.table_head class="pl-6">ID</.table_head>
                  <.table_head>Customer</.table_head>
                  <.table_head>Product</.table_head>
                  <.table_head>Amount</.table_head>
                  <.table_head>Status</.table_head>
                  <.table_head>Date</.table_head>
                  <.table_head class="text-right pr-6">Actions</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <%= for {o, idx} <- Enum.with_index(page_slice(@filtered_orders, @page)) do %>
                  <% tip_id = "order-status-#{@page}-#{idx}" %>
                  <.table_row>
                    <.table_cell class="pl-6 font-mono text-xs font-semibold text-primary">{o.id}</.table_cell>
                    <.table_cell class="font-semibold text-foreground">{o.customer}</.table_cell>
                    <.table_cell class="text-muted-foreground">{o.product}</.table_cell>
                    <.table_cell class="font-bold">{o.amount}</.table_cell>
                    <.table_cell>
                      <.tooltip id={tip_id} delay_ms={150}>
                        <.tooltip_trigger tooltip_id={tip_id}>
                          <.badge variant={status_variant(o.status)}>{status_label(o.status)}</.badge>
                        </.tooltip_trigger>
                        <.tooltip_content tooltip_id={tip_id} position={:top}>
                          {status_tooltip(o.status)}
                        </.tooltip_content>
                      </.tooltip>
                    </.table_cell>
                    <.table_cell class="text-muted-foreground text-sm">{o.date}</.table_cell>
                    <.table_cell class="text-right pr-6">
                      <button type="button" data-drawer-trigger="order-detail-drawer"
                        class="inline-flex items-center justify-center h-8 px-3 rounded-md text-xs font-medium border border-input bg-background hover:bg-accent hover:text-accent-foreground transition-colors">
                        Details
                      </button>
                    </.table_cell>
                  </.table_row>
                <% end %>
              </.table_body>
            </.table>
          </.card_content>
          <.card_footer class="pt-4">
            <.pagination>
              <.pagination_content>
                <.pagination_item>
                  <.pagination_previous current_page={@page} total_pages={@total_pages} on_change="page-changed" />
                </.pagination_item>
                <%= for p <- 1..@total_pages do %>
                  <.pagination_item>
                    <.pagination_link page={p} current_page={@page} on_change="page-changed">{p}</.pagination_link>
                  </.pagination_item>
                <% end %>
                <.pagination_item>
                  <.pagination_next current_page={@page} total_pages={@total_pages} on_change="page-changed" />
                </.pagination_item>
              </.pagination_content>
            </.pagination>
          </.card_footer>
        </.card>
      </div>

      <%!-- Order Detail Drawer --%>
      <.drawer_content id="order-detail-drawer" open={false} direction="right">
        <.drawer_header>
          <h2 id="order-detail-drawer-title" class="text-lg font-semibold text-foreground">Order Details</h2>
          <p class="text-sm text-muted-foreground mt-1">Full transaction information</p>
        </.drawer_header>
        <.drawer_close />
        <div class="px-6 pb-6 space-y-6">
          <div class="flex items-center justify-between">
            <p class="font-mono text-lg font-bold text-primary">#4521</p>
            <.badge variant={:default}>Paid</.badge>
          </div>
          <div class="space-y-3">
            <h3 class="text-sm font-semibold text-foreground">Information</h3>
            <div class="grid grid-cols-2 gap-3 text-sm">
              <div class="space-y-1"><p class="text-muted-foreground">Customer</p><p class="font-medium">Ana Costa</p></div>
              <div class="space-y-1"><p class="text-muted-foreground">Date</p><p class="font-medium">Mar 1, 2026</p></div>
              <div class="space-y-1"><p class="text-muted-foreground">Product</p><p class="font-medium">Pro Plan</p></div>
              <div class="space-y-1"><p class="text-muted-foreground">Amount</p><p class="font-bold text-primary">$299.00</p></div>
            </div>
          </div>
        </div>
        <.drawer_footer>
          <.button variant={:outline} size={:sm}>Send Receipt</.button>
          <.button variant={:default} size={:sm}>Issue Invoice</.button>
        </.drawer_footer>
      </.drawer_content>
    </Layout.layout>
    """
  end

  defp page_slice(orders, page) do
    orders |> Enum.drop(@page_size * (page - 1)) |> Enum.take(@page_size)
  end

  defp status_variant(:paid), do: :default
  defp status_variant(:pending), do: :secondary
  defp status_variant(:cancelled), do: :destructive

  defp status_label(:paid), do: "Paid"
  defp status_label(:pending), do: "Pending"
  defp status_label(:cancelled), do: "Cancelled"

  defp status_tooltip(:paid), do: "Payment confirmed by gateway"
  defp status_tooltip(:pending), do: "Awaiting payment confirmation"
  defp status_tooltip(:cancelled), do: "Order cancelled — no charge"

  defp update_filtered_orders(socket) do
    filtered =
      case socket.assigns.status_filter do
        :all -> socket.assigns.orders
        status -> Enum.filter(socket.assigns.orders, &(&1.status == status))
      end

    total_pages = max(1, ceil(length(filtered) / @page_size))
    socket |> assign(:filtered_orders, filtered) |> assign(:total_pages, total_pages)
  end

  defp filter_btn_class(val, val) do
    case val do
      :all -> "bg-foreground text-background border-foreground"
      :paid -> "bg-primary text-primary-foreground border-primary"
      :pending -> "bg-secondary text-secondary-foreground border-secondary"
      :cancelled -> "bg-destructive text-destructive-foreground border-destructive"
    end
  end

  defp filter_btn_class(_val, _current) do
    "bg-transparent text-muted-foreground border-border hover:bg-accent hover:text-foreground"
  end
end
