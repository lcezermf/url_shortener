defmodule UrlShortener.Shortener do
  @doc """
  Module to handles url shortener and get logic.
  """

  @name :shortener_server

  use GenServer

  defmodule UrlShortener.ShortenerState do
    defstruct urls: %{}
  end

  alias UrlShortener.ShortenerState

  # Client API

  def start_link(_arg \\ %{}) do
    GenServer.start_link(__MODULE__, %ShortenerState{}, name: @name)
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
    url_md5 = do_shorten(url)
    new_state = %{state | urls: Map.merge(state.urls, %{url_md5 => url})}

    {:reply, url_md5, new_state}
  end

  def handle_call(:urls, _from, state) do
    {:reply, state.urls, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | urls: %{}}}
  end

  defp do_shorten(url) do
    :crypto.hash(:md5, url) |> Base.encode16(case: :lower)
  end
end
