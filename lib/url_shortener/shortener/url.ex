defmodule UrlShortener.URL do
  @moduledoc false
  defstruct [:original, :hashed, clicks: 0]
end
