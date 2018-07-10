defmodule Twitter.Subscription do
    use Twitter.Web, :model
    import Ecto.Changeset

    schema "subscription" do
        field :subscriber, :string
        field :subscribee, :string
    end

    def changeset(subscription, params \\ %{}) do
        subscription
        |> cast(params, [:subscriber, :subscribee])
        |> validate_required([:subscriber, :subscribee])
    end
end