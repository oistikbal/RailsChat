class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat"
  end

  def unsubscribed
  end

  def receive(data)
    message = current_user.messages.create!(content: data['data'])
    ActionCable.server.broadcast("chat", { type: "message", data: data['data'], user: current_user.email }.to_json)
  end
end
