defmodule UrlShortener.ShortenerTest do
  use ExUnit.Case, async: true

  alias UrlShortener.URL
  alias UrlShortener.Shortener

  describe "shorten/1" do
    test "must return the url short version" do
      {:ok, pid} = Shortener.start_link(name: :test_1)

      url = "http://www.pudim.com.br"
      %URL{} = result = Shortener.shorten(pid, url)

      assert result.original == url
      assert result.clicks == 0
    end
  end

  describe "get_urls/0" do
    test "must return state with all urls" do
      {:ok, pid} = Shortener.start_link(name: :test_2)

      url = "http://www.pudim.com.br"
      Shortener.shorten(pid, url)

      [first_url | _] = urls = Shortener.get_urls(pid)

      assert is_list(urls)
      assert first_url.original == "http://www.pudim.com.br"
      assert length(urls) == 1
    end
  end

  describe "clear/0" do
    test "must reset the state and clean all urls" do
      {:ok, pid} = Shortener.start_link(name: :test_3)

      url = "http://www.pudim.com.br"
      Shortener.shorten(pid, url)
      urls = Shortener.get_urls(pid)

      assert length(urls) == 1

      Shortener.clear(pid)

      assert Enum.empty?(Shortener.get_urls(pid))
    end
  end

  describe "get_url/1" do
    test "return url when given a valid hashed" do
      {:ok, pid} = Shortener.start_link(name: :test_4)

      url = "http://www.pudim.com.br"
      shorten_url = Shortener.shorten(pid, url)

      fetched_url = Shortener.get_url(pid, shorten_url.hashed)

      assert fetched_url.original == url
    end

    test "return nil when given an invalid hashed" do
      {:ok, pid} = Shortener.start_link(name: :test_5)

      assert is_nil(Shortener.get_url(pid, "invalid"))
    end
  end

  describe "increase_clicks/1" do
    test "must increase clicks every time shorten url is called with a valid hashed" do
      {:ok, pid} = Shortener.start_link(name: :test_6)

      url = "http://www.pudim.com.br"
      result = Shortener.shorten(pid, url)

      Shortener.increase_clicks(pid, result.hashed)
      Shortener.increase_clicks(pid, result.hashed)
      Shortener.increase_clicks(pid, result.hashed)

      assert Enum.count(Shortener.get_urls(pid)) == 1

      [first | _] = Shortener.get_urls(pid)

      assert first.clicks == 3
    end

    test "must return the state when calls with an not_found hashed" do
      {:ok, pid} = Shortener.start_link(name: :test_7)

      :ok = Shortener.increase_clicks(pid, "invalid_hashed")

      assert Enum.empty?(Shortener.get_urls(pid))
    end
  end

  describe "complete flow" do
    test "must work properly" do
      {:ok, pid} = Shortener.start_link(name: :test_8)

      assert Enum.empty?(Shortener.get_urls(pid))

      url_one = "url_one"
      url_two = "url_two"

      Shortener.shorten(pid, url_one)
      Shortener.shorten(pid, url_two)

      [shortened_url_two, shortened_url_one | _] = result = Shortener.get_urls(pid)

      assert Enum.count(result) == 2
      assert shortened_url_two.original == url_two
      assert shortened_url_two.clicks == 0
      refute is_nil(shortened_url_two.hashed)

      assert shortened_url_one.original == url_one
      assert shortened_url_one.clicks == 0
      refute is_nil(shortened_url_one.hashed)

      Shortener.increase_clicks(pid, shortened_url_one.hashed)
      Shortener.increase_clicks(pid, shortened_url_one.hashed)

      Shortener.increase_clicks(pid, shortened_url_two.hashed)

      Shortener.increase_clicks(pid, "invalid")

      [shorted_url_two, shorted_url_one | _] = result = Shortener.get_urls(pid)

      assert Enum.count(result) == 2
      assert shorted_url_two.clicks == 1
      assert shorted_url_one.clicks == 2

      Shortener.clear(pid)

      assert Enum.empty?(Shortener.get_urls(pid))
    end
  end
end
