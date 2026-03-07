defmodule PhiaDemoWeb.Demo.Dashboard.Layout do
  @moduledoc "Dashboard shell component with sidebar navigation."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon
  import PhiaUi.Components.Avatar
  import PhiaDemoWeb.ProjectNav

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <.project_topbar current_project={:dashboard} dark_mode_id="dash-dm">
          <:actions>
            <button
              class="relative p-2 rounded-lg text-muted-foreground hover:bg-accent hover:text-foreground transition-colors"
              aria-label="Notifications"
            >
              <.icon name="bell" size={:sm} />
              <span class="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-primary ring-2 ring-background" />
            </button>
          </:actions>
        </.project_topbar>
      </:topbar>
      <:sidebar>
        <.sidebar>
          <:brand>
            <div class="flex items-center gap-2.5">
              <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm">
                <.icon name="layers" size={:sm} />
              </div>
              <div>
                <span class="text-sm font-bold text-foreground leading-none">PhiaUI</span>
                <p class="text-[10px] text-muted-foreground leading-none mt-0.5 font-medium">v0.1.3 · Dashboard</p>
              </div>
            </div>
          </:brand>
          <:nav_items>
            <.nav_section label="Dashboard">
              <.nav_item current_path={@current_path} href="/dashboard" icon="layout-dashboard" label="Overview" />
              <.nav_item current_path={@current_path} href="/dashboard/analytics" icon="chart-bar" label="Analytics" />
              <.nav_item current_path={@current_path} href="/dashboard/users" icon="users" label="Users" />
              <.nav_item current_path={@current_path} href="/dashboard/orders" icon="package" label="Orders" badge={5} />
              <.nav_item current_path={@current_path} href="/dashboard/settings" icon="sliders-horizontal" label="Settings" />
            </.nav_section>
          </:nav_items>
          <:footer_items>
            <.user_card />
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end

  # ── Private: section label ─────────────────────────────────────────────────

  attr :label, :string, required: true
  slot :inner_block, required: true

  defp nav_section(assigns) do
    ~H"""
    <div class="mb-4">
      <p class="px-3 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50">
        {@label}
      </p>
      <div class="space-y-0.5">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  # ── Private: single nav item ───────────────────────────────────────────────

  attr :current_path, :string, required: true
  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true
  attr :badge, :integer, default: nil

  defp nav_item(assigns) do
    active = assigns.current_path == assigns.href
    assigns = assign(assigns, :active, active)

    ~H"""
    <a
      href={@href}
      class={[
        "group relative flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition-all duration-150",
        if(@active,
          do: "bg-primary/10 text-primary font-semibold",
          else: "font-medium text-muted-foreground hover:bg-accent hover:text-foreground"
        )
      ]}
    >
      <%!-- Active indicator: thin vertical bar on left edge --%>
      <span
        :if={@active}
        class="absolute left-0 top-1/2 -translate-y-1/2 h-5 w-0.5 rounded-r-full bg-primary"
      />
      <.icon
        name={@icon}
        size={:sm}
        class={if(@active, do: "shrink-0 text-primary", else: "shrink-0 text-muted-foreground/60 group-hover:text-foreground")}
      />
      <span class="flex-1">{@label}</span>
      <span
        :if={@badge}
        class="ml-auto flex h-5 min-w-5 items-center justify-center rounded-full bg-primary/15 px-1.5 text-[10px] font-semibold text-primary tabular-nums"
      >
        {@badge}
      </span>
    </a>
    """
  end

  # ── Private: sidebar footer user card ─────────────────────────────────────

  defp user_card(assigns) do
    ~H"""
    <div class="group flex items-center gap-2.5 rounded-lg px-3 py-2 hover:bg-accent transition-colors cursor-default">
      <.avatar size="sm" class="ring-2 ring-primary/20 shrink-0">
        <.avatar_fallback name="Admin User" class="bg-primary/10 text-primary text-xs font-semibold" />
      </.avatar>
      <div class="flex-1 min-w-0">
        <p class="text-sm font-semibold text-foreground leading-none truncate">Admin User</p>
        <p class="text-xs text-muted-foreground mt-0.5 truncate">admin@phiaui.dev</p>
      </div>
      <div class="flex items-center gap-0.5 shrink-0 opacity-0 group-hover:opacity-100 transition-opacity">
        <a
          href="/dashboard/settings"
          class="p-1.5 rounded-md hover:bg-primary/10 hover:text-primary text-muted-foreground/60 transition-colors"
          aria-label="Settings"
        >
          <.icon name="settings" size={:xs} />
        </a>
        <button
          class="p-1.5 rounded-md hover:bg-destructive/10 hover:text-destructive text-muted-foreground/60 transition-colors"
          aria-label="Log out"
        >
          <.icon name="log-out" size={:xs} />
        </button>
      </div>
    </div>
    """
  end
end
