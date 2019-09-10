defmodule  Sgim.TipoDocumento do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sgim.TipoDocumento

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "tipo_documentos" do
    field :descripcion, :string
  end

  def changeset(%TipoDocumento{}=tipo_documento, attrs) do
    tipo_documento
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
