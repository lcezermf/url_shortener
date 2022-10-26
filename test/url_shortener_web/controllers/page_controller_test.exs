defmodule UrlShortenerWeb.PageControllerTest do
  use UrlShortenerWeb.ConnCase

  setup do
    {:ok, _pid} = UrlShortener.Shortener.start_link(name: :test_controller)

    :ok
  end

  describe "GET /r/:hashed" do
    test "redirect to original URL if the hashed is valid", %{conn: conn} do
      url = UrlShortener.Shortener.shorten(shorterner_server_pid(), "http://www.pudim.com.br")

      conn =
        conn
        |> get(Routes.page_path(conn, :redirect_to, url.hashed))

      assert redirected_to(conn) =~ url.original
    end
  end

  defp shorterner_server_pid do
    server = if Mix.env() == :dev, do: :shortener_server, else: :test_controller

    Process.whereis(server)
  end
end
