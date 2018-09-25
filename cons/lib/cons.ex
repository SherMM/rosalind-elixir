defmodule Cons do
  @moduledoc """
  Documentation for Cons.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cons.hello()
      :world

  """
  def get_counts(strands) do
    strands
      |> Enum.map(fn strand -> String.graphemes(strand) end)  
      |> List.zip()
      |> Enum.map(fn group -> Tuple.to_list(group) end)
      |> Enum.map(fn group -> calc_nuc_counts(group) end)
  end

  def get_profile(counts) do
    counts
      |> Enum.map(fn group -> Map.values(group) end)
      |> List.zip()
  end

  def get_consensus(counts) do
    counts
      |> Enum.map(fn group -> group end)
  end

  def calc_nuc_counts(group) do
    calc_nuc_counts(group, %{"A" => 0, "C" => 0, "G" => 0, "T" => 0})
  end

  defp calc_nuc_counts(group, counts) when length(group) != 0 do
    [nuc| rest] = group
    counts = %{counts | nuc => counts[nuc]+1}
    calc_nuc_counts(rest, counts)
  end

  defp calc_nuc_counts(_group, counts) do
    counts
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
    {:ok, pattern} = Regex.compile("(\n)?>Rosalind_[0-9]+\n")
    strands = for l <- String.split(line, pattern), l != "", do: l
    counts = get_counts(strands)
    profile = get_profile(counts)
    IO.inspect counts
    IO.inspect profile
    IO.inspect get_consensus(counts)
  end
end
