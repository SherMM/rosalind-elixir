defmodule Finder do
    def proteins_for(ids) do
        ids |> Enum.each(fn id ->
            spawn(Mprt, :protein_for, [id])
        end)
    end

    def parse_ids(filename) do
        {:ok, lines} = File.read(filename)
        lines |> String.trim("\n") |> String.split("\n")
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
        proteins_for(uniprot_ids)
    end
end