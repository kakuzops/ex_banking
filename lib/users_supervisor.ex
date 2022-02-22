defmodule ExBanking.UsersSupervisor do
  use DynamicSupervisor

  alias ExBanking.User

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec start_child(any) :: :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start_child(user_name) do
    DynamicSupervisor.start_child(__MODULE__, {User, {:via, Registry, {Registry.ExBanking, user_name}}})
    end
end
