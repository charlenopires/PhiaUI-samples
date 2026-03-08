defmodule PhiaDemoWeb.Demo.Mail.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Mail.Layout

  @emails [
    %{id: 1, from: "Alex Chen", email: "alex@acme.com", subject: "Re: PhiaUI v0.2 roadmap discussion", preview: "Thanks for sharing the timeline. I think the new component library is going to be amazing...", time: "2 min ago", read: false, starred: true, folder: :inbox},
    %{id: 2, from: "Product Team", email: "product@acme.com", subject: "Sprint 3 Planning — action items", preview: "Hi team, here are the action items from today's sprint planning session. Please review...", time: "1 hour ago", read: false, starred: false, folder: :inbox},
    %{id: 3, from: "GitHub", email: "noreply@github.com", subject: "[PhiaUI] New PR: Add Kanban board component", preview: "A new pull request has been opened in PhiaUI/components by @brunolima...", time: "3 hours ago", read: true, starred: false, folder: :inbox},
    %{id: 4, from: "Stripe", email: "billing@stripe.com", subject: "Your invoice is ready — March 2026", preview: "Your monthly invoice for $299.00 is now available. Log in to your dashboard...", time: "Yesterday", read: true, starred: false, folder: :inbox},
    %{id: 5, from: "Carla Souza", email: "carla@acme.com", subject: "Design review feedback", preview: "Hi! I went through the new dashboard designs and have some thoughts...", time: "2 days ago", read: true, starred: true, folder: :inbox},
    %{id: 6, from: "Newsletter", email: "elixir@elixir-lang.org", subject: "This month in Elixir — March 2026", preview: "Elixir v1.19 released, Phoenix 1.8 stable, and more community updates...", time: "3 days ago", read: true, starred: false, folder: :inbox},
    %{id: 7, from: "Diego Melo", email: "diego@acme.com", subject: "Sent: Q1 Report", preview: "Sending over the Q1 metrics report as requested.", time: "1 week ago", read: true, starred: false, folder: :sent}
  ]

  @impl true
  def mount(_params, _session, socket) do
    [first | _] = Enum.filter(@emails, &(&1.folder == :inbox))
    {:ok,
     socket
     |> assign(:page_title, "Mail")
     |> assign(:emails, @emails)
     |> assign(:selected, first)
     |> assign(:folder, :inbox)
     |> assign(:compose_open, false)
     |> assign(:mobile_view, :list)}
  end

  @impl true
  def handle_event("select-email", %{"id" => id}, socket) do
    email_id = String.to_integer(id)
    emails = Enum.map(socket.assigns.emails, fn e ->
      if e.id == email_id, do: %{e | read: true}, else: e
    end)
    selected = Enum.find(emails, &(&1.id == email_id))
    {:noreply, assign(socket, emails: emails, selected: selected, mobile_view: :detail)}
  end

  def handle_event("toggle-star", %{"id" => id}, socket) do
    email_id = String.to_integer(id)
    emails = Enum.map(socket.assigns.emails, fn e ->
      if e.id == email_id, do: %{e | starred: !e.starred}, else: e
    end)
    selected = if socket.assigns.selected && socket.assigns.selected.id == email_id,
      do: Enum.find(emails, &(&1.id == email_id)),
      else: socket.assigns.selected
    {:noreply, assign(socket, emails: emails, selected: selected)}
  end

  def handle_event("compose", _params, socket) do
    {:noreply, assign(socket, :compose_open, true)}
  end

  def handle_event("close-compose", _params, socket) do
    {:noreply, assign(socket, :compose_open, false)}
  end

  def handle_event("back-to-list", _params, socket) do
    {:noreply, assign(socket, :mobile_view, :list)}
  end

  def handle_event("archive", %{"id" => id}, socket) do
    email_id = String.to_integer(id)
    emails = Enum.reject(socket.assigns.emails, &(&1.id == email_id))
    next = List.first(Enum.filter(emails, &(&1.folder == :inbox)))
    {:noreply, assign(socket, emails: emails, selected: next)}
  end

  @impl true
  def render(assigns) do
    inbox = Enum.filter(assigns.emails, &(&1.folder == :inbox))
    unread_count = Enum.count(inbox, &(!&1.read))
    assigns = assign(assigns, inbox: inbox, unread_count: unread_count)

    ~H"""
    <Layout.layout current_path="/mail">
      <div class="flex h-full phia-animate">

        <%!-- Email list --%>
        <div class={[
          "w-full md:w-80 shrink-0 border-r border-border/60 flex flex-col",
          if(@mobile_view == :detail, do: "hidden md:flex", else: "flex")
        ]}>
          <div class="p-3 border-b border-border/60 flex items-center justify-between">
            <div class="flex items-center gap-2">
              <h2 class="text-sm font-semibold text-foreground">Inbox</h2>
              <.badge :if={@unread_count > 0} variant={:default} class="text-[10px]">{@unread_count}</.badge>
            </div>
            <button
              phx-click="compose"
              class="flex items-center gap-1.5 rounded-lg bg-primary px-3 py-1.5 text-xs font-semibold text-primary-foreground hover:bg-primary/90 transition-colors"
            >
              <.icon name="pencil" size={:xs} />
              Compose
            </button>
          </div>

          <div class="flex-1 overflow-y-auto">
            <%= for email <- @inbox do %>
              <button
                phx-click="select-email"
                phx-value-id={email.id}
                class={[
                  "w-full text-left px-4 py-3.5 sm:py-3 border-b border-border/40 last:border-0 transition-colors min-h-[44px]",
                  if(@selected && @selected.id == email.id,
                    do: "bg-primary/5 border-l-2 border-l-primary",
                    else: "hover:bg-accent"
                  ),
                  if(!email.read, do: "bg-background", else: "bg-card/30")
                ]}
              >
                <div class="flex items-start gap-2">
                  <.avatar size="sm" class="shrink-0 mt-0.5">
                    <.avatar_fallback name={email.from} class="bg-primary/10 text-primary text-xs font-semibold" />
                  </.avatar>
                  <div class="flex-1 min-w-0">
                    <div class="flex items-center justify-between gap-1">
                      <p class={"text-sm truncate " <> if(!email.read, do: "font-semibold text-foreground", else: "font-medium text-muted-foreground")}>
                        {email.from}
                      </p>
                      <span class="text-[10px] text-muted-foreground/60 shrink-0">{email.time}</span>
                    </div>
                    <p class={"text-xs truncate mt-0.5 " <> if(!email.read, do: "font-medium text-foreground", else: "text-muted-foreground")}>
                      {email.subject}
                    </p>
                    <p class="text-[11px] text-muted-foreground/60 truncate mt-0.5">{email.preview}</p>
                  </div>
                </div>
              </button>
            <% end %>
          </div>
        </div>

        <%!-- Email detail --%>
        <div class={[
          "flex-1 flex flex-col min-w-0",
          if(@mobile_view == :list, do: "hidden md:flex", else: "flex")
        ]}>
          <%= if @selected do %>
            <%!-- Email toolbar --%>
            <div class="flex items-center justify-between px-3 sm:px-6 py-3 border-b border-border/60 bg-card/30">
              <div class="flex items-center gap-2">
                <button
                  phx-click="back-to-list"
                  class="md:hidden flex items-center gap-1 rounded-md px-2.5 py-1.5 text-xs font-medium text-muted-foreground border border-border hover:bg-accent hover:text-foreground transition-colors min-h-[44px]"
                >
                  <.icon name="arrow-left" size={:xs} />
                  Back
                </button>
                <button
                  phx-click="archive"
                  phx-value-id={@selected.id}
                  class="flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs font-medium text-muted-foreground border border-border hover:bg-accent hover:text-foreground transition-colors"
                >
                  <.icon name="trash-2" size={:xs} />
                  Archive
                </button>
                <button class="flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs font-medium text-muted-foreground border border-border hover:bg-accent hover:text-foreground transition-colors">
                  <.icon name="reply" size={:xs} />
                  Reply
                </button>
              </div>
              <button
                phx-click="toggle-star"
                phx-value-id={@selected.id}
                class={["p-1.5 rounded-md transition-colors", if(@selected.starred, do: "text-amber-500", else: "text-muted-foreground hover:bg-accent")]}
                title={if @selected.starred, do: "Unstar", else: "Star"}
                aria-label={if @selected.starred, do: "Remove star", else: "Add star"}
              >
                <.icon name="star" size={:sm} />
              </button>
            </div>

            <%!-- Email body --%>
            <div class="flex-1 overflow-y-auto p-3 sm:p-4 lg:p-6 max-w-3xl mx-auto w-full">
              <h1 class="text-lg font-bold text-foreground mb-3">{@selected.subject}</h1>
              <div class="flex items-center gap-3 mb-6 pb-4 border-b border-border/60">
                <.avatar size="default">
                  <.avatar_fallback name={@selected.from} class="bg-primary/10 text-primary text-sm font-semibold" />
                </.avatar>
                <div>
                  <p class="text-sm font-semibold text-foreground">{@selected.from}</p>
                  <p class="text-xs text-muted-foreground">{@selected.email} · {@selected.time}</p>
                </div>
              </div>
              <div class="text-sm text-foreground/90 leading-relaxed space-y-3">
                <p>{@selected.preview}</p>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.</p>
                <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.</p>
                <div class="pt-2">
                  <p class="text-foreground/70">Best regards,</p>
                  <p class="font-semibold">{@selected.from}</p>
                </div>
              </div>
            </div>
          <% end %>
        </div>

      </div>

      <%!-- Compose dialog --%>
      <.alert_dialog id="compose-dialog" open={@compose_open}>
        <.alert_dialog_header>
          <.alert_dialog_title>New Message</.alert_dialog_title>
        </.alert_dialog_header>
        <div class="space-y-3 p-1">
          <div>
            <label class="text-xs font-medium text-muted-foreground">To</label>
            <input type="email" placeholder="recipient@example.com" class="w-full mt-1 rounded-md border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-1 focus:ring-primary/40" />
          </div>
          <div>
            <label class="text-xs font-medium text-muted-foreground">Subject</label>
            <input type="text" placeholder="Subject..." class="w-full mt-1 rounded-md border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-1 focus:ring-primary/40" />
          </div>
          <div>
            <label class="text-xs font-medium text-muted-foreground">Message</label>
            <textarea rows={6} placeholder="Write your message..." class="w-full mt-1 rounded-md border border-border bg-background px-3 py-2 text-sm resize-none focus:outline-none focus:ring-1 focus:ring-primary/40"></textarea>
          </div>
        </div>
        <.alert_dialog_footer>
          <.alert_dialog_cancel phx-click="close-compose">Cancel</.alert_dialog_cancel>
          <.alert_dialog_action phx-click="close-compose">
            <.icon name="send" size={:xs} class="mr-1.5" />
            Send
          </.alert_dialog_action>
        </.alert_dialog_footer>
      </.alert_dialog>
    </Layout.layout>
    """
  end
end
