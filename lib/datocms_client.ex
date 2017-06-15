defmodule DatoCMS do
  import JSONHyperschema.ClientBuilder

  @moduledoc """
  Documentation for DatoCMS.
  """

  schema_path = "priv/schemas/site-api-hyperschema.json"
  {:ok, schema_json} = File.read(schema_path)

  defapi "DatoCMS.Client", :datocms_client, schema_json

  def start() do
    HTTPoison.start()
  end
end
