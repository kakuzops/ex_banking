defmodule ExBanking.OperationsTest do
  use ExUnit.Case, async: true

  import ExBanking

  test "get balance user not exist" do
    assert create_user("user1") == :ok
    assert get_balance("user2", "dollar") == {:error, :user_does_not_exist}
  end

  test "deposit error teste" do
    create_user("user1")
    assert deposit("user1", "hello", "dollar") == {:error, :wrong_arguments}
    assert deposit("user1", -100, "dollar") == {:error, :wrong_arguments}
  end

end
