defmodule PhiaDemoWeb.Demo.AiChatV2.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.AiChatV2.Layout

  @conversations [
    %{id: 1, title: "Elixir GenServer patterns", date: "Today", messages: 12},
    %{id: 2, title: "Phoenix LiveView streams", date: "Yesterday", messages: 8},
    %{id: 3, title: "Tailwind v4 migration", date: "Mar 5", messages: 15},
    %{id: 4, title: "OTP supervision trees", date: "Mar 4", messages: 6},
    %{id: 5, title: "Ecto associations guide", date: "Mar 3", messages: 9}
  ]

  @models [
    %{id: "claude-opus-4-6", label: "Claude Opus 4.6", desc: "Most capable"},
    %{id: "claude-sonnet-4-6", label: "Claude Sonnet 4.6", desc: "Balanced"},
    %{id: "claude-haiku-4-5", label: "Claude Haiku 4.5", desc: "Fastest"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "AI Chat v2")
     |> assign(:conversations, @conversations)
     |> assign(:active_conversation, List.first(@conversations))
     |> assign(:messages, [
         %{id: 1, role: :user, content: "Explain Elixir GenServer patterns"},
         %{id: 2, role: :assistant, content: "GenServer is an OTP behaviour for building stateful server processes. Here are the key patterns:\n\n**1. Basic GenServer**\nUse `start_link/1` and `init/1` to start and initialize state. Use `handle_call/3` for synchronous requests and `handle_cast/2` for async.\n\n**2. Registry Pattern**\nRegister GenServers by name for easy lookup: `{:via, Registry, {MyRegistry, name}}`\n\n**3. Timeout handling**\nReturn `{:reply, response, state, timeout}` to send a `:timeout` message after inactivity.\n\nWould you like to see code examples for any of these patterns?"},
         %{id: 3, role: :user, content: "Yes, show me a Registry example"},
         %{id: 4, role: :assistant, content: "Here's a complete Registry-based GenServer example:\n\n```elixir\ndefmodule MyApp.WorkerRegistry do\n  use GenServer\n\n  def start_link(name) do\n    GenServer.start_link(__MODULE__, %{}, name: via(name))\n  end\n\n  def get_state(name) do\n    GenServer.call(via(name), :get_state)\n  end\n\n  defp via(name) do\n    {:via, Registry, {MyApp.Registry, name}}\n  end\n\n  @impl true\n  def init(state), do: {:ok, state}\n\n  @impl true\n  def handle_call(:get_state, _from, state) do\n    {:reply, state, state}\n  end\nend\n```\n\nStart the registry in your supervision tree and you can spawn named workers on demand!"}
       ])
     |> assign(:input, "")
     |> assign(:model, "claude-sonnet-4-6")
     |> assign(:temperature, 0.7)
     |> assign(:max_tokens, 2048)
     |> assign(:models, @models)}
  end

  @impl true
  def handle_event("select-conversation", %{"id" => id}, socket) do
    conv = Enum.find(socket.assigns.conversations, &(&1.id == String.to_integer(id)))
    {:noreply, assign(socket, :active_conversation, conv)}
  end

  def handle_event("update-input", %{"value" => val}, socket) do
    {:noreply, assign(socket, :input, val)}
  end

  def handle_event("set-model", %{"model" => m}, socket) do
    {:noreply, assign(socket, :model, m)}
  end

  def handle_event("set-temperature", %{"value" => val}, socket) do
    {temp, _} = Float.parse(val)
    {:noreply, assign(socket, :temperature, Float.round(temp, 1))}
  end

  def handle_event("send-message", _params, socket) do
    msg = String.trim(socket.assigns.input)
    if msg == "" do
      {:noreply, socket}
    else
      user_msg = %{id: System.unique_integer([:positive]), role: :user, content: msg}
      ai_msg = %{id: System.unique_integer([:positive]), role: :assistant, content: "This is a demo response using #{socket.assigns.model} (temperature: #{socket.assigns.temperature}). In a real implementation, this would call the Anthropic API with your message: \"#{String.slice(msg, 0, 50)}#{if String.length(msg) > 50, do: "...", else: ""}\""}
      {:noreply,
       socket
       |> update(:messages, &(&1 ++ [user_msg, ai_msg]))
       |> assign(:input, "")}
    end
  end

  def handle_event("new-conversation", _params, socket) do
    new_conv = %{id: System.unique_integer([:positive]), title: "New Conversation", date: "Now", messages: 0}
    {:noreply,
     socket
     |> update(:conversations, &[new_conv | &1])
     |> assign(:active_conversation, new_conv)
     |> assign(:messages, [])}
  end

  @impl true
  def render(assigns) do
    current_model = Enum.find(assigns.models, &(&1.id == assigns.model))
    assigns = assign(assigns, :current_model, current_model)

    ~H"""
    <Layout.layout current_path="/ai-chat-v2">
      <div class="flex h-full phia-animate">

        <%!-- Conversation list --%>
        <div class="hidden md:flex w-64 shrink-0 border-r border-border/60 bg-card/50 flex-col">
          <div class="p-3 border-b border-border/60">
            <.button class="w-full" size={:sm} phx-click="new-conversation">
              <.icon name="plus" size={:xs} class="mr-1.5" />
              New Chat
            </.button>
          </div>
          <div class="flex-1 overflow-y-auto p-2 space-y-0.5">
            <%= for conv <- @conversations do %>
              <button
                phx-click="select-conversation"
                phx-value-id={conv.id}
                class={[
                  "w-full text-left rounded-lg px-3 py-2.5 transition-colors",
                  if(@active_conversation && @active_conversation.id == conv.id,
                    do: "bg-primary/10 text-primary",
                    else: "hover:bg-accent text-foreground"
                  )
                ]}
              >
                <p class="text-sm font-medium truncate">{conv.title}</p>
                <div class="flex items-center gap-2 mt-0.5">
                  <span class="text-[10px] text-muted-foreground">{conv.date}</span>
                  <span class="text-[10px] text-muted-foreground">{conv.messages} msgs</span>
                </div>
              </button>
            <% end %>
          </div>
        </div>

        <%!-- Chat area --%>
        <div class="flex-1 flex flex-col min-w-0">
          <%!-- Header with model info --%>
          <div class="flex items-center justify-between px-3 sm:px-5 py-3 border-b border-border/60 bg-card/30 shrink-0">
            <div>
              <p class="text-sm font-semibold text-foreground">{@active_conversation && @active_conversation.title || "New Chat"}</p>
              <p class="text-xs text-muted-foreground">{@current_model && @current_model.label}</p>
            </div>
            <%!-- Model selector --%>
            <div class="flex items-center gap-2 overflow-x-auto">
              <div class="flex gap-1">
                <%= for m <- @models do %>
                  <button
                    phx-click="set-model"
                    phx-value-model={m.id}
                    class={[
                      "rounded-md px-2.5 py-2 sm:py-1.5 text-xs font-medium border transition-all whitespace-nowrap",
                      if(@model == m.id,
                        do: "bg-primary text-primary-foreground border-primary",
                        else: "border-border text-muted-foreground hover:border-primary/40"
                      )
                    ]}
                    title={m.desc}
                  >
                    {String.split(m.label, " ") |> Enum.at(1)}
                  </button>
                <% end %>
              </div>
            </div>
          </div>

          <%!-- Messages --%>
          <div class="flex-1 overflow-y-auto p-3 sm:p-5 space-y-4 sm:space-y-5">
            <%= for msg <- @messages do %>
              <div class={["flex gap-3 max-w-3xl mx-auto w-full", if(msg.role == :user, do: "flex-row-reverse", else: "")]}>
                <div class={[
                  "flex h-8 w-8 shrink-0 items-center justify-center rounded-full text-xs font-semibold",
                  if(msg.role == :user, do: "bg-primary text-primary-foreground", else: "bg-muted text-foreground")
                ]}>
                  {if msg.role == :user, do: "ME", else: "AI"}
                </div>
                <div class={[
                  "flex-1 rounded-2xl px-4 py-3 text-sm leading-relaxed",
                  if(msg.role == :user,
                    do: "bg-primary text-primary-foreground rounded-tr-sm max-w-[85%] sm:max-w-[70%] ml-auto",
                    else: "bg-muted text-foreground rounded-tl-sm"
                  )
                ]}>
                  {msg.content}
                </div>
              </div>
            <% end %>
          </div>

          <%!-- Input --%>
          <div class="shrink-0 border-t border-border/60 bg-background p-3 sm:p-4">
            <div class="max-w-3xl mx-auto space-y-3">
              <%!-- Temperature control --%>
              <div class="flex flex-wrap sm:flex-nowrap items-center gap-2 sm:gap-3 text-xs text-muted-foreground">
                <span class="whitespace-nowrap">Temperature: {@temperature}</span>
                <input
                  type="range"
                  min="0"
                  max="1"
                  step="0.1"
                  value={@temperature}
                  phx-change="set-temperature"
                  name="value"
                  class="flex-1 h-1.5 accent-primary"
                />
                <span>Max tokens: {@max_tokens}</span>
              </div>
              <form phx-submit="send-message" class="flex gap-2">
                <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />
                <textarea
                  phx-keyup="update-input"
                  rows={2}
                  placeholder="Ask anything..."
                  class="flex-1 rounded-xl border border-border bg-background px-4 py-3 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-primary/40 transition-all"
                >{@input}</textarea>
                <.button type="submit" class="rounded-xl self-end h-12 w-12 p-0 shrink-0" aria-label="Send message">
                  <.icon name="send" size={:sm} />
                </.button>
              </form>
            </div>
          </div>
        </div>

        <%!-- Settings panel --%>
        <div class="hidden lg:block w-56 shrink-0 border-l border-border/60 bg-card/50 p-4 space-y-5">
          <div>
            <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60 mb-3">Model Settings</p>
            <div class="space-y-4">
              <div>
                <p class="text-xs font-medium text-foreground mb-1.5">Temperature</p>
                <p class="text-xs text-muted-foreground mb-2">Controls randomness ({@temperature})</p>
                <.progress value={trunc(@temperature * 100)} class="h-1.5" />
              </div>
              <.separator />
              <div>
                <p class="text-xs font-medium text-foreground mb-1">Context</p>
                <div class="space-y-1">
                  <div class="flex justify-between text-xs">
                    <span class="text-muted-foreground">Messages</span>
                    <span class="font-medium text-foreground">{length(@messages)}</span>
                  </div>
                  <div class="flex justify-between text-xs">
                    <span class="text-muted-foreground">Max tokens</span>
                    <span class="font-medium text-foreground">{@max_tokens}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </Layout.layout>
    """
  end
end
