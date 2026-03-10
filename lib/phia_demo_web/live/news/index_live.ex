defmodule PhiaDemoWeb.Demo.News.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.News.Layout
  alias PhiaDemo.News

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "News")
     |> assign(:articles, News.list_articles())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout>
      <div class="p-4 md:p-6 lg:p-8 max-w-5xl mx-auto space-y-8 phia-animate">

        <%!-- Hero --%>
        <div class="text-center space-y-3 py-6 md:py-8">
          <div class="inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/10 mb-2">
            <.icon name="newspaper" class="text-primary" />
          </div>
          <h1 class="text-3xl font-bold text-foreground tracking-tight">News</h1>
          <p class="text-muted-foreground text-lg max-w-xl mx-auto">
            Latest updates, new components, and tools for PhiaUI developers.
          </p>
        </div>

        <%!-- Article cards --%>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
          <%= for article <- @articles do %>
            <a
              href={"/news/#{article.slug}"}
              class="group flex flex-col rounded-xl border border-border/60 bg-card p-5 shadow-sm hover:shadow-lg hover:border-primary/40 transition-all duration-300 overflow-hidden"
            >
              <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/10 text-primary mb-4 group-hover:bg-primary group-hover:text-primary-foreground transition-all duration-300 shrink-0">
                <.icon name={article.icon} size={:sm} />
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-xs text-muted-foreground mb-1.5">
                  {Calendar.strftime(article.date, "%B %d, %Y")}
                </p>
                <h2 class="font-semibold text-foreground text-sm mb-2 group-hover:text-primary transition-colors line-clamp-2">
                  {article.title}
                </h2>
                <p class="text-xs text-muted-foreground leading-relaxed line-clamp-3">
                  {article.summary}
                </p>
              </div>
              <div class="flex items-center gap-1 text-xs font-semibold text-primary mt-4 group-hover:gap-2 transition-all duration-200">
                Read more <.icon name="arrow-right" size={:xs} />
              </div>
            </a>
          <% end %>
        </div>

      </div>
    </Layout.layout>
    """
  end
end
