# Day 16: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Logging
using Query
using DataStructures

global_logger(ConsoleLogger(stderr, Logging.Debug))

parse_input(filename) = stack(readlines(filename), dims=1)
log_maze(maze) = @info "\n" * join(maze |> eachrow .|> join, '\n')
is_start = isequal('S')
is_end = isequal('E')
is_wall = isequal('#')

const DIRECTIONS = [(-1, 0), (0, 1), (1, 0), (0, -1)] .|> CartesianIndex

get_neighbors(graph, vertex) =
  DIRECTIONS |>
  @map(vertex + _) |>
  @filter(checkbounds(Bool, graph, _)) |>
  @filter(!is_wall(graph[_])) |>
  collect

get_score(to, from, dir, score) = (to - from == dir ? 1 : 1001) + score
get_score(to) = 0

function dijkstra(graph, start, explore)
  q = PriorityQueue()
  visited = Set()

  state = explore(start, 0)
  score = get_score(start)
  push!(q, (start, CartesianIndex(0, 1)) => score)

  while !isempty(q)
    (v, dir), score = dequeue_pair!(q)
    push!(visited, v)

    for w in get_neighbors(graph, v)
      if !in(w, visited)
        w_score = get_score(w, v, dir, score)
        w_dir = w - v
        explore(w, w_score)
        push!(q, (w, w_dir) => w_score)
      end
    end
  end

end

function solve(filename)
  maze = parse_input(filename)

  start_tile = findfirst(is_start, maze)
  end_tile = findfirst(is_end, maze)

  scores = Dict()

  function explore(vertex, score, dir=(0, 1))
    scores[vertex] = score
  end

  dijkstra(maze, start_tile, explore)

  scores[end_tile]
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === 7036
@assert solve("sample2.txt") === 11048
