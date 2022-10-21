defmodule UrlShortener.Shortener do
  @doc """
  Module to handles url shortener and get logic.
  """

  @name :shortener_server

  use GenServer

  alias UrlShortener.URL
  alias UrlShortener.State

  require Logger

  # Client API

  def start_link(_arg \\ %{}) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def shorten(hashed_url) do
    GenServer.call(@name, {:shorten, hashed_url})
  end

  def get_url(url) do
    GenServer.call(@name, {:get_url, url})
  end

  def get_urls do
    GenServer.call(@name, :get_urls)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def increase_count(hashed_url) do
    GenServer.cast(@name, {:increase_count, hashed_url})
  end

  # Server callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:shorten, url}, _from, state) do
    hashed_url = do_shorten(url)
    new_url = %URL{original: url, hashed_url: hashed_url}
    new_state = %{state | urls: [new_url | state.urls]}

    {:reply, new_url, new_state}
  end

  def handle_call(:get_urls, _from, state) do
    {:reply, state.urls, state}
  end

  def handle_call({:get_url, hashed_url}, _from, %{urls: urls} = state) do
    case Enum.find(urls, fn url -> url.hashed_url == hashed_url end) do
      nil ->
        {:reply, nil, state}

      url ->
        {:reply, url, state}
    end
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | urls: []}}
  end

  def handle_cast({:increase_count, hashed_url}, %{urls: urls} = state) do
    new_state =
      case Enum.find(urls, fn url -> url.hashed_url == hashed_url end) do
        nil ->
          state

        url ->
          new_url = %{url | count: url.count + 1}
          new_urls = Enum.reject(urls, fn url -> url.hashed_url == hashed_url end)

          %{state | urls: [new_url | new_urls]}
      end

    {:noreply, new_state}
  end

  defp do_shorten(url) do
    :crypto.hash(:md5, url) |> Base.encode16(case: :lower) |> binary_part(0, 7)
  end
end
