defmodule PhiaDemoWeb.Demo.Profile.V2Live do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Profile.Layout

  @connections [
    %{name: "Rachel Doe",      connections: 25, color: "bg-violet-500"},
    %{name: "Isabella Finley", connections: 79, color: "bg-rose-500"},
    %{name: "David Harrison",  connections: 0,  color: "bg-blue-500"},
    %{name: "Costa Quinn",     connections: 9,  color: "bg-emerald-500"}
  ]

  @teams [
    %{name: "#digitalmarketing", members: 8,  color: "bg-orange-500", description: "Social media strategy, SEO, and content marketing campaigns"},
    %{name: "#ethereum",         members: 14, color: "bg-blue-500",   description: "Blockchain development, smart contracts, and DeFi projects"},
    %{name: "#conference",       members: 3,  color: "bg-purple-500", description: "Event planning, speaker coordination, and logistics"},
    %{name: "#supportteam",      members: 3,  color: "bg-emerald-500", description: "Customer support, ticket resolution, and user onboarding"}
  ]

  @projects [
    %{name: "UI/UX",                                 updated: "2 hours ago",  progress: 0,   hours: "4:25",  status: "planning"},
    %{name: "Get a complete audit store",             updated: "1 day ago",    progress: 45,  hours: "18:42", status: "in_progress"},
    %{name: "Build stronger customer relationships",  updated: "2 days ago",   progress: 59,  hours: "9:01",  status: "in_progress"},
    %{name: "Update subscription method",            updated: "2 days ago",   progress: 57,  hours: "0:37",  status: "in_progress"},
    %{name: "Create a new theme",                    updated: "1 week ago",   progress: 100, hours: "24:12", status: "completed"},
    %{name: "Improve social banners",                updated: "1 week ago",   progress: 0,   hours: "8:08",  status: "on_hold"},
    %{name: "Deploy analytics pipeline",             updated: "3 days ago",   progress: 80,  hours: "12:30", status: "in_progress"}
  ]

  @activity_stream [
    %{
      type: :files,
      title: "Task report – uploaded weekly reports",
      time: "5 minutes ago",
      files: [
        %{name: "weekly-reports.xlsx",  size: "12kb"},
        %{name: "weekly-reports.xlsx",  size: "44kb"},
        %{name: "monthly-reports.xlsx", size: "8kb"}
      ]
    },
    %{
      type: :update,
      title: "Project status updated",
      time: "3 hours ago",
      files: []
    },
    %{
      type: :photos,
      title: "3 new photos added",
      time: "Yesterday",
      files: []
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Profile V2")
     |> assign(:active_tab, "Profile")
     |> assign(:connections, @connections)
     |> assign(:teams, @teams)
     |> assign(:projects, @projects)
     |> assign(:activity_stream, @activity_stream)}
  end

  @impl true
  def handle_event("switch-tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/profile/v2">
      <div class="max-w-screen-xl mx-auto">

        <%!-- Cover banner --%>
        <div class="relative">
          <div class="h-44 md:h-56 bg-gradient-to-r from-emerald-400 via-amber-400 to-purple-400 overflow-hidden">
            <div class="absolute inset-0 opacity-70">
              <div class="absolute top-4 left-1/4 h-32 w-32 rounded-full bg-green-300 blur-2xl" />
              <div class="absolute top-8 left-1/2 h-28 w-28 rounded-full bg-orange-300 blur-2xl" />
              <div class="absolute top-2 right-1/4 h-36 w-36 rounded-full bg-purple-400 blur-2xl" />
              <div class="absolute bottom-2 left-1/3 h-24 w-40 rounded-full bg-amber-300 blur-2xl" />
            </div>
          </div>

          <button class="absolute top-3 right-3 flex h-9 w-9 items-center justify-center rounded-full bg-black/30 text-white hover:bg-black/50 transition-colors backdrop-blur-sm min-h-[44px] min-w-[44px]">
            <.icon name="pencil" size={:xs} />
          </button>

          <div class="absolute -bottom-14 left-1/2 -translate-x-1/2">
            <div class="h-28 w-28 rounded-full border-4 border-background bg-gradient-to-br from-amber-400 to-rose-500 flex items-center justify-center text-white text-3xl font-bold shadow-xl">
              TB
            </div>
          </div>
        </div>

        <%!-- Profile identity section --%>
        <div class="pt-16 pb-4 px-4 md:px-6 text-center phia-animate">
          <h1 class="text-2xl font-bold text-foreground">Toby Belhome</h1>
          <div class="flex flex-wrap items-center justify-center gap-3 mt-2 text-sm text-muted-foreground">
            <span class="inline-flex items-center gap-1">
              <.icon name="code" size={:xs} />
              Developer
            </span>
            <span class="text-border/60">·</span>
            <span class="inline-flex items-center gap-1">
              <.icon name="home" size={:xs} />
              San Francisco, US
            </span>
            <span class="text-border/60">·</span>
            <span class="inline-flex items-center gap-1">
              <.icon name="calendar" size={:xs} />
              Joined March 2025
            </span>
          </div>
        </div>

        <%!-- Tabs + actions bar --%>
        <div class="px-4 md:px-6 flex items-center justify-between border-b border-border/60 phia-animate-d1">
          <div class="flex items-center gap-0.5 overflow-x-auto">
            <%= for {tab, badge} <- [{"Profile", nil}, {"Teams", nil}, {"Projects", length(@projects)}] do %>
              <button
                phx-click="switch-tab"
                phx-value-tab={tab}
                class={[
                  "flex items-center gap-1.5 px-4 py-2.5 text-sm font-medium transition-colors -mb-px border-b-2 min-h-[44px] whitespace-nowrap",
                  if tab == @active_tab do
                    "border-primary text-primary"
                  else
                    "border-transparent text-muted-foreground hover:text-foreground"
                  end
                ]}
              >
                {tab}
                <span
                  :if={badge}
                  class="inline-flex h-4 min-w-4 items-center justify-center rounded-full bg-muted px-1 text-[10px] font-semibold text-muted-foreground"
                >
                  {badge}
                </span>
              </button>
            <% end %>
          </div>
          <div class="flex items-center gap-2 mb-px">
            <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-3 py-2 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px]">
              <.icon name="user-plus" size={:xs} />
              Connect
            </button>
            <button class="flex h-9 w-9 items-center justify-center rounded-lg border border-border text-muted-foreground hover:bg-accent hover:text-foreground transition-colors min-h-[44px] min-w-[44px]">
              <.icon name="sliders-horizontal" size={:xs} />
            </button>
          </div>
        </div>

        <%!-- Tab Content --%>
        <%= case @active_tab do %>
          <% "Profile" -> %>
            <.profile_tab
              connections={@connections}
              teams={@teams}
              projects={@projects}
              activity_stream={@activity_stream}
            />
          <% "Teams" -> %>
            <.teams_tab teams={@teams} />
          <% "Projects" -> %>
            <.projects_tab projects={@projects} />
        <% end %>

      </div>
    </Layout.layout>
    """
  end

  # ===========================================================================
  # Profile Tab (original content)
  # ===========================================================================

  defp profile_tab(assigns) do
    ~H"""
    <div class="grid grid-cols-1 lg:grid-cols-[300px_1fr] gap-5 p-4 md:p-6 phia-animate-d2">

      <%!-- Left column --%>
      <div class="space-y-5">

        <%!-- Complete your profile --%>
        <.card class="border-border/60 shadow-sm">
          <.card_content class="p-5">
            <p class="text-sm font-semibold text-foreground mb-3">Complete your profile</p>
            <div class="mb-2">
              <div class="flex justify-between text-xs text-muted-foreground mb-1.5">
                <span>Progress</span>
                <span class="font-semibold text-primary">82%</span>
              </div>
              <div class="h-2 w-full rounded-full bg-muted overflow-hidden">
                <div class="h-full rounded-full bg-primary transition-all" style="width: 82%" />
              </div>
            </div>
          </.card_content>
        </.card>

        <%!-- About --%>
        <.card class="border-border/60 shadow-sm">
          <.card_content class="p-5 space-y-4">
            <p class="text-xs font-bold uppercase tracking-widest text-muted-foreground/60">About</p>
            <div class="space-y-3">
              <div class="flex items-center gap-2.5 text-sm">
                <.icon name="user" size={:xs} class="shrink-0 text-muted-foreground/60" />
                <span class="text-foreground font-medium">Toby Belhome</span>
              </div>
              <div class="flex items-center gap-2.5 text-sm">
                <.icon name="briefcase" size={:xs} class="shrink-0 text-muted-foreground/60" />
                <span class="text-muted-foreground">No department</span>
              </div>
              <div class="flex items-center gap-2.5 text-sm">
                <.icon name="trending-up" size={:xs} class="shrink-0 text-muted-foreground/60" />
                <span class="text-foreground font-medium">Developer</span>
              </div>
            </div>

            <div class="pt-3 border-t border-border/60">
              <p class="text-xs font-bold uppercase tracking-widest text-muted-foreground/60 mb-3">Contacts</p>
              <div class="space-y-3">
                <div class="flex items-center gap-2.5 text-sm">
                  <.icon name="link" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span class="text-primary truncate">hello@phiaui.dev</span>
                </div>
                <div class="flex items-center gap-2.5 text-sm">
                  <.icon name="message-circle" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span class="text-foreground">+1 (609) 972-22-22</span>
                </div>
              </div>
            </div>

            <div class="pt-3 border-t border-border/60">
              <p class="text-xs font-bold uppercase tracking-widest text-muted-foreground/60 mb-3">Teams</p>
              <div class="space-y-3">
                <div class="flex items-center gap-2.5 text-sm">
                  <.icon name="users" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span class="text-foreground">Member of <span class="font-semibold">{length(@teams)} teams</span></span>
                </div>
                <div class="flex items-center gap-2.5 text-sm">
                  <.icon name="folder" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span class="text-foreground">Working on <span class="font-semibold">{length(@projects)} projects</span></span>
                </div>
              </div>
            </div>
          </.card_content>
        </.card>

      </div>

      <%!-- Right column --%>
      <div class="space-y-5 min-w-0">

        <%!-- Activity Stream --%>
        <.card class="border-border/60 shadow-sm">
          <.card_header class="pb-3">
            <div class="flex items-center justify-between">
              <.card_title>Activity stream</.card_title>
              <button class="flex h-8 w-8 items-center justify-center rounded-lg text-muted-foreground hover:bg-accent transition-colors">
                <.icon name="sliders-horizontal" size={:xs} />
              </button>
            </div>
          </.card_header>
          <.card_content class="px-6 pb-4">
            <div class="relative space-y-0">
              <div class="absolute left-[6px] top-2 bottom-0 w-px bg-border/60" />

              <%= for item <- @activity_stream do %>
                <div class="flex gap-4 pb-6 last:pb-0 relative">
                  <div class="mt-1 h-3.5 w-3.5 shrink-0 rounded-full border-2 border-primary bg-background z-10" />

                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-semibold text-foreground">{item.title}</p>
                    <p class="text-xs text-muted-foreground mt-0.5 mb-2">{item.time}</p>

                    <div :if={item.type == :files && item.files != []} class="flex flex-wrap gap-2 mt-2">
                      <div
                        :for={file <- item.files}
                        class="flex items-center gap-2 rounded-lg border border-border bg-muted/40 px-3 py-2 text-xs"
                      >
                        <.icon name="paperclip" size={:xs} class="text-muted-foreground shrink-0" />
                        <div>
                          <p class="font-medium text-foreground leading-none">{file.name}</p>
                          <p class="text-muted-foreground mt-0.5">{file.size}</p>
                        </div>
                      </div>
                    </div>

                    <div :if={item.type == :photos} class="flex flex-wrap gap-2 mt-2">
                      <div class="h-20 w-28 rounded-lg bg-gradient-to-br from-sky-200 to-blue-400 dark:from-sky-700 dark:to-blue-800 overflow-hidden flex items-center justify-center">
                        <.icon name="image" size={:sm} class="text-white/60" />
                      </div>
                      <div class="h-20 w-28 rounded-lg bg-gradient-to-br from-purple-200 to-violet-400 dark:from-purple-700 dark:to-violet-800 overflow-hidden flex items-center justify-center">
                        <.icon name="image" size={:sm} class="text-white/60" />
                      </div>
                      <div class="h-20 w-28 rounded-lg bg-gradient-to-br from-indigo-200 to-purple-300 dark:from-indigo-700 dark:to-purple-800 overflow-hidden flex items-center justify-center">
                        <.icon name="image" size={:sm} class="text-white/60" />
                      </div>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
          </.card_content>
          <.card_footer class="px-6 pb-5 pt-0">
            <button class="w-full rounded-lg border border-border py-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-foreground transition-colors min-h-[44px]">
              View more
            </button>
          </.card_footer>
        </.card>

        <%!-- Connections + Teams (two columns on md+) --%>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

          <%!-- Connections --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-3">
              <.card_title>Connections</.card_title>
            </.card_header>
            <.card_content class="px-6 pb-4 space-y-3">
              <div
                :for={conn <- @connections}
                class="flex items-center gap-3"
              >
                <div class={"flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-white text-sm font-bold " <> conn.color}>
                  {String.first(conn.name)}
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-semibold text-foreground truncate">{conn.name}</p>
                  <p class="text-xs text-muted-foreground">
                    {conn.connections} connections
                  </p>
                </div>
                <button class="shrink-0 flex h-8 w-8 items-center justify-center rounded-full border border-border text-muted-foreground hover:bg-primary hover:text-primary-foreground hover:border-primary transition-colors">
                  <.icon name="user-plus" size={:xs} />
                </button>
              </div>
            </.card_content>
            <.card_footer class="px-6 pb-5 pt-0">
              <button class="w-full flex items-center justify-center gap-1 text-sm font-medium text-primary hover:text-primary/80 transition-colors min-h-[44px]">
                View all connections
                <.icon name="arrow-right" size={:xs} />
              </button>
            </.card_footer>
          </.card>

          <%!-- Teams summary --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-3">
              <.card_title>Teams</.card_title>
            </.card_header>
            <.card_content class="px-6 pb-4 space-y-3">
              <div
                :for={team <- @teams}
                class="flex items-center gap-3"
              >
                <div class={"flex h-9 w-9 shrink-0 items-center justify-center rounded-lg text-white text-xs font-bold " <> team.color}>
                  <.icon name="hash" size={:xs} />
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-semibold text-foreground truncate">{team.name}</p>
                  <p class="text-xs text-muted-foreground">{team.members} members</p>
                </div>
              </div>
            </.card_content>
            <.card_footer class="px-6 pb-5 pt-0">
              <button
                phx-click="switch-tab"
                phx-value-tab="Teams"
                class="w-full flex items-center justify-center gap-1 text-sm font-medium text-primary hover:text-primary/80 transition-colors min-h-[44px]"
              >
                View all teams
                <.icon name="arrow-right" size={:xs} />
              </button>
            </.card_footer>
          </.card>

        </div>

        <%!-- Projects summary table --%>
        <.card class="border-border/60 shadow-sm">
          <.card_header class="pb-3">
            <div class="flex items-center justify-between">
              <.card_title>Projects</.card_title>
              <button
                phx-click="switch-tab"
                phx-value-tab="Projects"
                class="text-sm font-medium text-primary hover:text-primary/80 transition-colors"
              >
                View all
              </button>
            </div>
          </.card_header>
          <.card_content class="p-0">
            <div class="overflow-x-auto">
              <table class="w-full text-sm min-w-[480px]">
                <thead>
                  <tr class="border-b border-border/60 text-xs text-muted-foreground font-medium">
                    <th class="px-4 py-2.5 text-left">Project</th>
                    <th class="px-4 py-2.5 text-left w-40">Progress</th>
                    <th class="px-4 py-2.5 text-right whitespace-nowrap">Hours Spent</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    :for={proj <- Enum.take(@projects, 5)}
                    class="border-b border-border/40 last:border-b-0 hover:bg-muted/30 transition-colors"
                  >
                    <td class="px-4 py-3">
                      <div class="flex items-center gap-2.5">
                        <div class="flex h-7 w-7 shrink-0 items-center justify-center rounded-md bg-primary/10">
                          <.icon name="folder" size={:xs} class="text-primary" />
                        </div>
                        <div class="min-w-0">
                          <p class="text-sm font-medium text-foreground truncate max-w-[200px]">{proj.name}</p>
                          <p class="text-xs text-muted-foreground">Updated {proj.updated}</p>
                        </div>
                      </div>
                    </td>
                    <td class="px-4 py-3">
                      <div class="flex items-center gap-2">
                        <div class="flex-1 h-1.5 rounded-full bg-muted overflow-hidden">
                          <div
                            class="h-full rounded-full bg-primary transition-all"
                            style={"width: #{proj.progress}%"}
                          />
                        </div>
                        <span class="text-xs text-muted-foreground tabular-nums w-8 text-right">
                          {proj.progress}%
                        </span>
                      </div>
                    </td>
                    <td class="px-4 py-3 text-sm font-semibold text-foreground text-right tabular-nums">
                      {proj.hours}
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </.card_content>
        </.card>

      </div>
    </div>
    """
  end

  # ===========================================================================
  # Teams Tab
  # ===========================================================================

  defp teams_tab(assigns) do
    ~H"""
    <div class="p-4 md:p-6 space-y-5 phia-animate-d2">
      <div class="flex items-center justify-between">
        <div>
          <h2 class="text-lg font-bold text-foreground">Your Teams</h2>
          <p class="text-sm text-muted-foreground mt-0.5">You're a member of {length(@teams)} teams</p>
        </div>
        <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px] whitespace-nowrap">
          <.icon name="plus" size={:xs} />
          Join Team
        </button>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <.card :for={team <- @teams} class="border-border/60 shadow-sm hover:shadow-md transition-shadow">
          <.card_content class="p-4 md:p-5">
            <div class="flex items-start gap-3">
              <div class={"flex h-10 w-10 shrink-0 items-center justify-center rounded-lg text-white " <> team.color}>
                <.icon name="hash" size={:sm} />
              </div>
              <div class="flex-1 min-w-0 space-y-2">
                <div>
                  <h3 class="text-sm font-semibold text-foreground">{team.name}</h3>
                  <p class="text-xs text-muted-foreground mt-0.5 leading-relaxed">{team.description}</p>
                </div>
                <div class="flex items-center justify-between pt-2 border-t border-border/40">
                  <div class="flex items-center gap-1.5 text-xs text-muted-foreground">
                    <.icon name="users" size={:xs} />
                    <span>{team.members} members</span>
                  </div>
                  <button class="text-xs font-medium text-primary hover:text-primary/80 transition-colors">
                    View
                  </button>
                </div>
              </div>
            </div>
          </.card_content>
        </.card>
      </div>
    </div>
    """
  end

  # ===========================================================================
  # Projects Tab
  # ===========================================================================

  defp projects_tab(assigns) do
    ~H"""
    <div class="p-4 md:p-6 space-y-5 phia-animate-d2">
      <div class="flex items-center justify-between">
        <div>
          <h2 class="text-lg font-bold text-foreground">Your Projects</h2>
          <p class="text-sm text-muted-foreground mt-0.5">{length(@projects)} projects total</p>
        </div>
        <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px] whitespace-nowrap">
          <.icon name="plus" size={:xs} />
          New Project
        </button>
      </div>

      <%!-- Stats summary --%>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
        <.card class="border-border/60 shadow-sm">
          <.card_content class="p-4 text-center">
            <p class="text-2xl font-bold text-foreground tabular-nums">{length(@projects)}</p>
            <p class="text-xs text-muted-foreground">Total</p>
          </.card_content>
        </.card>
        <.card class="border-border/60 shadow-sm">
          <.card_content class="p-4 text-center">
            <p class="text-2xl font-bold text-blue-600 dark:text-blue-400 tabular-nums">{Enum.count(@projects, &(&1.status == "in_progress"))}</p>
            <p class="text-xs text-muted-foreground">In Progress</p>
          </.card_content>
        </.card>
        <.card class="border-border/60 shadow-sm">
          <.card_content class="p-4 text-center">
            <p class="text-2xl font-bold text-emerald-600 dark:text-emerald-400 tabular-nums">{Enum.count(@projects, &(&1.status == "completed"))}</p>
            <p class="text-xs text-muted-foreground">Completed</p>
          </.card_content>
        </.card>
        <.card class="border-border/60 shadow-sm">
          <.card_content class="p-4 text-center">
            <p class="text-2xl font-bold text-amber-600 dark:text-amber-400 tabular-nums">{Enum.count(@projects, &(&1.status == "on_hold")) + Enum.count(@projects, &(&1.status == "planning"))}</p>
            <p class="text-xs text-muted-foreground">On Hold / Planning</p>
          </.card_content>
        </.card>
      </div>

      <%!-- Desktop table --%>
      <.card class="border-border/60 shadow-sm hidden md:block">
        <.card_content class="p-0">
          <div class="overflow-x-auto">
            <table class="w-full text-sm min-w-[580px]">
              <thead>
                <tr class="border-b border-border/60 text-xs text-muted-foreground font-medium">
                  <th class="px-4 py-3 text-left">Project</th>
                  <th class="px-4 py-3 text-left">Status</th>
                  <th class="px-4 py-3 text-left w-36">Progress</th>
                  <th class="px-4 py-3 text-right whitespace-nowrap">Hours</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  :for={proj <- @projects}
                  class="border-b border-border/40 last:border-b-0 hover:bg-muted/30 transition-colors"
                >
                  <td class="px-4 py-3">
                    <div class="flex items-center gap-2.5">
                      <div class="flex h-7 w-7 shrink-0 items-center justify-center rounded-md bg-primary/10">
                        <.icon name="folder" size={:xs} class="text-primary" />
                      </div>
                      <div class="min-w-0">
                        <p class="text-sm font-medium text-foreground truncate max-w-[200px]">{proj.name}</p>
                        <p class="text-xs text-muted-foreground">Updated {proj.updated}</p>
                      </div>
                    </div>
                  </td>
                  <td class="px-4 py-3">
                    <.badge variant={status_variant(proj.status)}>{humanize_status(proj.status)}</.badge>
                  </td>
                  <td class="px-4 py-3">
                    <div class="flex items-center gap-2">
                      <div class="flex-1 h-1.5 rounded-full bg-muted overflow-hidden">
                        <div class="h-full rounded-full bg-primary transition-all" style={"width: #{proj.progress}%"} />
                      </div>
                      <span class="text-xs text-muted-foreground tabular-nums w-8 text-right">{proj.progress}%</span>
                    </div>
                  </td>
                  <td class="px-4 py-3 text-sm font-semibold text-foreground text-right tabular-nums">{proj.hours}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </.card_content>
      </.card>

      <%!-- Mobile cards --%>
      <div class="md:hidden space-y-3">
        <.card :for={proj <- @projects} class="border-border/60 shadow-sm">
          <.card_content class="p-4 space-y-2">
            <div class="flex items-start justify-between gap-2">
              <h3 class="text-sm font-semibold text-foreground truncate">{proj.name}</h3>
              <.badge variant={status_variant(proj.status)}>{humanize_status(proj.status)}</.badge>
            </div>
            <p class="text-xs text-muted-foreground">Updated {proj.updated} · {proj.hours} hours</p>
            <div class="flex items-center gap-2">
              <div class="flex-1 h-1.5 rounded-full bg-muted overflow-hidden">
                <div class="h-full rounded-full bg-primary transition-all" style={"width: #{proj.progress}%"} />
              </div>
              <span class="text-xs text-muted-foreground tabular-nums">{proj.progress}%</span>
            </div>
          </.card_content>
        </.card>
      </div>
    </div>
    """
  end

  # ===========================================================================
  # Helpers
  # ===========================================================================

  defp status_variant("in_progress"), do: :default
  defp status_variant("completed"),   do: :secondary
  defp status_variant("on_hold"),     do: :destructive
  defp status_variant("planning"),    do: :outline
  defp status_variant(_),             do: :secondary

  defp humanize_status("in_progress"), do: "In Progress"
  defp humanize_status("completed"),   do: "Completed"
  defp humanize_status("on_hold"),     do: "On Hold"
  defp humanize_status("planning"),    do: "Planning"
  defp humanize_status(s),             do: s
end
