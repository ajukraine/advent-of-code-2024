# Day 18: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Logging
using Query

global_logger(ConsoleLogger(stderr, Logging.Debug))

parse_input(filename) = split.(readlines(filename), ",") .|> coord -> parse.(Int, coord)

const SAFE = '.'
const CORRUPTED = '#'
const DIRECTIONS = [(-1, 0), (0, 1), (1, 0), (0, -1)] .|> CartesianIndex

get_neighbors(g, v) =
  DIRECTIONS |> @map(v + _) |> @filter(checkbounds(Bool, g, _) && g[_] != CORRUPTED) |> collect

function bfs(graph, start, explore)
  q = []
  visited = Set()

  function visit(vertex, state=nothing)
    state = explore(vertex, state)

    push!(q, (vertex, state))
    push!(visited, vertex)
  end

  visit(start)

  while !isempty(q)
    v, state = popfirst!(q)

    visit.(get_neighbors(graph, v) |> filter(!in(visited)), state)
  end
end

function solve(filename, size)
  bytes = parse_input(filename)
  space = fill(SAFE, size)

  pos = CartesianIndex(1, 1)
  exit = CartesianIndex(size)

  for (x, y) in bytes
    space[y+1, x+1] = CORRUPTED

    distances = fill(-1, size)
    function explore(vertex, dist)
      distances[vertex] = isnothing(dist) ? 0 : dist + 1
    end

    bfs(space, pos, explore)

    if distances[exit] == -1
      return "$x,$y"
    end
  end
end

solve("input.txt", (71, 71)) |> println

# Test with sample
@assert solve("sample.txt", (7, 7)) === "6,1"
