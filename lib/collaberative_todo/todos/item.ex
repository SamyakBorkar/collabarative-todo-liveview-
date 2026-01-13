defmodule CollaberativeTodo.Todos.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :title, :string
    field :is_complete, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :is_complete])
    |> validate_required([:title, :is_complete])
  end
end
