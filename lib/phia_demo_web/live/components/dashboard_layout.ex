defmodule PhiaDemoWeb.DashboardLayout do
  @moduledoc "Reusable dashboard shell component with sidebar navigation."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <span class="ml-2 font-semibold text-foreground">PhiaUI Demo</span>
        <div class="ml-auto flex items-center gap-3">
          <div class="flex items-center gap-2">
            <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-primary text-primary-foreground text-xs font-semibold">
              AC
            </div>
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
            <.sidebar_item href="/" active={@current_path == "/"}>
              <.icon name="layout-dashboard" size={:sm} class="shrink-0" />
              Visão Geral
            </.sidebar_item>
            <.sidebar_item href="/analytics" active={@current_path == "/analytics"}>
              <.icon name="bar-chart-2" size={:sm} class="shrink-0" />
              Analytics
            </.sidebar_item>
            <.sidebar_item href="/users" active={@current_path == "/users"}>
              <.icon name="users" size={:sm} class="shrink-0" />
              Usuários
            </.sidebar_item>
            <.sidebar_item href="/orders" active={@current_path == "/orders"}>
              <.icon name="package" size={:sm} class="shrink-0" />
              Pedidos
            </.sidebar_item>
          </:nav_items>
          <:footer_items>
            <.sidebar_item href="#" active={false}>
              <.icon name="settings" size={:sm} class="shrink-0" />
              Configurações
            </.sidebar_item>
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end
end
