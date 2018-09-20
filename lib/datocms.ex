defmodule DatoCMS do
  use Application

  @cache_path "tmp/dato.cache"

  @doc false
  defmacro __using__(_opts) do
    quote do
      def dato_get(specifiers, locale) when is_list(specifiers) do
        Enum.map(specifiers, &dato_get(&1, locale))
      end
      def dato_get({_type} = specifier, locale) do
        DatoCMS.Repo.get!(specifier, locale)
      end
      def dato_get({_type, _id} = specifier, locale) do
        DatoCMS.Repo.get!(specifier, locale)
      end
      def dato_get({_type} = specifier) do
        DatoCMS.Repo.get!(specifier)
      end
      def dato_get({_type, _id} = specifier) do
        DatoCMS.Repo.get!(specifier)
      end
      def dato_get(type, locale) do
        DatoCMS.Repo.get!({type}, locale)
      end
      def dato_get(type) do
        DatoCMS.Repo.get!({type})
      end

      def dato_page(name) do
        DatoCMS.Repo.get!({name})
      end
      def dato_page(name, locale) do
        DatoCMS.Repo.get!({name}, locale)
      end

      def dato_by_type(type, locale) do
        DatoCMS.Repo.localized_items_of_type!(type, locale)
      end

      def dato_meta_tags(specifier, locale) do
        {:ok, tags} = DatoCMS.MetaTags.for_item(specifier, locale)
        stringify_tags(tags)
      end

      def dato_favicon_meta_tags(theme_color \\ nil) do
        {:ok, tags} = DatoCMS.FaviconMetaTags.meta_tags(
          DatoCMS.Repo.site!(),
          theme_color
        )
        stringify_tags(tags)
      end

      def dato_file_url(file) do
        DatoCMS.File.url_for(file)
      end

      def dato_image_url(image, attributes \\ %{}) do
        DatoCMS.Image.url_for(image, attributes)
      end

      defp stringify_tags(tags) do
        Enum.map(tags, fn (tag) ->
          attributes = if tag[:attributes] do
              tag[:attributes]
              |> Enum.map(fn ({k, v}) -> "#{k}=\"#{v}\"" end)
              |> Enum.join(" ")
            else
              ""
            end
          if tag[:content] do
            "<#{tag.tag_name} #{attributes}>#{tag.content}</#{tag.tag_name}>"
          else
            "<#{tag.tag_name} #{attributes}/>"
          end
        end)
        |> Enum.join("")
      end
    end
  end

  def start(_start_type, _args \\ []) do
    DatoCMS.Supervisor.start_link()
  end

  def load do
    DatoCMS.Site.fetch() |> handle_fetch_site
  end

  defp handle_fetch_site({:ok, site}) do
    DatoCMS.Items.fetch() |> handle_fetch_items(site)
  end
  defp handle_fetch_site({:error, response}), do: {:error, response}

  defp handle_fetch_items({:ok, items}, site) do
    {:ok, state} = DatoCMS.Transformer.internalize(site, items)
    {:ok} = put(state)
  end
  defp handle_fetch_items({:error, response}, _site), do: {:error, response}

  def put(state) do
    {:ok} = DatoCMS.Repo.put(state)
  end

  def all do
    DatoCMS.Repo.all!()
  end

  def cache do
    {:ok, state} = DatoCMS.Repo.all()
    path = Path.dirname(@cache_path)
    :ok = File.mkdir_p(path)
    binary = :erlang.term_to_binary(state)
    File.write!(@cache_path, binary)
    {:ok}
  end

  def load_from_cache do
    {:ok, binary} = File.read(@cache_path)
    state = :erlang.binary_to_term(binary)
    {:ok} = DatoCMS.Repo.put(state)
  end
end
