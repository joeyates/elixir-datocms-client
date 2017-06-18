defmodule DatoCMS do
  use Application

  def start(_start_type, _args \\ []) do
    DatoCMS.Supervisor.start_link()
  end

  def load do
    {:ok, site} = DatoCMS.Site.fetch()
    {:ok, items} = DatoCMS.Items.fetch()
    {:ok, state} = DatoCMS.Internalizer.internalize(site, items)
    DatoCMS.Repo.put(state)
  end
end
