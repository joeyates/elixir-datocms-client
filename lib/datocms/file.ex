defmodule DatoCMS.File do
  @doc """
  ```
  dato_file_url(file)
  ```
  """
  def url_for(file, site \\ nil) do
    domain(site) <> file.path
  end

  defp domain(site) do
    site = site || repo_site()
    "https://" <> site.data.attributes.imgix_host
  end

  defp repo_site() do
    DatoCMS.Repo.site!()
  end
end
