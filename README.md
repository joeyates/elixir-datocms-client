# DatoCMS Client

Provices access to data in a DatoCMS site.

## Installation

The package can be installed
by adding `datocms_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:datocms_client, "~> 0.1.0"}]
end
```

# Configuration

Assuming your `config/config.exs` includes environment-specific secrets files
excluded from your repo, put the following in `{dev|production}.secrets.exs`:

```elixir
config :datocms_client, :api_config,
  %{headers: ["Authorization": "Bearer nnnnnnnnnnnnnnnnnnnnn"]}
```

Where `nnnnnnnnnnnnnnnnnnnnn` should be replaced by either your read-write or
read-only DatoCMS API key.

If you are only reading data, you can use your read-only access token.

If you see timeout errors when downloading data, add the following:

```elixir
config :datocms_client, :api_config,
  %{
    headers: ["Authorization": "Bearer nnnnnnnnnnnnnnnnnnnnn"],
    options: [recv_timeout: :infinity]
  }
```

# Overview

## DatoCMS.Client

This module contains a REST client for the datocms.com API. The code is
genereated by the `json_hyperschema_client_builder`.

The generated documentation can be found at
[https://hexdocs.pm/datocms_client](https://hexdocs.pm/datocms_client).

## DatoCMS

Provides access to the main data access functionality:

* start/1, start/2 - start the DatoCMS Repo process,
* load/0 - download all site data, internallize it and store it in the Repo,
* put/1 - overwrite the data in the Repo with the supplied values,
* all/0 - retrieve the data in the Repo,
* cache/0 - copy all Repo data to a file on disk,
* load_from_cache/0 - the data from the file on disk and store it in the Repo.

Calling `load/0` downloads `site.json` from the DatoCMS API plus all
(paginated) `items.json` files.

## DatoCMS.Repo

### Internalized Data

All data is held in Elixir `Map` structues with atom keys.

A site's data is stored internally as a `keyword list` containing 3 data
structures:

* `:site` - general information about the site;
* `:internalized_item_types_by_id` - the structure of each item type;
* `:items_by_type` - the data, grouped by item type.
