defmodule UrlShortenerWeb.PageControllerTest do
  use UrlShortenerWeb.ConnCase

  describe "GET /r/:hashed" do
    test "redirect to original URL if the hashed is valid", %{conn: conn} do
      url = UrlShortener.Shortener.shorten("http://www.pudim.com.br")

      conn =
        conn
        |> get(Routes.page_path(conn, :redirect_to, url.hashed))

      assert redirected_to(conn) =~ url.original
    end
  end
end
