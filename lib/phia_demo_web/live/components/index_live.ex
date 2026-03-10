defmodule PhiaDemoWeb.Demo.Components.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Components.Layout

  @categories [
    %{name: "Inputs", href: "/components/inputs", icon: "keyboard", count: 42,
      description: "Button, ButtonGroup, FancyButton, IconButton, SocialButton, Switch, Slider, Rating, Toggle, Chip, PasswordInput, ColorPicker, OTP, InputAddon, MultiSelect, Combobox, Checkbox, RadioGroup, DatePicker, TagsInput, FileUpload, CopyButton, AutocompleteInput, MentionInput, PhoneInput, SearchInput, CopyInput, ClearableInput, Editable, InputGroup, UrlInput, UnitInput, TextareaCounter, InlineSearch e mais"},
    %{name: "Display", href: "/components/display", icon: "eye", count: 38,
      description: "Badge, Separator, Kbd, Tabs, TabsNav, Avatar, AvatarGroup, Card, SelectableCard, Timeline, ActivityFeed, Breadcrumb, Accordion, Skeleton, Table, Pagination, EmptyState, Icon, Tree, Direction, QrCode, ScrollArea, AspectRatio, ChatMessage, Typography, CodeSnippet, Article e mais"},
    %{name: "Feedback", href: "/components/feedback", icon: "bell", count: 32,
      description: "Spinner, Progress, ProgressEnhanced, CircularProgress, StepTracker, Alert, Toast, Snackbar, Sheet, Dialog, AlertDialog, Drawer, Command, HoverCard, Tooltip, Popover, DropdownMenu, ContextMenu, Carousel, BackTop, FloatButton, DarkModeToggle, Sonner, Banner, Notification, ErrorDisplay, StatusIndicator, Popconfirm, LoadingOverlay, FeedbackWidget, ResultState, GlobalMessage"},
    %{name: "Data & Charts", href: "/components/charts", icon: "chart-bar", count: 52,
      description: "ECharts (Line, Area, Bar, Pie, Donut, Scatter, Funnel, Heatmap, Treemap, Waterfall, Histogram), StatCard, MetricGrid, SparklineCard, GaugeChart, UptimeBar, FilterBar, DataGrid, Resizable, BarList, CategoryBar, BadgeDelta, BulletChart, MeterGroup, Leaderboard, Tracker e mais"},
    %{name: "Calendar", href: "/components/calendar", icon: "calendar", count: 28,
      description: "Calendar, BigCalendar, EventCalendar, HeatmapCalendar, WeekCalendar, RangeCalendar, MultiSelectCalendar, BadgeCalendar, StreakCalendar, BookingCalendar, DateRangePresets, DateCard, DateStrip, CountdownTimer, TimePicker, DateField, DateTimePicker, MonthPicker, YearPicker, WeekPicker, WeekDayPicker, DailyAgenda, MultiMonthCalendar, WheelPicker e mais"},
    %{name: "Cards", href: "/components/cards", icon: "layers", count: 31,
      description: "Card, SelectableCard, ReceiptCard, ProfileCard, FeatureCard, ArticleCard, CtaCard, EventCard, ImageCard, PricingCard, ProductCard, ProgressCard, TestimonialCard, TeamCard, NotificationCard, StatCard, SparklineCard, MetricGrid, ColorSwatchCard, FileCard, LinkPreviewCard — all card variants"},
    %{name: "Navigation", href: "/components/navigation", icon: "list", count: 28,
      description: "Breadcrumb, Tabs, TabsNav, Separator, Pagination, StepTracker, Accordion, Kbd, CommandPalette, MegaMenu, FloatingNav, SpeedDial, Dock, NavRail, Topbar, VerticalNav, BottomNavigation, StepperNav, Toolbar, ChipNav, DotNavigation, LinkGroup, Toc e mais"},
    %{name: "Tables", href: "/components/tables", icon: "list-ordered", count: 24,
      description: "Table, DataGrid, DataTable, FilterBar, Tree, TreeEnhanced, BulkActionBar, ExpandableTable, ResponsiveTable, ComparisonTable, InlineEditTable, TimelineTable, KanbanBoard, PivotTable, TableGroup — sortable, filterable, expandable tables"},
    %{name: "Upload", href: "/components/upload", icon: "upload", count: 10,
      description: "ImageUpload, FileUpload, CopyButton, DropZone, DocumentUpload, AvatarUpload — all file upload patterns including drag-and-drop and progress indicators"},
    %{name: "Media", href: "/components/media", icon: "image", count: 12,
      description: "Carousel, QrCode, AspectRatio, ScrollArea, Resizable, Direction, AudioPlayer, ImageComparison, Watermark, Lightbox, VideoPlayer — media display and layout utilities"},
    %{name: "Animation", href: "/components/animation", icon: "sparkles", count: 22,
      description: "marquee, orbit, aurora, meteor_shower, shimmer_text, typewriter, word_rotate, text_scramble, fade_in, float, spotlight, tilt_card, number_ticker, typing_indicator, wave_loader, animated_border, pulse_ring, confetti_burst, particle_bg e mais"},
    %{name: "Visual Effects", href: "/components/visual", icon: "eye", count: 20,
      description: "gradient_mesh, retro_grid, wave_bg, hex_pattern, bokeh_bg, flicker_grid, flowing_lines, beam_bg — plus glass_card, glass_panel, acrylic_surface, liquid_glass, neon_glow_card, border_beam, shine_border, magic_card, card_spotlight, moving_border"},
    %{name: "Layout", href: "/components/layout", icon: "layout-grid", count: 22,
      description: "Stack, Flex, Grid, SimpleGrid, Center, Container, Wrap, Spacer, DescriptionList, PageHeader, Section, MediaObject, SplitLayout, ResponsiveStack, MasonryGrid, ContainerQuery, Box, Cover, Divider, FixedBar, Sticky, ResponsiveVisibility"},
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Components")}
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :categories, @categories)

    ~H"""
    <Layout.layout current_path="/components">
      <div class="p-4 md:p-6 space-y-8 max-w-screen-xl mx-auto phia-animate">

        <%!-- Hero --%>
        <div class="text-center space-y-3 py-8">
          <div class="inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/10 mb-2">
            <.icon name="puzzle" class="text-primary" />
          </div>
          <h1 class="text-3xl font-bold text-foreground tracking-tight">Components</h1>
          <p class="text-muted-foreground text-lg max-w-xl mx-auto">
            Every PhiaUI component — live demos, fully interactive, dark-mode ready.
          </p>
          <div class="flex flex-wrap items-center justify-center gap-2 text-sm text-muted-foreground">
            <.badge variant={:secondary}>v0.1.16</.badge>
            <span>·</span>
            <span>623 components</span>
            <span>·</span>
            <span>13 categories</span>
          </div>
        </div>

        <%!-- Category Cards --%>
        <div class="grid gap-4 md:gap-6 sm:grid-cols-2">
          <%= for cat <- @categories do %>
            <a href={cat.href} class="group block rounded-xl border border-border/60 bg-card p-4 md:p-6 shadow-sm hover:shadow-md hover:border-primary/30 transition-all duration-200">
              <div class="flex items-start gap-4">
                <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-primary/10 group-hover:bg-primary/15 transition-colors">
                  <.icon name={cat.icon} class="text-primary" />
                </div>
                <div class="flex-1 min-w-0">
                  <div class="flex flex-wrap items-center gap-2">
                    <h2 class="text-lg font-semibold text-foreground group-hover:text-primary transition-colors">{cat.name}</h2>
                    <.badge variant={:outline} class="text-xs shrink-0">{cat.count} components</.badge>
                  </div>
                  <p class="text-sm text-muted-foreground mt-1">{cat.description}</p>
                </div>
                <.icon name="arrow-right" size={:sm} class="shrink-0 text-muted-foreground/50 group-hover:text-primary group-hover:translate-x-1 transition-all mt-0.5" />
              </div>
            </a>
          <% end %>
        </div>

        <%!-- Quick info --%>
        <.card class="border-border/60 border-dashed">
          <.card_content class="p-6">
            <div class="flex items-start gap-4">
              <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-primary/10">
                <.icon name="info" size={:sm} class="text-primary" />
              </div>
              <div>
                <h3 class="font-semibold text-foreground mb-1">About PhiaUI</h3>
                <p class="text-sm text-muted-foreground">
                  PhiaUI is a Phoenix LiveView component library built on Tailwind CSS v4 and Lucide icons.
                  Components are fully server-rendered with minimal JavaScript — only progressive enhancement hooks.
                  Dark mode is handled via CSS custom properties and the <code class="font-mono bg-muted px-1 rounded text-xs">.dark</code> class.
                </p>
              </div>
            </div>
          </.card_content>
        </.card>

      </div>
    </Layout.layout>
    """
  end
end
