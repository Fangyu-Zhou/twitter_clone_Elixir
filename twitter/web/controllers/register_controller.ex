defmodule Twitter.RegisterController do
    use Twitter.Web, :controller
    alias Twitter.User

    def register(conn, user) do
        IO.puts("+++++++")
        IO.inspect(user)
        IO.puts("+++++++")
        helper(user)
        render conn, "register.html"
    end

    def helper(user) do
        changeset = User.changeset(%User{}, user)

        case Repo.insert(changeset) do
            {:ok, post} -> IO.inspect(post)
            {:error, changeset} -> IO.inspect(changeset)
        end
    end
end
