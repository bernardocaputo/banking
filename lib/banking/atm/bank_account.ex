defmodule Banking.ATM.BankAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias Banking.Accounts.User

  @type t :: %__MODULE__{balance: non_neg_integer(), user: User.t()}

  @required_attrs [:balance, :user_id]

  schema "bank_accounts" do
    field :balance, :integer
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @doc false
  def changeset(bank_account, attrs) do
    bank_account
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:user)
  end
end
