defmodule Slug do
  @doc ~S"""
  Returns a slug, combining id and title.

  ## Example

      iex> Slug.for(123, "ciao")
      "123-ciao"

  ## Normalization

  The title is downcased:

      iex> Slug.for(123, "AAAAA")
      "123-aaaaa"

  Non-Latin characters are transliterated:

      iex> Slug.for(123, "andò")
      "123-ando"

  Separator characters are converted to '-':

      iex> Slug.for(123, "R&R")
      "123-r-r"

  Leading '-' is removed:

      iex> Slug.for(123, "-1")
      "123-1"

  Trailing '-' is removed:

      iex> Slug.for(123, "1-")
      "123-1"

  The text part is capped at 51 characters:

      iex> Slug.for(123, String.duplicate("a", 100))
      "123-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  """

  @max_text 51

  def for(id, title) do
    clean =
      String.normalize(title, :nfd)
      |> String.replace(" ", "-")
      |> String.replace("'", "-")
      |> String.replace("’", "-")
      |> String.replace(",", "-")
      |> String.replace("&", "-")
      |> String.replace("+", "-")
      |> String.replace(".", "-")
      |> String.replace("#", "-")
      |> String.replace("/", "-")
      |> String.replace("@", "-")
      |> String.replace(~r/[^0-9\-A-z]/u, "")
      |> String.downcase
    stripped =
      String.replace_leading(clean, "-", "")
      |> String.replace_trailing("-", "")
    deduped = String.replace(stripped, ~r/\-\-+/u, "-")
    sliced = String.slice(deduped, 0, @max_text)
    "#{id}-#{sliced}"
  end
end
