defmodule SgimWeb.SintomaPresuntivoController do
  use SgimWeb, :controller
  alias Sgim.SintomaPresuntivoService
  alias Sgim.SintomaPresuntivo

  def index(conn, params) do
    sintoma_presuntivos = SintomaPresuntivoService.list(params)

    conn
    |> render("index.html", sintoma_presuntivos: sintoma_presuntivos)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "SINTOMA PRESUNTIVO (NUEVO)"
    maxId = SintomaPresuntivoService.max_id()

    sintoma_presuntivo = %SintomaPresuntivo{id: maxId}
    changeset = SintomaPresuntivoService.changeset(sintoma_presuntivo)

    conn
    |> render("crud.html", changeset: changeset, sintoma_presuntivo: sintoma_presuntivo, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"sintoma_presuntivo" => sintoma_presuntivo_params}) do
    with {:ok, _sintoma_presuntivo} <- SintomaPresuntivoService.create(sintoma_presuntivo_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.sintoma_presuntivo_path(conn, :index))
    else
      {:error, _sintoma_presuntivo} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Paciente!")
        |> redirect(to: Routes.sintoma_presuntivo_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "SINTOMA PRESUNTIVO (BORRAR)"
    sintoma_presuntivo = SintomaPresuntivoService.record!(id)
    changeset = SintomaPresuntivoService.changeset(sintoma_presuntivo)
    render(conn, "crud.html", sintoma_presuntivo: sintoma_presuntivo, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "SINTOMA PRESUNTIVO (VER)"
    sintoma_presuntivo = SintomaPresuntivoService.record!(id)
    changeset = SintomaPresuntivoService.changeset(sintoma_presuntivo)
    render(conn, "crud.html", sintoma_presuntivo: sintoma_presuntivo, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "SINTOMA PRESUNTIVO (MODIFICAR)"
    sintoma_presuntivo = SintomaPresuntivoService.record!(id)
    changeset = SintomaPresuntivoService.changeset(sintoma_presuntivo)
    render(conn, "crud.html", sintoma_presuntivo: sintoma_presuntivo, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "sintoma_presuntivo" => sintoma_presuntivo_params}) do
    mode = :edit
    readonly = false
    titulo = "SINTOMA PRESUNTIVO (MODIFICAR)"
    sintoma_presuntivo = SintomaPresuntivoService.record!(id)

    case SintomaPresuntivoService.update(sintoma_presuntivo, sintoma_presuntivo_params) do
      {:ok, _sintoma_presuntivo} ->
        conn
        |> put_flash(:info, "Categoría Paciente grabado exitosamente.")
        |> redirect(to: Routes.sintoma_presuntivo_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", sintoma_presuntivo: sintoma_presuntivo, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    sintoma_presuntivo = SintomaPresuntivoService.record!(id)

    {:ok, _sintoma_presuntivo} = SintomaPresuntivoService.delete(sintoma_presuntivo)

    conn
    |> put_flash(:info, "SintomaPresuntivo borrado exitosamente.")
    |> redirect(to: Routes.sintoma_presuntivo_path(conn, :index))
  end

end
