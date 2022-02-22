defmodule ExBanking.Operations do
  alias ExBanking.BankingValidation

  def transfer_money([{from_pid, _}], [{to_pid, _}], amount, currency) do
    with {:ok, from_new_balance, to_new_balance} <- withdraw_for_transfer(from_pid, to_pid, amount, currency) do

      {:ok, from_new_balance, to_new_balance}
    else
      {:error, :not_enough_money} -> {:error, :not_enough_money}
      {:error, :too_many_requests_to_sender} -> {:error, :too_many_requests_to_sender}
      {:error, :too_many_requests_to_receiver} -> {:error, :too_many_requests_to_receiver}
    end
  end

  def withdraw_for_transfer(from_pid, to_pid, amount, currency) do
    with {:ok, from_reply, to_reply} <- GenServer.call(from_pid, {:send, to_pid, amount, currency}) do
      {:ok, from_reply, to_reply}
    else
      :not_enough_money -> {:error, :not_enough_money}
      :too_many_requests_to_user -> {:error, :too_many_requests_to_sender}
      {:error, :too_many_requests_to_receiver} -> {:error, :too_many_requests_to_receiver}
    end
  end

  def deposit_transfer(to_pid, amount, currency) do
    with %{} = new_state <- GenServer.call(to_pid, {:deposit, amount, currency}),
      {:ok, to_new_balance} <- BankingValidation.get_balance_from_reply(new_state, currency) do
       {:ok, to_new_balance}
    else
      :too_many_requests_to_user -> {:error, :too_many_requests_to_receiver}
    end
  end

  def add(cont1, cont2) when is_float(cont1) or is_float(cont2) do
    cont1 + cont2
    |> Float.round(2)
  end

  def add(cont1, cont2) do
    cont1 + cont2
  end


  def subtract(cont1, cont2) when is_float(cont1) or is_float(cont2) do
    cont1 - cont2
    |> Float.round(2)
  end

  def subtract(cont1, cont2) do
    cont1 - cont2
  end
end
