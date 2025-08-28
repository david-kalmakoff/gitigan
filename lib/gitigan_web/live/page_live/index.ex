defmodule GitiganWeb.PageLive.Index do
  use GitiganWeb, :live_view

  alias Gitigan.Pages

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Forms
        <:actions>
          <.button variant="primary" navigate={~p"/forms/new"}>
            <.icon name="hero-plus" /> New Form
          </.button>
        </:actions>
      </.header>

      <.table
        id="forms"
        rows={@streams.forms}
        row_click={fn {_id, form} -> JS.navigate(~p"/forms/#{form}") end}
      >
        <:col :let={{_id, form}} label="Name">{form.name}</:col>
        <:col :let={{_id, form}} label="Form values">{form.form_values}</:col>
        <:action :let={{_id, form}}>
          <div class="sr-only">
            <.link navigate={~p"/forms/#{form}"}>Show</.link>
          </div>
          <.link navigate={~p"/forms/#{form}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, form}}>
          <.link
            phx-click={JS.push("delete", value: %{id: form.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Forms")
     |> stream(:forms, Pages.list_forms())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    form = Pages.get_form!(id)
    {:ok, _} = Pages.delete_form(form)

    {:noreply, stream_delete(socket, :forms, form)}
  end
end
