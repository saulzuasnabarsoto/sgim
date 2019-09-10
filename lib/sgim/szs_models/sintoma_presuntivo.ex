defmodule  Sgim.SintomaPresuntivo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sgim.SintomaPresuntivo

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "sintoma_presuntivos" do
    field :descripcion, :string
  end

  def changeset(%SintomaPresuntivo{}=sintoma_presuntivo, attrs) do
    sintoma_presuntivo
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
