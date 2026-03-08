defmodule PhiaDemoWeb.Demo.Showcase.CardsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Cards Showcase")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/cards">
      <div class="p-6 space-y-10 max-w-screen-xl mx-auto phia-animate">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Cards</h1>
          <p class="text-muted-foreground mt-1">Card variants for every content type — from profiles to pricing.</p>
        </div>

        <%!-- Basic Cards --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Basic Card</h2>
          <div class="grid gap-4 sm:grid-cols-3">
            <.card class="border-border/60 shadow-sm">
              <.card_header>
                <.card_title>Default Card</.card_title>
                <.card_description>Standard card with header and content</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">Cards are the primary container for grouped content. They provide visual separation and structure.</p>
              </.card_content>
            </.card>
            <.card class="border-border/60 shadow-sm">
              <.card_header>
                <.card_title>With Footer</.card_title>
                <.card_description>Card with action footer</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">Cards can include a footer section for actions or additional metadata.</p>
              </.card_content>
              <.card_footer class="flex gap-2">
                <.button size={:sm}>Action</.button>
                <.button variant={:outline} size={:sm}>Cancel</.button>
              </.card_footer>
            </.card>
            <.card class="border-primary/30 bg-primary/5 shadow-sm">
              <.card_header>
                <.card_title class="text-primary">Highlighted Card</.card_title>
                <.card_description>Primary color accent variant</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">Use color accents to draw attention to featured or important cards.</p>
              </.card_content>
            </.card>
          </div>
        </section>

        <%!-- Selectable Card --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">SelectableCard</h2>
          <.selectable_card_group class="grid gap-3 sm:grid-cols-4">
            <.selectable_card selected={false} on_click="noop" value="free">
              <:title>Free — $0/mo</:title>
              <:description>For individuals</:description>
            </.selectable_card>
            <.selectable_card selected={true} on_click="noop" value="pro">
              <:title>Pro — $29/mo</:title>
              <:description>For professionals</:description>
            </.selectable_card>
            <.selectable_card selected={false} on_click="noop" value="team">
              <:title>Team — $89/mo</:title>
              <:description>For small teams</:description>
            </.selectable_card>
            <.selectable_card selected={false} on_click="noop" value="enterprise">
              <:title>Enterprise — Custom</:title>
              <:description>For large orgs</:description>
            </.selectable_card>
          </.selectable_card_group>
        </section>

        <%!-- Receipt Card --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">ReceiptCard</h2>
          <div class="max-w-sm">
            <.receipt_card>
              <:header>
                <div class="text-center py-2">
                  <p class="font-bold text-foreground text-lg">PhiaUI Store</p>
                  <p class="text-xs text-muted-foreground">Order #4521</p>
                </div>
              </:header>
              <:body>
                <.receipt_row label="Pro Plan" value="$299.00" />
                <.receipt_row label="Support Add-on" value="$49.00" />
                <.receipt_row label="Discount (10%)" value="-$34.80" />
              </:body>
              <:footer>
                <div class="flex justify-between font-bold text-foreground py-2">
                  <span>Total</span>
                  <span class="text-primary">$313.20</span>
                </div>
              </:footer>
            </.receipt_card>
          </div>
        </section>

        <%!-- Profile-style cards --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Profile Cards</h2>
          <div class="grid gap-4 sm:grid-cols-3">
            <%= for {name, role, email, stats} <- [
              {"Ana Costa", "Frontend Engineer", "ana@acme.com", [{"PRs", "42"}, {"Reviews", "128"}, {"Stars", "1.2k"}]},
              {"Bruno Lima", "Backend Engineer", "bruno@acme.com", [{"Commits", "387"}, {"PRs", "64"}, {"Stars", "890"}]},
              {"Carla Souza", "Design Lead", "carla@acme.com", [{"Designs", "215"}, {"Reviews", "94"}, {"Stars", "2.1k"}]}
            ] do %>
              <.card class="border-border/60 shadow-sm">
                <.card_content class="p-5">
                  <div class="flex items-start gap-3">
                    <.avatar size="lg">
                      <.avatar_fallback name={name} class="bg-primary/10 text-primary font-semibold" />
                    </.avatar>
                    <div class="flex-1 min-w-0">
                      <p class="font-semibold text-foreground">{name}</p>
                      <p class="text-xs text-muted-foreground">{role}</p>
                      <p class="text-xs text-muted-foreground/70 mt-0.5">{email}</p>
                    </div>
                    <.button variant={:outline} size={:sm} class="shrink-0">Follow</.button>
                  </div>
                  <div class="grid grid-cols-3 gap-2 mt-4 pt-4 border-t border-border/40">
                    <%= for {label, val} <- stats do %>
                      <div class="text-center">
                        <p class="text-sm font-bold text-foreground">{val}</p>
                        <p class="text-[10px] text-muted-foreground">{label}</p>
                      </div>
                    <% end %>
                  </div>
                </.card_content>
              </.card>
            <% end %>
          </div>
        </section>

        <%!-- Stat Cards --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">StatCard &amp; MetricGrid</h2>
          <div class="grid grid-cols-2 gap-4 lg:grid-cols-4">
            <%= for {title, value, trend, trend_val, icon} <- [
              {"Revenue", "$48,290", :up, "+14%", "circle-dollar-sign"},
              {"Users", "8,421", :up, "+6%", "users"},
              {"Orders", "1,284", :neutral, "→ 0%", "package"},
              {"Churn", "2.1%", :down, "-0.4%", "trending-down"}
            ] do %>
              <.stat_card title={title} value={value} trend={trend} trend_value={trend_val} class="border-border/60 shadow-sm">
                <:icon>
                  <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10">
                    <.icon name={icon} size={:sm} class="text-primary" />
                  </div>
                </:icon>
              </.stat_card>
            <% end %>
          </div>
        </section>

        <%!-- SparklineCard --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">SparklineCard</h2>
          <div class="grid gap-4 sm:grid-cols-3">
            <.sparkline_card title="Weekly Revenue" value="$12,400" trend={:up} delta="+8% vs last week" data={[4200, 5800, 4900, 6200, 7100, 6800, 8400]} />
            <.sparkline_card title="Active Sessions" value="1,842" trend={:up} delta="+12% today" data={[900, 1200, 1100, 1400, 1600, 1500, 1842]} />
            <.sparkline_card title="Error Rate" value="0.4%" trend={:down} delta="-0.1% vs last week" data={[0.8, 0.7, 0.6, 0.5, 0.6, 0.5, 0.4]} />
          </div>
        </section>

        <%!-- ArticleCard --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">ArticleCard</h2>
          <div class="grid gap-4 sm:grid-cols-3">
            <.article_card
              title="Getting Started with Phoenix"
              excerpt="A comprehensive guide to building real-time web applications with Phoenix LiveView."
              author_name="Jane Doe"
              date="Mar 2026"
              read_time="5 min read"
              category="Tutorial"
            />
            <.article_card
              title="Understanding OTP Patterns"
              excerpt="Deep dive into GenServers, Supervisors, and the building blocks of fault-tolerant systems."
              author_name="Bob Smith"
              date="Feb 2026"
              read_time="8 min read"
              category="Advanced"
              href="#"
            />
            <.article_card
              title="PhiaUI 1.0 Released"
              excerpt="Announcing the first stable release of the Phoenix LiveView component library."
              date="Mar 2026"
              category="Announcement"
            />
          </div>
        </section>

        <%!-- PricingCard --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">PricingCard</h2>
          <div class="grid gap-4 sm:grid-cols-3">
            <.pricing_card
              plan="Starter"
              price="$0"
              period="/month"
              features={["1 project", "5 team members", "—Priority support", "—Custom domains"]}
              cta_label="Get started"
            />
            <.pricing_card
              plan="Pro"
              price="$29"
              period="/month"
              description="Everything you need for growing teams."
              badge="Most popular"
              highlighted={true}
              features={["Unlimited projects", "Priority support", "Custom domains", "Analytics"]}
              cta_label="Start free trial"
            />
            <.pricing_card
              plan="Enterprise"
              price="Custom"
              period=""
              features={["Unlimited projects", "Priority support", "Custom domains", "Analytics", "SSO / SAML", "Dedicated support"]}
              cta_label="Contact sales"
            />
          </div>
        </section>

        <%!-- TestimonialCard --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">TestimonialCard</h2>
          <div class="grid gap-4 sm:grid-cols-3">
            <.testimonial_card
              quote="PhiaUI has transformed our development workflow. The component quality is outstanding."
              author_name="Sarah Chen"
              author_role="CTO at Acme"
              rating={5}
            />
            <.testimonial_card
              quote="Clean, well-documented components that just work. Saved us weeks of development time."
              author_name="Marcus Lee"
              author_role="Lead Engineer"
              company="NovaTech"
              variant={:bordered}
              rating={4}
            />
            <.testimonial_card
              quote="The best Phoenix component library I have used. Period."
              author_name="Ana Ferreira"
              variant={:minimal}
            />
          </div>
        </section>

        <%!-- TeamCard --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">TeamCard</h2>
          <div class="grid gap-4 sm:grid-cols-4">
            <.team_card name="Alex Rivera" role="Lead Engineer" fallback="AR" />
            <.team_card name="Mei Zhang" role="Product Designer" department="Design" fallback="MZ" />
            <.team_card name="Jordan Cole" role="DevOps" email="jordan@acme.com" variant={:compact} fallback="JC" />
            <.team_card name="Sara Nunes" role="Backend Engineer" department="Platform" variant={:horizontal} fallback="SN" />
          </div>
        </section>

      </div>
    </Layout.layout>
    """
  end
end
