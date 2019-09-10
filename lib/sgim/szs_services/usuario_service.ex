defmodule Sgim.UsuarioService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.Usuario

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in Usuario, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(Usuario, id)

  def record_por_cuenta(username) do
    Repo.get_by(Usuario, cuenta: username)
  end

  def changeset(%Usuario{} = usuario) do
    Usuario.changeset(usuario, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, usuario} <- insert(attrs)
      do
        usuario
      else
        _ -> Repo.rollback("No grabo Usuario")
      end
    end)
  end

  def insert(attrs) do
    %Usuario{}
    |> Usuario.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Usuario{} = usuario, attrs) do
    usuario
    |> Usuario.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Usuario{} = usuario) do
    Repo.delete(usuario)
  end


  def max_id() do
    query = from t in Usuario, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
