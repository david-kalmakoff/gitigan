defmodule Gitigan.Repo.Migrations.CreateForms do
  use Ecto.Migration

  def change do
    create table(:forms) do
      add :name, :string
      add :form_values, {:array, :map}

      timestamps(type: :utc_datetime)
    end
  end
end
