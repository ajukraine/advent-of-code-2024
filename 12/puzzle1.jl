# Day 12: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query

parse_input(filename) = stack(readlines(filename), dims=1)

const DIRECTIONS = [(-1, 0); (0, 1); (1, 0); (0, -1)] .|> CartesianIndex

struct Graph
  grid
end

get_neighbors(graph, vertex) =
  DIRECTIONS |>
  @map(_ + vertex) |>
  @filter(checkbounds(Bool, graph.grid, _)) |>
  @filter(graph.grid[_] == graph.grid[vertex]) |>
  collect

function bfs(explore, graph, start)
  q = []
  visited = Set()
  dist = 0

  function visit(vertex, dist)
    push!(q, (vertex, dist))
    push!(visited, vertex)
  end

  visit(start, dist)

  while !isempty(q)
    vertex, dist = popfirst!(q)
    explore(vertex, dist)

    for v in get_neighbors(graph, vertex) |> filter(!in(visited))
      visit(v, dist + 1)
    end
  end
end

function contains_region(outer, inner)
end

function solve(filename)
  grid = parse_input(filename)
  graph = Graph(grid)

  regions = Dict()
  perimeters = Dict()
  unmarked = Set(CartesianIndices(graph.grid))

  while !isempty(unmarked)
    plant_pos = first(unmarked)
    num_of_adjacent_sides = 0
    region = Set()

    bfs(graph, plant_pos) do vertex, dist
      push!(region, vertex)
      delete!(unmarked, vertex)

      num_of_adjacent_sides += length(get_neighbors(graph, vertex))
    end

    regions[plant_pos] = region
    perimeters[plant_pos] = length(regions[plant_pos]) * 4 - num_of_adjacent_sides
  end

  sum(perimeters[plant] * length(regions[plant]) for plant in keys(regions))
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample1.txt") === 140
@assert solve("sample2.txt") === 772
@assert solve("sample3.txt") === 1930
