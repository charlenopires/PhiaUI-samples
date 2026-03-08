defmodule PhiaDemoWeb.Demo.Courses.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Courses.Layout

  @courses [
    %{id: 1, title: "Elixir for Beginners", instructor: "José Valim", category: "Elixir", level: "Beginner", duration: "8h 30m", lessons: 24, progress: 100, enrolled: true, rating: 4.9, students: 12847, color: "bg-purple-500/10 text-purple-600"},
    %{id: 2, title: "Phoenix LiveView Masterclass", instructor: "Chris McCord", category: "Phoenix", level: "Intermediate", duration: "12h 15m", lessons: 38, progress: 65, enrolled: true, rating: 4.8, students: 8234, color: "bg-blue-500/10 text-blue-600"},
    %{id: 3, title: "Building Real-time Apps with PubSub", instructor: "Sophie DiBara", category: "Phoenix", level: "Advanced", duration: "6h 45m", lessons: 18, progress: 20, enrolled: true, rating: 4.7, students: 5612, color: "bg-cyan-500/10 text-cyan-600"},
    %{id: 4, title: "Tailwind CSS v4 — Zero to Hero", instructor: "Adam Wathan", category: "CSS", level: "Beginner", duration: "10h 00m", lessons: 32, progress: 0, enrolled: false, rating: 4.9, students: 23456, color: "bg-amber-500/10 text-amber-600"},
    %{id: 5, title: "OTP Patterns in Production", instructor: "Saša Jurić", category: "Elixir", level: "Advanced", duration: "9h 20m", lessons: 28, progress: 0, enrolled: false, rating: 4.8, students: 6789, color: "bg-green-500/10 text-green-600"},
    %{id: 6, title: "Ecto and Database Design", instructor: "Parker Selbert", category: "Elixir", level: "Intermediate", duration: "7h 10m", lessons: 22, progress: 0, enrolled: false, rating: 4.6, students: 4523, color: "bg-rose-500/10 text-rose-600"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Courses")
     |> assign(:courses, @courses)
     |> assign(:filter, :all)
     |> assign(:level_filter, :all)}
  end

  @impl true
  def handle_event("set-filter", %{"filter" => f}, socket) do
    {:noreply, assign(socket, :filter, String.to_existing_atom(f))}
  end

  def handle_event("set-level", %{"level" => l}, socket) do
    {:noreply, assign(socket, :level_filter, String.to_existing_atom(l))}
  end

  def handle_event("enroll", %{"id" => id}, socket) do
    course_id = String.to_integer(id)
    courses = Enum.map(socket.assigns.courses, fn c ->
      if c.id == course_id, do: %{c | enrolled: true}, else: c
    end)
    {:noreply, assign(socket, :courses, courses)}
  end

  @impl true
  def render(assigns) do
    filtered = Enum.filter(assigns.courses, fn c ->
      enrollment_ok = case assigns.filter do
        :all -> true
        :enrolled -> c.enrolled
        :completed -> c.progress == 100
        :not_enrolled -> !c.enrolled
      end
      level_ok = assigns.level_filter == :all or String.to_atom(String.downcase(c.level)) == assigns.level_filter
      enrollment_ok and level_ok
    end)
    enrolled_count = Enum.count(assigns.courses, & &1.enrolled)
    completed_count = Enum.count(assigns.courses, &(&1.progress == 100))
    assigns = assign(assigns, filtered: filtered, enrolled_count: enrolled_count, completed_count: completed_count)

    ~H"""
    <Layout.layout current_path="/courses">
      <div class="p-3 sm:p-4 lg:p-6 space-y-4 sm:space-y-6 max-w-screen-xl mx-auto phia-animate">

        <%!-- Header --%>
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-lg sm:text-xl font-bold text-foreground tracking-tight">Course Catalog</h1>
            <p class="text-sm text-muted-foreground mt-0.5">{@enrolled_count} enrolled · {@completed_count} completed</p>
          </div>
        </div>

        <%!-- Stats --%>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3 sm:gap-4">
          <%= for {label, value, icon, color} <- [{"Enrolled", @enrolled_count, "layers", "text-blue-500"}, {"Completed", @completed_count, "circle-check", "text-green-500"}, {"In Progress", @enrolled_count - @completed_count, "trending-up", "text-amber-500"}] do %>
            <.card class="border-border/60 shadow-sm">
              <.card_content class="p-5">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-xs text-muted-foreground font-medium">{label}</p>
                    <p class="text-2xl font-bold text-foreground mt-0.5">{value}</p>
                  </div>
                  <div class={"flex h-10 w-10 items-center justify-center rounded-lg bg-muted"}>
                    <.icon name={icon} size={:sm} class={color} />
                  </div>
                </div>
              </.card_content>
            </.card>
          <% end %>
        </div>

        <%!-- Filters --%>
        <div class="flex flex-col sm:flex-row flex-wrap gap-3 items-start sm:items-center">
          <div class="flex flex-wrap gap-1">
            <%= for {label, val} <- [{"All", :all}, {"My Courses", :enrolled}, {"Completed", :completed}, {"Not Enrolled", :not_enrolled}] do %>
              <button
                phx-click="set-filter"
                phx-value-filter={val}
                class={[
                  "rounded-md px-3 py-2 sm:py-1.5 text-xs font-medium border transition-all",
                  if(@filter == val,
                    do: "bg-primary text-primary-foreground border-primary",
                    else: "border-border text-muted-foreground hover:border-primary/40"
                  )
                ]}
              >
                {label}
              </button>
            <% end %>
          </div>
          <div class="flex flex-wrap gap-1 sm:ml-auto">
            <%= for {label, val} <- [{"All Levels", :all}, {"Beginner", :beginner}, {"Intermediate", :intermediate}, {"Advanced", :advanced}] do %>
              <button
                phx-click="set-level"
                phx-value-level={val}
                class={[
                  "rounded-md px-3 py-2 sm:py-1.5 text-xs font-medium border transition-all",
                  if(@level_filter == val,
                    do: "bg-primary text-primary-foreground border-primary",
                    else: "border-border text-muted-foreground hover:border-primary/40"
                  )
                ]}
              >
                {label}
              </button>
            <% end %>
          </div>
        </div>

        <%!-- Course grid --%>
        <div class="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          <%= for course <- @filtered do %>
            <.card class="border-border/60 shadow-sm hover:shadow-md transition-shadow flex flex-col">
              <%!-- Color header --%>
              <div class={"rounded-t-xl h-28 flex items-center justify-center " <> course.color}>
                <.icon name="layers" class="opacity-30 w-16 h-16" />
              </div>
              <.card_content class="p-5 flex-1 flex flex-col">
                <div class="flex items-start justify-between gap-2 mb-2">
                  <div>
                    <.badge variant={:outline} class="text-[10px] mb-2">{course.category}</.badge>
                    <h3 class="font-semibold text-foreground leading-snug">{course.title}</h3>
                    <p class="text-xs text-muted-foreground mt-0.5">by {course.instructor}</p>
                  </div>
                </div>

                <div class="flex items-center gap-3 mt-2 text-xs text-muted-foreground">
                  <span class="flex items-center gap-1">
                    <.icon name="star" size={:xs} class="text-amber-500" />
                    {course.rating}
                  </span>
                  <span>{course.duration}</span>
                  <span>{course.lessons} lessons</span>
                </div>

                <div class="flex items-center gap-1.5 mt-2 text-[11px] text-muted-foreground">
                  <.icon name="users" size={:xs} />
                  {format_count(course.students)} students
                </div>

                <%= if course.enrolled and course.progress > 0 do %>
                  <div class="mt-3">
                    <div class="flex items-center justify-between mb-1.5">
                      <span class="text-xs text-muted-foreground">Progress</span>
                      <span class="text-xs font-semibold text-primary">{course.progress}%</span>
                    </div>
                    <.progress value={course.progress} class="h-1.5" />
                  </div>
                <% end %>

                <div class="mt-4 pt-3 border-t border-border/40 flex items-center justify-between">
                  <.badge variant={:outline} class="text-[10px]">{course.level}</.badge>
                  <%= if course.enrolled do %>
                    <.button size={:sm} variant={if course.progress == 100, do: :secondary, else: :default}>
                      {if course.progress == 100, do: "Review", else: "Continue"}
                    </.button>
                  <% else %>
                    <.button size={:sm} variant={:outline} phx-click="enroll" phx-value-id={course.id}>
                      Enroll Free
                    </.button>
                  <% end %>
                </div>
              </.card_content>
            </.card>
          <% end %>
        </div>

        <.empty :if={@filtered == []} class="py-12">
          <:icon><.icon name="layers" /></:icon>
          <:title>No courses found</:title>
          <:description>Try adjusting your filters</:description>
        </.empty>

      </div>
    </Layout.layout>
    """
  end

  defp format_count(n) when n >= 1000, do: "#{div(n, 1000)}.#{div(rem(n, 1000), 100)}k"
  defp format_count(n), do: to_string(n)
end
