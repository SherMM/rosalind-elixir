defmodule Mprt do
  use Tesla 

  plug Tesla.Middleware.JSON
  
  def find_motif_matches_for(id) do
    # get primary id code, otherwise redirects
    # for http request won't work, haven't gotten
    # tesla allow redirects to work yet
    [primary_id| _] = String.split(id, "_")
    protein = 
      primary_id
        |> url_for()
        |> Tesla.get()
        |> parse_response()
    matches = find_matches(protein)
    if length(matches) != 0 do
      IO.puts id
      IO.puts Enum.join(
        Enum.map(matches, fn match ->
          Integer.to_string(match) end),
        " ")
    end
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

  def parse_response({:ok, response}) do
    body = response.body
    String.split(body, "\n")
      |> Enum.filter(fn line -> 
        not String.starts_with?(line, ">") 
      end)
      |> Enum.join("")
  end
end
