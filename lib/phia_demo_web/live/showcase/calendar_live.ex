defmodule PhiaDemoWeb.Demo.Showcase.CalendarLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @today Date.utc_today()
  @week_start Date.beginning_of_week(@today)
  @strip_dates Enum.map(0..6, &Date.add(@today, &1))
  @events [
    %{date: Date.add(@today, 2), label: "Team standup", color: "blue"},
    %{date: Date.add(@today, 5), label: "Deploy v2", color: "green"},
    %{date: Date.add(@today, 10), label: "Deadline", color: "red"},
    %{date: Date.add(@today, 14), label: "Sprint review", color: "purple"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    today = @today

    {:ok,
     socket
     |> assign(:page_title, "Calendar — Showcase")
     # calendar
     |> assign(:cal_month, Date.beginning_of_month(today))
     |> assign(:cal_selected, nil)
     # week_calendar
     |> assign(:week_start, @week_start)
     |> assign(:week_selected, today)
     # range_calendar
     |> assign(:range_year, today.year)
     |> assign(:range_month, today.month)
     |> assign(:range_from, nil)
     |> assign(:range_to, nil)
     # badge_calendar
     |> assign(:badge_year, today.year)
     |> assign(:badge_month, today.month)
     |> assign(:badge_selected, nil)
     # streak_calendar
     |> assign(:streak_year, today.year)
     |> assign(:streak_month, today.month)
     # multi_select_calendar
     |> assign(:ms_year, today.year)
     |> assign(:ms_month, today.month)
     |> assign(:ms_selected, [])
     # big_calendar
     |> assign(:big_year, today.year)
     |> assign(:big_month, today.month)
     |> assign(:big_view, "month")
     # event_calendar
     |> assign(:event_year, today.year)
     |> assign(:event_month, today.month)
     # date_range_presets
     |> assign(:preset_month, Date.beginning_of_month(today))
     |> assign(:active_preset, "last_7_days")
     |> assign(:preset_from, Date.add(today, -7))
     |> assign(:preset_to, today)
     # countdown
     |> assign(:cd_minutes, 14)
     |> assign(:cd_seconds, 32)
     # week_day_picker
     |> assign(:working_days, ["mon", "tue", "wed", "thu", "fri"])}
  end

  # Calendar navigation
  @impl true
  def handle_event("cal-prev", %{"month" => iso}, s), do: {:noreply, assign(s, :cal_month, Date.from_iso8601!(iso))}
  def handle_event("cal-next", %{"month" => iso}, s), do: {:noreply, assign(s, :cal_month, Date.from_iso8601!(iso))}
  def handle_event("calendar-prev-month", %{"month" => iso}, s), do: {:noreply, assign(s, :cal_month, Date.from_iso8601!(iso))}
  def handle_event("calendar-next-month", %{"month" => iso}, s), do: {:noreply, assign(s, :cal_month, Date.from_iso8601!(iso))}
  def handle_event("cal-select", %{"date" => iso}, s), do: {:noreply, assign(s, :cal_selected, Date.from_iso8601!(iso))}

  # WeekCalendar
  def handle_event("week-prev", _, s), do: {:noreply, assign(s, :week_start, Date.add(s.assigns.week_start, -7))}
  def handle_event("week-next", _, s), do: {:noreply, assign(s, :week_start, Date.add(s.assigns.week_start, 7))}
  def handle_event("week-select", %{"date" => iso}, s), do: {:noreply, assign(s, :week_selected, Date.from_iso8601!(iso))}

  # RangeCalendar
  def handle_event("range-select", %{"date" => iso}, s) do
    date = Date.from_iso8601!(iso)
    socket = cond do
      is_nil(s.assigns.range_from) -> assign(s, range_from: date, range_to: nil)
      is_nil(s.assigns.range_to) and Date.compare(date, s.assigns.range_from) != :lt -> assign(s, :range_to, date)
      true -> assign(s, range_from: date, range_to: nil)
    end
    {:noreply, socket}
  end
  def handle_event("range-prev", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, range_year: String.to_integer(y), range_month: String.to_integer(m))}
  def handle_event("range-next", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, range_year: String.to_integer(y), range_month: String.to_integer(m))}

  # BadgeCalendar
  def handle_event("badge-prev", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, badge_year: String.to_integer(y), badge_month: String.to_integer(m))}
  def handle_event("badge-next", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, badge_year: String.to_integer(y), badge_month: String.to_integer(m))}
  def handle_event("badge-select", %{"date" => iso}, s), do: {:noreply, assign(s, :badge_selected, Date.from_iso8601!(iso))}

  # StreakCalendar
  def handle_event("streak-prev", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, streak_year: String.to_integer(y), streak_month: String.to_integer(m))}
  def handle_event("streak-next", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, streak_year: String.to_integer(y), streak_month: String.to_integer(m))}

  # MultiSelectCalendar
  def handle_event("ms-prev", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, ms_year: String.to_integer(y), ms_month: String.to_integer(m))}
  def handle_event("ms-next", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, ms_year: String.to_integer(y), ms_month: String.to_integer(m))}
  def handle_event("ms-select", %{"date" => iso}, s) do
    date = Date.from_iso8601!(iso)
    selected = if date in s.assigns.ms_selected, do: List.delete(s.assigns.ms_selected, date), else: [date | s.assigns.ms_selected]
    {:noreply, assign(s, :ms_selected, selected)}
  end

  # BigCalendar
  def handle_event("big-nav", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, big_year: String.to_integer(y), big_month: String.to_integer(m))}
  def handle_event("big-view", %{"view" => v}, s), do: {:noreply, assign(s, :big_view, v)}

  # EventCalendar
  def handle_event("event-nav", %{"month" => m, "year" => y}, s),
    do: {:noreply, assign(s, event_year: String.to_integer(y), event_month: String.to_integer(m))}

  # DateRangePresets
  def handle_event("preset-select", %{"preset" => preset}, s) do
    today = @today
    {from, to} = case preset do
      "today" -> {today, today}
      "yesterday" -> {Date.add(today, -1), Date.add(today, -1)}
      "last_week" -> {Date.add(today, -7), Date.add(today, -1)}
      "last_7_days" -> {Date.add(today, -7), today}
      "this_month" -> {Date.beginning_of_month(today), today}
      "last_30_days" -> {Date.add(today, -30), today}
      _ -> {s.assigns.preset_from, s.assigns.preset_to}
    end
    {:noreply, assign(s, active_preset: preset, preset_from: from, preset_to: to)}
  end
  def handle_event("preset-change", %{"date" => iso}, s) do
    date = Date.from_iso8601!(iso)
    socket = cond do
      is_nil(s.assigns.preset_from) -> assign(s, preset_from: date, preset_to: nil)
      is_nil(s.assigns.preset_to) and Date.compare(date, s.assigns.preset_from) != :lt -> assign(s, :preset_to, date)
      true -> assign(s, preset_from: date, preset_to: nil)
    end
    {:noreply, assign(socket, :active_preset, "custom")}
  end

  # WeekDayPicker
  def handle_event("weekday-change", %{"days" => days}, s), do: {:noreply, assign(s, :working_days, days)}
  def handle_event("weekday-change", _, s), do: {:noreply, assign(s, :working_days, [])}

  def handle_event(_, _, s), do: {:noreply, s}

  @impl true
  def render(assigns) do
    today = @today
    strip_dates = @strip_dates
    events = @events

    badge_badges = %{
      Date.add(today, 1) => 3,
      Date.add(today, 5) => 7,
      Date.add(today, 10) => 2
    }

    streak_entries = Enum.into(Enum.map(-7..-1, fn i ->
      status = if rem(abs(i), 3) == 0, do: :missed, else: :completed
      {Date.add(today, i), status}
    end), %{})

    booking_avail = %{
      Date.add(today, 5) => :unavailable,
      Date.add(today, 6) => :unavailable,
      Date.add(today, 10) => :check_in_only,
      Date.add(today, 14) => :check_out_only
    }

    booking_prices = %{
      Date.add(today, 1) => "$99",
      Date.add(today, 2) => "$99",
      Date.add(today, 3) => "$120",
      Date.add(today, 7) => "$150"
    }

    assigns =
      assigns
      |> assign(:today, today)
      |> assign(:strip_dates, strip_dates)
      |> assign(:events, events)
      |> assign(:badge_badges, badge_badges)
      |> assign(:streak_entries, streak_entries)
      |> assign(:booking_avail, booking_avail)
      |> assign(:booking_prices, booking_prices)

    ~H"""
    <Layout.layout current_path="/showcase/calendar">
      <div class="p-3 sm:p-4 lg:p-6 space-y-8 max-w-screen-xl mx-auto phia-animate">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Calendar</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Date selection, scheduling, and time components</p>
        </div>

        <%!-- Calendar --%>
        <.demo_section title="Calendar" subtitle="Single-month interactive grid — keyboard navigable with PhiaCalendar hook">
          <div class="flex justify-center">
            <.calendar
              id="showcase-calendar"
              current_month={@cal_month}
              value={@cal_selected}
              on_change="cal-select"
              min={@today}
            />
          </div>
          <p class="text-xs text-muted-foreground mt-3 text-center">
            {if @cal_selected, do: "Selected: #{Calendar.strftime(@cal_selected, "%B %d, %Y")}", else: "Click a date to select"}
          </p>
        </.demo_section>

        <%!-- BigCalendar --%>
        <.demo_section title="BigCalendar" subtitle="Google Calendar-style full-month view with event pills and view switcher">
          <.big_calendar
            year={@big_year}
            month={@big_month}
            view={@big_view}
            events={@events}
            on_navigate="big-nav"
            on_view_change="big-view"
            on_day_click="noop"
            on_event_click="noop"
          />
        </.demo_section>

        <%!-- EventCalendar --%>
        <.demo_section title="EventCalendar" subtitle="Month grid with colored event dot-badges per day">
          <.event_calendar
            year={@event_year}
            month={@event_month}
            events={@events}
            on_navigate="event-nav"
            on_day_click="noop"
            on_event_click="noop"
          />
        </.demo_section>

        <%!-- HeatmapCalendar --%>
        <.demo_section title="HeatmapCalendar" subtitle="GitHub-style contribution grid — intensity 0–4 based on max_value">
          <% heatmap_data = Enum.flat_map(0..51, fn col ->
            Enum.map(0..6, fn row ->
              %{col: col, row: row, value: :rand.uniform(10)}
            end)
          end) %>
          <.heatmap_calendar
            data={heatmap_data}
            rows={7}
            cols={52}
            max_value={10}
            row_labels={~w[Sun Mon Tue Wed Thu Fri Sat]}
            show_legend={true}
          />
        </.demo_section>

        <%!-- WeekCalendar --%>
        <.demo_section title="WeekCalendar" subtitle="Compact 7-day strip with prev/next navigation">
          <.week_calendar
            week_start={@week_start}
            selected_date={@week_selected}
            on_select="week-select"
            on_prev="week-prev"
            on_next="week-next"
          />
          <p class="text-xs text-muted-foreground mt-2 text-center">
            {if @week_selected, do: "Selected: #{Calendar.strftime(@week_selected, "%A, %B %d")}", else: "Click a day"}
          </p>
        </.demo_section>

        <%!-- RangeCalendar --%>
        <.demo_section title="RangeCalendar" subtitle="Two-click range selection with visual band — server-side state">
          <div class="flex justify-center">
            <.range_calendar
              year={@range_year}
              month={@range_month}
              range_start={@range_from}
              range_end={@range_to}
              on_select="range-select"
              on_prev="range-prev"
              on_next="range-next"
            />
          </div>
          <p class="text-xs text-muted-foreground mt-2 text-center">
            {if @range_from, do: "From: #{@range_from}", else: "Click start date"}
            {if @range_to, do: " → To: #{@range_to}", else: if(@range_from, do: " → click end date")}
          </p>
        </.demo_section>

        <%!-- MultiSelectCalendar --%>
        <.demo_section title="MultiSelectCalendar" subtitle="Toggle individual non-contiguous dates — each click adds or removes">
          <div class="flex justify-center">
            <.multi_select_calendar
              year={@ms_year}
              month={@ms_month}
              selected_dates={@ms_selected}
              on_select="ms-select"
              on_prev="ms-prev"
              on_next="ms-next"
            />
          </div>
          <p class="text-xs text-muted-foreground mt-2 text-center">
            {length(@ms_selected)} date(s) selected
          </p>
        </.demo_section>

        <%!-- BadgeCalendar --%>
        <.demo_section title="BadgeCalendar" subtitle="Numeric count badge per day — ideal for task counts or notifications">
          <div class="flex justify-center">
            <.badge_calendar
              year={@badge_year}
              month={@badge_month}
              badges={@badge_badges}
              selected_date={@badge_selected}
              on_select="badge-select"
              on_prev="badge-prev"
              on_next="badge-next"
            />
          </div>
        </.demo_section>

        <%!-- StreakCalendar --%>
        <.demo_section title="StreakCalendar" subtitle="Duolingo-style habit tracker — completed/missed/rest states per day">
          <div class="flex justify-center">
            <.streak_calendar
              year={@streak_year}
              month={@streak_month}
              entries={@streak_entries}
              streak_count={7}
              on_prev="streak-prev"
              on_next="streak-next"
            />
          </div>
        </.demo_section>

        <%!-- BookingCalendar --%>
        <.demo_section title="BookingCalendar" subtitle="Airbnb-style availability calendar with per-cell states and prices">
          <div class="flex justify-center">
            <.booking_calendar
              year={@today.year}
              month={@today.month}
              availability={@booking_avail}
              prices={@booking_prices}
              range_start={nil}
              range_end={nil}
              on_select="noop"
            />
          </div>
        </.demo_section>

        <%!-- DateRangePresets --%>
        <.demo_section title="DateRangePresets" subtitle="Preset shortcuts (Today, Last 7 days…) + calendar custom range">
          <.date_range_presets
            id="showcase-presets"
            current_month={@preset_month}
            active_preset={@active_preset}
            from={@preset_from}
            to={@preset_to}
            on_preset="preset-select"
            on_change="preset-change"
            on_cancel="noop"
            on_confirm="noop"
          />
        </.demo_section>

        <%!-- ScheduleEventCard --%>
        <.demo_section title="ScheduleEventCard" subtitle="Event card with colored left border, date, time range, category badge">
          <div class="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            <.schedule_event_card
              title="Team Standup"
              category={:meeting}
              date="2026 / MAR / 10"
              time_range="09:00 AM - 09:30 AM"
              avatars={["Alice", "Bob", "Carol"]}
            />
            <.schedule_event_card
              title="Design Sprint"
              category={:event}
              date="2026 / MAR / 12"
              time_range="10:00 AM - 12:00 PM"
              avatars={["David", "Elena"]}
            />
            <.schedule_event_card
              title="Annual Leave"
              category={:leave}
              date="2026 / MAR / 15"
            />
            <.schedule_event_card
              title="Deploy v2"
              category={:default}
              date="2026 / MAR / 20"
              time_range="3:00 PM - 4:00 PM"
            />
          </div>
        </.demo_section>

        <%!-- DateCard + DateStrip --%>
        <.demo_section title="DateCard & DateStrip" subtitle="Individual selectable day card and horizontal scrollable strip">
          <div class="space-y-6">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-3">DateCard — individual sizes</p>
              <div class="flex flex-wrap gap-3">
                <.date_card date={@today} today={true} selected={true} size={:default} />
                <.date_card date={Date.add(@today, 1)} today={false} selected={false} size={:default} />
                <.date_card date={Date.add(@today, 2)} today={false} selected={false} size={:sm} />
                <.date_card date={Date.add(@today, 3)} disabled={true} size={:default} />
              </div>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-3">DateStrip — scrollable week</p>
              <.date_strip
                dates={@strip_dates}
                selected_date={@today}
                today={@today}
                size={:default}
                scrollable={true}
              />
            </div>
          </div>
        </.demo_section>

        <%!-- CountdownTimer --%>
        <.demo_section title="CountdownTimer" subtitle="SVG arc ring (circular) and flat card variants — zero JS, server-driven">
          <div class="flex flex-wrap gap-8 items-start">
            <div class="flex flex-col items-center gap-2">
              <.countdown_timer
                minutes={@cd_minutes}
                seconds={@cd_seconds}
                total_seconds={900}
                label="15 min"
              />
              <p class="text-xs text-muted-foreground">Circular (default)</p>
            </div>
            <div class="flex flex-col items-center gap-2 flex-1 min-w-64">
              <.countdown_timer
                minutes={@cd_minutes}
                seconds={@cd_seconds}
                total_seconds={900}
                variant={:flat}
                label="15 min"
                on_pause="noop"
                on_stop="noop"
              />
              <p class="text-xs text-muted-foreground">Flat with actions</p>
            </div>
          </div>
        </.demo_section>

        <%!-- TimePicker, DateField, DateTimePicker, MonthPicker, YearPicker, WeekPicker --%>
        <.demo_section title="TimePicker, DateField, DateTimePicker, MonthPicker, YearPicker, WeekPicker" subtitle="Styled native HTML inputs — zero JS, accessible, works in any context">
          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <.time_picker id="tp-start" name="start_time" label="Start Time" value="09:00" />
            <.date_field id="df-due" name="due_date" label="Due Date" min={Date.to_iso8601(@today)} />
            <.date_time_picker id="dtp-meeting" name="meeting_at" label="Meeting Date & Time" />
            <.month_picker id="mp-billing" name="billing_month" label="Billing Month" value={Calendar.strftime(@today, "%Y-%m")} />
            <.year_picker id="yp-event" name="event_year" label="Event Year" value={@today.year} min_year={2020} max_year={2030} />
            <.week_picker id="wp-sprint" name="sprint_week" label="Sprint Week" />
          </div>
        </.demo_section>

        <%!-- WeekDayPicker --%>
        <.demo_section title="WeekDayPicker" subtitle="Compact day-of-week selector — single or multiple mode, locale-aware">
          <div class="space-y-4">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Multiple (working days)</p>
              <.week_day_picker
                id="wdp-working"
                name="working_days"
                mode={:multiple}
                value={@working_days}
                on_change="weekday-change"
              />
              <p class="text-xs text-muted-foreground mt-2">Selected: {Enum.join(@working_days, ", ")}</p>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Single (read-only)</p>
              <.week_day_picker id="wdp-single" name="recurring_day" mode={:single} value={["mon"]} locale="en-US" />
            </div>
          </div>
        </.demo_section>

        <%!-- DailyAgenda --%>
        <.demo_section title="DailyAgenda" subtitle="Day view with time slots and event blocks">
          <.daily_agenda
            date={Date.utc_today()}
            events={[
              %{id: "1", title: "Team Standup", start_time: ~T[09:00:00], end_time: ~T[09:30:00], color: :blue},
              %{id: "2", title: "Design Review", start_time: ~T[11:00:00], end_time: ~T[12:00:00], color: :purple},
              %{id: "3", title: "Lunch Break", start_time: ~T[12:00:00], end_time: ~T[13:00:00], color: :green},
              %{id: "4", title: "Sprint Planning", start_time: ~T[14:00:00], end_time: ~T[15:30:00], color: :orange}
            ]}
          />
        </.demo_section>

        <%!-- MultiMonthCalendar --%>
        <.demo_section title="MultiMonthCalendar" subtitle="Side-by-side month panels — great for date range selection">
          <.multi_month_calendar year={Date.utc_today().year} month={Date.utc_today().month} months_count={3} />
        </.demo_section>

        <%!-- WheelPicker --%>
        <.demo_section title="WheelPicker" subtitle="iOS-style scroll wheel selector — for time, date, or custom values">
          <.wheel_picker
            columns={[
              %{name: "hours", items: Enum.map(1..12, &%{value: "#{&1}", label: "#{&1}"}), selected: "9"},
              %{name: "minutes", items: Enum.map(0..59//5, &%{value: "#{&1}", label: String.pad_leading("#{&1}", 2, "0")}), selected: "30"},
              %{name: "ampm", items: [%{value: "AM", label: "AM"}, %{value: "PM", label: "PM"}], selected: "AM"}
            ]}
          />
        </.demo_section>

      </div>
    </Layout.layout>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, required: true
  slot :inner_block, required: true

  defp demo_section(assigns) do
    ~H"""
    <div class="space-y-4">
      <div>
        <h2 class="text-base font-semibold text-foreground">{@title}</h2>
        <p class="text-xs text-muted-foreground mt-0.5">{@subtitle}</p>
      </div>
      <div class="rounded-xl border border-border/60 bg-card p-3 sm:p-5 shadow-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
