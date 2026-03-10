---
title: "~90 New Components in PhiaUI v0.1.15"
slug: new-components-v015
date: 2026-03-10
summary: "PhiaUI v0.1.15 brings ~90 new components spanning calendars, cards, data visualization, inputs, navigation, and layout — pushing the total to 623."
tags: release,components
icon: puzzle
---

## PhiaUI v0.1.15 — The Biggest Update Yet

We're excited to announce **PhiaUI v0.1.15**, our largest release to date. This update adds approximately **90 new components** across multiple categories, bringing the total component count to **623**.

### Calendar & Date Components

The calendar family got a major expansion:

- **DailyAgenda** — a day-view with time slots and event blocks
- **MultiMonthCalendar** — side-by-side month grids for range selection
- **WheelPicker** — iOS-style scrolling date/time picker

These join the existing 25+ calendar components including `BigCalendar`, `EventCalendar`, `HeatmapCalendar`, and `BookingCalendar`.

### New Card Variants

Cards are one of the most-used UI patterns, so we added:

- **ColorSwatchCard** — displays color palettes with copy-to-clipboard
- **FileCard** — file preview with type icon, size, and actions
- **LinkPreviewCard** — unfurls URLs with title, description, and thumbnail

### Data Visualization

Beyond our ECharts integration (line, area, bar, pie), we now offer pure-component data displays:

- **BarList** — horizontal bar chart with labels and values
- **CategoryBar** — segmented bar showing category proportions
- **BadgeDelta** — compact change indicator (up/down/neutral)
- **BulletChart** — comparative measure against a target
- **MeterGroup** — multiple meters in a stacked layout
- **Leaderboard** — ranked list with avatars and scores
- **Tracker** — uptime-style status grid

### Input Enhancements

- **UrlInput** — URL field with protocol prefix and validation
- **UnitInput** — number input with unit suffix (px, %, rem, etc.)
- **TextareaCounter** — textarea with live character count
- **InlineSearch** — search bar that expands inline on focus

### Display Components

- **ChatMessage** — chat bubble system with `chat_container`, `chat_bubble`, `chat_suggestions`, and `chat_input`
- **Typography** — full text system with `heading`, `display`, `paragraph`, `lead`, `blockquote`, `code_block`, `gradient_text`, and more
- **CodeSnippet** — syntax-highlighted code block with copy button
- **Article** — long-form content wrapper with prose styling

### Navigation

- **ChipNav** — horizontal chip-style tab navigation
- **DotNavigation** — minimal dot indicators for carousels/sections
- **LinkGroup** — grouped links with optional descriptions
- **Toc** — table of contents with scroll-spy highlighting

### Layout System

A brand-new layout toolkit:

- **Stack, Flex, Grid, SimpleGrid** — fundamental layout primitives
- **Center, Container, Wrap, Spacer** — alignment and spacing helpers
- **DescriptionList** — key-value display for metadata
- **PageHeader** — page title with breadcrumbs and actions
- **Section** — semantic content sections with dividers
- **MediaObject** — image + content side-by-side pattern
- **SplitLayout** — two-panel resizable layout
- **ResponsiveStack** — stack that switches direction at breakpoints

### Upgrade Guide

Update your `mix.exs`:

```elixir
{:phia_ui, "~> 0.1.15"}
```

Then run:

```bash
mix deps.get
mix tailwind phia_demo
```

All new components are fully compatible with the existing theme system and dark mode. No breaking changes.
