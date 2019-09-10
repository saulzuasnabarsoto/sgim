defmodule  Sgim.EstacionLugar do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sgim.EstacionLugar

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "estacion_lugars" do
    field :descripcion, :string
  end

  def changeset(%EstacionLugar{}=estacion_lugar, attrs) do
    estacion_lugar
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
