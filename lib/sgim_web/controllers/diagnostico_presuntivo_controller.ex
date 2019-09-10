defmodule SgimWeb.DiagnosticoPresuntivoController do
  use SgimWeb, :controller
  alias Sgim.DiagnosticoPresuntivoService
  alias Sgim.DiagnosticoPresuntivo

  def index(conn, params) do
    diagnostico_presuntivos = DiagnosticoPresuntivoService.list(params)

    conn
    |> render("index.html", diagnostico_presuntivos: diagnostico_presuntivos)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "DIAGNOSTICO PRESUNTIVO (NUEVO)"
    maxId = DiagnosticoPresuntivoService.max_id()

    diagnostico_presuntivo = %DiagnosticoPresuntivo{id: maxId}
    changeset = DiagnosticoPresuntivoService.changeset(diagnostico_presuntivo)

    conn
    |> render("crud.html", changeset: changeset, diagnostico_presuntivo: diagnostico_presuntivo, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"diagnostico_presuntivo" => diagnostico_presuntivo_params}) do
    with {:ok, _diagnostico_presuntivo} <- DiagnosticoPresuntivoService.create(diagnostico_presuntivo_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.diagnostico_presuntivo_path(conn, :index))
    else
      {:error, _diagnostico_presuntivo} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Paciente!")
        |> redirect(to: Routes.diagnostico_presuntivo_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "DIAGNOSTICO PRESUNTIVO (BORRAR)"
    diagnostico_presuntivo = DiagnosticoPresuntivoService.record!(id)
    changeset = DiagnosticoPresuntivoService.changeset(diagnostico_presuntivo)
    render(conn, "crud.html", diagnostico_presuntivo: diagnostico_presuntivo, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "DIAGNOSTICO PRESUNTIVO (VER)"
    diagnostico_presuntivo = DiagnosticoPresuntivoService.record!(id)
    changeset = DiagnosticoPresuntivoService.changeset(diagnostico_presuntivo)
    render(conn, "crud.html", diagnostico_presuntivo: diagnostico_presuntivo, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "DIAGNOSTICO PRESUNTIVO (MODIFICAR)"
    diagnostico_presuntivo = DiagnosticoPresuntivoService.record!(id)
    changeset = DiagnosticoPresuntivoService.changeset(diagnostico_presuntivo)
    render(conn, "crud.html", diagnostico_presuntivo: diagnostico_presuntivo, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "diagnostico_presuntivo" => diagnostico_presuntivo_params}) do
    mode = :edit
    readonly = false
    titulo = "DIAGNOSTICO PRESUNTIVO (MODIFICAR)"
    diagnostico_presuntivo = DiagnosticoPresuntivoService.record!(id)

    case DiagnosticoPresuntivoService.update(diagnostico_presuntivo, diagnostico_presuntivo_params) do
      {:ok, _diagnostico_presuntivo} ->
        conn
        |> put_flash(:info, "Categoría Paciente grabado exitosamente.")
        |> redirect(to: Routes.diagnostico_presuntivo_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", diagnostico_presuntivo: diagnostico_presuntivo, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    diagnostico_presuntivo = DiagnosticoPresuntivoService.record!(id)

    {:ok, _diagnostico_presuntivo} = DiagnosticoPresuntivoService.delete(diagnostico_presuntivo)

    conn
    |> put_flash(:info, "DiagnosticoPresuntivo borrado exitosamente.")
    |> redirect(to: Routes.diagnostico_presuntivo_path(conn, :index))
  end

end
