defmodule Mprt do
  
  def protein_for(id) do
    protein = 
      id
        |> url_for()
        |> HTTPoison.get()
        |> parse_response()
    {id, protein}
  end

  def find_matches(strand) do
    {:ok, regex} = Regex.compile("N[^P][ST][^P]")
    find_matches(strand, regex, 0, 4, String.length(strand), [])
  end

  def find_matches(strand, regex, i, j, k, positions) when i < k do
    sub = String.slice(strand, i, j)
    has_match = Regex.match?(regex, sub)
    positions = 
      if has_match do
        [i+1| positions]
      else
        positions
      end
    find_matches(strand, regex, i+1, j, k, positions)
  end


  def find_matches(_strand, _regex, _i, _j, _k, positions) do
    Enum.reverse(positions)
  end

  def url_for(id) do
    "https://www.uniprot.org/uniprot/#{id}.fasta"
  end

  def parse_response(response) do
    {_, %HTTPoison.Response{body: body, status_code: 200}} = response
    String.split(body, "\n")
      |> Enum.filter(fn line -> 
        not String.starts_with?(line, ">") 
      end)
      |> Enum.join("")
  end
end
