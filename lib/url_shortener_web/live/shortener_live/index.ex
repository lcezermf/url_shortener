defmodule UrlShortenerWeb.ShortenerLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener
  alias UrlShortener.URL

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(urls: Shortener.get_urls(Shortener.shorterner_server_pid()))
      |> assign(url: %URL{})

    {:ok, socket}
  end

  def handle_event("shorten_url", %{"url" => url}, socket) do
    Shortener.shorten(Shortener.shorterner_server_pid(), url)

    urls = Shortener.get_urls(Shortener.shorterner_server_pid())

    socket =
      socket
      |> assign(urls: urls)

    {:noreply, socket}
  end

  def handle_event("clear_urls", _params, socket) do
    Shortener.clear(Shortener.shorterner_server_pid())

    socket =
      socket
      |> assign(urls: Shortener.get_urls(Shortener.shorterner_server_pid()))

    {:noreply, socket}
  end

  def handle_event("increase-count", %{"hashed" => hashed}, socket) do
    with url <- Shortener.get_url(Shortener.shorterner_server_pid(), hashed),
         Shortener.increase_count(Shortener.shorterner_server_pid(), url.hashed) do
    end

    socket =
      socket
      |> assign(urls: Shortener.get_urls(Shortener.shorterner_server_pid()))

    {:noreply, socket}
  end
end
