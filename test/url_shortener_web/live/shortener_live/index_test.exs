defmodule UrlShortenerWeb.ShortenerLive.IndexTest do
  use UrlShortenerWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "ok", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.shortener_index_path(conn, :index))

    assert has_element?(view, "input#url")
  end
end
