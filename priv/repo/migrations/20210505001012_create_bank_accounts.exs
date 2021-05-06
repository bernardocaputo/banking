defmodule Banking.Repo.Migrations.CreateBankAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts) do
      add :balance, :integer, default: 0
      timestamps()
    end
  end
end
