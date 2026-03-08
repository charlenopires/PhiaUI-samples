defmodule PhiaDemoWeb.Demo.Showcase.Layout do
  @moduledoc "Showcase shell component with sidebar navigation."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon
  import PhiaDemoWeb.ProjectNav

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <.project_topbar current_project={:showcase} dark_mode_id="showcase-dm" />
      </:topbar>
      <:sidebar>
        <.sidebar>
          <:brand>
            <div class="flex items-center gap-2.5">
              <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm">
                <.icon name="puzzle" size={:sm} />
              </div>
              <div>
                <span class="text-sm font-bold text-foreground leading-none">Showcase</span>
                <p class="text-[10px] text-muted-foreground leading-none mt-0.5 font-medium">PhiaUI v0.1.13</p>
              </div>
            </div>
          </:brand>
          <:nav_items>
            <.nav_section label="Core">
              <.nav_item current_path={@current_path} href="/showcase" icon="layout-grid" label="Overview" />
              <.nav_item current_path={@current_path} href="/showcase/inputs" icon="keyboard" label="Inputs" />
              <.nav_item current_path={@current_path} href="/showcase/display" icon="eye" label="Display" />
              <.nav_item current_path={@current_path} href="/showcase/feedback" icon="bell" label="Feedback" />
              <.nav_item current_path={@current_path} href="/showcase/charts" icon="chart-bar" label="Data & Charts" />
              <.nav_item current_path={@current_path} href="/showcase/calendar" icon="calendar" label="Calendar" />
            </.nav_section>
            <.nav_section label="Extended">
              <.nav_item current_path={@current_path} href="/showcase/cards" icon="layers" label="Cards" />
              <.nav_item current_path={@current_path} href="/showcase/navigation" icon="list" label="Navigation" />
              <.nav_item current_path={@current_path} href="/showcase/tables" icon="list-ordered" label="Tables" />
              <.nav_item current_path={@current_path} href="/showcase/upload" icon="upload" label="Upload" />
              <.nav_item current_path={@current_path} href="/showcase/media" icon="image" label="Media" />
              <.nav_item current_path={@current_path} href="/showcase/animation" icon="sparkles" label="Animation" />
              <.nav_item current_path={@current_path} href="/showcase/visual" icon="eye" label="Visual Effects" />
            </.nav_section>
          </:nav_items>
          <:footer_items>
            <div class="px-3 py-1">
              <p class="text-[10px] text-muted-foreground/60 font-medium">PhiaUI &copy; 2026</p>
            </div>
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end

  attr :label, :string, required: true
  slot :inner_block, required: true

  defp nav_section(assigns) do
    ~H"""
    <div class="mb-4">
      <p class="px-3 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
        {@label}
      </p>
      <div class="space-y-0.5">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr :current_path, :string, required: true
  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true

  defp nav_item(assigns) do
    active = assigns.current_path == assigns.href
    assigns = assign(assigns, :active, active)

    ~H"""
    <a
      href={@href}
      class={[
        "group flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition-all duration-150",
        if(@active,
          do: "bg-primary/10 text-primary font-semibold shadow-sm",
          else: "font-medium text-muted-foreground hover:bg-accent hover:text-foreground"
        )
      ]}
    >
      <.icon
        name={@icon}
        size={:sm}
        class={if(@active, do: "shrink-0 text-primary", else: "shrink-0 text-muted-foreground/70 group-hover:text-foreground")}
      />
      {@label}
    </a>
    """
  end
end
