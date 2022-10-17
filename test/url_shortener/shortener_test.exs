defmodule UrlShortener.ShortenerTest do
  use ExUnit.Case, async: true

  alias UrlShortener.Shortener

  test "must return a valid genserver" do
    {:ok, pid} = Shortener.start_link()

    assert is_pid(pid)
    assert Process.info(pid)[:registered_name] == :shortener_server
  end

  test "must return the url short version" do
    {:ok, _pid} = Shortener.start_link()

    url = "http://www.pudim.com.br"
    url_md5 = Shortener.shorten(url)

    assert is_binary(url_md5)
  end

  test "must return state with all urls" do
    {:ok, _pid} = Shortener.start_link()

    url = "http://www.pudim.com.br"
    url_md5 = Shortener.shorten(url)

    urls = Shortener.get_urls()

    assert is_map(urls)
    assert urls[url_md5] == "http://www.pudim.com.br"
    assert length(Map.keys(urls)) == 1
  end

  test "must reset the state and clean all urls" do
    {:ok, _pid} = Shortener.start_link()

    url = "http://www.pudim.com.br"
    url_md5 = Shortener.shorten(url)
    urls = Shortener.get_urls()

    assert length(Map.keys(urls)) == 1

    Shortener.clear()

    urls = Shortener.get_urls()
    assert Enum.empty?(urls)
  end
end
