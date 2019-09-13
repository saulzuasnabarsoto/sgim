defmodule  Sgim.CategoriaPersonal do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sgim.CategoriaPersonal
  alias Sgim.Personal

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "categoria_personals" do
    field :descripcion, :string

    has_many :personals, Personal

  end

  def changeset(%CategoriaPersonal{}=categoria_personal, attrs) do
    categoria_personal
    |> cast(attrs, [:id, :descripcion])
    |> change_uppercase()
    |> validate_required([:id, :descripcion])
  end

  def change_uppercase(changeset) do
    with descripcion when not is_nil(descripcion) <- get_change(changeset, :descripcion) do
      put_change(changeset, :descripcion, String.upcase(descripcion))
    else
      _ -> changeset
    end
  end

end
