defmodule PhiaDemoWeb.Demo.Profile.V1Live do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Profile.Layout

  @transactions [
    %{product: "Mock premium pack",            status: "pending", date: "12/10/2025", amount: "$35"},
    %{product: "Enterprise plan subscription", status: "paid",    date: "11/13/2025", amount: "$155"},
    %{product: "Business board pro license",   status: "paid",    date: "10/13/2025", amount: "$85"},
    %{product: "Custom integration package",   status: "failed",  date: "09/13/2025", amount: "$295"},
    %{product: "Developer toolkit license",    status: "paid",    date: "08/15/2025", amount: "$125"},
    %{product: "Support package renewal",      status: "pending", date: "07/22/2025", amount: "$75"}
  ]

  @connections [
    %{name: "Olivia Davis",    email: "olivia.davis@example.com",    connected: false, color: "bg-orange-500"},
    %{name: "John Doe",        email: "john.doe@example.com",        connected: true,  color: "bg-blue-500"},
    %{name: "Alice Smith",     email: "alice.smith@example.com",     connected: false, color: "bg-violet-500"},
    %{name: "Emily Martinez",  email: "emily.martinez@example.com",  connected: true,  color: "bg-rose-500"},
    %{name: "James Wilson",    email: "james.wilson@example.com",    connected: true,  color: "bg-emerald-500"}
  ]

  @overview_activities [
    %{
      title:  "PhiaUI Application UI v2.0.0",
      badge:  "Latest",
      date:   "Released on December 2nd, 2025",
      desc:   "Get access to over 20+ pages including a dashboard layout, charts, kanban board, calendar, and pre-order E-commerce & Marketing pages.",
      action: "Download ZIP"
    },
    %{
      title: "PhiaUI Figma v1.3.0",
      badge: nil,
      date:  "Released on December 2nd, 2025",
      desc:  "All of the pages and components are first designed in Figma and we keep a parity between the two versions even as we update the project.",
      action: nil
    },
    %{
      title: "PhiaUI Library v1.2.2",
      badge: nil,
      date:  "Released on December 2nd, 2025",
      desc:  "Get started with dozens of web components and interactive elements built on top of Tailwind CSS.",
      action: nil
    }
  ]

  @skills ["Photoshop", "Figma", "HTML", "React", "Tailwind CSS", "CSS", "Laravel", "Node.js"]

  @projects_data [
    %{name: "Website Redesign",     description: "Complete overhaul of the marketing website with new branding guidelines", progress: 75,  status: "in_progress", team: ["Alice", "Bob", "Carol"],            updated: "2 hours ago",  category: "Design"},
    %{name: "Mobile App v2",        description: "Native iOS and Android app with offline-first architecture",              progress: 45,  status: "in_progress", team: ["David", "Eve"],                    updated: "1 day ago",    category: "Engineering"},
    %{name: "Analytics Dashboard",  description: "Real-time metrics dashboard with customizable widgets",                   progress: 100, status: "completed",   team: ["Frank", "Grace", "Hank", "Ivy"],   updated: "3 days ago",   category: "Data"},
    %{name: "API Gateway",          description: "Centralized API management with rate limiting and auth",                  progress: 30,  status: "in_progress", team: ["Jack", "Karen"],                   updated: "5 hours ago",  category: "Backend"},
    %{name: "Design System",        description: "Unified component library for all product teams",                         progress: 90,  status: "in_progress", team: ["Liam", "Mia", "Noah"],             updated: "1 week ago",   category: "Design"},
    %{name: "Data Pipeline",        description: "ETL pipeline for processing customer event streams",                      progress: 0,   status: "planning",    team: ["Olivia"],                          updated: "2 weeks ago",  category: "Data"},
    %{name: "Security Audit",       description: "Comprehensive security review and penetration testing",                   progress: 60,  status: "on_hold",     team: ["Paul", "Quinn"],                   updated: "4 days ago",   category: "Security"},
    %{name: "Documentation Portal", description: "Developer docs site with interactive API playground",                     progress: 100, status: "completed",   team: ["Rachel", "Sam", "Tina"],           updated: "1 day ago",    category: "Content"}
  ]

  @activities_data [
    %{type: "task",     user: "Alice Smith",      action: "completed",   target: "Homepage wireframes",       project: "Website Redesign",    timestamp: "9:12 AM",    date: "Today"},
    %{type: "file",     user: "Bob Johnson",      action: "uploaded",    target: "Q4_Report.pdf",             project: "Analytics Dashboard",  timestamp: "10:30 AM",   date: "Today"},
    %{type: "mention",  user: "Carol White",      action: "mentioned you in", target: "Design review thread", project: "Design System",        timestamp: "11:45 AM",   date: "Today"},
    %{type: "call",     user: "David Brown",      action: "scheduled",   target: "Sprint planning call",      project: "Mobile App v2",        timestamp: "2:00 PM",    date: "Today"},
    %{type: "reaction", user: "Eve Wilson",       action: "reacted to",  target: "your comment",              project: "API Gateway",          timestamp: "3:15 PM",    date: "Yesterday"},
    %{type: "system",   user: "System",           action: "deployed",    target: "v2.4.1 to production",      project: "Website Redesign",     timestamp: "4:00 PM",    date: "Yesterday"},
    %{type: "task",     user: "Frank Lee",        action: "assigned",    target: "Database migration",        project: "Data Pipeline",        timestamp: "9:00 AM",    date: "Yesterday"},
    %{type: "file",     user: "Grace Chen",       action: "shared",      target: "brand-assets.zip",          project: "Design System",        timestamp: "1:20 PM",    date: "Mar 5, 2026"},
    %{type: "mention",  user: "Hank Davis",       action: "mentioned you in", target: "Security checklist",   project: "Security Audit",       timestamp: "10:00 AM",   date: "Mar 5, 2026"},
    %{type: "system",   user: "System",           action: "archived",    target: "Sprint 14 board",           project: "Mobile App v2",        timestamp: "6:00 PM",    date: "Mar 4, 2026"}
  ]

  @members_data [
    %{name: "Alice Smith",     role: "Lead Designer",       email: "alice@example.com",   status: :online,  joined: "Jan 2024", color: "bg-violet-500", department: "Design"},
    %{name: "Bob Johnson",     role: "Senior Developer",    email: "bob@example.com",     status: :online,  joined: "Mar 2024", color: "bg-blue-500",   department: "Engineering"},
    %{name: "Carol White",     role: "Product Manager",     email: "carol@example.com",   status: :away,    joined: "Jun 2024", color: "bg-rose-500",   department: "Product"},
    %{name: "David Brown",     role: "Backend Engineer",    email: "david@example.com",   status: :busy,    joined: "Sep 2024", color: "bg-amber-500",  department: "Engineering"},
    %{name: "Eve Wilson",      role: "QA Engineer",         email: "eve@example.com",     status: :offline, joined: "Nov 2024", color: "bg-emerald-500", department: "QA"},
    %{name: "Frank Lee",       role: "DevOps Engineer",     email: "frank@example.com",   status: :online,  joined: "Feb 2025", color: "bg-orange-500", department: "Infrastructure"},
    %{name: "Grace Chen",      role: "UX Researcher",       email: "grace@example.com",   status: :away,    joined: "Apr 2025", color: "bg-pink-500",   department: "Design"},
    %{name: "Hank Davis",      role: "Security Analyst",    email: "hank@example.com",    status: :offline, joined: "Jul 2025", color: "bg-cyan-500",   department: "Security"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Profile V1")
     |> assign(:active_tab, "Overview")
     |> assign(:transactions, @transactions)
     |> assign(:connections, @connections)
     |> assign(:overview_activities, @overview_activities)
     |> assign(:skills, @skills)
     |> assign(:projects, @projects_data)
     |> assign(:filtered_projects, @projects_data)
     |> assign(:activities, @activities_data)
     |> assign(:members, @members_data)
     |> assign(:filtered_members, @members_data)}
  end

  @impl true
  def handle_event("switch-tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def handle_event("search-projects", %{"value" => query}, socket) do
    filtered =
      if String.trim(query) == "" do
        @projects_data
      else
        q = String.downcase(query)
        Enum.filter(@projects_data, fn p -> String.contains?(String.downcase(p.name), q) end)
      end

    {:noreply, assign(socket, :filtered_projects, filtered)}
  end

  def handle_event("search-members", %{"value" => query}, socket) do
    filtered =
      if String.trim(query) == "" do
        @members_data
      else
        q = String.downcase(query)

        Enum.filter(@members_data, fn m ->
          String.contains?(String.downcase(m.name), q) or
            String.contains?(String.downcase(m.role), q)
        end)
      end

    {:noreply, assign(socket, :filtered_members, filtered)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/profile">
      <div class="p-4 md:p-6 space-y-5 max-w-screen-xl mx-auto">

        <%!-- Page Header --%>
        <div class="flex items-center justify-between phia-animate">
          <h1 class="text-xl font-bold text-foreground tracking-tight">Profile Page</h1>
          <button class="inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-2 text-sm font-medium text-foreground hover:bg-accent transition-colors min-h-[44px]">
            <.icon name="settings" size={:xs} />
            Settings
          </button>
        </div>

        <%!-- Tabs --%>
        <div class="flex items-center gap-0.5 border-b border-border/60 phia-animate-d1 overflow-x-auto">
          <%= for tab <- ["Overview", "Projects", "Activities", "Members"] do %>
            <button
              phx-click="switch-tab"
              phx-value-tab={tab}
              class={[
                "px-4 py-2.5 text-sm font-medium transition-colors -mb-px border-b-2 min-h-[44px] whitespace-nowrap",
                if tab == @active_tab do
                  "border-primary text-primary"
                else
                  "border-transparent text-muted-foreground hover:text-foreground"
                end
              ]}
            >
              {tab}
            </button>
          <% end %>
        </div>

        <%!-- Tab Content --%>
        <%= case @active_tab do %>
          <% "Overview" -> %>
            <.overview_tab
              transactions={@transactions}
              connections={@connections}
              overview_activities={@overview_activities}
              skills={@skills}
            />
          <% "Projects" -> %>
            <.projects_tab projects={@filtered_projects} />
          <% "Activities" -> %>
            <.activities_tab activities={@activities} />
          <% "Members" -> %>
            <.members_tab members={@filtered_members} />
        <% end %>

      </div>
    </Layout.layout>
    """
  end

  # ===========================================================================
  # Overview Tab (original content)
  # ===========================================================================

  defp overview_tab(assigns) do
    ~H"""
    <div class="grid grid-cols-1 lg:grid-cols-[340px_1fr] gap-5 phia-animate-d2">

      <%!-- Left — Profile Card --%>
      <.card class="border-border/60 shadow-sm self-start">
        <.card_content class="p-6 flex flex-col items-center text-center">

          <%!-- Avatar --%>
          <div class="h-20 w-20 rounded-full bg-gradient-to-br from-amber-400 to-rose-500 flex items-center justify-center text-white text-2xl font-bold mb-4 ring-4 ring-background shadow-lg shrink-0">
            AH
          </div>

          <%!-- Name + Pro badge + title --%>
          <div class="flex items-center gap-2 mb-1">
            <h2 class="text-lg font-bold text-foreground">Anshan Haso</h2>
            <span class="inline-flex items-center rounded-full bg-primary px-2 py-0.5 text-[10px] font-bold text-primary-foreground leading-none">
              Pro
            </span>
          </div>
          <p class="text-sm text-muted-foreground mb-6">Project Manager</p>

          <%!-- Stats row --%>
          <div class="flex w-full justify-around border-t border-border/60 pt-5 mb-6">
            <div class="text-center">
              <p class="text-xl font-bold text-foreground tabular-nums">184</p>
              <p class="text-xs text-muted-foreground mt-0.5">Post</p>
            </div>
            <div class="w-px bg-border/60" />
            <div class="text-center">
              <p class="text-xl font-bold text-foreground tabular-nums">32</p>
              <p class="text-xs text-muted-foreground mt-0.5">Projects</p>
            </div>
            <div class="w-px bg-border/60" />
            <div class="text-center">
              <p class="text-xl font-bold text-foreground tabular-nums">4.5K</p>
              <p class="text-xs text-muted-foreground mt-0.5">Members</p>
            </div>
          </div>

          <%!-- Contact info --%>
          <div class="w-full space-y-3 text-left mb-6">
            <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
              <.icon name="send" size={:xs} class="shrink-0 text-muted-foreground/60" />
              <span class="truncate">hello@tobybelhome.com</span>
            </div>
            <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
              <.icon name="message-circle" size={:xs} class="shrink-0 text-muted-foreground/60" />
              <span>(+1-876) 8654 239 581</span>
            </div>
            <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
              <.icon name="home" size={:xs} class="shrink-0 text-muted-foreground/60" />
              <span>Canada</span>
            </div>
            <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
              <.icon name="link" size={:xs} class="shrink-0 text-muted-foreground/60" />
              <span class="truncate">https://phiaui.dev</span>
            </div>
            <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
              <.icon name="link" size={:xs} class="shrink-0 text-muted-foreground/60" />
              <span class="truncate">https://hexdocs.pm/phia_ui</span>
            </div>
          </div>

          <%!-- Complete Your Profile --%>
          <div class="w-full mb-6">
            <div class="flex items-center justify-between mb-2">
              <p class="text-sm font-semibold text-foreground">Complete Your Profile</p>
              <span class="text-xs text-muted-foreground">3/6</span>
            </div>
            <div class="h-2 w-full rounded-full bg-muted overflow-hidden">
              <div class="h-full rounded-full bg-primary transition-all" style="width: 50%" />
            </div>
          </div>

          <%!-- Skills --%>
          <div class="w-full text-left">
            <p class="text-sm font-semibold text-foreground mb-3">Skills</p>
            <div class="flex flex-wrap gap-2">
              <span
                :for={skill <- @skills}
                class="inline-flex items-center rounded-md border border-border bg-muted/50 px-2.5 py-1 text-xs font-medium text-foreground"
              >
                {skill}
              </span>
            </div>
          </div>

        </.card_content>
      </.card>

      <%!-- Right — Activity + Transactions + Connections --%>
      <div class="space-y-5 min-w-0">

        <%!-- Latest Activity --%>
        <.card class="border-border/60 shadow-sm">
          <.card_header class="pb-3">
            <div class="flex items-center justify-between">
              <.card_title>Latest Activity</.card_title>
              <button class="text-sm font-medium text-primary hover:text-primary/80 transition-colors">
                View All
              </button>
            </div>
          </.card_header>
          <.card_content class="px-6 pb-6 space-y-5">
            <%= for activity <- @overview_activities do %>
              <div class="flex gap-3 pb-5 last:pb-0 border-b border-border/40 last:border-b-0">
                <div class="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-primary/10">
                  <.icon name="layers" size={:xs} class="text-primary" />
                </div>
                <div class="flex-1 min-w-0">
                  <div class="flex flex-wrap items-center gap-2 mb-1">
                    <p class="text-sm font-semibold text-foreground">{activity.title}</p>
                    <span
                      :if={activity.badge}
                      class="inline-flex items-center rounded-full bg-emerald-500/10 px-2 py-0.5 text-[10px] font-bold text-emerald-600 dark:text-emerald-400"
                    >
                      {activity.badge}
                    </span>
                  </div>
                  <p class="text-xs text-muted-foreground mb-1.5 flex items-center gap-1">
                    <.icon name="calendar" size={:xs} />
                    {activity.date}
                  </p>
                  <p class="text-sm text-muted-foreground leading-relaxed">{activity.desc}</p>
                  <button
                    :if={activity.action}
                    class="mt-3 inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-1.5 text-xs font-medium text-foreground hover:bg-accent transition-colors"
                  >
                    <.icon name="upload" size={:xs} class="rotate-180" />
                    {activity.action}
                  </button>
                </div>
              </div>
            <% end %>
          </.card_content>
        </.card>

        <%!-- Transaction History + Connections (side by side on md+) --%>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

          <%!-- Transaction History --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-3">
              <.card_title>Transaction History</.card_title>
            </.card_header>
            <.card_content class="p-0">
              <div class="overflow-x-auto">
                <table class="w-full text-sm min-w-[360px]">
                  <thead>
                    <tr class="border-b border-border/60 text-xs text-muted-foreground font-medium">
                      <th class="px-4 py-2.5 text-left">Product</th>
                      <th class="px-4 py-2.5 text-left">Status</th>
                      <th class="px-4 py-2.5 text-left whitespace-nowrap">Date</th>
                      <th class="px-4 py-2.5 text-right whitespace-nowrap">Amt</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr
                      :for={t <- @transactions}
                      class="border-b border-border/40 last:border-b-0 hover:bg-muted/30 transition-colors"
                    >
                      <td class="px-4 py-3 font-medium text-foreground text-xs max-w-[130px] truncate">
                        {t.product}
                      </td>
                      <td class="px-4 py-3">
                        <span class={[
                          "inline-flex items-center rounded-full px-2 py-0.5 text-[10px] font-semibold whitespace-nowrap",
                          case t.status do
                            "paid"    -> "bg-emerald-500/10 text-emerald-700 dark:text-emerald-400"
                            "pending" -> "bg-amber-500/10 text-amber-700 dark:text-amber-400"
                            "failed"  -> "bg-red-500/10 text-red-700 dark:text-red-400"
                            _         -> "bg-muted text-muted-foreground"
                          end
                        ]}>
                          {t.status}
                        </span>
                      </td>
                      <td class="px-4 py-3 text-xs text-muted-foreground whitespace-nowrap">{t.date}</td>
                      <td class="px-4 py-3 text-xs font-semibold text-foreground text-right tabular-nums">
                        {t.amount}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </.card_content>
          </.card>

          <%!-- Connections --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-3">
              <.card_title>Connections</.card_title>
            </.card_header>
            <.card_content class="px-6 pb-5 space-y-4">
              <div
                :for={conn <- @connections}
                class="flex items-center gap-3"
              >
                <div class={"flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-white text-sm font-bold " <> conn.color}>
                  {String.first(conn.name)}
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-semibold text-foreground truncate">{conn.name}</p>
                  <p class="text-xs text-muted-foreground truncate">{conn.email}</p>
                </div>
                <button class={[
                  "shrink-0 rounded-lg border px-3 py-1.5 text-xs font-semibold transition-colors min-h-[36px]",
                  if conn.connected do
                    "border-border text-muted-foreground hover:bg-accent hover:text-foreground"
                  else
                    "border-primary/40 bg-primary/10 text-primary hover:bg-primary hover:text-primary-foreground"
                  end
                ]}>
                  {if conn.connected, do: "Disconnect", else: "Connect"}
                </button>
              </div>
            </.card_content>
          </.card>

        </div>
      </div>
    </div>
    """
  end

  # ===========================================================================
  # Projects Tab
  # ===========================================================================

  defp projects_tab(assigns) do
    ~H"""
    <div class="space-y-5 phia-animate-d2">
      <%!-- Search + action --%>
      <div class="flex flex-col sm:flex-row items-start sm:items-center gap-3">
        <div class="relative flex-1 w-full">
          <.icon name="search" size={:xs} class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
          <input
            type="text"
            placeholder="Search projects..."
            phx-keyup="search-projects"
            phx-debounce="300"
            class="w-full rounded-lg border border-border bg-background pl-9 pr-3 py-2.5 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring min-h-[44px]"
          />
        </div>
        <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px] whitespace-nowrap">
          <.icon name="plus" size={:xs} />
          New Project
        </button>
      </div>

      <%!-- Project cards grid --%>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <.card :for={project <- @projects} class="border-border/60 shadow-sm">
          <.card_content class="p-4 md:p-5 space-y-3">
            <div class="flex items-start justify-between gap-2">
              <h3 class="text-sm font-semibold text-foreground truncate">{project.name}</h3>
              <.badge variant={status_variant(project.status)}>
                {humanize_status(project.status)}
              </.badge>
            </div>

            <p class="text-xs text-muted-foreground leading-relaxed line-clamp-2">{project.description}</p>

            <%!-- Progress bar --%>
            <div class="space-y-1.5">
              <div class="flex items-center justify-between">
                <span class="text-xs text-muted-foreground">Progress</span>
                <span class="text-xs font-semibold text-foreground tabular-nums">{project.progress}%</span>
              </div>
              <div class="h-1.5 w-full rounded-full bg-muted overflow-hidden">
                <div class="h-full rounded-full bg-primary transition-all" style={"width: #{project.progress}%"} />
              </div>
            </div>

            <%!-- Footer: avatar group + timestamp --%>
            <div class="flex items-center justify-between pt-1">
              <.avatar_group size="sm" max={3}>
                <:item :for={name <- project.team} name={name} />
              </.avatar_group>
              <span class="text-xs text-muted-foreground">{project.updated}</span>
            </div>
          </.card_content>
        </.card>
      </div>
    </div>
    """
  end

  # ===========================================================================
  # Activities Tab
  # ===========================================================================

  defp activities_tab(assigns) do
    grouped = group_activities_by_date(assigns.activities)
    assigns = assign(assigns, :grouped, grouped)

    ~H"""
    <div class="space-y-5 phia-animate-d2">
      <.activity_feed id="profile-activity">
        <.activity_group :for={{date, items} <- @grouped} label={date}>
          <.activity_item :for={a <- items} type={a.type} timestamp={a.timestamp}>
            <strong>{a.user}</strong> {a.action} <strong>{a.target}</strong>
            <span class="text-muted-foreground">in {a.project}</span>
          </.activity_item>
        </.activity_group>
      </.activity_feed>

      <div class="flex justify-center">
        <button class="inline-flex items-center gap-1.5 rounded-lg border border-border px-4 py-2.5 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-foreground transition-colors min-h-[44px]">
          <.icon name="chevron-down" size={:xs} />
          Load more
        </button>
      </div>
    </div>
    """
  end

  # ===========================================================================
  # Members Tab
  # ===========================================================================

  defp members_tab(assigns) do
    ~H"""
    <div class="space-y-5 phia-animate-d2">
      <%!-- Search + action --%>
      <div class="flex flex-col sm:flex-row items-start sm:items-center gap-3">
        <div class="relative flex-1 w-full">
          <.icon name="search" size={:xs} class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
          <input
            type="text"
            placeholder="Search members..."
            phx-keyup="search-members"
            phx-debounce="300"
            class="w-full rounded-lg border border-border bg-background pl-9 pr-3 py-2.5 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring min-h-[44px]"
          />
        </div>
        <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px] whitespace-nowrap">
          <.icon name="user-plus" size={:xs} />
          Invite Member
        </button>
      </div>

      <%!-- Member cards grid --%>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <.card :for={member <- @members} class="border-border/60 shadow-sm">
          <.card_content class="p-4 md:p-5">
            <div class="flex items-start gap-3">
              <%!-- Avatar circle --%>
              <div class={"flex h-11 w-11 shrink-0 items-center justify-center rounded-full text-white text-sm font-bold " <> member.color}>
                {String.first(member.name)}
              </div>

              <div class="flex-1 min-w-0 space-y-1">
                <div class="flex items-center gap-2">
                  <h3 class="text-sm font-semibold text-foreground truncate">{member.name}</h3>
                  <.status_indicator status={member.status} size={:sm} />
                </div>
                <p class="text-xs font-medium text-muted-foreground">{member.role}</p>
                <p class="text-xs text-muted-foreground truncate">{member.email}</p>
                <p class="text-xs text-muted-foreground/60 pt-1">
                  <.icon name="calendar" size={:xs} class="inline-block mr-1 -mt-px" />
                  Joined {member.joined}
                </p>
              </div>
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

  defp group_activities_by_date(activities) do
    activities
    |> Enum.group_by(& &1.date)
    |> Enum.sort_by(fn {date, _} ->
      case date do
        "Today"     -> 0
        "Yesterday" -> 1
        _           -> 2
      end
    end)
  end
end
