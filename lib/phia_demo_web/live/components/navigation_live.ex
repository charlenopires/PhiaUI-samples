defmodule PhiaDemoWeb.Demo.Components.NavigationLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Components.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Navigation Showcase")
     |> assign(:active_tab, "overview")
     |> assign(:active_step, 2)}
  end

  @impl true
  def handle_event("set-tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def handle_event("set-step", %{"step" => step}, socket) do
    {:noreply, assign(socket, :active_step, String.to_integer(step))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/components/navigation">
      <div class="p-6 space-y-10 max-w-screen-xl mx-auto phia-animate">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Navigation</h1>
          <p class="text-muted-foreground mt-1">Tabs, breadcrumbs, pagination, separators, and step trackers.</p>
        </div>

        <%!-- Breadcrumb --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Breadcrumb</h2>
          <div class="space-y-3">
            <.breadcrumb>
              <.breadcrumb_list>
                <.breadcrumb_item>
                  <.breadcrumb_link href="/">Home</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator />
                <.breadcrumb_item>
                  <.breadcrumb_link href="/components">Components</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator />
                <.breadcrumb_item>
                  <.breadcrumb_page>Navigation</.breadcrumb_page>
                </.breadcrumb_item>
              </.breadcrumb_list>
            </.breadcrumb>

            <.breadcrumb>
              <.breadcrumb_list>
                <.breadcrumb_item>
                  <.breadcrumb_link href="/">PhiaUI</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator>
                  <.icon name="chevron-right" size={:xs} />
                </.breadcrumb_separator>
                <.breadcrumb_item>
                  <.breadcrumb_link href="/components">Components</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator>
                  <.icon name="chevron-right" size={:xs} />
                </.breadcrumb_separator>
                <.breadcrumb_item>
                  <.breadcrumb_link href="/components/navigation">Navigation</.breadcrumb_link>
                </.breadcrumb_item>
                <.breadcrumb_separator>
                  <.icon name="chevron-right" size={:xs} />
                </.breadcrumb_separator>
                <.breadcrumb_item>
                  <.breadcrumb_page>Breadcrumb</.breadcrumb_page>
                </.breadcrumb_item>
              </.breadcrumb_list>
            </.breadcrumb>
          </div>
        </section>

        <%!-- Tabs (server-driven) --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Tabs (Server-driven)</h2>
          <.tabs default_value={@active_tab}>
            <.tabs_list>
              <.tabs_trigger value="overview" phx-click="set-tab" phx-value-tab="overview">Overview</.tabs_trigger>
              <.tabs_trigger value="analytics" phx-click="set-tab" phx-value-tab="analytics">Analytics</.tabs_trigger>
              <.tabs_trigger value="reports" phx-click="set-tab" phx-value-tab="reports">Reports</.tabs_trigger>
              <.tabs_trigger value="settings" phx-click="set-tab" phx-value-tab="settings">Settings</.tabs_trigger>
            </.tabs_list>
            <.tabs_content value="overview">
              <div class="p-4 rounded-lg bg-muted/30 border border-border/60 mt-4">
                <p class="text-sm text-foreground font-medium">Overview Panel</p>
                <p class="text-sm text-muted-foreground mt-1">Content for the overview tab. Tabs manage state via server-side assigns.</p>
              </div>
            </.tabs_content>
            <.tabs_content value="analytics">
              <div class="p-4 rounded-lg bg-muted/30 border border-border/60 mt-4">
                <p class="text-sm text-foreground font-medium">Analytics Panel</p>
                <p class="text-sm text-muted-foreground mt-1">Analytics content goes here. Each tab panel is rendered server-side.</p>
              </div>
            </.tabs_content>
            <.tabs_content value="reports">
              <div class="p-4 rounded-lg bg-muted/30 border border-border/60 mt-4">
                <p class="text-sm text-foreground font-medium">Reports Panel</p>
                <p class="text-sm text-muted-foreground mt-1">Download and schedule reports from this panel.</p>
              </div>
            </.tabs_content>
            <.tabs_content value="settings">
              <div class="p-4 rounded-lg bg-muted/30 border border-border/60 mt-4">
                <p class="text-sm text-foreground font-medium">Settings Panel</p>
                <p class="text-sm text-muted-foreground mt-1">Configure your preferences and account settings.</p>
              </div>
            </.tabs_content>
          </.tabs>
        </section>

        <%!-- TabsNav --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">TabsNav</h2>
          <.tabs_nav>
            <.tabs_nav_item href="#" active={@active_tab == "overview"} phx-click="set-tab" phx-value-tab="overview">Overview</.tabs_nav_item>
            <.tabs_nav_item href="#" active={@active_tab == "analytics"} phx-click="set-tab" phx-value-tab="analytics">Analytics</.tabs_nav_item>
            <.tabs_nav_item href="#" active={@active_tab == "reports"} phx-click="set-tab" phx-value-tab="reports">Reports</.tabs_nav_item>
            <.tabs_nav_item href="#" active={@active_tab == "settings"} phx-click="set-tab" phx-value-tab="settings">Settings</.tabs_nav_item>
          </.tabs_nav>
          <div class="p-4 rounded-lg bg-muted/30 border border-border/60">
            <p class="text-sm text-muted-foreground">Active tab: <strong class="text-foreground">{@active_tab}</strong></p>
          </div>
        </section>

        <%!-- Separator --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Separator</h2>
          <div class="space-y-3 max-w-md">
            <p class="text-sm text-foreground">Content above separator</p>
            <.separator />
            <p class="text-sm text-foreground">Content below separator</p>
            <div class="relative flex items-center">
              <.separator />
              <span class="absolute left-1/2 -translate-x-1/2 bg-background px-2 text-xs text-muted-foreground">Or continue with</span>
            </div>
            <p class="text-sm text-foreground">Content after labeled separator</p>
          </div>
          <div class="flex items-center gap-3 max-w-xs h-5">
            <span class="text-sm text-foreground">Left</span>
            <.separator orientation="vertical" />
            <span class="text-sm text-foreground">Center</span>
            <.separator orientation="vertical" />
            <span class="text-sm text-foreground">Right</span>
          </div>
        </section>

        <%!-- Pagination --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Pagination</h2>
          <div class="space-y-4">
            <.pagination>
              <.pagination_content>
                <.pagination_item>
                  <.pagination_previous current_page={3} total_pages={10} on_change="noop" />
                </.pagination_item>
                <%= for page <- [1, 2, 3, 4, 5] do %>
                  <.pagination_item>
                    <.pagination_link page={page} current_page={3} on_change="noop">{page}</.pagination_link>
                  </.pagination_item>
                <% end %>
                <.pagination_item>
                  <.pagination_next current_page={3} total_pages={10} on_change="noop" />
                </.pagination_item>
              </.pagination_content>
            </.pagination>

            <.pagination>
              <.pagination_content>
                <.pagination_item>
                  <.pagination_previous current_page={1} total_pages={5} on_change="noop" />
                </.pagination_item>
                <%= for page <- [1, 2, 3, 4, 5] do %>
                  <.pagination_item>
                    <.pagination_link page={page} current_page={1} on_change="noop">{page}</.pagination_link>
                  </.pagination_item>
                <% end %>
                <.pagination_item>
                  <.pagination_next current_page={1} total_pages={5} on_change="noop" />
                </.pagination_item>
              </.pagination_content>
            </.pagination>
          </div>
        </section>

        <%!-- StepTracker --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">StepTracker</h2>
          <.step_tracker>
            <.step status={step_status(1, @active_step)} label="Account" description="Your credentials" step={1} />
            <.step status={step_status(2, @active_step)} label="Profile" description="Personal details" step={2} />
            <.step status={step_status(3, @active_step)} label="Plan" description="Choose subscription" step={3} />
            <.step status={step_status(4, @active_step)} label="Payment" description="Billing info" step={4} />
            <.step status={step_status(5, @active_step)} label="Confirm" description="Review & submit" step={5} />
          </.step_tracker>
          <div class="flex gap-2">
            <.button variant={:outline} size={:sm} phx-click="set-step" phx-value-step={max(1, @active_step - 1)} :if={@active_step > 1}>
              Previous
            </.button>
            <.button size={:sm} phx-click="set-step" phx-value-step={min(5, @active_step + 1)} :if={@active_step < 5}>
              Next Step
            </.button>
          </div>
        </section>

        <%!-- Accordion --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Accordion</h2>
          <div class="max-w-2xl">
            <.accordion id="showcase-acc" type={:single}>
              <.accordion_item value="a1" type={:single} accordion_id="showcase-acc">
                <.accordion_trigger value="a1" type={:single} accordion_id="showcase-acc">
                  What is PhiaUI?
                </.accordion_trigger>
                <.accordion_content value="a1">
                  PhiaUI is a comprehensive Phoenix LiveView component library built on Tailwind CSS v4. It provides 623+ components covering all common UI patterns, from basic inputs to complex data visualization.
                </.accordion_content>
              </.accordion_item>
              <.accordion_item value="a2" type={:single} accordion_id="showcase-acc">
                <.accordion_trigger value="a2" type={:single} accordion_id="showcase-acc">
                  How does dark mode work?
                </.accordion_trigger>
                <.accordion_content value="a2">
                  Dark mode is implemented via CSS custom properties and the <code class="font-mono text-xs bg-muted px-1 rounded">.dark</code> class on the HTML element. The <code class="font-mono text-xs bg-muted px-1 rounded">PhiaDarkMode</code> JS hook handles toggling and persists preference to localStorage.
                </.accordion_content>
              </.accordion_item>
              <.accordion_item value="a3" type={:single} accordion_id="showcase-acc">
                <.accordion_trigger value="a3" type={:single} accordion_id="showcase-acc">
                  Can I use it without JavaScript?
                </.accordion_trigger>
                <.accordion_content value="a3">
                  Most components are fully server-rendered and work without JavaScript. Only a subset of interactive components (dialogs, dropdowns, tooltips) require the PhiaUI JS hooks for full functionality.
                </.accordion_content>
              </.accordion_item>
              <.accordion_item value="a4" type={:single} accordion_id="showcase-acc">
                <.accordion_trigger value="a4" type={:single} accordion_id="showcase-acc">
                  Is TypeScript supported?
                </.accordion_trigger>
                <.accordion_content value="a4">
                  PhiaUI targets Elixir/Phoenix projects. TypeScript support comes via LSP and the generated types from Phoenix LiveView. The JS hooks are plain JavaScript files.
                </.accordion_content>
              </.accordion_item>
            </.accordion>
          </div>
        </section>

        <%!-- Kbd --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Kbd</h2>
          <div class="flex flex-wrap gap-3 items-center">
            <.kbd>⌘K</.kbd>
            <.kbd>Ctrl+C</.kbd>
            <.kbd>Shift</.kbd>
            <.kbd>Enter</.kbd>
            <.kbd>Escape</.kbd>
            <.kbd>Tab</.kbd>
            <.kbd>↑ ↓ ← →</.kbd>
          </div>
          <div class="flex items-center gap-2 text-sm text-muted-foreground">
            Press <.kbd>⌘K</.kbd> to open the command palette, or <.kbd>?</.kbd> for help
          </div>
        </section>

        <%!-- BottomNavigation --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">BottomNavigation</h2>
          <p class="text-xs text-muted-foreground">Mobile tab bar — shown inline here instead of fixed to viewport for demo purposes.</p>
          <div class="max-w-sm mx-auto border border-border rounded-xl overflow-hidden">
            <div class="h-32 flex items-center justify-center bg-muted/30">
              <p class="text-sm text-muted-foreground">App content area</p>
            </div>
            <.bottom_navigation
              class="!fixed-none !relative border-t border-border"
              active="home"
              items={[
                %{label: "Home", icon: "home", value: "home"},
                %{label: "Search", icon: "search", value: "search"},
                %{label: "Profile", icon: "user", value: "profile"}
              ]}
            />
          </div>
        </section>

        <%!-- Toolbar --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Toolbar</h2>
          <div class="space-y-4">
            <.toolbar>
              <:item aria_label="Bold" on_click="noop">B</:item>
              <:item aria_label="Italic" on_click="noop">I</:item>
              <:item aria_label="Underline" on_click="noop">U</:item>
              <:separator />
              <:item aria_label="List" on_click="noop">☰</:item>
              <:item aria_label="Link" on_click="noop">🔗</:item>
            </.toolbar>

            <.toolbar variant={:floating}>
              <:item aria_label="Align left" on_click="noop">←</:item>
              <:item aria_label="Align center" on_click="noop">↔</:item>
              <:item aria_label="Align right" on_click="noop">→</:item>
            </.toolbar>
          </div>
        </section>

        <%!-- ChipNav --%>
        <.demo_section title="ChipNav" subtitle="Pill-shaped navigation tabs — compact horizontal navigation">
          <.chip_nav>
            <.chip_nav_item active={true}>All</.chip_nav_item>
            <.chip_nav_item>Active</.chip_nav_item>
            <.chip_nav_item>Completed</.chip_nav_item>
            <.chip_nav_item>Archived</.chip_nav_item>
          </.chip_nav>
        </.demo_section>

        <%!-- DotNavigation --%>
        <.demo_section title="DotNavigation" subtitle="Dot-style page indicators — for carousels or step wizards">
          <div class="flex flex-col items-center gap-4">
            <.dot_navigation>
              <.dot_navigation_item />
              <.dot_navigation_item />
              <.dot_navigation_item active={true} />
              <.dot_navigation_item />
              <.dot_navigation_item />
            </.dot_navigation>
            <p class="text-xs text-muted-foreground">Page 3 of 5</p>
          </div>
        </.demo_section>

        <%!-- LinkGroup --%>
        <.demo_section title="LinkGroup" subtitle="Grouped link list — common for footer navigation or sidebars">
          <div class="grid gap-6 sm:grid-cols-3">
            <.link_group>
              <.link_group_heading>Product</.link_group_heading>
              <.link_group_item href="#">Features</.link_group_item>
              <.link_group_item href="#">Pricing</.link_group_item>
              <.link_group_item href="#">Changelog</.link_group_item>
              <.link_group_item href="#">Roadmap</.link_group_item>
            </.link_group>
            <.link_group>
              <.link_group_heading>Company</.link_group_heading>
              <.link_group_item href="#">About</.link_group_item>
              <.link_group_item href="#">Blog</.link_group_item>
              <.link_group_item href="#">Careers</.link_group_item>
              <.link_group_item href="#">Contact</.link_group_item>
            </.link_group>
            <.link_group>
              <.link_group_heading>Legal</.link_group_heading>
              <.link_group_item href="#">Privacy</.link_group_item>
              <.link_group_item href="#">Terms</.link_group_item>
              <.link_group_item href="#">License</.link_group_item>
            </.link_group>
          </div>
        </.demo_section>

        <%!-- Toc --%>
        <.demo_section title="Toc" subtitle="Table of contents — auto-generates from heading hierarchy">
          <div class="max-w-sm">
            <.toc id="showcase-toc">
              <.toc_item id="intro" depth={1}>Introduction</.toc_item>
              <.toc_item id="getting-started" depth={2}>Getting Started</.toc_item>
              <.toc_item id="installation" depth={3}>Installation</.toc_item>
              <.toc_item id="configuration" depth={3}>Configuration</.toc_item>
              <.toc_item id="components" depth={2}>Components</.toc_item>
              <.toc_item id="buttons" depth={3}>Buttons</.toc_item>
              <.toc_item id="inputs" depth={3}>Inputs</.toc_item>
              <.toc_item id="advanced" depth={2}>Advanced Usage</.toc_item>
            </.toc>
          </div>
        </.demo_section>

      </div>
    </Layout.layout>
    """
  end

  defp step_status(step_num, active) when step_num < active, do: "complete"
  defp step_status(step_num, active) when step_num == active, do: "active"
  defp step_status(_step_num, _active), do: "upcoming"

  attr :title, :string, required: true
  attr :subtitle, :string, required: true
  slot :inner_block, required: true

  defp demo_section(assigns) do
    ~H"""
    <section class="space-y-4">
      <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">{@title}</h2>
      <p class="text-xs text-muted-foreground -mt-2">{@subtitle}</p>
      <div class="rounded-xl border border-border/60 bg-card p-3 sm:p-5 shadow-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </section>
    """
  end
end
