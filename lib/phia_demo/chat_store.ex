defmodule PhiaDemo.ChatStore do
  @moduledoc """
  In-memory Agent storing chat messages, typing indicators, and polls.
  Seeded with fake data on startup.
  """

  use Agent

  alias PhiaDemo.FakeData

  @type room_id :: String.t()
  @type user_id :: String.t()

  def start_link(_opts) do
    Agent.start_link(fn -> seed_initial_state() end, name: __MODULE__)
  end

  # ── Messages ───────────────────────────────────────────────────────────────

  def get_messages(room_id) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state.messages, room_id, [])
    end)
  end

  def add_message(room_id, msg) do
    Agent.update(__MODULE__, fn state ->
      update_in(state, [:messages, room_id], fn msgs ->
        (msgs || []) ++ [msg]
      end)
    end)

    Phoenix.PubSub.broadcast(PhiaDemo.PubSub, "chat:room:#{room_id}", {:new_message, msg})
  end

  # ── Update message ─────────────────────────────────────────────────────────

  def update_message(room_id, msg_id, updates) do
    Agent.update(__MODULE__, fn state ->
      update_in(state, [:messages, room_id], fn msgs ->
        Enum.map(msgs, fn msg ->
          if msg.id == msg_id, do: Map.merge(msg, updates), else: msg
        end)
      end)
    end)

    updated_msg = Enum.find(get_messages(room_id), &(&1.id == msg_id))
    if updated_msg do
      Phoenix.PubSub.broadcast(PhiaDemo.PubSub, "chat:room:#{room_id}", {:message_updated, updated_msg})
    end
  end

  # ── Reactions ──────────────────────────────────────────────────────────────

  def add_reaction(room_id, msg_id, emoji, user_id) do
    Agent.update(__MODULE__, fn state ->
      update_in(state, [:messages, room_id], fn msgs ->
        Enum.map(msgs, fn msg ->
          if msg.id == msg_id do
            reactions = msg.reactions
            current_users = Map.get(reactions, emoji, [])

            new_users =
              if user_id in current_users do
                List.delete(current_users, user_id)
              else
                current_users ++ [user_id]
              end

            reactions = if new_users == [], do: Map.delete(reactions, emoji), else: Map.put(reactions, emoji, new_users)
            %{msg | reactions: reactions}
          else
            msg
          end
        end)
      end)
    end)

    updated_msg = Enum.find(get_messages(room_id), &(&1.id == msg_id))
    if updated_msg do
      Phoenix.PubSub.broadcast(PhiaDemo.PubSub, "chat:room:#{room_id}", {:reaction_updated, updated_msg})
    end
  end

  # ── Typing ─────────────────────────────────────────────────────────────────

  def get_typing(room_id) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state.typing, room_id, [])
    end)
  end

  def set_typing(room_id, user_id, typing?) do
    Agent.update(__MODULE__, fn state ->
      update_in(state, [:typing, room_id], fn current ->
        current = current || []

        if typing? do
          if user_id in current, do: current, else: current ++ [user_id]
        else
          List.delete(current, user_id)
        end
      end)
    end)

    typing_users = get_typing(room_id)
    Phoenix.PubSub.broadcast(PhiaDemo.PubSub, "chat:room:#{room_id}", {:typing_update, typing_users})
  end

  # ── Polls ──────────────────────────────────────────────────────────────────

  def add_poll(room_id, poll) do
    msg = %{
      id: "poll_#{:erlang.unique_integer([:positive])}",
      user_id: poll.created_by,
      text: poll.question,
      timestamp: poll.created_at,
      reactions: %{},
      type: :poll,
      reply_to: nil,
      poll: poll
    }

    add_message(room_id, msg)
  end

  def vote_poll(room_id, msg_id, option_idx, user_id) do
    Agent.update(__MODULE__, fn state ->
      update_in(state, [:messages, room_id], fn msgs ->
        Enum.map(msgs, fn msg ->
          if msg.id == msg_id and msg.type == :poll do
            poll = msg.poll

            options =
              Enum.with_index(poll.options)
              |> Enum.map(fn {opt, i} ->
                current_votes = opt.votes

                if i == option_idx do
                  if user_id in current_votes do
                    %{opt | votes: List.delete(current_votes, user_id)}
                  else
                    # Remove from other options first
                    %{opt | votes: current_votes ++ [user_id]}
                  end
                else
                  %{opt | votes: List.delete(opt.votes, user_id)}
                end
              end)

            updated_poll = %{poll | options: options}
            updated_msg = %{msg | poll: updated_poll}
            updated_msg
          else
            msg
          end
        end)
      end)
    end)

    updated_msg = Enum.find(get_messages(room_id), &(&1.id == msg_id))
    if updated_msg do
      Phoenix.PubSub.broadcast(PhiaDemo.PubSub, "chat:room:#{room_id}", {:poll_updated, updated_msg})
    end
  end

  # ── Private ────────────────────────────────────────────────────────────────

  defp seed_initial_state do
    rooms = FakeData.chat_rooms()

    messages =
      Map.new(rooms, fn room ->
        {room.id, FakeData.chat_seed_messages(room.id)}
      end)

    %{
      messages: messages,
      typing: %{},
      polls: %{}
    }
  end
end
