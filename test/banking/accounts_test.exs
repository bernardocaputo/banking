defmodule Banking.AccountsTest do
  use Banking.DataCase
  import Banking.AccountsFixtures
  alias Banking.Accounts
  alias Banking.Accounts.User

  @valid_attrs %{username: "#{System.unique_integer()}", password: "123456"}

  setup do
    user = Map.put(user_fixture(), :password, nil)
    [user: user]
  end

  describe "create_user/1" do
    test "valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:ok, user} ==
               Argon2.check_pass(user, @valid_attrs.password, hash_key: :password_hash)

      assert user.username == @valid_attrs.username
    end
  end

  describe "get_user_by_username/1" do
    test "return user", %{user: user} do
      assert Accounts.get_user_by_username(user.username) == user
    end

    test "return nil" do
      refute Accounts.get_user_by_username("#{System.unique_integer()}")
    end
  end

  describe "get_user!/1" do
    test "return user", %{user: user} do
      assert Accounts.get_user!(user.id) == user
    end

    test "return error" do
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(System.unique_integer()) end
    end
  end

  describe "authenticate_user" do
    test "return user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      Accounts.authenticate_user(user.username, user.password)
    end

    test "return  error" do
      assert Accounts.authenticate_user("non_existing", "123456") ==
               {:error, :invalid_credentials}
    end
  end
end
