defmodule  Sgim.CategoriaPaciente do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sgim.CategoriaPaciente

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "categoria_pacientes" do
    field :descripcion, :string
  end

  def changeset(%CategoriaPaciente{}=categoria_paciente, attrs) do
    categoria_paciente
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
