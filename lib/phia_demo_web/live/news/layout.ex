defmodule PhiaDemoWeb.Demo.News.Layout do
  @moduledoc "News page layout — topbar only, no sidebar."

  use Phoenix.Component

  import PhiaDemoWeb.ProjectNav

  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <div class="min-h-screen bg-background text-foreground">
      <header class="sticky top-0 z-40 flex h-14 items-center border-b border-border/60 bg-background/95 backdrop-blur px-4">
        <.project_topbar current_project={:news} dark_mode_id="news-dm" />
      </header>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
