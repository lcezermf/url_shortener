defmodule UrlShortener.ShortenerTest do
  use ExUnit.Case, async: true

  alias UrlShortener.URL
  alias UrlShortener.Shortener

  # Needs to fix them all, cause the process is getting in conflict

  # describe "start_link/0" do
  #   test "must return a valid genserver" do
  #     pid = Process.whereis(:shortener_server)

  #     assert is_pid(pid)
  #     assert Process.info(pid)[:registered_name] == :shortener_server
  #   end
  # end

  # describe "shorten/1" do
  #   test "must return the url short version" do
  #     {:ok, _pid} = Shortener.start_link()

  #     url = "http://www.pudim.com.br"
  #     %URL{} = result = Shortener.shorten(url)

  #     assert result.original == url
  #     assert result.count == 0
  #   end
  # end

  # describe "get_urls/0" do
  #   test "must return state with all urls" do
  #     {:ok, _pid} = Shortener.start_link()

  #     url = "http://www.pudim.com.br"
  #     Shortener.shorten(url)

  #     [first_url | _] = urls = Shortener.get_urls()

  #     assert is_list(urls)
  #     assert first_url.original == "http://www.pudim.com.br"
  #     assert length(urls) == 1
  #   end
  # end

  # describe "clear/0" do
  #   test "must reset the state and clean all urls" do
  #     {:ok, _pid} = Shortener.start_link()

  #     url = "http://www.pudim.com.br"
  #     Shortener.shorten(url)
  #     urls = Shortener.get_urls()

  #     assert length(urls) == 1

  #     Shortener.clear()

  #     assert Enum.empty?(Shortener.get_urls())
  #   end
  # end

  describe "get_url/1" do
    test "return url when given a valid hashed_url" do
      {:ok, _pid} = Shortener.start_link()

      url = "http://www.pudim.com.br"
      shorten_url = Shortener.shorten(url)

      fetched_url = Shortener.get_url(shorten_url.hashed_url)

      assert fetched_url.original == url
    end

    test "return nil when given an invalid hashed_url" do
      {:ok, _pid} = Shortener.start_link()

      assert is_nil(Shortener.get_url("invalid"))
    end
  end

  # describe "increase_count/1" do
  #   test "must increase count every time shorten url is called with a valid hashed_url" do
  #     {:ok, _pid} = Shortener.start_link()

  #     url = "http://www.pudim.com.br"
  #     result = Shortener.shorten(url)

  #     Shortener.increase_count(result.hashed_url)
  #     Shortener.increase_count(result.hashed_url)
  #     Shortener.increase_count(result.hashed_url)

  #     assert Enum.count(Shortener.get_urls()) == 1

  #     [first | _] = Shortener.get_urls()

  #     assert first.count == 3
  #   end

  #   test "must return the state when calls with an not_found hashed_url" do
  #     {:ok, _pid} = Shortener.start_link()

  #     :ok = Shortener.increase_count("invalid_hashed_url")

  #     assert Enum.empty?(Shortener.get_urls())
  #   end
  # end

  # describe "complete flow" do
  #   test "must work properly" do
  #     {:ok, _pid} = Shortener.start_link()

  #     assert Enum.empty?(Shortener.get_urls())

  #     url_one = "url_one"
  #     url_two = "url_two"

  #     Shortener.shorten(url_one)
  #     Shortener.shorten(url_two)

  #     [shortened_url_two, shortened_url_one | _] = result = Shortener.get_urls()

  #     assert Enum.count(result) == 2
  #     assert shortened_url_two.original == url_two
  #     assert shortened_url_two.count == 0
  #     refute is_nil(shortened_url_two.hashed_url)

  #     assert shortened_url_one.original == url_one
  #     assert shortened_url_one.count == 0
  #     refute is_nil(shortened_url_one.hashed_url)

  #     Shortener.increase_count(shortened_url_one.hashed_url)
  #     Shortener.increase_count(shortened_url_one.hashed_url)

  #     Shortener.increase_count(shortened_url_two.hashed_url)

  #     Shortener.increase_count("invalid")

  #     [shorted_url_two, shorted_url_one | _] = result = Shortener.get_urls()

  #     assert Enum.count(result) == 2
  #     assert shorted_url_two.count == 1
  #     assert shorted_url_one.count == 2

  #     Shortener.clear()

  #     assert Enum.empty?(Shortener.get_urls())
  #   end
  # end
end
