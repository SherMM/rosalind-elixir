defmodule Hamm do
  @moduledoc """
  Documentation for Hamm.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hamm.hello()
      :world

  """
  def parse_dna_strands(filename) do
    {:ok, lines} = File.read(filename)
    String.trim(lines, "\n")
      |> String.split("\n")
  end

  def calculate_hamming_distance(strands) do
    strands
      |> Enum.map(fn strand -> String.graphemes(strand) end)
      |> List.zip()
      |> Enum.filter(fn {x, y} -> x != y end)
      |> Enum.count()
  end

  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [filename: :string])
    options
  end

  def process([]) do
    IO.puts "No arguments provided"
  end

  def process(options) do
    strands = parse_dna_strands(options[:filename])
    IO.inspect calculate_hamming_distance(strands)
  end
end
