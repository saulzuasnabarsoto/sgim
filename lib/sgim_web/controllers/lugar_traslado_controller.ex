defmodule SgimWeb.LugarTrasladoController do
  use SgimWeb, :controller
  alias Sgim.LugarTrasladoService
  alias Sgim.LugarTraslado

  def index(conn, params) do
    lugar_traslados = LugarTrasladoService.list(params)

    conn
    |> render("index.html", lugar_traslados: lugar_traslados)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "LUGAR TRASLADO (NUEVO)"
    maxId = LugarTrasladoService.max_id()

    lugar_traslado = %LugarTraslado{id: maxId}
    changeset = LugarTrasladoService.changeset(lugar_traslado)

    conn
    |> render("crud.html", changeset: changeset, lugar_traslado: lugar_traslado, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"lugar_traslado" => lugar_traslado_params}) do
    with {:ok, _lugar_traslado} <- LugarTrasladoService.create(lugar_traslado_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.lugar_traslado_path(conn, :index))
    else
      {:error, _lugar_traslado} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Paciente!")
        |> redirect(to: Routes.lugar_traslado_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "LUGAR TRASLADO (BORRAR)"
    lugar_traslado = LugarTrasladoService.record!(id)
    changeset = LugarTrasladoService.changeset(lugar_traslado)
    render(conn, "crud.html", lugar_traslado: lugar_traslado, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "LUGAR TRASLADO (VER)"
    lugar_traslado = LugarTrasladoService.record!(id)
    changeset = LugarTrasladoService.changeset(lugar_traslado)
    render(conn, "crud.html", lugar_traslado: lugar_traslado, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "LUGAR TRASLADO (MODIFICAR)"
    lugar_traslado = LugarTrasladoService.record!(id)
    changeset = LugarTrasladoService.changeset(lugar_traslado)
    render(conn, "crud.html", lugar_traslado: lugar_traslado, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "lugar_traslado" => lugar_traslado_params}) do
    mode = :edit
    readonly = false
    titulo = "LUGAR TRASLADO (MODIFICAR)"
    lugar_traslado = LugarTrasladoService.record!(id)

    case LugarTrasladoService.update(lugar_traslado, lugar_traslado_params) do
      {:ok, _lugar_traslado} ->
        conn
        |> put_flash(:info, "Categoría Paciente grabado exitosamente.")
        |> redirect(to: Routes.lugar_traslado_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", lugar_traslado: lugar_traslado, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    lugar_traslado = LugarTrasladoService.record!(id)

    {:ok, _lugar_traslado} = LugarTrasladoService.delete(lugar_traslado)

    conn
    |> put_flash(:info, "LugarTraslado borrado exitosamente.")
    |> redirect(to: Routes.lugar_traslado_path(conn, :index))
  end

end
