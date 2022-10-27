defmodule UrlShortener.URL do
  defstruct [:original, :hashed, clicks: 0]
end
