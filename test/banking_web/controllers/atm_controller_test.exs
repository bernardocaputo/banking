defmodule BankingWeb.ATMControllerTest do
  use BankingWeb.ConnCase
  import Banking.AccountsFixtures
  import Banking.BankAccountsFixtures

  alias Banking.Repo

  setup %{conn: conn} do
    user = user_fixture()
    bank_account_fixture(%{user_id: user.id})

    conn =
      conn
      |> authenticate(user)

    user_preloaded = Repo.preload(user, :bank_account)

    {:ok, conn: conn, user: user_preloaded}
  end

  describe "show_bank_account/2" do
    test "return  bank account", %{conn: conn} do
      conn = get(conn, Routes.atm_path(conn, :show_bank_account))
      json = json_response(conn, 200)

      assert json == %{"data" => %{"balance" => 50}}
    end
  end

  describe "deposit_to/2" do
    test "return  bank account", %{conn: conn, user: user} do
      assert user.bank_account.balance == 50
      conn = post(conn, Routes.atm_path(conn, :deposit_to), %{deposit_amount: 10})
      json = json_response(conn, 200)

      assert json == %{"data" => %{"balance" => 60}}
    end

    test "return  error when params is string", %{conn: conn} do
      conn = post(conn, Routes.atm_path(conn, :deposit_to), %{deposit_amount: "lala"})
      json = json_response(conn, 400)

      assert %{"errors" => %{"message" => "Invalid deposit amount"}} == json
    end

    test "return  error when params is neg_integer", %{conn: conn, user: user} do
      assert user.bank_account.balance == 50
      conn = post(conn, Routes.atm_path(conn, :deposit_to), %{deposit_amount: -10})
      json = json_response(conn, 400)

      assert %{"errors" => %{"message" => "Must be greater than 0"}} == json
    end
  end

  describe "withdrawal_from/2" do
    test "return  bank account", %{conn: conn, user: user} do
      assert user.bank_account.balance == 50

      conn = post(conn, Routes.atm_path(conn, :withdrawal_from), %{withdrawal_amount: 10})
      json = json_response(conn, 200)

      assert json == %{"data" => %{"balance" => 40}}
    end

    test "return  error when string", %{conn: conn} do
      conn = post(conn, Routes.atm_path(conn, :withdrawal_from), %{withdrawal_amount: "haha"})
      json = json_response(conn, 400)

      assert %{"errors" => %{"message" => "Invalid withdrawal amount"}} == json
    end

    test "return  error when neg_integer", %{conn: conn, user: user} do
      assert user.bank_account.balance == 50
      conn = post(conn, Routes.atm_path(conn, :withdrawal_from), %{withdrawal_amount: -10})
      json = json_response(conn, 400)

      assert %{"errors" => %{"message" => "Must be greater than 0"}} == json
    end
  end
end
