defmodule PhiaDemoWeb.ProjectNav do
  @moduledoc """
  Cross-project top navigation bar shared across all PhiaUI demo apps.

  Renders a horizontal bar with:
  - PhiaUI logo / home link
  - 4 primary project tabs (News, Dashboard, Components, Chat)
  - "More ▾" dropdown with remaining demos in categories
  - Optional right-side action slot
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

  @projects_visible [
    %{id: :news,       label: "News",       href: "/news",       icon: "newspaper"},
    %{id: :dashboard,  label: "Dashboard",  href: "/dashboard",  icon: "layout-dashboard"},
    %{id: :components, label: "Components", href: "/components", icon: "puzzle"},
    %{id: :chat,       label: "Chat",       href: "/chat",       icon: "message-circle"}
  ]

  @projects_more [
    %{
      label: "Productivity",
      color: "text-blue-500",
      items: [
        %{id: :kanban, label: "Kanban", href: "/kanban",  icon: "layout-grid"},
        %{id: :notes,  label: "Notes",  href: "/notes",   icon: "pencil"},
        %{id: :todo,   label: "Todo",   href: "/todo",    icon: "circle-check"},
        %{id: :tasks,  label: "Tasks",  href: "/tasks",   icon: "list"}
      ]
    },
    %{
      label: "Communication",
      color: "text-green-500",
      items: [
        %{id: :mail,   label: "Mail",   href: "/mail",   icon: "inbox"},
        %{id: :social, label: "Social", href: "/social", icon: "users"}
      ]
    },
    %{
      label: "Business",
      color: "text-orange-500",
      items: [
        %{id: :files,    label: "Files",    href: "/files",           icon: "folder"},
        %{id: :api_keys, label: "API Keys", href: "/api-keys",        icon: "shield"},
        %{id: :pos,      label: "POS",      href: "/pos",             icon: "shopping-cart"},
        %{id: :courses,  label: "Courses",  href: "/courses",         icon: "layers"},
        %{id: :hotel,    label: "Hotel",    href: "/hotel",           icon: "building-2"}
      ]
    },
    %{
      label: "AI Tools",
      color: "text-rose-500",
      items: [
        %{id: :ai_chat,    label: "AI Chat",    href: "/ai-chat",         icon: "message-square"},
        %{id: :ai_chat_v2, label: "AI Chat v2", href: "/ai-chat-v2",      icon: "sparkles"},
        %{id: :image_gen,  label: "Image Gen",  href: "/image-generator", icon: "image"}
      ]
    },
    %{
      label: "Pages",
      color: "text-purple-500",
      items: [
        %{id: :profile, label: "Profile", href: "/profile",        icon: "user"},
        %{id: :pricing,        label: "Pricing",       href: "/pricing/column", icon: "tag"},
        %{id: :notifications, label: "Notifications", href: "/notifications",  icon: "bell"}
      ]
    }
  ]

  @projects_more_ids MapSet.new(
    Enum.flat_map(@projects_more, fn g -> Enum.map(g.items, & &1.id) end)
  )

  attr :current_project, :atom,
    default: nil,
    doc: "Atom identifying which project tab is active, or nil for home page"

  attr :dark_mode_id, :string,
    default: "top-dm-toggle",
    doc: "ID for the dark mode toggle — must be unique per page"

  slot :actions,
    doc: "Optional slot for action buttons rendered left of the dark mode toggle"

  def project_topbar(assigns) do
    assigns =
      assigns
      |> assign(:projects_visible, @projects_visible)
      |> assign(:projects_more, @projects_more)
      |> assign(:more_active, assigns.current_project in @projects_more_ids)

    ~H"""
    <div class="flex items-center flex-1 min-w-0 gap-1">
      <%!-- Logo / home --%>
      <a
        href="/"
        class="flex items-center gap-2 shrink-0 rounded-lg px-2 py-1.5 hover:bg-accent transition-colors"
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

        <%!-- Primary visible tabs --%>
        <%= for project <- @projects_visible do %>
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
                  do: "shrink-0 text-primary",
                  else: "shrink-0 text-muted-foreground/60"
              }
            />
            <span class="hidden sm:inline">{project.label}</span>
            <span
              :if={project.id == @current_project}
              class="absolute bottom-0 left-1/2 -translate-x-1/2 h-0.5 w-4 rounded-full bg-primary"
            />
          </a>
        <% end %>

        <%!-- "More" dropdown — <details> gives click/tap on mobile;
             group-hover/more keeps it open on desktop hover.             --%>
        <details class="relative group/more shrink-0 [&[open]>div]:block" id="more-menu">
          <%!-- Trigger: <summary> is keyboard + touch accessible --%>
          <summary class={[
            "list-none [&::-webkit-details-marker]:hidden",
            "relative flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium",
            "transition-colors whitespace-nowrap select-none cursor-pointer",
            if @more_active do
              "bg-primary/10 text-primary font-semibold"
            else
              "text-muted-foreground hover:bg-accent hover:text-foreground"
            end
          ]}>
            <.icon
              name="layout-grid"
              size={:xs}
              class={
                if @more_active,
                  do: "shrink-0 text-primary",
                  else: "shrink-0 text-muted-foreground/60"
              }
            />
            <span class="hidden sm:inline">More</span>
            <.icon
              name="chevron-down"
              size={:xs}
              class="shrink-0 opacity-50 transition-transform duration-200 group-hover/more:rotate-180 open:rotate-180"
            />
            <span
              :if={@more_active}
              class="absolute bottom-0 left-1/2 -translate-x-1/2 h-0.5 w-4 rounded-full bg-primary"
            />
          </summary>

          <%!-- Mobile backdrop --%>
          <div
            class="fixed inset-0 bg-black/30 z-[99] sm:hidden"
            onclick="document.getElementById('more-menu').removeAttribute('open')"
          />

          <%!-- Dropdown panel — bottom sheet on mobile, absolute dropdown on sm+ --%>
          <div class="fixed inset-x-0 bottom-0 z-[100] sm:absolute sm:inset-x-auto sm:bottom-auto sm:top-full sm:right-0 sm:pt-2 hidden group-hover/more:block">
            <div class="w-full sm:w-[440px] sm:max-w-[calc(100vw-1rem)] rounded-t-2xl sm:rounded-xl border border-border bg-popover shadow-xl overflow-hidden">

              <%!-- Drag handle (mobile only) --%>
              <div class="sm:hidden flex justify-center py-2">
                <div class="h-1 w-10 rounded-full bg-muted-foreground/30" />
              </div>

              <%!-- Panel header --%>
              <div class="px-4 py-2.5 border-b border-border/50 bg-muted/40 flex items-center justify-between">
                <p class="text-[11px] font-bold text-muted-foreground uppercase tracking-widest">All Demos</p>
                <div class="flex items-center gap-3">
                  <a
                    href="/"
                    class="text-[11px] text-muted-foreground/70 hover:text-primary transition-colors"
                  >
                    View all →
                  </a>
                  <%!-- Close button (mobile) --%>
                  <button
                    class="sm:hidden flex h-6 w-6 items-center justify-center rounded-md hover:bg-accent transition-colors"
                    onclick="document.getElementById('more-menu').removeAttribute('open')"
                    aria-label="Close menu"
                  >
                    <.icon name="x" size={:xs} class="text-muted-foreground" />
                  </button>
                </div>
              </div>

              <%!-- 2-column categories grid --%>
              <div class="max-h-[70vh] overflow-y-auto sm:max-h-none sm:overflow-visible grid grid-cols-1 sm:grid-cols-2 p-3 gap-1">
                <%= for group <- @projects_more do %>
                  <div class="p-1.5">
                    <%!-- Category label --%>
                    <p class={"mb-1.5 px-1 text-[10px] font-bold uppercase tracking-wider " <> group.color}>
                      {group.label}
                    </p>
                    <%!-- Demo links --%>
                    <div class="space-y-0.5">
                      <%= for item <- group.items do %>
                        <a
                          href={item.href}
                          class={[
                            "group/item flex items-center gap-2 rounded-lg px-2 py-1.5 text-sm transition-colors",
                            if item.id == @current_project do
                              "bg-primary/10 text-primary font-semibold"
                            else
                              "text-foreground/80 hover:bg-accent hover:text-foreground"
                            end
                          ]}
                        >
                          <.icon
                            name={item.icon}
                            size={:xs}
                            class={
                              if item.id == @current_project,
                                do: "shrink-0 text-primary",
                                else: "shrink-0 text-muted-foreground/50 group-hover/item:text-foreground"
                            }
                          />
                          <span class="flex-1">{item.label}</span>
                          <span
                            :if={item.id == @current_project}
                            class="h-1.5 w-1.5 rounded-full bg-primary shrink-0"
                          />
                        </a>
                      <% end %>
                    </div>
                  </div>
                <% end %>
              </div>

            </div>
          </div>
        </details>

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
