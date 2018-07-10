defmodule TweetChannel do
    use Twitter.Web, :channel
    alias Twitter.Tweet

    def join("tweet:" <> account, _params, socket) do
        IO.puts("++++")
        IO.puts(account)

#        get all tweet here
        {:ok, map} = Ecto.Adapters.SQL.query(Twitter.Repo, "SELECT tweet_content
        FROM tweet
        where tweet.publisher = $1
        OR tweet.publisher
        IN (SELECT subscribee from subscription where subscriber = $1)", [account])

        tweet = map.rows
        IO.inspect(tweet)


        {:ok, %{}, assign(socket, :account, account)}
    end

    def handle_in(name, content, socket) do
        account = socket.assigns.account

        changeset = Tweet.changeset(%Tweet{}, %{"tweet_content" => content, "publisher" => account})

        case Repo.insert(changeset) do
            {:ok, post} -> IO.inspect(post)
            {:error, changeset} -> IO.inspect(changeset)
        end

        {:reply, :ok, socket}
    end

end