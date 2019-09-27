defmodule SgimWeb.PersonalController do
  use SgimWeb, :controller
  alias Sgim.PersonalService
  alias Sgim.Personal
  alias Sgim.TipoDocumentoService
  alias Sgim.CategoriaPersonalService

  def index(conn, params) do
    personals = PersonalService.list(params)

    conn
    |> render("index.html", personals: personals)
  end

  def new(conn, _params) do
    tipo_documentos = TipoDocumentoService.list()
    categoria_personals = CategoriaPersonalService.list()
    mode = :new
    readonly = false
    titulo = "PERSONAL (NUEVO)"
    maxId = PersonalService.max_id()

    personal = %Personal{id: maxId}
    changeset = PersonalService.changeset(personal)

    assign = %{
      tipo_documentos: tipo_documentos,
      categoria_personals: categoria_personals,
      mode: mode,
      readonly: readonly,
      titulo: titulo,
      personal: personal,
      changeset: changeset
    }

   #render(conn, "crud.html", changeset: changeset, personal: personal, titulo: titulo, readonly: readonly, mode: mode)
    render(conn, "crud.html", assign)
  end

  def create(conn, %{"personal" => personal_params}) do
    with {:ok, _personal} <- PersonalService.create(personal_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.personal_path(conn, :index))
    else
      {:error, _personal} ->
        conn
        |> put_flash(:alert, "Error creando Personal!")
        |> redirect(to: Routes.personal_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => _delete}) do
    tipo_documentos = TipoDocumentoService.list()
    categoria_personals = CategoriaPersonalService.list()
    mode = :delete
    readonly = true
    titulo = "PERSONAL (BORRAR)"
    personal = PersonalService.record(id)
    changeset = PersonalService.changeset(personal)

    assign = %{
      tipo_documentos: tipo_documentos,
      categoria_personals: categoria_personals,
      mode: mode,
      readonly: readonly,
      titulo: titulo,
      personal: personal,
      changeset: changeset
    }
    #render(conn, "crud.html", personal: personal, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode, tipo_documentos: tipo_documentos)
    render(conn, "crud.html", assign)
  end

  def show(conn, %{"id" => id}) do
    tipo_documentos = TipoDocumentoService.list()
    categoria_personals = CategoriaPersonalService.list()
    mode = :show
    readonly = true
    titulo = "PERSONAL (VER)"
    personal = PersonalService.record(id)
    changeset = PersonalService.changeset(personal)

    assign = %{
      tipo_documentos: tipo_documentos,
      categoria_personals: categoria_personals,
      mode: mode,
      readonly: readonly,
      titulo: titulo,
      personal: personal,
      changeset: changeset
    }

    #render(conn, "crud.html", personal: personal, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    render(conn, "crud.html", assign)
  end

  def edit(conn, %{"id" => id}) do
    tipo_documentos = TipoDocumentoService.list()
    categoria_personals = CategoriaPersonalService.list()
    mode = :edit
    readonly = false
    titulo = "PERSONAL (MODIFICAR)"
    personal = PersonalService.record(id)
    changeset = PersonalService.changeset(personal)

    assign = %{
      tipo_documentos: tipo_documentos,
      categoria_personals: categoria_personals,
      mode: mode,
      readonly: readonly,
      titulo: titulo,
      personal: personal,
      changeset: changeset
    }

    #render(conn, "crud.html", personal: personal, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    render(conn, "crud.html", assign)
  end

  def update(conn, %{"id" => id, "personal" => personal_params}) do
    mode = :edit
    readonly = false
    titulo = "PERSONAL (MODIFICAR)"
    personal = PersonalService.record(id)

    case PersonalService.update(personal, personal_params) do
      {:ok, _personal} ->
        conn
        |> put_flash(:info, "Personal grabado exitosamente.")
        |> redirect(to: Routes.personal_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "crud.html", personal: personal, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    personal = PersonalService.record(id)

    {:ok, _personal} = PersonalService.delete(personal)

    conn
    |> put_flash(:info, "Personal borrado exitosamente.")
    |> redirect(to: Routes.personal_path(conn, :index))
  end

end
