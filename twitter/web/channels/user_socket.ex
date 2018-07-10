defmodule Twitter.UserSocket do
  use Phoenix.Socket


  channel "tweet:*", Twitter.TweetChannel
  channel "subscription:*", Twitter.SubscriptionChannel
  channel "retweet:*", Twitter.RetweetChannel
  channel "sign_in:*", Twitter.SignInChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end


  def id(_socket), do: nil
end
