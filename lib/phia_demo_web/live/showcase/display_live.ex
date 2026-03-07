defmodule PhiaDemoWeb.Demo.Showcase.DisplayLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Display — Showcase")
     |> assign(:collapsible_open, false)
     |> assign(:active_tab, "preview")
     |> assign(:selected_plan, "pro")
     |> assign(:bulk_count, 0)}
  end

  @impl true
  def handle_event("collapsible-toggle", _, s), do: {:noreply, update(s, :collapsible_open, &(!&1))}
  def handle_event("tab-select", %{"tab" => tab}, s), do: {:noreply, assign(s, :active_tab, tab)}
  def handle_event("plan-select", %{"plan" => plan}, s), do: {:noreply, assign(s, :selected_plan, plan)}
  def handle_event("bulk-select", %{"n" => n}, s), do: {:noreply, assign(s, :bulk_count, String.to_integer(n))}
  def handle_event("bulk-clear", _, s), do: {:noreply, assign(s, :bulk_count, 0)}
  def handle_event(_, _, s), do: {:noreply, s}

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/display">
      <div class="p-6 space-y-8 max-w-screen-xl mx-auto">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Display</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Visual components for presenting data and content</p>
        </div>

        <%!-- Badge --%>
        <.demo_section title="Badge" subtitle="Status labels and tags in multiple variants and sizes">
          <div class="flex flex-wrap gap-2 items-center">
            <.badge variant={:default}>Default</.badge>
            <.badge variant={:secondary}>Secondary</.badge>
            <.badge variant={:outline}>Outline</.badge>
            <.badge variant={:destructive}>Destructive</.badge>
            <.badge variant={:default} class="bg-green-600/80 text-white">Success</.badge>
            <.badge variant={:secondary} class="bg-amber-100 text-amber-700 border border-amber-300 dark:bg-amber-900/30 dark:text-amber-400">Warning</.badge>
            <.badge variant={:outline} class="text-blue-600 border-blue-300 bg-blue-50 dark:bg-blue-950/30 dark:text-blue-400">Info</.badge>
          </div>
        </.demo_section>

        <%!-- Separator --%>
        <.demo_section title="Separator" subtitle="Horizontal and vertical dividers with decorative/semantic modes">
          <div class="space-y-4">
            <div>
              <p class="text-sm text-foreground mb-2">Horizontal (default)</p>
              <.separator />
            </div>
            <div class="flex items-center gap-4 h-8">
              <span class="text-sm text-foreground">Left</span>
              <.separator orientation="vertical" class="h-full" />
              <span class="text-sm text-foreground">Center</span>
              <.separator orientation="vertical" class="h-full" />
              <span class="text-sm text-foreground">Right</span>
            </div>
            <div class="flex items-center gap-3">
              <.separator class="flex-1" />
              <span class="text-xs text-muted-foreground uppercase tracking-widest px-2">OR</span>
              <.separator class="flex-1" />
            </div>
          </div>
        </.demo_section>

        <%!-- Kbd --%>
        <.demo_section title="Kbd" subtitle="Keyboard shortcut labels with monospaced styling">
          <div class="space-y-3">
            <div class="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
              <span>Save</span>
              <div class="flex items-center gap-0.5">
                <.kbd>⌘</.kbd>
                <.kbd>S</.kbd>
              </div>
            </div>
            <div class="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
              <span>Search</span>
              <div class="flex items-center gap-0.5">
                <.kbd>⌘</.kbd>
                <.kbd>K</.kbd>
              </div>
            </div>
            <div class="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
              <span>Undo</span>
              <div class="flex items-center gap-0.5">
                <.kbd>⌘</.kbd>
                <.kbd>Z</.kbd>
              </div>
            </div>
            <div class="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
              <span>New tab</span>
              <div class="flex items-center gap-0.5">
                <.kbd>Ctrl</.kbd>
                <.kbd>T</.kbd>
              </div>
            </div>
          </div>
        </.demo_section>

        <%!-- Tabs --%>
        <.demo_section title="Tabs" subtitle="Server-side tab switching — default_value sets initial active panel">
          <.tabs :let={ctx} default_value={@active_tab} class="w-full">
              <.tabs_list>
                <.tabs_trigger value="preview" active={ctx.active} phx-click="tab-select" phx-value-tab="preview">
                  <.icon name="eye" size={:xs} class="mr-1.5" /> Preview
                </.tabs_trigger>
                <.tabs_trigger value="code" active={ctx.active} phx-click="tab-select" phx-value-tab="code">
                  <.icon name="code" size={:xs} class="mr-1.5" /> Code
                </.tabs_trigger>
                <.tabs_trigger value="docs" active={ctx.active} phx-click="tab-select" phx-value-tab="docs">
                  <.icon name="list" size={:xs} class="mr-1.5" /> Docs
                </.tabs_trigger>
              </.tabs_list>
              <.tabs_content value="preview" active={ctx.active} class="mt-4">
                <div class="rounded-lg border border-border/60 bg-muted/30 p-6 text-center">
                  <.badge variant={:default}>Live Preview</.badge>
                  <p class="text-sm text-muted-foreground mt-2">Component renders here</p>
                </div>
              </.tabs_content>
              <.tabs_content value="code" active={ctx.active} class="mt-4">
                <pre class="rounded-lg bg-muted/50 p-4 text-xs font-mono text-foreground overflow-x-auto"><code>&lt;.badge variant={:default}&gt;Live Preview&lt;/.badge&gt;</code></pre>
              </.tabs_content>
              <.tabs_content value="docs" active={ctx.active} class="mt-4">
                <div class="space-y-2 text-sm">
                  <p class="text-foreground font-medium">Attributes</p>
                  <div class="space-y-1 text-muted-foreground">
                    <p><code class="font-mono text-xs bg-muted px-1 rounded">variant</code> — :default | :secondary | :outline | :destructive</p>
                    <p><code class="font-mono text-xs bg-muted px-1 rounded">class</code> — additional CSS classes</p>
                  </div>
                </div>
              </.tabs_content>
          </.tabs>
        </.demo_section>

        <%!-- Avatar + AvatarGroup --%>
        <.demo_section title="Avatar & AvatarGroup" subtitle="User initials with fallback and stacked group layouts">
          <div class="space-y-4">
            <div class="flex flex-wrap items-center gap-4">
              <.avatar size="sm"><.avatar_fallback name="Alice" class="bg-primary/10 text-primary text-xs" /></.avatar>
              <.avatar size="default"><.avatar_fallback name="Bob Smith" class="bg-secondary text-secondary-foreground text-sm font-semibold" /></.avatar>
              <.avatar size="lg"><.avatar_fallback name="Carol Jones" class="bg-muted text-muted-foreground text-base font-bold" /></.avatar>
              <.avatar size="xl"><.avatar_fallback name="David Lee" class="bg-destructive/15 text-destructive text-lg font-bold" /></.avatar>
            </div>
            <.separator />
            <div>
              <p class="text-xs text-muted-foreground mb-2">Avatar group (stacked)</p>
              <.avatar_group>
                <%= for {name, color} <- [{"Alice B", "bg-primary/10 text-primary"}, {"Bob C", "bg-secondary text-secondary-foreground"}, {"Carol D", "bg-muted text-muted-foreground"}, {"David E", "bg-destructive/15 text-destructive"}] do %>
                  <.avatar size="sm">
                    <.avatar_fallback name={name} class={"#{color} text-xs font-semibold"} />
                  </.avatar>
                <% end %>
              </.avatar_group>
            </div>
          </div>
        </.demo_section>

        <%!-- Card --%>
        <.demo_section title="Card" subtitle="Composed card with header, content, footer slots">
          <div class="grid gap-4 sm:grid-cols-2">
            <.card>
              <.card_header>
                <.card_title>Simple Card</.card_title>
                <.card_description>Basic card with header and content</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">Card body content goes here. Cards can contain any HTML or component.</p>
              </.card_content>
            </.card>
            <.card>
              <.card_header>
                <.card_title>With Footer</.card_title>
                <.card_description>Card with action footer</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">Card content with a footer below.</p>
              </.card_content>
              <.card_footer class="gap-2">
                <.button variant={:outline} size={:sm}>Cancel</.button>
                <.button variant={:default} size={:sm}>Confirm</.button>
              </.card_footer>
            </.card>
          </div>
        </.demo_section>

        <%!-- SelectableCard --%>
        <.demo_section title="SelectableCard" subtitle="Click-to-select option cards — great for plan pickers and preferences">
          <.selectable_card_group class="grid grid-cols-1 gap-3 sm:grid-cols-3">
            <%= for {val, label, desc, icon} <- [
              {"starter", "Starter", "Up to 5 users · 10 GB", "users"},
              {"pro", "Pro", "Up to 50 users · 100 GB", "zap"},
              {"enterprise", "Enterprise", "Unlimited · Custom", "shield"}
            ] do %>
              <.selectable_card
                value={val}
                selected={@selected_plan == val}
                on_click="plan-select"
                phx-value-plan={val}
              >
                <:icon>
                  <div class={["flex h-8 w-8 items-center justify-center rounded-lg",
                    if(@selected_plan == val, do: "bg-primary text-primary-foreground", else: "bg-muted text-muted-foreground")]}>
                    <.icon name={icon} size={:xs} />
                  </div>
                </:icon>
                <:title>{label}</:title>
                <:description>{desc}</:description>
              </.selectable_card>
            <% end %>
          </.selectable_card_group>
          <p class="text-xs text-muted-foreground mt-3">Selected: <strong class="text-foreground">{@selected_plan}</strong></p>
        </.demo_section>

        <%!-- ReceiptCard --%>
        <.demo_section title="ReceiptCard" subtitle="Order summary card with label/value rows">
          <.receipt_card class="max-w-sm">
            <:header>
              <div class="flex items-center justify-between">
                <div>
                  <p class="font-semibold text-foreground text-sm">Order #1042</p>
                  <p class="text-xs text-muted-foreground">March 6, 2026</p>
                </div>
                <.badge variant={:default} class="bg-green-600/80 text-white text-xs">Paid</.badge>
              </div>
            </:header>
            <:body>
              <.receipt_row label="PhiaUI Pro License" value="$199.00" />
              <.receipt_row label="Additional seat (×3)" value="$45.00" />
              <.receipt_row label="Discount (SUMMER20)" value="-$48.80" />
            </:body>
            <:footer>
              <div class="flex justify-between font-semibold text-sm text-foreground">
                <span>Total</span>
                <span>$195.20</span>
              </div>
            </:footer>
          </.receipt_card>
        </.demo_section>

        <%!-- Timeline --%>
        <.demo_section title="Timeline" subtitle="Vertical event sequence with icons and timestamps">
          <.timeline>
            <.timeline_item timestamp="Just now">
              <:icon>
                <div class="flex h-7 w-7 items-center justify-center rounded-full bg-primary/10 ring-4 ring-background">
                  <.icon name="circle-check" size={:xs} class="text-primary" />
                </div>
              </:icon>
              <p class="text-sm font-semibold text-foreground">Deployment completed</p>
              <p class="text-xs text-muted-foreground mt-0.5">v0.1.3 is live in production</p>
            </.timeline_item>
            <.timeline_item timestamp="2 hours ago">
              <:icon>
                <div class="flex h-7 w-7 items-center justify-center rounded-full bg-muted ring-4 ring-background">
                  <.icon name="code" size={:xs} class="text-muted-foreground" />
                </div>
              </:icon>
              <p class="text-sm font-semibold text-foreground">Build passed</p>
              <p class="text-xs text-muted-foreground mt-0.5">All 142 tests passed</p>
            </.timeline_item>
            <.timeline_item timestamp="5 hours ago">
              <:icon>
                <div class="flex h-7 w-7 items-center justify-center rounded-full bg-warning/10 ring-4 ring-background">
                  <.icon name="triangle-alert" size={:xs} class="text-warning" />
                </div>
              </:icon>
              <p class="text-sm font-semibold text-foreground">Review requested</p>
              <p class="text-xs text-muted-foreground mt-0.5">2 reviewers assigned</p>
            </.timeline_item>
            <.timeline_item timestamp="Yesterday">
              <:icon>
                <div class="flex h-7 w-7 items-center justify-center rounded-full bg-muted ring-4 ring-background">
                  <.icon name="git-branch" size={:xs} class="text-muted-foreground" />
                </div>
              </:icon>
              <p class="text-sm font-semibold text-foreground">Branch created</p>
              <p class="text-xs text-muted-foreground mt-0.5">feat/phia-ui-showcase</p>
            </.timeline_item>
          </.timeline>
        </.demo_section>

        <%!-- ActivityFeed --%>
        <.demo_section title="ActivityFeed" subtitle="Grouped activity log with icons and relative timestamps">
          <.activity_feed>
            <.activity_group label="Today">
              <.activity_item type="task" timestamp="2 min ago">
                <span class="font-medium">Deployment succeeded</span>
                <span class="text-muted-foreground"> — Pushed to production by @admin</span>
              </.activity_item>
              <.activity_item type="mention" timestamp="1 hour ago">
                <span class="font-medium">New member joined</span>
                <span class="text-muted-foreground"> — Carol Davis accepted the invitation</span>
              </.activity_item>
              <.activity_item type="system" timestamp="3 hours ago">
                <span class="font-medium">Settings updated</span>
                <span class="text-muted-foreground"> — Notification preferences changed</span>
              </.activity_item>
            </.activity_group>
            <.activity_group label="Yesterday">
              <.activity_item type="file" timestamp="9 hours ago">
                <span class="font-medium">New order received</span>
                <span class="text-muted-foreground"> — Order #1042 — $195.20</span>
              </.activity_item>
              <.activity_item type="system" timestamp="12 hours ago">
                <span class="font-medium">Build failed</span>
                <span class="text-muted-foreground"> — GitHub Actions — 3 tests failed</span>
              </.activity_item>
            </.activity_group>
          </.activity_feed>
        </.demo_section>

        <%!-- Breadcrumb --%>
        <.demo_section title="Breadcrumb" subtitle="Hierarchical navigation trail with separator and current page">
          <div class="space-y-3">
            <.breadcrumb>
              <.breadcrumb_list>
                <.breadcrumb_item>
                  <.breadcrumb_link href="#" class="flex items-center gap-1">
                    <.icon name="home" size={:xs} /> Home
                  </.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator />
                <.breadcrumb_item>
                  <.breadcrumb_link href="#">Showcase</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator />
                <.breadcrumb_item>
                  <.breadcrumb_page>Display</.breadcrumb_page>
                </.breadcrumb_item>
              </.breadcrumb_list>
            </.breadcrumb>

            <.breadcrumb>
              <.breadcrumb_list>
                <.breadcrumb_item>
                  <.breadcrumb_link href="#">Dashboard</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator />
                <.breadcrumb_item>
                  <.breadcrumb_link href="#">Users</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator />
                <.breadcrumb_item>
                  <.breadcrumb_link href="#">Alice Brown</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator />
                <.breadcrumb_item>
                  <.breadcrumb_page>Edit Profile</.breadcrumb_page>
                </.breadcrumb_item>
              </.breadcrumb_list>
            </.breadcrumb>
          </div>
        </.demo_section>

        <%!-- Collapsible --%>
        <.demo_section title="Collapsible" subtitle="CSS-transition show/hide panel — trigger dispatches JS event, zero round-trip">
          <.collapsible id="showcase-collapsible" open={@collapsible_open}>
            <.collapsible_trigger collapsible_id="showcase-collapsible" open={@collapsible_open}
              phx-click="collapsible-toggle"
              class="flex items-center justify-between w-full px-4 py-3 rounded-lg border border-border hover:bg-accent transition-colors text-sm font-medium text-foreground">
              <span class="flex items-center gap-2">
                <.icon name="chevron-right" size={:xs} class={"transition-transform duration-200#{if @collapsible_open, do: " rotate-90", else: ""}"} />
                Advanced Options
              </span>
              <.badge variant={:outline} class="text-xs">{if @collapsible_open, do: "collapse", else: "expand"}</.badge>
            </.collapsible_trigger>
            <.collapsible_content id="showcase-collapsible-content" open={@collapsible_open} class="mt-2">
              <div class="rounded-lg border border-border/60 bg-muted/30 p-4 space-y-2">
                <p class="text-sm text-foreground font-medium">Advanced settings panel</p>
                <p class="text-xs text-muted-foreground">This content slides in and out with a CSS transition. The open state is server-controlled via phx-click.</p>
                <div class="flex gap-2 mt-3">
                  <.button size={:sm} variant={:outline}>Reset defaults</.button>
                  <.button size={:sm}>Apply</.button>
                </div>
              </div>
            </.collapsible_content>
          </.collapsible>
        </.demo_section>

        <%!-- Skeleton --%>
        <.demo_section title="Skeleton" subtitle="Loading placeholders for deferred content">
          <div class="space-y-4">
            <div class="flex items-center gap-4">
              <.skeleton class="h-12 w-12 rounded-full" />
              <div class="space-y-2 flex-1">
                <.skeleton class="h-4 w-1/2" />
                <.skeleton class="h-3 w-1/3" />
              </div>
            </div>
            <.skeleton class="h-32 w-full rounded-xl" />
            <div class="grid grid-cols-3 gap-3">
              <.skeleton class="h-20 rounded-lg" />
              <.skeleton class="h-20 rounded-lg" />
              <.skeleton class="h-20 rounded-lg" />
            </div>
          </div>
        </.demo_section>

        <%!-- Accordion --%>
        <.demo_section title="Accordion" subtitle="Collapsible sections — single or multiple open at once">
          <.accordion id="showcase-accordion" type={:single}>
            <.accordion_item value="a1" type={:single} accordion_id="showcase-accordion">
              <.accordion_trigger value="a1" type={:single} accordion_id="showcase-accordion">
                What is PhiaUI?
              </.accordion_trigger>
              <.accordion_content value="a1">
                PhiaUI is a Phoenix LiveView component library built on Tailwind CSS v4 with Lucide icons. All components are fully server-rendered with minimal JS.
              </.accordion_content>
            </.accordion_item>
            <.accordion_item value="a2" type={:single} accordion_id="showcase-accordion">
              <.accordion_trigger value="a2" type={:single} accordion_id="showcase-accordion">
                How does dark mode work?
              </.accordion_trigger>
              <.accordion_content value="a2">
                Dark mode toggles the <code class="font-mono bg-muted px-1 rounded text-xs">.dark</code> class on the HTML element. CSS custom properties handle all color overrides — no re-render needed.
              </.accordion_content>
            </.accordion_item>
            <.accordion_item value="a3" type={:single} accordion_id="showcase-accordion">
              <.accordion_trigger value="a3" type={:single} accordion_id="showcase-accordion">
                Is it production-ready?
              </.accordion_trigger>
              <.accordion_content value="a3">
                PhiaUI is actively developed. v0.1.3 is suitable for demos and prototypes. Production apps should pin the version and test thoroughly.
              </.accordion_content>
            </.accordion_item>
          </.accordion>
        </.demo_section>

        <%!-- Table --%>
        <.demo_section title="Table" subtitle="Data table with sortable header, badges and actions">
          <.table>
            <.table_header>
              <.table_row class="hover:bg-transparent">
                <.table_head>Name</.table_head>
                <.table_head>Role</.table_head>
                <.table_head>Status</.table_head>
                <.table_head class="text-right">Joined</.table_head>
              </.table_row>
            </.table_header>
            <.table_body>
              <%= for {name, role, status, joined} <- [
                {"Alice Brown", "Admin", :active, "Jan 2024"},
                {"Bob Chen", "Editor", :active, "Feb 2024"},
                {"Carol Davis", "Viewer", :inactive, "Mar 2024"},
                {"David Evans", "Editor", :pending, "Apr 2024"}
              ] do %>
                <.table_row>
                  <.table_cell class="font-medium">{name}</.table_cell>
                  <.table_cell><.badge variant={:outline} class="text-xs">{role}</.badge></.table_cell>
                  <.table_cell>
                    <.badge variant={if status == :active, do: :default, else: if(status == :inactive, do: :outline, else: :secondary)} class="text-xs">
                      {status |> to_string() |> String.capitalize()}
                    </.badge>
                  </.table_cell>
                  <.table_cell class="text-right text-muted-foreground text-sm">{joined}</.table_cell>
                </.table_row>
              <% end %>
            </.table_body>
          </.table>
        </.demo_section>

        <%!-- Pagination --%>
        <.demo_section title="Pagination" subtitle="Page navigation with prev/next links">
          <.pagination>
            <.pagination_content>
              <.pagination_item>
                <.pagination_previous current_page={3} total_pages={8} on_change="noop" />
              </.pagination_item>
              <%= for p <- [1, 2, 3, 4, 5] do %>
                <.pagination_item>
                  <.pagination_link page={p} current_page={3} on_change="noop">{p}</.pagination_link>
                </.pagination_item>
              <% end %>
              <.pagination_item>
                <.pagination_next current_page={3} total_pages={8} on_change="noop" />
              </.pagination_item>
            </.pagination_content>
          </.pagination>
        </.demo_section>

        <%!-- EmptyState --%>
        <.demo_section title="EmptyState" subtitle="Placeholder for empty collections with CTA">
          <.empty>
            <:icon>
              <div class="flex h-12 w-12 items-center justify-center rounded-full bg-primary/10">
                <.icon name="inbox" class="text-primary" />
              </div>
            </:icon>
            <:title>No results found</:title>
            <:description>Try adjusting your search or filter to find what you're looking for.</:description>
            <:action>
              <.button variant={:default} size={:sm}>Clear filters</.button>
            </:action>
          </.empty>
        </.demo_section>

        <%!-- Icon --%>
        <.demo_section title="Icon" subtitle="Lucide SVG sprite icons — 3 sizes, composable with any component">
          <div class="space-y-4">
            <div class="flex flex-wrap items-center gap-4">
              <%= for name <- ~w(home settings user bell mail search star zap shield package code git-branch) do %>
                <div class="flex flex-col items-center gap-1.5">
                  <.icon name={name} size={:sm} class="text-foreground" />
                  <span class="text-[10px] text-muted-foreground">{name}</span>
                </div>
              <% end %>
            </div>
            <.separator />
            <div class="flex flex-wrap items-center gap-6">
              <div class="flex flex-col items-center gap-1">
                <.icon name="star" size={:xs} class="text-primary" />
                <span class="text-[10px] text-muted-foreground">xs</span>
              </div>
              <div class="flex flex-col items-center gap-1">
                <.icon name="star" size={:sm} class="text-primary" />
                <span class="text-[10px] text-muted-foreground">sm</span>
              </div>
              <div class="flex flex-col items-center gap-1">
                <.icon name="star" class="text-primary" />
                <span class="text-[10px] text-muted-foreground">default</span>
              </div>
              <div class="flex flex-col items-center gap-1">
                <.icon name="star" size={:lg} class="text-primary" />
                <span class="text-[10px] text-muted-foreground">lg</span>
              </div>
            </div>
          </div>
        </.demo_section>

        <%!-- TabsNav + TabsNavItem --%>
        <.demo_section title="TabsNav & TabsNavItem" subtitle="Route-based link tabs in 3 visual variants — underline, pills, segment">
          <div class="space-y-6">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-3">Underline (default)</p>
              <.tabs_nav>
                <.tabs_nav_item href="#" active={true}>Overview</.tabs_nav_item>
                <.tabs_nav_item href="#">Analytics</.tabs_nav_item>
                <.tabs_nav_item href="#">Reports</.tabs_nav_item>
                <.tabs_nav_item href="#" disabled={true}>Billing</.tabs_nav_item>
              </.tabs_nav>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-3">Pills</p>
              <.tabs_nav variant={:pills}>
                <.tabs_nav_item href="#" variant={:pills}>Day</.tabs_nav_item>
                <.tabs_nav_item href="#" variant={:pills} active={true}>Week</.tabs_nav_item>
                <.tabs_nav_item href="#" variant={:pills}>Month</.tabs_nav_item>
                <.tabs_nav_item href="#" variant={:pills}>Year</.tabs_nav_item>
              </.tabs_nav>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-3">Segment</p>
              <.tabs_nav variant={:segment}>
                <.tabs_nav_item href="#" variant={:segment} active={true}>List</.tabs_nav_item>
                <.tabs_nav_item href="#" variant={:segment}>Grid</.tabs_nav_item>
                <.tabs_nav_item href="#" variant={:segment}>Board</.tabs_nav_item>
              </.tabs_nav>
            </div>
          </div>
        </.demo_section>

        <%!-- Tree + TreeItem --%>
        <.demo_section title="Tree & TreeItem" subtitle="Hierarchical data with expand/collapse via native details/summary — zero JS">
          <.tree id="showcase-tree" class="max-w-xs">
            <.tree_item label="lib" expandable={true} expanded={true}>
              <.tree_item label="phia_demo_web" expandable={true} expanded={true}>
                <.tree_item label="live" expandable={true}>
                  <.tree_item label="dashboard" expandable={false} />
                  <.tree_item label="showcase" expandable={false} />
                  <.tree_item label="chat" expandable={false} />
                </.tree_item>
                <.tree_item label="components" expandable={true}>
                  <.tree_item label="layouts" expandable={false} />
                  <.tree_item label="project_nav.ex" expandable={false} />
                </.tree_item>
                <.tree_item label="router.ex" expandable={false} />
              </.tree_item>
              <.tree_item label="phia_demo" expandable={true}>
                <.tree_item label="fake_data.ex" expandable={false} />
              </.tree_item>
            </.tree_item>
            <.tree_item label="mix.exs" expandable={false} />
          </.tree>
        </.demo_section>

        <%!-- Direction --%>
        <.demo_section title="Direction" subtitle="LTR/RTL wrapper — pure HTML dir attribute, no JS">
          <div class="space-y-4">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">LTR</p>
              <.direction dir="ltr">
                <p class="text-sm text-foreground border border-border/60 rounded-lg p-3">Hello, World! — Left to right text direction.</p>
              </.direction>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">RTL (Arabic)</p>
              <.direction dir="rtl">
                <p class="text-sm text-foreground border border-border/60 rounded-lg p-3">مرحبا بالعالم — Right to left text direction.</p>
              </.direction>
            </div>
          </div>
        </.demo_section>

        <%!-- QrCode --%>
        <.demo_section title="QrCode" subtitle="Server-side SVG QR code generation — no JS, no CDN, inline SVG">
          <div class="flex flex-wrap gap-8 items-start">
            <div class="flex flex-col items-center gap-2">
              <.qr_code value="https://github.com/phiaui" size={160} />
              <p class="text-xs text-muted-foreground">Default</p>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.qr_code value="https://hex.pm/packages/phia_ui" size={160} color="#6366f1" background="#f5f3ff" caption="PhiaUI on Hex" />
              <p class="text-xs text-muted-foreground">Custom colors + caption</p>
            </div>
          </div>
        </.demo_section>

        <%!-- Skeleton sub-components --%>
        <.demo_section title="Skeleton variants" subtitle="skeleton_text, skeleton_avatar, skeleton_card — composite loading placeholders">
          <div class="grid gap-6 md:grid-cols-3">
            <div class="space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">skeleton_text</p>
              <.skeleton_text lines={4} />
            </div>
            <div class="space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">skeleton_avatar</p>
              <div class="flex items-center gap-3">
                <.skeleton_avatar size="10" />
                <div class="flex-1"><.skeleton_text lines={2} /></div>
              </div>
            </div>
            <div class="space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">skeleton_card</p>
              <.skeleton_card />
            </div>
          </div>
        </.demo_section>

        <%!-- ScrollArea --%>
        <.demo_section title="ScrollArea" subtitle="Styled overflow container — vertical, horizontal, both orientations">
          <div class="grid gap-6 md:grid-cols-2">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Vertical scroll</p>
              <.scroll_area class="h-40 rounded-md border border-border/60">
                <div class="p-4 space-y-2">
                  <%= for i <- 1..15 do %>
                    <p class="text-sm text-foreground">Item {i} — scroll down to see more</p>
                  <% end %>
                </div>
              </.scroll_area>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Horizontal scroll</p>
              <.scroll_area orientation="horizontal" class="rounded-md border border-border/60">
                <div class="flex gap-3 p-4" style="width: max-content">
                  <%= for {name, color} <- [{"Phoenix", "bg-orange-500"}, {"Elixir", "bg-purple-500"}, {"LiveView", "bg-blue-500"}, {"Tailwind", "bg-sky-500"}, {"Lucide", "bg-green-500"}, {"PhiaUI", "bg-primary"}] do %>
                    <div class={"h-16 w-24 rounded-lg #{color} flex items-center justify-center text-white text-xs font-semibold"}>
                      {name}
                    </div>
                  <% end %>
                </div>
              </.scroll_area>
            </div>
          </div>
        </.demo_section>

        <%!-- AspectRatio --%>
        <.demo_section title="AspectRatio" subtitle="CSS padding-top trick — maintains ratio at any container width">
          <div class="grid gap-6 md:grid-cols-3">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">16:9</p>
              <.aspect_ratio ratio={16 / 9} class="rounded-lg overflow-hidden">
                <div class="w-full h-full bg-gradient-to-br from-violet-500 to-purple-600 flex items-center justify-center text-white text-sm font-semibold">16 / 9</div>
              </.aspect_ratio>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">4:3</p>
              <.aspect_ratio ratio={4 / 3} class="rounded-lg overflow-hidden">
                <div class="w-full h-full bg-gradient-to-br from-sky-500 to-blue-600 flex items-center justify-center text-white text-sm font-semibold">4 / 3</div>
              </.aspect_ratio>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">1:1</p>
              <.aspect_ratio ratio={1.0} class="rounded-lg overflow-hidden">
                <div class="w-full h-full bg-gradient-to-br from-emerald-500 to-green-600 flex items-center justify-center text-white text-sm font-semibold">1 / 1</div>
              </.aspect_ratio>
            </div>
          </div>
        </.demo_section>

      </div>
    </Layout.layout>

    <%!-- BulkActionBar --%>
    <.bulk_action_bar count={@bulk_count} label="{count} item selected" on_clear="bulk-clear">
      <.bulk_action label="Archive" icon="tag" on_click="bulk-clear" />
      <.bulk_action label="Delete" icon="trash-2" variant="destructive" on_click="bulk-clear" />
    </.bulk_action_bar>
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
