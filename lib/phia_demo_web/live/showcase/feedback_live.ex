defmodule PhiaDemoWeb.Demo.Showcase.FeedbackLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Feedback — Showcase")
     |> assign(:progress_value, 65)
     |> assign(:toast_count, 0)
     |> assign(:snackbar_visible, false)
     |> assign(:snackbar_selected, 0)
     |> assign(:step_current, 2)
     |> assign(:sheet_open, false)
     |> assign(:command_query, "")
     |> assign(:carousel_open, false)}
  end

  @impl true
  def handle_event("fire-toast", %{"variant" => variant}, socket) do
    count = socket.assigns.toast_count + 1
    {:noreply,
     socket
     |> assign(:toast_count, count)
     |> push_event("phia-toast", %{
       title: "Notification ##{count}",
       description: "This is a #{variant} toast message.",
       variant: variant,
       duration_ms: 4000
     })}
  end

  def handle_event("progress-inc", _, socket),
    do: {:noreply, update(socket, :progress_value, &min(100, &1 + 10))}
  def handle_event("progress-dec", _, socket),
    do: {:noreply, update(socket, :progress_value, &max(0, &1 - 10))}

  def handle_event("snackbar-select", %{"n" => n}, socket) do
    n = String.to_integer(n)
    {:noreply, assign(socket, snackbar_visible: n > 0, snackbar_selected: n)}
  end
  def handle_event("snackbar-clear", _, socket),
    do: {:noreply, assign(socket, snackbar_visible: false, snackbar_selected: 0)}

  def handle_event("step-next", _, socket),
    do: {:noreply, update(socket, :step_current, &min(4, &1 + 1))}
  def handle_event("step-prev", _, socket),
    do: {:noreply, update(socket, :step_current, &max(1, &1 - 1))}

  def handle_event("sheet-toggle", _, socket),
    do: {:noreply, update(socket, :sheet_open, &(!&1))}

  def handle_event("command-search", %{"query" => q}, socket),
    do: {:noreply, assign(socket, :command_query, q)}

  def handle_event("fire-sonner", %{"variant" => variant}, socket) do
    {:noreply,
     push_event(socket, "phia-sonner", %{
       title: "Sonner notification",
       description: "This is a #{variant} sonner toast.",
       variant: variant,
       duration_ms: 4000
     })}
  end

  def handle_event(_, _, socket), do: {:noreply, socket}

  @commands [
    %{group: "Pages", icon: "layout-dashboard", label: "Dashboard", shortcut: "D"},
    %{group: "Pages", icon: "puzzle", label: "Showcase", shortcut: "S"},
    %{group: "Pages", icon: "message-circle", label: "Chat", shortcut: "C"},
    %{group: "Actions", icon: "settings", label: "Settings", shortcut: "⌘,"},
    %{group: "Actions", icon: "user", label: "Profile", shortcut: nil},
    %{group: "Actions", icon: "search", label: "Search files", shortcut: "⌘F"},
    %{group: "Actions", icon: "moon", label: "Toggle dark mode", shortcut: nil},
    %{group: "Actions", icon: "log-out", label: "Log out", shortcut: nil}
  ]

  @impl true
  def render(assigns) do
    assigns = assign(assigns, commands: @commands)

    ~H"""
    <Layout.layout current_path="/showcase/feedback">
      <div class="p-3 sm:p-4 lg:p-6 space-y-8 max-w-screen-xl mx-auto phia-animate">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Feedback</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Notification, progress, and overlay components</p>
        </div>

        <%!-- Spinner --%>
        <.demo_section title="Spinner" subtitle="Animated loading indicator in 4 sizes">
          <div class="flex flex-wrap items-center gap-8">
            <div class="flex flex-col items-center gap-2">
              <.spinner size={:xs} label="Loading..." />
              <span class="text-xs text-muted-foreground">xs</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.spinner size={:sm} label="Loading..." />
              <span class="text-xs text-muted-foreground">sm</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.spinner size={:default} label="Loading..." />
              <span class="text-xs text-muted-foreground">md</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.spinner size={:lg} label="Loading..." />
              <span class="text-xs text-muted-foreground">lg</span>
            </div>
            <div class="flex items-center gap-2 text-sm text-muted-foreground">
              <.spinner size={:sm} />
              Loading data...
            </div>
          </div>
        </.demo_section>

        <%!-- Progress --%>
        <.demo_section title="Progress" subtitle="Linear progress bar with live server updates">
          <div class="space-y-4">
            <div class="space-y-2">
              <div class="flex justify-between text-sm">
                <span class="font-medium text-foreground">Upload progress</span>
                <span class="text-muted-foreground">{@progress_value}%</span>
              </div>
              <.progress value={@progress_value} max={100} aria-label="Upload progress" />
            </div>
            <div class="space-y-2">
              <div class="flex justify-between text-sm">
                <span class="font-medium text-foreground">Storage used</span>
                <span class="text-muted-foreground">7.2 / 10 GB</span>
              </div>
              <.progress value={72} max={100} class="[&>div]:bg-amber-500" aria-label="Storage" />
            </div>
            <div class="flex gap-2">
              <.button variant={:outline} size={:sm} phx-click="progress-dec">−10%</.button>
              <.button variant={:outline} size={:sm} phx-click="progress-inc">+10%</.button>
            </div>
          </div>
        </.demo_section>

        <%!-- CircularProgress --%>
        <.demo_section title="CircularProgress" subtitle="SVG ring indicator — value, size and color configurable">
          <div class="flex flex-wrap items-center gap-8">
            <div class="flex flex-col items-center gap-2">
              <.circular_progress value={25} size="sm" color="var(--color-primary)" />
              <span class="text-xs text-muted-foreground">25%</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.circular_progress value={65} size="default" color="var(--color-primary)" />
              <span class="text-xs text-muted-foreground">65%</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.circular_progress value={90} size="lg" color="var(--color-primary)" />
              <span class="text-xs text-muted-foreground">90%</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.circular_progress value={42} size="default" color="oklch(0.65 0.18 55)">
                <:label>
                  <span class="text-xs font-bold text-foreground">42%</span>
                  <span class="text-[9px] text-muted-foreground block">Done</span>
                </:label>
              </.circular_progress>
              <span class="text-xs text-muted-foreground">custom label</span>
            </div>
          </div>
        </.demo_section>

        <%!-- StepTracker --%>
        <.demo_section title="StepTracker" subtitle="Multi-step wizard indicator — server controls active step">
          <div class="space-y-4">
            <.step_tracker>
              <.step step={1} status={if @step_current > 1, do: "complete", else: if(@step_current == 1, do: "active", else: "upcoming")}
                label="Account" description="Create your account" />
              <.step step={2} status={if @step_current > 2, do: "complete", else: if(@step_current == 2, do: "active", else: "upcoming")}
                label="Profile" description="Add your details" />
              <.step step={3} status={if @step_current > 3, do: "complete", else: if(@step_current == 3, do: "active", else: "upcoming")}
                label="Billing" description="Payment information" />
              <.step step={4} status={if @step_current > 4, do: "complete", else: if(@step_current == 4, do: "active", else: "upcoming")}
                label="Review" description="Confirm and submit" />
            </.step_tracker>
            <div class="flex gap-2 pt-2">
              <.button variant={:outline} size={:sm} phx-click="step-prev" disabled={@step_current <= 1}>
                ← Back
              </.button>
              <.button size={:sm} phx-click="step-next" disabled={@step_current >= 4}>
                Next →
              </.button>
            </div>
          </div>
        </.demo_section>

        <%!-- Alert --%>
        <.demo_section title="Alert" subtitle="Inline status messages in 4 variants">
          <div class="space-y-3">
            <.alert variant={:default}>
              <.alert_title>Default Alert</.alert_title>
              <.alert_description>This is a general-purpose informational alert.</.alert_description>
            </.alert>
            <.alert variant={:success}>
              <.alert_title>Success</.alert_title>
              <.alert_description>Your changes were saved successfully.</.alert_description>
            </.alert>
            <.alert variant={:warning}>
              <.alert_title>Warning</.alert_title>
              <.alert_description>Please review your settings before continuing.</.alert_description>
            </.alert>
            <.alert variant={:destructive}>
              <.alert_title>Error</.alert_title>
              <.alert_description>Something went wrong. Please try again.</.alert_description>
            </.alert>
          </div>
        </.demo_section>

        <%!-- Toast --%>
        <.demo_section title="Toast" subtitle="Transient pop-up notifications with auto-dismiss">
          <div class="flex flex-wrap gap-2">
            <%= for {variant, label} <- [{"default", "Default"}, {"success", "Success"}, {"destructive", "Error"}] do %>
              <.button variant={:outline} size={:sm} phx-click="fire-toast" phx-value-variant={variant}>
                <.icon name="bell" size={:xs} class="mr-1.5" />
                {label} Toast
              </.button>
            <% end %>
          </div>
          <p class="text-xs text-muted-foreground mt-2">
            {if @toast_count > 0, do: "#{@toast_count} toast(s) fired.", else: "Click a button to fire a toast."}
          </p>
        </.demo_section>

        <%!-- Snackbar --%>
        <.demo_section title="Snackbar" subtitle="Bulk-action bar triggered by selection state — slides up from bottom">
          <div class="space-y-3">
            <p class="text-xs text-muted-foreground">Simulate selecting rows — the snackbar slides up with action buttons.</p>
            <div class="flex flex-wrap gap-2">
              <%= for n <- [1, 3, 5] do %>
                <.button variant={:outline} size={:sm} phx-click="snackbar-select" phx-value-n={n}>
                  Select {n} item{if n > 1, do: "s"}
                </.button>
              <% end %>
              <.button variant={:ghost} size={:sm} phx-click="snackbar-clear">Clear</.button>
            </div>
          </div>
        </.demo_section>

        <%!-- Sheet --%>
        <.demo_section title="Sheet" subtitle="Side panel overlay — uses PhiaDialog hook, press Escape or click backdrop to close">
          <div class="flex flex-wrap gap-3">
            <button type="button" phx-click="sheet-toggle"
              class="inline-flex items-center gap-2 h-9 px-4 rounded-md border border-input bg-background text-sm font-medium hover:bg-accent transition-colors">
              <.icon name="panel-right" size={:sm} />
              Open Sheet
            </button>
          </div>
        </.demo_section>

        <%!-- Dialog --%>
        <.demo_section title="Dialog" subtitle="Modal overlay with focus trap — Escape or backdrop closes it">
          <.dialog id="showcase-dialog">
            <.dialog_trigger for="showcase-dialog">
              <.button variant={:outline} size={:sm}>Open Dialog</.button>
            </.dialog_trigger>
            <.dialog_content id="showcase-dialog">
              <.dialog_header>
                <.dialog_title id="showcase-dialog-title">Confirm Action</.dialog_title>
                <.dialog_description id="showcase-dialog-desc">
                  This dialog traps focus and closes on Escape or backdrop click. All PhiaUI components compose inside it.
                </.dialog_description>
              </.dialog_header>
              <div class="py-4 space-y-3">
                <.alert variant={:warning}>
                  <.alert_title>Heads up</.alert_title>
                  <.alert_description>This action cannot be reversed.</.alert_description>
                </.alert>
              </div>
              <.dialog_footer>
                <.dialog_close for="showcase-dialog"
                  class="inline-flex items-center justify-center border border-input bg-background hover:bg-accent h-10 px-4 rounded-md text-sm font-medium transition-colors">
                  Cancel
                </.dialog_close>
                <.button variant={:destructive}>Confirm Delete</.button>
              </.dialog_footer>
            </.dialog_content>
          </.dialog>
        </.demo_section>

        <%!-- AlertDialog --%>
        <.demo_section title="AlertDialog" subtitle="Destructive confirmation dialog — no accidental dismiss">
          <.alert_dialog id="showcase-alert-dialog" open={false} aria-labelledby="sad-title" aria-describedby="sad-desc">
            <.alert_dialog_header>
              <.alert_dialog_title id="sad-title">Are you absolutely sure?</.alert_dialog_title>
              <.alert_dialog_description id="sad-desc">
                This action cannot be undone. The item and all its data will be permanently deleted.
              </.alert_dialog_description>
            </.alert_dialog_header>
            <.alert_dialog_footer>
              <.alert_dialog_cancel>Cancel</.alert_dialog_cancel>
              <.alert_dialog_action variant="destructive">Delete</.alert_dialog_action>
            </.alert_dialog_footer>
          </.alert_dialog>
          <p class="text-xs text-muted-foreground">AlertDialog is triggered programmatically — e.g. after a dangerous server action.</p>
        </.demo_section>

        <%!-- Drawer --%>
        <.demo_section title="Drawer" subtitle="Sliding panel from any screen edge — right and bottom variants">
          <div class="flex flex-wrap gap-3">
            <.drawer_trigger drawer_id="showcase-drawer-right">
              <.button variant={:outline} size={:sm}>
                <.icon name="panel-right" size={:sm} class="mr-1.5" /> Right
              </.button>
            </.drawer_trigger>
            <.drawer_trigger drawer_id="showcase-drawer-bottom">
              <.button variant={:outline} size={:sm}>
                <.icon name="panel-bottom" size={:sm} class="mr-1.5" /> Bottom
              </.button>
            </.drawer_trigger>
          </div>
        </.demo_section>

        <%!-- Command --%>
        <.demo_section title="Command" subtitle="Search command palette — type to filter, click to execute">
          <div class="max-w-md">
            <.command id="showcase-cmd" class="rounded-xl border border-border shadow-md">
              <.command_group id="showcase-cmd-group" label="All Commands">
                <.command_input id="showcase-cmd-search" placeholder="Search commands..." on_change="command-search" />
                <.command_list id="showcase-cmd-list">
                  <.command_empty>No results for "{@command_query}"</.command_empty>
                  <%= for {group, items} <- Enum.group_by(Enum.filter(@commands, fn cmd ->
                    @command_query == "" or String.contains?(String.downcase(cmd.label), String.downcase(@command_query))
                  end), & &1.group) do %>
                    <.command_group id={"cmd-group-#{group}"} label={group}>
                      <%= for cmd <- items do %>
                        <.command_item on_click="noop" value={cmd.label} class="flex items-center justify-between">
                          <span class="flex items-center gap-2">
                            <.icon name={cmd.icon} size={:xs} class="text-muted-foreground" />
                            {cmd.label}
                          </span>
                          <%= if cmd.shortcut do %>
                            <.kbd>{cmd.shortcut}</.kbd>
                          <% end %>
                        </.command_item>
                      <% end %>
                    </.command_group>
                  <% end %>
                </.command_list>
              </.command_group>
            </.command>
          </div>
        </.demo_section>

        <%!-- HoverCard --%>
        <.demo_section title="HoverCard" subtitle="Rich floating preview on hover with open/close delays">
          <div class="flex flex-wrap items-center gap-6">
            <.hover_card id="hc-user" open_delay={200} close_delay={150}>
              <.hover_card_trigger hover_card_id="hc-user">
                <a href="#" class="text-sm font-medium text-primary underline-offset-4 hover:underline">
                  @janedoe
                </a>
              </.hover_card_trigger>
              <.hover_card_content hover_card_id="hc-user" class="w-72">
                <div class="flex gap-3">
                  <.avatar size="default" class="ring-2 ring-primary/20 shrink-0">
                    <.avatar_fallback name="Jane Doe" class="bg-primary/10 text-primary font-semibold" />
                  </.avatar>
                  <div class="min-w-0">
                    <p class="font-semibold text-sm text-foreground">Jane Doe</p>
                    <p class="text-xs text-muted-foreground">@janedoe · Product Designer</p>
                    <p class="text-xs text-muted-foreground mt-2 leading-relaxed">
                      Designing delightful experiences at PhiaUI.
                    </p>
                    <div class="flex items-center gap-3 mt-2 text-xs text-muted-foreground">
                      <span><strong class="text-foreground">142</strong> following</span>
                      <span><strong class="text-foreground">2.4k</strong> followers</span>
                    </div>
                  </div>
                </div>
              </.hover_card_content>
            </.hover_card>

            <.hover_card id="hc-repo" open_delay={300} close_delay={200} side="right">
              <.hover_card_trigger hover_card_id="hc-repo">
                <span class="inline-flex items-center gap-1 text-sm text-muted-foreground cursor-help border-b border-dashed border-muted-foreground/40">
                  <.icon name="info" size={:xs} /> PhiaUI
                </span>
              </.hover_card_trigger>
              <.hover_card_content hover_card_id="hc-repo" side="right" class="w-64">
                <p class="font-semibold text-sm">PhiaUI</p>
                <p class="text-xs text-muted-foreground mt-1">Phoenix LiveView UI library — Tailwind v4, Lucide icons, dark mode.</p>
                <div class="flex gap-3 mt-2 text-xs text-muted-foreground">
                  <span>⭐ 1.2k</span><span>Elixir</span><span>MIT</span>
                </div>
              </.hover_card_content>
            </.hover_card>
          </div>
        </.demo_section>

        <%!-- Tooltip --%>
        <.demo_section title="Tooltip" subtitle="Hover or focus label for UI elements in 4 positions">
          <div class="flex flex-wrap items-center gap-4">
            <%= for {id, label, pos} <- [{"tip-top", "Top", :top}, {"tip-bottom", "Bottom", :bottom}, {"tip-left", "Left", :left}, {"tip-right", "Right", :right}] do %>
              <.tooltip id={id} delay_ms={100}>
                <.tooltip_trigger tooltip_id={id}>
                  <.button variant={:outline} size={:sm}>{label}</.button>
                </.tooltip_trigger>
                <.tooltip_content tooltip_id={id} position={pos}>
                  Tooltip on {label |> String.downcase()}
                </.tooltip_content>
              </.tooltip>
            <% end %>
          </div>
        </.demo_section>

        <%!-- Popover --%>
        <.demo_section title="Popover" subtitle="Floating panel anchored to trigger — focus trap, Escape to close">
          <div class="flex flex-wrap gap-3">
            <.popover id="showcase-popover">
              <.popover_trigger popover_id="showcase-popover">
                <.button variant={:outline} size={:sm}>
                  <.icon name="settings" size={:xs} class="mr-1.5" /> Settings
                </.button>
              </.popover_trigger>
              <.popover_content popover_id="showcase-popover" class="w-64">
                <div class="space-y-3">
                  <h4 class="font-semibold text-sm text-foreground">Display settings</h4>
                  <div class="space-y-1.5">
                    <label class="flex items-center gap-2 text-sm cursor-pointer">
                      <input type="checkbox" class="rounded border-input" checked /> Compact mode
                    </label>
                    <label class="flex items-center gap-2 text-sm cursor-pointer">
                      <input type="checkbox" class="rounded border-input" /> Show grid lines
                    </label>
                  </div>
                  <.button variant={:default} size={:sm} class="w-full">Apply</.button>
                </div>
              </.popover_content>
            </.popover>

            <.popover id="showcase-popover-2">
              <.popover_trigger popover_id="showcase-popover-2">
                <.button variant={:outline} size={:sm}>
                  <.icon name="user" size={:xs} class="mr-1.5" /> Profile
                </.button>
              </.popover_trigger>
              <.popover_content popover_id="showcase-popover-2" position={:bottom} class="w-56">
                <div class="flex items-center gap-2.5 mb-3">
                  <.avatar size="sm"><.avatar_fallback name="Admin User" class="bg-primary/10 text-primary text-xs font-semibold" /></.avatar>
                  <div>
                    <p class="text-sm font-semibold text-foreground">Admin User</p>
                    <p class="text-xs text-muted-foreground">admin@phiaui.dev</p>
                  </div>
                </div>
                <hr class="border-border mb-2" />
                <a href="/dashboard/settings" class="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground px-1 py-1 rounded-sm hover:bg-accent transition-colors">
                  <.icon name="settings" size={:xs} /> Settings
                </a>
                <button class="flex items-center gap-2 text-sm text-destructive hover:text-destructive w-full px-1 py-1 rounded-sm hover:bg-destructive/10 transition-colors mt-0.5">
                  <.icon name="log-out" size={:xs} /> Log out
                </button>
              </.popover_content>
            </.popover>
          </div>
        </.demo_section>

        <%!-- DropdownMenu --%>
        <.demo_section title="DropdownMenu" subtitle="Accessible menu with keyboard navigation (↑↓ Arrow, Enter, Escape)">
          <div class="flex flex-wrap gap-3">
            <.dropdown_menu id="showcase-dropdown">
              <.dropdown_menu_trigger class="h-9 px-3 inline-flex items-center gap-2 rounded-md border border-input bg-background hover:bg-accent text-sm font-medium transition-colors">
                <.icon name="settings" size={:sm} /> Options <.icon name="chevron-down" size={:xs} />
              </.dropdown_menu_trigger>
              <.dropdown_menu_content>
                <.dropdown_menu_label>My Account</.dropdown_menu_label>
                <.dropdown_menu_separator />
                <.dropdown_menu_group>
                  <.dropdown_menu_item>
                    <.icon name="user" size={:xs} class="mr-2 text-muted-foreground" /> Profile
                    <.dropdown_menu_shortcut>⌘P</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_item>
                    <.icon name="settings" size={:xs} class="mr-2 text-muted-foreground" /> Settings
                    <.dropdown_menu_shortcut>⌘S</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_item disabled>
                    <.icon name="shield" size={:xs} class="mr-2 text-muted-foreground" /> Admin (disabled)
                  </.dropdown_menu_item>
                </.dropdown_menu_group>
                <.dropdown_menu_separator />
                <.dropdown_menu_item variant="destructive">
                  <.icon name="log-out" size={:xs} class="mr-2" /> Log out
                  <.dropdown_menu_shortcut>⌘Q</.dropdown_menu_shortcut>
                </.dropdown_menu_item>
              </.dropdown_menu_content>
            </.dropdown_menu>

            <.dropdown_menu id="showcase-dropdown-view">
              <.dropdown_menu_trigger class="h-9 px-3 inline-flex items-center gap-2 rounded-md border border-input bg-background hover:bg-accent text-sm font-medium transition-colors">
                <.icon name="eye" size={:sm} /> View <.icon name="chevron-down" size={:xs} />
              </.dropdown_menu_trigger>
              <.dropdown_menu_content>
                <.dropdown_menu_label>Appearance</.dropdown_menu_label>
                <.dropdown_menu_separator />
                <.dropdown_menu_checkbox_item checked={true}>Show toolbar</.dropdown_menu_checkbox_item>
                <.dropdown_menu_checkbox_item checked={false}>Show status bar</.dropdown_menu_checkbox_item>
                <.dropdown_menu_checkbox_item checked={true}>Show sidebar</.dropdown_menu_checkbox_item>
              </.dropdown_menu_content>
            </.dropdown_menu>
          </div>
        </.demo_section>

        <%!-- ContextMenu --%>
        <.demo_section title="ContextMenu" subtitle="Right-click menu — try right-clicking the cards below">
          <div class="grid grid-cols-2 sm:grid-cols-3 gap-3">
            <%= for {name, icon, color} <- [{"document.pdf", "bold", "text-blue-500"}, {"image.png", "image", "text-green-500"}, {"archive.zip", "package", "text-orange-500"}] do %>
              <.context_menu id={"ctx-#{name}"}>
                <.context_menu_trigger context_menu_id={"ctx-#{name}"}>
                  <div class="flex flex-col items-center gap-2 p-4 rounded-lg border border-border hover:bg-muted/60 cursor-default select-none transition-colors">
                    <.icon name={icon} size={:lg} class={color} />
                    <span class="text-xs text-foreground font-medium truncate w-full text-center">{name}</span>
                  </div>
                </.context_menu_trigger>
                <.context_menu_content id={"ctx-#{name}-content"}>
                  <.context_menu_label>{name}</.context_menu_label>
                  <.context_menu_separator />
                  <.context_menu_item><.icon name="eye" size={:xs} class="mr-2 text-muted-foreground" /> Open</.context_menu_item>
                  <.context_menu_item><.icon name="pencil" size={:xs} class="mr-2 text-muted-foreground" /> Rename</.context_menu_item>
                  <.context_menu_separator />
                  <.context_menu_item class="text-destructive focus:text-destructive">
                    <.icon name="trash-2" size={:xs} class="mr-2" /> Delete
                  </.context_menu_item>
                </.context_menu_content>
              </.context_menu>
            <% end %>
          </div>
        </.demo_section>

        <%!-- Carousel --%>
        <.demo_section title="Carousel" subtitle="Touch-swipeable image/card slider with prev/next navigation">
          <.carousel id="showcase-carousel" class="w-full max-w-lg mx-auto">
            <.carousel_content>
              <%= for {title, color, desc} <- [
                {"Phoenix LiveView", "from-violet-500 to-purple-600", "Real-time UIs without writing JS"},
                {"Tailwind CSS v4", "from-sky-500 to-blue-600", "CSS-first configuration and OKLCH colors"},
                {"Lucide Icons", "from-emerald-500 to-green-600", "Beautiful open-source SVG icon library"},
                {"PhiaUI", "from-rose-500 to-pink-600", "Component library built for the Elixir ecosystem"}
              ] do %>
                <.carousel_item>
                  <div class={"h-40 rounded-xl bg-gradient-to-br #{color} flex flex-col items-center justify-center text-white p-6 text-center"}>
                    <p class="font-bold text-lg">{title}</p>
                    <p class="text-sm text-white/80 mt-1">{desc}</p>
                  </div>
                </.carousel_item>
              <% end %>
            </.carousel_content>
          </.carousel>
        </.demo_section>

        <%!-- DarkModeToggle --%>
        <.demo_section title="DarkModeToggle" subtitle="PhiaDarkMode hook — toggles .dark class on html, persists to localStorage">
          <div class="flex flex-wrap items-center gap-4">
            <div class="flex flex-col items-center gap-2">
              <.dark_mode_toggle id="showcase-dm-toggle-1" />
              <p class="text-xs text-muted-foreground">Default size</p>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.dark_mode_toggle id="showcase-dm-toggle-2" class="h-8 w-8" />
              <p class="text-xs text-muted-foreground">Small</p>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.dark_mode_toggle id="showcase-dm-toggle-3" class="h-12 w-12" />
              <p class="text-xs text-muted-foreground">Large</p>
            </div>
          </div>
          <p class="text-xs text-muted-foreground mt-3">Clicking toggles the page theme — the sun/moon icons swap via CSS <code class="font-mono bg-muted px-1 rounded">dark:</code> variant.</p>
        </.demo_section>

        <%!-- Sonner --%>
        <.demo_section title="Sonner" subtitle="Stacked toast notifications with 5 variants — hover to expand, auto-dismiss">
          <div class="flex flex-wrap gap-2">
            <%= for {variant, label} <- [{"default", "Default"}, {"success", "Success"}, {"error", "Error"}, {"warning", "Warning"}, {"info", "Info"}] do %>
              <.button variant={:outline} size={:sm} phx-click="fire-sonner" phx-value-variant={variant}>
                <.icon name="bell" size={:xs} class="mr-1.5" />
                {label}
              </.button>
            <% end %>
          </div>
          <p class="text-xs text-muted-foreground mt-2">Toasts appear bottom-right, stack on multiple fires, and auto-dismiss after 4s. Hover to expand stacked notifications.</p>
        </.demo_section>

        <%!-- Banner --%>
        <.demo_section title="Banner" subtitle="Full-width page-level feedback strip — 5 variants, optionally dismissible">
          <div class="space-y-3">
            <.banner id="demo-banner-info" variant={:info}>
              <:icon><.icon name="info" class="h-4 w-4" /></:icon>
              New version v0.1.13 is available with 50+ new components.
            </.banner>
            <.banner id="demo-banner-success" variant={:success}>
              <:icon><.icon name="circle-check" class="h-4 w-4" /></:icon>
              Deployment completed successfully.
            </.banner>
            <.banner id="demo-banner-warning" variant={:warning}>
              <:icon><.icon name="triangle-alert" class="h-4 w-4" /></:icon>
              Your trial expires in 3 days.
              <:action>
                <.button size={:sm} variant={:outline}>Upgrade now</.button>
              </:action>
            </.banner>
            <.banner id="demo-banner-destructive" variant={:destructive}>
              <:icon><.icon name="circle-x" class="h-4 w-4" /></:icon>
              Service outage detected. Our team is investigating.
            </.banner>
          </div>
        </.demo_section>

        <%!-- StatusIndicator --%>
        <.demo_section title="StatusIndicator" subtitle="Colored presence dots — online, offline, away, busy, and more">
          <div class="flex flex-wrap items-center gap-6">
            <.status_indicator status={:online} label="API Server" />
            <.status_indicator status={:offline} label="Backup Service" />
            <.status_indicator status={:error} label="Queue Worker" />
            <.status_indicator status={:away} label="Worker Node" />
            <.status_indicator status={:busy} label="Build Agent" />
            <.status_indicator status={:online} label="Live" show_pulse={true} />
          </div>
        </.demo_section>

        <%!-- BackTop --%>
        <.demo_section title="BackTop" subtitle="Scroll-to-top button — appears after scrolling 200px">
          <p class="text-xs text-muted-foreground">
            Scroll down the page to reveal the <code class="font-mono bg-muted px-1 rounded">BackTop</code> button in the bottom-right corner.
            It uses the <code class="font-mono bg-muted px-1 rounded">PhiaBackTop</code> JS hook.
          </p>
        </.demo_section>

        <%!-- FloatButton --%>
        <.demo_section title="FloatButton" subtitle="Floating action button — speed-dial at bottom-left">
          <p class="text-xs text-muted-foreground">
            Click the <strong>+</strong> button at the bottom-left of the viewport to expand the speed-dial actions.
            The FAB is positioned away from the BackTop button to avoid overlap.
          </p>
        </.demo_section>

      </div>
    </Layout.layout>

    <%!-- Snackbar outside layout for viewport positioning --%>
    <.snackbar visible={@snackbar_visible}>
      <:icon>
        <span class="flex h-6 w-6 items-center justify-center rounded-full bg-primary/15 text-primary text-xs font-bold">
          {@snackbar_selected}
        </span>
      </:icon>
      <:label>
        {if @snackbar_selected == 1, do: "1 item selected", else: "#{@snackbar_selected} items selected"}
      </:label>
      <:actions>
        <.button size={:sm} variant={:outline} phx-click="snackbar-clear">
          <.icon name="trash-2" size={:xs} class="mr-1.5" /> Delete
        </.button>
        <.button size={:sm} phx-click="snackbar-clear">
          <.icon name="arrow-right" size={:xs} class="mr-1.5" /> Move
        </.button>
      </:actions>
    </.snackbar>

    <%!-- Sheet panel --%>
    <.sheet id="showcase-sheet" open={@sheet_open} side="right" size="md">
      <.sheet_header>
        <.sheet_title id="showcase-sheet-title">Edit Profile</.sheet_title>
        <.sheet_description id="showcase-sheet-desc">
          Update your profile information. Changes are saved when you click Save.
        </.sheet_description>
      </.sheet_header>
      <.sheet_close phx-click="sheet-toggle" />
      <div class="px-6 pb-6 space-y-4">
        <div class="space-y-1.5">
          <label class="text-sm font-medium text-foreground">Name</label>
          <input type="text" value="Admin User" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
        </div>
        <div class="space-y-1.5">
          <label class="text-sm font-medium text-foreground">Email</label>
          <input type="email" value="admin@phiaui.dev" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
        </div>
        <div class="space-y-1.5">
          <label class="text-sm font-medium text-foreground">Bio</label>
          <textarea rows="3" class="flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm resize-none focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring">PhiaUI developer and open-source enthusiast.</textarea>
        </div>
      </div>
      <.sheet_footer>
        <.button variant={:outline} size={:sm} phx-click="sheet-toggle">Cancel</.button>
        <.button size={:sm} phx-click="sheet-toggle">Save changes</.button>
      </.sheet_footer>
    </.sheet>

    <%!-- BackTop fixed --%>
    <.back_top threshold={200} />

    <%!-- Sonner viewport --%>
    <.sonner id="showcase-sonner" position="bottom-right" />

    <%!-- FloatButton speed-dial --%>
    <.float_button id="feedback-fab" position={:bottom_left}>
      <:main icon="plus" aria_label="Actions" />
      <:item icon="pencil" on_click="noop" label="Edit" />
      <:item icon="star" on_click="noop" label="Bookmark" />
      <:item icon="send" on_click="noop" label="Share" />
    </.float_button>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, required: true
  slot :inner_block, required: true

  defp demo_section(assigns) do
    ~H"""
    <div class="space-y-4">
      <div>
        <h2 class="text-base font-semibold text-foreground">{@title}</h2>
        <p class="text-xs text-muted-foreground mt-0.5">{@subtitle}</p>
      </div>
      <div class="rounded-xl border border-border/60 bg-card p-3 sm:p-5 shadow-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
