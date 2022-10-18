defmodule UrlShortener.URL do
  defstruct [:original, :hashed_url, count: 0]
end
