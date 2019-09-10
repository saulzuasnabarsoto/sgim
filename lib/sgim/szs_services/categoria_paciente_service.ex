defmodule Sgim.CategoriaPacienteService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.CategoriaPaciente

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in CategoriaPaciente, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(CategoriaPaciente, id)

  def changeset(%CategoriaPaciente{} = categoria_paciente) do
    CategoriaPaciente.changeset(categoria_paciente, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, categoria_paciente} <- insert(attrs)
      do
        categoria_paciente
      else
        _ -> Repo.rollback("No grabo Categoria Paciente")
      end
    end)
  end

  def insert(attrs) do
    %CategoriaPaciente{}
    |> CategoriaPaciente.changeset(attrs)
    |> Repo.insert()
  end

  def update(%CategoriaPaciente{} = categoria_paciente, attrs) do
    categoria_paciente
    |> CategoriaPaciente.changeset(attrs)
    |> Repo.update()
  end

  def delete(%CategoriaPaciente{} = categoria_paciente) do
    Repo.delete(categoria_paciente)
  end


  def max_id() do
    query = from t in CategoriaPaciente, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
