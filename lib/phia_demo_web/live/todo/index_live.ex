defmodule PhiaDemoWeb.Demo.Todo.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Todo.Layout

  @lists [
    %{id: "Today",    icon: "sun",         color: "text-amber-500",  bg: "bg-amber-500/10",  ring: "ring-amber-500/30"},
    %{id: "Work",     icon: "briefcase",   color: "text-blue-500",   bg: "bg-blue-500/10",   ring: "ring-blue-500/30"},
    %{id: "Personal", icon: "user",        color: "text-purple-500", bg: "bg-purple-500/10", ring: "ring-purple-500/30"},
    %{id: "Shopping", icon: "shopping-cart", color: "text-green-500", bg: "bg-green-500/10", ring: "ring-green-500/30"}
  ]

  @initial_tasks [
    %{id: 1,  title: "Review PR from Ana",               done: false, priority: :high,   list: "Today",    due: "Today"},
    %{id: 2,  title: "Fix dark mode flicker on load",    done: false, priority: :high,   list: "Today",    due: "Today"},
    %{id: 3,  title: "Team standup at 10am",             done: true,  priority: :medium, list: "Today",    due: "Today"},
    %{id: 4,  title: "Write component documentation",    done: false, priority: :high,   list: "Work",     due: "Mar 9"},
    %{id: 5,  title: "Update CHANGELOG.md",              done: true,  priority: :low,    list: "Work",     due: "Mar 8"},
    %{id: 6,  title: "Submit conference talk proposal",  done: false, priority: :high,   list: "Work",     due: "Mar 15"},
    %{id: 7,  title: "Review pull requests",             done: false, priority: :medium, list: "Work",     due: "Mar 10"},
    %{id: 8,  title: "Schedule dentist appointment",     done: false, priority: :high,   list: "Personal", due: "Mar 12"},
    %{id: 9,  title: "Read 20 pages of book",            done: false, priority: :low,    list: "Personal", due: "Daily"},
    %{id: 10, title: "Morning run",                      done: true,  priority: :medium, list: "Personal", due: "Daily"},
    %{id: 11, title: "Order new keyboard",               done: false, priority: :low,    list: "Shopping", due: nil},
    %{id: 12, title: "Get standing desk mat",            done: false, priority: :medium, list: "Shopping", due: nil},
    %{id: 13, title: "Buy coffee beans",                 done: true,  priority: :low,    list: "Shopping", due: nil}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Todo")
     |> assign(:tasks, @initial_tasks)
     |> assign(:lists, @lists)
     |> assign(:adding_to, nil)
     |> assign(:new_task, "")
     |> assign(:show_done, true)}
  end

  @impl true
  def handle_event("toggle-task", %{"id" => id}, socket) do
    task_id = String.to_integer(id)
    tasks = Enum.map(socket.assigns.tasks, fn t ->
      if t.id == task_id, do: %{t | done: !t.done}, else: t
    end)
    {:noreply, assign(socket, :tasks, tasks)}
  end

  def handle_event("start-adding", %{"list" => list}, socket) do
    {:noreply, assign(socket, adding_to: list, new_task: "")}
  end

  def handle_event("cancel-adding", _params, socket) do
    {:noreply, assign(socket, adding_to: nil, new_task: "")}
  end

  def handle_event("update-new-task", %{"value" => val}, socket) do
    {:noreply, assign(socket, :new_task, val)}
  end

  def handle_event("save-task", _params, socket) do
    title = String.trim(socket.assigns.new_task)
    list = socket.assigns.adding_to
    if title == "" or list == nil do
      {:noreply, assign(socket, adding_to: nil, new_task: "")}
    else
      new_id = (Enum.map(socket.assigns.tasks, & &1.id) |> Enum.max()) + 1
      task = %{id: new_id, title: title, done: false, priority: :medium, list: list, due: nil}
      {:noreply,
       socket
       |> update(:tasks, &(&1 ++ [task]))
       |> assign(:adding_to, nil)
       |> assign(:new_task, "")}
    end
  end

  def handle_event("delete-task", %{"id" => id}, socket) do
    task_id = String.to_integer(id)
    {:noreply, update(socket, :tasks, &Enum.reject(&1, fn t -> t.id == task_id end))}
  end

  def handle_event("toggle-done-visibility", _params, socket) do
    {:noreply, assign(socket, :show_done, !socket.assigns.show_done)}
  end

  @impl true
  def render(assigns) do
    total = length(assigns.tasks)
    done = Enum.count(assigns.tasks, & &1.done)
    overall_pct = if total > 0, do: round(done / total * 100), else: 0
    assigns = assign(assigns, total: total, done: done, overall_pct: overall_pct)

    ~H"""
    <Layout.layout current_path="/todo">
      <div class="h-full overflow-y-auto bg-background phia-animate">

        <%!-- Header --%>
        <div class="px-3 sm:px-6 pt-4 sm:pt-6 pb-4 max-w-3xl mx-auto">
          <div class="flex items-start justify-between mb-5">
            <div>
              <h1 class="text-lg sm:text-xl lg:text-2xl font-bold text-foreground tracking-tight">My Tasks</h1>
              <p class="text-sm text-muted-foreground mt-0.5">{@done} of {@total} completed</p>
            </div>
            <button
              phx-click="toggle-done-visibility"
              class="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground px-3 py-1.5 rounded-lg border border-border/60 hover:border-border bg-card transition-colors"
            >
              <.icon name={if @show_done, do: "eye-off", else: "eye"} size={:xs} />
              {if @show_done, do: "Hide done", else: "Show done"}
            </button>
          </div>

          <%!-- Overall progress bar --%>
          <div class="rounded-2xl border border-border/60 bg-card p-3 sm:p-5 shadow-sm">
            <div class="flex items-center justify-between mb-3">
              <div class="flex items-center gap-2">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10">
                  <.icon name="circle-check" size={:xs} class="text-primary" />
                </div>
                <span class="text-sm font-semibold text-foreground">Overall Progress</span>
              </div>
              <span class="text-2xl font-bold text-primary tabular-nums">{@overall_pct}%</span>
            </div>
            <.progress value={@overall_pct} class="h-2.5 rounded-full" />
            <div class="flex gap-3 sm:gap-6 mt-4">
              <%= for list <- @lists do %>
                <% list_tasks = Enum.filter(@tasks, &(&1.list == list.id))
                   list_done = Enum.count(list_tasks, & &1.done)
                   list_pct = if length(list_tasks) > 0, do: round(list_done / length(list_tasks) * 100), else: 0 %>
                <div class="flex flex-col items-center gap-1 flex-1">
                  <div class={"flex h-6 w-6 items-center justify-center rounded-lg " <> list.bg}>
                    <.icon name={list.icon} size={:xs} class={list.color} />
                  </div>
                  <span class="text-xs font-bold text-foreground">{list_pct}%</span>
                  <span class="text-[9px] text-muted-foreground">{list.id}</span>
                </div>
              <% end %>
            </div>
          </div>
        </div>

        <%!-- Task lists --%>
        <div class="px-3 sm:px-6 pb-8 max-w-3xl mx-auto grid sm:grid-cols-2 gap-4">
          <%= for list <- @lists do %>
            <% list_tasks = Enum.filter(@tasks, &(&1.list == list.id))
               visible_tasks = if @show_done, do: list_tasks, else: Enum.filter(list_tasks, &(!&1.done))
               done_count = Enum.count(list_tasks, & &1.done)
               list_pct = if length(list_tasks) > 0, do: round(done_count / length(list_tasks) * 100), else: 0 %>
            <div class="rounded-2xl border border-border/60 bg-card shadow-sm overflow-hidden">
              <%!-- List header --%>
              <div class="flex items-center justify-between px-4 pt-4 pb-3">
                <div class="flex items-center gap-2.5">
                  <div class={"flex h-8 w-8 items-center justify-center rounded-xl " <> list.bg}>
                    <.icon name={list.icon} size={:xs} class={list.color} />
                  </div>
                  <div>
                    <p class="text-sm font-bold text-foreground leading-none">{list.id}</p>
                    <p class="text-[10px] text-muted-foreground mt-0.5">{done_count}/{length(list_tasks)} done</p>
                  </div>
                </div>
                <span class={["text-xs font-bold tabular-nums", list.color]}>{list_pct}%</span>
              </div>
              <%!-- Mini progress --%>
              <div class="px-4 pb-3">
                <.progress value={list_pct} class="h-1 rounded-full" />
              </div>

              <%!-- Tasks --%>
              <div class="px-3 pb-3 space-y-0.5">
                <%= for task <- visible_tasks do %>
                  <div class={[
                    "group flex items-center gap-3 rounded-xl px-2 py-2.5 transition-colors",
                    if(task.done, do: "opacity-50", else: "hover:bg-accent/60")
                  ]}>
                    <button
                      phx-click="toggle-task"
                      phx-value-id={task.id}
                      class={[
                        "h-5 w-5 shrink-0 rounded-full border-2 flex items-center justify-center transition-all",
                        if(task.done,
                          do: "border-primary bg-primary",
                          else: "border-border hover:border-primary group-hover:border-primary/60"
                        )
                      ]}
                      aria-label={if task.done, do: "Mark as incomplete", else: "Mark as complete"}
                    >
                      <.icon :if={task.done} name="check" size={:xs} class="text-primary-foreground" />
                    </button>
                    <div class="flex-1 min-w-0">
                      <p class={"text-sm truncate " <> if(task.done, do: "line-through text-muted-foreground", else: "text-foreground font-medium")}>
                        {task.title}
                      </p>
                      <div class="flex items-center gap-1.5 mt-0.5">
                        <span :if={task.priority == :high} class="h-1.5 w-1.5 rounded-full bg-destructive shrink-0" />
                        <span :if={task.due} class="text-[9px] text-muted-foreground">{task.due}</span>
                      </div>
                    </div>
                    <button
                      phx-click="delete-task"
                      phx-value-id={task.id}
                      class="p-1 rounded-lg opacity-0 group-hover:opacity-100 text-muted-foreground/50 hover:text-destructive hover:bg-destructive/10 transition-all"
                      aria-label="Delete task"
                    >
                      <.icon name="x" size={:xs} />
                    </button>
                  </div>
                <% end %>

                <%!-- Add task inline --%>
                <%= if @adding_to == list.id do %>
                  <div class="flex items-center gap-3 rounded-xl border border-primary/30 bg-primary/5 px-2 py-2.5">
                    <div class="h-5 w-5 shrink-0 rounded-full border-2 border-primary/40" />
                    <input
                      type="text"
                      phx-keyup="update-new-task"
                      phx-value-value=""
                      phx-key="Enter"
                      value={@new_task}
                      placeholder="New task..."
                      autofocus
                      class="flex-1 text-sm bg-transparent border-none outline-none text-foreground placeholder:text-muted-foreground/50"
                    />
                    <div class="flex gap-1">
                      <button phx-click="save-task" class="p-1 rounded text-primary hover:bg-primary/10 transition-colors" title="Save">
                        <.icon name="check" size={:xs} />
                      </button>
                      <button phx-click="cancel-adding" class="p-1 rounded text-muted-foreground hover:bg-accent transition-colors" title="Cancel">
                        <.icon name="x" size={:xs} />
                      </button>
                    </div>
                  </div>
                <% else %>
                  <button
                    phx-click="start-adding"
                    phx-value-list={list.id}
                    class="flex w-full items-center gap-3 rounded-xl px-2 py-2 text-xs text-muted-foreground/60 hover:text-muted-foreground hover:bg-accent/50 transition-all"
                  >
                    <.icon name="plus" size={:xs} />
                    Add task
                  </button>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>

      </div>
    </Layout.layout>
    """
  end
end
