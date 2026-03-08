defmodule PhiaDemoWeb.Demo.Kanban.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Kanban.Layout

  @columns [
    %{id: :backlog,     label: "Backlog",      color: "text-muted-foreground", dot: "bg-slate-400",    band: "bg-slate-200 dark:bg-slate-700",     col_bg: "bg-slate-50/60 dark:bg-slate-900/30"},
    %{id: :in_progress, label: "In Progress", color: "text-blue-600 dark:text-blue-400",  dot: "bg-blue-500",    band: "bg-blue-200 dark:bg-blue-800/60",    col_bg: "bg-blue-50/40 dark:bg-blue-950/20"},
    %{id: :review,      label: "Review",      color: "text-amber-600 dark:text-amber-400", dot: "bg-amber-500",   band: "bg-amber-200 dark:bg-amber-800/60",  col_bg: "bg-amber-50/40 dark:bg-amber-950/20"},
    %{id: :done,        label: "Done",        color: "text-green-600 dark:text-green-400", dot: "bg-green-500",   band: "bg-green-200 dark:bg-green-800/60",  col_bg: "bg-green-50/40 dark:bg-green-950/20"}
  ]

  @initial_cards [
    %{id: 1, title: "Setup PhiaUI v0.2 design tokens", priority: :high, column: :backlog, assignee: "AC", tags: ["design", "tokens"]},
    %{id: 2, title: "Implement Kanban board component", priority: :high, column: :in_progress, assignee: "BL", tags: ["feature"]},
    %{id: 3, title: "Write component documentation", priority: :medium, column: :in_progress, assignee: "CS", tags: ["docs"]},
    %{id: 4, title: "Add dark mode to all components", priority: :medium, column: :review, assignee: "DM", tags: ["dark-mode"]},
    %{id: 5, title: "Performance audit and optimization", priority: :low, column: :backlog, assignee: "ER", tags: ["perf"]},
    %{id: 6, title: "Publish v0.1.5 release notes", priority: :low, column: :done, assignee: "AC", tags: ["release"]},
    %{id: 7, title: "Fix drag-and-drop on mobile", priority: :high, column: :backlog, assignee: "BL", tags: ["bug", "mobile"]},
    %{id: 8, title: "Review accessibility audit", priority: :medium, column: :review, assignee: "CS", tags: ["a11y"]},
    %{id: 9, title: "Create Storybook stories", priority: :low, column: :done, assignee: "DM", tags: ["storybook"]}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Kanban Board")
     |> assign(:cards, @initial_cards)
     |> assign(:columns, @columns)
     |> assign(:new_card_title, "")
     |> assign(:adding_to, nil)}
  end

  @impl true
  def handle_event("add-card", %{"column" => col}, socket) do
    {:noreply, assign(socket, :adding_to, String.to_existing_atom(col))}
  end

  def handle_event("cancel-add", _params, socket) do
    {:noreply, assign(socket, adding_to: nil, new_card_title: "")}
  end

  def handle_event("update-new-card", %{"value" => val}, socket) do
    {:noreply, assign(socket, :new_card_title, val)}
  end

  def handle_event("save-card", _params, socket) do
    title = String.trim(socket.assigns.new_card_title)
    column = socket.assigns.adding_to

    if title == "" or is_nil(column) do
      {:noreply, socket}
    else
      new_id = (Enum.map(socket.assigns.cards, & &1.id) |> Enum.max(fn -> 0 end)) + 1
      new_card = %{id: new_id, title: title, priority: :medium, column: column, assignee: "ME", tags: []}
      {:noreply,
       socket
       |> update(:cards, &[new_card | &1])
       |> assign(:adding_to, nil)
       |> assign(:new_card_title, "")}
    end
  end

  def handle_event("move-card", %{"card_id" => id, "column" => col}, socket) do
    card_id = String.to_integer(id)
    new_col = String.to_existing_atom(col)
    cards = Enum.map(socket.assigns.cards, fn c ->
      if c.id == card_id, do: %{c | column: new_col}, else: c
    end)
    {:noreply, assign(socket, :cards, cards)}
  end

  def handle_event("delete-card", %{"id" => id}, socket) do
    card_id = String.to_integer(id)
    {:noreply, update(socket, :cards, &Enum.reject(&1, fn c -> c.id == card_id end))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/kanban">
      <div class="p-3 sm:p-4 lg:p-6 h-full flex flex-col gap-4 sm:gap-6 max-w-screen-2xl mx-auto">

        <%!-- Header --%>
        <div class="flex items-center justify-between phia-animate">
          <div>
            <h1 class="text-lg sm:text-xl font-bold text-foreground tracking-tight">Project Board</h1>
            <p class="text-xs sm:text-sm text-muted-foreground mt-0.5">PhiaUI v0.2 — Sprint 3</p>
          </div>
          <div class="flex items-center gap-2">
            <.badge variant={:secondary}>{length(@cards)} cards</.badge>
            <.badge variant={:outline} class="hidden sm:inline-flex">{length(Enum.filter(@cards, &(&1.column == :done)))} done</.badge>
          </div>
        </div>

        <%!-- Columns --%>
        <div class="flex overflow-x-auto gap-4 pb-2 sm:grid sm:grid-cols-2 xl:grid-cols-4 flex-1 min-h-0 phia-animate-d1 snap-x snap-mandatory sm:snap-none">
          <%= for col <- @columns do %>
            <% col_cards = Enum.filter(@cards, &(&1.column == col.id)) %>
            <div class={"flex flex-col gap-0 rounded-2xl border border-border/60 overflow-hidden shadow-sm min-w-[280px] sm:min-w-0 snap-center " <> col.col_bg}>
              <%!-- Column header band --%>
              <div class={"h-1 w-full " <> col.band} />
              <div class="flex items-center justify-between px-4 py-3">
                <div class="flex items-center gap-2">
                  <span class={"h-2.5 w-2.5 rounded-full shrink-0 " <> col.dot} />
                  <h2 class={"text-sm font-bold " <> col.color}>{col.label}</h2>
                  <span class="flex h-5 min-w-5 items-center justify-center rounded-full bg-background/80 px-1.5 text-[10px] font-bold text-muted-foreground border border-border/40">
                    {length(col_cards)}
                  </span>
                </div>
                <button
                  phx-click="add-card"
                  phx-value-column={col.id}
                  class="p-2 sm:p-1.5 rounded-lg text-muted-foreground hover:bg-background/80 hover:text-foreground transition-colors min-h-[44px] min-w-[44px] sm:min-h-0 sm:min-w-0 flex items-center justify-center"
                  title="Add card"
                  aria-label="Add card"
                >
                  <.icon name="plus" size={:xs} />
                </button>
              </div>

              <%!-- Cards area --%>
              <div class="flex flex-col gap-2 flex-1 overflow-y-auto px-3 pb-3 min-h-[200px]">
                <%!-- Add card form --%>
                <div :if={@adding_to == col.id} class="rounded-xl border-2 border-primary/30 bg-card p-3 shadow-md">
                  <input
                    type="text"
                    phx-keyup="update-new-card"
                    phx-key="Enter"
                    value={@new_card_title}
                    placeholder="Card title..."
                    autofocus
                    class="w-full text-sm bg-transparent border-none outline-none text-foreground placeholder:text-muted-foreground/60 font-medium"
                  />
                  <div class="flex items-center gap-1.5 mt-2.5 pt-2 border-t border-border/40">
                    <button phx-click="save-card" class="text-xs px-2.5 py-1 rounded-lg bg-primary text-primary-foreground font-semibold hover:bg-primary/90 transition-colors">
                      Add card
                    </button>
                    <button phx-click="cancel-add" class="text-xs px-2.5 py-1 rounded-lg text-muted-foreground hover:bg-accent transition-colors">
                      Cancel
                    </button>
                  </div>
                </div>

                <%= for card <- col_cards do %>
                  <div class="group rounded-xl border border-border/60 bg-card p-3.5 shadow-sm hover:shadow-md hover:border-primary/30 hover:-translate-y-0.5 transition-all duration-200 cursor-pointer">
                    <%!-- Priority indicator strip --%>
                    <div class="flex items-start gap-2.5">
                      <span class={"mt-1 h-2 w-1 rounded-full shrink-0 " <> priority_dot(card.priority)} />
                      <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-foreground leading-snug">{card.title}</p>
                        <div class="flex items-center gap-1.5 mt-2 flex-wrap">
                          <%= for tag <- card.tags do %>
                            <span class="text-[9px] font-semibold text-muted-foreground bg-muted rounded px-1.5 py-0.5">#{tag}</span>
                          <% end %>
                        </div>
                      </div>
                      <button
                        phx-click="delete-card"
                        phx-value-id={card.id}
                        class="p-2 sm:p-1 rounded-lg sm:opacity-0 sm:group-hover:opacity-100 text-muted-foreground/50 hover:text-destructive hover:bg-destructive/10 transition-all shrink-0"
                        aria-label="Delete card"
                      >
                        <.icon name="x" size={:xs} />
                      </button>
                    </div>
                    <div class="flex items-center justify-between mt-3 pt-2.5 border-t border-border/40">
                      <span class="flex h-6 w-6 items-center justify-center rounded-full bg-primary/10 text-[10px] font-bold text-primary ring-2 ring-background">
                        {card.assignee}
                      </span>
                      <%!-- Quick-move arrows --%>
                      <div class="flex items-center gap-1 sm:opacity-0 sm:group-hover:opacity-100 transition-opacity">
                        <%= for dest <- [:backlog, :in_progress, :review, :done], dest != card.column do %>
                          <button
                            phx-click="move-card"
                            phx-value-card_id={card.id}
                            phx-value-column={dest}
                            class="text-[9px] px-1.5 py-0.5 rounded-md border border-border/60 bg-background text-muted-foreground hover:border-primary/50 hover:text-primary hover:bg-primary/5 transition-all font-medium"
                            title={"Move to #{col_label(dest)}"}
                          >
                            {col_abbrev(dest)}
                          </button>
                        <% end %>
                      </div>
                    </div>
                  </div>
                <% end %>

                <%!-- Empty column placeholder --%>
                <div :if={col_cards == [] and @adding_to != col.id} class="flex-1 flex flex-col items-center justify-center py-8 text-center rounded-xl border-2 border-dashed border-border/40">
                  <.icon name="plus" size={:xs} class="text-muted-foreground/30 mb-1" />
                  <p class="text-[10px] text-muted-foreground/50">Drop cards here</p>
                </div>
              </div>
            </div>
          <% end %>
        </div>

      </div>
    </Layout.layout>
    """
  end

  defp col_abbrev(:backlog),     do: "BL"
  defp col_abbrev(:in_progress), do: "IP"
  defp col_abbrev(:review),      do: "RV"
  defp col_abbrev(:done),        do: "DN"

  defp col_label(:backlog),     do: "Backlog"
  defp col_label(:in_progress), do: "In Progress"
  defp col_label(:review),      do: "Review"
  defp col_label(:done),        do: "Done"

  defp priority_dot(:high),   do: "bg-destructive"
  defp priority_dot(:medium), do: "bg-amber-500"
  defp priority_dot(:low),    do: "bg-muted-foreground/40"
end
