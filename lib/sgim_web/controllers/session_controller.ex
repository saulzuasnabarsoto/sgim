defmodule SgimWeb.SessionController do
  use SgimWeb, :controller
  alias Sgim.UsuarioService

  def new(conn, _) do
    render(conn, "new.html")
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "Logged out successfully!")
    |> redirect(to: "/")
  end

  def create(conn, %{"username" => username, "password" => password}) do
    with usuario <- UsuarioService.record_por_cuenta(username),
         {:ok, login_usuario} <- login(usuario, password)
    do
      conn
      |> put_flash(:info, "Logged in successfully!")
      |> put_session(:user, %{ id: login_usuario.id, username: login_usuario.cuenta})
      |> redirect(to: "/")
    else
      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid username/password!")
        |> render("new.html")
    end
  end

  defp login(usuario, password) do
    Bcrypt.check_pass(usuario, password, hash_key: :contrasenia)
  end
end
