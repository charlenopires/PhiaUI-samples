defmodule PhiaDemoWeb.Demo.Chat.Layout do
  @moduledoc "Chat app shell — sales-style with 3 rooms."

  use Phoenix.Component

  import PhiaUi.Components.Icon
  import PhiaUi.Components.Avatar
  import PhiaDemoWeb.ProjectNav

  attr :rooms, :list, required: true
  attr :current_room_id, :string, required: true
  attr :users, :list, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <div class="flex flex-col h-screen overflow-hidden bg-background">
      <%!-- Top navigation bar --%>
      <header class="flex items-center h-14 px-4 border-b border-border/60 bg-background shrink-0">
        <.project_topbar current_project={:chat} dark_mode_id="chat-dm" />
      </header>

      <%!-- Body: sidebar + content --%>
      <div class="flex flex-1 min-h-0 overflow-hidden">
        <%!-- Sidebar --%>
        <aside class="hidden md:flex flex-col w-60 shrink-0 border-r border-border/60 bg-sidebar">
          <%!-- Brand --%>
          <div class="flex items-center gap-2.5 px-4 py-3 border-b border-border/40">
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm shrink-0">
              <.icon name="message-circle" size={:xs} />
            </div>
            <div class="min-w-0">
              <span class="text-sm font-bold text-foreground leading-none">Sales Chat</span>
              <p class="text-[10px] text-muted-foreground leading-none mt-0.5">Live Support · PhiaUI</p>
            </div>
          </div>

          <div class="flex-1 overflow-y-auto py-3 space-y-5">
            <%!-- Rooms --%>
            <div>
              <p class="px-4 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
                Conversations
              </p>
              <%= for room <- @rooms do %>
                <a
                  href={"/chat/#{room.id}"}
                  class={[
                    "flex items-center gap-2.5 px-3 py-2 mx-1 rounded-lg transition-colors",
                    if(room.id == @current_room_id,
                      do: "bg-primary/10 text-primary",
                      else: "text-muted-foreground hover:bg-accent hover:text-foreground"
                    )
                  ]}
                >
                  <div class={[
                    "flex h-7 w-7 items-center justify-center rounded-md shrink-0",
                    if(room.id == @current_room_id, do: "bg-primary/20", else: "bg-muted")
                  ]}>
                    <.icon name={room.icon} size={:xs} />
                  </div>
                  <div class="min-w-0">
                    <p class={["text-sm leading-none mb-0.5", if(room.id == @current_room_id, do: "font-semibold", else: "font-medium")]}>{room.name}</p>
                    <p class="text-[10px] text-muted-foreground/70 truncate">{room.description}</p>
                  </div>
                </a>
              <% end %>
            </div>

            <%!-- Agents online --%>
            <div>
              <p class="px-4 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
                Agents
              </p>
              <%= for user <- Enum.reject(@users, &(&1.id == "you")) do %>
                <div class="flex items-center gap-2.5 px-3 py-1.5 mx-1">
                  <div class="relative shrink-0">
                    <.avatar size="sm">
                      <.avatar_fallback name={user.name} class="bg-primary/10 text-primary text-xs font-semibold" />
                    </.avatar>
                    <span class={[
                      "absolute -bottom-0.5 -right-0.5 h-2 w-2 rounded-full ring-1 ring-background",
                      case user.status do
                        :online -> "bg-success"
                        :away -> "bg-warning"
                        :offline -> "bg-muted-foreground"
                      end
                    ]} />
                  </div>
                  <div class="min-w-0">
                    <p class="text-sm font-medium text-foreground truncate leading-none mb-0.5">{user.name}</p>
                    <p class="text-[10px] text-muted-foreground/70 truncate">{user.role}</p>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </aside>

        <%!-- Main content --%>
        <div class="flex flex-col flex-1 min-w-0">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
