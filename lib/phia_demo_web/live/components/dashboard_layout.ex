defmodule PhiaDemoWeb.DashboardLayout do
  @moduledoc "Reusable dashboard shell component with sidebar navigation."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon
  import PhiaUi.Components.DarkModeToggle
  import PhiaUi.Components.Tooltip
  import PhiaUi.Components.Avatar

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <span class="ml-2 font-semibold text-foreground">PhiaUI Demo</span>
        <div class="ml-auto flex items-center gap-3">
          <.dark_mode_toggle id="theme-toggle" />
          <div class="flex items-center gap-2">
            <.avatar size="sm">
              <.avatar_fallback name="Admin Costa" />
            </.avatar>
            <div class="hidden sm:block">
              <p class="text-sm font-medium text-foreground leading-none">Admin Costa</p>
              <p class="text-xs text-muted-foreground mt-0.5">Administrador</p>
            </div>
          </div>
        </div>
      </:topbar>
      <:sidebar>
        <.sidebar>
          <:brand>
            <div class="flex items-center gap-2">
              <div class="flex h-7 w-7 items-center justify-center rounded-md bg-primary text-primary-foreground">
                <.icon name="layers" size={:sm} />
              </div>
              <div>
                <span class="text-sm font-bold text-foreground leading-none">PhiaUI</span>
                <span class="ml-1 text-xs text-muted-foreground">Demo</span>
              </div>
            </div>
          </:brand>
          <:nav_items>
            <.tooltip id="tip-overview" delay_ms={400}>
              <.tooltip_trigger tooltip_id="tip-overview">
                <.sidebar_item href="/" active={@current_path == "/"}>
                  <.icon name="layout-dashboard" size={:sm} class="shrink-0" />
                  Visão Geral
                </.sidebar_item>
              </.tooltip_trigger>
              <.tooltip_content tooltip_id="tip-overview" position={:right}>Visão Geral</.tooltip_content>
            </.tooltip>
            <.tooltip id="tip-analytics" delay_ms={400}>
              <.tooltip_trigger tooltip_id="tip-analytics">
                <.sidebar_item href="/analytics" active={@current_path == "/analytics"}>
                  <.icon name="bar-chart-2" size={:sm} class="shrink-0" />
                  Analytics
                </.sidebar_item>
              </.tooltip_trigger>
              <.tooltip_content tooltip_id="tip-analytics" position={:right}>Analytics</.tooltip_content>
            </.tooltip>
            <.tooltip id="tip-users" delay_ms={400}>
              <.tooltip_trigger tooltip_id="tip-users">
                <.sidebar_item href="/users" active={@current_path == "/users"}>
                  <.icon name="users" size={:sm} class="shrink-0" />
                  Usuários
                </.sidebar_item>
              </.tooltip_trigger>
              <.tooltip_content tooltip_id="tip-users" position={:right}>Usuários</.tooltip_content>
            </.tooltip>
            <.tooltip id="tip-orders" delay_ms={400}>
              <.tooltip_trigger tooltip_id="tip-orders">
                <.sidebar_item href="/orders" active={@current_path == "/orders"}>
                  <.icon name="package" size={:sm} class="shrink-0" />
                  Pedidos
                </.sidebar_item>
              </.tooltip_trigger>
              <.tooltip_content tooltip_id="tip-orders" position={:right}>Pedidos</.tooltip_content>
            </.tooltip>
          </:nav_items>
          <:footer_items>
            <.tooltip id="tip-settings" delay_ms={400}>
              <.tooltip_trigger tooltip_id="tip-settings">
                <.sidebar_item href="#" active={false}>
                  <.icon name="settings" size={:sm} class="shrink-0" />
                  Configurações
                </.sidebar_item>
              </.tooltip_trigger>
              <.tooltip_content tooltip_id="tip-settings" position={:right}>Configurações</.tooltip_content>
            </.tooltip>
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end
end
