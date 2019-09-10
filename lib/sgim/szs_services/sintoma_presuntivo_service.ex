defmodule Sgim.SintomaPresuntivoService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.SintomaPresuntivo

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in SintomaPresuntivo, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(SintomaPresuntivo, id)

  def changeset(%SintomaPresuntivo{} = sintoma_presuntivo) do
    SintomaPresuntivo.changeset(sintoma_presuntivo, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, sintoma_presuntivo} <- insert(attrs)
      do
        sintoma_presuntivo
      else
        _ -> Repo.rollback("No grabo Sintoma Presuntivo")
      end
    end)
  end

  def insert(attrs) do
    %SintomaPresuntivo{}
    |> SintomaPresuntivo.changeset(attrs)
    |> Repo.insert()
  end

  def update(%SintomaPresuntivo{} = sintoma_presuntivo, attrs) do
    sintoma_presuntivo
    |> SintomaPresuntivo.changeset(attrs)
    |> Repo.update()
  end

  def delete(%SintomaPresuntivo{} = sintoma_presuntivo) do
    Repo.delete(sintoma_presuntivo)
  end


  def max_id() do
    query = from t in SintomaPresuntivo, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
