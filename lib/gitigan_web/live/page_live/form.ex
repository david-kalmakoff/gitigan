defmodule GitiganWeb.PageLive.Form do
  use GitiganWeb, :live_view

  alias Gitigan.Pages
  alias Gitigan.Pages.Form

  """
  TODO:
  - add multiple value sets
  - remove value sets
  - save
  """

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage form records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="page-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:form_values]} type="text" label="Values" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Form</.button>
          <.button navigate={return_path(@return_to, @page)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    page = Pages.get_form!(id)

    socket
    |> assign(:page_title, "Edit Form")
    |> assign(:page, page)
    |> assign(:form, to_form(Pages.change_form(page)))
  end

  defp apply_action(socket, :new, _params) do
    page = %Form{}

    socket
    |> assign(:page_title, "New Form")
    |> assign(:page, page)
    |> assign(:form, to_form(Pages.change_form(page)))
  end

  @impl true
  def handle_event("validate", %{"form" => form_params}, socket) do
    changeset = Pages.change_form(socket.assigns.page, form_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"form" => form_params}, socket) do
    save_form(socket, socket.assigns.live_action, form_params)
  end

  defp save_form(socket, :edit, form_params) do
    case Pages.update_form(socket.assigns.page, form_params) do
      {:ok, page} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, page))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_form(socket, :new, form_params) do
    case Pages.create_form(form_params) do
      {:ok, page} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, page))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _page), do: ~p"/forms"
  defp return_path("show", page), do: ~p"/forms/#{page}"
end
