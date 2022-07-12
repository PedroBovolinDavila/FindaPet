defmodule FindapetWeb.Router do
  use FindapetWeb, :router

  alias FindapetWeb.Auth.Pipeline, as: AuthPipeline
  alias FindapetWeb.{EnsureIsAdmin, UUIDChecker}

  pipeline :api do
    plug :accepts, ["json"]
    plug UUIDChecker
  end

  pipeline :auth do
    plug AuthPipeline
  end

  pipeline :ensure_is_admin do
    plug EnsureIsAdmin
  end

  scope "/api", FindapetWeb do
    pipe_through [:api, :auth, :ensure_is_admin]

    get "/users", UsersController, :index
    patch "/users/:id/admin", UsersController, :update_admin

    get "/pets", PetsController, :index
  end

  scope "/api", FindapetWeb do
    pipe_through [:api, :auth]

    resources "/users", UsersController, only: [:show, :update, :delete]
    resources "/pets", PetsController, except: [:new, :edit, :index]

    get "/pets/:id/user_id", PetsController, :get_by_user_id
  end

  scope "/api", FindapetWeb do
    pipe_through :api

    resources "/users", UsersController, except: [:new, :edit, :show, :update, :delete, :index]
    post "/users/session", UsersController, :session
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: FindapetWeb.Telemetry
    end
  end
end
