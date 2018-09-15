defmodule DatoCMS.FaviconMetaTags do
  @apple_touch_icon_sizes [57, 60, 72, 76, 114, 120, 144, 152, 180]
  @icon_sizes [16, 32, 96, 192]
  @windows_sizes [{70, 70}, {150, 150}, {310, 310}, {310, 150}]

  def meta_tags(site, theme_color \\ nil) do
    favicon = get_in(site, [:data, :attributes, :favicon])
    name = get_in(site, [:data, :attributes, :name])

    tags = [
      favicon && [
        build_icon_tags(favicon),
        build_apple_icon_tags(favicon),
        build_windows_tags(favicon)
      ],
      theme_color && build_color_tags(theme_color),
      name && build_app_name_tag(name)
    ]
    |> List.flatten
    |> Enum.filter(fn x -> x end)
    {:ok, tags}
  end

  def build_icon_tags(favicon) do
    Enum.map(
      @icon_sizes,
      fn size ->
        link_tag(
          "icon",
          url(favicon, size),
          %{
            sizes: "#{size}x#{size}",
            type: "image/#{favicon.format}"
          }
        )
      end
    )
  end

  def build_apple_icon_tags(favicon) do
    Enum.map(
      @apple_touch_icon_sizes,
      fn size ->
        link_tag(
          "apple-touch-icon",
          url(favicon, size),
          %{sizes: "#{size}x#{size}"}
        )
      end
    )
  end

  def build_windows_tags(favicon) do
    Enum.map(
      @windows_sizes,
      fn {w, h} ->
        meta_tag("msapplication-square#{w}x#{h}logo", url(favicon, w, h))
      end
    )
  end

  def build_color_tags(theme_color) do
    [
      meta_tag("theme-color", theme_color),
      meta_tag("msapplication-TileColor", theme_color)
    ]
  end

  def build_app_name_tag(name) do
    meta_tag("application-name", name)
  end

  def url(favicon, width, height) do
    DatoCMS.Image.url_for(favicon, %{w: width, h: height})
  end
  def url(favicon, width) do
    url(favicon, width, width)
  end

  def meta_tag(name, value) do
    %{tag_name: "meta", attributes: %{name: name, content: value}}
  end

  def link_tag(rel, href, attrs \\ %{}) do
    %{tag_name: "link", attributes: Map.merge(attrs, %{rel: rel, href: href})}
  end
end
