#!/bin/bash

SESSION=$(cat .session)

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
curl "https://adventofcode.com/2024/day/$((10#$day))/input" --cookie "session=$SESSION" -o "input.txt"

# Download and extract example
curl "https://adventofcode.com/2024/day/$((10#$day))" --cookie "session=$SESSION" -o "problem.html"

cat problem.html | \
    awk 'tolower($0) ~ /example/{p=1; next} p&&/<pre><code>/{p=2; sub("<pre><code>",""); print; next} p==2{if(/<\/code><\/pre>/){exit}; print}' | \
    sed 's/&gt;/>/g; s/&lt;/</g;' \
    > sample.txt

# Get answer
example_answer=$(cat problem.html | \
    awk '/<code>[[:space:]]*<em>/{gsub(/.*<code>[[:space:]]*<em>/, ""); gsub(/<\/em>[[:space:]]*<\/code>.*/, ""); print; exit}')

rm problem.html  # cleanup

puzzle_boilerplate() {
    local answer=$1
    cat << EOL
# Day $day: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Logging

global_logger(ConsoleLogger(stderr, Logging.Debug))

function parse_input(filename)
end

function solve(filename)
  parse_input(filename)
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === $answer
EOL
}

# Create both puzzle files using the template function
puzzle_boilerplate "$example_answer" > puzzle1.jl
puzzle_boilerplate "nothing" > puzzle2.jl

# Start Zellij session
zellij -n aoc -s "AOC $day"
