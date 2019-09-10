defmodule SgimWeb.ZonaLesionController do
  use SgimWeb, :controller
  alias Sgim.ZonaLesionService
  alias Sgim.ZonaLesion

  def index(conn, params) do
    zona_lesions = ZonaLesionService.list(params)

    conn
    |> render("index.html", zona_lesions: zona_lesions)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "ZONA LESION (NUEVO)"
    maxId = ZonaLesionService.max_id()

    zona_lesion = %ZonaLesion{id: maxId}
    changeset = ZonaLesionService.changeset(zona_lesion)

    conn
    |> render("crud.html", changeset: changeset, zona_lesion: zona_lesion, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"zona_lesion" => zona_lesion_params}) do
    with {:ok, _zona_lesion} <- ZonaLesionService.create(zona_lesion_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.zona_lesion_path(conn, :index))
    else
      {:error, _zona_lesion} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Paciente!")
        |> redirect(to: Routes.zona_lesion_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "ZONA LESION (BORRAR)"
    zona_lesion = ZonaLesionService.record!(id)
    changeset = ZonaLesionService.changeset(zona_lesion)
    render(conn, "crud.html", zona_lesion: zona_lesion, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "ZONA LESION (VER)"
    zona_lesion = ZonaLesionService.record!(id)
    changeset = ZonaLesionService.changeset(zona_lesion)
    render(conn, "crud.html", zona_lesion: zona_lesion, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "ZONA LESION (MODIFICAR)"
    zona_lesion = ZonaLesionService.record!(id)
    changeset = ZonaLesionService.changeset(zona_lesion)
    render(conn, "crud.html", zona_lesion: zona_lesion, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "zona_lesion" => zona_lesion_params}) do
    mode = :edit
    readonly = false
    titulo = "ZONA LESION (MODIFICAR)"
    zona_lesion = ZonaLesionService.record!(id)

    case ZonaLesionService.update(zona_lesion, zona_lesion_params) do
      {:ok, _zona_lesion} ->
        conn
        |> put_flash(:info, "Categoría Paciente grabado exitosamente.")
        |> redirect(to: Routes.zona_lesion_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", zona_lesion: zona_lesion, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    zona_lesion = ZonaLesionService.record!(id)

    {:ok, _zona_lesion} = ZonaLesionService.delete(zona_lesion)

    conn
    |> put_flash(:info, "ZonaLesion borrado exitosamente.")
    |> redirect(to: Routes.zona_lesion_path(conn, :index))
  end

end
