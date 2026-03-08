defmodule PhiaDemoWeb.Demo.Social.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Social.Layout

  @posts [
    %{id: 1, author: "Ana Costa", handle: "@ana_costa", avatar: "AC", time: "2 min ago", content: "Just published a new article on Phoenix LiveView real-time features! The combination of PubSub and LiveView streams makes building collaborative UIs incredibly smooth. Check it out! 🚀", likes: 42, comments: 8, liked: false, tags: ["elixir", "phoenix"]},
    %{id: 2, author: "Bruno Lima", handle: "@brunolima", avatar: "BL", time: "1 hour ago", content: "Hot take: Tailwind CSS v4 with CSS-first configuration is the best thing to happen to frontend development this year. No more config file wrangling — just write CSS with superpowers.", likes: 87, comments: 23, liked: true, tags: ["tailwind", "css"]},
    %{id: 3, author: "Carla Souza", handle: "@carla_dev", avatar: "CS", time: "3 hours ago", content: "Working on PhiaUI — a comprehensive Phoenix LiveView component library. 584+ components, zero JavaScript dependencies for most features. Server-rendered and proud of it! Who else is building with LiveView?", likes: 156, comments: 41, liked: false, tags: ["phiaui", "elixir", "liveview"]},
    %{id: 4, author: "Diego Melo", handle: "@diegomelo", avatar: "DM", time: "Yesterday", content: "Reminder that pattern matching in Elixir is genuinely one of the most powerful programming features ever designed. Writing code that reads like a specification is pure joy.", likes: 203, comments: 19, liked: false, tags: ["elixir", "functional"]},
    %{id: 5, author: "Elena Rocha", handle: "@elena_tech", avatar: "ER", time: "Yesterday", content: "Dark mode done right: CSS custom properties + a single .dark class toggle on the root element. No JavaScript frameworks needed. This is the way.", likes: 324, comments: 67, liked: true, tags: ["darkmode", "css"]}
  ]

  @trending [
    %{tag: "elixir", count: "12.4k"},
    %{tag: "phoenix", count: "8.1k"},
    %{tag: "liveview", count: "5.7k"},
    %{tag: "tailwind", count: "15.2k"},
    %{tag: "phiaui", count: "2.3k"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Social")
     |> assign(:posts, @posts)
     |> assign(:trending, @trending)
     |> assign(:compose_open, false)}
  end

  @impl true
  def handle_event("like-post", %{"id" => id}, socket) do
    post_id = String.to_integer(id)
    posts = Enum.map(socket.assigns.posts, fn p ->
      if p.id == post_id do
        if p.liked,
          do: %{p | liked: false, likes: p.likes - 1},
          else: %{p | liked: true, likes: p.likes + 1}
      else
        p
      end
    end)
    {:noreply, assign(socket, :posts, posts)}
  end

  def handle_event("compose", _params, socket) do
    {:noreply, assign(socket, :compose_open, true)}
  end

  def handle_event("close-compose", _params, socket) do
    {:noreply, assign(socket, :compose_open, false)}
  end

  def handle_event("publish-post", _params, socket) do
    {:noreply, assign(socket, :compose_open, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/social">
      <div class="flex gap-6 p-3 sm:p-4 lg:p-6 max-w-screen-xl mx-auto phia-animate">

        <%!-- Main feed --%>
        <div class="flex-1 min-w-0 space-y-4">
          <%!-- Compose bar --%>
          <div class="flex gap-3 rounded-xl border border-border/60 bg-card p-3 sm:p-4 shadow-sm">
            <.avatar size="default">
              <.avatar_fallback name="Me" class="bg-primary/10 text-primary font-semibold" />
            </.avatar>
            <button
              phx-click="compose"
              class="flex-1 rounded-lg border border-border bg-muted px-4 py-2.5 text-sm text-muted-foreground text-left hover:border-primary/40 hover:bg-accent transition-colors"
            >
              What's on your mind?
            </button>
            <.button phx-click="compose">
              <.icon name="pencil" size={:xs} class="mr-1.5" />
              Post
            </.button>
          </div>

          <%!-- Posts --%>
          <%= for post <- @posts do %>
            <.card class="border-border/60 shadow-sm hover:shadow-md transition-shadow">
              <.card_content class="p-3 sm:p-5">
                <div class="flex items-start gap-3">
                  <.avatar size="default" class="shrink-0">
                    <.avatar_fallback name={post.author} class="bg-primary/10 text-primary font-semibold" />
                  </.avatar>
                  <div class="flex-1 min-w-0">
                    <div class="flex items-start justify-between gap-2">
                      <div>
                        <span class="text-sm font-semibold text-foreground">{post.author}</span>
                        <span class="text-xs text-muted-foreground ml-1.5">{post.handle}</span>
                      </div>
                      <span class="text-xs text-muted-foreground shrink-0">{post.time}</span>
                    </div>
                    <p class="text-sm text-foreground/90 mt-2 leading-relaxed">{post.content}</p>
                    <div class="flex flex-wrap gap-1.5 mt-3">
                      <%= for tag <- post.tags do %>
                        <span class="text-xs font-medium text-primary">#<%= tag %></span>
                      <% end %>
                    </div>
                    <div class="flex items-center gap-4 mt-4 pt-3 border-t border-border/40">
                      <button
                        phx-click="like-post"
                        phx-value-id={post.id}
                        class={["flex items-center gap-1.5 text-sm transition-colors", if(post.liked, do: "text-primary font-semibold", else: "text-muted-foreground hover:text-primary")]}
                      >
                        <.icon name={if post.liked, do: "circle-check", else: "circle-arrow-up"} size={:sm} />
                        {post.likes}
                      </button>
                      <button class="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors">
                        <.icon name="message-circle" size={:sm} />
                        {post.comments}
                      </button>
                      <button class="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors ml-auto">
                        <.icon name="send" size={:sm} />
                        Share
                      </button>
                    </div>
                  </div>
                </div>
              </.card_content>
            </.card>
          <% end %>
        </div>

        <%!-- Sidebar --%>
        <div class="hidden lg:block w-72 shrink-0 space-y-5">
          <%!-- Trending --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-3">
              <.card_title class="text-base">Trending Topics</.card_title>
            </.card_header>
            <.card_content class="pt-0">
              <div class="space-y-2">
                <%= for {topic, idx} <- Enum.with_index(@trending, 1) do %>
                  <div class="flex items-center justify-between py-1.5 hover:bg-accent rounded-md px-2 -mx-2 transition-colors cursor-pointer">
                    <div>
                      <p class="text-[10px] text-muted-foreground/60">#<%= idx %> trending</p>
                      <p class="text-sm font-semibold text-foreground">#{topic.tag}</p>
                    </div>
                    <span class="text-xs text-muted-foreground">{topic.count} posts</span>
                  </div>
                <% end %>
              </div>
            </.card_content>
          </.card>

          <%!-- Suggested accounts --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-3">
              <.card_title class="text-base">Who to Follow</.card_title>
            </.card_header>
            <.card_content class="pt-0">
              <div class="space-y-3">
                <%= for {name, handle, initials} <- [{"José Valim", "@josevalim", "JV"}, {"Chris McCord", "@chris_mccord", "CM"}, {"Dashbit Team", "@dashbit", "DB"}] do %>
                  <div class="flex items-center gap-3">
                    <.avatar size="sm">
                      <.avatar_fallback name={name} class="bg-primary/10 text-primary text-xs font-semibold" />
                    </.avatar>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-semibold text-foreground truncate">{name}</p>
                      <p class="text-xs text-muted-foreground truncate">{handle}</p>
                    </div>
                    <.button variant={:outline} size={:sm} class="shrink-0 text-xs">Follow</.button>
                  </div>
                <% end %>
              </div>
            </.card_content>
          </.card>
        </div>

      </div>

      <%!-- Compose dialog --%>
      <.alert_dialog id="compose-post" open={@compose_open}>
        <.alert_dialog_header>
          <.alert_dialog_title>Create Post</.alert_dialog_title>
        </.alert_dialog_header>
        <div class="flex gap-3 p-1">
          <.avatar size="default" class="shrink-0">
            <.avatar_fallback name="Me" class="bg-primary/10 text-primary font-semibold" />
          </.avatar>
          <textarea
            rows={5}
            placeholder="What's on your mind?"
            class="flex-1 rounded-lg border border-border bg-background px-3 py-2 text-sm resize-none focus:outline-none focus:ring-1 focus:ring-primary/40"
          ></textarea>
        </div>
        <.alert_dialog_footer>
          <.alert_dialog_cancel phx-click="close-compose">Cancel</.alert_dialog_cancel>
          <.alert_dialog_action phx-click="publish-post">Publish</.alert_dialog_action>
        </.alert_dialog_footer>
      </.alert_dialog>
    </Layout.layout>
    """
  end
end
