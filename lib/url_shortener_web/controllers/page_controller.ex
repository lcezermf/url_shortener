defmodule UrlShortenerWeb.PageController do
  use UrlShortenerWeb, :controller

  def redirect_to(conn, %{"hashed" => hashed}) do
    case UrlShortener.Shortener.get_url(shorterner_server_pid(), hashed) do
      nil ->
        conn

      url ->
        redirect(conn, external: url.original)
    end
  end

  def killer(conn, _) do
    UrlShortener.Shortener.kill(shorterner_server_pid())

    redirect(conn, to: Routes.shortener_index_path(conn, :index))
  end

  defp shorterner_server_pid do
    server = if Mix.env() == :dev, do: :shortener_server, else: :test_controller

    Process.whereis(server)
  end
end
