defmodule Sgim.ZonaLesionService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.ZonaLesion

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in ZonaLesion, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(ZonaLesion, id)

  def changeset(%ZonaLesion{} = zona_lesion) do
    ZonaLesion.changeset(zona_lesion, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, zona_lesion} <- insert(attrs)
      do
        zona_lesion
      else
        _ -> Repo.rollback("No grabo Categoria Paciente")
      end
    end)
  end

  def insert(attrs) do
    %ZonaLesion{}
    |> ZonaLesion.changeset(attrs)
    |> Repo.insert()
  end

  def update(%ZonaLesion{} = zona_lesion, attrs) do
    zona_lesion
    |> ZonaLesion.changeset(attrs)
    |> Repo.update()
  end

  def delete(%ZonaLesion{} = zona_lesion) do
    Repo.delete(zona_lesion)
  end


  def max_id() do
    query = from t in ZonaLesion, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
