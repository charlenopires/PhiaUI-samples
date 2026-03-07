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

    # Chat demo
    live "/chat",                 Demo.Chat.RoomLive, :index
    live "/chat/:room_id",        Demo.Chat.RoomLive, :show
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
