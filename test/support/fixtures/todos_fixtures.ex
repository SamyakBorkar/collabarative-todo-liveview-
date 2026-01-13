defmodule CollaberativeTodo.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CollaberativeTodo.Todos` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        is_complete: true,
        title: "some title"
      })
      |> CollaberativeTodo.Todos.create_item()

    item
  end
end
