defmodule PhiaDemoWeb.Demo.Showcase.TablesLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout
  alias PhiaDemo.FakeData

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Tables Showcase")
     |> assign(:orders, FakeData.recent_orders())
     |> assign(:users, FakeData.users())
     |> assign(:sort_col, nil)
     |> assign(:sort_dir, :asc)
     |> assign(:selected_ids, [])
     |> assign(:expanded_rows, MapSet.new())}
  end

  @impl true
  def handle_event("sort", %{"col" => col}, socket) do
    col_atom = String.to_existing_atom(col)
    {new_col, new_dir} = if socket.assigns.sort_col == col_atom,
      do: {col_atom, if(socket.assigns.sort_dir == :asc, do: :desc, else: :asc)},
      else: {col_atom, :asc}
    {:noreply, assign(socket, sort_col: new_col, sort_dir: new_dir)}
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

  def handle_event("toggle_row", %{"id" => id}, socket) do
    expanded =
      if MapSet.member?(socket.assigns.expanded_rows, id),
        do: MapSet.delete(socket.assigns.expanded_rows, id),
        else: MapSet.put(socket.assigns.expanded_rows, id)

    {:noreply, assign(socket, expanded_rows: expanded)}
  end

  @impl true
  def render(assigns) do
    sorted_users = if assigns.sort_col do
      Enum.sort_by(assigns.users, &Map.get(&1, assigns.sort_col), if(assigns.sort_dir == :asc, do: :asc, else: :desc))
    else
      assigns.users
    end
    assigns = assign(assigns, :sorted_users, sorted_users)

    ~H"""
    <Layout.layout current_path="/showcase/tables">
      <div class="p-6 space-y-10 max-w-screen-xl mx-auto phia-animate">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Tables</h1>
          <p class="text-muted-foreground mt-1">Table, Tree, DataGrid, and BulkActionBar components.</p>
        </div>

        <%!-- Simple Table --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Table (Basic)</h2>
          <.card class="border-border/60 shadow-sm">
            <.table>
              <.table_header>
                <.table_row>
                  <.table_head>Order</.table_head>
                  <.table_head>Customer</.table_head>
                  <.table_head>Product</.table_head>
                  <.table_head>Amount</.table_head>
                  <.table_head>Status</.table_head>
                  <.table_head>Date</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <%= for order <- @orders do %>
                  <.table_row>
                    <.table_cell>{order.id}</.table_cell>
                    <.table_cell>{order.customer}</.table_cell>
                    <.table_cell>{order.product}</.table_cell>
                    <.table_cell>{order.amount}</.table_cell>
                    <.table_cell>
                      <.badge variant={status_variant(order.status)} class="text-[10px] capitalize">
                        {to_string(order.status)}
                      </.badge>
                    </.table_cell>
                    <.table_cell>{order.date}</.table_cell>
                  </.table_row>
                <% end %>
              </.table_body>
            </.table>
          </.card>
        </section>

        <%!-- Sortable Table with Selection --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Table (Sortable + Selection)</h2>
          <div :if={@selected_ids != []} class="flex items-center gap-3 rounded-lg border border-primary/30 bg-primary/5 px-4 py-2.5">
            <span class="text-sm font-semibold text-primary">{length(@selected_ids)} selected</span>
            <.separator orientation="vertical" class="h-4" />
            <.button variant={:outline} size={:sm} phx-click="clear-selection">Clear</.button>
            <.button variant={:destructive} size={:sm}>Delete</.button>
          </div>
          <.card class="border-border/60 shadow-sm">
            <div class="overflow-x-auto">
              <table class="w-full text-sm">
                <thead>
                  <tr class="border-b border-border/60">
                    <th class="w-10 px-4 py-3"></th>
                    <%= for {label, col} <- [{"Name", :name}, {"Email", :email}, {"Role", :role}, {"Status", :status}, {"Joined", :joined}] do %>
                      <th class="px-4 py-3 text-left">
                        <button
                          phx-click="sort"
                          phx-value-col={col}
                          class="flex items-center gap-1.5 text-xs font-semibold text-muted-foreground uppercase tracking-wider hover:text-foreground transition-colors"
                        >
                          {label}
                          <.icon :if={@sort_col == col} name={if @sort_dir == :asc, do: "trending-up", else: "trending-down"} size={:xs} class="text-primary" />
                        </button>
                      </th>
                    <% end %>
                  </tr>
                </thead>
                <tbody class="divide-y divide-border/40">
                  <%= for user <- @sorted_users do %>
                    <tr class={["hover:bg-accent/40 transition-colors", if(to_string(user.id) in @selected_ids, do: "bg-primary/5")]}>
                      <td class="px-4 py-3">
                        <button
                          phx-click="toggle-select"
                          phx-value-id={user.id}
                          class={["h-4 w-4 rounded border-2 flex items-center justify-center transition-all", if(to_string(user.id) in @selected_ids, do: "border-primary bg-primary", else: "border-border hover:border-primary")]}
                        >
                          <.icon :if={to_string(user.id) in @selected_ids} name="check" size={:xs} class="text-primary-foreground" />
                        </button>
                      </td>
                      <td class="px-4 py-3 font-medium text-foreground">{user.name}</td>
                      <td class="px-4 py-3 text-muted-foreground">{user.email}</td>
                      <td class="px-4 py-3 text-muted-foreground">{user.role}</td>
                      <td class="px-4 py-3">
                        <.badge variant={if user.status == :active, do: :default, else: :secondary} class="text-[10px] capitalize">
                          {to_string(user.status)}
                        </.badge>
                      </td>
                      <td class="px-4 py-3 text-muted-foreground">{user.joined}</td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </.card>
        </section>

        <%!-- Tree --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Tree</h2>
          <div class="max-w-sm">
            <.tree id="showcase-tree">
              <.tree_item label="PhiaUI" expandable={true} expanded={true}>
                <.tree_item label="components" expandable={true} expanded={true}>
                  <.tree_item label="buttons" expandable={true} />
                  <.tree_item label="cards" expandable={true} />
                  <.tree_item label="inputs" expandable={true} expanded={true}>
                    <.tree_item label="input.ex" />
                    <.tree_item label="select.ex" />
                    <.tree_item label="checkbox.ex" />
                  </.tree_item>
                  <.tree_item label="feedback" expandable={true} />
                  <.tree_item label="navigation" expandable={true} />
                </.tree_item>
                <.tree_item label="mix.exs" />
                <.tree_item label="README.md" />
              </.tree_item>
            </.tree>
          </div>
        </section>

        <%!-- DataGrid --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">DataGrid</h2>
          <.data_grid>
            <.data_grid_head sort_key="name" sort_dir={if @sort_col == :name, do: @sort_dir, else: :none} on_sort="sort">Name</.data_grid_head>
            <.data_grid_head>Email</.data_grid_head>
            <.data_grid_head>Role</.data_grid_head>
            <.data_grid_head>Status</.data_grid_head>
            <.data_grid_head sort_key="joined" sort_dir={if @sort_col == :joined, do: @sort_dir, else: :none} on_sort="sort">Joined</.data_grid_head>
            <.data_grid_body>
              <%= for user <- @sorted_users do %>
                <.data_grid_row>
                  <.data_grid_cell>{user.name}</.data_grid_cell>
                  <.data_grid_cell>{user.email}</.data_grid_cell>
                  <.data_grid_cell>{user.role}</.data_grid_cell>
                  <.data_grid_cell>
                    <.badge variant={if user.status == :active, do: :default, else: :secondary} class="text-[10px] capitalize">
                      {to_string(user.status)}
                    </.badge>
                  </.data_grid_cell>
                  <.data_grid_cell>{user.joined}</.data_grid_cell>
                </.data_grid_row>
              <% end %>
            </.data_grid_body>
          </.data_grid>
        </section>

        <%!-- FilterBar --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">FilterBar</h2>
          <.filter_bar>
            <.filter_search placeholder="Search users..." on_search="noop" value="" />
            <.filter_select label="Role" name="role" options={[{"All Roles", ""}, {"Admin", "admin"}, {"Editor", "editor"}, {"Viewer", "viewer"}]} value="" on_change="noop" />
            <.filter_select label="Status" name="status" options={[{"All", ""}, {"Active", "active"}, {"Inactive", "inactive"}]} value="" on_change="noop" />
            <.filter_reset on_click="noop" />
          </.filter_bar>
        </section>

        <%!-- Comparison Table --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Comparison Table</h2>
          <.card class="border-border/60 shadow-sm p-4">
            <.comparison_table
              plans={[
                %{name: "Starter", highlighted: false},
                %{name: "Pro", highlighted: true},
                %{name: "Enterprise", highlighted: false}
              ]}
              features={[
                %{label: "Users", values: ["1", "Up to 10", "Unlimited"]},
                %{label: "Storage", values: ["5 GB", "100 GB", "Unlimited"]},
                %{label: "API Access", values: [false, true, true]},
                %{label: "Priority Support", values: [false, false, true]},
                %{label: "Custom Domain", values: [false, true, true]},
                %{label: "SLA", values: [false, false, "99.99%"]}
              ]}
            />
          </.card>
        </section>

        <%!-- Expandable Table --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Expandable Table</h2>
          <.card class="border-border/60 shadow-sm">
            <.table>
              <.table_header>
                <.table_row>
                  <.table_head class="w-10"></.table_head>
                  <.table_head>Order</.table_head>
                  <.table_head>Customer</.table_head>
                  <.table_head>Product</.table_head>
                  <.table_head>Amount</.table_head>
                  <.table_head>Status</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <%= for order <- @orders do %>
                  <.expandable_table_row
                    row_id={to_string(order.id)}
                    expanded={to_string(order.id) in @expanded_rows}
                    on_toggle="toggle_row"
                  >
                    <.table_cell>{order.id}</.table_cell>
                    <.table_cell>{order.customer}</.table_cell>
                    <.table_cell>{order.product}</.table_cell>
                    <.table_cell>{order.amount}</.table_cell>
                    <.table_cell>
                      <.badge variant={status_variant(order.status)} class="text-[10px] capitalize">
                        {to_string(order.status)}
                      </.badge>
                    </.table_cell>
                  </.expandable_table_row>
                  <.expandable_table_detail
                    row_id={to_string(order.id)}
                    expanded={to_string(order.id) in @expanded_rows}
                    col_span={6}
                  >
                    <div class="rounded-md bg-muted/30 p-4 text-sm space-y-1">
                      <p><span class="font-medium text-foreground">Order ID:</span> <span class="text-muted-foreground">{order.id}</span></p>
                      <p><span class="font-medium text-foreground">Customer:</span> <span class="text-muted-foreground">{order.customer}</span></p>
                      <p><span class="font-medium text-foreground">Product:</span> <span class="text-muted-foreground">{order.product}</span></p>
                      <p><span class="font-medium text-foreground">Amount:</span> <span class="text-muted-foreground">{order.amount}</span></p>
                      <p><span class="font-medium text-foreground">Date:</span> <span class="text-muted-foreground">{order.date}</span></p>
                    </div>
                  </.expandable_table_detail>
                <% end %>
              </.table_body>
            </.table>
          </.card>
        </section>

      </div>
    </Layout.layout>
    """
  end

  defp status_variant(:paid), do: :default
  defp status_variant(:pending), do: :secondary
  defp status_variant(:cancelled), do: :destructive
  defp status_variant(_), do: :outline
end
