defmodule GitiganWeb.PageController do
  use GitiganWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
