defmodule PhiaDemoWeb.Demo.Profile.TeamsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Profile.Layout

  @teams [
    %{name: "Product Design",      description: "UI/UX design, prototyping, and design system maintenance",              members: 8,  category: "Design",        color: "bg-violet-500", member_names: ["Alice", "Grace", "Liam", "Mia", "Noah", "Quinn", "Rachel", "Sam"]},
    %{name: "Core Engineering",    description: "Backend infrastructure, API development, and system architecture",      members: 12, category: "Engineering",   color: "bg-blue-500",   member_names: ["Bob", "David", "Frank", "Jack", "Karen", "Paul", "Tina", "Victor", "Wendy", "Xander", "Yara", "Zane"]},
    %{name: "Growth & Marketing",  description: "User acquisition, analytics, and go-to-market strategy",                members: 6,  category: "Marketing",     color: "bg-emerald-500", member_names: ["Carol", "Eve", "Hank", "Ivy", "Oscar", "Uma"]},
    %{name: "Quality Assurance",   description: "Automated testing, regression suites, and release validation",          members: 5,  category: "QA",            color: "bg-amber-500",  member_names: ["Eve", "Frank", "Grace", "Hank", "Ivy"]},
    %{name: "DevOps & Platform",   description: "CI/CD pipelines, cloud infrastructure, and monitoring",                  members: 4,  category: "Infrastructure", color: "bg-orange-500", member_names: ["Frank", "Jack", "Paul", "Victor"]},
    %{name: "Security & Compliance", description: "Vulnerability assessments, audits, and regulatory compliance",        members: 3,  category: "Security",      color: "bg-rose-500",   member_names: ["Hank", "Paul", "Quinn"]}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Teams")
     |> assign(:teams, @teams)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/profile/teams">
      <div class="p-4 md:p-6 space-y-5 max-w-screen-xl mx-auto">

        <%!-- Header --%>
        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 phia-animate">
          <div>
            <h1 class="text-xl font-bold text-foreground tracking-tight">Teams</h1>
            <p class="text-sm text-muted-foreground mt-0.5">{length(@teams)} teams in your organization</p>
          </div>
          <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px] whitespace-nowrap">
            <.icon name="plus" size={:xs} />
            Create Team
          </button>
        </div>

        <%!-- Team cards grid --%>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 phia-animate-d1">
          <.card :for={team <- @teams} class="border-border/60 shadow-sm hover:shadow-md transition-shadow">
            <.card_content class="p-4 md:p-5 space-y-4">
              <div class="flex items-start gap-3">
                <%!-- Icon square --%>
                <div class={"flex h-10 w-10 shrink-0 items-center justify-center rounded-lg text-white " <> team.color}>
                  <.icon name="users" size={:sm} />
                </div>
                <div class="flex-1 min-w-0">
                  <div class="flex items-center gap-2 mb-0.5">
                    <h3 class="text-sm font-semibold text-foreground truncate">{team.name}</h3>
                    <.badge variant={:outline}>{team.category}</.badge>
                  </div>
                  <p class="text-xs text-muted-foreground leading-relaxed line-clamp-2">{team.description}</p>
                </div>
              </div>

              <%!-- Footer: avatars + count --%>
              <div class="flex items-center justify-between pt-1 border-t border-border/40">
                <.avatar_group size="sm" max={4}>
                  <:item :for={name <- team.member_names} name={name} />
                </.avatar_group>
                <span class="text-xs text-muted-foreground tabular-nums">{team.members} members</span>
              </div>
            </.card_content>
          </.card>
        </div>

      </div>
    </Layout.layout>
    """
  end
end
