defmodule Prtm do
  @moduledoc """
  Documentation for Prtm.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Prtm.hello()
      :world

  """
  def parse_mass_table(filename) do
    {:ok, lines} = File.read(filename)
    lines 
      |> String.trim("\n") 
      |> String.split("\n")
      |> Enum.map(fn line -> String.split(line) end)
      |> Enum.map(fn [acid, weight] -> 
        {acid, String.to_float(weight)} 
      end)
      |> Map.new
  end

  def calculate_protein_mass(protein, table) do
    String.graphemes(protein)
      |> Enum.reduce(0, fn acid, acc -> 
        table[acid] + acc 
      end)
  end

  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    {options, _, _} = OptionParser.parse(args, 
      switches: [masses: :string, protein: :string])
    options
  end

  def process([]) do
    IO.puts "No Arguments"
  end

  def process(options) do
    protein_mass_file = options[:masses]
    protein_file = options[:protein]
    table = parse_mass_table(protein_mass_file)
    {:ok, protein} = File.read(protein_file)
    protein = String.trim(protein, "\n")
    IO.puts calculate_protein_mass(protein, table)
  end
end
