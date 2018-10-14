defmodule Finder do
    def find_all_motif_matches_for(ids) do
        ids |> Enum.each(fn id ->
            spawn(Mprt, :find_motif_matches_for, [id])
        end)
    end

    def parse_ids(filename) do
        {:ok, lines} = File.read(filename)
        lines |> String.trim("\n") |> String.split("\n")
    end

    def get_all_motifs(filename) do
        ids = parse_ids(filename)
        find_all_motif_matches_for(ids)
    end

    def main(args) do
        args |> process_args |> process
    end

    def process_args(args) do
        {options, _, _} = OptionParser.parse(args, 
        switches: [filename: :string])
        options
    end

    def process([]) do
        IO.puts "No arguments"
    end
    
    def process(options) do
        uniprot_ids = parse_ids(options[:filename])
        IO.inspect uniprot_ids
        find_all_motif_matches_for(uniprot_ids)
    end
end