defmodule SgimWeb.UsuarioController do
  use SgimWeb, :controller
  alias Sgim.UsuarioService
  alias Sgim.Usuario

  def index(conn, params) do
    usuarios = UsuarioService.list(params)

    conn
    |> render("index.html", usuarios: usuarios)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "USUARIO (NUEVO)"
    maxId = UsuarioService.max_id()

    usuario = %Usuario{id: maxId}
    changeset = UsuarioService.changeset(usuario)

    conn
    |> render("crud.html", changeset: changeset, usuario: usuario, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"usuario" => usuario_params}) do
    with {:ok, _usuario} <- UsuarioService.create(usuario_params)
    do
      conn
      |> put_flash(:info, "Usuario creado exitosamente!")
      |> redirect(to: Routes.usuario_path(conn, :index))
    else
      {:error, _usuario} ->
        conn
        |> put_flash(:alert, "Error creando Usuario!")
        |> redirect(to: Routes.usuario_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "USUARIO (BORRAR)"
    usuario = UsuarioService.record!(id)
    changeset = UsuarioService.changeset(usuario)
    render(conn, "crud.html", usuario: usuario, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "USUARIO (VER)"
    usuario = UsuarioService.record!(id)
    changeset = UsuarioService.changeset(usuario)
    render(conn, "crud.html", usuario: usuario, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "USUARIO (MODIFICAR)"
    usuario = UsuarioService.record!(id)
    changeset = UsuarioService.changeset(usuario)
    render(conn, "crud.html", usuario: usuario, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "usuario" => usuario_params}) do
    mode = :edit
    readonly = false
    titulo = "USUARIO (MODIFICAR)"
    usuario = UsuarioService.record!(id)

    case UsuarioService.update(usuario, usuario_params) do
      {:ok, _usuario} ->
        conn
        |> put_flash(:info, "Usuario grabado exitosamente.")
        |> redirect(to: Routes.usuario_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", usuario: usuario, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    usuario = UsuarioService.record!(id)

    {:ok, _usuario} = UsuarioService.delete(usuario)

    conn
    |> put_flash(:info, "Usuario borrado exitosamente.")
    |> redirect(to: Routes.usuario_path(conn, :index))
  end

end
