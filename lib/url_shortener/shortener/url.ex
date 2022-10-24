defmodule UrlShortener.URL do
  defstruct [:original, :hashed, count: 0]
end
