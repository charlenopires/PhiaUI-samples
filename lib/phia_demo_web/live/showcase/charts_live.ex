defmodule PhiaDemoWeb.Demo.Showcase.ChartsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.Demo.Showcase.Layout

  @users [
    %{id: 1, name: "Alice Brown", email: "alice@acme.com", role: "Admin", status: "Active"},
    %{id: 2, name: "Bob Chen", email: "bob@acme.com", role: "Editor", status: "Active"},
    %{id: 3, name: "Carol Davis", email: "carol@acme.com", role: "Viewer", status: "Inactive"},
    %{id: 4, name: "David Evans", email: "david@acme.com", role: "Editor", status: "Active"},
    %{id: 5, name: "Elena Fox", email: "elena@acme.com", role: "Admin", status: "Pending"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Data & Charts — Showcase")
     |> assign(:stats, FakeData.stats())
     |> assign(:revenue, FakeData.revenue_by_month())
     |> assign(:visits, FakeData.visits_by_month())
     |> assign(:traffic, FakeData.traffic_by_source())
     |> assign(:filter_search, "")
     |> assign(:filter_role, "")
     |> assign(:filter_archived, false)
     |> assign(:sort_key, "name")
     |> assign(:sort_dir, :asc)}
  end

  @impl true
  def handle_event("filter-search", %{"value" => v}, s), do: {:noreply, assign(s, :filter_search, v)}
  def handle_event("filter-role", %{"role" => v}, s), do: {:noreply, assign(s, :filter_role, v)}
  def handle_event("filter-archived", %{"archived" => v}, s), do: {:noreply, assign(s, :filter_archived, v == "true")}
  def handle_event("filter-reset", _, s), do: {:noreply, assign(s, filter_search: "", filter_role: "", filter_archived: false)}
  def handle_event("dg-sort", %{"key" => key, "dir" => dir}, s),
    do: {:noreply, assign(s, sort_key: key, sort_dir: String.to_existing_atom(dir))}
  def handle_event(_, _, s), do: {:noreply, s}

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :users, @users)

    ~H"""
    <Layout.layout current_path="/showcase/charts">
      <div class="p-6 space-y-8 max-w-screen-xl mx-auto">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Data & Charts</h1>
          <p class="text-sm text-muted-foreground mt-0.5">SVG charts, data visualization and table components</p>
        </div>

        <%!-- StatCard + MetricGrid --%>
        <.demo_section title="StatCard + MetricGrid" subtitle="KPI cards with trend indicators in a responsive grid">
          <.metric_grid cols={2}>
            <.stat_card :for={s <- Enum.take(@stats, 2)} title={s.title} value={s.value} trend={s.trend} trend_value={s.trend_value} description={s.description} class="border-border/60" />
          </.metric_grid>
        </.demo_section>

        <%!-- Area Chart --%>
        <.demo_section title="Area Chart" subtitle="SVG polygon + polyline with grid lines">
          <.card_header class="p-0 pb-4">
            <div class="flex items-start justify-between">
              <div>
                <.card_title>Monthly Revenue</.card_title>
                <.card_description>Last 12 months</.card_description>
              </div>
              <p class="text-lg font-bold text-foreground">$284,590</p>
            </div>
          </.card_header>
          <% max_val = Enum.max(Enum.map(@revenue, & &1.value)) %>
          <% n = length(@revenue) - 1 %>
          <% pts = Enum.with_index(@revenue) |> Enum.map(fn {item, i} ->
            x = 44.0 + i * (548.0 / n)
            y = 165.0 - item.value / max_val * 135.0
            {Float.round(x, 1), Float.round(y, 1)}
          end) %>
          <% {fx, _} = List.first(pts) %>
          <% {lx, _} = List.last(pts) %>
          <% area_pts = "#{fx},165 " <> Enum.map_join(pts, " ", fn {x, y} -> "#{x},#{y}" end) <> " #{lx},165" %>
          <% line_pts = Enum.map_join(pts, " ", fn {x, y} -> "#{x},#{y}" end) %>
          <svg viewBox="0 0 612 190" class="w-full" style="height:200px">
            <%= for pct <- [0.25, 0.5, 0.75, 1.0] do %>
              <% gy = Float.round(165.0 - pct * 135.0, 1) %>
              <line x1="44" y1={gy} x2="592" y2={gy} class="stroke-border" stroke-width="1" stroke-dasharray="4 3" />
              <text x="38" y={gy + 4} text-anchor="end" class="fill-muted-foreground" style="font-size:9px">
                {trunc(max_val * pct / 1000)}k
              </text>
            <% end %>
            <polygon points={area_pts} class="fill-primary" fill-opacity="0.08" />
            <polyline points={line_pts} class="stroke-primary" fill="none" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" />
            <%= for {x, y} <- pts do %>
              <circle cx={x} cy={y} r="3" class="fill-background stroke-primary" stroke-width="1.5" />
            <% end %>
            <%= for {item, i} <- Enum.with_index(@revenue) do %>
              <% lx2 = Float.round(44.0 + i * (548.0 / n), 1) %>
              <text x={lx2} y="183" text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                {item.month}
              </text>
            <% end %>
          </svg>
        </.demo_section>

        <%!-- Bar Chart --%>
        <.demo_section title="Bar Chart" subtitle="SVG rect-based vertical bars">
          <% bar_data = Enum.take(@revenue, 6) %>
          <% max_bar = Enum.max(Enum.map(bar_data, & &1.value)) %>
          <% chart_h = 160 %>
          <% bar_w = 36 %>
          <% gap = 20 %>
          <% n_bars = length(bar_data) %>
          <% total_w = n_bars * bar_w + (n_bars - 1) * gap + 40 %>
          <svg viewBox={"0 0 #{total_w} #{chart_h + 30}"} class="w-full" style="height:190px">
            <%= for {item, i} <- Enum.with_index(bar_data) do %>
              <% bar_h = Float.round(item.value / max_bar * chart_h, 1) %>
              <% x = 20 + i * (bar_w + gap) %>
              <% y = chart_h - bar_h %>
              <rect x={x} y={y} width={bar_w} height={bar_h} rx="4" class="fill-primary" fill-opacity="0.8" />
              <text x={x + bar_w / 2} y={chart_h + 15} text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                {item.month}
              </text>
              <text x={x + bar_w / 2} y={y - 4} text-anchor="middle" class="fill-primary font-semibold" style="font-size:8px; font-weight:600">
                {trunc(item.value / 1000)}k
              </text>
            <% end %>
          </svg>
        </.demo_section>

        <%!-- Donut Chart --%>
        <.demo_section title="Donut Chart" subtitle="SVG stroke-dasharray technique">
          <div class="flex gap-8 items-center">
            <div class="w-36 h-36 shrink-0">
              <% total = Enum.sum(Enum.map(@traffic, & &1.value)) %>
              <% {_offset, slices} =
                Enum.reduce(@traffic, {0, []}, fn item, {offset, acc} ->
                  pct = item.value / total * 100
                  {offset + pct, [{item, offset, pct} | acc]}
                end) %>
              <svg viewBox="0 0 120 120" class="w-full h-full">
                <%= for {item, offset, pct} <- Enum.reverse(slices) do %>
                  <circle cx="60" cy="60" r="40" fill="none"
                    class={"stroke-current #{String.replace(item.color, "fill-", "text-")}"}
                    stroke-width="20"
                    stroke-dasharray={"#{Float.round(pct * 2.513, 1)} #{100 * 2.513}"}
                    stroke-dashoffset={"-#{Float.round(offset * 2.513, 1)}"}
                    transform="rotate(-90 60 60)"
                  />
                <% end %>
                <text x="60" y="56" text-anchor="middle" class="fill-foreground" style="font-size:12px; font-weight:700">
                  {total}k
                </text>
                <text x="60" y="69" text-anchor="middle" class="fill-muted-foreground" style="font-size:8px">
                  total
                </text>
              </svg>
            </div>
            <ul class="space-y-2 text-sm">
              <%= for item <- @traffic do %>
                <li class="flex items-center justify-between gap-4">
                  <span class="flex items-center gap-2">
                    <span class={"inline-block w-2.5 h-2.5 rounded-full #{item.color}"} />
                    <span class="text-foreground">{item.source}</span>
                  </span>
                  <span class="font-semibold text-muted-foreground">{item.value}%</span>
                </li>
              <% end %>
            </ul>
          </div>
        </.demo_section>

        <%!-- ChartShell --%>
        <.demo_section title="ChartShell" subtitle="Card wrapper for chart content with header metadata">
          <.chart_shell
            title="Monthly Visitors"
            description="Unique visitors per month"
            period="Last 12 months"
            min_height="200px"
          >
            <svg viewBox="0 0 420 200" class="w-full h-full">
              <% max_val = Enum.max(Enum.map(@visits, & &1.value)) %>
              <% n = length(@visits) - 1 %>
              <% coords = Enum.with_index(@visits) |> Enum.map(fn {item, i} ->
                x = Float.round(18.0 + i * (384.0 / n), 1)
                y = Float.round(170.0 - item.value / max_val * 150.0, 1)
                {x, y}
              end) %>
              <% line_pts = Enum.map_join(coords, " ", fn {x, y} -> "#{x},#{y}" end) %>
              <% {fx, _} = List.first(coords) %>
              <% {lx, _} = List.last(coords) %>
              <% area_pts = "#{fx},170 #{line_pts} #{lx},170" %>
              <polygon points={area_pts} class="fill-primary" fill-opacity="0.08" />
              <polyline points={line_pts} class="stroke-primary fill-none" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" />
              <%= for {item, {x, y}} <- Enum.zip(@visits, coords) do %>
                <circle cx={x} cy={y} r="3" class="fill-background stroke-primary" stroke-width="1.5" />
                <text x={x} y="190" text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                  {item.month}
                </text>
              <% end %>
            </svg>
          </.chart_shell>
        </.demo_section>

        <%!-- SparklineCard --%>
        <.demo_section title="SparklineCard" subtitle="Compact metric card with inline SVG sparkline trend">
          <div class="grid gap-4 sm:grid-cols-3">
            <.sparkline_card title="Revenue" value="$33,100" data={[18500, 21300, 19800, 24100, 22700, 26400, 23900, 28600, 31200, 35800, 29400, 33100]} delta="+12.5%" trend={:up} />
            <.sparkline_card title="Active Users" value="12,847" data={[8200, 9100, 9800, 10200, 10900, 11400, 11800, 12100, 12400, 12600, 12700, 12847]} delta="+8.2%" trend={:up} />
            <.sparkline_card title="Bounce Rate" value="32.1%" data={[38, 36, 35, 34, 33, 34, 33, 33, 32, 32, 33, 32]} delta="-2.1%" trend={:down} />
          </div>
        </.demo_section>

        <%!-- GaugeChart --%>
        <.demo_section title="GaugeChart" subtitle="Semi-circular SVG gauge — 5 colors, 3 sizes">
          <div class="flex flex-wrap items-center gap-8">
            <div class="flex flex-col items-center gap-2">
              <.gauge_chart value={78} max={100} label="Health Score" color={:blue} size={:default} />
              <p class="text-xs text-muted-foreground">78 / 100</p>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.gauge_chart value={45} max={100} label="Disk Usage" color={:orange} size={:default} />
              <p class="text-xs text-muted-foreground">45%</p>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.gauge_chart value={92} max={100} label="Uptime" color={:green} size={:default} />
              <p class="text-xs text-muted-foreground">92%</p>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.gauge_chart value={15} max={100} label="Error Rate" color={:red} size={:sm} />
              <p class="text-xs text-muted-foreground">15% (sm)</p>
            </div>
          </div>
        </.demo_section>

        <%!-- UptimeBar --%>
        <.demo_section title="UptimeBar" subtitle="Status bar with colored segments — inspired by Statuspage.io">
          <% uptime_segs = Enum.map(1..90, fn i ->
            status = cond do
              rem(i, 30) == 0 -> :down
              rem(i, 15) == 0 -> :degraded
              true -> :up
            end
            %{status: status, label: "Day #{i}"}
          end) %>
          <div class="space-y-4">
            <div>
              <div class="flex items-center justify-between mb-1">
                <p class="text-sm font-medium text-foreground">API Gateway</p>
              </div>
              <.uptime_bar segments={uptime_segs} days={90} />
            </div>
            <div>
              <div class="flex items-center justify-between mb-1">
                <p class="text-sm font-medium text-foreground">Database</p>
              </div>
              <.uptime_bar segments={Enum.map(1..90, fn _ -> %{status: :up} end)} days={90} />
            </div>
          </div>
        </.demo_section>

        <%!-- FilterBar + sub-components --%>
        <.demo_section title="FilterBar, FilterSearch, FilterSelect, FilterToggle, FilterReset" subtitle="Composable filter toolbar — 5 components: filter_bar + 4 sub-components">
          <div class="space-y-4">
            <.filter_bar>
              <.filter_search placeholder="Search users..." on_search="filter-search" value={@filter_search} />
              <.filter_select
                label="Role"
                name="role"
                options={[{"All roles", ""}, {"Admin", "Admin"}, {"Editor", "Editor"}, {"Viewer", "Viewer"}]}
                value={@filter_role}
                on_change="filter-role"
              />
              <.filter_toggle label="Show inactive" name="archived" checked={@filter_archived} on_change="filter-archived" />
              <.filter_reset on_click="filter-reset" />
            </.filter_bar>
            <p class="text-xs text-muted-foreground">
              Filter: query="{@filter_search}" role="{@filter_role}" archived={@filter_archived}
            </p>
          </div>
        </.demo_section>

        <%!-- DataGrid + sub-components --%>
        <.demo_section title="DataGrid, DataGridHead, DataGridBody, DataGridRow, DataGridCell" subtitle="Feature-rich server-side sortable table — 5 sub-components">
          <.data_grid id="showcase-datagrid" status_message={"#{length(@users)} users"}>
            <thead>
              <tr>
                <.data_grid_head sort_key="name" sort_dir={if @sort_key == "name", do: @sort_dir, else: :none} on_sort="dg-sort">Name</.data_grid_head>
                <.data_grid_head sort_key="email" sort_dir={if @sort_key == "email", do: @sort_dir, else: :none} on_sort="dg-sort">Email</.data_grid_head>
                <.data_grid_head sort_key="role" sort_dir={if @sort_key == "role", do: @sort_dir, else: :none} on_sort="dg-sort">Role</.data_grid_head>
                <.data_grid_head>Status</.data_grid_head>
              </tr>
            </thead>
            <.data_grid_body id="showcase-datagrid-body">
              <.data_grid_row :for={u <- @users} id={"dg-user-#{u.id}"}>
                <.data_grid_cell class="font-medium">{u.name}</.data_grid_cell>
                <.data_grid_cell class="text-muted-foreground">{u.email}</.data_grid_cell>
                <.data_grid_cell><.badge variant={:outline} class="text-xs">{u.role}</.badge></.data_grid_cell>
                <.data_grid_cell>
                  <.badge variant={if u.status == "Active", do: :default, else: :secondary} class="text-xs">{u.status}</.badge>
                </.data_grid_cell>
              </.data_grid_row>
            </.data_grid_body>
          </.data_grid>
        </.demo_section>

        <%!-- Resizable + sub-components --%>
        <.demo_section title="Resizable, ResizablePanel, ResizableHandle" subtitle="Drag-to-resize split panels — 3 sub-components, keyboard accessible">
          <div class="space-y-4">
            <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Horizontal split</p>
            <.resizable class="h-40 rounded-lg border border-border/60 overflow-hidden">
              <.resizable_panel default_size={50} min_size={20}>
                <div class="h-full p-4 bg-muted/30 flex items-center justify-center">
                  <p class="text-sm text-muted-foreground">Left panel — drag the handle</p>
                </div>
              </.resizable_panel>
              <.resizable_handle />
              <.resizable_panel default_size={50} min_size={20}>
                <div class="h-full p-4 flex items-center justify-center">
                  <p class="text-sm text-muted-foreground">Right panel</p>
                </div>
              </.resizable_panel>
            </.resizable>

            <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mt-4">Vertical split</p>
            <.resizable direction="vertical" class="h-40 rounded-lg border border-border/60 overflow-hidden">
              <.resizable_panel default_size={60} min_size={30}>
                <div class="h-full p-4 bg-muted/30 flex items-center justify-center">
                  <p class="text-sm text-muted-foreground">Top panel</p>
                </div>
              </.resizable_panel>
              <.resizable_handle />
              <.resizable_panel default_size={40} min_size={20}>
                <div class="h-full p-4 flex items-center justify-center">
                  <p class="text-sm text-muted-foreground">Bottom panel</p>
                </div>
              </.resizable_panel>
            </.resizable>
          </div>
        </.demo_section>

      </div>
    </Layout.layout>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, required: true
  slot :inner_block, required: true

  defp demo_section(assigns) do
    ~H"""
    <div class="space-y-4">
      <div>
        <h2 class="text-base font-semibold text-foreground">{@title}</h2>
        <p class="text-xs text-muted-foreground mt-0.5">{@subtitle}</p>
      </div>
      <div class="rounded-xl border border-border/60 bg-card p-5 shadow-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
