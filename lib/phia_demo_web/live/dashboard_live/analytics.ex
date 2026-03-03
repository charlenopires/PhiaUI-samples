defmodule PhiaDemoWeb.DashboardLive.Analytics do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Analytics")
     |> assign(:stats, FakeData.analytics_stats())
     |> assign(:visits, FakeData.visits_by_month())
     |> assign(:traffic, FakeData.traffic_by_source())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/analytics">
      <div class="p-6 space-y-6">
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Analytics</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <div>
          <h1 class="text-2xl font-semibold text-foreground">Analytics</h1>
          <p class="text-sm text-muted-foreground mt-1">Métricas de tráfego e engajamento</p>
        </div>

        <.alert variant={:default}>
          <.alert_title>Dados atualizados</.alert_title>
          <.alert_description>Última sincronização: 03/03/2026 às 08:00</.alert_description>
        </.alert>

        <%!-- Collapsible filters --%>
        <.collapsible id="analytics-filters">
          <.collapsible_trigger collapsible_id="analytics-filters" class="flex w-full items-center justify-between rounded-lg border bg-card px-4 py-3 text-sm font-medium shadow-sm hover:bg-accent/50 transition-colors">
            <span>Filtros de Período</span>
            <svg class="h-4 w-4 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
          </.collapsible_trigger>
          <.collapsible_content id="analytics-filters-content">
            <div class="mt-2 rounded-lg border bg-card px-4 py-3 shadow-sm">
              <div class="flex flex-wrap gap-2">
                <.button variant={:default} size={:sm}>Últimos 7 dias</.button>
                <.button variant={:outline} size={:sm}>Últimos 30 dias</.button>
                <.button variant={:outline} size={:sm}>Últimos 90 dias</.button>
                <.button variant={:outline} size={:sm}>Este ano</.button>
              </div>
            </div>
          </.collapsible_content>
        </.collapsible>

        <.metric_grid cols={3}>
          <.stat_card
            :for={s <- @stats}
            title={s.title}
            value={s.value}
            trend={s.trend}
            trend_value={s.trend_value}
            description={s.description}
          />
        </.metric_grid>

        <div class="grid gap-6 lg:grid-cols-2">
          <.chart_shell
            title="Visitas Mensais"
            description="Visitantes únicos por mês"
            period="Últimos 12 meses"
            min_height="220px"
          >
            <svg viewBox="0 0 420 200" class="w-full h-full">
              <% max_val = Enum.max(Enum.map(@visits, & &1.value)) %>
              <% coords =
                @visits
                |> Enum.with_index()
                |> Enum.map(fn {item, i} ->
                  x = i * 35 + 18
                  y = 170 - trunc(item.value / max_val * 160)
                  {x, y}
                end) %>
              <% points = Enum.map_join(coords, " ", fn {x, y} -> "#{x},#{y}" end) %>
              <%!-- Area fill polygon: close path along the bottom --%>
              <% {first_x, _} = List.first(coords) %>
              <% {last_x, _} = List.last(coords) %>
              <% area_points = "#{first_x},170 #{points} #{last_x},170" %>
              <polygon
                points={area_points}
                class="fill-primary opacity-20"
              />
              <polyline
                points={points}
                class="stroke-primary fill-none"
                stroke-width="2.5"
                stroke-linejoin="round"
                stroke-linecap="round"
              />
              <%= for {item, {x, y}} <- Enum.zip(@visits, coords) do %>
                <circle cx={x} cy={y} r="3.5" class="fill-primary" />
                <text x={x} y="190" text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                  {item.mes}
                </text>
              <% end %>
            </svg>
          </.chart_shell>

          <.chart_shell
            title="Fonte de Tráfego"
            description="Distribuição por canal de aquisição"
            min_height="220px"
          >
            <div class="flex gap-6 items-center h-full py-2">
              <div class="relative w-32 h-32 shrink-0">
                <svg viewBox="0 0 120 120" class="w-full h-full">
                  <% total = Enum.sum(Enum.map(@traffic, & &1.value)) %>
                  <% {_offset, slices} =
                    Enum.reduce(@traffic, {0, []}, fn item, {offset, acc} ->
                      pct = item.value / total * 100
                      {offset + pct, [{item, offset, pct} | acc]}
                    end) %>
                  <%= for {item, offset, pct} <- Enum.reverse(slices) do %>
                    <circle
                      cx="60"
                      cy="60"
                      r="40"
                      fill="none"
                      class={"stroke-current #{String.replace(item.color, "fill-", "text-")}"}
                      stroke-width="20"
                      stroke-dasharray={"#{pct * 2.513} #{100 * 2.513}"}
                      stroke-dashoffset={"-#{offset * 2.513}"}
                      transform="rotate(-90 60 60)"
                    />
                  <% end %>
                  <text
                    x="60"
                    y="56"
                    text-anchor="middle"
                    class="fill-foreground"
                    style="font-size:11px; font-weight:600"
                  >
                    {total}k
                  </text>
                  <text
                    x="60"
                    y="69"
                    text-anchor="middle"
                    class="fill-muted-foreground"
                    style="font-size:8px"
                  >
                    visitas
                  </text>
                </svg>
              </div>
              <ul class="space-y-2 text-sm flex-1">
                <%= for item <- @traffic do %>
                  <li class="flex items-center justify-between gap-2">
                    <span class="flex items-center gap-2">
                      <span class={"inline-block w-2.5 h-2.5 rounded-full #{item.color}"} />
                      <span class="text-foreground">{item.source}</span>
                    </span>
                    <span class="font-medium text-muted-foreground">{item.value}%</span>
                  </li>
                <% end %>
              </ul>
            </div>
          </.chart_shell>
        </div>

        <.card>
          <.card_header>
            <.card_title>Conversão por Canal</.card_title>
            <.card_description>Taxa de conversão relativa por fonte de tráfego</.card_description>
          </.card_header>
          <.card_content>
            <div class="space-y-4">
              <%= for {item, conv} <- Enum.zip(@traffic, [5.2, 3.8, 2.1, 7.4, 1.3]) do %>
                <div class="space-y-1">
                  <div class="flex justify-between text-sm">
                    <span class="text-foreground">{item.source}</span>
                    <span class="font-medium text-muted-foreground">{conv}%</span>
                  </div>
                  <div class="h-2 w-full rounded-full bg-secondary">
                    <div
                      class="h-2 rounded-full bg-primary"
                      style={"width: #{Float.round(conv / 8 * 100, 1)}%"}
                    />
                  </div>
                </div>
              <% end %>
            </div>
          </.card_content>
        </.card>

        <%!-- Empty state demo --%>
        <.card>
          <.card_header>
            <.card_title>Dados por Canal</.card_title>
            <.card_description>Detalhamento do canal selecionado nos filtros</.card_description>
          </.card_header>
          <.card_content>
            <.empty>
              <:icon>
                <div class="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                  <svg
                    class="h-6 w-6 text-muted-foreground"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    stroke-width="1.5"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75zM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625zM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z"
                    />
                  </svg>
                </div>
              </:icon>
              <:title>Sem dados para exibir</:title>
              <:description>
                Selecione um canal nos filtros de período acima para visualizar o detalhamento.
              </:description>
              <:action>
                <.button variant={:outline} size={:sm}>Abrir Filtros</.button>
              </:action>
            </.empty>
          </.card_content>
        </.card>
      </div>
    </DashboardLayout.layout>
    """
  end
end
