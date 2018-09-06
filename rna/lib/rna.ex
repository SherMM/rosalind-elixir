defmodule Rna do
  @moduledoc """
  Documentation for Rna.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Rna.hello()
      :world

  """
  def transcribe_nucleotide(nucleotide) do
    if nucleotide == "T" do
      "U"
    else
      nucleotide
    end
  end

  def transcribe_dna(dna) do
    Enum.map_join(String.graphemes(dna), "", &Rna.transcribe_nucleotide/1)
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
    IO.puts Rna.transcribe_dna(dna)
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [filename: :string])
    options
  end
end
