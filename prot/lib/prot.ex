defmodule Prot do
  @moduledoc """
  Documentation for Prot.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Prot.hello()
      :world

  """
  def transcribe_to_protein(dna, codons) do
    stops = ["UAA", "UAG", "UGA"]
    String.graphemes(dna)
      |> Enum.chunk_every(3)
      |> Enum.take_while(fn codon -> Enum.join(codon) not in stops end)
      |> Enum.map(fn codon -> codons[Enum.join(codon)] end)
      |> Enum.join()
  end

  def parse_codon_table(filename) do
    lines = read_lines(filename)
    lines
      |> Enum.map(fn line -> String.split(line) end)
      |> List.flatten()
      |> Enum.chunk_every(2)
      |> Enum.map(fn [k, v] -> {k, v} end)
      |> Map.new
  end

  def read_lines(filename) do
    {:ok, lines} = File.read(filename)
    String.trim(lines, "\n")
      |> String.split("\n")
  end

  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [codons: :string, filename: :string])
    options
  end

  def process([]) do
    IO.puts "No Arguments"
  end

  def process(options) do
    codons = parse_codon_table(options[:codons])
    {:ok, line} = File.read(options[:filename])
    dna = String.trim(line, "\n")
    IO.puts transcribe_to_protein(dna, codons)
  end

end
