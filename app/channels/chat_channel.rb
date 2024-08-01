class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat"
  end

  def unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast("chat", data)
  end
end
