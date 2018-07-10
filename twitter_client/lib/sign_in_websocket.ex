defmodule SignWebSocket do
    @host "localhost"
    @path "/socket/websocket"
    @params %{authenticated: "false"}
    @port 4000
    @opts [
        host: @host,
        port: @port,
        path: @path,
        params: @params]



    def connect(account, privateKey) do
        {:ok, pid} = PhoenixChannelClient.start_link()
        {:ok, socket} = PhoenixChannelClient.connect(pid, @opts)

        channel = PhoenixChannelClient.channel(socket, "sign_in:" <> account)

#        PhoenixChannelClient.join(channel)
        {:ok, encrypted} = PhoenixChannelClient.join(channel)
        {:ok, encrypted} = Base.decode64(encrypted)
        IO.puts("*********encrypted current time receive from server is: ")
        IO.inspect(encrypted)
        message = RSA.decrypt(encrypted , {:private, RSA.decode_key(privateKey)})
        IO.puts("*********current time after decrypted by private key: ")
        IO.puts(message)
        reply = challenge(channel, message)
        case reply do
            {:ok, socket} -> IO.puts("authentication correct")
            {:error, socket} -> IO.puts("authentication failure")
        end


        operation(channel, account, privateKey)



#        exit(:kill)
    end

    def operation(channel, account, privateKey) do
        IO.puts("this is the operation")

#        IO.inspect(new_tweet(channel, "hi I am zyj", %{pound_account: "lllkkk", at_account: "asd"}, account))
      #        IO.inspect(subscribe(channel, "zfy"))
      #        IO.inspect(subscribee_tweet(channel))
      #        IO.inspect(unsubscibe(channel, "zfy"))
      #        IO.inspect(subscribee_tweet(channel))
      #
      ##        new_tweet(channel, "hi I am zyj", %{pound_account: "2411537283", at_account: "zhangyujia"}, account)
      #        IO.inspect(pound_tweet(channel))
      #        IO.inspect(at_tweet(channel))
        IO.puts("***********  publish a tweet")
        IO.inspect(new_tweet(channel, "hi I am zyj", %{pound_account: "lllkkk", at_account: "asd"}, account))
#        IO.puts("***********  Subscribe an account")
#        IO.inspect(subscribe(channel, "zfy"))
#        IO.puts("***********  Show the tweets of the user and his Subscribee")
#        IO.inspect(subscribee_tweet(channel))
#        IO.puts("***********  Unsubscribe an account")
#        IO.inspect(unsubscibe(channel, "zfy"))
#        IO.puts("***********  Show the tweets after unsubscribe")
#        IO.inspect(subscribee_tweet(channel))
#
##        w_tweet(channel, "hi I am zyj", %{pound_account: "2411537283", at_account: "zhangyujia"}, account)
#        IO.puts("**********  Show the tweets that pound this account")
#        IO.inspect(pound_tweet(channel))
#        IO.puts("***********  Show the tweets that @this account")
#        IO.inspect(at_tweet(channel))

#        operation(channel, account, privateKey)

    end

    def challenge(channel, message) do
        PhoenixChannelClient.push_and_receive(channel, "challenge:" <> message, %{a: 1})
    end

    def subscribe(channel, subscribee) do
        PhoenixChannelClient.push_and_receive(channel, "subscribe:" <> subscribee, %{a: 1})
    end

    def unsubscibe(channel, subscribee) do
        PhoenixChannelClient.push_and_receive(channel, "unsubscribe:" <> subscribee, %{a: 1} )
    end

    def subscribee_tweet(channel) do
        PhoenixChannelClient.push_and_receive(channel, "subscribee_tweet:", %{a: 1} )
    end

    def new_tweet(channel, content, suffix, account) do
#        content = encode(content, privateKey)


        secret = RS256.generate_secret_key(account)
#        jwt = RS256.encode(suffix, secret)

        message = %{content: content, suffix: suffix}
        jwt = RS256.encode(message, secret)

        IO.puts("***********  JSON message")
        IO.inspect(message)
        IO.puts("***********  encoded message")
        IO.puts(jwt)


        #        PhoenixChannelClient.push_and_receive(channel, "new_tweet:" <> content, jwt)
        PhoenixChannelClient.push_and_receive(channel, "new_tweet:", jwt)
    end

    def pound_tweet(channel) do
        PhoenixChannelClient.push_and_receive(channel, "pound_tweet:", %{a: 1} )
    end

    def at_tweet(channel) do
        PhoenixChannelClient.push_and_receive(channel, "at_tweet:", %{a: 1} )
    end

    def retweet(channel, tweet_id, suffix) do
        PhoenixChannelClient.push_and_receive(channel, "retweet:" <> tweet_id, suffix )
    end

    def encode(content, privateKey) do
        Base.encode64(RSA.encrypt(content, {:private, RSA.decode_key(privateKey)}))
    end
end
