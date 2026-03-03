# PhiaUI Samples

> A real-world dashboard demo showcasing the [PhiaUI](https://github.com/charlenopires/phiaui) component library for **Phoenix LiveView**.

---

## Overview

This repository contains a fully functional **admin dashboard** built with Elixir, Phoenix 1.8, Phoenix LiveView 1.1, and Tailwind CSS — demonstrating how to integrate and use **PhiaUI** components in a production-like application.

The app features four interactive LiveView pages:

| Route | Module | Description |
|---|---|---|
| `/` | `DashboardLive.Overview` | KPI cards, monthly revenue bar chart, recent orders table, and top-products breakdown |
| `/analytics` | `DashboardLive.Analytics` | Traffic & engagement metrics, monthly visitors line chart, traffic-source donut chart, and conversion-by-channel progress bars |
| `/users` | `DashboardLive.Users` | User listing table with role and status badges, stat cards, and pending-user alert |
| `/orders` | `DashboardLive.Orders` | Full order listing with status color-coding, summary KPIs, and action buttons |

---

## PhiaUI Components Used

The demo actively uses the following **PhiaUI** components imported globally via `PhiaDemoWeb`:

| Component | Module | Usage |
|---|---|---|
| `<.shell>` / `<.sidebar>` | `PhiaUi.Components.Shell` | App shell with collapsible sidebar and top-bar |
| `<.stat_card>` | `PhiaUi.Components.StatCard` | KPI tiles with trend indicators (up / down / neutral) |
| `<.metric_grid>` | `PhiaUi.Components.MetricGrid` | Responsive grid layout for stat cards |
| `<.chart_shell>` | `PhiaUi.Components.ChartShell` | Framed container for SVG charts with title and period |
| `<.card>` / `<.card_header>` / `<.card_content>` | `PhiaUi.Components.Card` | General-purpose content cards |
| `<.badge>` | `PhiaUi.Components.Badge` | Variant-aware inline labels (default, secondary, outline, destructive) |
| `<.button>` | `PhiaUi.Components.Button` | Buttons with variant and size props |
| `<.table>` / `<.table_header>` etc. | `PhiaUi.Components.Table` | Semantic data tables |
| `<.alert>` / `<.alert_title>` / `<.alert_description>` | `PhiaUi.Components.Alert` | Contextual alert banners (default, warning) |
| `<.icon>` | `PhiaUi.Components.Icon` | Lucide-style icon component |

---

## Prerequisites

- **Elixir** `~> 1.15`
- **Erlang/OTP** 26+
- **Node.js** (for initial asset compilation)
- **Mix** (bundled with Elixir)

> The `PhiaUI` library is fetched automatically from [Hex.pm](https://hex.pm) as a standard dependency. No local clone is required unless you plan to modify PhiaUI itself — in that case, override the path dependency in `mix.exs`.

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/charlenopires/PhiaUI-samples.git
cd PhiaUI-samples
```

### 2. Install dependencies and set up assets

```bash
mix setup
```

This single command runs:
- `mix deps.get` — fetches Elixir dependencies (including `phia_ui ~> 0.1.1`)
- `tailwind.install` / `esbuild.install` — downloads local Tailwind and ESBuild binaries
- `mix compile` — compiles the project
- `tailwind phia_demo` / `esbuild phia_demo` — builds CSS and JS assets

### 3. Start the server

```bash
mix phx.server
```

Or run interactively inside IEx:

```bash
iex -S mix phx.server
```

### 4. Open the app

Navigate to [http://localhost:4000](http://localhost:4000) in your browser.

---

## Project Structure

```
PhiaUI-samples/
├── lib/
│   ├── phia_demo/
│   │   └── fake_data.ex              # Hardcoded demo data (stats, orders, users, revenue…)
│   └── phia_demo_web/
│       ├── components/
│       │   ├── core_components.ex    # Default Phoenix core components (button/table overridden by PhiaUI)
│       │   └── layouts.ex            # Root and app layout templates
│       ├── live/
│       │   ├── components/
│       │   │   └── dashboard_layout.ex  # Reusable sidebar shell component
│       │   └── dashboard_live/
│       │       ├── overview.ex       # / — Visão Geral
│       │       ├── analytics.ex      # /analytics — Analytics
│       │       ├── users.ex          # /users — Usuários
│       │       └── orders.ex         # /orders — Pedidos
│       ├── router.ex                 # Route definitions
│       └── endpoint.ex               # Phoenix endpoint config
├── assets/
│   ├── css/app.css                   # Tailwind entry (includes PhiaUI source path)
│   └── js/app.js                     # JS entry point
├── config/                           # Environment configs (dev, prod, runtime, test)
├── mix.exs                           # Project dependencies and aliases
└── mix.lock
```

### Key Design Decisions

- **`DashboardLayout`** is a shared functional component that wraps every LiveView page. It renders the `<.shell>` with sidebar navigation, avoiding code duplication across pages.
- **`PhiaDemo.FakeData`** centralises all demo data in one place, keeping the LiveView modules focused on rendering logic only.
- **`PhiaDemoWeb` (`phia_demo_web.ex`)** imports all PhiaUI components globally so every LiveView and component can use them without per-file imports.
- Phoenix's **`CoreComponents`** `button/1` and `table/1` are overridden by PhiaUI equivalents via `except:` in the import.

---

## Useful Mix Aliases

| Alias | Description |
|---|---|
| `mix setup` | Full first-time setup: deps + assets |
| `mix phx.server` | Start the development server with live reload |
| `mix assets.build` | Compile Tailwind + ESBuild assets |
| `mix assets.deploy` | Minified production asset build + digest |
| `mix precommit` | Compile (warnings-as-errors) + remove unused deps + format + test |

---

## Development Tips

- The **Tailwind configuration** in `assets/css/app.css` adds `@source "../../deps/phia_ui/lib"` so that PhiaUI component classes are scanned and included in the generated CSS bundle.
- Phoenix **LiveDashboard** is available at [http://localhost:4000/dev/dashboard](http://localhost:4000/dev/dashboard) in development mode.
- Hot reload is enabled in dev — changes to LiveView templates, components, and CSS reflect instantly in the browser.

---

## Learn More

- [PhiaUI on GitHub](https://github.com/charlenopires/phiaui)
- [PhiaUI on Hex.pm](https://hex.pm/packages/phia_ui)
- [Phoenix Framework](https://www.phoenixframework.org/)
- [Phoenix LiveView Guides](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

---

## License

MIT — see [LICENSE](LICENSE) for details.
