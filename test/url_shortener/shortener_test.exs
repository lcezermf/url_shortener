defmodule UrlShortener.ShortenerTest do
  use ExUnit.Case, async: true

  alias UrlShortener.URL
  alias UrlShortener.Shortener

  describe "start_link/0" do
    test "must return a valid genserver" do
      {:ok, pid} = Shortener.start_link()

      assert is_pid(pid)
      assert Process.info(pid)[:registered_name] == :shortener_server
    end
  end

  describe "shorten/1" do
    test "must return the url short version" do
      {:ok, _pid} = Shortener.start_link()

      url = "http://www.pudim.com.br"
      %URL{} = result = Shortener.shorten(url)

      assert result.original == url
      assert result.count == 0
    end
  end

  describe "get_urls/0" do
    test "must return state with all urls" do
      {:ok, _pid} = Shortener.start_link()

      url = "http://www.pudim.com.br"
      Shortener.shorten(url)

      [first_url | _] = urls = Shortener.get_urls()

      assert is_list(urls)
      assert first_url.original == "http://www.pudim.com.br"
      assert length(urls) == 1
    end
  end

  describe "clear/0" do
    test "must reset the state and clean all urls" do
      {:ok, _pid} = Shortener.start_link()

      url = "http://www.pudim.com.br"
      Shortener.shorten(url)
      urls = Shortener.get_urls()

      assert length(urls) == 1

      Shortener.clear()

      assert Enum.empty?(Shortener.get_urls())
    end
  end

  describe "increase_count/1" do
    test "must increase count every time shorten url is called with a valid hashed_url" do
      {:ok, _pid} = Shortener.start_link()

      url = "http://www.pudim.com.br"
      result = Shortener.shorten(url)

      Shortener.increase_count(result.hashed_url)
      Shortener.increase_count(result.hashed_url)
      Shortener.increase_count(result.hashed_url)

      [first | _] = Shortener.get_urls()

      assert first.count == 3
    end

    test "must return the state when calls with an not_found hashed_url" do
      {:ok, _pid} = Shortener.start_link()

      :ok = Shortener.increase_count("invalid_hashed_url")
    end
  end
end
