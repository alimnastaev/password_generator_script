defmodule PasswordGenerator do
  @moduledoc """
  Documentation for `PasswordGenerator`.
  """

  @doc """
  ## Example:
  - How many characters? 10
  - Include numbers? Yes
  - Include special characters? No

  Result: zoanF2um8T
  """

  @letters "ABCDEFGHIJKLMNOPQRSTUVWXYZ" <> "abcdefghijklmnopqrstuvwxyz"
  @integers "0123456789"
  @special "!#$%&'()*+,-./:;<=>?@[]^_{|}~"

  @all (@letters <> @integers <> @special) |> String.split("", trim: true)
  @with_integers (@letters <> @integers) |> String.split("", trim: true)
  @with_special (@letters <> @special) |> String.split("", trim: true)
  @alphabet @letters |> String.split("", trim: true)

  def run() do
    length = get_length()
    integers = with_numbers?()
    special = with_special_characters?()

    generate(length, integers, special)
  end

  defp generate(length, true, true), do: do_generate(@all, length)
  defp generate(length, true, false), do: do_generate(@with_integers, length)
  defp generate(length, false, true), do: do_generate(@with_special, length)
  defp generate(length, _, _), do: do_generate(@alphabet, length)

  defp do_generate(list, length) do
    result =
      1..length
      |> Enum.reduce("", fn _, result -> result <> Enum.random(list) end)

    IO.puts("\n#{result}")
  end

  #### HELPERS ####
  defp get_length() do
    "\nHow many characters?\n"
    |> question()
    |> Integer.parse()
    |> validate_input(:length)
  end

  defp with_numbers?() do
    "\nInclude numbers?\n"
    |> question()
    |> validate_input(:numbers)
  end

  defp with_special_characters?() do
    "\nInclude special characters?\n"
    |> question()
    |> validate_input(:special)
  end

  # length validtion
  defp validate_input({number, _}, :length) when number >= 10, do: number

  defp validate_input(:error, :length) do
    error_message("\n*** Make sure to type a number ***")

    get_length()
  end

  defp validate_input(_, :length) do
    error_message("\n*** Your password should be at least 10 characters long ***")

    get_length()
  end

  # numbers and special validtion
  defp validate_input("Yes", type) when type in [:numbers, :special], do: true
  defp validate_input("No", type) when type in [:numbers, :special], do: false

  defp validate_input(_, :numbers) do
    error_message()

    with_numbers?()
  end

  defp validate_input(_, :special) do
    error_message()

    with_special_characters?()
  end

  defp question(message) do
    IO.gets(yellow_color() <> message <> reset_color())
    |> String.trim()
  end

  defp error_message(message \\ "\n*** Make sure to type Yes or No ***"),
    do: IO.puts(red_color() <> message <> reset_color())

  # colors
  defp red_color(), do: IO.ANSI.red()

  defp yellow_color(), do: IO.ANSI.yellow()

  defp reset_color(), do: IO.ANSI.reset()
end

case System.argv() do
  ["--run"] ->
    PasswordGenerator.run()

  _ ->
    IO.puts(:stderr, "\nplease specify flag --run")
end
