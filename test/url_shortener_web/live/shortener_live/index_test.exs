defmodule UrlShortenerWeb.ShortenerLive.IndexTest do
  use UrlShortenerWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  setup do
    {:ok, _pid} = UrlShortener.Shortener.start_link(name: :test_server)

    :ok
  end

  test "must show input and empty state", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.shortener_index_path(conn, :index))

    assert has_element?(view, "input#url")
    assert has_element?(view, "div#urls", "No urls yet!")
  end

  test "must show the shorten url after submit an url", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.shortener_index_path(conn, :index))

    assert has_element?(view, "input#url")

    view
    |> element("form#add_url")
    |> render_submit()

    refute has_element?(view, "div#urls", "No urls yet!")
    assert has_element?(view, "h3", "Shorten urls")
  end

  test "must update click count", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.shortener_index_path(conn, :index))

    assert has_element?(view, "input#url")

    view
    |> element("form#add_url")
    |> render_submit(%{"url" => "http://www.pudim.com.br/"})

    assert has_element?(view, "h3", "Shorten urls")
    assert has_element?(view, "li", "pudim")
    assert has_element?(view, "li", "Clicks 0")

    view
    |> element("li[data-id=0]")
    |> render_click()

    assert has_element?(view, "li", "Clicks 1")
  end

  test "must reset all urls", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.shortener_index_path(conn, :index))

    assert has_element?(view, "input#url")

    view
    |> element("form#add_url")
    |> render_submit()

    assert has_element?(view, "h3", "Shorten urls")

    view
    |> element("button#clear_urls")
    |> render_click()

    assert has_element?(view, "div#urls", "No urls yet!")
  end
end
