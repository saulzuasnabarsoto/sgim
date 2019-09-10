defmodule Sgim.EstacionService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.Estacion

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in Estacion, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(Estacion, id)

  def changeset(%Estacion{} = estacion) do
    Estacion.changeset(estacion, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, estacion} <- insert(attrs)
      do
        estacion
      else
        _ -> Repo.rollback("No grabo Estacion")
      end
    end)
  end

  def insert(attrs) do
    %Estacion{}
    |> Estacion.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Estacion{} = estacion, attrs) do
    estacion
    |> Estacion.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Estacion{} = estacion) do
    Repo.delete(estacion)
  end


  def max_id() do
    query = from t in Estacion, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
