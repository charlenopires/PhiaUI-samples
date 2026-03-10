defmodule PhiaDemoWeb.Demo.Components.InputsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Components.Layout

  @fruit_options [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"},
    %{value: "grape", label: "Grape"},
    %{value: "kiwi", label: "Kiwi"},
    %{value: "mango", label: "Mango"},
    %{value: "orange", label: "Orange"},
    %{value: "pear", label: "Pear"},
    %{value: "strawberry", label: "Strawberry"},
    %{value: "watermelon", label: "Watermelon"}
  ]

  @country_options [
    %{value: "br", label: "Brazil"},
    %{value: "us", label: "United States"},
    %{value: "de", label: "Germany"},
    %{value: "jp", label: "Japan"},
    %{value: "fr", label: "France"}
  ]

  @multi_options [
    {"Elixir", "elixir"},
    {"Phoenix", "phoenix"},
    {"LiveView", "liveview"},
    {"Tailwind", "tailwind"},
    {"Rust", "rust"},
    {"TypeScript", "typescript"}
  ]

  @seg_options [
    %{value: "day", label: "Day"},
    %{value: "week", label: "Week"},
    %{value: "month", label: "Month"},
    %{value: "year", label: "Year"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Inputs — Showcase")
     |> assign(:fruit_value, "apple")
     |> assign(:fruit_open, false)
     |> assign(:fruit_search, "")
     |> assign(:country_value, "br")
     |> assign(:country_open, false)
     |> assign(:country_search, "")
     |> assign(:tags, ["phoenix", "liveview"])
     |> assign(:date_range, nil)
     |> assign(:view_month, Date.utc_today() |> Date.beginning_of_month())
     |> assign(:date_from, nil)
     |> assign(:date_to, nil)
     |> assign(:picker_open, false)
     |> assign(:picker_date, nil)
     |> assign(:picker_month, Date.beginning_of_month(Date.utc_today()))
     # Switch
     |> assign(:switch_notifications, true)
     |> assign(:switch_marketing, false)
     |> assign(:switch_airplane, false)
     # Slider
     |> assign(:slider_volume, 65)
     |> assign(:slider_brightness, 40)
     # Rating
     |> assign(:rating_value, 4)
     # Segmented control
     |> assign(:seg_value, "month")
     # Number input
     |> assign(:number_qty, 3)
     # Color picker
     |> assign(:color_value, "#6366f1")
     # Toggle group (text formatting)
     |> assign(:toggle_bold, true)
     |> assign(:toggle_italic, false)
     |> assign(:toggle_underline, false)
     |> assign(:toggle_align, "left")
     # Chip filter
     |> assign(:chip_filter, "all")
     # MultiSelect
     |> assign(:multi_selected, ["elixir", "phoenix"])
     # AutocompleteInput
     |> assign(:ac_language, "")
     # PhoneInput
     |> assign(:phone_value, "")
     |> assign(:phone_code, "+1")
     # SearchInput
     |> assign(:search_query, "")
     # ClearableInput
     |> assign(:clearable_value, "")}
  end

  @impl true
  def handle_event("fruit-toggle", _, s), do: {:noreply, update(s, :fruit_open, &(!&1))}
  def handle_event("fruit-search", %{"query" => q}, s), do: {:noreply, assign(s, :fruit_search, q)}
  def handle_event("fruit-change", %{"value" => v}, s), do: {:noreply, assign(s, fruit_value: v, fruit_open: false, fruit_search: "")}

  def handle_event("country-toggle", _, s), do: {:noreply, update(s, :country_open, &(!&1))}
  def handle_event("country-search", %{"query" => q}, s), do: {:noreply, assign(s, :country_search, q)}
  def handle_event("country-change", %{"value" => v}, s), do: {:noreply, assign(s, country_value: v, country_open: false, country_search: "")}

  def handle_event("tags-change", %{"tags" => tags}, s), do: {:noreply, assign(s, :tags, tags)}

  def handle_event("date-range-change", %{"date" => date_str}, s) do
    date = Date.from_iso8601!(date_str)
    socket =
      cond do
        is_nil(s.assigns.date_from) ->
          assign(s, date_from: date, date_to: nil, date_range: %{start: date, end: nil})
        is_nil(s.assigns.date_to) and Date.compare(date, s.assigns.date_from) != :lt ->
          assign(s, date_to: date, date_range: %{start: s.assigns.date_from, end: date})
        true ->
          assign(s, date_from: date, date_to: nil, date_range: %{start: date, end: nil})
      end
    {:noreply, socket}
  end

  def handle_event("date-month-change", %{"dir" => "next"}, s) do
    vm = s.assigns.view_month
    total = vm.year * 12 + vm.month - 1 + 1
    {:noreply, assign(s, :view_month, Date.new!(div(total, 12), rem(total, 12) + 1, 1))}
  end
  def handle_event("date-month-change", %{"dir" => "prev"}, s) do
    vm = s.assigns.view_month
    total = vm.year * 12 + vm.month - 1 - 1
    {:noreply, assign(s, :view_month, Date.new!(div(total, 12), rem(total, 12) + 1, 1))}
  end

  def handle_event("picker-toggle", _, s), do: {:noreply, update(s, :picker_open, &(!&1))}
  def handle_event("picker-select", %{"date" => iso}, s) do
    date = Date.from_iso8601!(iso)
    {:noreply, assign(s, picker_date: date, picker_open: false, picker_month: Date.beginning_of_month(date))}
  end
  def handle_event("calendar-prev-month", %{"month" => iso}, s),
    do: {:noreply, assign(s, :picker_month, Date.from_iso8601!(iso))}
  def handle_event("calendar-next-month", %{"month" => iso}, s),
    do: {:noreply, assign(s, :picker_month, Date.from_iso8601!(iso))}

  def handle_event("switch-toggle", %{"field" => field}, s) do
    key = String.to_existing_atom("switch_#{field}")
    {:noreply, update(s, key, &(!&1))}
  end

  def handle_event("slider-change", %{"field" => field, "value" => val}, s) do
    key = String.to_existing_atom("slider_#{field}")
    {:noreply, assign(s, key, String.to_integer(val))}
  end

  def handle_event("rating-change", %{"value" => val}, s) do
    {:noreply, assign(s, :rating_value, String.to_integer(val))}
  end

  def handle_event("seg-change", %{"value" => val}, s) do
    {:noreply, assign(s, :seg_value, val)}
  end

  def handle_event("number-change", %{"value" => val}, s) do
    case Integer.parse(val) do
      {n, _} -> {:noreply, assign(s, :number_qty, n)}
      :error -> {:noreply, s}
    end
  end

  def handle_event("color-change", %{"value" => val}, s) do
    {:noreply, assign(s, :color_value, val)}
  end

  def handle_event("toggle-format", %{"format" => "bold"}, s), do: {:noreply, update(s, :toggle_bold, &(!&1))}
  def handle_event("toggle-format", %{"format" => "italic"}, s), do: {:noreply, update(s, :toggle_italic, &(!&1))}
  def handle_event("toggle-format", %{"format" => "underline"}, s), do: {:noreply, update(s, :toggle_underline, &(!&1))}

  def handle_event("toggle-align", %{"align" => align}, s) do
    {:noreply, assign(s, :toggle_align, align)}
  end

  def handle_event("chip-select", %{"filter" => f}, s) do
    {:noreply, assign(s, :chip_filter, f)}
  end

  def handle_event("multi-change", %{"values" => vals}, s) do
    {:noreply, assign(s, :multi_selected, vals)}
  end
  def handle_event("multi-change", _, s), do: {:noreply, assign(s, :multi_selected, [])}

  def handle_event("ac-language-change", %{"value" => val}, s) do
    {:noreply, assign(s, :ac_language, val)}
  end

  def handle_event("phone-change", %{"value" => val}, s) do
    {:noreply, assign(s, :phone_value, val)}
  end

  def handle_event("search-change", %{"value" => val}, s) do
    {:noreply, assign(s, :search_query, val)}
  end
  def handle_event("clear-search", _, s) do
    {:noreply, assign(s, :search_query, "")}
  end

  def handle_event("clearable-change", %{"value" => val}, s) do
    {:noreply, assign(s, :clearable_value, val)}
  end
  def handle_event("clear-clearable", _, s) do
    {:noreply, assign(s, :clearable_value, "")}
  end

  def handle_event(_, _, s), do: {:noreply, s}

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(fruit_options: @fruit_options, country_options: @country_options)
      |> assign(multi_options: @multi_options, seg_options: @seg_options)

    ~H"""
    <Layout.layout current_path="/components/inputs">
      <div class="p-3 sm:p-4 lg:p-6 space-y-8 max-w-screen-xl mx-auto phia-animate">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Inputs</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Form components — text fields, selectors, toggles, pickers and editors</p>
        </div>

        <%!-- Button variants --%>
        <.demo_section title="Button" subtitle="6 variants × 3 sizes — all server-rendered, no JS required">
          <div class="space-y-3">
            <div class="flex flex-wrap gap-2 items-center">
              <.button>Primary</.button>
              <.button variant={:secondary}>Secondary</.button>
              <.button variant={:outline}>Outline</.button>
              <.button variant={:ghost}>Ghost</.button>
              <.button variant={:destructive}>Destructive</.button>
              <.button variant={:link}>Link</.button>
            </div>
            <.separator />
            <div class="flex flex-wrap gap-2 items-center">
              <.button size={:sm}>Small</.button>
              <.button>Default</.button>
              <.button size={:lg}>Large</.button>
              <.button size={:icon} aria-label="Settings"><.icon name="settings" size={:xs} /></.button>
            </div>
            <.separator />
            <div class="flex flex-wrap gap-2 items-center">
              <.button disabled>Disabled</.button>
              <.button variant={:outline} disabled>Outline Disabled</.button>
            </div>
          </div>
        </.demo_section>

        <%!-- ButtonGroup --%>
        <.demo_section title="ButtonGroup" subtitle="Unified button bar — borders collapse between adjacent buttons">
          <div class="space-y-4">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Horizontal (default)</p>
              <.button_group>
                <.button variant={:outline} size={:sm} aria-label="Bold"><.icon name="bold" size={:xs} /></.button>
                <.button variant={:outline} size={:sm} aria-label="Italic"><.icon name="italic" size={:xs} /></.button>
                <.button variant={:outline} size={:sm} aria-label="Underline"><.icon name="underline" size={:xs} /></.button>
                <.button variant={:outline} size={:sm} aria-label="Link"><.icon name="link" size={:xs} /></.button>
              </.button_group>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">With text labels</p>
              <.button_group>
                <.button variant={:outline} size={:sm}>Previous</.button>
                <.button variant={:outline} size={:sm}>1</.button>
                <.button variant={:outline} size={:sm}>2</.button>
                <.button variant={:outline} size={:sm}>3</.button>
                <.button variant={:outline} size={:sm}>Next</.button>
              </.button_group>
            </div>
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Vertical</p>
              <.button_group orientation="vertical">
                <.button variant={:outline} size={:sm}>Top</.button>
                <.button variant={:outline} size={:sm}>Middle</.button>
                <.button variant={:outline} size={:sm}>Bottom</.button>
              </.button_group>
            </div>
          </div>
        </.demo_section>

        <%!-- CopyButton --%>
        <.demo_section title="CopyButton" subtitle="Click to copy — icon swaps to checkmark for feedback duration">
          <div class="space-y-4">
            <div class="flex items-center gap-3">
              <code class="flex-1 rounded-md border border-border bg-muted px-3 py-2 text-sm font-mono">mix phx.new my_app --no-ecto</code>
              <.copy_button id="copy-mix" value="mix phx.new my_app --no-ecto" />
            </div>
            <div class="flex items-center gap-3">
              <code class="flex-1 rounded-md border border-border bg-muted px-3 py-2 text-sm font-mono">sk-ant-api03-example-key</code>
              <.copy_button id="copy-key" value="sk-ant-api03-example-key" label="Copy API key" />
            </div>
          </div>
        </.demo_section>

        <%!-- Switch --%>
        <.demo_section title="Switch" subtitle="Controlled on/off toggles with aria-checked">
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-foreground">Email Notifications</p>
                <p class="text-xs text-muted-foreground">Receive alerts about your account</p>
              </div>
              <.switch checked={@switch_notifications} phx-click="switch-toggle" phx-value-field="notifications" />
            </div>
            <.separator />
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-foreground">Marketing Emails</p>
                <p class="text-xs text-muted-foreground">Receive news and promotions</p>
              </div>
              <.switch checked={@switch_marketing} phx-click="switch-toggle" phx-value-field="marketing" />
            </div>
            <.separator />
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-foreground">Airplane Mode</p>
                <p class="text-xs text-muted-foreground">Disable all wireless connections</p>
              </div>
              <.switch checked={@switch_airplane} phx-click="switch-toggle" phx-value-field="airplane" />
            </div>
          </div>
        </.demo_section>

        <%!-- Slider --%>
        <.demo_section title="Slider" subtitle="Range input with live value display — keyboard accessible">
          <div class="space-y-6">
            <div class="space-y-2">
              <div class="flex justify-between text-sm">
                <label class="font-medium text-foreground">Volume</label>
                <span class="text-muted-foreground">{@slider_volume}%</span>
              </div>
              <.slider value={@slider_volume} min={0} max={100} step={1}
                phx-change="slider-change" phx-value-field="volume" name="volume" />
            </div>
            <div class="space-y-2">
              <div class="flex justify-between text-sm">
                <label class="font-medium text-foreground">Brightness</label>
                <span class="text-muted-foreground">{@slider_brightness}%</span>
              </div>
              <.slider value={@slider_brightness} min={0} max={100} step={5}
                phx-change="slider-change" phx-value-field="brightness" name="brightness" />
            </div>
          </div>
        </.demo_section>

        <%!-- Rating --%>
        <.demo_section title="Rating" subtitle="Star rating — click to set, server-controlled">
          <div class="space-y-4">
            <div class="space-y-1">
              <p class="text-sm font-medium text-foreground">Product Rating</p>
              <.rating value={@rating_value} max={5} phx-click="rating-change" name="rating" />
              <p class="text-xs text-muted-foreground mt-1">
                {if @rating_value > 0, do: "#{@rating_value} / 5 stars selected", else: "No rating selected"}
              </p>
            </div>
            <.separator />
            <div class="space-y-1">
              <p class="text-sm font-medium text-foreground">Read-only (4.5 stars)</p>
              <.rating value={4} max={5} readonly={true} />
            </div>
          </div>
        </.demo_section>

        <%!-- SegmentedControl --%>
        <.demo_section title="SegmentedControl" subtitle="Mutually exclusive tab-style selector — radio inputs, zero JS">
          <div class="space-y-3">
            <.segmented_control
              id="showcase-seg"
              name="period"
              value={@seg_value}
              segments={@seg_options}
              on_change="seg-change"
            />
            <p class="text-xs text-muted-foreground">
              Selected: <strong class="text-foreground">{@seg_value}</strong>
            </p>
          </div>
        </.demo_section>

        <%!-- Toggle + ToggleGroup --%>
        <.demo_section title="Toggle & ToggleGroup" subtitle="Pressed-state buttons for toolbars — aria-pressed managed automatically">
          <div class="space-y-4">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Text Formatting</p>
              <div class="flex items-center gap-1 p-1 rounded-md border border-border/60 bg-muted/30 w-fit">
                <.toggle pressed={@toggle_bold} phx-click="toggle-format" phx-value-format="bold" aria-label="Bold">
                  <.icon name="bold" size={:xs} />
                </.toggle>
                <.toggle pressed={@toggle_italic} phx-click="toggle-format" phx-value-format="italic" aria-label="Italic">
                  <.icon name="italic" size={:xs} />
                </.toggle>
                <.toggle pressed={@toggle_underline} phx-click="toggle-format" phx-value-format="underline" aria-label="Underline">
                  <.icon name="underline" size={:xs} />
                </.toggle>
                <.separator orientation="vertical" class="h-6 mx-1" />
                <.toggle pressed={false} aria-label="Heading">
                  <.icon name="heading" size={:xs} />
                </.toggle>
                <.toggle pressed={false} aria-label="List">
                  <.icon name="list" size={:xs} />
                </.toggle>
                <.toggle pressed={false} aria-label="Ordered List">
                  <.icon name="list-ordered" size={:xs} />
                </.toggle>
                <.toggle pressed={false} aria-label="Link">
                  <.icon name="link" size={:xs} />
                </.toggle>
              </div>
              <p class="text-xs text-muted-foreground mt-2">
                Active: <%= [if(@toggle_bold, do: "Bold"), if(@toggle_italic, do: "Italic"), if(@toggle_underline, do: "Underline")] |> Enum.reject(&is_nil/1) |> Enum.join(", ") |> case do "" -> "none"; v -> v end %>
              </p>
            </div>
            <.separator />
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">Alignment (ToggleGroup single)</p>
              <.toggle_group :let={ctx} type="single" value={@toggle_align}>
                <.toggle_group_item value="left" group_value={ctx.group_value} group_type={ctx.group_type}
                  phx-click="toggle-align" phx-value-align="left" aria-label="Align left">
                  <.icon name="align-left" size={:xs} />
                </.toggle_group_item>
                <.toggle_group_item value="center" group_value={ctx.group_value} group_type={ctx.group_type}
                  phx-click="toggle-align" phx-value-align="center" aria-label="Align center">
                  <.icon name="align-center" size={:xs} />
                </.toggle_group_item>
                <.toggle_group_item value="right" group_value={ctx.group_value} group_type={ctx.group_type}
                  phx-click="toggle-align" phx-value-align="right" aria-label="Align right">
                  <.icon name="align-right" size={:xs} />
                </.toggle_group_item>
              </.toggle_group>
            </div>
          </div>
        </.demo_section>

        <%!-- Chip filter --%>
        <.demo_section title="Chip" subtitle="Compact interactive labels — filter chips with selected state">
          <div class="space-y-3">
            <div class="flex flex-wrap gap-2">
              <%= for {value, label} <- [{"all", "All"}, {"frontend", "Frontend"}, {"backend", "Backend"}, {"design", "Design"}, {"devops", "DevOps"}] do %>
                <.chip value={value} selected={@chip_filter == value} on_click="chip-select" phx-value-filter={value}>
                  {label}
                </.chip>
              <% end %>
            </div>
            <p class="text-xs text-muted-foreground">Filter: <strong class="text-foreground">{@chip_filter}</strong></p>
            <.separator />
            <div class="flex flex-wrap gap-2">
              <.chip variant={:outline}>Outline</.chip>
              <.chip variant={:filled}>Filled</.chip>
              <.chip dismissible={true}>Dismissible ×</.chip>
              <.chip disabled={true}>Disabled</.chip>
            </div>
          </div>
        </.demo_section>

        <%!-- Input + Textarea --%>
        <.demo_section title="Input & Textarea" subtitle="Basic text inputs with label, placeholder and disabled states">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-3">
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Username</label>
                <input type="text" placeholder="e.g. john_doe" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
              </div>
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Email</label>
                <input type="email" placeholder="user@example.com" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
              </div>
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Disabled</label>
                <input type="text" value="Cannot edit" disabled class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm opacity-50 cursor-not-allowed" />
              </div>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Description</label>
              <textarea rows="5" placeholder="Write something..." class="flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring resize-none"></textarea>
              <p class="text-xs text-muted-foreground">Max 500 characters</p>
            </div>
          </div>
        </.demo_section>

        <%!-- PasswordInput + NumberInput --%>
        <.demo_section title="PasswordInput & NumberInput" subtitle="Specialised inputs — password reveal toggle and numeric stepper">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Password</label>
              <.password_input placeholder="Enter your password" name="password" />
              <p class="text-xs text-muted-foreground">Click the eye icon to reveal</p>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Quantity — live: {@number_qty}</label>
              <.number_input value={@number_qty} min={1} max={99} step={1} name="qty" />
            </div>
          </div>
        </.demo_section>

        <%!-- ColorPicker --%>
        <.demo_section title="ColorPicker" subtitle="Native color wheel with hex preview — triggers phx-change on selection">
          <div class="space-y-3">
            <div class="flex items-center gap-4">
              <.color_picker id="showcase-color" value={@color_value} on_change="color-change" />
              <div class="space-y-1">
                <p class="text-sm font-medium text-foreground">Selected Color</p>
                <div class="flex items-center gap-2">
                  <span class="inline-block h-6 w-6 rounded-md ring-1 ring-border" style={"background-color: #{@color_value}"} />
                  <code class="text-sm font-mono text-foreground">{@color_value}</code>
                </div>
              </div>
            </div>
          </div>
        </.demo_section>

        <%!-- InputOtp --%>
        <.demo_section title="InputOtp" subtitle="One-time password slots — focus advances automatically on digit entry">
          <div class="space-y-3">
            <label class="text-sm font-medium text-foreground">Verification Code</label>
            <.input_otp id="showcase-otp" name="otp" length={6} />
            <p class="text-xs text-muted-foreground">Enter the 6-digit code sent to your device</p>
          </div>
        </.demo_section>

        <%!-- InputAddon --%>
        <.demo_section title="InputAddon" subtitle="Prefix/suffix decorations for contextual inputs">
          <div class="space-y-3">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Website</label>
              <.input_addon>
                <:prefix>https://</:prefix>
                <input type="text" placeholder="yoursite.com" class="flex-1 min-w-0 h-full bg-transparent text-sm px-3 outline-none placeholder:text-muted-foreground" />
              </.input_addon>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Amount</label>
              <.input_addon>
                <:prefix>$</:prefix>
                <input type="number" placeholder="0.00" class="flex-1 min-w-0 h-full bg-transparent text-sm px-3 outline-none placeholder:text-muted-foreground" />
                <:suffix>USD</:suffix>
              </.input_addon>
            </div>
          </div>
        </.demo_section>

        <%!-- MultiSelect --%>
        <.demo_section title="MultiSelect" subtitle="Multi-value native select with chip-style display">
          <div class="space-y-1.5">
            <label class="text-sm font-medium text-foreground">Technologies</label>
            <.multi_select
              id="showcase-multi"
              name="tech"
              options={@multi_options}
              selected={@multi_selected}
              placeholder="Select technologies..."
              on_change="multi-change"
            />
            <p class="text-xs text-muted-foreground">
              Selected: {if @multi_selected == [], do: "none", else: Enum.join(@multi_selected, ", ")}
            </p>
          </div>
        </.demo_section>

        <%!-- Combobox --%>
        <.demo_section title="Combobox" subtitle="Searchable select with live filtering — keyboard navigable">
          <div class="grid gap-6 lg:grid-cols-2">
            <div>
              <label class="text-sm font-medium text-foreground mb-1.5 block">Favorite Fruit</label>
              <div :if={@fruit_open} phx-click="fruit-toggle" class="fixed inset-0 z-40" aria-hidden="true" />
              <.combobox
                id="showcase-fruit"
                options={@fruit_options}
                value={@fruit_value}
                open={@fruit_open}
                search={@fruit_search}
                placeholder="Select fruit..."
                search_placeholder="Search fruit..."
                on_change="fruit-change"
                on_search="fruit-search"
                on_toggle="fruit-toggle"
              />
            </div>
            <div>
              <label class="text-sm font-medium text-foreground mb-1.5 block">Country</label>
              <div :if={@country_open} phx-click="country-toggle" class="fixed inset-0 z-40" aria-hidden="true" />
              <.combobox
                id="showcase-country"
                options={@country_options}
                value={@country_value}
                open={@country_open}
                search={@country_search}
                placeholder="Select country..."
                search_placeholder="Search country..."
                on_change="country-change"
                on_search="country-search"
                on_toggle="country-toggle"
              />
            </div>
          </div>
        </.demo_section>

        <%!-- Checkbox + RadioGroup --%>
        <.demo_section title="Checkbox & RadioGroup" subtitle="PhiaUI checkbox and radio_group + radio_group_item components">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Checkbox</p>
              <label class="flex items-center gap-3 cursor-pointer">
                <.checkbox id="cb-email" name="cb_email" checked={true} />
                <span class="text-sm text-foreground">Email notifications</span>
              </label>
              <label class="flex items-center gap-3 cursor-pointer">
                <.checkbox id="cb-sms" name="cb_sms" checked={false} />
                <span class="text-sm text-foreground">SMS alerts</span>
              </label>
              <label class="flex items-center gap-3 cursor-pointer">
                <.checkbox id="cb-digest" name="cb_digest" checked={true} />
                <span class="text-sm text-foreground">Weekly digest</span>
              </label>
              <label class="flex items-center gap-3 cursor-pointer">
                <.checkbox id="cb-all" name="cb_all" indeterminate={true} />
                <span class="text-sm text-foreground">Select all (indeterminate)</span>
              </label>
            </div>
            <div class="space-y-3">
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">RadioGroup & RadioGroupItem</p>
              <.radio_group :let={group} value="pro" name="plan">
                <.radio_group_item value="free" label="Free — $0/month" {group} />
                <.radio_group_item value="pro" label="Pro — $29/month" {group} />
                <.radio_group_item value="enterprise" label="Enterprise — Custom pricing" {group} />
              </.radio_group>
            </div>
          </div>
        </.demo_section>

        <%!-- DatePicker --%>
        <.demo_section title="DatePicker" subtitle="Single-date calendar popover — server-controlled, zero JS">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-2">
              <label class="text-sm font-medium text-foreground">Event date</label>
              <.date_picker
                id="showcase-datepicker"
                open={@picker_open}
                value={@picker_date}
                current_month={@picker_month}
                on_toggle="picker-toggle"
                on_change="picker-select"
                placeholder="Pick a date"
                format="%B %d, %Y"
              />
              <p :if={@picker_date} class="text-xs text-muted-foreground">
                Selected: {Calendar.strftime(@picker_date, "%A, %B %d, %Y")}
              </p>
              <p :if={is_nil(@picker_date)} class="text-xs text-muted-foreground">
                No date selected. Click to open calendar.
              </p>
            </div>
            <div class="space-y-2">
              <label class="text-sm font-medium text-foreground">Date Range</label>
              <.date_range_picker
                id="showcase-daterange"
                view_month={@view_month}
                from={@date_from}
                to={@date_to}
                on_change="date-range-change"
                on_month_change="date-month-change"
              />
              <%= if @date_range && @date_range.start do %>
                <p class="text-xs text-muted-foreground">
                  {Calendar.strftime(@date_range.start, "%b %d, %Y")} → {if @date_range.end, do: Calendar.strftime(@date_range.end, "%b %d, %Y"), else: "..."}
                </p>
              <% end %>
            </div>
          </div>
        </.demo_section>

        <%!-- TagsInput --%>
        <.demo_section title="TagsInput" subtitle="Tag chips — manual fallback demo (full version uses Phoenix.HTML.FormField)">
          <div class="space-y-1.5">
            <label class="text-sm font-medium text-foreground">Technologies</label>
            <div class="flex flex-wrap gap-1.5 rounded-md border border-input bg-background px-3 py-2 min-h-10">
              <%= for tag <- @tags do %>
                <span class="inline-flex items-center gap-1 rounded-md bg-primary/10 px-2 py-0.5 text-xs font-medium text-primary">
                  {tag}
                  <button type="button" class="text-primary/60 hover:text-primary ml-0.5" aria-label={"Remove tag " <> tag}>×</button>
                </span>
              <% end %>
              <input type="text" placeholder="Add tag..." aria-label="Add tag" class="flex-1 min-w-20 text-sm bg-transparent outline-none placeholder:text-muted-foreground" />
            </div>
            <p class="text-xs text-muted-foreground">Use <code class="font-mono bg-muted px-1 rounded">.form</code> + FormField for full functionality</p>
          </div>
        </.demo_section>

        <%!-- FileUpload --%>
        <.demo_section title="FileUpload" subtitle="Drag-and-drop zone — wires to allow_upload/3 in LiveView">
          <.file_upload label="Documents" accept=".pdf,.docx,.xlsx">
            <:empty>
              <p class="text-sm"><span class="font-medium text-primary">Click to upload</span> or drag & drop</p>
              <p class="text-xs text-muted-foreground mt-1">PDF, DOCX, XLSX up to 10 MB</p>
            </:empty>
          </.file_upload>
        </.demo_section>

        <%!-- Select (native) --%>
        <.demo_section title="Select (native)" subtitle="HTML select with semantic styling">
          <div class="grid gap-4 lg:grid-cols-2">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Role</label>
              <select class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring">
                <option value="">Select role...</option>
                <option>Admin</option>
                <option>Editor</option>
                <option>Viewer</option>
              </select>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Size</label>
              <select class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring">
                <option>Small</option>
                <option selected>Medium</option>
                <option>Large</option>
                <option>Extra Large</option>
              </select>
            </div>
          </div>
        </.demo_section>

        <%!-- AutocompleteInput --%>
        <.demo_section title="AutocompleteInput" subtitle="Text input with native HTML5 datalist suggestions — no JS required">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Programming Language</label>
              <.autocomplete_input
                name="language"
                value={@ac_language}
                placeholder="Start typing a language..."
                suggestions={["Elixir", "Erlang", "Rust", "Go", "Python", "TypeScript", "JavaScript", "Ruby", "Java", "Kotlin", "Swift", "C#", "Haskell", "Clojure", "Scala"]}
                phx-change="ac-language-change"
              />
              <p class="text-xs text-muted-foreground">
                {if @ac_language != "", do: "Selected: #{@ac_language}", else: "Type to see browser suggestions"}
              </p>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">City (tuple suggestions)</label>
              <.autocomplete_input
                name="city"
                placeholder="Search cities..."
                suggestions={[{"New York", "nyc"}, {"San Francisco", "sfo"}, {"London", "ldn"}, {"Tokyo", "tyo"}, {"Berlin", "ber"}, {"Paris", "par"}, {"São Paulo", "gru"}]}
              />
              <p class="text-xs text-muted-foreground">Uses <code class="font-mono bg-muted px-1 rounded">{"{label, value}"}</code> tuples</p>
            </div>
          </div>
        </.demo_section>

        <%!-- PhoneInput --%>
        <.demo_section title="PhoneInput" subtitle="Phone number input with country dial-code prefix selector — ~50 countries included">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Phone Number</label>
              <.phone_input
                name="phone"
                value={@phone_value}
                selected_code={@phone_code}
                placeholder="555 123 4567"
                phx-change="phone-change"
              />
              <p class="text-xs text-muted-foreground">
                {if @phone_value != "", do: "Number: #{@phone_code} #{@phone_value}", else: "Select a country code and type a number"}
              </p>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Disabled</label>
              <.phone_input
                name="phone_disabled"
                value="7700 900000"
                selected_code="+44"
                disabled={true}
              />
              <p class="text-xs text-muted-foreground">Disabled state — both selector and input</p>
            </div>
          </div>
        </.demo_section>

        <%!-- SearchInput --%>
        <.demo_section title="SearchInput" subtitle="Search field with magnifier icon, optional clear button and shortcut badge — 3 variants">
          <div class="space-y-4">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Default variant</label>
              <.search_input
                name="q"
                value={@search_query}
                placeholder="Search products..."
                on_clear="clear-search"
                phx-change="search-change"
                phx-debounce="300"
              />
              <p class="text-xs text-muted-foreground">
                {if @search_query != "", do: "Query: \"#{@search_query}\"", else: "Type to search — × button appears when non-empty"}
              </p>
            </div>
            <.separator />
            <div class="grid gap-4 lg:grid-cols-2">
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">With shortcut badge</label>
                <.search_input name="cmd" placeholder="Jump to..." shortcut="⌘K" />
              </div>
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Minimal variant</label>
                <.search_input name="filter" placeholder="Filter items..." variant="minimal" />
              </div>
            </div>
            <div class="grid gap-4 lg:grid-cols-2">
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Ghost variant</label>
                <.search_input name="ghost" placeholder="Search..." variant="ghost" />
              </div>
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Disabled</label>
                <.search_input name="disabled" placeholder="Search..." disabled={true} />
              </div>
            </div>
          </div>
        </.demo_section>

        <%!-- CopyInput --%>
        <.demo_section title="CopyInput" subtitle="Read-only input with inline copy button — optional masking for secrets">
          <div class="space-y-4">
            <.copy_input
              label="Share Link"
              value="https://phiaui.dev/share/abc123xyz"
            />
            <.separator />
            <.copy_input
              label="API Key"
              value="sk-live-phia-abc123def456ghi789"
              masked={true}
              description="Click the eye icon to reveal, copy button always copies the real value"
            />
            <.separator />
            <div class="grid gap-4 lg:grid-cols-2">
              <.copy_input
                label="Embed Code"
                value={~s(<script src="https://cdn.phiaui.dev/widget.js"></script>)}
                size="sm"
              />
              <.copy_input
                label="Webhook URL"
                value="https://api.phiaui.dev/webhooks/events"
                size="lg"
              />
            </div>
          </div>
        </.demo_section>

        <%!-- ClearableInput --%>
        <.demo_section title="ClearableInput" subtitle="Text input with inline × clear button — disappears when empty">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Filter by name</label>
              <.clearable_input
                name="filter"
                value={@clearable_value}
                placeholder="Type to filter..."
                on_clear="clear-clearable"
                phx-change="clearable-change"
                phx-debounce="300"
              />
              <p class="text-xs text-muted-foreground">
                {if @clearable_value != "", do: "Value: \"#{@clearable_value}\" — click × to clear", else: "× button appears when non-empty"}
              </p>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Email (no clear button)</label>
              <.clearable_input
                name="email_demo"
                value=""
                type="email"
                placeholder="user@example.com"
              />
              <p class="text-xs text-muted-foreground">Without <code class="font-mono bg-muted px-1 rounded">on_clear</code> — works as a regular input</p>
            </div>
          </div>
        </.demo_section>

        <%!-- UrlInput --%>
        <.demo_section title="UrlInput" subtitle="URL input with lockable protocol prefix — https:// or http://">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Website URL</label>
              <.url_input name="website" placeholder="example.com" />
              <p class="text-xs text-muted-foreground">Protocol defaults to https://</p>
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Custom protocol</label>
              <.url_input name="website_http" placeholder="legacy-site.com" protocol="http" />
            </div>
          </div>
        </.demo_section>

        <%!-- UnitInput --%>
        <.demo_section title="UnitInput" subtitle="Numeric input with unit symbol — currency, percentage, weight, distance">
          <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Price (USD)</label>
              <.unit_input name="price" unit={:currency_usd} placeholder="0.00" />
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Discount</label>
              <.unit_input name="discount" unit={:percent} placeholder="0" />
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Weight</label>
              <.unit_input name="weight" unit={:kg} placeholder="0.0" />
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Custom unit</label>
              <.unit_input name="custom" symbol="px" symbol_position="right" placeholder="16" />
            </div>
          </div>
        </.demo_section>

        <%!-- TextareaCounter --%>
        <.demo_section title="TextareaCounter" subtitle="Textarea with live character counter — color changes at 80% and over limit">
          <div class="grid gap-6 lg:grid-cols-2">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Bio (max 280)</label>
              <.textarea_counter name="bio" max_length={280} placeholder="Write a short bio..." rows={4} />
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Notes (no limit)</label>
              <.textarea_counter name="notes" placeholder="Free-form notes..." rows={4} />
            </div>
          </div>
        </.demo_section>

        <%!-- InlineSearch --%>
        <.demo_section title="InlineSearch" subtitle="Icon button that expands to search input on click — collapses on Escape/blur">
          <div class="flex items-center gap-4">
            <.inline_search id="inline-search-demo" name="inline_q" placeholder="Search items..." />
            <p class="text-sm text-muted-foreground">Click the search icon to expand</p>
          </div>
        </.demo_section>

        <%!-- FancyButton Variants --%>
        <.demo_section title="FancyButton, SplitButton, IconButton, SocialButton, ActionButton" subtitle="Extended button variants — shimmer, split dropdown, icon-only, social, and action styles">
          <div class="space-y-6">
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">FancyButton</p>
              <div class="flex flex-wrap gap-2 items-center">
                <.shimmer_button>Shimmer</.shimmer_button>
                <.glow_button>Glow</.glow_button>
                <.gradient_button>Gradient</.gradient_button>
              </div>
            </div>
            <.separator />
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">IconButton</p>
              <div class="flex flex-wrap gap-2 items-center">
                <.icon_button icon="settings" label="Settings" />
                <.icon_button icon="heart" label="Favorite" variant={:outline} />
                <.icon_button icon="trash-2" label="Delete" variant={:destructive} />
                <.icon_button icon="plus" label="Add" variant={:secondary} size={:lg} />
              </div>
            </div>
            <.separator />
            <div>
              <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground mb-2">SocialButton</p>
              <div class="flex flex-wrap gap-2 items-center">
                <.social_button provider={:github}>GitHub</.social_button>
                <.social_button provider={:google}>Google</.social_button>
                <.social_button provider={:apple}>Apple</.social_button>
              </div>
            </div>
          </div>
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
