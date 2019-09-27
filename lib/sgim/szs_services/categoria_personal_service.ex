defmodule Sgim.CategoriaPersonalService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.CategoriaPersonal

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in CategoriaPersonal, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def list do
    query = from t in CategoriaPersonal
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(CategoriaPersonal, id)

  def changeset(%CategoriaPersonal{} = categoria_personal) do
    CategoriaPersonal.changeset(categoria_personal, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, categoria_personal} <- insert(attrs)
      do
        categoria_personal
      else
        _ -> Repo.rollback("No grabo Categoria Paciente")
      end
    end)
  end

  def insert(attrs) do
    %CategoriaPersonal{}
    |> CategoriaPersonal.changeset(attrs)
    |> Repo.insert()
  end

  def update(%CategoriaPersonal{} = categoria_personal, attrs) do
    categoria_personal
    |> CategoriaPersonal.changeset(attrs)
    |> Repo.update()
  end

  def delete(%CategoriaPersonal{} = categoria_personal) do
    Repo.delete(categoria_personal)
  end


  def max_id() do
    query = from t in CategoriaPersonal, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
