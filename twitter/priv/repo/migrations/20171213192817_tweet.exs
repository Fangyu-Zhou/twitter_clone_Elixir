defmodule Twitter.Repo.Migrations.Tweet do
  use Ecto.Migration

  def change do
      create table(:tweet) do
        add :tweet_content, :string
        add :publisher, :string
        add :pound_account, :string
        add :at_account, :string
    end

  end
end
