import Node
import DiGraph

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
    build_graph(strands, k, %DiGraph{})
  end

  def build_graph(strands, k, graph) when length(strands) != 0 do
    [{name, strand}| rest] = strands
    head = String.slice(strand, 0, k)
    tail = String.slice(strand, -k, k)
    vertex = %Node{
      name: name,
      head: head,
      tail: tail
    }
    build_graph(rest, k, graph)
  end

  def build_graph(_strands, _k, graph) do
    graph
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
    IO.inspect strands
    IO.inspect build_graph(strands, k)
  end
end
