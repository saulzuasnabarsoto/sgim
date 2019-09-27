defmodule Sgim.PersonalService do
  import Ecto.Query, warn: false

  alias Sgim.Repo
  alias Sgim.Personal

  def list(params) do
    search_term = get_in(params, ["query"])

    search_term = "%#{search_term}%"

    query = from t in Personal, where: like(t.id, ^search_term) or like(t.descripcion, ^search_term), order_by: t.id
    Repo.all(query) |> Repo.preload([:tipo_documento, :categoria_personal])
  end

  def record!(id), do: Repo.get!(Personal, id) |> Repo.preload([:tipo_documento, :categoria_personal])
  def record(id), do: Repo.get(Personal, id) |> Repo.preload([:tipo_documento, :categoria_personal])

  def changeset(%Personal{} = personal) do
    Personal.changeset(personal, %{})
  end

  def create(attrs) do
    Repo.transaction(fn ->
      with {:ok, personal} <- insert(attrs)
      do
        personal
      else
        _ -> Repo.rollback("No grabo Personal")
      end
    end)
  end

  def insert(attrs) do
    %Personal{}
    |> Personal.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Personal{} = personal, attrs) do
    personal
    |> Personal.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Personal{} = personal) do
    Repo.delete(personal)
  end


  def max_id() do
    query = from t in Personal, select: max(t.id)
    [max_value] = Repo.all(query)
    case max_value do
      nil ->   1
      value -> value + 1
    end

  end

end
