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
  def generate_edges(u, u_strand, vertexes) do
    vertexes
      |> Enum.map(fn {v, v_strand} -> {{u, v}, {u_strand, v_strand}} end)
      |> Enum.filter(fn {{_, _}, {s1, s2}} -> s1 != s2 end)
      |> Enum.map(fn {{name1, name2}, {_, _}} -> {name1, name2} end)
  end

  def build_graph(strands, k) do
    build_graph(strands, k, %{}, %{}, [])
  end

  def build_graph(strands, k, heads, tails, edges) when length(strands) != 0 do
    [{name, strand}| rest] = strands
    head = String.slice(strand, 0, k)
    tail = String.slice(strand, -k, k)
    heads = Map.put_new(heads, head, [])
    tails = Map.put_new(tails, tail, [])

    edges = edges ++ generate_edges(name, strand, Map.get(heads, tail, []))
    edges = edges ++ generate_edges(name, strand, Map.get(tails, head, []))
    heads = %{heads| head => [{name, strand}] ++ heads[head]}
    tails = %{tails| tail => [{name, strand}] ++ tails[tail]}
    build_graph(rest, k, heads, tails, edges)
  end

  def build_graph(_strands, _k, _heads, _tails, edges) do
    edges
  end

  def filter_duplicate_edges(edges) do
    filter_duplicate_edges(edges, MapSet.new())
  end

  def filter_duplicate_edges(edges, seen) when length(edges) != 0 do
    [{head, tail}| rest] = edges
    seen = 
    if not MapSet.member?(seen, {tail, head}) do
      MapSet.put(seen, {head, tail})
    else
      seen
    end
    filter_duplicate_edges(rest, seen)
  end

  def filter_duplicate_edges(_edges, seen) do
    seen
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
    connected = filter_duplicate_edges(edges)
    Enum.each(connected, fn {x, y} ->
      IO.puts "#{x} #{y}"
    end)
  end
end
