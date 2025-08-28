defmodule Gitigan.PagesTest do
  use Gitigan.DataCase

  alias Gitigan.Pages

  describe "forms" do
    alias Gitigan.Pages.Page

    import Gitigan.PagesFixtures

    @invalid_attrs %{name: nil, form_values: nil}

    test "list_forms/0 returns all forms" do
      page = page_fixture()
      assert Pages.list_forms() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Pages.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      valid_attrs = %{name: "some name", form_values: []}

      assert {:ok, %Page{} = page} = Pages.create_page(valid_attrs)
      assert page.name == "some name"
      assert page.form_values == []
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      update_attrs = %{name: "some updated name", form_values: []}

      assert {:ok, %Page{} = page} = Pages.update_page(page, update_attrs)
      assert page.name == "some updated name"
      assert page.form_values == []
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_page(page, @invalid_attrs)
      assert page == Pages.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Pages.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Pages.change_page(page)
    end
  end
end
