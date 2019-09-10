defmodule SgimWeb.Router do
  use SgimWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SgimWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:create]

    get "/login", SessionController, :new
    get "/logout", SessionController, :delete

    resources "/usuarios", UsuarioController, only: [:index, :new, :show, :create, :edit, :delete, :update]

    resources "/estacions", EstacionController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/estacion_lugars", EstacionLugarController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/categoria_pacientes", CategoriaPacienteController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/sintoma_presuntivos", SintomaPresuntivoController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/diagnostico_presuntivos", DiagnosticoPresuntivoController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/zona_lesions", ZonaLesionController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/lugar_traslados", LugarTrasladoController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/tipo_documentos", TipoDocumentoController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/categoria_personals", CategoriaPersonalController, only: [:index, :new, :create, :edit, :show, :delete, :update]

  end

  # Other scopes may use custom stacks.
  # scope "/api", SgimWeb do
  #   pipe_through :api
  # end
end
