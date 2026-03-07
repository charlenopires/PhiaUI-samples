defmodule PhiaDemoWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use PhiaDemoWeb, :controller
      use PhiaDemoWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images icons favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components — exclude functions overridden by PhiaUI
      import PhiaDemoWeb.CoreComponents, except: [button: 1, table: 1, icon: 1]

      # PhiaUI — Icon (Lucide sprites, overrides CoreComponents.icon)
      import PhiaUi.Components.Icon

      # PhiaUI — Dashboard & Layout
      import PhiaUi.Components.Shell
      import PhiaUi.Components.StatCard
      import PhiaUi.Components.MetricGrid
      import PhiaUi.Components.ChartShell
      import PhiaUi.Components.Card

      # PhiaUI — Primitives
      import PhiaUi.Components.Badge
      import PhiaUi.Components.Button
      import PhiaUi.Components.ButtonGroup
      import PhiaUi.Components.Alert
      import PhiaUi.Components.Skeleton
      import PhiaUi.Components.Breadcrumb
      import PhiaUi.Components.Avatar

      # PhiaUI — Data Display
      import PhiaUi.Components.Table
      import PhiaUi.Components.Pagination
      import PhiaUi.Components.EmptyState
      import PhiaUi.Components.Accordion

      # PhiaUI — Form Inputs
      import PhiaUi.Components.TagsInput
      import PhiaUi.Components.DateRangePicker
      import PhiaUi.Components.Switch
      import PhiaUi.Components.Slider
      import PhiaUi.Components.Rating
      import PhiaUi.Components.SegmentedControl
      import PhiaUi.Components.InputOtp
      import PhiaUi.Components.NumberInput
      import PhiaUi.Components.PasswordInput
      import PhiaUi.Components.ColorPicker
      import PhiaUi.Components.Chip
      import PhiaUi.Components.MultiSelect
      import PhiaUi.Components.Checkbox
      import PhiaUi.Components.RadioGroup
      import PhiaUi.Components.InputAddon

      # PhiaUI — Buttons
      import PhiaUi.Components.Toggle
      import PhiaUi.Components.ToggleGroup
      import PhiaUi.Components.CopyButton

      # PhiaUI — Interactive
      import PhiaUi.Components.Tooltip
      import PhiaUi.Components.Dialog
      import PhiaUi.Components.AlertDialog
      import PhiaUi.Components.DropdownMenu
      import PhiaUi.Components.Collapsible
      import PhiaUi.Components.Popover
      import PhiaUi.Components.ContextMenu
      import PhiaUi.Components.Carousel
      import PhiaUi.Components.Drawer
      import PhiaUi.Components.Sheet
      import PhiaUi.Components.Combobox
      import PhiaUi.Components.HoverCard
      import PhiaUi.Components.Snackbar
      import PhiaUi.Components.FloatButton
      import PhiaUi.Components.BackTop
      import PhiaUi.Components.FileUpload
      import PhiaUi.Components.DatePicker
      import PhiaUi.Components.Command

      # PhiaUI — Feedback
      import PhiaUi.Components.Spinner
      import PhiaUi.Components.CircularProgress
      import PhiaUi.Components.StepTracker
      import PhiaUi.Components.Progress

      # PhiaUI — Display
      import PhiaUi.Components.Timeline
      import PhiaUi.Components.ActivityFeed
      import PhiaUi.Components.AvatarGroup
      import PhiaUi.Components.Kbd
      import PhiaUi.Components.Direction

      # PhiaUI — Navigation
      import PhiaUi.Components.Tabs
      import PhiaUi.Components.TabsNav
      import PhiaUi.Components.Separator

      # PhiaUI — Data
      import PhiaUi.Components.Tree
      import PhiaUi.Components.BulkActionBar
      import PhiaUi.Components.SparklineCard
      import PhiaUi.Components.GaugeChart
      import PhiaUi.Components.UptimeBar

      # PhiaUI — Cards
      import PhiaUi.Components.SelectableCard
      import PhiaUi.Components.ReceiptCard

      # PhiaUI — Media
      import PhiaUi.Components.QrCode

      # PhiaUI — Utilities
      import PhiaUi.Components.Toast
      import PhiaUi.Components.DarkModeToggle
      import PhiaUi.Components.Sonner

      # PhiaUI — Additional Inputs
      import PhiaUi.Components.ImageUpload

      # PhiaUI — Layout
      import PhiaUi.Components.ScrollArea
      import PhiaUi.Components.AspectRatio
      import PhiaUi.Components.Resizable

      # PhiaUI — Data
      import PhiaUi.Components.FilterBar
      import PhiaUi.Components.DataGrid

      # PhiaUI — Calendar
      import PhiaUi.Components.Calendar
      import PhiaUi.Components.BigCalendar
      import PhiaUi.Components.HeatmapCalendar
      import PhiaUi.Components.CountdownTimer
      import PhiaUi.Components.TimePicker
      import PhiaUi.Components.DateCard
      import PhiaUi.Components.DateStrip
      import PhiaUi.Components.WeekCalendar
      import PhiaUi.Components.MonthPicker
      import PhiaUi.Components.YearPicker
      import PhiaUi.Components.WeekPicker
      import PhiaUi.Components.RangeCalendar
      import PhiaUi.Components.BadgeCalendar
      import PhiaUi.Components.StreakCalendar
      import PhiaUi.Components.BookingCalendar
      import PhiaUi.Components.DateRangePresets
      import PhiaUi.Components.EventCalendar
      import PhiaUi.Components.ScheduleEventCard
      import PhiaUi.Components.MultiSelectCalendar
      import PhiaUi.Components.WeekDayPicker
      import PhiaUi.Components.DateField
      import PhiaUi.Components.DateTimePicker

      # Common modules used in templates
      alias Phoenix.LiveView.JS
      alias PhiaDemoWeb.Layouts

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: PhiaDemoWeb.Endpoint,
        router: PhiaDemoWeb.Router,
        statics: PhiaDemoWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
