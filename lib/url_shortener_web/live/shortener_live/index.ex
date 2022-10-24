defmodule UrlShortenerWeb.ShortenerLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener
  alias UrlShortener.URL

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(urls: Shortener.get_urls())
      |> assign(url: %URL{})

    {:ok, socket}
  end

  def handle_event("shorten_url", %{"url" => url}, socket) do
    Shortener.shorten(url)

    urls = Shortener.get_urls()

    socket =
      socket
      |> assign(urls: urls)

    {:noreply, socket}
  end

  def handle_event("clear_urls", _params, socket) do
    Shortener.clear()

    socket =
      socket
      |> assign(urls: Shortener.get_urls())

    {:noreply, socket}
  end

  def handle_event("increase-count", %{"hashed" => hashed}, socket) do
    with url <- Shortener.get_url(hashed),
         Shortener.increase_count(url.hashed) do
    end

    socket =
      socket
      |> assign(urls: Shortener.get_urls())

    {:noreply, socket}
  end
end
