defmodule SgimWeb.CategoriaPacienteController do
  use SgimWeb, :controller
  alias Sgim.CategoriaPacienteService
  alias Sgim.CategoriaPaciente

  def index(conn, params) do
    categoria_pacientes = CategoriaPacienteService.list(params)

    conn
    |> render("index.html", categoria_pacientes: categoria_pacientes)
  end

  def new(conn, _params) do
    mode = :new
    readonly = false
    titulo = "CATEGORIA PACIENTE (NUEVO)"
    maxId = CategoriaPacienteService.max_id()

    categoria_paciente = %CategoriaPaciente{id: maxId}
    changeset = CategoriaPacienteService.changeset(categoria_paciente)

    conn
    |> render("crud.html", changeset: changeset, categoria_paciente: categoria_paciente, titulo: titulo, readonly: readonly, mode: mode)
  end

  def create(conn, %{"categoria_paciente" => categoria_paciente_params}) do
    with {:ok, _categoria_paciente} <- CategoriaPacienteService.create(categoria_paciente_params)
    do
      conn
      |> put_flash(:info, "Categoría Paciente creado exitosamente!")
      |> redirect(to: Routes.categoria_paciente_path(conn, :index))
    else
      {:error, _categoria_paciente} ->
        conn
        |> put_flash(:alert, "Error creando Categoría Paciente!")
        |> redirect(to: Routes.categoria_paciente_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id, "delete" => delete}) do
    mode = :delete
    readonly = true
    titulo = "CATEGORIA PACIENTE (BORRAR)"
    categoria_paciente = CategoriaPacienteService.record!(id)
    changeset = CategoriaPacienteService.changeset(categoria_paciente)
    render(conn, "crud.html", categoria_paciente: categoria_paciente, changeset: changeset, titulo: titulo, delete: delete, readonly: readonly, mode: mode)
  end

  def show(conn, %{"id" => id}) do
    mode = :show
    readonly = true
    titulo = "CATEGORIA PACIENTE (VER)"
    categoria_paciente = CategoriaPacienteService.record!(id)
    changeset = CategoriaPacienteService.changeset(categoria_paciente)
    render(conn, "crud.html", categoria_paciente: categoria_paciente, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def edit(conn, %{"id" => id}) do
    mode = :edit
    readonly = false
    titulo = "CATEGORIA PACIENTE (MODIFICAR)"
    categoria_paciente = CategoriaPacienteService.record!(id)
    changeset = CategoriaPacienteService.changeset(categoria_paciente)
    render(conn, "crud.html", categoria_paciente: categoria_paciente, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
  end

  def update(conn, %{"id" => id, "categoria_paciente" => categoria_paciente_params}) do
    mode = :edit
    readonly = false
    titulo = "CATEGORIA PACIENTE (MODIFICAR)"
    categoria_paciente = CategoriaPacienteService.record!(id)

    case CategoriaPacienteService.update(categoria_paciente, categoria_paciente_params) do
      {:ok, _categoria_paciente} ->
        conn
        |> put_flash(:info, "Categoría Paciente grabado exitosamente.")
        |> redirect(to: Routes.categoria_paciente_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "No Grabo"
        render(conn, "crud.html", categoria_paciente: categoria_paciente, changeset: changeset, titulo: titulo, readonly: readonly, mode: mode)
    end
  end

  def delete(conn, %{"id" => id}) do

    categoria_paciente = CategoriaPacienteService.record!(id)

    {:ok, _categoria_paciente} = CategoriaPacienteService.delete(categoria_paciente)

    conn
    |> put_flash(:info, "CategoriaPaciente borrado exitosamente.")
    |> redirect(to: Routes.categoria_paciente_path(conn, :index))
  end

end
