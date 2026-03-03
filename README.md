# PhiaUI Samples

> A real-world dashboard demo showcasing the [PhiaUI](https://hex.pm/packages/phia_ui) component library for **Phoenix LiveView**.

---

## Overview

This repository contains a fully functional **admin dashboard** built with Elixir, Phoenix 1.8, Phoenix LiveView 1.1, and Tailwind CSS — demonstrating **26+ PhiaUI components** in a production-like application.

```
┌─────────────────────────────────────────────────────┐
│  PhiaUI Demo                           🌙  👤 Admin │
├──────────────┬──────────────────────────────────────┤
│ ⎕ Visão Geral│  Dashboard / Visão Geral             │
│ ⎕ Analytics  │                                      │
│ ⎕ Usuários   │  ┌────┐ ┌────┐ ┌────┐ ┌────┐        │
│ ⎕ Pedidos    │  │KPI │ │KPI │ │KPI │ │KPI │        │
│              │  └────┘ └────┘ └────┘ └────┘        │
│              │                                      │
│              │  ┌──────────── Bar Chart ──────────┐ │
│              │  └────────────────────────────────┘ │
│──────────────│                                      │
│ ⚙ Config    │  ┌── Table ──┐  ┌── Products ──┐    │
└──────────────┴──────────────────────────────────────┘
```

The app features four interactive LiveView pages:

| Route | Module | Description |
|---|---|---|
| `/` | `DashboardLive.Overview` | KPI cards, bar chart, orders table, top products, skeleton demo, accordion activity log |
| `/analytics` | `DashboardLive.Analytics` | Traffic metrics, area chart, donut chart, collapsible filters, empty state |
| `/users` | `DashboardLive.Users` | User table with avatars, dropdown actions, dialog form, confirm delete, pagination, toast |
| `/orders` | `DashboardLive.Orders` | Order listing with tooltip badges, button group export, collapsible filters, pagination |

---

## PhiaUI Components Demonstrated

| Component | Module | Pages |
|---|---|---|
| `<.shell>` / `<.sidebar>` / `<.sidebar_item>` / `<.mobile_sidebar_toggle>` | Shell | Todas |
| `<.stat_card>` / `<.metric_grid>` | StatCard / MetricGrid | Todas |
| `<.chart_shell>` (+ SVG inline) | ChartShell | Overview, Analytics |
| `<.card>` / `<.card_header>` / `<.card_title>` / `<.card_description>` / `<.card_content>` / `<.card_footer>` | Card | Todas |
| `<.badge>` | Badge | Todas |
| `<.button>` | Button | Todas |
| `<.table>` / `<.table_header>` / `<.table_body>` / `<.table_row>` / `<.table_head>` / `<.table_cell>` | Table | Overview, Users, Orders |
| `<.alert>` / `<.alert_title>` / `<.alert_description>` | Alert | Analytics, Users |
| `<.icon>` (Lucide sprites) | Icon | Layout |
| `<.skeleton>` / `<.skeleton_text>` | Skeleton | Overview |
| `<.breadcrumb>` / `<.breadcrumb_list>` / `<.breadcrumb_item>` / `<.breadcrumb_link>` / `<.breadcrumb_page>` / `<.breadcrumb_separator>` | Breadcrumb | Todas |
| `<.accordion>` / `<.accordion_item>` / `<.accordion_trigger>` / `<.accordion_content>` | Accordion | Overview (activity log) |
| `<.collapsible>` / `<.collapsible_trigger>` / `<.collapsible_content>` | Collapsible | Analytics (filters), Orders (filters) |
| `<.pagination>` / `<.pagination_content>` / `<.pagination_item>` / `<.pagination_link>` / `<.pagination_previous>` / `<.pagination_next>` | Pagination | Users, Orders |
| `<.dark_mode_toggle>` | DarkModeToggle | Layout (topbar) |
| `<.tooltip>` / `<.tooltip_trigger>` / `<.tooltip_content>` | Tooltip | Layout (sidebar), Orders (badges) |
| `<.avatar>` / `<.avatar_fallback>` | Avatar | Layout (topbar), Users (table) |
| `<.dialog>` / `<.dialog_trigger>` / `<.dialog_content>` / `<.dialog_header>` / `<.dialog_title>` / `<.dialog_description>` / `<.dialog_footer>` / `<.dialog_close>` | Dialog | Users (new user form) |
| `<.alert_dialog>` / `<.alert_dialog_header>` / `<.alert_dialog_title>` / `<.alert_dialog_description>` / `<.alert_dialog_footer>` / `<.alert_dialog_action>` / `<.alert_dialog_cancel>` | AlertDialog | Users (confirm delete) |
| `<.dropdown_menu>` / `<.dropdown_menu_trigger>` / `<.dropdown_menu_content>` / `<.dropdown_menu_item>` / `<.dropdown_menu_label>` / `<.dropdown_menu_separator>` / `<.dropdown_menu_group>` | DropdownMenu | Users (row actions) |
| `<.toast>` (push_event) | Toast | Users (delete confirmation) |
| `<.button_group>` | ButtonGroup | Orders (export buttons) |
| `<.empty>` | EmptyState | Analytics (canal data) |

**Total: 30+ PhiaUI components and sub-components demonstrated**

---

## Prerequisites

- **Elixir** `~> 1.15`
- **Erlang/OTP** 26+
- **Node.js** (for initial asset compilation — one-time only)
- **Mix** (bundled with Elixir)

> PhiaUI `~> 0.1.2` is fetched automatically from [Hex.pm](https://hex.pm/packages/phia_ui).

---

## Getting Started

### 1. Clone

```bash
git clone https://github.com/charlenopires/PhiaUI-samples.git
cd PhiaUI-samples
```

### 2. Install dependencies and build assets

```bash
mix setup
```

This runs:
- `mix deps.get` — fetches Elixir deps (including `phia_ui ~> 0.1.2`)
- `tailwind.install` / `esbuild.install` — downloads local binaries
- `mix compile` — compiles the project
- `tailwind phia_demo` / `esbuild phia_demo` — builds CSS and JS

### 3. Start the server

```bash
mix phx.server
```

Or with IEx:

```bash
iex -S mix phx.server
```

### 4. Open the app

Navigate to [http://localhost:4000](http://localhost:4000)

---

## Project Structure

```
PhiaUI-samples/
├── assets/
│   ├── css/app.css                     # Tailwind entry — PhiaUI theme inline, @source for class scanning
│   └── js/
│       ├── app.js                      # LiveSocket registration with PhiaHooks
│       └── phia_hooks/
│           ├── index.js                # Exports all PhiaUI JS hooks
│           ├── dialog.js               # PhiaDialog — focus trap, scroll lock, keyboard
│           ├── dropdown_menu.js        # PhiaDropdownMenu — positioning, click-outside, keyboard nav
│           ├── tooltip.js              # PhiaTooltip — smart positioning, delay, viewport flip
│           ├── dark_mode.js            # PhiaDarkMode — .dark class toggle, localStorage
│           └── toast.js               # PhiaToast — dynamic DOM creation, auto-dismiss
├── lib/
│   ├── phia_demo/
│   │   └── fake_data.ex               # All hardcoded demo data
│   └── phia_demo_web/
│       ├── components/
│       │   ├── core_components.ex     # Phoenix defaults (button/table overridden by PhiaUI)
│       │   └── layouts/
│       │       ├── root.html.heex     # HTML skeleton + anti-FOUC script + toast viewport
│       │       └── app.html.heex      # App layout (passthrough)
│       ├── live/
│       │   ├── components/
│       │   │   └── dashboard_layout.ex  # Shared shell with dark mode toggle + sidebar tooltips
│       │   └── dashboard_live/
│       │       ├── overview.ex        # / — KPIs, chart, skeleton, accordion
│       │       ├── analytics.ex       # /analytics — traffic metrics, collapsible, empty state
│       │       ├── users.ex           # /users — dialog, dropdown, pagination, toast
│       │       └── orders.ex          # /orders — button group, tooltip, collapsible, pagination
│       ├── phia_demo_web.ex           # Global PhiaUI imports
│       └── router.ex                  # 4 live routes
├── mix.exs                            # {:phia_ui, "~> 0.1.2"}
└── mix.lock
```

---

## Architecture Decisions

### PhiaUI as a Hex Dependency

PhiaUI is consumed as a standard Hex dependency (`{:phia_ui, "~> 0.1.2"}`). This means:

- **`@source "../../deps/phia_ui/lib"`** in `app.css` — correct for Tailwind class scanning at build time.
- **`@import "../../../deps/phia_ui/priv/static/theme.css"` is PROHIBITED** — relative paths only work in local development, not in production builds. The theme CSS is inlined directly in `app.css`.

### JS Hooks Registration

PhiaUI interactive components require JavaScript hooks (PhiaDialog, PhiaDropdownMenu, PhiaTooltip, PhiaDarkMode, PhiaToast). These are stored in `assets/js/phia_hooks/` and registered via:

```js
// app.js
hooks: {...PhiaHooks, ...colocatedHooks}
```

### Global Component Imports

All PhiaUI components are imported globally in `phia_demo_web.ex` so every LiveView can use them without per-file imports. Exception: `PhiaUi.Components.Icon` is NOT imported globally because it conflicts with `CoreComponents.icon` (used by `flash_group`). It is imported locally only in `DashboardLayout`.

### CoreComponents Overrides

Phoenix's default `button/1` and `table/1` from `CoreComponents` are excluded:

```elixir
import PhiaDemoWeb.CoreComponents, except: [button: 1, table: 1]
```

PhiaUI's `Button` and `Table` components take their place.

### Dark Mode

PhiaDarkMode hook toggles the `.dark` CSS class on `<html>` and persists to `localStorage['phia-theme']`. An anti-FOUC inline script in `root.html.heex` reads the preference before any stylesheet loads, preventing the theme flash on page load.

### Toast Notifications

The `<.toast id="phia-toast-viewport" />` is placed once in `root.html.heex`. Server-side LiveViews trigger toasts via `push_event/3`:

```elixir
push_event(socket, "phia-toast", %{
  title: "Usuário removido",
  description: "O usuário foi desativado com sucesso.",
  variant: "destructive",
  duration_ms: 4000
})
```

---

## Useful Mix Aliases

| Alias | Description |
|---|---|
| `mix setup` | First-time setup: deps + assets |
| `mix phx.server` | Start dev server with live reload |
| `mix assets.build` | Compile Tailwind + ESBuild |
| `mix assets.deploy` | Minified production build + digest |
| `mix precommit` | Compile (warnings-as-errors) + unused deps + format + test |

---

## Learn More

- [PhiaUI on Hex.pm](https://hex.pm/packages/phia_ui)
- [Phoenix Framework](https://www.phoenixframework.org/)
- [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Tailwind CSS v4](https://tailwindcss.com/docs)

---

## License

MIT — see [LICENSE](LICENSE) for details.
