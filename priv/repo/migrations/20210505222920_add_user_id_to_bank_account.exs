defmodule Banking.Repo.Migrations.AddUserIdToBankAccount do
  use Ecto.Migration

  def change do
    alter table(:bank_accounts) do
      add :user_id, references(:users)
    end

    create unique_index(:bank_accounts, [:user_id])
  end
end
