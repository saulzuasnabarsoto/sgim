defmodule Sgim.EstacionLugarService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.EstacionLugar

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in EstacionLugar, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(EstacionLugar, id)

  def changeset(%EstacionLugar{} = estacion_lugar) do
    EstacionLugar.changeset(estacion_lugar, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, estacion_lugar} <- insert(attrs)
      do
        estacion_lugar
      else
        _ -> Repo.rollback("No grabo Estacion Lugar")
      end
    end)
  end

  def insert(attrs) do
    %EstacionLugar{}
    |> EstacionLugar.changeset(attrs)
    |> Repo.insert()
  end

  def update(%EstacionLugar{} = estacion_lugar, attrs) do
    estacion_lugar
    |> EstacionLugar.changeset(attrs)
    |> Repo.update()
  end

  def delete(%EstacionLugar{} = estacion_lugar) do
    Repo.delete(estacion_lugar)
  end


  def max_id() do
    query = from t in EstacionLugar, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
