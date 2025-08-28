defmodule Gitigan.PagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gitigan.Pages` context.
  """

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(%{
        form_values: [],
        name: "some name"
      })
      |> Gitigan.Pages.create_page()

    page
  end
end
