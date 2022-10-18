defmodule UrlShortener.Shortener do
  @doc """
  Module to handles url shortener and get logic.
  """

  @name :shortener_server

  use GenServer

  alias UrlShortener.URL
  alias UrlShortener.State

  # Client API

  def start_link(_arg \\ %{}) do
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def shorten(url) do
    GenServer.call(@name, {:shorten, url})
  end

  def get_urls do
    GenServer.call(@name, :urls)
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

  def handle_call(:urls, _from, state) do
    {:reply, state.urls, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | urls: []}}
  end

  def handle_cast({:increase_count, hashed_url}, %{urls: urls} = state) do
    new_state =
      case Enum.find(urls, fn url -> url.hashed_url == hashed_url end) do
        nil ->
          {:noreply, state}

        url ->
          new_url = %{url | count: url.count + 1}
          %{state | urls: [new_url | state.urls]}
      end

    {:noreply, new_state}
  end

  defp do_shorten(url) do
    :crypto.hash(:md5, url) |> Base.encode16(case: :lower) |> binary_part(0, 7)
  end
end
