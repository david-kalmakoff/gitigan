defmodule GitiganWeb.Router do
  use GitiganWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GitiganWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :protected do
    plug :browser
    plug :require_auth
  end

  pipeline :unprotected do
    plug :browser
    plug :require_no_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # protected routes
  scope "/", GitiganWeb do
    pipe_through :protected

    # get "/home", PageController, :home

    live "/", PageLive.Index, :index
    live "/forms", PageLive.Index, :index
    live "/forms/new", PageLive.Form, :new
    live "/forms/:id", PageLive.Show, :show
    live "/forms/:id/edit", PageLive.Form, :edit

    scope "/auth" do
      get "/logout", AuthController, :delete
      delete "/logout", AuthController, :delete
    end
  end

  # unprotected routes
  scope "/", GitiganWeb do
    pipe_through :unprotected

    scope "/auth" do
      get "/", AuthController, :index
      get "/callback", AuthController, :callback
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", GitiganWeb do
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gitigan, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GitiganWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # ===========================================================================
  # Plugs
  # ===========================================================================

  # for protected routes
  defp require_auth(%{assigns: %{current_user: %{email: _email}}} = conn, _opts) do
    # check if user is still logged in
    try do
      access_token = get_session(conn, :access_token)
      PocketId.get_user!(access_token)

      conn
    rescue
      # if user is not logged in, redirect to login page
      _ ->
        conn
        |> configure_session(drop: true)
        |> redirect(to: "/auth")
        |> halt()
    end
  end

  defp require_auth(conn, _opts), do: conn |> redirect(to: "/auth") |> halt()

  # for unprotected routes
  defp require_no_auth(%{assigns: %{current_user: %{email: _email}}} = conn, _opts) do
    conn
    |> redirect(to: "/")
    |> halt()
  end

  defp require_no_auth(conn, _opts), do: conn

  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end
