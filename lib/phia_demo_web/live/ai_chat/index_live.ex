defmodule PhiaDemoWeb.Demo.AiChat.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.AiChat.Layout

  @suggestions [
    "Explain Phoenix LiveView streams",
    "How does Elixir pattern matching work?",
    "Best practices for Tailwind CSS v4",
    "What are OTP behaviours?"
  ]

  @mock_responses %{
    "explain phoenix liveview streams" => "Phoenix LiveView Streams are an optimization feature for efficiently handling large, dynamic lists. Instead of sending the entire list on every update, Streams only send the diff — what was added, removed, or changed. This dramatically reduces bandwidth and improves performance for long lists.\n\nKey benefits:\n- Server-side state management\n- Minimal data transfer\n- Automatic DOM reconciliation\n- Works great with pagination",
    "how does elixir pattern matching work?" => "Pattern matching in Elixir is one of its most powerful features. The `=` operator isn't just assignment — it's a match operator.\n\nExamples:\n```elixir\n{a, b, c} = {1, 2, 3}  # a=1, b=2, c=3\n[head | tail] = [1, 2, 3]  # head=1, tail=[2,3]\n%{name: name} = %{name: \"Alice\"}  # name=\"Alice\"\n```\n\nPattern matching is used in function clauses, case expressions, and with statements throughout Elixir code.",
    "default" => "That's a great question! As a demo AI assistant, I'd normally provide a thoughtful response here. In a real implementation, this would call an actual AI API like the Anthropic Claude API to generate contextual, helpful responses based on your input.\n\nThis demo showcases the chat UI components: message bubbles, typing indicators, suggestions, and the overall chat interface pattern built with PhiaUI components."
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "AI Chat")
     |> assign(:messages, [])
     |> assign(:input, "")
     |> assign(:typing, false)
     |> assign(:suggestions, @suggestions)}
  end

  @impl true
  def handle_event("send-message", %{"message" => msg}, socket) when msg != "" do
    user_msg = %{id: System.unique_integer([:positive]), role: :user, content: msg, time: "now"}
    socket = socket
      |> update(:messages, &(&1 ++ [user_msg]))
      |> assign(:input, "")
      |> assign(:typing, true)
    {:noreply, socket |> push_event("phx:scroll-to-bottom", %{})}
  end

  def handle_event("send-message", _params, socket), do: {:noreply, socket}

  def handle_event("update-input", %{"value" => val}, socket) do
    {:noreply, assign(socket, :input, val)}
  end

  def handle_event("use-suggestion", %{"text" => text}, socket) do
    user_msg = %{id: System.unique_integer([:positive]), role: :user, content: text, time: "now"}
    socket = socket
      |> update(:messages, &(&1 ++ [user_msg]))
      |> assign(:typing, true)
    Process.send_after(self(), {:ai_response, text}, 1500)
    {:noreply, socket}
  end

  def handle_event("clear-chat", _params, socket) do
    {:noreply, assign(socket, messages: [], typing: false)}
  end

  @impl true
  def handle_info({:ai_response, prompt}, socket) do
    key = String.downcase(prompt)
    response = Map.get(@mock_responses, key, @mock_responses["default"])
    ai_msg = %{id: System.unique_integer([:positive]), role: :assistant, content: response, time: "now"}
    {:noreply, socket |> update(:messages, &(&1 ++ [ai_msg])) |> assign(:typing, false)}
  end

  def handle_info({:send_response, msg}, socket) do
    ai_msg = %{id: System.unique_integer([:positive]), role: :assistant, content: msg, time: "now"}
    {:noreply, socket |> update(:messages, &(&1 ++ [ai_msg])) |> assign(:typing, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/ai-chat">
      <div class="flex flex-col h-full bg-background phia-animate">

        <%!-- Chat header --%>
        <div class="flex items-center justify-between px-3 sm:px-5 py-3 border-b border-border/60 bg-card/40 backdrop-blur shrink-0">
          <div class="flex items-center gap-3">
            <div class="relative">
              <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-primary to-primary/70 text-primary-foreground shadow-sm">
                <.icon name="message-square" size={:xs} />
              </div>
              <span class="absolute -bottom-0.5 -right-0.5 h-2.5 w-2.5 rounded-full bg-green-500 ring-2 ring-background" />
            </div>
            <div>
              <p class="text-sm font-bold text-foreground">Claude</p>
              <p class="text-[10px] text-muted-foreground leading-none">Anthropic · claude-sonnet-4-6</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <.badge variant={:secondary} class="text-[10px] hidden sm:flex">Demo mode</.badge>
            <button
              phx-click="clear-chat"
              class="p-2 rounded-lg text-muted-foreground hover:bg-accent hover:text-foreground transition-colors"
              title="Clear chat"
              aria-label="Clear chat"
            >
              <.icon name="trash-2" size={:xs} />
            </button>
          </div>
        </div>

        <%!-- Messages area --%>
        <div class="flex-1 overflow-y-auto">
          <%!-- Welcome / empty state --%>
          <%= if @messages == [] do %>
            <div class="flex flex-col items-center justify-center h-full gap-8 text-center px-6 py-12">
              <%!-- Animated icon --%>
              <div class="relative">
                <div class="flex h-20 w-20 items-center justify-center rounded-3xl bg-gradient-to-br from-primary/20 to-primary/5 ring-1 ring-primary/20">
                  <.icon name="message-square" class="text-primary h-8 w-8" />
                </div>
                <div class="absolute -right-1 -top-1 h-5 w-5 rounded-full bg-green-500 ring-2 ring-background flex items-center justify-center">
                  <.icon name="check" size={:xs} class="text-white" />
                </div>
              </div>
              <div class="max-w-sm">
                <h2 class="text-xl sm:text-2xl font-bold text-foreground">How can I help?</h2>
                <p class="text-muted-foreground mt-2 text-sm leading-relaxed">
                  Ask me anything about Elixir, Phoenix LiveView, or web development.
                  Select a suggestion below to get started.
                </p>
              </div>
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5 max-w-lg w-full">
                <%= for suggestion <- @suggestions do %>
                  <button
                    phx-click="use-suggestion"
                    phx-value-text={suggestion}
                    class="group rounded-xl border border-border/60 bg-card p-4 text-left transition-all duration-200 hover:border-primary/40 hover:bg-primary/5 hover:shadow-sm"
                  >
                    <div class="flex items-start gap-2.5">
                      <div class="h-1.5 w-1.5 rounded-full bg-primary mt-1.5 shrink-0 group-hover:scale-125 transition-transform" />
                      <span class="text-sm text-foreground font-medium leading-snug">{suggestion}</span>
                    </div>
                  </button>
                <% end %>
              </div>
            </div>
          <% else %>
            <div class="py-4 sm:py-6 px-3 sm:px-4 space-y-4 sm:space-y-6 max-w-3xl mx-auto w-full">
              <%= for msg <- @messages do %>
                <div class={["flex items-end gap-3", if(msg.role == :user, do: "flex-row-reverse", else: "")]}>
                  <%!-- Avatar --%>
                  <div class={[
                    "flex h-8 w-8 shrink-0 items-center justify-center rounded-full text-[10px] font-bold ring-2 ring-background",
                    if(msg.role == :user,
                      do: "bg-primary text-primary-foreground",
                      else: "bg-gradient-to-br from-primary/30 to-primary/10 text-primary"
                    )
                  ]}>
                    {if msg.role == :user, do: "You", else: "AI"}
                  </div>
                  <%!-- Bubble --%>
                  <div class={[
                    "rounded-2xl px-4 py-3 max-w-[75%] text-sm leading-relaxed shadow-sm",
                    if(msg.role == :user,
                      do: "bg-primary text-primary-foreground rounded-br-sm",
                      else: "bg-card border border-border/60 text-foreground rounded-bl-sm"
                    )
                  ]}>
                    <p class="whitespace-pre-wrap">{msg.content}</p>
                  </div>
                </div>
              <% end %>

              <%!-- Typing indicator --%>
              <div :if={@typing} class="flex items-end gap-3">
                <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-primary/30 to-primary/10 text-[10px] font-bold text-primary ring-2 ring-background">
                  AI
                </div>
                <div class="rounded-2xl rounded-bl-sm bg-card border border-border/60 px-4 py-3 shadow-sm">
                  <.typing_indicator size={:md} />
                </div>
              </div>
            </div>
          <% end %>
        </div>

        <%!-- Input area --%>
        <div class="shrink-0 border-t border-border/60 bg-background/95 backdrop-blur px-3 sm:px-4 py-3 sm:py-4">
          <div class="max-w-3xl mx-auto">
            <form phx-submit="send-message" class="flex gap-2.5 items-end">
              <input type="hidden" name="message" value={@input} />
              <div class="flex-1 relative">
                <textarea
                  phx-keyup="update-input"
                  phx-key="Enter"
                  rows={1}
                  placeholder="Message Claude..."
                  class="w-full rounded-2xl border border-border bg-card px-4 py-3 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary/40 transition-all shadow-sm"
                  style="min-height: 48px; max-height: 160px;"
                >{@input}</textarea>
              </div>
              <.button type="submit" class="h-12 w-12 rounded-2xl shrink-0 p-0 shadow-sm" aria-label="Send message">
                <.icon name="send" size={:xs} />
              </.button>
            </form>
            <p class="text-[10px] text-muted-foreground/50 text-center mt-2.5">
              Demo · Responses are pre-programmed · Use Anthropic SDK for real AI
            </p>
          </div>
        </div>

      </div>
    </Layout.layout>
    """
  end
end
