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
    profile = get_profile(counts, %{"A"=>[], "C"=>[], "G"=>[], "T"=>[]})
    for {k, v} <- profile, into: %{}, do: {k, Enum.reverse(v)}
  end

  defp get_profile(counts, profile) when length(counts) > 0 do
    [group|rest] = counts
    profile = Map.merge(group, profile, fn _k, v, list ->
      [v| list]
    end)
    get_profile(rest, profile)
  end

  defp get_profile(_counts, profile) do
    profile
  end

  def print_profile(profile) do
    profile
      |> Enum.map(fn {k, v} -> {k, Enum.join(v, " ")} end)
      |> Enum.map(fn {k, v} -> IO.puts "#{k}: #{v}" end)   
  end

  def get_consensus(counts) do
    counts
      |> Enum.map(fn group -> get_consensus_nuc(group) end)
      |> Enum.map(fn {nuc, _} -> nuc end)
      |> Enum.join("")
  end

  def get_consensus_nuc(group) do
    Enum.max_by(group, fn {_, v} -> v end)
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
    strands = for l <- String.split(String.trim(line), pattern), l != "", do: String.replace(l, "\n", "")
    counts = get_counts(strands)
    profile = get_profile(counts)
    IO.puts get_consensus(counts)
    print_profile(profile)
  end
end
