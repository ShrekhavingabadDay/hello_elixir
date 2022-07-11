defmodule ToGuess do

  def start_link do
    Task.start_link(
      fn -> loop(1)
      end
    )
  end

  defp loop(base) do
    receive do
      { :inc, caller } ->
        
        send caller, {
          Enum.random(base..base*10),
          "Numbers from #{base} to #{base*10}"
        }

        loop( base*10 )

      { :reset, _ } ->
        loop(1)
    end
  end

end

defmodule NumGuess do

  def start() do
    {:ok, pid} = ToGuess.start_link
    play(pid)
  end

  def guess_loop(n, pid) do
    case guess(n) do
      :ok ->
        play(pid)
      :quit ->
        IO.puts("Goodbye!\n")
      msg ->
        IO.puts(msg)
        guess_loop(n, pid)
    end
  end

  def play(pid) do
    send(pid, {:inc, self()})
    receive do
      {n, lvl} when n <= 10 ->
        IO.puts("\nGuess the number!\n#{lvl}\nGood luck!\n")
        guess_loop(n, pid)
      {n, lvl} ->
        IO.puts("\nWell done!\nNext level!\n#{lvl}\n")
        guess_loop(n, pid)
    end
  end

  def guess(target) do
    case IO.gets("Guess: ") |> Integer.parse() do
      :error ->
        IO.puts("Couldn't parse integer!\n")

        case IO.gets("Would you like to quit? [y|n] ") |> String.slice(0,1) do
          "y" -> :quit
          _   -> guess(target)
        end

      {x, _} -> compare(x, target)
    end
  end

  def compare(x, target) do
    cond do
      x > target -> "Less"
      x < target -> "More"
      x == target -> :ok
    end
  end

end
