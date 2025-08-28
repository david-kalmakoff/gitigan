defmodule Gitigan.Pages.Form do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forms" do
    field :name, :string
    field :form_values, {:array, :map}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:name, :form_values])
    |> validate_required([:name, :form_values])
  end
end
