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

    # Showcase demo
    live "/showcase",             Demo.Showcase.IndexLive,    :index
    live "/showcase/inputs",      Demo.Showcase.InputsLive,   :index
    live "/showcase/display",     Demo.Showcase.DisplayLive,  :index
    live "/showcase/feedback",    Demo.Showcase.FeedbackLive, :index
    live "/showcase/charts",      Demo.Showcase.ChartsLive,    :index
    live "/showcase/calendar",    Demo.Showcase.CalendarLive,  :index
    live "/showcase/cards",       Demo.Showcase.CardsLive,     :index
    live "/showcase/navigation",  Demo.Showcase.NavigationLive, :index
    live "/showcase/tables",      Demo.Showcase.TablesLive,    :index
    live "/showcase/upload",      Demo.Showcase.UploadLive,    :index
    live "/showcase/media",       Demo.Showcase.MediaLive,     :index
    live "/showcase/animation",   Demo.Showcase.AnimationLive, :index
    live "/showcase/visual",      Demo.Showcase.VisualLive,    :index

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
