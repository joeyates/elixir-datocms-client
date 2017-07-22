defmodule DatoCMS do
  use Application

  @cache_path "tmp/dato.cache"

  @doc false
  defmacro __using__(_opts) do
    quote do
      def dato_get(specifier) do
        DatoCMS.Repo.get!(specifier)
      end

      def dato_page(name) do
        DatoCMS.Repo.get!({name})
      end

      def dato_by_type(type, locale) do
        DatoCMS.Repo.localized_items_of_type!(type, locale)
      end

      def dato_meta_tags(specifier, locale) do
        {:ok, tags} = DatoCMS.MetaTags.for_item(specifier, locale)
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
    {:ok, site} = DatoCMS.Site.fetch()
    {:ok, items} = DatoCMS.Items.fetch()
    {:ok, state} = DatoCMS.Internalizer.internalize(site, items)
    {:ok} = put(state)
  end

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
