#!/bin/bash

# Check if a day number was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a day number"
    echo "Usage: ./new.sh <day_number>"
    exit 1
fi

# Get the day number and pad it with zero if needed
day=$(printf "%02d" $1)

# Create the directory structure
mkdir -p $day
cd $day

# Create input files
touch "input.txt"
touch "sample.txt"

# Create Julia solution file
cat > "puzzle1.jl" << EOL
# Day $day: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

function parse_input(filename)
end

function solve(filename)
  parse_input(filename)
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === nothing
EOL

# Create puzzle2.jl with the same content
cp puzzle1.jl puzzle2.jl

# Start Zellij session
zellij -n aoc -s "AOC $day"
