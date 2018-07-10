defmodule UserOperation do
    alias Twitter.RegisterController
    alias Twitter.UserService

    def register(account, password) do
        RegisterController.helper(%{"account" => account, "password" => password})
    end

    def operate(account) do
        subscribee = "chinazhangyujia"
        UserService.subscribe(account, subscribee)
        UserService.subscribee_tweet(account)
        UserService.unsubscribe(account, subscribee)
        UserService.subscribee_tweet(account)

        content = "hi I am zyj"
        new_tweet_params = %{pound_account: "2411537283", at_account: "zhangyujia"}
        UserService.new_tweet(account, content, new_tweet_params )
        UserService.pound_tweet(account)
        UserService.at_tweet(account)

        retweet_params = %{at_account: "zhangyujia"}
        tweet_id = "3"
        UserService.retweet(account, tweet_id, retweet_params)

    end

end