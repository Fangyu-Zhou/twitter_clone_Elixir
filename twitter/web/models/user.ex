defmodule Twitter.User do
    use Twitter.Web, :model
    import Ecto.Changeset

    schema "user_table" do
        field :account, :string
        field :password, :string
        field :publickeys, :string
    end

    def changeset(user, params \\ %{}) do
        user
        |> cast(params, [:account, :password, :publickeys])
        |> validate_required([:account, :password, :publickeys])
        |> unique_constraint(:account)
    end
end