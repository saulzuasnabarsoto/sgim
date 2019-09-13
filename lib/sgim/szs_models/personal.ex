defmodule  Sgim.Personal do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sgim.Personal
  alias Sgim.TipoDocumento
  alias Sgim.CategoriaPersonal

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "personals" do
    field :descripcion, :string
    field :numero_documento, :string

    belongs_to :tipo_documento, TipoDocumento
    belongs_to :categoria_personal, CategoriaPersonal
  end

  def changeset(%Personal{}=personal, attrs) do
    personal
    |> cast(attrs, [:id, :descripcion, :tipo_documento_id, :numero_documento, :categoria_personal_id])
    |> change_uppercase()
    |> validate_required([:id, :descripcion, :tipo_documento_id, :numero_documento, :categoria_personal_id])
  end

  def change_uppercase(changeset) do
    with descripcion when not is_nil(descripcion) <- get_change(changeset, :descripcion) do
      put_change(changeset, :descripcion, String.upcase(descripcion))
    else
      _ -> changeset
    end
  end

end
