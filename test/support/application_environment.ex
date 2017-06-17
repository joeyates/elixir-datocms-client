defmodule DatoCMS.Test.Support.ApplicationEnvironment do
  def set(value) do
    Application.put_env(
      :datocms_client,
      :api_config,
      value
    )
  end
end
