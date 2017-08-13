defmodule DatoCMS.Image do
  @extra_attributes %{ixlib: "rb-1.1.0", auto: "compress,format"}

  @doc """
  Accepts a chain of attributes to be converted to params:

  ```
  dato_image_url(img, ch: "Width,DPR", width: 200, ...)
  ```
  """
  def url_for(image, attributes \\ %{}) do
    all = Map.merge(@extra_attributes, attributes)
    domain() <> image.path <> "?" <> URI.encode_query(all)
  end

  defp domain() do
    "https://" <> site().data.attributes.imgix_host
  end

  defp site(), do: DatoCMS.Repo.site!()
end
