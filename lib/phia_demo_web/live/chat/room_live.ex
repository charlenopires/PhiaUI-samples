defmodule PhiaDemoWeb.Demo.Chat.RoomLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.{FakeData, ChatStore}
  alias PhiaDemoWeb.Demo.Chat.Layout

  @current_user_id "you"

  @room_agents %{
    "products" => "sofia",
    "order" => "marcos",
    "survey" => "sofia"
  }

  @quick_emojis ["👍", "❤️", "😂", "🎉", "😮", "🙏"]

  @impl true
  def mount(params, _session, socket) do
    rooms = FakeData.chat_rooms()
    users = FakeData.chat_users()
    room_id = Map.get(params, "room_id", "products")

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhiaDemo.PubSub, "chat:room:#{room_id}")
    end

    messages = ChatStore.get_messages(room_id)
    typing = ChatStore.get_typing(room_id)
    current_user = Enum.find(users, &(&1.id == @current_user_id))

    {:ok,
     socket
     |> assign(:page_title, room_label(rooms, room_id))
     |> assign(:rooms, rooms)
     |> assign(:users, users)
     |> assign(:room_id, room_id)
     |> assign(:messages, messages)
     |> assign(:typing, typing)
     |> assign(:input_text, "")
     |> assign(:reply_to, nil)
     |> assign(:email_input, "")
     |> assign(:quick_emojis, @quick_emojis)
     |> assign(:current_user_id, @current_user_id)
     |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    room_id = Map.get(params, "room_id", "products")

    if connected?(socket) and room_id != socket.assigns[:room_id] do
      old_room = socket.assigns[:room_id]
      if old_room, do: Phoenix.PubSub.unsubscribe(PhiaDemo.PubSub, "chat:room:#{old_room}")
      Phoenix.PubSub.subscribe(PhiaDemo.PubSub, "chat:room:#{room_id}")
      ChatStore.set_typing(old_room || room_id, @current_user_id, false)
    end

    messages = ChatStore.get_messages(room_id)
    typing = ChatStore.get_typing(room_id)

    {:noreply,
     socket
     |> assign(:room_id, room_id)
     |> assign(:messages, messages)
     |> assign(:typing, typing)
     |> assign(:reply_to, nil)
     |> assign(:email_input, "")
     |> assign(:page_title, room_label(socket.assigns.rooms, room_id))}
  end

  # ── Events ────────────────────────────────────────────────────────────────

  @impl true
  def handle_event("typing", %{"value" => text}, socket) do
    room_id = socket.assigns.room_id
    was_typing = socket.assigns.input_text != ""
    is_typing = text != ""

    if is_typing != was_typing do
      ChatStore.set_typing(room_id, @current_user_id, is_typing)
    end

    {:noreply, assign(socket, :input_text, text)}
  end

  def handle_event("send_message", %{"text" => text}, socket) do
    text = String.trim(text)

    if text != "" do
      reply_to = socket.assigns.reply_to

      msg = %{
        id: "msg_#{:erlang.unique_integer([:positive])}",
        user_id: @current_user_id,
        text: text,
        timestamp: format_time(),
        reactions: %{},
        type: :text,
        reply_to: if(reply_to, do: reply_to.id, else: nil),
        read: false
      }

      ChatStore.set_typing(socket.assigns.room_id, @current_user_id, false)
      ChatStore.add_message(socket.assigns.room_id, msg)
    end

    {:noreply, socket |> assign(:input_text, "") |> assign(:reply_to, nil)}
  end

  def handle_event("react", %{"msg_id" => msg_id, "emoji" => emoji}, socket) do
    ChatStore.add_reaction(socket.assigns.room_id, msg_id, emoji, @current_user_id)
    {:noreply, socket}
  end

  def handle_event("vote_poll", %{"msg_id" => msg_id, "option_idx" => idx_str}, socket) do
    ChatStore.vote_poll(socket.assigns.room_id, msg_id, String.to_integer(idx_str), @current_user_id)
    {:noreply, socket}
  end

  def handle_event("quick_reply", %{"msg_id" => msg_id, "value" => value}, socket) do
    room_id = socket.assigns.room_id
    ChatStore.update_message(room_id, msg_id, %{answered: true, answer: value})

    agent_id = Map.get(@room_agents, room_id, "sofia")

    response =
      if value == "yes" do
        "Great choice! I'll send you more details about this product. Would you prefer to complete the order online or would you like me to help you right now?"
      else
        "No problem! We have many other options. Would you like to see more models with different prices and configurations?"
      end

    schedule_agent_response(room_id, agent_id, response, 2000)
    {:noreply, socket}
  end

  def handle_event("update_email_input", %{"value" => val}, socket) do
    {:noreply, assign(socket, :email_input, val)}
  end

  def handle_event("submit_email", %{"msg_id" => msg_id}, socket) do
    email = String.trim(socket.assigns.email_input)

    if email != "" and String.contains?(email, "@") do
      room_id = socket.assigns.room_id
      ChatStore.update_message(room_id, msg_id, %{answered: true, email: email})
      agent_id = Map.get(@room_agents, room_id, "marcos")

      schedule_agent_response(
        room_id,
        agent_id,
        "Email received! Our sales team will contact #{email} within 24 hours with your personalized proposal.",
        1500
      )

      {:noreply, assign(socket, :email_input, "")}
    else
      {:noreply, socket}
    end
  end

  def handle_event("select_day", %{"msg_id" => msg_id, "day" => day}, socket) do
    room_id = socket.assigns.room_id
    ChatStore.update_message(room_id, msg_id, %{answered: true, selected_day: day})
    agent_id = Map.get(@room_agents, room_id, "marcos")

    schedule_agent_response(
      room_id,
      agent_id,
      "Demo scheduled for #{day}! You'll receive an email with all the details. See you soon!",
      1500
    )

    {:noreply, socket}
  end

  def handle_event("nps_score", %{"msg_id" => msg_id, "score" => score_str}, socket) do
    score = String.to_integer(score_str)
    room_id = socket.assigns.room_id
    ChatStore.update_message(room_id, msg_id, %{answered: true, selected_score: score})
    agent_id = Map.get(@room_agents, room_id, "sofia")

    response =
      cond do
        score >= 9 ->
          "Amazing! Thanks for the #{score}/10! It's so rewarding to know you'd recommend us. Your support means a lot!"

        score >= 7 ->
          "Thanks for the #{score}/10! We'll keep working to make your experience even better."

        true ->
          "Thanks for your honesty. A score of #{score} shows us there's room to improve. Could you share what we could do better?"
      end

    schedule_agent_response(room_id, agent_id, response, 1800)
    {:noreply, socket}
  end

  def handle_event("reply_to_msg", %{"msg_id" => msg_id}, socket) do
    msg = Enum.find(socket.assigns.messages, &(&1.id == msg_id))

    if msg do
      user = Enum.find(socket.assigns.users, &(&1.id == msg.user_id))
      reply = %{id: msg_id, text: preview_text(msg), user_name: if(user, do: user.name, else: msg.user_id)}
      {:noreply, assign(socket, :reply_to, reply)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("cancel_reply", _, socket) do
    {:noreply, assign(socket, :reply_to, nil)}
  end

  # ── PubSub handlers ────────────────────────────────────────────────────────

  @impl true
  def handle_info({:new_message, _msg}, socket) do
    messages = ChatStore.get_messages(socket.assigns.room_id)
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_info({:message_updated, _msg}, socket) do
    messages = ChatStore.get_messages(socket.assigns.room_id)
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_info({:reaction_updated, _msg}, socket) do
    messages = ChatStore.get_messages(socket.assigns.room_id)
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_info({:typing_update, users}, socket) do
    {:noreply, assign(socket, :typing, users)}
  end

  def handle_info({:poll_updated, _msg}, socket) do
    messages = ChatStore.get_messages(socket.assigns.room_id)
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_info({:agent_typing_start, room_id, agent_id}, socket) do
    if room_id == socket.assigns.room_id do
      ChatStore.set_typing(room_id, agent_id, true)
    end

    {:noreply, socket}
  end

  def handle_info({:auto_respond, room_id, agent_id, text}, socket) do
    if room_id == socket.assigns.room_id do
      ChatStore.set_typing(room_id, agent_id, false)

      msg = %{
        id: "auto_#{:erlang.unique_integer([:positive])}",
        user_id: agent_id,
        text: text,
        timestamp: format_time(),
        reactions: %{},
        type: :text,
        reply_to: nil,
        read: true
      }

      ChatStore.add_message(room_id, msg)
    end

    {:noreply, socket}
  end

  # ── Render ─────────────────────────────────────────────────────────────────

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout rooms={@rooms} current_room_id={@room_id} users={@users}>
      <% agent = room_agent(@users, @room_id) %>

      <%!-- Topbar --%>
      <div class="flex items-center gap-3 px-4 h-14 border-b border-border/60 bg-background shrink-0">
        <div class="flex items-center gap-2.5">
          <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary shrink-0">
            <.icon name={room_icon(@room_id)} size={:xs} />
          </div>
          <div>
            <span class="font-semibold text-foreground text-sm">{room_label(@rooms, @room_id)}</span>
            <%= if agent do %>
              <p class="text-[10px] text-muted-foreground leading-none mt-0.5 flex items-center gap-1">
                <span class="inline-block h-1.5 w-1.5 rounded-full bg-success" />
                {agent.name} · online agora
              </p>
            <% end %>
          </div>
        </div>

        <div class="ml-auto flex items-center gap-2">
          <.dark_mode_toggle id="chat-theme-toggle" />
          <div class="hidden sm:flex items-center gap-2 border-l border-border/60 pl-3 ml-1">
            <.avatar size="sm" class="ring-2 ring-primary/20">
              <.avatar_fallback name={@current_user.name} class="bg-primary/10 text-primary text-xs font-semibold" />
            </.avatar>
            <span class="text-sm font-medium text-foreground">{@current_user.name}</span>
          </div>
        </div>
      </div>

      <%!-- Messages area --%>
      <div id="chat-messages" class="flex-1 overflow-y-auto overflow-x-auto px-3 sm:px-4 lg:px-6 py-3 sm:py-4 space-y-3" phx-update="replace" aria-live="polite" role="log" aria-label="Chat messages">
        <%= for msg <- @messages do %>
          <% user = Enum.find(@users, &(&1.id == msg.user_id)) %>
          <% is_me = msg.user_id == @current_user_id %>

          <%= if msg.type == :system do %>
            <%!-- System message --%>
            <div class="chat-msg-enter flex items-center justify-center py-1">
              <span class="px-3 py-1 rounded-full bg-muted text-[10px] text-muted-foreground font-medium">
                {msg.text}
              </span>
            </div>
          <% else %>
            <div id={"msg-#{msg.id}"} class={["chat-msg-enter flex gap-2.5 group", if(is_me, do: "flex-row-reverse", else: "")]}>

              <%!-- Avatar with online dot --%>
              <div class="shrink-0 mt-0.5 relative">
                <.avatar size="sm">
                  <.avatar_fallback
                    name={if user, do: user.name, else: "?"}
                    class="bg-primary/10 text-primary text-xs font-semibold"
                  />
                </.avatar>
                <%= if user && user.status == :online do %>
                  <span class="absolute -bottom-0.5 -right-0.5 h-2 w-2 rounded-full bg-success ring-1 ring-background" />
                <% end %>
              </div>

              <div class={["max-w-[75%] flex flex-col gap-1", if(is_me, do: "items-end", else: "items-start")]}>

                <%!-- Sender name + time --%>
                <div class={["flex items-baseline gap-2", if(is_me, do: "flex-row-reverse", else: "")]}>
                  <span class="text-xs font-semibold text-foreground">
                    {if user, do: user.name, else: msg.user_id}
                  </span>
                  <span class="text-[10px] text-muted-foreground">{msg.timestamp}</span>
                </div>

                <%!-- Reply preview --%>
                <%= if Map.get(msg, :reply_to) do %>
                  <% replied = Enum.find(@messages, &(&1.id == msg.reply_to)) %>
                  <%= if replied do %>
                    <% replied_user = Enum.find(@users, &(&1.id == replied.user_id)) %>
                    <div class="px-2.5 py-1.5 rounded-lg border-l-2 border-primary/40 bg-muted/60 text-xs text-muted-foreground max-w-full">
                      <span class="font-semibold text-foreground">
                        {if replied_user, do: replied_user.name, else: replied.user_id}:
                      </span>
                      {preview_text(replied)}
                    </div>
                  <% end %>
                <% end %>

                <%!-- Message content --%>
                <%= case msg.type do %>
                  <% :product_card -> %>
                    <.product_card_bubble msg={msg} />
                  <% :email_form -> %>
                    <.email_form_bubble msg={msg} email_input={@email_input} />
                  <% :booking -> %>
                    <.booking_bubble msg={msg} />
                  <% :nps -> %>
                    <.nps_bubble msg={msg} />
                  <% :poll -> %>
                    <.poll_bubble msg={msg} current_user_id={@current_user_id} />
                  <% _ -> %>
                    <div class={[
                      "rounded-2xl px-3.5 py-2 text-sm leading-relaxed",
                      if(is_me,
                        do: "bg-primary text-primary-foreground rounded-tr-sm",
                        else: "bg-muted text-foreground rounded-tl-sm"
                      )
                    ]}>
                      {msg.text}
                    </div>
                <% end %>

                <%!-- Reactions --%>
                <%= if Map.get(msg, :reactions, %{}) != %{} do %>
                  <div class="flex flex-wrap gap-1 mt-0.5">
                    <%= for {emoji, user_ids} <- msg.reactions do %>
                      <button
                        type="button"
                        phx-click="react"
                        phx-value-msg_id={msg.id}
                        phx-value-emoji={emoji}
                        class={[
                          "inline-flex items-center gap-1 rounded-full border px-1.5 py-0.5 text-xs transition-colors",
                          if(@current_user_id in user_ids,
                            do: "bg-primary/10 border-primary/30 text-primary",
                            else: "bg-background border-border text-muted-foreground hover:bg-muted"
                          )
                        ]}
                      >
                        {emoji}
                        <span class="font-medium">{length(user_ids)}</span>
                      </button>
                    <% end %>
                  </div>
                <% end %>

                <%!-- Hover actions: emoji quick-react + reply --%>
                <div class={[
                  "hidden group-hover:flex items-center gap-0.5 bg-background border border-border shadow-sm rounded-full px-1.5 py-1",
                  if(is_me, do: "flex-row-reverse", else: "")
                ]}>
                  <%= for emoji <- @quick_emojis do %>
                    <button
                      type="button"
                      phx-click="react"
                      phx-value-msg_id={msg.id}
                      phx-value-emoji={emoji}
                      class="h-6 w-6 flex items-center justify-center rounded-full hover:bg-muted text-sm transition-colors"
                    >
                      {emoji}
                    </button>
                  <% end %>
                  <div class="w-px h-4 bg-border mx-0.5" />
                  <button
                    type="button"
                    phx-click="reply_to_msg"
                    phx-value-msg_id={msg.id}
                    class="h-6 w-6 flex items-center justify-center rounded-full hover:bg-muted text-muted-foreground hover:text-foreground transition-colors"
                    title="Reply"
                    aria-label="Reply"
                  >
                    <.icon name="reply" size={:xs} />
                  </button>
                </div>

                <%!-- Read receipt for own messages --%>
                <%= if is_me do %>
                  <div class="flex items-center gap-0.5 text-[9px] text-muted-foreground/50 mt-0.5">
                    <svg class="h-3 w-3" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                      <path d="M20 6 9 17l-5-5" />
                    </svg>
                    <svg class="h-3 w-3 -ml-1.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                      <path d="M20 6 9 17l-5-5" />
                    </svg>
                    <span>Entregue</span>
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        <% end %>

        <%!-- Typing indicator --%>
        <% typers = Enum.reject(@typing, &(&1 == @current_user_id)) %>
        <%= if typers != [] do %>
          <% names = typers |> Enum.map(fn id -> (Enum.find(@users, &(&1.id == id)) || %{name: id}).name end) |> Enum.join(", ") %>
          <div class="flex items-center gap-2 px-1">
            <div class="flex gap-0.5 items-center">
              <span class="h-2 w-2 rounded-full bg-muted-foreground/50 animate-bounce" style="animation-delay: 0ms" />
              <span class="h-2 w-2 rounded-full bg-muted-foreground/50 animate-bounce" style="animation-delay: 150ms" />
              <span class="h-2 w-2 rounded-full bg-muted-foreground/50 animate-bounce" style="animation-delay: 300ms" />
            </div>
            <span class="text-xs text-muted-foreground italic">{names} esta digitando...</span>
          </div>
        <% end %>
      </div>

      <%!-- Reply preview bar --%>
      <%= if @reply_to do %>
        <div class="flex items-center gap-2 px-3 sm:px-4 lg:px-6 py-2 bg-muted/40 border-t border-border/40 shrink-0">
          <.icon name="reply" size={:xs} class="text-primary shrink-0" />
          <div class="flex-1 min-w-0">
            <span class="text-xs font-semibold text-primary">{@reply_to.user_name}</span>
            <p class="text-xs text-muted-foreground truncate">{@reply_to.text}</p>
          </div>
          <button
            type="button"
            phx-click="cancel_reply"
            class="h-5 w-5 flex items-center justify-center rounded-full hover:bg-muted text-muted-foreground shrink-0"
            aria-label="Cancel reply"
          >
            <.icon name="x" size={:xs} />
          </button>
        </div>
      <% end %>

      <%!-- Input bar --%>
      <div class="shrink-0 border-t border-border/60 bg-background px-3 sm:px-4 lg:px-6 py-3">
        <form phx-submit="send_message" class="flex items-center gap-2">
          <button
            type="button"
            class="h-11 w-11 sm:h-9 sm:w-9 flex items-center justify-center rounded-full hover:bg-muted text-muted-foreground transition-colors shrink-0"
            title="Anexar arquivo"
            aria-label="Attach file"
          >
            <.icon name="paperclip" size={:sm} />
          </button>

          <input
            type="text"
            name="text"
            value={@input_text}
            placeholder={"Message — #{room_label(@rooms, @room_id)}..."}
            aria-label="Type a message"
            phx-keyup="typing"
            phx-debounce="100"
            autocomplete="off"
            class="flex-1 h-9 rounded-xl border border-input bg-muted/40 px-4 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring transition-shadow"
          />

          <button
            type="button"
            class="h-11 w-11 sm:h-9 sm:w-9 flex items-center justify-center rounded-full hover:bg-muted text-muted-foreground transition-colors shrink-0"
            title="Emoji"
            aria-label="Emoji"
          >
            <.icon name="smile" size={:sm} />
          </button>

          <button
            type="submit"
            class="h-11 w-11 sm:h-9 sm:w-9 flex items-center justify-center rounded-full bg-primary text-primary-foreground hover:bg-primary/90 transition-colors shrink-0 disabled:opacity-50"
            aria-label="Send message"
          >
            <.icon name="send" size={:xs} />
          </button>
        </form>
      </div>

    </Layout.layout>
    """
  end

  # ── Private components ─────────────────────────────────────────────────────

  defp product_card_bubble(assigns) do
    ~H"""
    <div class="rounded-2xl border border-border bg-card overflow-hidden w-64 shadow-sm rounded-tl-sm">
      <%!-- Product image area --%>
      <div class="h-28 flex flex-col items-center justify-center gap-1" style={product_card_style(@msg.product.gradient)}>
        <span class="text-4xl">{product_emoji(@msg.product.icon)}</span>
        <span class="text-[10px] font-semibold text-white/80 px-2 py-0.5 rounded-full bg-white/20">
          {@msg.product.badge}
        </span>
      </div>
      <%!-- Product info --%>
      <div class="p-3.5 space-y-2">
        <div class="flex items-start justify-between gap-2">
          <h4 class="font-bold text-sm text-foreground leading-tight">{@msg.product.name}</h4>
          <span class="text-sm font-bold text-primary shrink-0">{@msg.product.price}</span>
        </div>
        <p class="text-xs text-muted-foreground">{@msg.product.description}</p>
        <%!-- Quick replies --%>
        <%= if @msg.answered do %>
          <div class="flex items-center gap-1.5 pt-0.5 text-xs">
            <.icon name="circle-check" size={:xs} class="text-success shrink-0" />
            <span class="text-muted-foreground">
              {if @msg.answer == "yes", do: "Interest confirmed!", else: "Not interested right now"}
            </span>
          </div>
        <% else %>
          <div class="flex gap-2 pt-1">
            <%= for qr <- @msg.quick_replies do %>
              <button
                type="button"
                phx-click="quick_reply"
                phx-value-msg_id={@msg.id}
                phx-value-value={qr.value}
                class="flex-1 text-xs py-2 rounded-lg border border-border bg-background hover:border-primary/50 hover:bg-primary/5 transition-colors font-medium text-center"
              >
                {qr.label}
              </button>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp email_form_bubble(assigns) do
    ~H"""
    <div class="rounded-2xl border border-border bg-card p-4 space-y-3 w-72 rounded-tl-sm shadow-sm">
      <div class="flex items-center gap-2">
        <.icon name="inbox" size={:xs} class="text-primary" />
        <span class="text-xs font-semibold text-primary uppercase tracking-wide">Email Capture</span>
      </div>
      <p class="text-sm text-foreground">{@msg.text}</p>
      <%= if @msg.answered do %>
        <div class="flex items-center gap-2 p-2.5 rounded-lg bg-success/10 border border-success/20">
          <.icon name="circle-check" size={:xs} class="text-success shrink-0" />
          <span class="text-xs text-success font-medium">Submitted: {@msg.email}</span>
        </div>
      <% else %>
        <div class="flex gap-2">
          <input
            type="email"
            placeholder="your@email.com"
            value={@email_input}
            phx-keyup="update_email_input"
            phx-debounce="100"
            class="flex-1 h-8 rounded-lg border border-input bg-background px-2.5 text-xs focus:outline-none focus:ring-1 focus:ring-ring placeholder:text-muted-foreground"
          />
          <button
            type="button"
            phx-click="submit_email"
            phx-value-msg_id={@msg.id}
            class="h-8 px-3 rounded-lg bg-primary text-primary-foreground text-xs font-medium hover:bg-primary/90 transition-colors shrink-0"
          >
            Send
          </button>
        </div>
      <% end %>
    </div>
    """
  end

  defp booking_bubble(assigns) do
    ~H"""
    <div class="rounded-2xl border border-border bg-card p-4 space-y-3 w-72 rounded-tl-sm shadow-sm">
      <div class="flex items-center gap-2">
        <.icon name="calendar" size={:xs} class="text-primary" />
        <span class="text-xs font-semibold text-primary uppercase tracking-wide">Schedule a Demo</span>
      </div>
      <p class="text-sm text-foreground">{@msg.text}</p>
      <%= if @msg.answered do %>
        <div class="flex items-center gap-2 p-2.5 rounded-lg bg-primary/10 border border-primary/20">
          <.icon name="circle-check" size={:xs} class="text-primary shrink-0" />
          <span class="text-xs text-primary font-medium">Confirmed for {@msg.selected_day}</span>
        </div>
      <% else %>
        <div class="grid grid-cols-3 gap-1.5">
          <%= for day <- @msg.days do %>
            <button
              type="button"
              phx-click="select_day"
              phx-value-msg_id={@msg.id}
              phx-value-day={day}
              class="py-2.5 rounded-lg border border-border text-xs font-medium text-foreground hover:border-primary/60 hover:bg-primary/5 hover:text-primary transition-all"
            >
              {day}
            </button>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp nps_bubble(assigns) do
    ~H"""
    <div class="rounded-2xl border border-border bg-card p-4 space-y-3 w-72 rounded-tl-sm shadow-sm">
      <div class="flex items-center gap-2">
        <.icon name="zap" size={:xs} class="text-primary" />
        <span class="text-xs font-semibold text-primary uppercase tracking-wide">NPS · Satisfaction</span>
      </div>
      <p class="text-sm text-foreground">{@msg.text}</p>
      <%= if @msg.answered do %>
        <div class="flex items-center gap-2 p-2.5 rounded-lg bg-primary/10 border border-primary/20">
          <.icon name="check" size={:xs} class="text-primary shrink-0" />
          <span class="text-xs text-primary font-medium">Your score: {@msg.selected_score}/10</span>
        </div>
      <% else %>
        <div>
          <div class="flex justify-between text-[9px] text-muted-foreground mb-2 px-0.5">
            <span>Improvavel</span>
            <span>Muito provavel</span>
          </div>
          <div class="flex gap-1">
            <%= for score <- 0..10 do %>
              <button
                type="button"
                phx-click="nps_score"
                phx-value-msg_id={@msg.id}
                phx-value-score={score}
                class={["flex-1 py-2 rounded-md text-[10px] font-bold transition-colors", nps_color(score)]}
              >
                {score}
              </button>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp poll_bubble(assigns) do
    ~H"""
    <div class="rounded-2xl border border-border bg-card p-4 space-y-2.5 w-72 rounded-tl-sm shadow-sm">
      <div class="flex items-center gap-2">
        <.icon name="chart-bar" size={:xs} class="text-primary" />
        <span class="text-xs font-semibold text-primary uppercase tracking-wide">Poll</span>
      </div>
      <p class="text-sm font-semibold text-foreground leading-snug">{@msg.poll.question}</p>
      <% total_votes = Enum.sum(Enum.map(@msg.poll.options, &length(&1.votes))) %>
      <%= for {opt, idx} <- Enum.with_index(@msg.poll.options) do %>
        <% pct = if total_votes > 0, do: Float.round(length(opt.votes) / total_votes * 100, 0), else: 0 %>
        <% voted = @current_user_id in opt.votes %>
        <button
          type="button"
          phx-click="vote_poll"
          phx-value-msg_id={@msg.id}
          phx-value-option_idx={idx}
          class={["w-full text-left rounded-lg p-2.5 transition-all space-y-1.5", if(voted, do: "bg-primary/10 ring-1 ring-primary/20", else: "hover:bg-muted/60")]}
        >
          <div class="flex justify-between text-xs">
            <span class={["font-medium", if(voted, do: "text-primary", else: "text-foreground")]}>{opt.text}</span>
            <span class="text-muted-foreground">{trunc(pct)}%</span>
          </div>
          <div class="h-1.5 w-full rounded-full bg-muted overflow-hidden">
            <div
              class={["h-1.5 rounded-full transition-all duration-500", if(voted, do: "bg-primary", else: "bg-muted-foreground/40")]}
              style={"width: #{pct}%"}
            />
          </div>
        </button>
      <% end %>
      <p class="text-[10px] text-muted-foreground">{total_votes} vote(s) · click to vote</p>
    </div>
    """
  end

  # ── Helpers ────────────────────────────────────────────────────────────────

  defp room_agent(users, room_id) do
    agent_id = Map.get(@room_agents, room_id)
    if agent_id, do: Enum.find(users, &(&1.id == agent_id)), else: nil
  end

  defp room_label(rooms, room_id) do
    room = Enum.find(rooms, &(&1.id == room_id))
    if room, do: room.name, else: room_id
  end

  defp room_icon("products"), do: "package"
  defp room_icon("order"), do: "inbox"
  defp room_icon("survey"), do: "chart-bar"
  defp room_icon(_), do: "message-circle"

  defp product_emoji("smartphone"), do: "📱"
  defp product_emoji("laptop"), do: "💻"
  defp product_emoji("watch"), do: "⌚"
  defp product_emoji("headphones"), do: "🎧"
  defp product_emoji(_), do: "📦"

  defp product_card_style("slate"),
    do: "background: linear-gradient(135deg, #334155, #0f172a)"

  defp product_card_style("violet"),
    do: "background: linear-gradient(135deg, #7c3aed, #581c87)"

  defp product_card_style("blue"),
    do: "background: linear-gradient(135deg, #2563eb, #1e3a8a)"

  defp product_card_style("green"),
    do: "background: linear-gradient(135deg, #16a34a, #14532d)"

  defp product_card_style(_),
    do: "background: linear-gradient(135deg, #6366f1, #4338ca)"

  defp nps_color(score) when score <= 6,
    do: "bg-destructive/10 text-destructive hover:bg-destructive/20"

  defp nps_color(score) when score <= 8,
    do: "bg-warning/10 text-warning hover:bg-warning/20"

  defp nps_color(_),
    do: "bg-success/10 text-success hover:bg-success/20"

  defp preview_text(%{type: :product_card} = msg), do: msg.product.name
  defp preview_text(%{type: :email_form}), do: "Email form"
  defp preview_text(%{type: :booking}), do: "Schedule a demo"
  defp preview_text(%{type: :nps}), do: "NPS survey"
  defp preview_text(%{type: :poll, poll: poll}), do: poll.question
  defp preview_text(%{text: text}) when is_binary(text), do: String.slice(text, 0, 60)
  defp preview_text(_), do: "Message"

  defp schedule_agent_response(room_id, agent_id, text, delay) do
    me = self()
    Process.send_after(me, {:agent_typing_start, room_id, agent_id}, 300)
    Process.send_after(me, {:auto_respond, room_id, agent_id, text}, delay)
  end

  defp format_time do
    :calendar.local_time()
    |> elem(1)
    |> then(fn {h, m, _s} -> :io_lib.format("~2..0B:~2..0B", [h, m]) |> to_string() end)
  end
end
