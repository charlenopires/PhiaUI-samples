defmodule PhiaDemoWeb.Demo.ApiKeys.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.ApiKeys.Layout

  @keys [
    %{id: 1, name: "Production API", key: "phia_prod_k1x8m2n4p6q9r3s5t7u0v2w4y6z8a1b3", prefix: "phia_prod_", scope: [:read, :write], status: :active, last_used: "2 min ago", created: "Jan 15, 2026"},
    %{id: 2, name: "Development Key", key: "phia_dev_a9b7c5d3e1f8g6h4i2j0k8l6m4n2o0p9", prefix: "phia_dev_", scope: [:read], status: :active, last_used: "1 hour ago", created: "Feb 1, 2026"},
    %{id: 3, name: "CI/CD Pipeline", key: "phia_ci_z2y4x6w8v0u2t4s6r8q0p2o4n6m8l0k2", prefix: "phia_ci_", scope: [:read, :write, :admin], status: :active, last_used: "3 hours ago", created: "Feb 10, 2026"},
    %{id: 4, name: "Mobile SDK", key: "phia_mob_j1i3h5g7f9e1d3c5b7a9z1y3x5w7v9u1", prefix: "phia_mob_", scope: [:read], status: :revoked, last_used: "Never", created: "Feb 15, 2026"},
    %{id: 5, name: "Analytics Service", key: "phia_anl_m8n6o4p2q0r8s6t4u2v0w8x6y4z2a0b8", prefix: "phia_anl_", scope: [:read], status: :active, last_used: "Yesterday", created: "Mar 1, 2026"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "API Keys")
     |> assign(:keys, @keys)
     |> assign(:create_open, false)
     |> assign(:revoke_target, nil)
     |> assign(:new_key_name, "")
     |> assign(:revealed, [])}
  end

  @impl true
  def handle_event("open-create", _params, socket) do
    {:noreply, assign(socket, :create_open, true)}
  end

  def handle_event("close-create", _params, socket) do
    {:noreply, assign(socket, :create_open, false)}
  end

  def handle_event("create-key", _params, socket) do
    name = socket.assigns.new_key_name
    if name != "" do
      new_id = (Enum.map(socket.assigns.keys, & &1.id) |> Enum.max()) + 1
      new_key = %{
        id: new_id,
        name: name,
        key: "phia_new_" <> :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower),
        prefix: "phia_new_",
        scope: [:read],
        status: :active,
        last_used: "Never",
        created: "Mar 7, 2026"
      }
      {:noreply,
       socket
       |> update(:keys, &[new_key | &1])
       |> assign(:create_open, false)
       |> assign(:new_key_name, "")}
    else
      {:noreply, socket}
    end
  end

  def handle_event("update-name", %{"value" => val}, socket) do
    {:noreply, assign(socket, :new_key_name, val)}
  end

  def handle_event("revoke-key", %{"id" => id}, socket) do
    key_id = String.to_integer(id)
    keys = Enum.map(socket.assigns.keys, fn k ->
      if k.id == key_id, do: %{k | status: :revoked}, else: k
    end)
    {:noreply, assign(socket, keys: keys, revoke_target: nil)}
  end

  def handle_event("confirm-revoke", %{"id" => id}, socket) do
    {:noreply, assign(socket, :revoke_target, String.to_integer(id))}
  end

  def handle_event("cancel-revoke", _params, socket) do
    {:noreply, assign(socket, :revoke_target, nil)}
  end

  def handle_event("toggle-reveal", %{"id" => id}, socket) do
    key_id = String.to_integer(id)
    revealed = if key_id in socket.assigns.revealed,
      do: List.delete(socket.assigns.revealed, key_id),
      else: [key_id | socket.assigns.revealed]
    {:noreply, assign(socket, :revealed, revealed)}
  end

  @impl true
  def render(assigns) do
    active_count = Enum.count(assigns.keys, &(&1.status == :active))
    assigns = assign(assigns, :active_count, active_count)

    ~H"""
    <Layout.layout current_path="/api-keys">
      <div class="p-3 sm:p-4 lg:p-6 space-y-6 max-w-screen-xl mx-auto phia-animate">

        <%!-- Header --%>
        <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h1 class="text-xl font-bold text-foreground tracking-tight">API Keys</h1>
            <p class="text-sm text-muted-foreground mt-0.5">{@active_count} active keys</p>
          </div>
          <.button phx-click="open-create" class="self-start sm:self-auto">
            <.icon name="plus" size={:xs} class="mr-1.5" />
            Generate New Key
          </.button>
        </div>

        <%!-- Info banner --%>
        <.alert>
          <.alert_title>Keep your API keys secure</.alert_title>
          <.alert_description>
            Never share your API keys publicly. Keys grant full access to your account resources.
            Rotate keys regularly and revoke any that are no longer needed.
          </.alert_description>
        </.alert>

        <%!-- Keys table --%>
        <.card class="border-border/60 shadow-sm">
          <div class="overflow-x-auto">
            <table class="w-full text-sm">
              <thead>
                <tr class="border-b border-border/60">
                  <th class="px-5 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Name</th>
                  <th class="px-5 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Key</th>
                  <th class="px-5 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Scopes</th>
                  <th class="px-5 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Status</th>
                  <th class="px-5 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Last Used</th>
                  <th class="px-5 py-3 text-left text-xs font-semibold text-muted-foreground uppercase tracking-wider">Created</th>
                  <th class="px-5 py-3"></th>
                </tr>
              </thead>
              <tbody class="divide-y divide-border/40">
                <%= for k <- @keys do %>
                  <tr class={["group transition-colors", if(k.status == :revoked, do: "opacity-60", else: "hover:bg-accent/30")]}>
                    <td class="px-5 py-4 font-semibold text-foreground">{k.name}</td>
                    <td class="px-5 py-4">
                      <div class="flex items-center gap-2">
                        <code class="font-mono text-xs bg-muted px-2 py-1 rounded text-foreground max-w-[120px] sm:max-w-none truncate inline-block">
                          {if k.id in @revealed,
                            do: String.slice(k.key, 0, 32) <> "...",
                            else: k.prefix <> String.duplicate("•", 20)}
                        </code>
                        <button
                          phx-click="toggle-reveal"
                          phx-value-id={k.id}
                          class="p-1 rounded text-muted-foreground hover:text-foreground hover:bg-accent transition-colors"
                          title={if k.id in @revealed, do: "Hide", else: "Reveal"}
                          aria-label={if k.id in @revealed, do: "Hide API key", else: "Reveal API key"}
                        >
                          <.icon name={if k.id in @revealed, do: "eye-off", else: "eye"} size={:xs} />
                        </button>
                        <.copy_button id={"copy-key-#{k.id}"} value={k.key} label="Copy API key" />
                      </div>
                    </td>
                    <td class="px-5 py-4">
                      <div class="flex gap-1 flex-wrap">
                        <%= for scope <- k.scope do %>
                          <.badge variant={:outline} class="text-[10px] capitalize">{to_string(scope)}</.badge>
                        <% end %>
                      </div>
                    </td>
                    <td class="px-5 py-4">
                      <.badge variant={if k.status == :active, do: :default, else: :secondary} class="text-[10px] capitalize">
                        {to_string(k.status)}
                      </.badge>
                    </td>
                    <td class="px-5 py-4 text-xs text-muted-foreground">{k.last_used}</td>
                    <td class="px-5 py-4 text-xs text-muted-foreground">{k.created}</td>
                    <td class="px-5 py-4">
                      <.button
                        :if={k.status == :active}
                        variant={:destructive}
                        size={:sm}
                        phx-click="confirm-revoke"
                        phx-value-id={k.id}
                      >
                        Revoke
                      </.button>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </.card>

        <%!-- Create Key Dialog --%>
        <.alert_dialog id="create-key" open={@create_open}>
          <.alert_dialog_header>
            <.alert_dialog_title>Generate New API Key</.alert_dialog_title>
            <.alert_dialog_description>Create a new API key with specific permissions</.alert_dialog_description>
          </.alert_dialog_header>
          <div class="space-y-4 p-1">
            <div>
              <label class="text-xs font-semibold text-muted-foreground">Key Name</label>
              <input
                type="text"
                placeholder="e.g. Production Server"
                phx-keyup="update-name"
                phx-value-value=""
                class="w-full mt-1 rounded-md border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-1 focus:ring-primary/40"
              />
            </div>
            <div>
              <label class="text-xs font-semibold text-muted-foreground mb-2 block">Scopes</label>
              <div class="flex flex-col gap-2">
                <%= for scope <- ["Read", "Write", "Admin"] do %>
                  <label class="flex items-center gap-2.5 text-sm text-foreground cursor-pointer">
                    <input type="checkbox" class="h-4 w-4 rounded border-border" checked={scope == "Read"} />
                    {scope}
                    <span class="text-xs text-muted-foreground">
                      — {scope_desc(scope)}
                    </span>
                  </label>
                <% end %>
              </div>
            </div>
          </div>
          <.alert_dialog_footer>
            <.alert_dialog_cancel phx-click="close-create">Cancel</.alert_dialog_cancel>
            <.alert_dialog_action phx-click="create-key">Generate Key</.alert_dialog_action>
          </.alert_dialog_footer>
        </.alert_dialog>

        <%!-- Revoke Confirm Dialog --%>
        <.alert_dialog id="revoke-confirm" open={@revoke_target != nil}>
          <.alert_dialog_header>
            <.alert_dialog_title>Revoke API Key?</.alert_dialog_title>
            <.alert_dialog_description>
              This action cannot be undone. Any services using this key will immediately lose access.
            </.alert_dialog_description>
          </.alert_dialog_header>
          <.alert_dialog_footer>
            <.button variant={:outline} phx-click="cancel-revoke">Cancel</.button>
            <.button variant={:destructive} phx-click="revoke-key" phx-value-id={@revoke_target}>
              Yes, Revoke Key
            </.button>
          </.alert_dialog_footer>
        </.alert_dialog>

      </div>
    </Layout.layout>
    """
  end

  defp scope_desc("Read"), do: "view resources"
  defp scope_desc("Write"), do: "create and modify"
  defp scope_desc("Admin"), do: "full access"
  defp scope_desc(_), do: ""
end
