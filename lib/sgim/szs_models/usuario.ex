defmodule  Sgim.Usuario do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sgim.Usuario

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "usuarios" do
    field :descripcion, :string
    field :cuenta, :string
    field :contrasenia, :string
    field :activo, :integer, default: 0

    field :password, :string, virtual: true

  end

  def changeset(%Usuario{}=usuario, attrs) do
    usuario
    |> cast(attrs, [:id, :descripcion, :cuenta, :password])
    |> encrypt_password()
    |> validate_required([:id, :descripcion, :cuenta, :contrasenia])
  end

  def encrypt_password(changeset) do
    with password when not is_nil(password) <- get_change(changeset, :password) do
      put_change(changeset, :contrasenia, Bcrypt.hash_pwd_salt(password))
    else
      _ -> changeset
    end
  end

end
