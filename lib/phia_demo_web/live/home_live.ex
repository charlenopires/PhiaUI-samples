defmodule PhiaDemoWeb.HomeLive do
  use PhiaDemoWeb, :live_view

  import PhiaDemoWeb.ProjectNav

  # All 8 official PhiaUI theme presets (matching phia-themes.css)
  # `text_on` = text color to use when this color IS the button background.
  # Determined by OKLCH lightness: L < ~0.62 with high chroma → white text; brighter → dark text.
  @themes [
    %{id: "violet",  label: "Violet",  color: "oklch(0.541 0.281 293.009)", atom: :violet,  text_on: "text-white"},
    %{id: "blue",    label: "Blue",    color: "oklch(0.546 0.245 262.881)", atom: :blue,    text_on: "text-white"},
    %{id: "green",   label: "Green",   color: "oklch(0.527 0.154 150.069)", atom: :green,   text_on: "text-white"},
    %{id: "rose",    label: "Rose",    color: "oklch(0.592 0.241 349.615)", atom: :rose,    text_on: "text-white"},
    %{id: "orange",  label: "Orange",  color: "oklch(0.645 0.246 37.304)",  atom: :orange,  text_on: "text-gray-900"},
    %{id: "slate",   label: "Slate",   color: "oklch(0.208 0.042 265.755)", atom: :slate,   text_on: "text-white"},
    %{id: "zinc",    label: "Zinc",    color: "oklch(0.211 0.005 285.82)",  atom: :zinc,    text_on: "text-white"},
    %{id: "neutral", label: "Neutral", color: "oklch(0.205 0 0)",           atom: :neutral, text_on: "text-white"}
  ]

  @project_groups [
    %{
      label: "Core Demos",
      icon: "layout-dashboard",
      color: "text-violet-500",
      bg: "bg-violet-500/10",
      projects: [
        %{id: :dashboard, title: "Dashboard",  href: "/dashboard",  icon: "layout-dashboard", desc: "Admin panel with metrics, SVG charts, and sidebar navigation."},
        %{id: :showcase,  title: "Showcase",   href: "/showcase",   icon: "puzzle",           desc: "Gallery of 584 PhiaUI components — interactive, dark-mode ready."},
        %{id: :chat,      title: "Chat",       href: "/chat",       icon: "message-circle",   desc: "Real-time chat rooms with agents, polls, and reactions."}
      ]
    },
    %{
      label: "Productivity",
      icon: "zap",
      color: "text-blue-500",
      bg: "bg-blue-500/10",
      projects: [
        %{id: :kanban, title: "Kanban",  href: "/kanban",  icon: "layout-grid",  desc: "Drag-and-drop board with columns, cards, and quick add."},
        %{id: :notes,  title: "Notes",   href: "/notes",   icon: "pencil",       desc: "Google Keep-style masonry grid with colors, tags, and pins."},
        %{id: :todo,   title: "Todo",    href: "/todo",    icon: "circle-check", desc: "Personal task manager grouped by list with progress tracking."},
        %{id: :tasks,  title: "Tasks",   href: "/tasks",   icon: "list",         desc: "Issue tracker with status, priority, assignees, and bulk actions."}
      ]
    },
    %{
      label: "Communication",
      icon: "inbox",
      color: "text-green-500",
      bg: "bg-green-500/10",
      projects: [
        %{id: :mail,   title: "Mail",   href: "/mail",   icon: "inbox", desc: "Email client with inbox, compose, stars, archive, and labels."},
        %{id: :social, title: "Social", href: "/social", icon: "users", desc: "Community feed with posts, reactions, and trending topics."}
      ]
    },
    %{
      label: "Business",
      icon: "briefcase",
      color: "text-orange-500",
      bg: "bg-orange-500/10",
      projects: [
        %{id: :files,    title: "File Manager",   href: "/files",    icon: "folder",        desc: "File browser with grid/list views, upload, and folder tree."},
        %{id: :api_keys, title: "API Keys",       href: "/api-keys", icon: "shield",        desc: "Secure key management with copy, reveal, revoke, and scopes."},
        %{id: :pos,      title: "Point of Sale",  href: "/pos",      icon: "shopping-cart", desc: "POS terminal with catalog, cart, and checkout flow."},
        %{id: :courses,  title: "Courses",        href: "/courses",  icon: "layers",        desc: "Learning platform with catalog, enrollment, and progress."}
      ]
    },
    %{
      label: "AI Tools",
      icon: "sparkles",
      color: "text-rose-500",
      bg: "bg-rose-500/10",
      projects: [
        %{id: :ai_chat,  title: "AI Chat",           href: "/ai-chat",         icon: "message-square", desc: "Conversational AI with suggestions and typing indicator."},
        %{id: :ai_chat_v2, title: "AI Chat v2",      href: "/ai-chat-v2",      icon: "message-square", desc: "Advanced chat with model selection, temperature, and history."},
        %{id: :image_gen,  title: "Image Generator", href: "/image-generator", icon: "image",          desc: "AI image studio with prompt editor, styles, and gallery."}
      ]
    }
  ]

  @projects Enum.flat_map(@project_groups, & &1.projects)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "PhiaUI Demos")
     |> assign(:themes, @themes)
     |> assign(:projects, @projects)
     |> assign(:project_groups, @project_groups)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-background text-foreground">

      <%!-- Top navigation bar --%>
      <header class="sticky top-0 z-40 flex h-14 items-center border-b border-border/60 bg-background/95 backdrop-blur px-4">
        <.project_topbar current_project={nil} dark_mode_id="home-dm" />
      </header>

      <%!-- Hero with aurora background --%>
      <section class="relative overflow-hidden px-6 pt-12 pb-8 max-w-5xl mx-auto text-center">
        <%!-- Aurora glow --%>
        <.aurora
          colors={["oklch(0.541 0.281 293.009 / 0.3)", "oklch(0.546 0.245 262.881 / 0.2)", "oklch(0.592 0.241 349.615 / 0.15)"]}
          speed={12}
          class="absolute inset-0 h-full w-full rounded-3xl"
        />
        <div class="relative z-10 phia-animate">
          <div class="inline-flex items-center gap-2 rounded-full border border-primary/30 bg-primary/10 px-4 py-1.5 text-xs font-semibold text-primary mb-4">
            <.icon name="layers" size={:xs} />
            PhiaUI v0.1.13
            <span class="h-3 w-px bg-primary/30" />
            <span class="text-primary/70">Phoenix LiveView</span>
          </div>
          <img
            src={~p"/images/phiaui-demo-logo.svg"}
            alt="PhiaUI Demo"
            class="mx-auto mb-5 w-full max-w-md sm:max-w-lg"
          />
          <p class="text-lg text-muted-foreground max-w-2xl mx-auto mb-10 leading-relaxed">
            16 complete Phoenix LiveView applications built with PhiaUI —
            a Tailwind v4 component library with CSS-first theming and dark mode.
          </p>
          <%!-- Stats row --%>
          <div class="flex flex-wrap items-center justify-center gap-4 sm:gap-8">
            <div class="text-center">
              <p class="text-3xl font-bold text-foreground tabular-nums">
                <.number_ticker id="stat-apps" value={16} duration={1200} />
              </p>
              <p class="text-xs text-muted-foreground mt-0.5">Demo Apps</p>
            </div>
            <div class="h-8 w-px bg-border/60" />
            <div class="text-center">
              <p class="text-3xl font-bold text-foreground tabular-nums">
                <.number_ticker id="stat-components" value={584} duration={1600} />
              </p>
              <p class="text-xs text-muted-foreground mt-0.5">Components</p>
            </div>
            <div class="h-8 w-px bg-border/60" />
            <div class="text-center">
              <p class="text-3xl font-bold text-foreground tabular-nums">
                <.number_ticker id="stat-themes" value={8} duration={800} />
              </p>
              <p class="text-xs text-muted-foreground mt-0.5">Color Themes</p>
            </div>
          </div>
        </div>
      </section>

      <%!-- Theme Palette Picker --%>
      <section class="px-6 pb-12 max-w-5xl mx-auto phia-animate">
        <div class="rounded-2xl border border-border/60 bg-card shadow-sm overflow-hidden">
          <div class="px-6 pt-6 pb-4 border-b border-border/60 flex items-center justify-between">
            <div>
              <h2 class="text-sm font-semibold text-foreground">Color Theme</h2>
              <p class="text-xs text-muted-foreground mt-0.5">Select a palette — changes take effect instantly across all demos</p>
            </div>
            <.badge variant={:outline} class="text-[10px] font-mono">Select a theme</.badge>
          </div>

          <%!-- Swatch buttons with PhiaTheme hook (hook handles active state + localStorage) --%>
          <div class="px-6 py-5 flex flex-wrap gap-2">
            <%= for theme <- @themes do %>
              <button
                id={"theme-btn-#{theme.id}"}
                phx-hook="PhiaTheme"
                data-theme={theme.id}
                class="group flex items-center gap-2.5 rounded-xl border-2 border-border bg-background text-muted-foreground px-4 py-2.5 text-sm font-semibold transition-all duration-200 cursor-pointer hover:bg-foreground/8 hover:text-foreground hover:border-foreground/20"
              >
                <span
                  class="h-4 w-4 rounded-full shrink-0 ring-2 ring-black/10 dark:ring-white/10"
                  style={"background-color: #{theme.color}"}
                />
                {theme.label}
              </button>
            <% end %>
          </div>

        </div>
      </section>

      <%!-- Project groups --%>
      <section class="px-6 pb-20 max-w-5xl mx-auto space-y-12 phia-animate-d1">
        <div class="flex items-center justify-between border-b border-border/60 pb-2">
          <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">
            Explore demos
          </p>
          <span class="text-xs text-muted-foreground">{length(@projects)} apps</span>
        </div>
        <%= for group <- @project_groups do %>
          <div>
            <div class="flex items-center gap-2.5 mb-4">
              <div class={"flex h-7 w-7 items-center justify-center rounded-lg " <> group.bg}>
                <.icon name={group.icon} size={:xs} class={group.color} />
              </div>
              <h2 class="text-sm font-bold text-foreground">{group.label}</h2>
              <span class="text-xs text-muted-foreground">({length(group.projects)})</span>
            </div>
            <div class="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              <%= for project <- group.projects do %>
                <a
                  href={project.href}
                  class="group relative flex flex-col rounded-xl border border-border/60 bg-card p-5 shadow-sm hover:shadow-lg hover:border-primary/40 hover:bg-card transition-all duration-300 overflow-hidden"
                >
                  <%!-- Subtle hover glow --%>
                  <div class="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-xl pointer-events-none" />
                  <div class="relative">
                    <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/10 text-primary mb-4 group-hover:bg-primary group-hover:text-primary-foreground transition-all duration-300 shrink-0">
                      <.icon name={project.icon} size={:sm} />
                    </div>
                    <h3 class="font-semibold text-foreground text-sm mb-1.5">{project.title}</h3>
                    <p class="text-xs text-muted-foreground flex-1 leading-relaxed">{project.desc}</p>
                    <div class="flex items-center gap-1 text-xs font-semibold text-primary mt-4 group-hover:gap-2 transition-all duration-200">
                      Open app
                      <.icon name="arrow-right" size={:xs} />
                    </div>
                  </div>
                </a>
              <% end %>
            </div>
          </div>
        <% end %>
      </section>

      <%!-- Footer --%>
      <footer class="border-t border-border/60 px-6 py-8">
        <div class="max-w-5xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
          <div class="flex items-center gap-2">
            <.icon name="layers" size={:xs} class="text-primary" />
            <span class="text-sm font-semibold text-foreground">PhiaUI</span>
            <.badge variant={:outline} class="text-[10px]">v0.1.13</.badge>
          </div>
          <div class="flex items-center gap-4">
            <p class="text-xs text-muted-foreground">
              Phoenix LiveView + Tailwind CSS v4 · CSS-first theming · 584 components
            </p>
            <a
              href="https://github.com/charlenopires/PhiaUI-samples"
              target="_blank"
              rel="noopener noreferrer"
              class="text-muted-foreground hover:text-foreground transition-colors"
              title="View source on GitHub"
            >
              <svg viewBox="0 0 24 24" fill="currentColor" class="h-5 w-5" aria-label="GitHub">
                <path d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0 1 12 5.803c.98.005 1.97.132 2.9.392 2.29-1.552 3.297-1.23 3.297-1.23.651 1.652.242 2.873.118 3.176.769.84 1.235 1.91 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z" />
              </svg>
            </a>
          </div>
        </div>
      </footer>

    </div>
    """
  end
end
