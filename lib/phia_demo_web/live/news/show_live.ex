defmodule PhiaDemoWeb.Demo.News.ShowLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.News.Layout
  alias PhiaDemo.News

  @impl true
  def handle_params(%{"slug" => slug}, _uri, socket) do
    case News.get_article(slug) do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "Article not found")
         |> push_navigate(to: "/news")}

      article ->
        {:noreply,
         socket
         |> assign(:page_title, article.title)
         |> assign(:article, article)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout>
      <div class="p-4 md:p-6 lg:p-8 max-w-3xl mx-auto phia-animate">

        <%!-- Back link --%>
        <a href="/news" class="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-primary transition-colors mb-6">
          <.icon name="arrow-left" size={:xs} />
          Back to News
        </a>

        <%!-- Article header --%>
        <header class="mb-8 space-y-3">
          <div class="flex items-center gap-2 flex-wrap">
            <%= for tag <- @article.tags do %>
              <.badge variant={:secondary} class="text-xs">{tag}</.badge>
            <% end %>
          </div>
          <h1 class="text-2xl md:text-3xl font-bold text-foreground tracking-tight">
            {@article.title}
          </h1>
          <p class="text-sm text-muted-foreground">
            {Calendar.strftime(@article.date, "%B %d, %Y")}
          </p>
        </header>

        <%!-- Article body --%>
        <.prose>
          {Phoenix.HTML.raw(@article.body_html)}
        </.prose>

        <%!-- Footer nav --%>
        <div class="mt-12 pt-6 border-t border-border/60">
          <a href="/news" class="inline-flex items-center gap-1.5 text-sm font-medium text-primary hover:gap-2.5 transition-all">
            <.icon name="arrow-left" size={:xs} />
            All articles
          </a>
        </div>

      </div>
    </Layout.layout>
    """
  end
end
