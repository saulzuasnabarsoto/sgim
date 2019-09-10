defmodule SgimWeb.EstacionController do
  use SgimWeb, :controller
  alias Sgim.EstacionService
  alias Sgim.Estacion

  def index(conn, params) do
    estacions = EstacionService.list(params)

    conn
    |> render("index.html", estacions: estacions)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "ESTACION (NUEVO)"
    maxId = EstacionService.max_id()

    estacion = %Estacion{id: maxId}
    changeset = EstacionService.changeset(estacion)

    conn
    |> render("crud.html", changeset: changeset, estacion: estacion, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"estacion" => estacion_params}) do
    with {:ok, _estacion} <- EstacionService.create(estacion_params)
    do
      conn
      |> put_flash(:info, "Estación creado exitosamente!")
      |> redirect(to: Routes.estacion_path(conn, :index))
    else
      {:error, _estacion} ->
        conn
        |> put_flash(:alert, "Error creando Estación!")
        |> redirect(to: Routes.estacion_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "ESTACION (BORRAR)"
    estacion = EstacionService.record!(id)
    changeset = EstacionService.changeset(estacion)
    render(conn, "crud.html", estacion: estacion, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "ESTACION (VER)"
    estacion = EstacionService.record!(id)
    changeset = EstacionService.changeset(estacion)
    render(conn, "crud.html", estacion: estacion, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "ESTACION (MODIFICAR)"
    estacion = EstacionService.record!(id)
    changeset = EstacionService.changeset(estacion)
    render(conn, "crud.html", estacion: estacion, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "estacion" => estacion_params}) do
    mode = :edit
    readonly = false
    titulo = "ESTACION (MODIFICAR)"
    estacion = EstacionService.record!(id)

    case EstacionService.update(estacion, estacion_params) do
      {:ok, _estacion} ->
        conn
        |> put_flash(:info, "Estación grabado exitosamente.")
        |> redirect(to: Routes.estacion_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", estacion: estacion, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    estacion = EstacionService.record!(id)

    {:ok, _estacion} = EstacionService.delete(estacion)

    conn
    |> put_flash(:info, "Estacion borrado exitosamente.")
    |> redirect(to: Routes.estacion_path(conn, :index))
  end

end
