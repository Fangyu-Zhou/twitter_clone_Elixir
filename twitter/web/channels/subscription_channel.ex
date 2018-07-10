defmodule Twitter.SubscriptionChannel do
    use Twitter.Web, :channel
    alias Twitter.Subscription


    def join("subscription:" <> account, _params, socket) do
        IO.puts("++++")
        IO.puts(account)

        {:ok, %{}, assign(socket, :account, account)}
    end

    def handle_in("subscribe:" <> subscribee, params, socket) do
        account = socket.assigns.account

        changeset = Subscription.changeset(%Subscription{}, %{subscriber: account, subscribee: subscribee})

        case Repo.insert(changeset) do
            {:ok, post} -> IO.inspect(post)
            {:error, changeset} -> IO.inspect(changeset)
        end


        {:reply, :ok, socket}
    end

    def handle_in("unsubscribe:" <> subscribee, params, socket) do
        IO.puts("----------------")
        IO.inspect(subscribee)
        IO.puts("----------------")

        {:reply, :ok, socket}
    end

end