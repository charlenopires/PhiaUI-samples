defmodule PhiaDemoWeb.Demo.Tasks.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Tasks.Layout

  @issues [
    %{id: "PHX-001", title: "DataGrid row selection not working in Firefox", status: :bug, priority: :high, assignee: "AC", project: "Dashboard", created: "Mar 1"},
    %{id: "PHX-002", title: "Add Kanban board to showcase", status: :feature, priority: :high, assignee: "BL", project: "Components", created: "Mar 1"},
    %{id: "PHX-003", title: "Dark mode flicker on initial load", status: :bug, priority: :medium, assignee: "CS", project: "PhiaUI Core", created: "Feb 28"},
    %{id: "PHX-004", title: "Implement virtual scrolling for large lists", status: :enhancement, priority: :medium, assignee: "DM", project: "PhiaUI Core", created: "Feb 28"},
    %{id: "PHX-005", title: "Write Accordion component docs", status: :docs, priority: :low, assignee: "ER", project: "PhiaUI Core", created: "Feb 27"},
    %{id: "PHX-006", title: "Add animation presets to Button", status: :enhancement, priority: :low, assignee: "AC", project: "PhiaUI Core", created: "Feb 27"},
    %{id: "PHX-007", title: "Tooltip positioning broken on scroll", status: :bug, priority: :high, assignee: "BL", project: "Components", created: "Feb 26"},
    %{id: "PHX-008", title: "Implement Notes app demo", status: :feature, priority: :medium, assignee: "CS", project: "Dashboard", created: "Feb 26"},
    %{id: "PHX-009", title: "Add command palette to showcase", status: :feature, priority: :medium, assignee: "DM", project: "Components", created: "Feb 25"},
    %{id: "PHX-010", title: "Performance: reduce re-renders in DataGrid", status: :enhancement, priority: :high, assignee: "ER", project: "PhiaUI Core", created: "Feb 25"},
    %{id: "PHX-011", title: "Add Gantt chart component", status: :feature, priority: :low, assignee: "AC", project: "PhiaUI Core", created: "Feb 24"},
    %{id: "PHX-012", title: "Fix Button loading state animation", status: :bug, priority: :medium, assignee: "BL", project: "PhiaUI Core", created: "Feb 24"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Tasks")
     |> assign(:issues, @issues)
     |> assign(:status_filter, :all)
     |> assign(:priority_filter, :all)
     |> assign(:search, "")
     |> assign(:selected_ids, [])
     |> assign(:create_open, false)}
  end

  @impl true
  def handle_event("filter-status", %{"status" => s}, socket) do
    {:noreply, assign(socket, :status_filter, String.to_existing_atom(s))}
  end

  def handle_event("filter-priority", %{"priority" => p}, socket) do
    {:noreply, assign(socket, :priority_filter, String.to_existing_atom(p))}
  end

  def handle_event("search", %{"value" => q}, socket) do
    {:noreply, assign(socket, :search, q)}
  end

  def handle_event("toggle-select", %{"id" => id}, socket) do
    selected = if id in socket.assigns.selected_ids,
      do: List.delete(socket.assigns.selected_ids, id),
      else: [id | socket.assigns.selected_ids]
    {:noreply, assign(socket, :selected_ids, selected)}
  end

  def handle_event("clear-selection", _params, socket) do
    {:noreply, assign(socket, :selected_ids, [])}
  end

  def handle_event("open-create", _params, socket) do
    {:noreply, assign(socket, :create_open, true)}
  end

  def handle_event("close-create", _params, socket) do
    {:noreply, assign(socket, :create_open, false)}
  end

  @impl true
  def render(assigns) do
    filtered = Enum.filter(assigns.issues, fn i ->
      status_ok = assigns.status_filter == :all or i.status == assigns.status_filter
      priority_ok = assigns.priority_filter == :all or i.priority == assigns.priority_filter
      search_ok = assigns.search == "" or String.contains?(String.downcase(i.title), String.downcase(assigns.search))
      status_ok and priority_ok and search_ok
    end)
    assigns = assign(assigns, :filtered, filtered)

    ~H"""
    <Layout.layout current_path="/tasks">
      <div class="p-3 sm:p-4 lg:p-6 space-y-5 max-w-screen-xl mx-auto phia-animate">

        <%!-- Header --%>
        <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h1 class="text-xl font-bold text-foreground tracking-tight">Issues</h1>
            <p class="text-sm text-muted-foreground mt-0.5">{length(@issues)} total · {length(@filtered)} shown</p>
          </div>
          <.button phx-click="open-create" class="self-start sm:self-auto">
            <.icon name="plus" size={:xs} class="mr-1.5" />
            New Issue
          </.button>
        </div>

        <%!-- Filters --%>
        <div class="flex flex-wrap items-center gap-3">
          <%!-- Search --%>
          <div class="relative">
            <.icon name="search" size={:xs} class="absolute left-2.5 top-1/2 -translate-y-1/2 text-muted-foreground/60" />
            <input
              type="text"
              placeholder="Search issues..."
              phx-keyup="search"
              phx-value-value=""
              aria-label="Search issues"
              class="rounded-md border border-border bg-background pl-8 pr-3 py-1.5 text-sm focus:outline-none focus:ring-1 focus:ring-primary/40 w-full sm:w-64"
            />
          </div>
          <%!-- Status filter --%>
          <div class="flex flex-wrap gap-1">
            <%= for {label, val} <- [{"All", :all}, {"Bug", :bug}, {"Feature", :feature}, {"Enhancement", :enhancement}, {"Docs", :docs}] do %>
              <button
                phx-click="filter-status"
                phx-value-status={val}
                class={[
                  "rounded-md px-2.5 py-2 text-xs font-medium transition-all border min-h-[44px] sm:min-h-0 sm:py-1.5",
                  if(@status_filter == val,
                    do: "bg-primary text-primary-foreground border-primary",
                    else: "border-border text-muted-foreground hover:border-primary/40 hover:text-foreground"
                  )
                ]}
              >
                {label}
              </button>
            <% end %>
          </div>
          <%!-- Priority filter --%>
          <div class="flex flex-wrap gap-1 sm:ml-auto">
            <%= for {label, val} <- [{"All", :all}, {"High", :high}, {"Medium", :medium}, {"Low", :low}] do %>
              <button
                phx-click="filter-priority"
                phx-value-priority={val}
                class={[
                  "rounded-md px-2.5 py-2 text-xs font-medium transition-all border min-h-[44px] sm:min-h-0 sm:py-1.5",
                  if(@priority_filter == val,
                    do: "bg-primary text-primary-foreground border-primary",
                    else: "border-border text-muted-foreground hover:border-primary/40 hover:text-foreground"
                  )
                ]}
              >
                {label}
              </button>
            <% end %>
          </div>
        </div>

        <%!-- Bulk action bar --%>
        <div :if={@selected_ids != []} class="flex items-center gap-3 rounded-lg border border-primary/30 bg-primary/5 px-4 py-2.5">
          <span class="text-sm font-semibold text-primary">{length(@selected_ids)} selected</span>
          <.separator orientation="vertical" class="h-4" />
          <.button variant={:outline} size={:sm} phx-click="clear-selection">Clear selection</.button>
          <.button variant={:destructive} size={:sm}>Delete selected</.button>
        </div>

        <%!-- Issues table --%>
        <.card class="border-border/60 shadow-sm">
          <div class="overflow-x-auto">
            <table class="w-full text-sm">
              <thead>
                <tr class="border-b border-border/60">
                  <th class="w-10 px-4 py-3"></th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Issue</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Status</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Priority</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Project</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Assignee</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Created</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-border/40">
                <%= for issue <- @filtered do %>
                  <tr class={["group hover:bg-accent/50 transition-colors", if(issue.id in @selected_ids, do: "bg-primary/5")]}>
                    <td class="px-4 py-3">
                      <button
                        phx-click="toggle-select"
                        phx-value-id={issue.id}
                        class={[
                          "h-6 w-6 sm:h-4 sm:w-4 rounded border-2 flex items-center justify-center transition-all",
                          if(issue.id in @selected_ids, do: "border-primary bg-primary", else: "border-border hover:border-primary")
                        ]}
                        aria-label={"Select issue " <> issue.id}
                      >
                        <.icon :if={issue.id in @selected_ids} name="check" size={:xs} class="text-primary-foreground" />
                      </button>
                    </td>
                    <td class="px-4 py-3">
                      <div>
                        <span class="font-mono text-[10px] text-muted-foreground/60 mr-2">{issue.id}</span>
                        <span class="font-medium text-foreground">{issue.title}</span>
                      </div>
                    </td>
                    <td class="px-4 py-3">
                      <.badge variant={status_variant(issue.status)} class="text-[10px] capitalize">
                        {to_string(issue.status)}
                      </.badge>
                    </td>
                    <td class="px-4 py-3">
                      <div class="flex items-center gap-1.5">
                        <span class={"h-2 w-2 rounded-full " <> priority_dot(issue.priority)} />
                        <span class="text-xs text-muted-foreground capitalize">{to_string(issue.priority)}</span>
                      </div>
                    </td>
                    <td class="px-4 py-3 text-xs text-muted-foreground">{issue.project}</td>
                    <td class="px-4 py-3">
                      <span class="flex h-6 w-6 items-center justify-center rounded-full bg-primary/10 text-[10px] font-semibold text-primary">
                        {issue.assignee}
                      </span>
                    </td>
                    <td class="px-4 py-3 text-xs text-muted-foreground">{issue.created}</td>
                  </tr>
                <% end %>
              </tbody>
            </table>
            <.empty :if={@filtered == []} class="py-12">
              <:icon><.icon name="search" /></:icon>
              <:title>No issues found</:title>
              <:description>Try adjusting your filters</:description>
            </.empty>
          </div>
        </.card>

        <%!-- Create issue dialog --%>
        <.alert_dialog id="create-issue" open={@create_open}>
          <.alert_dialog_header>
            <.alert_dialog_title>Create New Issue</.alert_dialog_title>
            <.alert_dialog_description>Add a new issue to the tracker</.alert_dialog_description>
          </.alert_dialog_header>
          <div class="space-y-4 p-1">
            <div>
              <label class="text-xs font-medium text-muted-foreground">Title</label>
              <input type="text" placeholder="Issue title..." class="w-full mt-1 rounded-md border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-1 focus:ring-primary/40" />
            </div>
            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="text-xs font-medium text-muted-foreground">Status</label>
                <select class="w-full mt-1 rounded-md border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-1 focus:ring-primary/40">
                  <option>Bug</option>
                  <option>Feature</option>
                  <option>Enhancement</option>
                  <option>Docs</option>
                </select>
              </div>
              <div>
                <label class="text-xs font-medium text-muted-foreground">Priority</label>
                <select class="w-full mt-1 rounded-md border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-1 focus:ring-primary/40">
                  <option>High</option>
                  <option>Medium</option>
                  <option>Low</option>
                </select>
              </div>
            </div>
          </div>
          <.alert_dialog_footer>
            <.alert_dialog_cancel phx-click="close-create">Cancel</.alert_dialog_cancel>
            <.alert_dialog_action phx-click="close-create">Create Issue</.alert_dialog_action>
          </.alert_dialog_footer>
        </.alert_dialog>

      </div>
    </Layout.layout>
    """
  end

  defp status_variant(:bug), do: :destructive
  defp status_variant(:feature), do: :default
  defp status_variant(:enhancement), do: :secondary
  defp status_variant(:docs), do: :outline

  defp priority_dot(:high), do: "bg-destructive"
  defp priority_dot(:medium), do: "bg-amber-500"
  defp priority_dot(:low), do: "bg-muted-foreground"
end
