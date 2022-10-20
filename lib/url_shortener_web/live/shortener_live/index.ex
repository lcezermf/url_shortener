defmodule UrlShortenerWeb.ShortenerLive.Index do
  use UrlShortenerWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(urls: [])

    {:ok, socket}
  end
end
