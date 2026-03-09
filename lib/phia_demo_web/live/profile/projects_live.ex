defmodule PhiaDemoWeb.Demo.Profile.ProjectsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Profile.Layout

  @stats [
    %{label: "Total Projects", value: "10", icon: "folder",        color: "bg-primary/10 text-primary"},
    %{label: "In Progress",    value: "4",  icon: "loader",        color: "bg-blue-500/10 text-blue-600 dark:text-blue-400"},
    %{label: "Completed",      value: "3",  icon: "circle-check",  color: "bg-emerald-500/10 text-emerald-600 dark:text-emerald-400"},
    %{label: "On Hold",        value: "2",  icon: "pause",         color: "bg-amber-500/10 text-amber-600 dark:text-amber-400"}
  ]

  @projects [
    %{name: "Website Redesign",        description: "Marketing site overhaul",              progress: 75,  priority: "high",   status: "in_progress", team: "Design",         team_members: ["Alice", "Bob", "Carol"],          start_date: "Jan 15, 2026", due_date: "Apr 30, 2026"},
    %{name: "Mobile App v2",           description: "Native iOS & Android rewrite",         progress: 45,  priority: "high",   status: "in_progress", team: "Engineering",    team_members: ["David", "Eve"],                   start_date: "Feb 1, 2026",  due_date: "Jun 15, 2026"},
    %{name: "Analytics Dashboard",     description: "Real-time metrics & widgets",          progress: 100, priority: "medium", status: "completed",   team: "Data",           team_members: ["Frank", "Grace", "Hank", "Ivy"],  start_date: "Oct 1, 2025",  due_date: "Jan 31, 2026"},
    %{name: "API Gateway",            description: "Centralized API management",            progress: 30,  priority: "high",   status: "in_progress", team: "Backend",        team_members: ["Jack", "Karen"],                  start_date: "Mar 1, 2026",  due_date: "Jul 31, 2026"},
    %{name: "Design System",          description: "Unified component library",             progress: 90,  priority: "medium", status: "in_progress", team: "Design",         team_members: ["Liam", "Mia", "Noah"],            start_date: "Nov 15, 2025", due_date: "Mar 31, 2026"},
    %{name: "Data Pipeline",          description: "Customer event stream ETL",             progress: 0,   priority: "low",    status: "planning",    team: "Data",           team_members: ["Olivia"],                         start_date: "Apr 1, 2026",  due_date: "Aug 31, 2026"},
    %{name: "Security Audit",         description: "Penetration testing & review",          progress: 60,  priority: "high",   status: "on_hold",     team: "Security",       team_members: ["Paul", "Quinn"],                  start_date: "Dec 1, 2025",  due_date: "Mar 15, 2026"},
    %{name: "Documentation Portal",   description: "Developer docs & API playground",      progress: 100, priority: "medium", status: "completed",   team: "Content",        team_members: ["Rachel", "Sam", "Tina"],          start_date: "Sep 1, 2025",  due_date: "Dec 31, 2025"},
    %{name: "Onboarding Flow",        description: "New user onboarding experience",        progress: 55,  priority: "medium", status: "on_hold",     team: "Product",        team_members: ["Uma", "Victor"],                  start_date: "Jan 1, 2026",  due_date: "May 15, 2026"},
    %{name: "Performance Monitoring", description: "APM & real-time alerting system",       progress: 100, priority: "low",    status: "completed",   team: "Infrastructure", team_members: ["Wendy", "Xander", "Yara"],        start_date: "Aug 1, 2025",  due_date: "Nov 30, 2025"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Projects")
     |> assign(:stats, @stats)
     |> assign(:projects, @projects)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/profile/projects">
      <div class="p-4 md:p-6 space-y-5 max-w-screen-xl mx-auto">

        <%!-- Header --%>
        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 phia-animate">
          <h1 class="text-xl font-bold text-foreground tracking-tight">Projects</h1>
          <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px] whitespace-nowrap">
            <.icon name="plus" size={:xs} />
            New Project
          </button>
        </div>

        <%!-- Stats row --%>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 phia-animate-d1">
          <.card :for={stat <- @stats} class="border-border/60 shadow-sm">
            <.card_content class="p-4 md:p-5 flex items-center gap-3">
              <div class={"flex h-10 w-10 shrink-0 items-center justify-center rounded-lg " <> stat.color}>
                <.icon name={stat.icon} size={:sm} />
              </div>
              <div>
                <p class="text-2xl font-bold text-foreground tabular-nums">{stat.value}</p>
                <p class="text-xs text-muted-foreground">{stat.label}</p>
              </div>
            </.card_content>
          </.card>
        </div>

        <%!-- Desktop Table --%>
        <.card class="border-border/60 shadow-sm hidden md:block phia-animate-d2">
          <.card_content class="p-0">
            <div class="overflow-x-auto">
              <table class="w-full text-sm min-w-[700px]">
                <thead>
                  <tr class="border-b border-border/60 text-xs text-muted-foreground font-medium">
                    <th class="px-4 py-3 text-left">Project</th>
                    <th class="px-4 py-3 text-left">Status</th>
                    <th class="px-4 py-3 text-left">Priority</th>
                    <th class="px-4 py-3 text-left w-32">Progress</th>
                    <th class="px-4 py-3 text-left">Team</th>
                    <th class="px-4 py-3 text-left whitespace-nowrap">Due Date</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    :for={p <- @projects}
                    class="border-b border-border/40 last:border-b-0 hover:bg-muted/30 transition-colors"
                  >
                    <td class="px-4 py-3">
                      <div>
                        <p class="text-sm font-medium text-foreground">{p.name}</p>
                        <p class="text-xs text-muted-foreground">{p.description}</p>
                      </div>
                    </td>
                    <td class="px-4 py-3">
                      <.badge variant={status_variant(p.status)}>{humanize_status(p.status)}</.badge>
                    </td>
                    <td class="px-4 py-3">
                      <.badge variant={priority_variant(p.priority)}>{String.capitalize(p.priority)}</.badge>
                    </td>
                    <td class="px-4 py-3">
                      <div class="flex items-center gap-2">
                        <div class="flex-1 h-1.5 rounded-full bg-muted overflow-hidden">
                          <div class="h-full rounded-full bg-primary transition-all" style={"width: #{p.progress}%"} />
                        </div>
                        <span class="text-xs text-muted-foreground tabular-nums w-8 text-right">{p.progress}%</span>
                      </div>
                    </td>
                    <td class="px-4 py-3">
                      <.avatar_group size="sm" max={3}>
                        <:item :for={name <- p.team_members} name={name} />
                      </.avatar_group>
                    </td>
                    <td class="px-4 py-3 text-xs text-muted-foreground whitespace-nowrap">{p.due_date}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </.card_content>
        </.card>

        <%!-- Mobile Card List --%>
        <div class="md:hidden space-y-3 phia-animate-d2">
          <.card :for={p <- @projects} class="border-border/60 shadow-sm">
            <.card_content class="p-4 space-y-3">
              <div class="flex items-start justify-between gap-2">
                <div class="min-w-0">
                  <h3 class="text-sm font-semibold text-foreground truncate">{p.name}</h3>
                  <p class="text-xs text-muted-foreground mt-0.5">{p.description}</p>
                </div>
                <.badge variant={priority_variant(p.priority)}>{String.capitalize(p.priority)}</.badge>
              </div>

              <div class="flex items-center gap-2">
                <.badge variant={status_variant(p.status)}>{humanize_status(p.status)}</.badge>
                <span class="text-xs text-muted-foreground">Due {p.due_date}</span>
              </div>

              <div class="space-y-1">
                <div class="flex items-center justify-between">
                  <span class="text-xs text-muted-foreground">Progress</span>
                  <span class="text-xs font-semibold text-foreground tabular-nums">{p.progress}%</span>
                </div>
                <div class="h-1.5 w-full rounded-full bg-muted overflow-hidden">
                  <div class="h-full rounded-full bg-primary transition-all" style={"width: #{p.progress}%"} />
                </div>
              </div>

              <div class="flex items-center justify-between pt-1">
                <.avatar_group size="sm" max={3}>
                  <:item :for={name <- p.team_members} name={name} />
                </.avatar_group>
                <span class="text-xs text-muted-foreground">{p.team}</span>
              </div>
            </.card_content>
          </.card>
        </div>

      </div>
    </Layout.layout>
    """
  end

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

  defp priority_variant("high"),   do: :destructive
  defp priority_variant("medium"), do: :secondary
  defp priority_variant("low"),    do: :outline
  defp priority_variant(_),        do: :secondary
end
