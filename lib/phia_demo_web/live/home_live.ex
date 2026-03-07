defmodule PhiaDemoWeb.HomeLive do
  use PhiaDemoWeb, :live_view

  import PhiaDemoWeb.ProjectNav

  @themes [
    %{id: "violet", label: "Violet", color: "oklch(0.555 0.235 268)"},
    %{id: "blue",   label: "Blue",   color: "oklch(0.55 0.20 240)"},
    %{id: "green",  label: "Green",  color: "oklch(0.53 0.17 145)"},
    %{id: "rose",   label: "Rose",   color: "oklch(0.60 0.22 15)"},
    %{id: "amber",  label: "Amber",  color: "oklch(0.65 0.18 55)"},
    %{id: "slate",  label: "Slate",  color: "oklch(0.42 0.03 250)"}
  ]

  @projects [
    %{
      id: :dashboard,
      title: "Dashboard",
      href: "/dashboard",
      icon: "layout-dashboard",
      desc: "Admin panel with metrics, tables, SVG charts, and a full sidebar navigation."
    },
    %{
      id: :showcase,
      title: "Showcase",
      href: "/showcase",
      icon: "puzzle",
      desc: "Gallery of all PhiaUI components — inputs, overlays, feedback, and much more."
    },
    %{
      id: :chat,
      title: "Chat",
      href: "/chat",
      icon: "message-circle",
      desc: "Real-time sales chat with multiple rooms, agents, and interactive messages."
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "PhiaUI Demos")
     |> assign(:current_theme, "violet")
     |> assign(:themes, @themes)
     |> assign(:projects, @projects)}
  end

  @impl true
  def handle_event("set-theme", %{"theme" => theme}, socket) do
    {:noreply,
     socket
     |> assign(:current_theme, theme)
     |> push_event("phx:set-color-theme", %{theme: theme})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-background text-foreground">
      <%!-- Top navigation bar --%>
      <header class="sticky top-0 z-40 flex h-14 items-center border-b border-border/60 bg-background/95 px-4">
        <.project_topbar current_project={nil} dark_mode_id="home-dm" />
      </header>

      <%!-- Hero --%>
      <section class="px-6 pt-16 pb-10 max-w-4xl mx-auto text-center">
        <div class="inline-flex items-center gap-1.5 rounded-full border border-primary/30 bg-primary/10 px-3 py-1 text-xs font-semibold text-primary mb-6">
          <.icon name="layers" size={:xs} />
          PhiaUI v0.1.5
        </div>
        <h1 class="text-4xl sm:text-5xl font-bold tracking-tight text-foreground mb-4">
          Component Library Demos
        </h1>
        <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
          Three complete Phoenix LiveView applications built with PhiaUI —
          a Tailwind v4 component library with dynamic theming and dark mode.
        </p>
      </section>

      <%!-- Theme picker --%>
      <section class="px-6 pb-12 max-w-4xl mx-auto">
        <div class="rounded-2xl border border-border/60 bg-card p-6 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-4">
            Choose a color theme
          </p>
          <div class="flex flex-wrap items-center gap-3">
            <%= for theme <- @themes do %>
              <button
                phx-click={JS.dispatch("phx:set-color-theme", detail: %{theme: theme.id}) |> JS.push("set-theme", value: %{"theme" => theme.id})}
                title={theme.label}
                aria-pressed={to_string(@current_theme == theme.id)}
                class={[
                  "flex items-center gap-2 rounded-lg border px-3 py-2 text-sm font-medium transition-all duration-200",
                  if(@current_theme == theme.id,
                    do: "border-primary bg-primary/10 text-primary shadow-sm",
                    else: "border-border bg-background text-muted-foreground hover:border-primary/40 hover:bg-accent"
                  )
                ]}
              >
                <span
                  class="h-4 w-4 rounded-full shrink-0 ring-1 ring-black/10"
                  style={"background-color: #{theme.color}"}
                />
                {theme.label}
                <.icon :if={@current_theme == theme.id} name="check" size={:xs} class="text-primary" />
              </button>
            <% end %>
          </div>

          <%!-- Live component preview --%>
          <div class="mt-6 pt-5 border-t border-border/60 space-y-4">
            <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">
              Component preview
            </p>
            <div class="flex flex-wrap gap-2 items-center">
              <.button>Primary</.button>
              <.button variant={:secondary}>Secondary</.button>
              <.button variant={:outline}>Outline</.button>
              <.button variant={:ghost}>Ghost</.button>
              <.button variant={:destructive}>Destructive</.button>
            </div>
            <div class="flex flex-wrap gap-2 items-center">
              <.badge>Default</.badge>
              <.badge variant={:secondary}>Secondary</.badge>
              <.badge variant={:outline}>Outline</.badge>
              <.badge variant={:destructive}>Destructive</.badge>
            </div>
            <.alert>
              <.alert_title>Theme: {@current_theme}</.alert_title>
              <.alert_description>
                Components respond automatically to the theme via CSS custom properties.
                The theme persists across pages via localStorage.
              </.alert_description>
            </.alert>
          </div>
        </div>
      </section>

      <%!-- Project cards --%>
      <section class="px-6 pb-20 max-w-4xl mx-auto">
        <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-4">
          Explore demos
        </p>
        <div class="grid grid-cols-1 gap-5 sm:grid-cols-3">
          <%= for project <- @projects do %>
            <a
              href={project.href}
              class="group flex flex-col rounded-2xl border border-border/60 bg-card p-6 shadow-sm hover:shadow-md hover:border-primary/30 transition-all duration-200"
            >
              <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/10 text-primary mb-4 group-hover:bg-primary group-hover:text-primary-foreground transition-all duration-200 shrink-0">
                <.icon name={project.icon} size={:sm} />
              </div>
              <h3 class="font-semibold text-foreground mb-1">{project.title}</h3>
              <p class="text-sm text-muted-foreground flex-1 leading-relaxed">{project.desc}</p>
              <div class="flex items-center gap-1 text-xs font-semibold text-primary mt-5 group-hover:gap-2 transition-all duration-200">
                Open demo
                <.icon name="arrow-right" size={:xs} />
              </div>
            </a>
          <% end %>
        </div>
      </section>

      <%!-- Footer --%>
      <footer class="border-t border-border/60 px-6 py-6 text-center">
        <p class="text-xs text-muted-foreground">
          PhiaUI &copy; 2026 · Phoenix LiveView + Tailwind CSS v4
        </p>
      </footer>
    </div>
    """
  end
end
