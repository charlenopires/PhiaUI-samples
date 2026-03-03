defmodule PhiaDemoWeb.DashboardLive.Users do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @page_size 3

  @impl true
  def mount(_params, _session, socket) do
    users = FakeData.users()
    total_pages = max(1, ceil(length(users) / @page_size))

    {:ok,
     socket
     |> assign(:page_title, "Usuários")
     |> assign(:users, users)
     |> assign(:visible_users, page_slice(users, 1))
     |> assign(:ativos, Enum.count(users, &(&1.status == :ativo)))
     |> assign(:inativos, Enum.count(users, &(&1.status == :inativo)))
     |> assign(:pendentes, Enum.count(users, &(&1.status == :pendente)))
     |> assign(:page, 1)
     |> assign(:total_pages, total_pages)
     |> assign(:confirm_delete_user_id, nil)}
  end

  @impl true
  def handle_event("init_delete", %{"id" => id}, socket) do
    {:noreply, assign(socket, :confirm_delete_user_id, String.to_integer(id))}
  end

  @impl true
  def handle_event("cancel_delete", _params, socket) do
    {:noreply, assign(socket, :confirm_delete_user_id, nil)}
  end

  @impl true
  def handle_event("delete_user", _params, socket) do
    user_id = socket.assigns.confirm_delete_user_id
    users = Enum.reject(socket.assigns.users, &(&1.id == user_id))
    total_pages = max(1, ceil(length(users) / @page_size))
    page = min(socket.assigns.page, total_pages)

    {:noreply,
     socket
     |> assign(:users, users)
     |> assign(:visible_users, page_slice(users, page))
     |> assign(:page, page)
     |> assign(:total_pages, total_pages)
     |> assign(:confirm_delete_user_id, nil)
     |> assign(:ativos, Enum.count(users, &(&1.status == :ativo)))
     |> assign(:inativos, Enum.count(users, &(&1.status == :inativo)))
     |> assign(:pendentes, Enum.count(users, &(&1.status == :pendente)))
     |> push_event("phia-toast", %{
       title: "Usuário removido",
       description: "O usuário foi desativado com sucesso.",
       variant: "destructive",
       duration_ms: 4000
     })}
  end

  @impl true
  def handle_event("page-changed", %{"page" => page}, socket) do
    page = String.to_integer(page)

    {:noreply,
     socket
     |> assign(:page, page)
     |> assign(:visible_users, page_slice(socket.assigns.users, page))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/users">
      <div class="p-6 space-y-6">
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Usuários</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-semibold text-foreground">Usuários</h1>
            <p class="text-sm text-muted-foreground mt-1">{length(@users)} usuários cadastrados</p>
          </div>
          <.dialog id="new-user-dialog">
            <.dialog_trigger for="new-user-dialog">
              <.button variant={:default} size={:sm}>+ Novo Usuário</.button>
            </.dialog_trigger>
            <.dialog_content id="new-user-dialog">
              <.dialog_header>
                <.dialog_title id="new-user-dialog-title">Novo Usuário</.dialog_title>
                <.dialog_description id="new-user-dialog-description">
                  Preencha os dados para criar um novo usuário na plataforma.
                </.dialog_description>
              </.dialog_header>
              <div class="grid gap-4 py-4">
                <div class="grid gap-1.5">
                  <label class="text-sm font-medium text-foreground" for="new-user-name">Nome</label>
                  <input
                    id="new-user-name"
                    type="text"
                    placeholder="Nome completo"
                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                  />
                </div>
                <div class="grid gap-1.5">
                  <label class="text-sm font-medium text-foreground" for="new-user-email">E-mail</label>
                  <input
                    id="new-user-email"
                    type="email"
                    placeholder="email@exemplo.com"
                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                  />
                </div>
                <div class="grid gap-1.5">
                  <label class="text-sm font-medium text-foreground" for="new-user-role">Papel</label>
                  <select
                    id="new-user-role"
                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                  >
                    <option>Admin</option>
                    <option>Editor</option>
                    <option>Viewer</option>
                  </select>
                </div>
              </div>
              <.dialog_footer>
                <.dialog_close
                  for="new-user-dialog"
                  class="border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2 rounded-md text-sm font-medium"
                >
                  Cancelar
                </.dialog_close>
                <.button variant={:default}>Criar Usuário</.button>
              </.dialog_footer>
            </.dialog_content>
          </.dialog>
        </div>

        <.metric_grid cols={3}>
          <.stat_card
            title="Ativos"
            value={to_string(@ativos)}
            trend={:up}
            trend_value="+2 este mês"
            description="usuários ativos"
          />
          <.stat_card
            title="Inativos"
            value={to_string(@inativos)}
            trend={:neutral}
            trend_value="sem mudança"
            description="usuários inativos"
          />
          <.stat_card
            title="Pendentes"
            value={to_string(@pendentes)}
            trend={:neutral}
            trend_value="aguardando"
            description="aprovação pendente"
          />
        </.metric_grid>

        <%= if @pendentes > 0 do %>
          <.alert variant={:warning}>
            <.alert_title>Usuários aguardando aprovação</.alert_title>
            <.alert_description>
              {@pendentes} {if @pendentes == 1, do: "usuário precisa", else: "usuários precisam"} de revisão antes de acessar a plataforma.
            </.alert_description>
          </.alert>
        <% end %>

        <.card>
          <.card_content class="p-0">
            <.table>
              <.table_header>
                <.table_row>
                  <.table_head>Usuário</.table_head>
                  <.table_head>E-mail</.table_head>
                  <.table_head>Papel</.table_head>
                  <.table_head>Status</.table_head>
                  <.table_head>Cadastro</.table_head>
                  <.table_head class="text-right">Ações</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <.table_row :for={u <- @visible_users}>
                  <.table_cell>
                    <div class="flex items-center gap-3">
                      <.avatar size="sm">
                        <.avatar_fallback name={u.nome} />
                      </.avatar>
                      <span class="font-medium text-foreground">{u.nome}</span>
                    </div>
                  </.table_cell>
                  <.table_cell class="text-muted-foreground">{u.email}</.table_cell>
                  <.table_cell>
                    <.badge variant={role_variant(u.role)}>{u.role}</.badge>
                  </.table_cell>
                  <.table_cell>
                    <.badge variant={user_status_variant(u.status)}>
                      {user_status_label(u.status)}
                    </.badge>
                  </.table_cell>
                  <.table_cell class="text-muted-foreground">{u.cadastro}</.table_cell>
                  <.table_cell class="text-right">
                    <.dropdown_menu id={"user-menu-#{u.id}"}>
                      <.dropdown_menu_trigger class="h-8 w-8 p-0 inline-flex items-center justify-center rounded-md hover:bg-accent hover:text-accent-foreground transition-colors">
                        <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                          <circle cx="12" cy="5" r="1.5" />
                          <circle cx="12" cy="12" r="1.5" />
                          <circle cx="12" cy="19" r="1.5" />
                        </svg>
                        <span class="sr-only">Ações para {u.nome}</span>
                      </.dropdown_menu_trigger>
                      <.dropdown_menu_content>
                        <.dropdown_menu_label>Ações</.dropdown_menu_label>
                        <.dropdown_menu_separator />
                        <.dropdown_menu_group>
                          <.dropdown_menu_item>Editar</.dropdown_menu_item>
                          <.dropdown_menu_item>Ver Perfil</.dropdown_menu_item>
                          <.dropdown_menu_item>Desativar</.dropdown_menu_item>
                        </.dropdown_menu_group>
                        <.dropdown_menu_separator />
                        <.dropdown_menu_item
                          class="text-destructive focus:text-destructive"
                          phx-click={JS.push("init_delete", value: %{id: u.id})}
                        >
                          Remover
                        </.dropdown_menu_item>
                      </.dropdown_menu_content>
                    </.dropdown_menu>
                  </.table_cell>
                </.table_row>
              </.table_body>
            </.table>
          </.card_content>
          <.card_footer class="pt-4">
            <.pagination>
              <.pagination_content>
                <.pagination_item>
                  <.pagination_previous
                    current_page={@page}
                    total_pages={@total_pages}
                    on_change="page-changed"
                  />
                </.pagination_item>
                <%= for p <- 1..@total_pages do %>
                  <.pagination_item>
                    <.pagination_link page={p} current_page={@page} on_change="page-changed">
                      {p}
                    </.pagination_link>
                  </.pagination_item>
                <% end %>
                <.pagination_item>
                  <.pagination_next
                    current_page={@page}
                    total_pages={@total_pages}
                    on_change="page-changed"
                  />
                </.pagination_item>
              </.pagination_content>
            </.pagination>
          </.card_footer>
        </.card>
      </div>

      <%!-- Confirm Delete Alert Dialog --%>
      <.alert_dialog
        id="confirm-delete-dialog"
        open={@confirm_delete_user_id != nil}
        aria-labelledby="confirm-delete-title"
        aria-describedby="confirm-delete-desc"
      >
        <.alert_dialog_header>
          <.alert_dialog_title id="confirm-delete-title">Remover usuário</.alert_dialog_title>
          <.alert_dialog_description id="confirm-delete-desc">
            Esta ação não pode ser desfeita. O usuário será removido permanentemente da plataforma.
          </.alert_dialog_description>
        </.alert_dialog_header>
        <.alert_dialog_footer>
          <.alert_dialog_cancel phx-click="cancel_delete">Cancelar</.alert_dialog_cancel>
          <.alert_dialog_action variant="destructive" phx-click="delete_user">
            Remover
          </.alert_dialog_action>
        </.alert_dialog_footer>
      </.alert_dialog>
    </DashboardLayout.layout>
    """
  end

  defp page_slice(users, page) do
    users
    |> Enum.drop(@page_size * (page - 1))
    |> Enum.take(@page_size)
  end

  defp role_variant("Admin"), do: :default
  defp role_variant("Editor"), do: :secondary
  defp role_variant(_), do: :outline

  defp user_status_variant(:ativo), do: :default
  defp user_status_variant(:inativo), do: :outline
  defp user_status_variant(:pendente), do: :secondary

  defp user_status_label(:ativo), do: "Ativo"
  defp user_status_label(:inativo), do: "Inativo"
  defp user_status_label(:pendente), do: "Pendente"
end
