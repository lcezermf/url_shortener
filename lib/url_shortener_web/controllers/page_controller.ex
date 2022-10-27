defmodule UrlShortenerWeb.PageController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener

  def redirect_to(conn, %{"hashed" => hashed}) do
    case UrlShortener.Shortener.get_url(Shortener.shorterner_server_pid(), hashed) do
      nil ->
        conn

      url ->
        redirect(conn, external: url.original)
    end
  end

  def killer(conn, _) do
    UrlShortener.Shortener.kill(Shortener.shorterner_server_pid())

    redirect(conn, to: Routes.shortener_index_path(conn, :index))
  end
end
