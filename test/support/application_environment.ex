defmodule DatoCMS.Test.Support.ApplicationEnvironment do
  def set(value) do
    Application.put_env(
      :json_hyperschema_client_builder,
      DatoCMS.Client,
      value
    )
  end
end
