defmodule Twitter.Tweet do
    use Twitter.Web, :model
    import Ecto.Changeset

    schema "tweet" do
        field :tweet_content, :string
        field :publisher, :string
        field :pound_account, :string
        field :at_account, :string
    end

    def changeset(tweet, params \\ %{}) do
        tweet
        |> cast(params, [:tweet_content, :publisher, :pound_account, :at_account])
        |> validate_required([:tweet_content, :publisher])
    end
end