defmodule PhiaDemoWeb.DashboardLive.Orders do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @page_size 4

  @impl true
  def mount(_params, _session, socket) do
    orders = FakeData.recent_orders()
    summary = FakeData.order_summary()
    total_pages = max(1, ceil(length(orders) / @page_size))

    {:ok,
     socket
     |> assign(:page_title, "Pedidos")
     |> assign(:orders, orders)
     |> assign(:pagos, Enum.count(orders, &(&1.status == :pago)))
     |> assign(:pendentes, Enum.count(orders, &(&1.status == :pendente)))
     |> assign(:cancelados, Enum.count(orders, &(&1.status == :cancelado)))
     |> assign(:summary, summary)
     |> assign(:page, 1)
     |> assign(:total_pages, total_pages)}
  end

  @impl true
  def handle_event("page-changed", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, String.to_integer(page))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/orders">
      <div class="p-6 space-y-6">
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Pedidos</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-semibold text-foreground">Pedidos</h1>
            <p class="text-sm text-muted-foreground mt-1">{length(@orders)} pedidos encontrados</p>
          </div>
          <%!-- Button Group --%>
          <.button_group>
            <.button variant={:outline} size={:sm}>Exportar CSV</.button>
            <.button variant={:outline} size={:sm}>Exportar PDF</.button>
          </.button_group>
        </div>

        <.metric_grid cols={4}>
          <.stat_card
            title="Pagos"
            value={to_string(@pagos)}
            trend={:up}
            trend_value="+3 hoje"
            description="pedidos pagos"
          />
          <.stat_card
            title="Pendentes"
            value={to_string(@pendentes)}
            trend={:neutral}
            trend_value="em aberto"
            description="aguardando pagamento"
          />
          <.stat_card
            title="Cancelados"
            value={to_string(@cancelados)}
            trend={:down}
            trend_value="-1 vs ontem"
            description="pedidos cancelados"
          />
          <.stat_card
            title="Receita Total"
            value={@summary.total_revenue}
            trend={:up}
            trend_value="+8,4%"
            description={"ticket médio #{@summary.avg_ticket}"}
          />
        </.metric_grid>

        <%!-- Collapsible status filters --%>
        <.collapsible id="order-filters">
          <.collapsible_trigger collapsible_id="order-filters" class="flex w-full items-center justify-between rounded-lg border bg-card px-4 py-3 text-sm font-medium shadow-sm hover:bg-accent/50 transition-colors">
            <span>Filtrar por Status</span>
            <svg class="h-4 w-4 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
          </.collapsible_trigger>
          <.collapsible_content id="order-filters-content">
            <div class="mt-2 rounded-lg border bg-card px-4 py-3 shadow-sm">
              <div class="flex flex-wrap gap-2">
                <.badge variant={:outline} class="cursor-pointer hover:bg-accent transition-colors">Todos</.badge>
                <.badge variant={:default} class="cursor-pointer">Pago</.badge>
                <.badge variant={:secondary} class="cursor-pointer">Pendente</.badge>
                <.badge variant={:destructive} class="cursor-pointer">Cancelado</.badge>
              </div>
            </div>
          </.collapsible_content>
        </.collapsible>

        <.card>
          <.card_header>
            <.card_title>Todos os Pedidos</.card_title>
            <.card_description>Página {@page} de {@total_pages}</.card_description>
          </.card_header>
          <.card_content class="p-0">
            <.table>
              <.table_header>
                <.table_row>
                  <.table_head>ID</.table_head>
                  <.table_head>Cliente</.table_head>
                  <.table_head>Produto</.table_head>
                  <.table_head>Valor</.table_head>
                  <.table_head>Status</.table_head>
                  <.table_head>Data</.table_head>
                  <.table_head class="text-right">Ações</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <%= for {o, idx} <- Enum.with_index(page_slice(@orders, @page)) do %>
                  <% tip_id = "order-status-#{@page}-#{idx}" %>
                  <.table_row class={row_class(o.status)}>
                    <.table_cell class="font-mono text-xs font-medium">{o.id}</.table_cell>
                    <.table_cell class="font-medium">{o.cliente}</.table_cell>
                    <.table_cell class="text-muted-foreground">{o.produto}</.table_cell>
                    <.table_cell class="font-semibold">{o.valor}</.table_cell>
                    <.table_cell>
                      <.tooltip id={tip_id} delay_ms={150}>
                        <.tooltip_trigger tooltip_id={tip_id}>
                          <.badge variant={status_variant(o.status)}>
                            {status_label(o.status)}
                          </.badge>
                        </.tooltip_trigger>
                        <.tooltip_content tooltip_id={tip_id} position={:top}>
                          {status_tooltip(o.status)}
                        </.tooltip_content>
                      </.tooltip>
                    </.table_cell>
                    <.table_cell class="text-muted-foreground">{o.data}</.table_cell>
                    <.table_cell class="text-right">
                      <.button variant={:ghost} size={:sm}>Ver</.button>
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
                  <.pagination_previous
                    current_page={@page}
                    total_pages={@total_pages}
                    on_change="page-changed"
                  />
                </.pagination_item>
                <%= for p <- 1..@total_pages do %>
                  <.pagination_item>
                    <.pagination_link page={p} current_page={@page} on_change="page-changed">
                      {p}
                    </.pagination_link>
                  </.pagination_item>
                <% end %>
                <.pagination_item>
                  <.pagination_next
                    current_page={@page}
                    total_pages={@total_pages}
                    on_change="page-changed"
                  />
                </.pagination_item>
              </.pagination_content>
            </.pagination>
          </.card_footer>
        </.card>
      </div>
    </DashboardLayout.layout>
    """
  end

  defp page_slice(orders, page) do
    orders
    |> Enum.drop(@page_size * (page - 1))
    |> Enum.take(@page_size)
  end

  defp row_class(:pago), do: "border-l-2 border-l-primary"
  defp row_class(:pendente), do: "border-l-2 border-l-muted-foreground"
  defp row_class(:cancelado), do: "border-l-2 border-l-destructive"

  defp status_variant(:pago), do: :default
  defp status_variant(:pendente), do: :secondary
  defp status_variant(:cancelado), do: :destructive

  defp status_label(:pago), do: "Pago"
  defp status_label(:pendente), do: "Pendente"
  defp status_label(:cancelado), do: "Cancelado"

  defp status_tooltip(:pago), do: "Pagamento confirmado"
  defp status_tooltip(:pendente), do: "Aguardando pagamento"
  defp status_tooltip(:cancelado), do: "Pedido cancelado"
end
