defmodule PhiaDemo.FakeData do
  @moduledoc "Hardcoded demo data for the PhiaUI dashboard."

  # ── Overview KPIs ─────────────────────────────────────────────────────────

  def stats do
    [
      %{title: "Total Revenue", value: "$284,590", trend: :up, trend_value: "+12.5%", description: "vs. last month", icon: "circle-dollar-sign"},
      %{title: "Active Users", value: "12,847", trend: :up, trend_value: "+8.2%", description: "vs. last month", icon: "users"},
      %{title: "Orders", value: "3,924", trend: :neutral, trend_value: "→ 0.1%", description: "vs. last month", icon: "shopping-cart"},
      %{title: "Conversion", value: "4.7%", trend: :down, trend_value: "-0.3%", description: "vs. last month", icon: "percent"}
    ]
  end

  # ── Highlights carousel ───────────────────────────────────────────────────

  def highlights do
    [
      %{title: "Revenue Goal Reached", subtitle: "February 2026", stat: "$33,100", detail: "+12.5% above the monthly target", icon: "trending-up", badge: "Record"},
      %{title: "Largest User Base", subtitle: "Since launch", stat: "12,847", detail: "Active users — 8.2% monthly growth", icon: "users", badge: "New High"},
      %{title: "Historic NPS", subtitle: "Q1 2026 Survey", stat: "72", detail: "Top 10% of the industry — highly satisfied customers", icon: "star", badge: "Highlight"},
      %{title: "Enterprise Plus Launched", subtitle: "New plan available", stat: "$1,999/mo", detail: "3 contracts signed in the first week", icon: "zap", badge: "New"}
    ]
  end

  # ── Orders ────────────────────────────────────────────────────────────────

  def recent_orders do
    [
      %{id: "#4521", customer: "Ana Costa", product: "Pro Plan", amount: "$299.00", status: :paid, date: "Mar 1, 2026"},
      %{id: "#4520", customer: "Bruno Lima", product: "Starter Plan", amount: "$99.00", status: :pending, date: "Mar 1, 2026"},
      %{id: "#4519", customer: "Carla Souza", product: "Enterprise Plan", amount: "$999.00", status: :paid, date: "Feb 28, 2026"},
      %{id: "#4518", customer: "Diego Melo", product: "Pro Plan", amount: "$299.00", status: :cancelled, date: "Feb 28, 2026"},
      %{id: "#4517", customer: "Elena Rocha", product: "Starter Plan", amount: "$99.00", status: :paid, date: "Feb 27, 2026"},
      %{id: "#4516", customer: "Fabio Nunes", product: "Pro Plan", amount: "$299.00", status: :paid, date: "Feb 27, 2026"},
      %{id: "#4515", customer: "Gabi Torres", product: "Enterprise Plan", amount: "$999.00", status: :pending, date: "Feb 26, 2026"},
      %{id: "#4514", customer: "Hugo Alves", product: "Starter Plan", amount: "$99.00", status: :paid, date: "Feb 26, 2026"},
      %{id: "#4513", customer: "Isis Ferreira", product: "Pro Plan", amount: "$299.00", status: :paid, date: "Feb 25, 2026"},
      %{id: "#4512", customer: "Joao Ribeiro", product: "Enterprise Plan", amount: "$999.00", status: :cancelled, date: "Feb 25, 2026"}
    ]
  end

  # ── Users ─────────────────────────────────────────────────────────────────

  def users do
    [
      %{id: 1, name: "Ana Costa", email: "ana@acme.com", role: "Admin", status: :active, joined: "Jan 2024"},
      %{id: 2, name: "Bruno Lima", email: "bruno@acme.com", role: "Editor", status: :active, joined: "Mar 2024"},
      %{id: 3, name: "Carla Souza", email: "carla@acme.com", role: "Viewer", status: :inactive, joined: "Jun 2024"},
      %{id: 4, name: "Diego Melo", email: "diego@acme.com", role: "Editor", status: :active, joined: "Aug 2024"},
      %{id: 5, name: "Elena Rocha", email: "elena@acme.com", role: "Admin", status: :active, joined: "Sep 2024"},
      %{id: 6, name: "Fabio Nunes", email: "fabio@acme.com", role: "Viewer", status: :pending, joined: "Nov 2024"},
      %{id: 7, name: "Gabi Torres", email: "gabi@acme.com", role: "Editor", status: :active, joined: "Dec 2024"},
      %{id: 8, name: "Hugo Alves", email: "hugo@acme.com", role: "Viewer", status: :inactive, joined: "Feb 2025"}
    ]
  end

  def role_options do
    [
      %{value: "all", label: "All roles"},
      %{value: "Admin", label: "Admin"},
      %{value: "Editor", label: "Editor"},
      %{value: "Viewer", label: "Viewer"}
    ]
  end

  # ── Charts ────────────────────────────────────────────────────────────────

  def revenue_by_month do
    [
      %{month: "Mar", value: 18_500},
      %{month: "Apr", value: 21_300},
      %{month: "May", value: 19_800},
      %{month: "Jun", value: 24_100},
      %{month: "Jul", value: 22_700},
      %{month: "Aug", value: 26_400},
      %{month: "Sep", value: 23_900},
      %{month: "Oct", value: 28_600},
      %{month: "Nov", value: 31_200},
      %{month: "Dec", value: 35_800},
      %{month: "Jan", value: 29_400},
      %{month: "Feb", value: 33_100}
    ]
  end

  def visits_by_month do
    [
      %{month: "Mar", value: 4_200},
      %{month: "Apr", value: 5_800},
      %{month: "May", value: 5_100},
      %{month: "Jun", value: 6_900},
      %{month: "Jul", value: 7_400},
      %{month: "Aug", value: 8_100},
      %{month: "Sep", value: 7_600},
      %{month: "Oct", value: 9_200},
      %{month: "Nov", value: 10_500},
      %{month: "Dec", value: 12_300},
      %{month: "Jan", value: 9_800},
      %{month: "Feb", value: 11_200}
    ]
  end

  def traffic_by_source do
    [
      %{source: "Organic Search", value: 42, color: "fill-primary"},
      %{source: "Direct", value: 25, color: "fill-secondary-foreground"},
      %{source: "Social Media", value: 18, color: "fill-success"},
      %{source: "Email", value: 10, color: "fill-warning"},
      %{source: "Other", value: 5, color: "fill-muted-foreground"}
    ]
  end

  # ── Analytics ─────────────────────────────────────────────────────────────

  def top_products do
    [
      %{name: "Enterprise Plan", revenue: "$11,988", orders: 12, pct: 100},
      %{name: "Pro Plan", revenue: "$8,970", orders: 30, pct: 75},
      %{name: "Starter Plan", revenue: "$2,970", orders: 30, pct: 25},
      %{name: "Analytics Add-on", revenue: "$1,490", orders: 15, pct: 12},
      %{name: "Premium Support", revenue: "$990", orders: 9, pct: 8}
    ]
  end

  def order_summary do
    %{
      total_revenue: "$26,418",
      avg_ticket: "$359.00",
      paid_amount: "$22,278"
    }
  end

  def analytics_stats do
    [
      %{title: "Unique Visitors", value: "98,421", trend: :up, trend_value: "+14.3%", description: "vs. last month"},
      %{title: "Pages per Session", value: "3.8", trend: :up, trend_value: "+0.4", description: "vs. last month"},
      %{title: "Bounce Rate", value: "32.1%", trend: :down, trend_value: "-2.1%", description: "vs. last month"}
    ]
  end

  def period_options do
    [
      %{value: "last_7", label: "Last 7 days"},
      %{value: "last_30", label: "Last 30 days"},
      %{value: "last_90", label: "Last 90 days"},
      %{value: "this_year", label: "This year"},
      %{value: "last_year", label: "Last year"}
    ]
  end

  # ── Activity ──────────────────────────────────────────────────────────────

  def activity_log do
    [
      %{title: "Enterprise Sale — Carla Souza", desc: "Enterprise Plan activated — $999.00", date: "Feb 28", icon: "circle-check", color: "text-success"},
      %{title: "New User — Fabio Nunes", desc: "Account approved — Starter Plan", date: "Feb 27", icon: "user-plus", color: "text-primary"},
      %{title: "Cancellation — Joao Ribeiro", desc: "Enterprise Plan terminated at customer request", date: "Feb 25", icon: "circle-x", color: "text-destructive"},
      %{title: "Plan Upgrade — Diego Melo", desc: "Starter → Pro — prorated charge applied", date: "Feb 24", icon: "circle-arrow-up", color: "text-warning"},
      %{title: "NPS Collected — Q1 2026", desc: "Score: 72 — 183 responses received", date: "Feb 20", icon: "star", color: "text-primary"}
    ]
  end

  def notifications do
    [
      %{title: "Order confirmed", description: "Order #4521 was paid successfully.", variant: :default},
      %{title: "User removed", description: "Hugo Alves' account has been deactivated.", variant: :destructive}
    ]
  end

  # ── Chat ──────────────────────────────────────────────────────────────────

  def chat_rooms do
    [
      %{id: "products", name: "Products", description: "Featured product showcase", icon: "package"},
      %{id: "order", name: "Order", description: "Sales proposal and scheduling", icon: "inbox"},
      %{id: "survey", name: "Survey", description: "Customer satisfaction survey", icon: "chart-bar"}
    ]
  end

  def chat_users do
    [
      %{id: "sofia", name: "Sofia", initials: "SF", status: :online, color: "bg-primary", role: "Sales Consultant"},
      %{id: "marcos", name: "Marcos", initials: "MK", status: :online, color: "bg-success", role: "Account Executive"},
      %{id: "you", name: "You", initials: "YO", status: :online, color: "bg-violet-500", role: "Customer"}
    ]
  end

  def chat_seed_messages("products") do
    [
      %{
        id: "p_sys1",
        user_id: "system",
        text: "Sofia joined the conversation",
        timestamp: "09:58",
        reactions: %{},
        type: :system,
        reply_to: nil
      },
      %{
        id: "p1",
        user_id: "sofia",
        text: "Hi! Welcome to our store! I'm Sofia, your sales consultant. Can I show you some of our featured products today?",
        timestamp: "09:58",
        reactions: %{"❤️" => ["sofia"]},
        type: :text,
        reply_to: nil,
        read: true
      },
      %{
        id: "p2",
        user_id: "sofia",
        text: "Check out our best-selling product this month:",
        timestamp: "09:59",
        reactions: %{},
        type: :product_card,
        reply_to: nil,
        read: true,
        product: %{
          name: "iPhone 15 Pro",
          price: "$999",
          badge: "Best Seller",
          description: "A17 Pro chip · 48MP camera · Titanium",
          gradient: "slate",
          icon: "smartphone"
        },
        quick_replies: [
          %{label: "Yes, tell me more", value: "yes"},
          %{label: "No, thanks", value: "no"}
        ],
        answered: false,
        answer: nil
      },
      %{
        id: "p3",
        user_id: "sofia",
        text: "We also have an exclusive deal on this laptop:",
        timestamp: "10:00",
        reactions: %{},
        type: :product_card,
        reply_to: nil,
        read: true,
        product: %{
          name: "MacBook Air M3",
          price: "$1,299",
          badge: "10% OFF",
          description: "M3 chip · 8GB RAM · 18h battery life",
          gradient: "violet",
          icon: "laptop"
        },
        quick_replies: [
          %{label: "I'm interested", value: "yes"},
          %{label: "Maybe later", value: "no"}
        ],
        answered: false,
        answer: nil
      }
    ]
  end

  def chat_seed_messages("order") do
    [
      %{
        id: "ped_sys1",
        user_id: "system",
        text: "Marcos joined the conversation",
        timestamp: "10:05",
        reactions: %{},
        type: :system,
        reply_to: nil
      },
      %{
        id: "ped1",
        user_id: "marcos",
        text: "Hi! I heard you're interested in the Enterprise plan. Let me put together a custom proposal for you!",
        timestamp: "10:05",
        reactions: %{},
        type: :text,
        reply_to: nil,
        read: true
      },
      %{
        id: "ped2",
        user_id: "marcos",
        text: "To send you the proposal, I'll need your best email address:",
        timestamp: "10:06",
        reactions: %{},
        type: :email_form,
        reply_to: nil,
        read: true,
        answered: false,
        email: nil
      },
      %{
        id: "ped3",
        user_id: "marcos",
        text: "Our consultant can run a live demo for you. Which day of the week works best?",
        timestamp: "10:07",
        reactions: %{},
        type: :booking,
        reply_to: nil,
        read: true,
        days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
        answered: false,
        selected_day: nil
      }
    ]
  end

  def chat_seed_messages("survey") do
    [
      %{
        id: "enq_sys1",
        user_id: "system",
        text: "Sofia joined the conversation",
        timestamp: "10:15",
        reactions: %{},
        type: :system,
        reply_to: nil
      },
      %{
        id: "enq1",
        user_id: "sofia",
        text: "Hi! We're running a quick survey about our customers' preferences. It takes less than 1 minute!",
        timestamp: "10:15",
        reactions: %{"👍" => ["marcos"]},
        type: :text,
        reply_to: nil,
        read: true
      },
      %{
        id: "enq2",
        user_id: "sofia",
        text: nil,
        timestamp: "10:16",
        reactions: %{},
        type: :poll,
        reply_to: nil,
        read: true,
        poll: %{
          id: "poll_seed1",
          question: "Which product categories interest you the most?",
          options: [
            %{text: "Smartphones & Tablets", votes: ["sofia"]},
            %{text: "Laptops & Computers", votes: []},
            %{text: "Gaming & Accessories", votes: ["marcos"]},
            %{text: "Cameras & Photography", votes: []}
          ],
          created_by: "sofia",
          created_at: "10:16"
        }
      },
      %{
        id: "enq3",
        user_id: "sofia",
        text: "Thanks for your answers! One last question:",
        timestamp: "10:17",
        reactions: %{},
        type: :text,
        reply_to: nil,
        read: true
      },
      %{
        id: "enq4",
        user_id: "sofia",
        text: "On a scale from 0 to 10, how likely are you to recommend our store to a friend?",
        timestamp: "10:17",
        reactions: %{},
        type: :nps,
        reply_to: nil,
        read: true,
        answered: false,
        selected_score: nil
      }
    ]
  end

  def chat_seed_messages(_room_id) do
    [
      %{id: "generic1", user_id: "sofia", text: "Welcome! How can I help you today?", timestamp: "09:00", reactions: %{}, type: :text, reply_to: nil, read: true}
    ]
  end
end
