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
        <div>
          <h1 class="text-2xl font-semibold text-foreground">Analytics</h1>
          <p class="text-sm text-muted-foreground mt-1">Métricas de tráfego e engajamento</p>
        </div>

        <.alert variant={:default}>
          <.alert_title>Dados atualizados</.alert_title>
          <.alert_description>Última sincronização: 03/03/2026 às 08:00</.alert_description>
        </.alert>

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
      </div>
    </DashboardLayout.layout>
    """
  end
end
