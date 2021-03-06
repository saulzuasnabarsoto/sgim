defmodule Sgim.TipoDocumentoService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.TipoDocumento

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in TipoDocumento, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query)
  end

  def list do

    query = from t in TipoDocumento
    Repo.all(query)
  end

  def record!(id), do: Repo.get!(TipoDocumento, id)

  def changeset(%TipoDocumento{} = tipo_documento) do
    TipoDocumento.changeset(tipo_documento, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, tipo_documento} <- insert(attrs)
      do
        tipo_documento
      else
        _ -> Repo.rollback("No grabo Categoria Paciente")
      end
    end)
  end

  def insert(attrs) do
    %TipoDocumento{}
    |> TipoDocumento.changeset(attrs)
    |> Repo.insert()
  end

  def update(%TipoDocumento{} = tipo_documento, attrs) do
    tipo_documento
    |> TipoDocumento.changeset(attrs)
    |> Repo.update()
  end

  def delete(%TipoDocumento{} = tipo_documento) do
    Repo.delete(tipo_documento)
  end


  def max_id() do
    query = from t in TipoDocumento, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
