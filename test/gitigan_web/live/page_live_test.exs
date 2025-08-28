defmodule GitiganWeb.PageLiveTest do
  use GitiganWeb.ConnCase

  import Phoenix.LiveViewTest
  import Gitigan.PagesFixtures

  @create_attrs %{name: "some name", form_values: []}
  @update_attrs %{name: "some updated name", form_values: []}
  @invalid_attrs %{name: nil, form_values: []}
  defp create_page(_) do
    page = page_fixture()

    %{page: page}
  end

  describe "Index" do
    setup [:create_page]

    test "lists all forms", %{conn: conn, page: page} do
      {:ok, _index_live, html} = live(conn, ~p"/forms")

      assert html =~ "Listing Forms"
      assert html =~ page.name
    end

    test "saves new page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/forms")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Page")
               |> render_click()
               |> follow_redirect(conn, ~p"/forms/new")

      assert render(form_live) =~ "New Page"

      assert form_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#page-form", page: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/forms")

      html = render(index_live)
      assert html =~ "Page created successfully"
      assert html =~ "some name"
    end

    test "updates page in listing", %{conn: conn, page: page} do
      {:ok, index_live, _html} = live(conn, ~p"/forms")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#forms-#{page.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/forms/#{page}/edit")

      assert render(form_live) =~ "Edit Page"

      assert form_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#page-form", page: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/forms")

      html = render(index_live)
      assert html =~ "Page updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes page in listing", %{conn: conn, page: page} do
      {:ok, index_live, _html} = live(conn, ~p"/forms")

      assert index_live |> element("#forms-#{page.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#forms-#{page.id}")
    end
  end

  describe "Show" do
    setup [:create_page]

    test "displays page", %{conn: conn, page: page} do
      {:ok, _show_live, html} = live(conn, ~p"/forms/#{page}")

      assert html =~ "Show Page"
      assert html =~ page.name
    end

    test "updates page and returns to show", %{conn: conn, page: page} do
      {:ok, show_live, _html} = live(conn, ~p"/forms/#{page}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/forms/#{page}/edit?return_to=show")

      assert render(form_live) =~ "Edit Page"

      assert form_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#page-form", page: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/forms/#{page}")

      html = render(show_live)
      assert html =~ "Page updated successfully"
      assert html =~ "some updated name"
    end
  end
end
