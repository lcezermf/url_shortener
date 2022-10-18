defmodule UrlShortener.Shortener do
  @doc """
  Module to handles url shortener and get logic.
  """

  @name :shortener_server

  use GenServer

  alias UrlShortener.URL
  alias UrlShortener.State

  # Add cast to count clicks

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

  # Server callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:shorten, url}, _from, state) do
    hashed_url = do_shorten(url)
    new_url = %URL{original: url, hashed_url: hashed_url, count: 1}
    new_state = %{state | urls: [new_url | state.urls]}

    {:reply, new_url, new_state}
  end

  def handle_call(:urls, _from, state) do
    {:reply, state.urls, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | urls: []}}
  end

  defp do_shorten(url) do
    :crypto.hash(:md5, url) |> Base.encode16(case: :lower) |> binary_part(0, 7)
  end
end
