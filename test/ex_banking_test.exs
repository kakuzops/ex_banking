defmodule ExBankingTest do
 use ExUnit.Case, async: true

  import ExBanking

  setup do
    Application.stop(:ex_banking)
    :ok = Application.start(:ex_banking)
  end

  test "create user test" do
    assert create_user("kakuzops") == :ok
  end

  test "create user bad arguments test" do
    assert create_user("kakuzops") == :ok
    assert create_user("kakuzops") == {:error, :user_already_exists}
  end

  test "get balance user not exist" do
    assert create_user("user1") == :ok
    assert get_balance("user2", "dollar") == {:error, :user_does_not_exist}
  end

  test "deposit error teste" do
    create_user("joker")
    assert deposit("joker", "why so serious", "dollar") == {:error, :wrong_arguments}
    assert deposit("joker", -100, "dollar") == {:error, :wrong_arguments}
  end

  test "get balance test" do
    assert create_user("batman") == :ok
    assert get_balance("batman", "dollar") == {:ok, 0}
  end

  test "deposit money positive test" do
    create_user("flash")
    assert deposit("flash", 50, "dollar") == {:ok, 50}
    assert get_balance("flash", "dollar") == {:ok, 50}
  end

  test "withdraw money positive test" do
    create_user("harley_queen")
    assert deposit("harley_queen", 899, "dollar") == {:ok, 899}
    assert withdraw("harley_queen", 899, "dollar") == {:ok, 0}
    assert get_balance("harley_queen", "dollar") == {:ok, 0}
  end

  test "send money to ok test" do
    create_user("sandman")
    create_user("death")
    deposit("sandman", 200, "dollar")


    assert send("sandman", "death", 100, "dollar") == {:ok, 100, 100}
  end
end
