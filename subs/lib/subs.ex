defmodule Subs do
  @moduledoc """
  Documentation for Subs.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Subs.hello()
      :world

  """
  def find_substr_matching_positions(dna, sub) do
    find_substr_matching_positions(dna, sub, 0, String.length(sub), String.length(dna), [])
  end


  defp find_substr_matching_positions(dna, sub, i, k, n, positions) when i <= n - k do
    s = String.slice(dna, i..i+k-1)
    if s == sub do
      find_substr_matching_positions(dna, sub, i+1, k, n, [i+1|positions])
    else
      find_substr_matching_positions(dna, sub, i+1, k, n, positions)
    end
  end

  defp find_substr_matching_positions(_dna, _sub, _i, _k, _n, positions) do
    positions
  end

  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [filename: :string])
    options
  end

  def process([]) do
    IO.puts "No Arguments"
  end

  def process(options) do
    {:ok, line} = File.read(options[:filename])
    [dna, sub] = String.split(String.trim(line, "\n"), "\n")
    IO.puts Enum.join(Enum.reverse(find_substr_matching_positions(dna, sub)), " ")
  end
end
