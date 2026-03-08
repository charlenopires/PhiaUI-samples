defmodule PhiaDemoWeb.Demo.FileManager.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.FileManager.Layout

  @files [
    %{id: 1, name: "Q1-Report-2026.pdf", type: :pdf, size: "2.4 MB", modified: "Mar 1, 2026", folder: "Documents"},
    %{id: 2, name: "PhiaUI-Brand-Kit.zip", type: :archive, size: "18.7 MB", modified: "Feb 28, 2026", folder: "Documents"},
    %{id: 3, name: "hero-banner.png", type: :image, size: "1.1 MB", modified: "Feb 27, 2026", folder: "Images"},
    %{id: 4, name: "dashboard-preview.png", type: :image, size: "845 KB", modified: "Feb 27, 2026", folder: "Images"},
    %{id: 5, name: "dark-mode-mockup.png", type: :image, size: "622 KB", modified: "Feb 26, 2026", folder: "Images"},
    %{id: 6, name: "app.css", type: :code, size: "12 KB", modified: "Feb 25, 2026", folder: "Projects"},
    %{id: 7, name: "phia_demo_web.ex", type: :code, size: "8 KB", modified: "Feb 25, 2026", folder: "Projects"},
    %{id: 8, name: "Meeting-Notes-Mar.docx", type: :document, size: "54 KB", modified: "Feb 24, 2026", folder: "Documents"},
    %{id: 9, name: "logo-icon.svg", type: :image, size: "4 KB", modified: "Feb 23, 2026", folder: "Images"},
    %{id: 10, name: "router.ex", type: :code, size: "3 KB", modified: "Feb 22, 2026", folder: "Projects"},
    %{id: 11, name: "Budget-2026.xlsx", type: :spreadsheet, size: "156 KB", modified: "Feb 20, 2026", folder: "Documents"},
    %{id: 12, name: "Presentation.pptx", type: :presentation, size: "4.2 MB", modified: "Feb 19, 2026", folder: "Documents"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Files")
     |> assign(:files, @files)
     |> assign(:view, :grid)
     |> assign(:folder, nil)
     |> assign(:selected, nil)
     |> assign(:upload_open, false)}
  end

  @impl true
  def handle_event("set-view", %{"view" => view}, socket) do
    {:noreply, assign(socket, :view, String.to_existing_atom(view))}
  end

  def handle_event("set-folder", %{"folder" => folder}, socket) do
    f = if folder == "", do: nil, else: folder
    {:noreply, assign(socket, folder: f, selected: nil)}
  end

  def handle_event("select-file", %{"id" => id}, socket) do
    file_id = String.to_integer(id)
    file = Enum.find(socket.assigns.files, &(&1.id == file_id))
    {:noreply, assign(socket, :selected, file)}
  end

  def handle_event("open-upload", _params, socket) do
    {:noreply, assign(socket, :upload_open, true)}
  end

  def handle_event("close-upload", _params, socket) do
    {:noreply, assign(socket, :upload_open, false)}
  end

  def handle_event("delete-file", %{"id" => id}, socket) do
    file_id = String.to_integer(id)
    files = Enum.reject(socket.assigns.files, &(&1.id == file_id))
    {:noreply, assign(socket, files: files, selected: nil)}
  end

  @impl true
  def render(assigns) do
    filtered = if assigns.folder,
      do: Enum.filter(assigns.files, &(&1.folder == assigns.folder)),
      else: assigns.files
    folders = assigns.files |> Enum.map(& &1.folder) |> Enum.uniq() |> Enum.sort()
    assigns = assign(assigns, filtered: filtered, folders: folders)

    ~H"""
    <Layout.layout current_path="/files">
      <div class="flex h-full phia-animate">

        <%!-- Folder tree panel --%>
        <div class="hidden md:block w-56 shrink-0 border-r border-border/60 bg-card/50 p-3 space-y-1">
          <button
            phx-click="set-folder"
            phx-value-folder=""
            class={[
              "flex items-center gap-2 w-full rounded-md px-3 py-2 text-sm transition-colors",
              if(is_nil(@folder), do: "bg-primary/10 text-primary font-semibold", else: "text-muted-foreground hover:bg-accent hover:text-foreground")
            ]}
          >
            <.icon name="home" size={:xs} />
            All Files
          </button>
          <p class="px-3 pt-2 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50">Folders</p>
          <%= for folder <- @folders do %>
            <button
              phx-click="set-folder"
              phx-value-folder={folder}
              class={[
                "flex items-center gap-2 w-full rounded-md px-3 py-2 text-sm transition-colors",
                if(@folder == folder, do: "bg-primary/10 text-primary font-semibold", else: "text-muted-foreground hover:bg-accent hover:text-foreground")
              ]}
            >
              <.icon name="folder" size={:xs} />
              {folder}
              <span class="ml-auto text-[10px] text-muted-foreground/60">
                {Enum.count(@files, &(&1.folder == folder))}
              </span>
            </button>
          <% end %>
        </div>

        <%!-- Main content --%>
        <div class="flex-1 flex flex-col min-w-0">
          <%!-- Toolbar --%>
          <div class="flex items-center justify-between px-3 sm:px-5 py-3 border-b border-border/60 bg-card/30">
            <div class="flex items-center gap-2 min-w-0">
              <%!-- Mobile folder select --%>
              <select
                phx-change="set-folder"
                name="folder"
                class="md:hidden rounded-md border border-border bg-background px-2 py-1.5 text-sm min-h-[44px]"
              >
                <option value="" selected={is_nil(@folder)}>All Files</option>
                <%= for folder <- @folders do %>
                  <option value={folder} selected={@folder == folder}>{folder}</option>
                <% end %>
              </select>
              <.breadcrumb class="hidden md:flex">
                <.breadcrumb_list>
                  <.breadcrumb_item>
                    <.breadcrumb_link href="/files">Files</.breadcrumb_link>
                  </.breadcrumb_item>
                  <span :if={@folder} class="flex items-center gap-1.5">
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_page>{@folder}</.breadcrumb_page>
                    </.breadcrumb_item>
                  </span>
                </.breadcrumb_list>
              </.breadcrumb>
              <.badge variant={:outline} class="text-[10px]">{length(@filtered)} items</.badge>
            </div>
            <div class="flex items-center gap-2">
              <.button variant={:outline} size={:sm} phx-click="open-upload">
                <.icon name="upload" size={:xs} class="mr-1.5" />
                Upload
              </.button>
              <div class="flex rounded-md border border-border overflow-hidden">
                <button
                  phx-click="set-view"
                  phx-value-view="grid"
                  class={["px-2.5 py-1.5 text-sm transition-colors", if(@view == :grid, do: "bg-primary text-primary-foreground", else: "text-muted-foreground hover:bg-accent")]}
                  title="Grid view"
                  aria-label="Grid view"
                  aria-pressed={to_string(@view == :grid)}
                >
                  <.icon name="layout-grid" size={:xs} />
                </button>
                <button
                  phx-click="set-view"
                  phx-value-view="list"
                  class={["px-2.5 py-1.5 text-sm transition-colors border-l border-border", if(@view == :list, do: "bg-primary text-primary-foreground", else: "text-muted-foreground hover:bg-accent")]}
                  title="List view"
                  aria-label="List view"
                  aria-pressed={to_string(@view == :list)}
                >
                  <.icon name="list" size={:xs} />
                </button>
              </div>
            </div>
          </div>

          <div class="flex-1 overflow-auto p-3 sm:p-5">
            <%= if @view == :grid do %>
              <%!-- Grid view --%>
              <div class="grid grid-cols-1 gap-3 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
                <%= for file <- @filtered do %>
                  <button
                    phx-click="select-file"
                    phx-value-id={file.id}
                    class={[
                      "group flex flex-col items-center gap-2 rounded-xl border p-4 text-center transition-all hover:shadow-sm",
                      if(@selected && @selected.id == file.id,
                        do: "border-primary bg-primary/5 shadow-sm",
                        else: "border-border/60 bg-card hover:border-primary/30"
                      )
                    ]}
                  >
                    <div class={"flex h-12 w-12 items-center justify-center rounded-xl " <> file_bg(file.type)}>
                      <.icon name={file_icon(file.type)} size={:sm} class={file_icon_color(file.type)} />
                    </div>
                    <p class="text-xs font-medium text-foreground truncate w-full">{file.name}</p>
                    <p class="text-[10px] text-muted-foreground/60">{file.size}</p>
                  </button>
                <% end %>
              </div>
            <% else %>
              <%!-- List view --%>
              <div class="overflow-x-auto">
              <div class="space-y-1 min-w-[600px]">
                <%= for file <- @filtered do %>
                  <button
                    phx-click="select-file"
                    phx-value-id={file.id}
                    class={[
                      "group flex items-center gap-3 w-full rounded-lg px-3 py-2.5 transition-colors text-left",
                      if(@selected && @selected.id == file.id,
                        do: "bg-primary/5 border border-primary/20",
                        else: "hover:bg-accent border border-transparent"
                      )
                    ]}
                  >
                    <div class={"flex h-8 w-8 items-center justify-center rounded-lg shrink-0 " <> file_bg(file.type)}>
                      <.icon name={file_icon(file.type)} size={:xs} class={file_icon_color(file.type)} />
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-medium text-foreground truncate">{file.name}</p>
                      <p class="text-xs text-muted-foreground">{file.folder}</p>
                    </div>
                    <span class="text-xs text-muted-foreground shrink-0">{file.size}</span>
                    <span class="text-xs text-muted-foreground shrink-0">{file.modified}</span>
                    <button
                      phx-click="delete-file"
                      phx-value-id={file.id}
                      class="p-1.5 rounded opacity-0 group-hover:opacity-100 text-muted-foreground/60 hover:text-destructive hover:bg-destructive/10 transition-all shrink-0"
                      title="Delete"
                      aria-label="Delete file"
                    >
                      <.icon name="trash-2" size={:xs} />
                    </button>
                  </button>
                <% end %>
              </div>
              </div>
            <% end %>
          </div>
        </div>

        <%!-- File detail panel --%>
        <div :if={@selected} class="hidden lg:block w-64 shrink-0 border-l border-border/60 bg-card/50 p-4 space-y-4">
          <div class="flex items-center justify-between">
            <p class="text-sm font-semibold text-foreground">Details</p>
            <button phx-click="select-file" phx-value-id="-1" class="p-1 rounded text-muted-foreground hover:bg-accent transition-colors" aria-label="Close details panel">
              <.icon name="x" size={:xs} />
            </button>
          </div>
          <div class={"flex h-16 w-16 mx-auto items-center justify-center rounded-2xl " <> file_bg(@selected.type)}>
            <.icon name={file_icon(@selected.type)} class={file_icon_color(@selected.type)} />
          </div>
          <div class="space-y-3">
            <div>
              <p class="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">Name</p>
              <p class="text-sm font-medium text-foreground mt-0.5 break-all">{@selected.name}</p>
            </div>
            <div>
              <p class="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">Size</p>
              <p class="text-sm text-foreground mt-0.5">{@selected.size}</p>
            </div>
            <div>
              <p class="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">Folder</p>
              <p class="text-sm text-foreground mt-0.5">{@selected.folder}</p>
            </div>
            <div>
              <p class="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">Modified</p>
              <p class="text-sm text-foreground mt-0.5">{@selected.modified}</p>
            </div>
          </div>
          <div class="flex flex-col gap-2 pt-2">
            <.button class="w-full" size={:sm}>
              <.icon name="cloud-upload" size={:xs} class="mr-1.5" />
              Download
            </.button>
            <.button variant={:destructive} class="w-full" size={:sm} phx-click="delete-file" phx-value-id={@selected.id}>
              <.icon name="trash-2" size={:xs} class="mr-1.5" />
              Delete
            </.button>
          </div>
        </div>

      </div>

      <%!-- Upload dialog --%>
      <.alert_dialog id="upload-files" open={@upload_open}>
        <.alert_dialog_header>
          <.alert_dialog_title>Upload Files</.alert_dialog_title>
          <.alert_dialog_description>Drag and drop files or click to browse</.alert_dialog_description>
        </.alert_dialog_header>
        <div class="rounded-xl border-2 border-dashed border-border p-12 text-center hover:border-primary/40 hover:bg-primary/5 transition-colors cursor-pointer">
          <div class="flex h-12 w-12 mx-auto items-center justify-center rounded-xl bg-primary/10 mb-3">
            <.icon name="cloud-upload" size={:sm} class="text-primary" />
          </div>
          <p class="text-sm font-medium text-foreground">Drop files here</p>
          <p class="text-xs text-muted-foreground mt-1">or click to browse</p>
        </div>
        <.alert_dialog_footer>
          <.alert_dialog_cancel phx-click="close-upload">Cancel</.alert_dialog_cancel>
          <.alert_dialog_action phx-click="close-upload">Upload</.alert_dialog_action>
        </.alert_dialog_footer>
      </.alert_dialog>
    </Layout.layout>
    """
  end

  defp file_icon(:pdf), do: "list-ordered"
  defp file_icon(:image), do: "image"
  defp file_icon(:code), do: "code"
  defp file_icon(:archive), do: "package"
  defp file_icon(:document), do: "list"
  defp file_icon(:spreadsheet), do: "chart-bar"
  defp file_icon(:presentation), do: "layers"
  defp file_icon(_), do: "list"

  defp file_bg(:pdf), do: "bg-red-500/10"
  defp file_bg(:image), do: "bg-purple-500/10"
  defp file_bg(:code), do: "bg-blue-500/10"
  defp file_bg(:archive), do: "bg-amber-500/10"
  defp file_bg(:document), do: "bg-sky-500/10"
  defp file_bg(:spreadsheet), do: "bg-green-500/10"
  defp file_bg(:presentation), do: "bg-orange-500/10"
  defp file_bg(_), do: "bg-muted"

  defp file_icon_color(:pdf), do: "text-red-500"
  defp file_icon_color(:image), do: "text-purple-500"
  defp file_icon_color(:code), do: "text-blue-500"
  defp file_icon_color(:archive), do: "text-amber-500"
  defp file_icon_color(:document), do: "text-sky-500"
  defp file_icon_color(:spreadsheet), do: "text-green-500"
  defp file_icon_color(:presentation), do: "text-orange-500"
  defp file_icon_color(_), do: "text-muted-foreground"
end
