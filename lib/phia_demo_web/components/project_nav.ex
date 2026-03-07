defmodule PhiaDemoWeb.ProjectNav do
  @moduledoc """
  Cross-project top navigation bar shared across all PhiaUI demo apps.

  Renders a horizontal bar with:
  - PhiaUI logo / home link
  - Project switcher tabs (Dashboard, Showcase, Chat)
  - Optional right-side action slot (e.g. notification bell)
  - Dark mode toggle

  ## Usage

      <.project_topbar current_project={:dashboard} dark_mode_id="dash-dm">
        <:actions>
          <button ...><.icon name="bell" /></button>
        </:actions>
      </.project_topbar>
  """

  use Phoenix.Component

  import PhiaUi.Components.Icon
  import PhiaUi.Components.DarkModeToggle

  @projects [
    %{id: :dashboard, label: "Dashboard", href: "/dashboard", icon: "layout-dashboard"},
    %{id: :showcase, label: "Showcase",   href: "/showcase",  icon: "puzzle"},
    %{id: :chat,     label: "Chat",       href: "/chat",      icon: "message-circle"}
  ]

  attr :current_project, :atom,
    default: nil,
    doc: "Atom identifying which project tab is currently active, or nil for home page"

  attr :dark_mode_id, :string,
    default: "top-dm-toggle",
    doc: "ID for the dark mode toggle — must be unique per page"

  slot :actions,
    doc: "Optional slot for action buttons rendered to the left of the dark mode toggle"

  def project_topbar(assigns) do
    assigns = assign(assigns, :projects, @projects)

    ~H"""
    <div class="flex items-center flex-1 min-w-0 gap-1">
      <%!-- Logo / home --%>
      <a
        href="/"
        class="flex items-center gap-2 shrink-0 rounded-lg px-2 py-1.5 hover:bg-accent transition-colors group"
        aria-label="PhiaUI home"
      >
        <div class="flex h-7 w-7 items-center justify-center rounded-md bg-primary text-primary-foreground shadow-sm shrink-0">
          <.icon name="layers" size={:xs} />
        </div>
        <div class="hidden sm:flex flex-col leading-none gap-px">
          <span class="text-sm font-bold text-foreground leading-none">PhiaUI</span>
          <span class="text-[10px] text-muted-foreground font-medium leading-none">Demos</span>
        </div>
      </a>

      <%!-- Vertical separator --%>
      <div class="hidden sm:block h-5 w-px bg-border/60 mx-1.5 shrink-0" />

      <%!-- Project switcher --%>
      <nav class="flex items-center gap-0.5" aria-label="Demo projects">
        <%= for project <- @projects do %>
          <a
            href={project.href}
            aria-current={if project.id == @current_project, do: "page"}
            class={[
              "relative flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium transition-colors whitespace-nowrap",
              if project.id == @current_project do
                "bg-primary/10 text-primary font-semibold"
              else
                "text-muted-foreground hover:bg-accent hover:text-foreground"
              end
            ]}
          >
            <.icon
              name={project.icon}
              size={:xs}
              class={
                if project.id == @current_project,
                  do: "hidden sm:block shrink-0 transition-colors text-primary",
                  else: "hidden sm:block shrink-0 transition-colors text-muted-foreground/60"
              }
            />
            {project.label}
            <%!-- Active underline indicator --%>
            <span
              :if={project.id == @current_project}
              class="absolute bottom-0 left-1/2 -translate-x-1/2 h-0.5 w-4 rounded-full bg-primary"
            />
          </a>
        <% end %>
      </nav>

      <%!-- Spacer + right-side actions --%>
      <div class="ml-auto flex items-center gap-1.5 shrink-0">
        <%= render_slot(@actions) %>
        <.dark_mode_toggle id={@dark_mode_id} />
      </div>
    </div>
    """
  end
end
