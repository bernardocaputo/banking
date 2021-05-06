defmodule BankingWeb.AccountsControllerTest do
  use BankingWeb.ConnCase
  import Banking.AccountsFixtures

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  describe "sign_up/2" do
    test "return bank account", %{conn: conn} do
      params = valid_user_attributes()
      conn = post(conn, Routes.accounts_path(conn, :sign_up), params)

      json = json_response(conn, 200)

      assert json == %{"data" => %{"balance" => 50}}
    end

    test "return error when invalid params", %{conn: conn} do
      params = %{username: "12", password: "12"}
      conn = post(conn, Routes.accounts_path(conn, :sign_up), params)

      json = json_response(conn, 422)

      assert %{
               "errors" => %{
                 "password" => ["should be at least 4 character(s)"],
                 "username" => ["should be at least 4 character(s)"]
               }
             } == json
    end
  end

  describe "authenticate_user/2" do
    test "return token when authenticating successfully", %{conn: conn} do
      user = user_fixture()

      conn =
        post(conn, Routes.accounts_path(conn, :authenticate_user), %{
          username: user.username,
          password: user.password
        })

      json = json_response(conn, 200)

      assert %{"token" => _} = json
    end

    test "return error when invalid credentials", %{conn: conn} do
      conn =
        post(conn, Routes.accounts_path(conn, :authenticate_user), %{
          username: "wrong",
          password: "nonpassword"
        })

      json = json_response(conn, 400)

      assert %{"errors" => %{"message" => "Invalid credentials"}} == json
    end
  end
end
