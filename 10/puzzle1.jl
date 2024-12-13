# Day 10: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query
using Curry

parse_input(filename) = tryparse.(Int, string.(stack(collect.(readlines(filename)))))

DIRECTIONS = [(-1, 0); (0, 1); (1, 0); (0, -1)] .|> CartesianIndex

steps(pos, map) =
  [(-1, 0); (0, 1); (1, 0); (0, -1)] .|>
  CartesianIndex |>
  @map(pos + _) |>
  @filter(checkbounds(Bool, map, _))

function solve(filename)
  parse
  map = parse_input(filename)
  trailheads = findall(isequal(0), map)

  function score(pos, visited=Set())
    push!(visited, pos)

    h = map[pos]

    if h == 9
      return 1
    end

    steps(pos, map) |>
    @filter(!in(_, visited)) |>
    @filter(map[_] == h + 1) |>
    @map(score(_, visited)) |>
    x -> sum(x, init=0)
  end

  score.(trailheads) |> sum
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample1.txt") === 1
@assert solve("sample2.txt") === 2
@assert solve("sample3.txt") === 4
@assert solve("sample4.txt") === 3
@assert solve("sample5.txt") === 36
