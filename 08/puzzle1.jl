# Day 08: Advent of Code 2024

using Query, Combinatorics

parse_input(filename) = stack(readlines(filename), dims=1)

function get_antinodes((a, b))
  diff = a - b
  [a + diff, b - diff]
end

function solve(filename)
  map = parse_input(filename)

  findall(!isequal('.'), map) |>
  @groupby(map[_]) |>
  Iterators.flatten ∘ @map(combinations(_, 2)) |>
  Iterators.flatten ∘ @map(get_antinodes(_)) |>
  @unique() |>
  @filter(checkbounds(Bool, map, _)) |>
  @count()
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === 14
