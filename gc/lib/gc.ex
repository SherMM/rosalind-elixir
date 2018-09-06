defmodule GC do
  @moduledoc """
  Documentation for GC.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GC.hello()
      :world

  """
  def get_gc_content(strand) do
    size = String.length(strand)
    Enum.count(String.graphemes(strand), fn nuc ->
      nuc in ["G", "C"] end) / size
  end

  def get_max_gc_content(strands) do
    strands
      |> Enum.map(fn {code, strand} -> {code, GC.get_gc_content(strand)} end)
      |> Enum.max_by(fn {_, gc} -> gc end)
  end

  def parse_codes_and_strands(lines) do
    parse_codes_and_strands(lines, "", %{})
  end

  defp parse_codes_and_strands(lines, code, strands) when length(lines) != 0 do
    [line|rest] = lines
    if String.starts_with?(line, ">") do
      fasta = String.trim_leading(line, ">")
      parse_codes_and_strands(rest, fasta, Map.put(strands, fasta, ""))
    else
      parse_codes_and_strands(rest, code, %{strands| code => strands[code] <> line})
    end
  end

  defp parse_codes_and_strands([], _code, strands) do
    strands
  end

  def read_lines(filename) do
    {:ok, lines} = File.read(filename)
    lines
      |> String.split("\n")
  end

  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts "no arguments given"
  end

  def process(options) do
    lines = read_lines(options[:filename])
    strands = parse_codes_and_strands(lines)
    {fasta, gc_max} = get_max_gc_content(strands)
    IO.puts fasta
    IO.puts gc_max * 100
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [filename: :string])
    options
  end
end
