# Day 10: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query

parse_input(filename) = tryparse.(Int, string.(stack(collect.(readlines(filename)))))

DIRECTIONS = [(-1, 0); (0, 1); (1, 0); (0, -1)] .|> CartesianIndex

steps(pos, map) =
  DIRECTIONS |> @map(pos + _) |> @filter(checkbounds(Bool, map, _))



# trail(pos, map)

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

    s = 0
    for step in (steps(pos, map) |> @filter(!in(_, visited)) |> @filter(map[_] == h + 1))
      s += score(step, visited)
    end

    s
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