defmodule SgimWeb.EstacionLugarController do
  use SgimWeb, :controller
  alias Sgim.EstacionLugarService
  alias Sgim.EstacionLugar

  def index(conn, params) do
    estacion_lugars = EstacionLugarService.list(params)

    conn
    |> render("index.html", estacion_lugars: estacion_lugars)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "ESTACION LUGAR (NUEVO)"
    maxId = EstacionLugarService.max_id()

    estacion_lugar = %EstacionLugar{id: maxId}
    changeset = EstacionLugarService.changeset(estacion_lugar)

    conn
    |> render("crud.html", changeset: changeset, estacion_lugar: estacion_lugar, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"estacion_lugar" => estacion_lugar_params}) do
    with {:ok, _estacion_lugar} <- EstacionLugarService.create(estacion_lugar_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.estacion_lugar_path(conn, :index))
    else
      {:error, _estacion_lugar} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Paciente!")
        |> redirect(to: Routes.estacion_lugar_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "ESTACION LUGAR (BORRAR)"
    estacion_lugar = EstacionLugarService.record!(id)
    changeset = EstacionLugarService.changeset(estacion_lugar)
    render(conn, "crud.html", estacion_lugar: estacion_lugar, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "ESTACION LUGAR (VER)"
    estacion_lugar = EstacionLugarService.record!(id)
    changeset = EstacionLugarService.changeset(estacion_lugar)
    render(conn, "crud.html", estacion_lugar: estacion_lugar, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "ESTACION LUGAR (MODIFICAR)"
    estacion_lugar = EstacionLugarService.record!(id)
    changeset = EstacionLugarService.changeset(estacion_lugar)
    render(conn, "crud.html", estacion_lugar: estacion_lugar, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "estacion_lugar" => estacion_lugar_params}) do
    mode = :edit
    readonly = false
    titulo = "ESTACION LUGAR (MODIFICAR)"
    estacion_lugar = EstacionLugarService.record!(id)

    case EstacionLugarService.update(estacion_lugar, estacion_lugar_params) do
      {:ok, _estacion_lugar} ->
        conn
        |> put_flash(:info, "Categoría Paciente grabado exitosamente.")
        |> redirect(to: Routes.estacion_lugar_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", estacion_lugar: estacion_lugar, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    estacion_lugar = EstacionLugarService.record!(id)

    {:ok, _estacion_lugar} = EstacionLugarService.delete(estacion_lugar)

    conn
    |> put_flash(:info, "EstacionLugar borrado exitosamente.")
    |> redirect(to: Routes.estacion_lugar_path(conn, :index))
  end

end
