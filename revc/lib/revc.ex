defmodule Revc do
  @moduledoc """
  Documentation for Revc.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Revc.hello()
      :world

  """
  def get_complement(nucleotide) do
    case nucleotide do
      "A" -> "T"
      "T" -> "A"
      "C" -> "G"
      "G" -> "C"
    end
  end

  def get_reverse_complement(dna) do
    Enum.map_join(String.graphemes(String.reverse(dna)), "", &Revc.get_complement/1)
  end

  def parse_dna_from_file(filename) do
    File.stream!(filename) 
      |> Stream.map(&(String.replace(&1, "\n", ""))) 
      |> Enum.join()
  end

  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts "No arguments given"
  end

  def process(options) do
    dna = parse_dna_from_file(options[:filename])
    IO.puts Revc.get_reverse_complement(dna)
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [filename: :string])
    options
  end
end
