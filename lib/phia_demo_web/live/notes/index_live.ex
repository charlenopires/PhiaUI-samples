defmodule PhiaDemoWeb.Demo.Notes.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Notes.Layout

  # Note colors — inspired by Google Keep's palette
  @note_colors [
    %{id: "default", label: "Default", bg: "bg-card", border: "border-border/60", text: "text-foreground"},
    %{id: "yellow",  label: "Yellow",  bg: "bg-yellow-50 dark:bg-yellow-950/40",  border: "border-yellow-200 dark:border-yellow-800/60",  text: "text-yellow-900 dark:text-yellow-100"},
    %{id: "blue",    label: "Blue",    bg: "bg-blue-50 dark:bg-blue-950/40",      border: "border-blue-200 dark:border-blue-800/60",      text: "text-blue-900 dark:text-blue-100"},
    %{id: "green",   label: "Green",   bg: "bg-green-50 dark:bg-green-950/40",    border: "border-green-200 dark:border-green-800/60",    text: "text-green-900 dark:text-green-100"},
    %{id: "rose",    label: "Rose",    bg: "bg-rose-50 dark:bg-rose-950/40",      border: "border-rose-200 dark:border-rose-800/60",      text: "text-rose-900 dark:text-rose-100"},
    %{id: "purple",  label: "Purple",  bg: "bg-purple-50 dark:bg-purple-950/40",  border: "border-purple-200 dark:border-purple-800/60",  text: "text-purple-900 dark:text-purple-100"},
    %{id: "orange",  label: "Orange",  bg: "bg-orange-50 dark:bg-orange-950/40",  border: "border-orange-200 dark:border-orange-800/60",  text: "text-orange-900 dark:text-orange-100"},
    %{id: "gray",    label: "Gray",    bg: "bg-gray-100 dark:bg-gray-800/60",     border: "border-gray-300 dark:border-gray-600/60",      text: "text-gray-900 dark:text-gray-100"}
  ]

  @color_swatches %{
    "default" => "bg-white border-2 border-gray-300 dark:bg-gray-700 dark:border-gray-500",
    "yellow"  => "bg-yellow-200",
    "blue"    => "bg-blue-200",
    "green"   => "bg-green-200",
    "rose"    => "bg-rose-200",
    "purple"  => "bg-purple-200",
    "orange"  => "bg-orange-200",
    "gray"    => "bg-gray-300"
  }

  @initial_notes [
    %{id: 1, title: "Getting started with PhiaUI", content: "PhiaUI is a Phoenix LiveView component library built on Tailwind CSS v4. It provides 584+ components covering all common UI patterns.\n\nKey features:\n- Server-rendered with minimal JS\n- Dark mode via CSS custom properties\n- Lucide icon system\n- CSS-first theming", tags: ["work", "docs"], updated_at: "2 min ago", pinned: true, color: "yellow"},
    %{id: 2, title: "Elixir pattern matching", content: "Pattern matching is one of Elixir's most powerful features:\n\n1. Pin operator: Use ^ to match existing variable values\n2. Guard clauses: Add `when` conditions\n3. Multi-clause functions: dispatch to the right clause", tags: ["elixir"], updated_at: "1 hour ago", pinned: true, color: "green"},
    %{id: 3, title: "Book list for 2026", content: "Technical:\n- Programming Elixir 1.6 by Dave Thomas\n- The Little Schemer\n- SICP\n\nNon-technical:\n- Atomic Habits\n- Deep Work by Cal Newport", tags: ["personal"], updated_at: "Yesterday", pinned: false, color: "blue"},
    %{id: 4, title: "Phoenix LiveView lifecycle", content: "Key callbacks:\n\n- mount/3: Initialize state\n- handle_params/3: URL params\n- handle_event/3: User interactions\n- handle_info/2: PubSub messages\n- render/1: HEEx template", tags: ["work", "phoenix"], updated_at: "2 days ago", pinned: false, color: "purple"},
    %{id: 5, title: "Ideas for new components", content: "Potential additions:\n- DataTable with virtual scrolling\n- Timeline with branching\n- Color picker with eyedropper\n- Signature pad\n- Audio waveform visualizer", tags: ["ideas"], updated_at: "3 days ago", pinned: false, color: "rose"},
    %{id: 6, title: "Tailwind v4 changes", content: "Big changes in v4:\n- CSS-first config with @theme\n- source(none) to opt out of auto-detection\n- Container queries built-in\n- OKLCH color palette\n- 3.5x faster builds", tags: ["work", "css"], updated_at: "3 days ago", pinned: false, color: "orange"},
    %{id: 7, title: "Weekend groceries", content: "- Avocados\n- Greek yogurt\n- Oat milk\n- Sourdough bread\n- Cherry tomatoes\n- Olive oil", tags: ["personal"], updated_at: "4 days ago", pinned: false, color: "gray"},
    %{id: 8, title: "Meeting notes — Mar 5", content: "Discussed:\n- Q1 roadmap review\n- New hiring pipeline\n- UI component audit\n- Release schedule for v0.2\n\nAction items: update docs by Friday", tags: ["work"], updated_at: "5 days ago", pinned: false, color: "default"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Notes")
     |> assign(:notes, @initial_notes)
     |> assign(:note_colors, @note_colors)
     |> assign(:color_swatches, @color_swatches)
     |> assign(:search, "")
     |> assign(:selected_note, nil)
     |> assign(:creating, false)
     |> assign(:new_title, "")
     |> assign(:new_content, "")
     |> assign(:new_color, "default")}
  end

  @impl true
  def handle_event("search", %{"value" => q}, socket) do
    {:noreply, assign(socket, :search, q)}
  end

  def handle_event("open-note", %{"id" => id}, socket) do
    note = Enum.find(socket.assigns.notes, &(&1.id == String.to_integer(id)))
    {:noreply, assign(socket, :selected_note, note)}
  end

  def handle_event("close-note", _params, socket) do
    {:noreply, assign(socket, :selected_note, nil)}
  end

  def handle_event("toggle-pin", %{"id" => id}, socket) do
    note_id = String.to_integer(id)
    notes = Enum.map(socket.assigns.notes, fn n ->
      if n.id == note_id, do: %{n | pinned: !n.pinned}, else: n
    end)
    selected = if socket.assigns.selected_note && socket.assigns.selected_note.id == note_id,
      do: Enum.find(notes, &(&1.id == note_id)),
      else: socket.assigns.selected_note
    {:noreply, assign(socket, notes: notes, selected_note: selected)}
  end

  def handle_event("set-color", %{"id" => id, "color" => color}, socket) do
    note_id = String.to_integer(id)
    notes = Enum.map(socket.assigns.notes, fn n ->
      if n.id == note_id, do: %{n | color: color}, else: n
    end)
    selected = if socket.assigns.selected_note && socket.assigns.selected_note.id == note_id,
      do: Enum.find(notes, &(&1.id == note_id)),
      else: socket.assigns.selected_note
    {:noreply, assign(socket, notes: notes, selected_note: selected)}
  end

  def handle_event("delete-note", %{"id" => id}, socket) do
    note_id = String.to_integer(id)
    notes = Enum.reject(socket.assigns.notes, &(&1.id == note_id))
    selected = if socket.assigns.selected_note && socket.assigns.selected_note.id == note_id,
      do: nil,
      else: socket.assigns.selected_note
    {:noreply, assign(socket, notes: notes, selected_note: selected)}
  end

  def handle_event("start-create", _params, socket) do
    {:noreply, assign(socket, creating: true)}
  end

  def handle_event("cancel-create", _params, socket) do
    {:noreply, assign(socket, creating: false, new_title: "", new_content: "", new_color: "default")}
  end

  def handle_event("update-new-title", %{"value" => val}, socket) do
    {:noreply, assign(socket, :new_title, val)}
  end

  def handle_event("update-new-content", %{"value" => val}, socket) do
    {:noreply, assign(socket, :new_content, val)}
  end

  def handle_event("set-new-color", %{"color" => color}, socket) do
    {:noreply, assign(socket, :new_color, color)}
  end

  def handle_event("save-new-note", _params, socket) do
    title = String.trim(socket.assigns.new_title)
    content = String.trim(socket.assigns.new_content)
    if title == "" and content == "" do
      {:noreply, assign(socket, creating: false)}
    else
      new_id = (Enum.map(socket.assigns.notes, & &1.id) |> Enum.max()) + 1
      note = %{
        id: new_id,
        title: if(title == "", do: "Untitled", else: title),
        content: content,
        tags: [],
        updated_at: "Just now",
        pinned: false,
        color: socket.assigns.new_color
      }
      {:noreply,
       socket
       |> update(:notes, &[note | &1])
       |> assign(:creating, false)
       |> assign(:new_title, "")
       |> assign(:new_content, "")
       |> assign(:new_color, "default")}
    end
  end

  @impl true
  def render(assigns) do
    filtered = Enum.filter(assigns.notes, fn n ->
      assigns.search == "" or
        String.contains?(String.downcase(n.title), String.downcase(assigns.search)) or
        String.contains?(String.downcase(n.content), String.downcase(assigns.search))
    end)
    pinned = Enum.filter(filtered, & &1.pinned)
    others = Enum.filter(filtered, &(!&1.pinned))
    assigns = assign(assigns, filtered: filtered, pinned: pinned, others: others)

    ~H"""
    <Layout.layout current_path="/notes">
      <div class="h-full overflow-y-auto bg-background phia-animate">
        <%!-- Top bar --%>
        <div class="sticky top-0 z-20 flex items-center gap-3 px-3 sm:px-4 lg:px-6 py-3 bg-background/95 backdrop-blur border-b border-border/60">
          <div class="relative flex-1 max-w-lg">
            <.icon name="search" size={:xs} class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground/60" />
            <input
              type="text"
              placeholder="Search notes..."
              phx-keyup="search"
              phx-value-value=""
              aria-label="Search notes"
              class="w-full rounded-full border border-border bg-accent/50 pl-9 pr-4 py-2 text-sm text-foreground placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:bg-background transition-all"
            />
          </div>
          <button
            phx-click="start-create"
            class="flex items-center gap-2 rounded-full bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors shrink-0 min-h-[44px] sm:min-h-0"
          >
            <.icon name="plus" size={:xs} />
            New note
          </button>
        </div>

        <div class="px-3 py-4 sm:px-4 sm:py-6 lg:px-6 max-w-6xl mx-auto space-y-8">

          <%!-- Create note card --%>
          <%= if @creating do %>
            <div class={["rounded-2xl border shadow-lg p-4 max-w-lg mx-auto", note_bg(@new_color), note_border(@new_color)]}>
              <input
                type="text"
                placeholder="Title"
                phx-keyup="update-new-title"
                phx-value-value=""
                class="w-full bg-transparent text-sm font-semibold text-foreground placeholder:text-muted-foreground/60 border-none outline-none mb-2"
              />
              <textarea
                placeholder="Take a note..."
                phx-keyup="update-new-content"
                phx-value-value=""
                rows="4"
                class="w-full bg-transparent text-sm text-foreground/80 placeholder:text-muted-foreground/60 border-none outline-none resize-none"
              ></textarea>
              <div class="flex items-center justify-between mt-3 pt-3 border-t border-black/10 dark:border-white/10">
                <%!-- Color swatches --%>
                <div class="flex items-center gap-1.5">
                  <%= for {color_id, swatch_class} <- @color_swatches do %>
                    <button
                      phx-click="set-new-color"
                      phx-value-color={color_id}
                      class={["h-5 w-5 rounded-full transition-transform hover:scale-110 ring-offset-1", swatch_class, if(@new_color == color_id, do: "ring-2 ring-primary scale-110", else: "")]}
                      title={color_id}
                      aria-label={"Set color to " <> color_id}
                    />
                  <% end %>
                </div>
                <div class="flex items-center gap-2">
                  <button phx-click="cancel-create" class="text-xs text-muted-foreground hover:text-foreground px-3 py-1.5 rounded-lg hover:bg-black/5 dark:hover:bg-white/10 transition-colors">
                    Discard
                  </button>
                  <button phx-click="save-new-note" class="text-xs font-semibold text-foreground px-3 py-1.5 rounded-lg hover:bg-black/5 dark:hover:bg-white/10 transition-colors">
                    Save
                  </button>
                </div>
              </div>
            </div>
          <% end %>

          <%!-- Pinned notes --%>
          <%= if @pinned != [] do %>
            <div>
              <p class="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground mb-3 flex items-center gap-1.5">
                <.icon name="pin" size={:xs} />
                Pinned
              </p>
              <div class="columns-1 sm:columns-2 md:columns-3 lg:columns-4 xl:columns-5 gap-3 space-y-3">
                <%= for note <- @pinned do %>
                  <.note_card note={note} color_swatches={@color_swatches} />
                <% end %>
              </div>
            </div>
          <% end %>

          <%!-- Other notes --%>
          <%= if @others != [] do %>
            <div>
              <p :if={@pinned != []} class="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground mb-3">
                Other notes
              </p>
              <div class="columns-1 sm:columns-2 md:columns-3 lg:columns-4 xl:columns-5 gap-3 space-y-3">
                <%= for note <- @others do %>
                  <.note_card note={note} color_swatches={@color_swatches} />
                <% end %>
              </div>
            </div>
          <% end %>

          <%!-- Empty state --%>
          <.empty :if={@filtered == [] and !@creating} class="py-20">
            <:icon><.icon name="pencil" /></:icon>
            <:title>No notes yet</:title>
            <:description>Click "New note" to get started</:description>
          </.empty>

        </div>

        <%!-- Note detail dialog --%>
        <.alert_dialog id="note-detail" open={@selected_note != nil}>
          <%= if @selected_note do %>
            <div class={["rounded-2xl", note_bg(@selected_note.color)]}>
              <.alert_dialog_header>
                <div class="flex items-start justify-between gap-3">
                  <.alert_dialog_title class="text-xl font-bold leading-tight">
                    {@selected_note.title}
                  </.alert_dialog_title>
                  <div class="flex items-center gap-1 shrink-0">
                    <button
                      phx-click="toggle-pin"
                      phx-value-id={@selected_note.id}
                      class={["p-1.5 rounded-lg transition-colors", if(@selected_note.pinned, do: "text-primary bg-primary/10", else: "text-muted-foreground hover:bg-black/5 dark:hover:bg-white/10")]}
                      title={if @selected_note.pinned, do: "Unpin", else: "Pin"}
                      aria-label={if @selected_note.pinned, do: "Unpin note", else: "Pin note"}
                    >
                      <.icon name="pin" size={:xs} />
                    </button>
                    <button
                      phx-click="delete-note"
                      phx-value-id={@selected_note.id}
                      class="p-1.5 rounded-lg text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                      title="Delete note"
                      aria-label="Delete note"
                    >
                      <.icon name="trash-2" size={:xs} />
                    </button>
                  </div>
                </div>
                <p class="text-xs text-muted-foreground mt-1">Updated {@selected_note.updated_at}</p>
              </.alert_dialog_header>

              <div class="px-6 py-4">
                <div class="text-sm text-foreground/80 leading-relaxed whitespace-pre-wrap">{@selected_note.content}</div>

                <%= if @selected_note.tags != [] do %>
                  <div class="flex flex-wrap gap-1.5 mt-4">
                    <%= for tag <- @selected_note.tags do %>
                      <.badge variant={:outline} class="text-[10px]">#{tag}</.badge>
                    <% end %>
                  </div>
                <% end %>

                <%!-- Color picker in detail view --%>
                <div class="flex items-center gap-2 mt-4 pt-4 border-t border-black/10 dark:border-white/10">
                  <span class="text-[10px] font-semibold uppercase tracking-wider text-muted-foreground mr-1">Color</span>
                  <%= for {color_id, swatch_class} <- @color_swatches do %>
                    <button
                      phx-click="set-color"
                      phx-value-id={@selected_note.id}
                      phx-value-color={color_id}
                      class={["h-5 w-5 rounded-full transition-transform hover:scale-110 ring-offset-1", swatch_class, if(@selected_note.color == color_id, do: "ring-2 ring-primary scale-110", else: "")]}
                      title={color_id}
                      aria-label={"Set color to " <> color_id}
                    />
                  <% end %>
                </div>
              </div>

              <.alert_dialog_footer>
                <.alert_dialog_cancel phx-click="close-note">Close</.alert_dialog_cancel>
              </.alert_dialog_footer>
            </div>
          <% end %>
        </.alert_dialog>

      </div>
    </Layout.layout>
    """
  end

  # Note card component — the Google Keep-style card
  defp note_card(assigns) do
    ~H"""
    <div
      class={[
        "group break-inside-avoid rounded-2xl border p-4 cursor-pointer transition-all duration-200 hover:shadow-lg hover:scale-[1.02]",
        note_bg(@note.color),
        note_border(@note.color)
      ]}
      phx-click="open-note"
      phx-value-id={@note.id}
    >
      <%!-- Pin badge --%>
      <div class="flex items-start justify-between mb-2">
        <h3 :if={@note.title != ""} class="font-semibold text-sm text-foreground leading-snug flex-1 min-w-0 pr-2">
          {@note.title}
        </h3>
        <div class="flex items-center gap-0.5 opacity-0 group-hover:opacity-100 transition-opacity shrink-0">
          <button
            phx-click="toggle-pin"
            phx-value-id={@note.id}
            class={["p-1 rounded-lg transition-colors", if(@note.pinned, do: "text-primary", else: "text-muted-foreground hover:text-foreground hover:bg-black/5 dark:hover:bg-white/10")]}
            title={if @note.pinned, do: "Unpin", else: "Pin"}
            aria-label={if @note.pinned, do: "Unpin note", else: "Pin note"}
          >
            <.icon name="pin" size={:xs} />
          </button>
        </div>
      </div>

      <%!-- Content preview --%>
      <p :if={@note.content != ""} class="text-xs text-foreground/70 leading-relaxed line-clamp-6 mb-3">
        {String.slice(@note.content, 0, 200)}
      </p>

      <%!-- Tags + time --%>
      <div class="flex items-center justify-between gap-2 mt-auto">
        <div class="flex flex-wrap gap-1">
          <%= for tag <- Enum.take(@note.tags, 2) do %>
            <span class="text-[9px] font-medium text-muted-foreground bg-black/5 dark:bg-white/10 rounded px-1.5 py-0.5">
              #{tag}
            </span>
          <% end %>
        </div>
        <span class="text-[9px] text-muted-foreground/60 shrink-0">{@note.updated_at}</span>
      </div>
    </div>
    """
  end

  defp note_bg("default"), do: "bg-card"
  defp note_bg("yellow"),  do: "bg-yellow-50 dark:bg-yellow-950/40"
  defp note_bg("blue"),    do: "bg-blue-50 dark:bg-blue-950/40"
  defp note_bg("green"),   do: "bg-green-50 dark:bg-green-950/40"
  defp note_bg("rose"),    do: "bg-rose-50 dark:bg-rose-950/40"
  defp note_bg("purple"),  do: "bg-purple-50 dark:bg-purple-950/40"
  defp note_bg("orange"),  do: "bg-orange-50 dark:bg-orange-950/40"
  defp note_bg("gray"),    do: "bg-gray-100 dark:bg-gray-800/60"
  defp note_bg(_),         do: "bg-card"

  defp note_border("default"), do: "border-border/60"
  defp note_border("yellow"),  do: "border-yellow-200 dark:border-yellow-800/60"
  defp note_border("blue"),    do: "border-blue-200 dark:border-blue-800/60"
  defp note_border("green"),   do: "border-green-200 dark:border-green-800/60"
  defp note_border("rose"),    do: "border-rose-200 dark:border-rose-800/60"
  defp note_border("purple"),  do: "border-purple-200 dark:border-purple-800/60"
  defp note_border("orange"),  do: "border-orange-200 dark:border-orange-800/60"
  defp note_border("gray"),    do: "border-gray-300 dark:border-gray-600/60"
  defp note_border(_),         do: "border-border/60"
end
