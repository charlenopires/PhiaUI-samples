defmodule PhiaDemoWeb.Demo.Components.MediaLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Components.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Media Showcase")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/components/media">
      <div class="p-6 space-y-10 max-w-screen-xl mx-auto phia-animate">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Media</h1>
          <p class="text-muted-foreground mt-1">Carousel, QR Code, AspectRatio, ScrollArea, and Resizable.</p>
        </div>

        <%!-- Carousel --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Carousel</h2>
          <div class="max-w-xl">
            <.carousel id="media-carousel">
              <.carousel_content>
                <.carousel_item>
                  <div class="h-48 rounded-xl bg-gradient-to-br from-primary/40 to-primary/80 flex items-center justify-center">
                    <div class="text-center text-white">
                      <p class="text-xl font-bold">Slide 1</p>
                      <p class="text-sm opacity-80">Beautiful gradient background</p>
                    </div>
                  </div>
                </.carousel_item>
                <.carousel_item>
                  <div class="h-48 rounded-xl bg-gradient-to-br from-amber-400 to-orange-500 flex items-center justify-center">
                    <div class="text-center text-white">
                      <p class="text-xl font-bold">Slide 2</p>
                      <p class="text-sm opacity-80">Warm amber gradient</p>
                    </div>
                  </div>
                </.carousel_item>
                <.carousel_item>
                  <div class="h-48 rounded-xl bg-gradient-to-br from-green-400 to-teal-600 flex items-center justify-center">
                    <div class="text-center text-white">
                      <p class="text-xl font-bold">Slide 3</p>
                      <p class="text-sm opacity-80">Cool teal gradient</p>
                    </div>
                  </div>
                </.carousel_item>
                <.carousel_item>
                  <div class="h-48 rounded-xl bg-gradient-to-br from-purple-500 to-blue-600 flex items-center justify-center">
                    <div class="text-center text-white">
                      <p class="text-xl font-bold">Slide 4</p>
                      <p class="text-sm opacity-80">Purple to blue gradient</p>
                    </div>
                  </div>
                </.carousel_item>
              </.carousel_content>
              <.carousel_previous />
              <.carousel_next />
            </.carousel>
          </div>
        </section>

        <%!-- QR Code --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">QrCode</h2>
          <div class="flex flex-wrap gap-6">
            <div class="text-center space-y-2">
              <.qr_code value="https://github.com/phiaui/phia_ui" size={150} />
              <p class="text-xs text-muted-foreground">PhiaUI GitHub</p>
            </div>
            <div class="text-center space-y-2">
              <.qr_code value="https://hex.pm/packages/phia_ui" size={150} />
              <p class="text-xs text-muted-foreground">Hex Package</p>
            </div>
            <div class="text-center space-y-2">
              <.qr_code value="https://localhost:4000" size={150} />
              <p class="text-xs text-muted-foreground">Dev Server</p>
            </div>
          </div>
        </section>

        <%!-- AspectRatio --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">AspectRatio</h2>
          <div class="grid gap-4 sm:grid-cols-3">
            <div>
              <p class="text-xs text-muted-foreground mb-2">16:9 (Video)</p>
              <.aspect_ratio ratio={16/9}>
                <div class="h-full w-full rounded-xl bg-gradient-to-br from-primary/30 to-primary/60 flex items-center justify-center">
                  <.icon name="image" class="text-primary/50 w-12 h-12" />
                </div>
              </.aspect_ratio>
            </div>
            <div>
              <p class="text-xs text-muted-foreground mb-2">1:1 (Square)</p>
              <.aspect_ratio ratio={1.0}>
                <div class="h-full w-full rounded-xl bg-gradient-to-br from-amber-400/30 to-orange-500/60 flex items-center justify-center">
                  <.icon name="image" class="text-amber-500/50 w-12 h-12" />
                </div>
              </.aspect_ratio>
            </div>
            <div>
              <p class="text-xs text-muted-foreground mb-2">4:3 (Classic)</p>
              <.aspect_ratio ratio={4/3}>
                <div class="h-full w-full rounded-xl bg-gradient-to-br from-green-400/30 to-teal-600/60 flex items-center justify-center">
                  <.icon name="image" class="text-green-500/50 w-12 h-12" />
                </div>
              </.aspect_ratio>
            </div>
          </div>
        </section>

        <%!-- ScrollArea --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">ScrollArea</h2>
          <div class="grid gap-4 sm:grid-cols-2">
            <div>
              <p class="text-xs text-muted-foreground mb-2">Vertical scroll</p>
              <.scroll_area class="h-48 rounded-xl border border-border p-3">
                <%= for i <- 1..20 do %>
                  <div class="py-2 border-b border-border/40 last:border-0 text-sm text-foreground">
                    List item {i} — scroll to see more content below
                  </div>
                <% end %>
              </.scroll_area>
            </div>
            <div>
              <p class="text-xs text-muted-foreground mb-2">Horizontal scroll</p>
              <.scroll_area class="w-full rounded-xl border border-border p-3" orientation="horizontal">
                <div class="flex gap-3" style="width: 800px">
                  <%= for i <- 1..10 do %>
                    <div class="flex h-24 w-32 shrink-0 items-center justify-center rounded-lg bg-muted text-sm font-medium text-foreground">
                      Card {i}
                    </div>
                  <% end %>
                </div>
              </.scroll_area>
            </div>
          </div>
        </section>

        <%!-- Resizable --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Resizable</h2>
          <.resizable class="h-48 rounded-xl border border-border overflow-hidden">
            <.resizable_panel default_size={35} min_size={20}>
              <div class="h-full flex items-center justify-center bg-muted/30">
                <div class="text-center">
                  <.icon name="panel-left" size={:sm} class="text-muted-foreground mx-auto mb-1" />
                  <p class="text-xs text-muted-foreground">Left panel</p>
                  <p class="text-[10px] text-muted-foreground/60">Drag handle to resize</p>
                </div>
              </div>
            </.resizable_panel>
            <.resizable_handle />
            <.resizable_panel>
              <div class="h-full flex items-center justify-center bg-background">
                <div class="text-center">
                  <.icon name="panel-right" size={:sm} class="text-muted-foreground mx-auto mb-1" />
                  <p class="text-xs text-muted-foreground">Right panel</p>
                  <p class="text-[10px] text-muted-foreground/60">Main content area</p>
                </div>
              </div>
            </.resizable_panel>
          </.resizable>
        </section>

        <%!-- Direction --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Direction</h2>
          <div class="flex flex-wrap gap-6">
            <.card class="border-border/60 shadow-sm p-4">
              <p class="text-xs text-muted-foreground mb-2">LTR (Left to Right)</p>
              <.direction dir="ltr">
                <p class="text-sm text-foreground">Hello World — left to right text direction</p>
              </.direction>
            </.card>
            <.card class="border-border/60 shadow-sm p-4">
              <p class="text-xs text-muted-foreground mb-2">RTL (Right to Left)</p>
              <.direction dir="rtl">
                <p class="text-sm text-foreground">مرحبا بالعالم — right to left text direction</p>
              </.direction>
            </.card>
          </div>
        </section>

        <%!-- Watermark --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Watermark</h2>
          <div class="grid gap-4 sm:grid-cols-2">
            <.watermark content="PhiaUI Demo" class="h-48 rounded-lg bg-muted/30 flex items-center justify-center">
              <p class="text-sm text-muted-foreground">Content with watermark overlay</p>
            </.watermark>
            <.watermark content="CONFIDENTIAL" rotate={-45} opacity="0.08" font_size="20px" class="h-48 rounded-lg bg-muted/30 flex items-center justify-center">
              <p class="text-sm text-muted-foreground">Custom rotation and opacity</p>
            </.watermark>
          </div>
        </section>

      </div>
    </Layout.layout>
    """
  end
end
