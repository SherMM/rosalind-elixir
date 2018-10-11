defmodule Graph do
  @moduledoc """
  Documentation for Graph.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Graph.hello()
      :world

  """
  def build_graph(strands, k) do
    product = for {n1, s1} <- strands, {n2, s2} <- strands, 
      do: {n1, n2, s1, s2}
    product
      |> Enum.filter(fn {_, _, s1, s2} -> s1 != s2 end)
      |> Enum.filter(fn {_, _, s1, s2} ->
          String.slice(s1, -k, k) == String.slice(s2, 0, k)
      end)
      |> Enum.map(fn {n1, n2, _, _} -> {n1, n2} end)
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
    Map.to_list(strands)
  end

  def read_lines(filename) do
    {:ok, lines} = File.read(filename)
    lines
      |> String.split("\n")
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
    k = 3
    lines = read_lines(options[:filename])
    strands = parse_codes_and_strands(lines)
    edges = build_graph(strands, k)
    Enum.each(edges, fn {x, y} ->
      IO.puts "#{x} #{y}"
    end)
  end
end
