defmodule PhiaDemoWeb.Demo.Showcase.AnimationLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Animation & Effects")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/animation">
      <div class="p-6 space-y-12 max-w-screen-xl mx-auto">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Animation & Effects</h1>
          <p class="text-muted-foreground mt-1">22 animation primitives — text effects, backgrounds, interactive hover, counters, and canvas.</p>
        </div>

        <%!-- Text Effects --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Text Effects</h2>

          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            <%!-- Shimmer Text --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">shimmer_text</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.shimmer_text class="text-2xl font-bold text-foreground">
                  ✨ PhiaUI
                </.shimmer_text>
              </div>
              <p class="text-xs text-muted-foreground">Sliding shine gradient — pure CSS.</p>
            </div>

            <%!-- Typewriter --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">typewriter</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg min-h-[72px]">
                <.typewriter
                  id="tw-demo"
                  text="Phoenix LiveView!"
                  loop={true}
                  speed={70}
                  class="text-lg font-semibold text-foreground"
                />
              </div>
              <p class="text-xs text-muted-foreground">Char-by-char reveal with cursor.</p>
            </div>

            <%!-- Word Rotate --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">word_rotate</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg min-h-[72px]">
                <div class="text-center">
                  <span class="text-lg font-semibold text-foreground">Build </span>
                  <.word_rotate
                    id="wr-demo"
                    words={["faster", "smarter", "better", "together"]}
                    class="text-lg font-bold text-primary"
                  />
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Cycling words with fade transition.</p>
            </div>

            <%!-- Text Scramble --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">text_scramble</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg min-h-[72px]">
                <.text_scramble
                  id="ts-demo"
                  text="Decode me!"
                  trigger={:mount}
                  class="text-lg font-semibold text-foreground"
                />
              </div>
              <p class="text-xs text-muted-foreground">Glitch-then-reveal text effect.</p>
            </div>
          </div>
        </section>

        <%!-- Background Effects --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Background Effects</h2>

          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <%!-- Aurora --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">aurora</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-slate-900">
                <.aurora
                  colors={["oklch(0.541 0.281 293.009 / 0.6)", "oklch(0.546 0.245 262.881 / 0.4)", "oklch(0.592 0.241 349.615 / 0.3)"]}
                  speed={8}
                  class="absolute inset-0 h-full w-full"
                />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-white font-semibold text-sm">Aurora Borealis</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Animated gradient — pure CSS.</p>
            </div>

            <%!-- Meteor Shower --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">meteor_shower</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-slate-900">
                <.meteor_shower count={12} color="#94a3b8" class="absolute inset-0 w-full h-full" />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-white font-semibold text-sm">✦ Star Field</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Falling meteors — pure CSS.</p>
            </div>

            <%!-- Dot Pattern --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">dot_pattern</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-background">
                <.dot_pattern color="oklch(0.5 0.2 250 / 25%)" spacing={20} class="absolute inset-0 w-full h-full" />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-sm font-semibold text-foreground">Dot Grid</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Radial dot grid — pure CSS.</p>
            </div>

            <%!-- Grid Pattern --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">grid_pattern</p>
              <div class="relative h-32 rounded-lg overflow-hidden bg-background">
                <.grid_pattern color="oklch(0.5 0.2 250 / 15%)" size={24} class="absolute inset-0 w-full h-full" />
                <div class="absolute inset-0 flex items-center justify-center">
                  <span class="text-sm font-semibold text-foreground">Grid Lines</span>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">Orthogonal grid — pure CSS.</p>
            </div>

            <%!-- Ripple --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">ripple_bg</p>
              <div class="flex items-center justify-center h-32 bg-muted/30 rounded-lg">
                <.ripple_bg color="var(--color-primary)" count={3} class="size-24" />
              </div>
              <p class="text-xs text-muted-foreground">Concentric expanding rings — pure CSS.</p>
            </div>

            <%!-- Orbit --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">orbit</p>
              <div class="flex items-center justify-center h-32 bg-muted/30 rounded-lg">
                <.orbit radius={48} duration={6}>
                  <span class="size-3 rounded-full bg-primary shadow-[0_0_8px_2px] shadow-primary/60" />
                  <:center>
                    <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary/10 border border-primary/30">
                      <.icon name="layers" size={:xs} class="text-primary" />
                    </div>
                  </:center>
                </.orbit>
              </div>
              <p class="text-xs text-muted-foreground">Element orbiting center — pure CSS.</p>
            </div>
          </div>
        </section>

        <%!-- Entry & Loop Animations --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Entry & Loop Animations</h2>

          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            <%!-- Fade In --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">fade_in</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.fade_in direction={:up} delay={0} once={false}>
                  <div class="rounded-lg bg-primary/10 border border-primary/20 px-4 py-2">
                    <span class="text-sm font-semibold text-primary">Fades in ↑</span>
                  </div>
                </.fade_in>
              </div>
              <p class="text-xs text-muted-foreground">Scroll-triggered reveal. PhiaScrollReveal hook.</p>
            </div>

            <%!-- Float --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">float</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.float>
                  <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-lg">
                    <.icon name="sparkles" size={:sm} />
                  </div>
                </.float>
              </div>
              <p class="text-xs text-muted-foreground">Perpetual levitation loop — pure CSS.</p>
            </div>

            <%!-- Animated Border --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">animated_border</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.animated_border class="w-32">
                  <div class="px-3 py-2 text-center text-sm font-semibold text-foreground">Border Spin</div>
                </.animated_border>
              </div>
              <p class="text-xs text-muted-foreground">Rotating conic-gradient border — pure CSS.</p>
            </div>

            <%!-- Pulse Ring --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">pulse_ring</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.pulse_ring color="var(--color-primary)" size={40}>
                  <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-primary-foreground">
                    <.icon name="bell" size={:xs} />
                  </div>
                </.pulse_ring>
              </div>
              <p class="text-xs text-muted-foreground">Expanding pulsing rings — pure CSS.</p>
            </div>
          </div>
        </section>

        <%!-- Interactive Hover --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Interactive Hover</h2>

          <div class="grid gap-6 sm:grid-cols-2">
            <%!-- Spotlight --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">spotlight</p>
              <.spotlight id="spotlight-demo" class="h-36 rounded-lg bg-slate-900 flex items-center justify-center">
                <span class="relative z-10 text-white font-semibold">Move cursor here</span>
              </.spotlight>
              <p class="text-xs text-muted-foreground">Cursor-following radial light. PhiaSpotlight hook.</p>
            </div>

            <%!-- Tilt Card --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">tilt_card</p>
              <.tilt_card id="tilt-demo" class="h-36 rounded-lg bg-gradient-to-br from-primary/20 to-primary/5 border border-primary/20 flex items-center justify-center">
                <div class="text-center">
                  <.icon name="layers" class="text-primary mx-auto mb-2" />
                  <span class="text-sm font-semibold text-foreground">Hover to tilt</span>
                </div>
              </.tilt_card>
              <p class="text-xs text-muted-foreground">3D perspective tilt on hover. PhiaTiltCard hook.</p>
            </div>
          </div>
        </section>

        <%!-- Counters & Loaders --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Counters & Loaders</h2>

          <div class="grid gap-6 sm:grid-cols-3">
            <%!-- Number Ticker --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">number_ticker</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <div class="text-center">
                  <p class="text-4xl font-bold text-foreground tabular-nums">
                    <.number_ticker id="anim-ticker" value={1337} duration={1800} />
                  </p>
                  <p class="text-xs text-muted-foreground mt-1">Count-up animation</p>
                </div>
              </div>
              <p class="text-xs text-muted-foreground">PhiaNumberTicker hook.</p>
            </div>

            <%!-- Typing Indicator --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">typing_indicator</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.typing_indicator />
              </div>
              <p class="text-xs text-muted-foreground">3-dot bouncing chat loader — pure CSS.</p>
            </div>

            <%!-- Wave Loader --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">wave_loader</p>
              <div class="flex items-center justify-center py-4 bg-muted/30 rounded-lg">
                <.wave_loader />
              </div>
              <p class="text-xs text-muted-foreground">Wave bar equalizer — pure CSS.</p>
            </div>
          </div>
        </section>

        <%!-- Marquee --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Marquee</h2>

          <div class="rounded-xl border border-border/60 bg-card p-5 space-y-4">
            <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">marquee — horizontal infinite scroll</p>
            <.marquee id="marquee-demo" gap="gap-6" class="py-2">
              <%= for item <- ~w(Phoenix LiveView Tailwind PhiaUI Components Hooks DarkMode Theming OKLCH Animations) do %>
                <div class="flex items-center gap-2 rounded-full border border-border/60 bg-card px-4 py-2 text-sm font-medium text-foreground shadow-sm">
                  <span class="h-2 w-2 rounded-full bg-primary" />
                  {item}
                </div>
              <% end %>
            </.marquee>
            <p class="text-xs text-muted-foreground">Seamless infinite scroll. PhiaMarquee hook. Pauses on hover.</p>
          </div>
        </section>

        <%!-- Canvas Effects --%>
        <section class="space-y-6">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Canvas Effects</h2>

          <div class="grid gap-6 sm:grid-cols-2">
            <%!-- Particle Bg --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">particle_bg</p>
              <.particle_bg id="particle-demo" color="rgba(99,102,241,0.6)" count={40} class="h-36 rounded-lg bg-slate-900">
              </.particle_bg>
              <p class="text-xs text-muted-foreground">Canvas floating particles. PhiaParticleBg hook.</p>
            </div>

            <%!-- Confetti --%>
            <div class="rounded-xl border border-border/60 bg-card p-5 space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">confetti_burst</p>
              <.confetti_burst id="confetti-demo" trigger={:mount} class="h-36 rounded-lg bg-muted/30 flex items-center justify-center">
                <span class="relative z-10 text-sm font-semibold text-foreground">🎉 Celebration!</span>
              </.confetti_burst>
              <p class="text-xs text-muted-foreground">Canvas confetti particles. PhiaConfetti hook.</p>
            </div>
          </div>
        </section>

      </div>
    </Layout.layout>
    """
  end
end
