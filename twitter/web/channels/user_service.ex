defmodule Twitter.UserService do
    use Twitter.Web, :channel
    alias Twitter.Subscription
    alias Twitter.Tweet

    def subscribe(account, subscribee) do
        changeset = Subscription.changeset(%Subscription{}, %{subscriber: account, subscribee: subscribee})

        case Repo.insert(changeset) do
            {:ok, post} -> IO.inspect(post)
            {:error, changeset} -> IO.inspect(changeset)
        end

        IO.puts("------------------")
        IO.puts("subscribe successful")
        IO.puts("------------------")
        subscribee
    end

    def unsubscribe(account, subscribee) do
        Ecto.Adapters.SQL.query(Twitter.Repo, "DELETE FROM subscription
        WHERE subscriber = $1
        AND subscribee = $2", [account, subscribee])

        IO.puts("------------------")
        IO.puts("unsubscribe successful")
        IO.puts("------------------")
        subscribee
    end

    def subscribee_tweet(account) do
        {:ok, map} = Ecto.Adapters.SQL.query(Twitter.Repo, "SELECT tweet_content
        FROM tweet
        WHERE tweet.publisher = $1
        OR tweet.publisher
        IN (SELECT subscribee FROM subscription WHERE subscriber = $1)", [account])

        tweet = map.rows
        IO.inspect(tweet)

        IO.puts("------------------")
        IO.puts("show subscribees' tweet successful")
        IO.puts("------------------")
        tweet
    end

    def pound_tweet(account) do
        {:ok, map} = Ecto.Adapters.SQL.query(Twitter.Repo, "SELECT tweet_content
        FROM tweet
        WHERE tweet.pound_account = $1", [account])

        tweet = map.rows
        IO.inspect(tweet)

        IO.puts("------------------")
        IO.puts("show pound_account's tweet successful")
        IO.puts("------------------")
        tweet
    end

    def at_tweet(account) do
        {:ok, map} = Ecto.Adapters.SQL.query(Twitter.Repo, "SELECT tweet_content
        FROM tweet
        WHERE tweet.at_account = $1", [account])

        tweet = map.rows
        IO.inspect(tweet)

        IO.puts("------------------")
        IO.puts("show at_account's tweet successful")
        IO.puts("------------------")
        tweet
    end

    def new_tweet(account, content, params) do
        case params do
            %{pound_account: pound_account, at_account: at_account} -> new_tweet_helper(account, content, pound_account, at_account)
            %{pound_account: pound_account} -> new_tweet_helper(account, content, pound_account, nil)
            %{at_account: at_account} -> new_tweet_helper(account, content, nil, at_account)

            %{"pound_account" => pound_account, "at_account" => at_account} -> new_tweet_helper(account, content, pound_account, at_account)
            %{"pound_account" => pound_account} -> new_tweet_helper(account, content, pound_account, nil)
            %{"at_account" => at_account} -> new_tweet_helper(account, content, nil, at_account)
            %{} -> new_tweet_helper(account, content, nil, nil)

        end

        IO.puts("------------------")
        IO.puts("publish new tweet successful")
        IO.puts("------------------")
        %{content: content, suffix: params}
    end

    def retweet(account, tweet_id, params) do
        {:ok, map} = Ecto.Adapters.SQL.query(Twitter.Repo, "SELECT tweet_content
        FROM tweet
        where id = $1", [String.to_integer(tweet_id)])

        [[content]] = map.rows

        case params do
            %{"pound_account" => pound_account, "at_account" => at_account} -> new_tweet_helper(account, content, pound_account, at_account)
            %{"pound_account" => pound_account} -> new_tweet_helper(account, content, pound_account, nil)
            %{"at_account" => at_account} -> new_tweet_helper(account, content, nil, at_account)
            %{} -> new_tweet_helper(account, content, nil, nil)

        end

        IO.puts("------------------")
        IO.puts("retweet successful")
        IO.puts("------------------")
        %{tweet_id: tweet_id, content: content}
    end

    defp new_tweet_helper(account, content, pound_account, at_account) do
        IO.puts(pound_account)
        IO.puts(at_account)

        changeset = Tweet.changeset(%Tweet{}, %{"tweet_content" => content,
            "publisher" => account, "pound_account" => pound_account, "at_account" => at_account})

        case Repo.insert(changeset) do
            {:ok, post} -> IO.inspect(post)
            {:error, changeset} -> IO.inspect(changeset)
        end
    end
end