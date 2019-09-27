defmodule SgimWeb.CategoriaPersonalController do
  use SgimWeb, :controller
  alias Sgim.CategoriaPersonalService
  alias Sgim.CategoriaPersonal

  def index(conn, params) do
    categoria_personals = CategoriaPersonalService.list(params)

    conn
    |> render("index.html", categoria_personals: categoria_personals)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "CATEGORIA PERSONAL (NUEVO)"
    maxId = CategoriaPersonalService.max_id()

    categoria_personal = %CategoriaPersonal{id: maxId}
    changeset = CategoriaPersonalService.changeset(categoria_personal)

    conn
    |> render("crud.html", changeset: changeset, categoria_personal: categoria_personal, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"categoria_personal" => categoria_personal_params}) do
    with {:ok, _categoria_personal} <- CategoriaPersonalService.create(categoria_personal_params)
    do
      conn
      |> put_flash(:info, "Categoría Personal creado exitosamente!")
      |> redirect(to: Routes.categoria_personal_path(conn, :index))
    else
      {:error, _categoria_personal} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Personal!")
        |> redirect(to: Routes.categoria_personal_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "CATEGORIA PERSONAL (BORRAR)"
    categoria_personal = CategoriaPersonalService.record!(id)
    changeset = CategoriaPersonalService.changeset(categoria_personal)
    render(conn, "crud.html", categoria_personal: categoria_personal, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "CATEGORIA PERSONAL (VER)"
    categoria_personal = CategoriaPersonalService.record!(id)
    changeset = CategoriaPersonalService.changeset(categoria_personal)
    render(conn, "crud.html", categoria_personal: categoria_personal, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "CATEGORIA PERSONAL (MODIFICAR)"
    categoria_personal = CategoriaPersonalService.record!(id)
    changeset = CategoriaPersonalService.changeset(categoria_personal)
    render(conn, "crud.html", categoria_personal: categoria_personal, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "categoria_personal" => categoria_personal_params}) do
    mode = :edit
    readonly = false
    titulo = "CATEGORIA PERSONAL (MODIFICAR)"
    categoria_personal = CategoriaPersonalService.record!(id)

    case CategoriaPersonalService.update(categoria_personal, categoria_personal_params) do
      {:ok, _categoria_personal} ->
        conn
        |> put_flash(:info, "Categoría Personal grabado exitosamente.")
        |> redirect(to: Routes.categoria_personal_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "crud.html", categoria_personal: categoria_personal, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    categoria_personal = CategoriaPersonalService.record!(id)

    {:ok, _categoria_personal} = CategoriaPersonalService.delete(categoria_personal)

    conn
    |> put_flash(:info, "Categoria Personal borrado exitosamente.")
    |> redirect(to: Routes.categoria_personal_path(conn, :index))
  end

end
