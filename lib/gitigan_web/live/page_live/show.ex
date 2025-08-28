defmodule GitiganWeb.PageLive.Show do
  use GitiganWeb, :live_view

  alias Gitigan.Pages

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Form {@form.id}
        <:subtitle>This is a form record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/forms"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/forms/#{@form}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit form
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@form.name}</:item>
        <:item title="Form values">{@form.form_values}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Form")
     |> assign(:form, Pages.get_form!(id))}
  end
end
