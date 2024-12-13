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

function bfs(get_neighbors, explore, start, track_visited=true)
  q = []
  visited = Set()

  function visit(pos, dist)
    push!(q, (pos, dist))
    if track_visited
      push!(visited, pos)
    end
  end

  visit(start, 0)

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
  rate(trailhead) = bfs(get_neighbors, explore, trailhead, false)

  rate.(trailheads)
  heights_counter[9]
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample5.txt") === 81
@assert solve("sample6.txt") === 3
@assert solve("sample7.txt") === 13
@assert solve("sample8.txt") === 227
