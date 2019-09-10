defmodule Sgim.LugarTrasladoService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.LugarTraslado

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in LugarTraslado, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(LugarTraslado, id)

  def changeset(%LugarTraslado{} = lugar_traslado) do
    LugarTraslado.changeset(lugar_traslado, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, lugar_traslado} <- insert(attrs)
      do
        lugar_traslado
      else
        _ -> Repo.rollback("No grabo Categoria Paciente")
      end
    end)
  end

  def insert(attrs) do
    %LugarTraslado{}
    |> LugarTraslado.changeset(attrs)
    |> Repo.insert()
  end

  def update(%LugarTraslado{} = lugar_traslado, attrs) do
    lugar_traslado
    |> LugarTraslado.changeset(attrs)
    |> Repo.update()
  end

  def delete(%LugarTraslado{} = lugar_traslado) do
    Repo.delete(lugar_traslado)
  end


  def max_id() do
    query = from t in LugarTraslado, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
