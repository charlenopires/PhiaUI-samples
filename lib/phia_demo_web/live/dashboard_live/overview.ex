defmodule PhiaDemoWeb.DashboardLive.Overview do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Visão Geral")
     |> assign(:stats, FakeData.stats())
     |> assign(:orders, FakeData.recent_orders())
     |> assign(:revenue, FakeData.revenue_by_month())
     |> assign(:top_products, FakeData.top_products())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/">
      <div class="p-6 space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-semibold text-foreground">Visão Geral</h1>
            <p class="text-sm text-muted-foreground mt-1">Resumo do desempenho do mês</p>
          </div>
          <div class="flex items-center gap-2">
            <.badge variant={:outline}>Fev 2026</.badge>
            <span class="text-sm text-muted-foreground">03/03/2026</span>
          </div>
        </div>

        <.metric_grid cols={4}>
          <.stat_card
            :for={s <- @stats}
            title={s.title}
            value={s.value}
            trend={s.trend}
            trend_value={s.trend_value}
            description={s.description}
          />
        </.metric_grid>

        <.chart_shell
          title="Receita Mensal"
          description="Últimos 12 meses"
          period="Mar 2025 – Fev 2026"
          min_height="240px"
        >
          <svg viewBox="0 0 420 210" class="w-full h-full">
            <% max_val = Enum.max(Enum.map(@revenue, & &1.value)) %>
            <%!-- Horizontal grid lines at 25%, 50%, 75% --%>
            <%= for pct <- [0.25, 0.5, 0.75] do %>
              <% y = 170 - trunc(pct * 160) %>
              <line
                x1="0"
                y1={y}
                x2="420"
                y2={y}
                class="stroke-border"
                stroke-width="1"
                stroke-dasharray="4 4"
              />
            <% end %>
            <%= for {item, i} <- Enum.with_index(@revenue) do %>
              <% bar_h = trunc(item.value / max_val * 160) %>
              <% x = i * 35 + 4 %>
              <% y = 170 - bar_h %>
              <% label = "R$#{trunc(item.value / 1000)}k" %>
              <rect x={x} y={y} width="28" height={bar_h} class="fill-primary opacity-80" rx="3" />
              <text
                x={x + 14}
                y={y - 4}
                text-anchor="middle"
                class="fill-muted-foreground"
                style="font-size:8px"
              >
                {label}
              </text>
              <text
                x={x + 14}
                y="190"
                text-anchor="middle"
                class="fill-muted-foreground"
                style="font-size:9px"
              >
                {item.mes}
              </text>
            <% end %>
          </svg>
        </.chart_shell>

        <div class="grid gap-6 lg:grid-cols-2">
          <.card>
            <.card_header>
              <.card_title>Pedidos Recentes</.card_title>
              <.card_description>Últimas 10 transações</.card_description>
            </.card_header>
            <.card_content class="p-0">
              <.table>
                <.table_header>
                  <.table_row>
                    <.table_head>ID</.table_head>
                    <.table_head>Cliente</.table_head>
                    <.table_head>Valor</.table_head>
                    <.table_head>Status</.table_head>
                  </.table_row>
                </.table_header>
                <.table_body>
                  <.table_row :for={o <- @orders}>
                    <.table_cell class="font-mono text-xs">{o.id}</.table_cell>
                    <.table_cell>{o.cliente}</.table_cell>
                    <.table_cell class="font-medium">{o.valor}</.table_cell>
                    <.table_cell><.order_status_badge status={o.status} /></.table_cell>
                  </.table_row>
                </.table_body>
              </.table>
            </.card_content>
          </.card>

          <.card>
            <.card_header>
              <.card_title>Top Produtos</.card_title>
              <.card_description>Por receita no período</.card_description>
            </.card_header>
            <.card_content>
              <div class="space-y-4">
                <%= for p <- @top_products do %>
                  <div class="space-y-1.5">
                    <div class="flex items-center justify-between text-sm">
                      <span class="font-medium text-foreground">{p.name}</span>
                      <span class="text-muted-foreground">{p.revenue}</span>
                    </div>
                    <div class="h-2 w-full rounded-full bg-secondary">
                      <div
                        class="h-2 rounded-full bg-primary"
                        style={"width: #{p.pct}%"}
                      />
                    </div>
                    <p class="text-xs text-muted-foreground">{p.orders} pedidos</p>
                  </div>
                <% end %>
              </div>
            </.card_content>
          </.card>
        </div>
      </div>
    </DashboardLayout.layout>
    """
  end

  defp order_status_badge(assigns) do
    ~H"""
    <.badge variant={status_variant(@status)}>
      {status_label(@status)}
    </.badge>
    """
  end

  defp status_variant(:pago), do: :default
  defp status_variant(:pendente), do: :secondary
  defp status_variant(:cancelado), do: :destructive

  defp status_label(:pago), do: "Pago"
  defp status_label(:pendente), do: "Pendente"
  defp status_label(:cancelado), do: "Cancelado"
end
