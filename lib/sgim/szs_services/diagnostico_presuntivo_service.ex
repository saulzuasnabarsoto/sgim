defmodule Sgim.DiagnosticoPresuntivoService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.DiagnosticoPresuntivo

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in DiagnosticoPresuntivo, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(DiagnosticoPresuntivo, id)

  def changeset(%DiagnosticoPresuntivo{} = diagnostico_presuntivo) do
    DiagnosticoPresuntivo.changeset(diagnostico_presuntivo, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, diagnostico_presuntivo} <- insert(attrs)
      do
        diagnostico_presuntivo
      else
        _ -> Repo.rollback("No grabo Categoria Paciente")
      end
    end)
  end

  def insert(attrs) do
    %DiagnosticoPresuntivo{}
    |> DiagnosticoPresuntivo.changeset(attrs)
    |> Repo.insert()
  end

  def update(%DiagnosticoPresuntivo{} = diagnostico_presuntivo, attrs) do
    diagnostico_presuntivo
    |> DiagnosticoPresuntivo.changeset(attrs)
    |> Repo.update()
  end

  def delete(%DiagnosticoPresuntivo{} = diagnostico_presuntivo) do
    Repo.delete(diagnostico_presuntivo)
  end


  def max_id() do
    query = from t in DiagnosticoPresuntivo, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
