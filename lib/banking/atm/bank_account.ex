defmodule Banking.ATM.BankAccount do
  @moduledoc """
  Module that handle bank account changeset and schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Banking.Accounts.User

  @type t :: %__MODULE__{balance: non_neg_integer(), user: User.t()}

  @required_attrs [:user_id]
  # @optional_attrs [:balance]

  schema "bank_accounts" do
    field(:balance, :integer)
    belongs_to(:user, User)

    timestamps()
  end

  @doc """
  Return changeset for inserting new bank account given attrs
  """
  @spec create_changeset(map()) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_change(:balance, 50)
  end

  @doc """
  Return changeset for inserting/updating current struct
  """
  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:user_id)
  end

  @doc """
  Return changeset for updating new balance after deposit
  """
  @spec deposit_changeset(__MODULE__.t(), pos_integer()) :: Ecto.Changeset.t()
  def deposit_changeset(bank_account, deposit_amount) do
    bank_account
    |> change(%{balance: bank_account.balance + deposit_amount})
  end

  def withdrawal_changeset(bank_account, withdrawal_amount) do
    bank_account
    |> change(%{balance: bank_account.balance - withdrawal_amount})
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
