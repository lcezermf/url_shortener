defmodule UrlShortenerWeb.PageController do
  use UrlShortenerWeb, :controller

  def redirect_to(conn, %{"hashed" => hashed}) do
    case UrlShortener.Shortener.get_url(:shortener_server, hashed) do
      nil ->
        conn

      url ->
        redirect(conn, external: url.original)
    end
  end

  def killer(conn, _) do
    UrlShortener.Shortener.kill(:shortener_server)

    redirect(conn, to: Routes.shortener_index_path(conn, :index))
  end
end
