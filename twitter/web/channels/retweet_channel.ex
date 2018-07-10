defmodule RetweetChannel do
    use Twitter.Web, :channel
    alias Twitter.Tweet


    def join("retweet:" <> account, _params, socket) do
        IO.puts("++++")
        IO.puts(account)



        {:ok, %{}, assign(socket, :account, account)}
    end

    def handle_in(name, tweet_id, socket) do
        account = socket.assigns.account

#        get content by id
        {:ok, map} = Ecto.Adapters.SQL.query(Twitter.Repo, "SELECT tweet_content
        FROM tweet
        where id = $1", [String.to_integer(tweet_id)])

        [[content]] = map.rows

        changeset = Tweet.changeset(%{}, %{"content" => content, "publisher" => account})

        case Repo.insert(changeset) do
            {:ok, post} -> IO.inspect(post)
            {:error, changeset} -> IO.inspect(changeset)
        end


        {:reply, :ok, socket}
    end

end