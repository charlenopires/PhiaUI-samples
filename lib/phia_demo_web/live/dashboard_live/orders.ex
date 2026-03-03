defmodule PhiaDemoWeb.DashboardLive.Orders do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @impl true
  def mount(_params, _session, socket) do
    orders = FakeData.recent_orders()
    summary = FakeData.order_summary()

    {:ok,
     socket
     |> assign(:page_title, "Pedidos")
     |> assign(:orders, orders)
     |> assign(:pagos, Enum.count(orders, &(&1.status == :pago)))
     |> assign(:pendentes, Enum.count(orders, &(&1.status == :pendente)))
     |> assign(:cancelados, Enum.count(orders, &(&1.status == :cancelado)))
     |> assign(:summary, summary)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/orders">
      <div class="p-6 space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-semibold text-foreground">Pedidos</h1>
            <p class="text-sm text-muted-foreground mt-1">{length(@orders)} pedidos encontrados</p>
          </div>
          <div class="flex items-center gap-2">
            <.button variant={:outline} size={:sm}>Exportar CSV</.button>
            <.button variant={:default} size={:sm}>+ Novo Pedido</.button>
          </div>
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
            description="ticket médio #{@summary.avg_ticket}"
          />
        </.metric_grid>

        <.card>
          <.card_header>
            <.card_title>Todos os Pedidos</.card_title>
            <.card_description>Lista completa de transações</.card_description>
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
                <.table_row :for={o <- @orders} class={row_class(o.status)}>
                  <.table_cell class="font-mono text-xs font-medium">{o.id}</.table_cell>
                  <.table_cell class="font-medium">{o.cliente}</.table_cell>
                  <.table_cell class="text-muted-foreground">{o.produto}</.table_cell>
                  <.table_cell class="font-semibold">{o.valor}</.table_cell>
                  <.table_cell>
                    <.badge variant={status_variant(o.status)}>
                      {status_label(o.status)}
                    </.badge>
                  </.table_cell>
                  <.table_cell class="text-muted-foreground">{o.data}</.table_cell>
                  <.table_cell class="text-right">
                    <.button variant={:ghost} size={:sm}>Ver</.button>
                  </.table_cell>
                </.table_row>
              </.table_body>
            </.table>
          </.card_content>
        </.card>
      </div>
    </DashboardLayout.layout>
    """
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
end
