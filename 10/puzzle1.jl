# Day 10: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query
using Curry

parse_input(filename) = tryparse.(Int, string.(stack(collect.(readlines(filename)))))

steps(map, pos) =
  [(-1, 0); (0, 1); (1, 0); (0, -1)] |>
  @map(CartesianIndex(_)) |>
  @map(pos + _) |>
  @filter(checkbounds(Bool, map, _)) |>
  @filter(map[_] == map[pos] + 1) |>
  collect

function dfs(get_neighbors, explore, start)
  q = [(start, 0)]
  visited = Set([start])

  function visit(pos, dist)
    push!(q, (pos, dist))
    push!(visited, pos)
  end

  while !isempty(q)
    vertex, dist = popfirst!(q)

    explore(vertex, dist)

    for v in get_neighbors(vertex) |> filter(!in(visited))
      visit(v, dist + 1)
    end
  end
end

function solve(filename)
  map = parse_input(filename)
  trailheads = findall(isequal(0), map)

  heights_counter = Dict()
  get_neighbors(pos) = steps(map, pos)
  explore(pos, dist) = heights_counter[dist] = get(heights_counter, dist, 0) + 1

  dfs.(get_neighbors, explore, trailheads)
  heights_counter[9]
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample1.txt") === 1
@assert solve("sample2.txt") === 2
@assert solve("sample3.txt") === 4
@assert solve("sample4.txt") === 3
@assert solve("sample5.txt") === 36
