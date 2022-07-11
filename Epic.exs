defmodule Epic do

  def factorial(1), do: 1

  def factorial(n) do
    n * factorial(n-1)
  end
      
end
