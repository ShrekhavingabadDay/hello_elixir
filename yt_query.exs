defmodule YTQuery do
 
  @yt_link_regex ~r/http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?[\w\?=]*)?/
  @sanity_regex ~r/["'\\]+/

  def query(s) do
    String.match?(s, @yt_link_regex)
      && s
      || 
      case String.replace(s, @sanity_regex, "") do
        ""   -> :error
        res  -> get_url(res)
      end
  end

  def get_url(ytsearch) do

    {url, _exit_code} = System.cmd("yt-dlp", ["--get-url", "ytsearch:{\"#{ytsearch}\"}"])

    [_, audio_url] = String.split(url)

    audio_url
  end

end
