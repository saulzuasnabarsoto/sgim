defmodule SgimWeb.TipoDocumentoController do
  use SgimWeb, :controller
  alias Sgim.TipoDocumentoService
  alias Sgim.TipoDocumento

  def index(conn, params) do
    tipo_documentos = TipoDocumentoService.list(params)

    conn
    |> render("index.html", tipo_documentos: tipo_documentos)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "TIPO DOCUMENTO (NUEVO)"
    maxId = TipoDocumentoService.max_id()

    tipo_documento = %TipoDocumento{id: maxId}
    changeset = TipoDocumentoService.changeset(tipo_documento)

    conn
    |> render("crud.html", changeset: changeset, tipo_documento: tipo_documento, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"tipo_documento" => tipo_documento_params}) do
    with {:ok, _tipo_documento} <- TipoDocumentoService.create(tipo_documento_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.tipo_documento_path(conn, :index))
    else
      {:error, _tipo_documento} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Paciente!")
        |> redirect(to: Routes.tipo_documento_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "TIPO DOCUMENTO (BORRAR)"
    tipo_documento = TipoDocumentoService.record!(id)
    changeset = TipoDocumentoService.changeset(tipo_documento)
    render(conn, "crud.html", tipo_documento: tipo_documento, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "TIPO DOCUMENTO (VER)"
    tipo_documento = TipoDocumentoService.record!(id)
    changeset = TipoDocumentoService.changeset(tipo_documento)
    render(conn, "crud.html", tipo_documento: tipo_documento, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "TIPO DOCUMENTO (MODIFICAR)"
    tipo_documento = TipoDocumentoService.record!(id)
    changeset = TipoDocumentoService.changeset(tipo_documento)
    render(conn, "crud.html", tipo_documento: tipo_documento, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "tipo_documento" => tipo_documento_params}) do
    mode = :edit
    readonly = false
    titulo = "TIPO DOCUMENTO (MODIFICAR)"
    tipo_documento = TipoDocumentoService.record!(id)

    case TipoDocumentoService.update(tipo_documento, tipo_documento_params) do
      {:ok, _tipo_documento} ->
        conn
        |> put_flash(:info, "Categoría Paciente grabado exitosamente.")
        |> redirect(to: Routes.tipo_documento_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", tipo_documento: tipo_documento, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    tipo_documento = TipoDocumentoService.record!(id)

    {:ok, _tipo_documento} = TipoDocumentoService.delete(tipo_documento)

    conn
    |> put_flash(:info, "TipoDocumento borrado exitosamente.")
    |> redirect(to: Routes.tipo_documento_path(conn, :index))
  end

end
