defmodule PhiaDemoWeb.Router do
  use PhiaDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhiaDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhiaDemoWeb do
    pipe_through :browser

    # Home — theme picker + project selector
    live "/", HomeLive

    # Dashboard demo
    live "/dashboard",            Demo.Dashboard.Overview,  :index
    live "/dashboard/analytics",  Demo.Dashboard.Analytics, :index
    live "/dashboard/users",      Demo.Dashboard.Users,     :index
    live "/dashboard/orders",     Demo.Dashboard.Orders,    :index
    live "/dashboard/settings",   Demo.Dashboard.Settings,  :index

    # News
    live "/news",         Demo.News.IndexLive, :index
    live "/news/:slug",   Demo.News.ShowLive,  :show

    # Components
    live "/components",             Demo.Components.IndexLive,      :index
    live "/components/inputs",      Demo.Components.InputsLive,     :index
    live "/components/display",     Demo.Components.DisplayLive,    :index
    live "/components/feedback",    Demo.Components.FeedbackLive,   :index
    live "/components/charts",      Demo.Components.ChartsLive,     :index
    live "/components/calendar",    Demo.Components.CalendarLive,   :index
    live "/components/cards",       Demo.Components.CardsLive,      :index
    live "/components/navigation",  Demo.Components.NavigationLive, :index
    live "/components/tables",      Demo.Components.TablesLive,     :index
    live "/components/upload",      Demo.Components.UploadLive,     :index
    live "/components/media",       Demo.Components.MediaLive,      :index
    live "/components/animation",   Demo.Components.AnimationLive,  :index
    live "/components/visual",      Demo.Components.VisualLive,     :index
    live "/components/layout",      Demo.Components.LayoutLive,     :index

    # Chat demo
    live "/chat",                 Demo.Chat.RoomLive, :index
    live "/chat/:room_id",        Demo.Chat.RoomLive, :show

    # Kanban demo
    live "/kanban",               Demo.Kanban.IndexLive, :index

    # Notes demo
    live "/notes",                Demo.Notes.IndexLive, :index

    # Mail demo
    live "/mail",                 Demo.Mail.IndexLive, :index

    # Todo demo
    live "/todo",                 Demo.Todo.IndexLive, :index

    # Tasks demo
    live "/tasks",                Demo.Tasks.IndexLive, :index

    # Social demo
    live "/social",               Demo.Social.IndexLive, :index

    # File Manager demo
    live "/files",                Demo.FileManager.IndexLive, :index

    # API Keys demo
    live "/api-keys",             Demo.ApiKeys.IndexLive, :index

    # POS demo
    live "/pos",                  Demo.Pos.IndexLive, :index

    # Courses demo
    live "/courses",              Demo.Courses.IndexLive, :index

    # AI Chat demo
    live "/ai-chat",              Demo.AiChat.IndexLive, :index

    # AI Chat V2 demo
    live "/ai-chat-v2",           Demo.AiChatV2.IndexLive, :index

    # Image Generator demo
    live "/image-generator",      Demo.ImageGenerator.IndexLive, :index

    # Hotel demo
    live "/hotel",          Demo.Hotel.OverviewLive,  :index
    live "/hotel/bookings", Demo.Hotel.BookingsLive,  :index

    # Profile demo
    live "/profile",          Demo.Profile.V1Live,       :index
    live "/profile/v2",       Demo.Profile.V2Live,       :index
    live "/profile/teams",    Demo.Profile.TeamsLive,    :index
    live "/profile/projects", Demo.Profile.ProjectsLive, :index

    # Notifications page
    live "/notifications", Demo.Notifications.IndexLive, :index

    # Pricing demo
    live "/pricing",        Demo.Pricing.ColumnLive, :index
    live "/pricing/column", Demo.Pricing.ColumnLive, :index
    live "/pricing/table",  Demo.Pricing.TableLive,  :index
    live "/pricing/single", Demo.Pricing.SingleLive, :index
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:phia_demo, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhiaDemoWeb.Telemetry
    end
  end
end
