defmodule PhiaDemoWeb.Demo.Showcase.UploadLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Upload Showcase")
     |> assign(:zone_state, "idle")
     |> assign(:transfer_source, [
       %{id: "admin", label: "Admin"},
       %{id: "editor", label: "Editor"},
       %{id: "viewer", label: "Viewer"},
       %{id: "moderator", label: "Moderator"},
       %{id: "contributor", label: "Contributor"}
     ])
     |> assign(:transfer_target, [
       %{id: "owner", label: "Owner"}
     ])
     |> allow_upload(:showcase_image,
       accept: ~w(.jpg .jpeg .png .webp .gif),
       max_entries: 3,
       max_file_size: 5_242_880
     )
     |> allow_upload(:showcase_file,
       accept: ~w(.pdf .doc .docx .txt .csv),
       max_entries: 5,
       max_file_size: 10_485_760
     )
     |> allow_upload(:showcase_btn,
       accept: ~w(.csv .json .txt),
       max_entries: 3,
       max_file_size: 5_242_880
     )
     |> allow_upload(:showcase_queue,
       accept: :any,
       max_entries: 5,
       max_file_size: 10_485_760
     )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel_upload", %{"ref" => ref, "name" => name}, socket) do
    upload_name = String.to_existing_atom(name)
    {:noreply, cancel_upload(socket, upload_name, ref)}
  end

  def handle_event("noop", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("zone_drop", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("roles_updated", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/upload">
      <div class="p-6 space-y-10 max-w-screen-xl mx-auto phia-animate">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Upload</h1>
          <p class="text-muted-foreground mt-1">File upload, image upload, avatar upload, drop zones, transfer lists, and progress indicators.</p>
        </div>

        <%!-- ImageUpload --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">ImageUpload</h2>
          <div class="max-w-md">
            <.form for={%{}} phx-change="validate" phx-submit="noop">
              <.image_upload upload={@uploads.showcase_image} label="Click or drag & drop images here (JPG, PNG, WEBP)" />
            </.form>
          </div>
        </section>

        <%!-- FileUpload --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">FileUpload</h2>
          <div class="max-w-md">
            <.form for={%{}} phx-change="validate" phx-submit="noop">
              <.file_upload upload={@uploads.showcase_file} label="Upload Documents" accept=".pdf,.doc,.docx">
                <:empty>
                  <p class="text-sm text-muted-foreground">Drag &amp; drop files here or <span class="text-primary font-medium">click to browse</span></p>
                  <p class="text-[11px] text-muted-foreground/60 mt-1">PDF, DOC, DOCX up to 10MB</p>
                </:empty>
                <:file :let={entry}>
                  <.file_upload_entry entry={entry} on_cancel="cancel_upload" />
                </:file>
              </.file_upload>
            </.form>
          </div>
        </section>

        <%!-- DropZone component --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">DropZone</h2>
          <p class="text-sm text-muted-foreground">Interactive drop zone with state transitions (idle / hover / active / error). Drag files over to see the visual states.</p>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 max-w-2xl">
            <div class="space-y-2">
              <p class="text-xs font-medium text-muted-foreground uppercase tracking-wide">Default (idle)</p>
              <.drop_zone id="zone-idle" label="Drop files here" on_drop="zone_drop" />
            </div>
            <div class="space-y-2">
              <p class="text-xs font-medium text-muted-foreground uppercase tracking-wide">Custom icon &amp; label</p>
              <.drop_zone id="zone-custom" label="Drop images here" on_drop="zone_drop" accepts="image/*">
                <:icon>
                  <.icon name="image" size={:md} class="opacity-60" />
                </:icon>
                Drag &amp; drop images or click to browse
              </.drop_zone>
            </div>
          </div>
        </section>

        <%!-- DragTransferList --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">DragTransferList</h2>
          <p class="text-sm text-muted-foreground">Dual-list transfer widget with drag-and-drop and button-click fallbacks. Click an item to select, then use arrows or drag between lists.</p>
          <div class="max-w-md">
            <.drag_transfer_list
              id="role-transfer"
              source_label="Available Roles"
              target_label="Assigned Roles"
              source_items={@transfer_source}
              target_items={@transfer_target}
              on_transfer="roles_updated"
            />
          </div>
        </section>

        <%!-- Upload progress mock --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Upload Progress</h2>
          <.card class="border-border/60 shadow-sm max-w-md">
            <.card_content class="p-5 space-y-4">
              <%= for {name, pct, icon_name} <- [{"hero-banner.png", 100, "image"}, {"Q1-Report.pdf", 73, "file-text"}, {"assets.zip", 28, "package"}] do %>
                <div class="space-y-1.5">
                  <div class="flex items-center justify-between text-sm">
                    <div class="flex items-center gap-2">
                      <.icon name={icon_name} size={:xs} class="text-primary" />
                      <span class="font-medium text-foreground">{name}</span>
                    </div>
                    <div class="flex items-center gap-2">
                      <span class="text-xs text-muted-foreground">{pct}%</span>
                      <%= if pct == 100 do %>
                        <.icon name="circle-check" size={:xs} class="text-green-500" />
                      <% else %>
                        <.icon name="x" size={:xs} class="text-muted-foreground hover:text-destructive cursor-pointer" />
                      <% end %>
                    </div>
                  </div>
                  <.progress value={pct} class={"h-1.5 " <> if(pct == 100, do: "[&>div]:bg-green-500", else: "")} />
                </div>
              <% end %>
            </.card_content>
          </.card>
        </section>

        <%!-- Avatar upload --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Avatar Upload Pattern</h2>
          <div class="flex items-center gap-6">
            <div class="relative">
              <.avatar size="xl">
                <.avatar_fallback name="John Doe" class="bg-primary/10 text-primary text-lg font-semibold" />
              </.avatar>
              <button class="absolute bottom-0 right-0 flex h-7 w-7 items-center justify-center rounded-full border-2 border-background bg-primary text-primary-foreground shadow-sm hover:bg-primary/90 transition-colors">
                <.icon name="pencil" size={:xs} />
              </button>
            </div>
            <div>
              <p class="text-sm font-semibold text-foreground">John Doe</p>
              <p class="text-xs text-muted-foreground mb-2">john@acme.com</p>
              <.button variant={:outline} size={:sm}>
                <.icon name="upload" size={:xs} class="mr-1.5" />
                Upload photo
              </.button>
            </div>
          </div>
        </section>

        <%!-- UploadButton --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">UploadButton</h2>
          <p class="text-sm text-muted-foreground">Compact button-style file picker — opens the file dialog without a drop zone. Selected files appear in a list below.</p>
          <div class="flex flex-wrap gap-4 max-w-lg">
            <.form for={%{}} phx-change="validate" phx-submit="noop">
              <div class="space-y-4">
                <.upload_button upload={@uploads.showcase_btn} label="Import CSV" variant="default" />
                <.upload_button upload={@uploads.showcase_btn} label="Attach files" variant="outline" size="sm" show_list={false} />
              </div>
            </.form>
          </div>
        </section>

        <%!-- UploadQueue --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">UploadQueue</h2>
          <p class="text-sm text-muted-foreground">Multi-entry upload queue showing per-file progress with file-type badges and cancel buttons. Select files to see the queue.</p>
          <div class="max-w-md space-y-3">
            <.form for={%{}} phx-change="validate" phx-submit="noop">
              <.upload_button upload={@uploads.showcase_queue} label="Add files" variant="outline" show_list={false} />
              <.upload_queue upload={@uploads.showcase_queue} on_cancel="cancel_upload" show_empty={true} empty_label="No files added yet" class="mt-3" />
            </.form>
          </div>
        </section>

        <%!-- UploadProgress (standalone) --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">UploadProgress</h2>
          <p class="text-sm text-muted-foreground">Standalone progress rows with five status states: pending, uploading, done, error, and canceled.</p>
          <div class="max-w-md space-y-2">
            <.upload_progress filename="quarterly-report.pdf" status={:pending} />
            <.upload_progress filename="photo-gallery.zip" status={:uploading} progress={67} on_cancel="noop" />
            <.upload_progress filename="invoice_2026.xlsx" status={:done} progress={100} />
            <.upload_progress filename="backup.tar.gz" status={:error} progress={34} error_message="Network timeout — file too large" on_retry="noop" on_cancel="noop" />
            <.upload_progress filename="old-draft.docx" status={:canceled} />
          </div>
        </section>

        <%!-- UploadCard --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">UploadCard</h2>
          <p class="text-sm text-muted-foreground">Cards representing completed file uploads with file-type badges, size, status, and optional download/remove actions.</p>
          <div class="max-w-md space-y-2">
            <.upload_card filename="invoice_q1_2026.pdf" size_bytes={248_320} status={:done} uploaded_at="Mar 6, 2026" on_remove="noop" />
            <.upload_card filename="product_photo.jpg" size_bytes={1_843_200} status={:done} uploaded_at="Mar 7, 2026" href="#" />
            <.upload_card filename="team-data.xlsx" size_bytes={512_000} status={:done} on_remove="noop" href="#" />
            <.upload_card filename="corrupted_file.zip" size_bytes={98_304} status={:error} on_remove="noop" />
          </div>
        </section>

        <%!-- CopyButton --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">CopyButton</h2>
          <div class="space-y-3 max-w-md">
            <div class="flex items-center gap-2 rounded-lg border border-border bg-muted/30 px-3 py-2">
              <code class="flex-1 font-mono text-sm text-foreground">npm install phia_ui</code>
              <.copy_button id="copy-npm" value="npm install phia_ui" label="Copy install command" />
            </div>
            <div class="flex items-center gap-2 rounded-lg border border-border bg-muted/30 px-3 py-2">
              <code class="flex-1 font-mono text-sm text-foreground">phia_prod_k1x8m2n4p6q9...</code>
              <.copy_button id="copy-key" value="phia_prod_k1x8m2n4p6q9r3s5t7u0v2w4y6z8a1b3" label="Copy API key" />
            </div>
            <div class="flex items-center gap-2 rounded-lg border border-border bg-muted/30 px-3 py-2">
              <code class="flex-1 font-mono text-sm text-foreground">mix phia.install Button Card Badge</code>
              <.copy_button id="copy-mix" value="mix phia.install Button Card Badge" label="Copy mix command" />
            </div>
          </div>
        </section>

      </div>
    </Layout.layout>
    """
  end
end
