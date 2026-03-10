defmodule PhiaDemoWeb.Demo.Components.ChartsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.Demo.Components.Layout

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
    <Layout.layout current_path="/components/charts">
      <div class="p-3 sm:p-4 lg:p-6 space-y-8 max-w-screen-xl mx-auto phia-animate">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Data & Charts</h1>
          <p class="text-sm text-muted-foreground mt-0.5">ECharts integration, data visualization and table components</p>
        </div>

        <%!-- ═══════════════════════════════════════════════════ --%>
        <%!-- ECharts Section --%>
        <%!-- ═══════════════════════════════════════════════════ --%>

        <div class="flex items-center gap-2 border-b border-border/60 pb-2">
          <.icon name="chart-bar" size={:sm} class="text-primary" />
          <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">ECharts (via phia_chart)</p>
        </div>

        <%!-- Line Chart --%>
        <.demo_section title="Line Chart" subtitle="Interactive line chart with tooltips — powered by Apache ECharts">
          <.phia_chart
            id="showcase-line"
            type={:line}
            series={[
              %{name: "Revenue", data: Enum.map(@revenue, & &1.value)},
              %{name: "Expenses", data: [15200, 14800, 16100, 17500, 16300, 18200, 17800, 19100, 20400, 19800, 21300, 22100]}
            ]}
            labels={Enum.map(@revenue, & &1.month)}
            height="300px"
          />
        </.demo_section>

        <%!-- Area Chart --%>
        <.demo_section title="Area Chart" subtitle="Filled area with gradient — revenue trend">
          <.phia_chart
            id="showcase-area"
            type={:area}
            series={[%{name: "Revenue", data: Enum.map(@revenue, & &1.value)}]}
            labels={Enum.map(@revenue, & &1.month)}
            height="280px"
          />
        </.demo_section>

        <%!-- Bar Chart --%>
        <.demo_section title="Bar Chart" subtitle="Grouped vertical bars — multiple series comparison">
          <.phia_chart
            id="showcase-bar"
            type={:bar}
            series={[
              %{name: "Organic", data: [120, 145, 132, 178, 201, 189]},
              %{name: "Paid", data: [80, 95, 110, 88, 130, 115]},
              %{name: "Referral", data: [30, 28, 45, 52, 40, 55]}
            ]}
            labels={["Jan", "Feb", "Mar", "Apr", "May", "Jun"]}
            height="300px"
          />
        </.demo_section>

        <%!-- Pie / Donut --%>
        <div class="grid gap-6 lg:grid-cols-2">
          <.demo_section title="Pie Chart" subtitle="Traffic distribution by source">
            <.phia_chart
              id="showcase-pie"
              type={:pie}
              series={[%{name: "Traffic", data: Enum.map(@traffic, & &1.value)}]}
              labels={Enum.map(@traffic, & &1.source)}
              height="280px"
            />
          </.demo_section>

          <.demo_section title="Radar Chart" subtitle="Multi-dimensional skill comparison">
            <.phia_chart
              id="showcase-radar"
              type={:line}
              series={[%{name: "Team A", data: [85, 72, 91, 68, 78]}, %{name: "Team B", data: [65, 88, 74, 82, 69]}]}
              labels={["Speed", "Quality", "UX", "Security", "Scale"]}
              height="280px"
            />
          </.demo_section>
        </div>

        <%!-- Pie (Browser Share) + Multi-Series Line side-by-side --%>
        <div class="grid gap-6 lg:grid-cols-2">
          <.demo_section title="Pie Chart (Browser Share)" subtitle="Proportional breakdown — browser market share distribution">
            <.phia_chart
              id="showcase-pie-browsers"
              type={:pie}
              series={[%{name: "Browser Share", data: [64, 18, 12, 4, 2]}]}
              labels={["Chrome", "Safari", "Firefox", "Edge", "Other"]}
              height="280px"
            />
          </.demo_section>

          <.demo_section title="Multi-Series Line" subtitle="Product growth comparison — two lines over the same period">
            <.phia_chart
              id="showcase-multi-line"
              type={:line}
              series={[
                %{name: "Product A", data: [8, 15, 22, 28, 35, 42, 38, 48]},
                %{name: "Product B", data: [12, 18, 25, 30, 28, 35, 42, 50]}
              ]}
              labels={["W1", "W2", "W3", "W4", "W5", "W6", "W7", "W8"]}
              height="300px"
            />
          </.demo_section>
        </div>

        <%!-- Conversion Bar Chart --%>
        <.demo_section title="Bar Chart (Conversion Funnel)" subtitle="Conversion stages — progressive reduction through the pipeline">
          <.phia_chart
            id="showcase-funnel-bar"
            type={:bar}
            series={[%{name: "Conversion", data: [5000, 3800, 2400, 1200, 600]}]}
            labels={["Visitors", "Sign Ups", "Trials", "Paid", "Retained"]}
            height="300px"
          />
        </.demo_section>

        <%!-- Stacked Area Chart --%>
        <.demo_section title="Area Chart (Revenue Breakdown)" subtitle="Stacked area showing cumulative revenue categories over time">
          <.phia_chart
            id="showcase-area-stacked"
            type={:area}
            series={[
              %{name: "Subscriptions", data: [120, 135, 150, 162, 178, 195, 210]},
              %{name: "One-time Sales", data: [30, 25, 45, 20, 60, 35, 50]},
              %{name: "Services", data: [15, 18, 22, 28, 25, 32, 38]}
            ]}
            labels={["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"]}
            height="300px"
          />
        </.demo_section>

        <%!-- Weekly Activity Bar --%>
        <.demo_section title="Bar Chart (Weekly Activity)" subtitle="Multi-series bar — activity breakdown by day of week">
          <.phia_chart
            id="showcase-weekly-bar"
            type={:bar}
            series={[
              %{name: "Commits", data: [12, 19, 15, 22, 18, 8, 3]},
              %{name: "PRs Merged", data: [5, 8, 7, 10, 9, 3, 1]},
              %{name: "Issues Closed", data: [3, 6, 4, 8, 5, 2, 0]}
            ]}
            labels={["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]}
            height="280px"
          />
        </.demo_section>

        <%!-- Market Share Pie --%>
        <.demo_section title="Pie Chart (Market Cap)" subtitle="Proportional market capitalization — top tech companies">
          <.phia_chart
            id="showcase-pie-market"
            type={:pie}
            series={[%{name: "Market Cap", data: [450, 280, 200, 150, 120, 90, 60, 40]}]}
            labels={["Apple", "Microsoft", "Amazon", "Google", "Meta", "Tesla", "Netflix", "Uber"]}
            height="300px"
          />
        </.demo_section>

        <%!-- Distribution Bar --%>
        <.demo_section title="Bar Chart (Distribution)" subtitle="Response time distribution — frequency across time ranges">
          <.phia_chart
            id="showcase-distribution-bar"
            type={:bar}
            series={[%{name: "Response Time (ms)", data: [12, 45, 89, 132, 95, 67, 34, 18, 8, 3]}]}
            labels={["0-50", "50-100", "100-150", "150-200", "200-250", "250-300", "300-350", "350-400", "400-450", "450-500"]}
            height="280px"
          />
        </.demo_section>

        <%!-- ═══════════════════════════════════════════════════ --%>
        <%!-- Specialized Components Section --%>
        <%!-- ═══════════════════════════════════════════════════ --%>

        <div class="flex items-center gap-2 border-b border-border/60 pb-2 mt-4">
          <.icon name="layers" size={:sm} class="text-primary" />
          <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Specialized Components</p>
        </div>

        <%!-- StatCard + MetricGrid --%>
        <.demo_section title="StatCard + MetricGrid" subtitle="KPI cards with trend indicators in a responsive grid">
          <.metric_grid cols={2}>
            <.stat_card :for={s <- Enum.take(@stats, 2)} title={s.title} value={s.value} trend={s.trend} trend_value={s.trend_value} description={s.description} class="border-border/60" />
          </.metric_grid>
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

        <%!-- ═══════════════════════════════════════════════════ --%>
        <%!-- Data Components Section --%>
        <%!-- ═══════════════════════════════════════════════════ --%>

        <div class="flex items-center gap-2 border-b border-border/60 pb-2 mt-4">
          <.icon name="chart-bar" size={:sm} class="text-primary" />
          <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Data Components</p>
        </div>

        <%!-- BarList --%>
        <.demo_section title="BarList" subtitle="Horizontal ranked bars — showing relative values in a category">
          <.bar_list data={[
            %{name: "Google", value: 456},
            %{name: "Direct", value: 351},
            %{name: "Twitter", value: 271},
            %{name: "GitHub", value: 191},
            %{name: "Reddit", value: 91}
          ]} />
        </.demo_section>

        <%!-- CategoryBar --%>
        <.demo_section title="CategoryBar" subtitle="Stacked percentage bar — showing proportional breakdown of a whole">
          <div class="space-y-6">
            <div class="space-y-2">
              <p class="text-sm font-medium text-foreground">Storage Usage</p>
              <.category_bar
                values={[35, 25, 20, 20]}
                colors={[:blue, :green, :orange, :red]}
                labels={["Documents", "Photos", "Videos", "Other"]}
                show_labels={true}
              />
            </div>
            <div class="space-y-2">
              <p class="text-sm font-medium text-foreground">With Marker (Budget — 60% spent)</p>
              <.category_bar
                values={[40, 20, 25, 15]}
                colors={[:blue, :green, :purple, :teal]}
                marker_value={60}
              />
            </div>
          </div>
        </.demo_section>

        <%!-- BadgeDelta --%>
        <.demo_section title="BadgeDelta" subtitle="KPI trend badges with directional icons — 5 delta types">
          <div class="flex flex-wrap gap-3 items-center">
            <.badge_delta value="+12.5%" delta_type={:increase} />
            <.badge_delta value="+3.2%" delta_type={:moderate_increase} />
            <.badge_delta value="0.0%" delta_type={:unchanged} />
            <.badge_delta value="-1.8%" delta_type={:moderate_decrease} />
            <.badge_delta value="-8.4%" delta_type={:decrease} />
          </div>
          <div class="flex flex-wrap gap-3 items-center mt-4">
            <.badge_delta value="+22%" delta_type={:increase} size={:xs} />
            <.badge_delta value="+22%" delta_type={:increase} size={:sm} />
            <.badge_delta value="+22%" delta_type={:increase} size={:default} />
            <.badge_delta value="+22%" delta_type={:increase} size={:lg} />
          </div>
        </.demo_section>

        <%!-- BulletChart --%>
        <.demo_section title="BulletChart" subtitle="SVG bullet gauge with ranges and target marker — compact KPI display">
          <div class="space-y-6">
            <div class="space-y-1">
              <p class="text-sm font-medium text-foreground">Revenue (Target: $280k)</p>
              <.bullet_chart value={245} target={280} max={350} label="$245k" />
            </div>
            <div class="space-y-1">
              <p class="text-sm font-medium text-foreground">Performance Score</p>
              <.bullet_chart value={82} target={90} max={100} ranges={[%{to: 40, color: "red"}, %{to: 70, color: "orange"}, %{to: 100, color: "green"}]} label="82%" />
            </div>
          </div>
        </.demo_section>

        <%!-- MeterGroup --%>
        <.demo_section title="MeterGroup" subtitle="Multiple labeled meters in a collection — resource allocation">
          <.meter_group
            meters={[
              %{label: "Storage", value: 68, max: 100, color: :blue},
              %{label: "Memory", value: 42, max: 100, color: :green},
              %{label: "CPU", value: 87, max: 100, color: :orange},
              %{label: "Network", value: 23, max: 100, color: :purple}
            ]}
            total_label="System Resources"
          />
        </.demo_section>

        <%!-- Leaderboard --%>
        <.demo_section title="Leaderboard" subtitle="Ranked list with medals, metrics, and delta badges">
          <div class="max-w-lg">
            <.leaderboard items={[
              %{rank: 1, name: "Sarah Connor", metric: "2,847 pts", delta: "+124", delta_type: :increase},
              %{rank: 2, name: "John Smith", metric: "2,614 pts", delta: "+89", delta_type: :increase},
              %{rank: 3, name: "Ana Costa", metric: "2,398 pts", delta: "-12", delta_type: :decrease},
              %{rank: 4, name: "Diego Melo", metric: "2,201 pts", delta: "+45", delta_type: :moderate_increase},
              %{rank: 5, name: "Elena Rocha", metric: "1,987 pts", delta: "0", delta_type: :unchanged}
            ]} />
          </div>
        </.demo_section>

        <%!-- Tracker --%>
        <.demo_section title="Tracker" subtitle="Status blocks for time-series monitoring — inspired by Statuspage.io">
          <div class="space-y-4">
            <div class="space-y-1">
              <p class="text-sm font-medium text-foreground">API Gateway — 30 days</p>
              <.tracker data={Enum.map(1..30, fn i ->
                cond do
                  rem(i, 15) == 0 -> %{color: :red, tooltip: "Day #{i}: Outage"}
                  rem(i, 7) == 0 -> %{color: :orange, tooltip: "Day #{i}: Degraded"}
                  true -> %{color: :green, tooltip: "Day #{i}: Operational"}
                end
              end)} />
            </div>
            <div class="space-y-1">
              <p class="text-sm font-medium text-foreground">Database — 30 days</p>
              <.tracker data={Enum.map(1..30, fn _ -> %{color: :green, tooltip: "Operational"} end)} />
            </div>
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
      <div class="rounded-xl border border-border/60 bg-card p-3 sm:p-5 shadow-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
