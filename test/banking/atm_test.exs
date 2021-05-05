defmodule Banking.ATMTest do
  use Banking.DataCase
  import Banking.BankAccountsFixtures
  alias Banking.ATM

  setup do
    bank_account = bank_account_fixture()
    [bank_account: bank_account]
  end

  describe "check_balance/1" do
    test "return balance", %{bank_account: bank_account} do
      assert ATM.check_balance(bank_account.id) == bank_account
    end
  end

  describe "deposit_to/2" do
    test "return bank account updated when deposit amount is > 0", %{bank_account: bank_account} do
      deposit_amount = 10
      {:ok, bank_account_updated} = ATM.deposit_to(bank_account, deposit_amount)

      assert bank_account_updated.balance == bank_account.balance + deposit_amount
    end

    test "return error when deposit amount is < 0", %{bank_account: bank_account} do
      deposit_amount = -10
      assert {:error, :must_be_greater_than_0} == ATM.deposit_to(bank_account, deposit_amount)
    end

    test "return error when value is not integer", %{bank_account: bank_account} do
      deposit_amount = "a"
      assert {:error, :invalid_deposit_amount} == ATM.deposit_to(bank_account, deposit_amount)
    end
  end

  describe "withdrawal_from/2" do
    test "return bank account updated when withdrawal amount is > 0 and balance >= 0", %{
      bank_account: bank_account
    } do
      withdrawal_amount = 10
      {:ok, bank_account_updated} = ATM.withdrawal_from(bank_account, withdrawal_amount)

      assert bank_account_updated.balance == bank_account.balance - withdrawal_amount

      assert bank_account_updated.balance >= 0
    end

    test "return error when after withdrawal balance is < 0", %{bank_account: bank_account} do
      withdrawal_amount = 200

      assert {:error, changeset} = ATM.withdrawal_from(bank_account, withdrawal_amount)

      assert %{balance: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return error when withdrawal amount is < 0", %{bank_account: bank_account} do
      withdrawal_amount = -10

      assert {:error, :must_be_greater_than_0} ==
               ATM.withdrawal_from(bank_account, withdrawal_amount)
    end

    test "return error when value is not integer", %{bank_account: bank_account} do
      withdrawal_amount = "a"

      assert {:error, :invalid_withdrawal_amount} ==
               ATM.withdrawal_from(bank_account, withdrawal_amount)
    end
  end
end
