defmodule Dna do
  @moduledoc """
  Documentation for Dna.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dna.hello()
      :world

  """
  def count_nucleotides(dna) do
    count_nucleotides(dna, %{"A" => 0, "C" => 0, "G" => 0, "T" => 0})
  end

  defp count_nucleotides(dna, counts) when dna != "" do
    <<nuc>> <> strand = dna
    counts = %{counts | <<nuc>> => counts[<<nuc>>]+1}
    count_nucleotides(strand, counts)
  end

  defp count_nucleotides(_dna, counts) do
    counts
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
    dna = Dna.parse_dna_from_file(options[:filename])
    counts = Dna.count_nucleotides(dna)
    Enum.each(["A", "C", "G", "T"], fn nuc ->
      IO.write "#{counts[nuc]} " end)
    IO.puts ""
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [filename: :string])
    options
  end
end