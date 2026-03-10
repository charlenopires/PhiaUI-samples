defmodule PhiaDemoWeb.Demo.Components.VisualLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Components.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Visual Effects")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/components/visual">
      <div class="p-6 space-y-12 max-w-screen-xl mx-auto phia-animate">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Visual Effects</h1>
          <p class="text-muted-foreground mt-1">Background patterns, glass surfaces, and animated surface components.</p>
        </div>

        <%!-- Background Patterns --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Background Patterns</h2>

          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <%!-- Gradient Mesh --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">gradient_mesh</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-background">
                <.gradient_mesh id="mesh-demo" colors={["#ff6b6b", "#4ecdc4", "#45b7d1", "#96c93d"]} blob_count={4} class="absolute inset-0 w-full h-full" />
              </div>
              <p class="text-xs text-muted-foreground">JS-animated blob divs. PhiaMeshBg hook.</p>
            </div>

            <%!-- Retro Grid --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">retro_grid</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-black">
                <.retro_grid color="rgba(0,255,0,0.25)" cell_size={24} />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-green-400 font-mono text-sm font-semibold">RETRO GRID</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Perspective-transformed 3D grid — pure CSS.</p>
            </div>

            <%!-- Wave Bg --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">wave_bg</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-gradient-to-b from-sky-100 to-sky-50 dark:from-sky-950 dark:to-slate-900">
                <.wave_bg color="rgba(99,102,241,0.3)" color2="rgba(139,92,246,0.2)" duration={6} />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-sm font-semibold text-foreground">Wave Motion</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">SVG wave paths — pure CSS.</p>
            </div>

            <%!-- Bokeh Bg --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">bokeh_bg</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-slate-900">
                <.bokeh_bg class="absolute inset-0 w-full h-full" />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-white font-semibold text-sm">Bokeh Lights</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">CSS-animated blurred blobs — pure CSS.</p>
            </div>

            <%!-- Flicker Grid --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">flicker_grid</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-slate-900">
                <.flicker_grid id="flicker-demo" color="rgba(99,102,241,0.7)" dot_size={2} gap={16} />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-white font-semibold text-sm">Flicker Grid</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Canvas flicker dots. PhiaFlickerGrid hook.</p>
            </div>

            <%!-- Animated Gradient Bg --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">animated_gradient_bg</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-background">
                <.animated_gradient_bg from="#667eea" via="#764ba2" to="#f64f59" duration={6} />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-white font-semibold text-sm">Gradient Flow</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Animated gradient — pure CSS.</p>
            </div>
          </div>

          <%!-- More patterns row --%>
          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            <%!-- Noise Bg --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">noise_bg</p>
              <div class="relative h-24 rounded-lg overflow-hidden bg-gradient-to-br from-violet-500 to-purple-900">
                <.noise_bg opacity={0.4} />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-white text-xs font-semibold">Grain Texture</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">SVG feTurbulence — pure CSS.</p>
            </div>

            <%!-- Hex Pattern --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">hex_pattern</p>
              <div class="relative h-24 rounded-lg overflow-hidden bg-background">
                <.hex_pattern color="oklch(0.5 0.2 250 / 20%)" class="absolute inset-0 w-full h-full" />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-sm font-semibold text-foreground">Hexagons</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">SVG hex tile — pure CSS.</p>
            </div>

            <%!-- Beam Bg --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">beam_bg</p>
              <div class="relative h-24 rounded-lg overflow-hidden bg-slate-900">
                <.beam_bg class="absolute inset-0 w-full h-full" />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-white text-xs font-semibold">Beam Sweep</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">CSS beam sweep — pure CSS.</p>
            </div>

            <%!-- Flowing Lines --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">flowing_lines</p>
              <div class="relative h-24 rounded-lg overflow-hidden bg-background">
                <.flowing_lines class="absolute inset-0 w-full h-full" />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-sm font-semibold text-foreground">Flow Lines</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">SVG stroke-dashoffset — pure CSS.</p>
            </div>
          </div>
        </section>

        <%!-- Glass Surfaces --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Glass & Frosted Surfaces</h2>

          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <%!-- Glass Card --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">glass_card</p>
              <div class="relative h-40 rounded-lg overflow-hidden bg-gradient-to-br from-violet-500 via-purple-600 to-blue-500 flex items-center justify-center p-4">
                <.glass_card blur="md" opacity="medium" class="p-4 text-center">
                  <.icon name="layers" class="text-white mx-auto mb-1" />
                  <p class="text-white text-sm font-semibold">Glass Card</p>
                  <p class="text-white/70 text-xs">backdrop-blur</p>
                </.glass_card>
              </div>
              <p class="text-xs text-muted-foreground">Glassmorphism — pure CSS backdrop-filter.</p>
            </div>

            <%!-- Glass Panel --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">glass_panel</p>
              <div class="relative h-40 rounded-lg overflow-hidden bg-gradient-to-br from-green-400 via-teal-500 to-cyan-600 flex items-center justify-center p-4">
                <.glass_panel blur="xl" opacity="dark" class="text-center">
                  <p class="text-white text-sm font-semibold">Glass Panel</p>
                  <p class="text-white/70 text-xs">Wide nav overlay</p>
                </.glass_panel>
              </div>
              <p class="text-xs text-muted-foreground">Wider glass for nav overlays — pure CSS.</p>
            </div>

            <%!-- Acrylic Surface --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">acrylic_surface</p>
              <div class="relative h-40 rounded-lg overflow-hidden bg-gradient-to-br from-orange-400 via-rose-500 to-pink-600 flex items-center justify-center p-4">
                <.acrylic_surface blur="lg" class="p-4 text-center">
                  <p class="text-white text-sm font-semibold">Acrylic</p>
                  <p class="text-white/70 text-xs">Windows Acrylic + noise</p>
                </.acrylic_surface>
              </div>
              <p class="text-xs text-muted-foreground">Acrylic with noise texture — pure CSS.</p>
            </div>

            <%!-- Liquid Glass --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">liquid_glass</p>
              <div class="relative h-40 rounded-lg overflow-hidden bg-gradient-to-br from-sky-400 via-blue-500 to-indigo-600 flex items-center justify-center p-4">
                <.liquid_glass class="p-4 text-center">
                  <p class="text-white text-sm font-semibold">Liquid Glass</p>
                  <p class="text-white/70 text-xs">Apple 2025 style</p>
                </.liquid_glass>
              </div>
              <p class="text-xs text-muted-foreground">Prismatic border — pure CSS.</p>
            </div>

            <%!-- Neon Glow Card — Purple --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">neon_glow_card</p>
              <div class="flex items-center justify-center py-4 bg-slate-900 rounded-lg gap-3">
                <.neon_glow_card color="purple" intensity="md" class="p-3 text-center w-16">
                  <p class="text-purple-400 text-xs font-bold">PRP</p>
                </.neon_glow_card>
                <.neon_glow_card color="blue" intensity="md" class="p-3 text-center w-16">
                  <p class="text-blue-400 text-xs font-bold">BLU</p>
                </.neon_glow_card>
                <.neon_glow_card color="green" intensity="md" class="p-3 text-center w-16">
                  <p class="text-green-400 text-xs font-bold">GRN</p>
                </.neon_glow_card>
              </div>
              <p class="text-xs text-muted-foreground">Colored neon box-shadow — pure CSS.</p>
            </div>
          </div>
        </section>

        <%!-- Animated Surfaces --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Animated Surfaces</h2>

          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <%!-- Border Beam --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">border_beam</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.border_beam duration={6} color_from="#ffaa40" color_to="#9c40ff" class="w-40">
                  <div class="p-4 text-center">
                    <p class="text-sm font-semibold text-foreground">Border Beam</p>
                    <p class="text-xs text-muted-foreground">Rotating gradient</p>
                  </div>
                </.border_beam>
              </div>
              <p class="text-xs text-muted-foreground">Rotating conic border — pure CSS.</p>
            </div>

            <%!-- Shine Border --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">shine_border</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.shine_border shine_color="#c0c0c0" duration={4} class="w-40">
                  <div class="p-4 text-center">
                    <p class="text-sm font-semibold text-foreground">Shine Border</p>
                    <p class="text-xs text-muted-foreground">Rotating shine</p>
                  </div>
                </.shine_border>
              </div>
              <p class="text-xs text-muted-foreground">Rotating shine overlay — pure CSS.</p>
            </div>

            <%!-- Moving Border --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">moving_border</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.moving_border duration={4} class="w-40">
                  <div class="p-4 text-center">
                    <p class="text-sm font-semibold text-foreground">Moving Border</p>
                    <p class="text-xs text-muted-foreground">Shifting gradient</p>
                  </div>
                </.moving_border>
              </div>
              <p class="text-xs text-muted-foreground">Animated gradient border — pure CSS.</p>
            </div>

            <%!-- Magic Card --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">magic_card</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.magic_card id="magic-card-demo" gradient_color="oklch(0.3 0.1 250)" class="w-40 p-4">
                  <div class="text-center">
                    <.icon name="sparkles" class="text-primary mx-auto mb-1" size={:sm} />
                    <p class="text-sm font-semibold text-foreground">Magic Card</p>
                    <p class="text-xs text-muted-foreground">Move cursor here</p>
                  </div>
                </.magic_card>
              </div>
              <p class="text-xs text-muted-foreground">Cursor-tracked gradient. PhiaMagicCard hook.</p>
            </div>

            <%!-- Card Spotlight --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">card_spotlight</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.card_spotlight id="card-spotlight-demo" color="rgba(120,80,255,0.2)" size={200} class="w-40 p-4">
                  <div class="text-center">
                    <.icon name="zap" class="text-primary mx-auto mb-1" size={:sm} />
                    <p class="text-sm font-semibold text-foreground">Card Spotlight</p>
                    <p class="text-xs text-muted-foreground">Move cursor here</p>
                  </div>
                </.card_spotlight>
              </div>
              <p class="text-xs text-muted-foreground">Cursor spotlight overlay. PhiaCardSpotlight hook.</p>
            </div>
          </div>
        </section>

      </div>
    </Layout.layout>
    """
  end
end
