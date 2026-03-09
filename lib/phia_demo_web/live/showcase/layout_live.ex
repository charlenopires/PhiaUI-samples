defmodule PhiaDemoWeb.Demo.Showcase.LayoutLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Layout — Showcase")}
  end

  @impl true
  def handle_event(_, _, s), do: {:noreply, s}

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/layout">
      <div class="p-3 sm:p-4 lg:p-6 space-y-8 max-w-screen-xl mx-auto phia-animate">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Layout</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Responsive layout primitives — Box, Stack, Flex, Grid, Container and more</p>
        </div>

        <%!-- Stack --%>
        <.demo_section title="Stack" subtitle="Vertical/horizontal flex container with gap — responsive direction support">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-2">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Vertical (default)</p>
              <.stack gap={3} class="p-4 rounded-lg border border-border/60 bg-muted/20">
                <div class="h-10 rounded-md bg-primary/20 flex items-center justify-center text-xs font-medium text-primary">Item 1</div>
                <div class="h-10 rounded-md bg-primary/20 flex items-center justify-center text-xs font-medium text-primary">Item 2</div>
                <div class="h-10 rounded-md bg-primary/20 flex items-center justify-center text-xs font-medium text-primary">Item 3</div>
              </.stack>
            </div>
            <div class="space-y-2">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Horizontal</p>
              <.stack direction={:horizontal} gap={3} class="p-4 rounded-lg border border-border/60 bg-muted/20">
                <div class="h-10 flex-1 rounded-md bg-primary/20 flex items-center justify-center text-xs font-medium text-primary">Item 1</div>
                <div class="h-10 flex-1 rounded-md bg-primary/20 flex items-center justify-center text-xs font-medium text-primary">Item 2</div>
                <div class="h-10 flex-1 rounded-md bg-primary/20 flex items-center justify-center text-xs font-medium text-primary">Item 3</div>
              </.stack>
            </div>
          </div>
        </.demo_section>

        <%!-- Flex --%>
        <.demo_section title="Flex" subtitle="Full flexbox control — direction, wrap, gap, align, justify">
          <div class="space-y-4">
            <.flex gap={3} wrap={:wrap} class="p-4 rounded-lg border border-border/60 bg-muted/20">
              <div :for={i <- 1..8} class="h-12 w-20 rounded-md bg-primary/20 flex items-center justify-center text-xs font-medium text-primary">
                {i}
              </div>
            </.flex>
            <.flex justify={:between} align={:center} class="p-4 rounded-lg border border-border/60 bg-muted/20">
              <div class="text-sm font-medium text-foreground">Left aligned</div>
              <div class="text-sm text-muted-foreground">Center</div>
              <div class="text-sm font-medium text-foreground">Right aligned</div>
            </.flex>
          </div>
        </.demo_section>

        <%!-- Grid --%>
        <.demo_section title="Grid" subtitle="CSS Grid with responsive columns — supports 1–12 cols with gap control">
          <div class="space-y-4">
            <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Responsive: 1 → 2 → 4 cols</p>
            <.grid cols={%{base: 1, sm: 2, lg: 4}} gap={3}>
              <div :for={i <- 1..8} class="h-16 rounded-md bg-primary/10 border border-primary/20 flex items-center justify-center text-xs font-medium text-primary">
                Cell {i}
              </div>
            </.grid>
          </div>
        </.demo_section>

        <%!-- SimpleGrid --%>
        <.demo_section title="SimpleGrid" subtitle="Simplified grid — auto-calculates columns from min child width">
          <.simple_grid cols={3} gap={4}>
            <.card class="border-border/60 shadow-sm">
              <.card_content class="p-4">
                <p class="text-sm font-medium text-foreground">Card A</p>
                <p class="text-xs text-muted-foreground mt-1">SimpleGrid auto-distributes cards evenly</p>
              </.card_content>
            </.card>
            <.card class="border-border/60 shadow-sm">
              <.card_content class="p-4">
                <p class="text-sm font-medium text-foreground">Card B</p>
                <p class="text-xs text-muted-foreground mt-1">Responsive columns via breakpoint map</p>
              </.card_content>
            </.card>
            <.card class="border-border/60 shadow-sm">
              <.card_content class="p-4">
                <p class="text-sm font-medium text-foreground">Card C</p>
                <p class="text-xs text-muted-foreground mt-1">Consistent gap between all items</p>
              </.card_content>
            </.card>
          </.simple_grid>
        </.demo_section>

        <%!-- Center --%>
        <.demo_section title="Center" subtitle="Centering utility — horizontally and/or vertically center content">
          <.center class="h-32 rounded-lg border border-border/60 bg-muted/20">
            <div class="text-center">
              <p class="text-sm font-medium text-foreground">Centered content</p>
              <p class="text-xs text-muted-foreground">Both axes</p>
            </div>
          </.center>
        </.demo_section>

        <%!-- Container --%>
        <.demo_section title="Container" subtitle="Max-width wrapper for page content — responsive padding included">
          <.container class="rounded-lg border border-border/60 bg-muted/20 p-4">
            <p class="text-sm text-muted-foreground">Content is centered within a max-width container with responsive horizontal padding.</p>
          </.container>
        </.demo_section>

        <%!-- Wrap --%>
        <.demo_section title="Wrap" subtitle="Flex-wrap container with gap — items flow to next line automatically">
          <.wrap gap={2} class="p-4 rounded-lg border border-border/60 bg-muted/20">
            <.badge :for={tech <- ["Elixir", "Phoenix", "LiveView", "Tailwind", "Rust", "TypeScript", "React", "Svelte", "Vue", "Go"]} variant={:secondary}>
              {tech}
            </.badge>
          </.wrap>
        </.demo_section>

        <%!-- Spacer --%>
        <.demo_section title="Spacer" subtitle="Flexible space filler — pushes siblings apart in flex containers">
          <.flex align={:center} class="p-4 rounded-lg border border-border/60 bg-muted/20">
            <.icon name="layers" size={:sm} class="text-primary" />
            <span class="text-sm font-semibold text-foreground ml-2">PhiaUI</span>
            <.spacer />
            <.button variant={:outline} size={:sm}>Settings</.button>
            <.button size={:sm}>Upgrade</.button>
          </.flex>
        </.demo_section>

        <%!-- DescriptionList --%>
        <.demo_section title="DescriptionList" subtitle="Key-value pairs — common for detail/settings views">
          <.description_list>
            <.dl_item>
              <:term>Full Name</:term>
              <:description>Ana Costa</:description>
            </.dl_item>
            <.dl_item>
              <:term>Email</:term>
              <:description>ana@phiaui.dev</:description>
            </.dl_item>
            <.dl_item>
              <:term>Role</:term>
              <:description>Frontend Engineer</:description>
            </.dl_item>
            <.dl_item>
              <:term>Status</:term>
              <:description><.badge variant={:default} class="text-xs">Active</.badge></:description>
            </.dl_item>
            <.dl_item>
              <:term>Joined</:term>
              <:description>March 2025</:description>
            </.dl_item>
          </.description_list>
        </.demo_section>

        <%!-- PageHeader --%>
        <.demo_section title="PageHeader" subtitle="Page title + description + optional actions — common pattern for admin pages">
          <.page_header>
            <:title>Team Members</:title>
            <:description>Manage your organization's team members and their roles.</:description>
            <:actions>
              <.button variant={:outline} size={:sm}>Export</.button>
              <.button size={:sm}>
                <.icon name="plus" size={:xs} class="mr-1" /> Invite
              </.button>
            </:actions>
          </.page_header>
        </.demo_section>

        <%!-- Section --%>
        <.demo_section title="Section" subtitle="Content section with title, description, and optional footer">
          <.section size={:sm}>
            <h3 class="text-sm font-semibold text-foreground">Notification Preferences</h3>
            <p class="text-xs text-muted-foreground mt-1">Choose how you want to be notified about updates.</p>
            <div class="space-y-3 mt-3">
              <div class="flex items-center justify-between">
                <span class="text-sm text-foreground">Email notifications</span>
                <.switch checked={true} />
              </div>
              <div class="flex items-center justify-between">
                <span class="text-sm text-foreground">Push notifications</span>
                <.switch checked={false} />
              </div>
            </div>
          </.section>
        </.demo_section>

        <%!-- MediaObject --%>
        <.demo_section title="MediaObject" subtitle="Classic media object pattern — image/icon alongside text content">
          <div class="space-y-4">
            <.media_object>
              <:media>
                <.avatar size="lg">
                  <.avatar_fallback name="Ana Costa" class="bg-primary/10 text-primary font-semibold" />
                </.avatar>
              </:media>
              <p class="font-semibold text-foreground">Ana Costa</p>
              <p class="text-sm text-muted-foreground">Frontend Engineer at PhiaUI. Building beautiful interfaces with Elixir and LiveView.</p>
            </.media_object>
            <.separator />
            <.media_object>
              <:media>
                <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-green-500/10">
                  <.icon name="circle-check" size={:sm} class="text-green-600 dark:text-green-400" />
                </div>
              </:media>
              <p class="font-semibold text-foreground">Deployment Successful</p>
              <p class="text-sm text-muted-foreground">v0.1.15 deployed to production 2 minutes ago.</p>
            </.media_object>
          </div>
        </.demo_section>

        <%!-- SplitLayout --%>
        <.demo_section title="SplitLayout" subtitle="Two-column split layout — sidebar + main content area">
          <.split_layout class="h-40 rounded-lg border border-border/60 overflow-hidden">
            <:pane>
              <div class="bg-muted/30 p-4 h-full">
                <p class="text-sm font-medium text-foreground">Sidebar</p>
                <p class="text-xs text-muted-foreground mt-1">Navigation or filters</p>
              </div>
            </:pane>
            <div class="p-4">
              <p class="text-sm font-medium text-foreground">Main Content</p>
              <p class="text-xs text-muted-foreground mt-1">Primary content area</p>
            </div>
          </.split_layout>
        </.demo_section>

        <%!-- ResponsiveStack --%>
        <.demo_section title="ResponsiveStack" subtitle="Stack that switches from vertical to horizontal at a breakpoint">
          <.responsive_stack class="p-4 rounded-lg border border-border/60 bg-muted/20">
            <div class="h-16 flex-1 rounded-md bg-blue-500/10 flex items-center justify-center text-xs font-medium text-blue-600 dark:text-blue-400">Panel A</div>
            <div class="h-16 flex-1 rounded-md bg-green-500/10 flex items-center justify-center text-xs font-medium text-green-600 dark:text-green-400">Panel B</div>
            <div class="h-16 flex-1 rounded-md bg-purple-500/10 flex items-center justify-center text-xs font-medium text-purple-600 dark:text-purple-400">Panel C</div>
          </.responsive_stack>
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
