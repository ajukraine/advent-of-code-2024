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

  pos = CartesianIndex(1, 1)
  exit = CartesianIndex(size)

  function corrupt(num)
    space = fill(SAFE, size)
    for (x, y) in bytes[begin:num]
      space[y+1, x+1] = CORRUPTED
    end
    space
  end

  lo = 1
  hi = length(bytes)

  while hi > lo
    mid = div((hi + lo), 2)
    space = corrupt(mid)

    distances = fill(-1, size)
    function explore(vertex, dist)
      distances[vertex] = isnothing(dist) ? 0 : dist + 1
    end

    bfs(space, pos, explore)

    if distances[exit] == -1
      hi = mid
    else
      lo = mid + 1
    end
  end

  x, y = bytes[hi]
  "$x,$y"
end

solve("input.txt", (71, 71)) |> println

# Test with sample
@assert solve("sample.txt", (7, 7)) === "6,1"
