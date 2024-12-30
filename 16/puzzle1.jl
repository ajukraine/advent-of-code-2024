# Day 16: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Logging
using Query

global_logger(ConsoleLogger(stderr, Logging.Warn))

parse_input(filename) = stack(readlines(filename), dims=1)
log_maze(maze) = @info "\n" * join(maze |> eachrow .|> join, '\n')

const DIRECTIONS = [(-1, 0), (0, 1), (1, 0), (0, -1)] .|> CartesianIndex

get_neighbors(graph, vertex) =
  DIRECTIONS |>
  @map(vertex + _) |>
  @filter(checkbounds(Bool, graph, _)) |>
  @filter(graph[_] == '.' || graph[_] == 'E' || graph[_] == 'S') |>
  collect

function dfs(graph, start, explore)
  stack = []

  start_state = explore(start)
  push!(stack, (start, start_state))

  while !isempty(stack)
    v, state = pop!(stack)

    for w in get_neighbors(graph, v) |> filter(!in(state[1]))
      w_state = explore(w, state)
      if graph[w] != 'E' && !isnothing(w_state)
        push!(stack, (w, w_state))
      end
    end
  end
end

function score_path(path, dir)
  score = length(path) - 1

  prev = path[begin]
  for next in path[begin+1:end]
    if dir != next - prev
      dir = next - prev
      score += 1000
    end
    prev = next
  end

  score
end

function solve(filename)
  maze = parse_input(filename)
  log_maze(maze)

  start_tile = findfirst(isequal('S'), maze)
  end_tile = findfirst(isequal('E'), maze)

  min_score = Inf32
  start_dir = CartesianIndex(0, 1)
  scores = Dict()

  function explore(vertex, state=nothing)
    if isnothing(state)
      scores[(start_dir, start_dir, vertex)] = 0
      return (Set([vertex]), vertex, start_dir, 0)
    end

    path, prev, dir, score = state
    new_dir = vertex - prev

    score += 1
    if new_dir != dir
      score += 1000
    end

    if score > min_score || get(scores, (dir, new_dir, vertex), Inf32) < score
      return nothing
    end

    if vertex == end_tile && score < min_score
      min_score = score
      @debug min_score
    end

    scores[(dir, new_dir, vertex)] = score
    (union(path, [vertex]), vertex, new_dir, score)
  end

  dfs(maze, start_tile, explore)

  min_score
end

solve("sample.txt") |> println

# Test with sample
@assert solve("sample.txt") === 7036
@assert solve("sample2.txt") === 11048
