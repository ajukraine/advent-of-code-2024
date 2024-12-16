# Day 12: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query
using LinearAlgebra

parse_input(filename) = stack(readlines(filename), dims=1)

const DIRECTIONS = [(-1, 0); (0, 1); (1, 0); (0, -1)] .|> CartesianIndex

get_neighbors(grid, vertex) =
  DIRECTIONS |>
  @map(_ + vertex) |>
  @filter(checkbounds(Bool, grid, _)) |>
  @filter(grid[_] == grid[vertex]) |>
  collect

function bfs(explore, grid, start)
  q = []
  visited = Set()

  function visit(vertex, dist=0)
    push!(q, (vertex, dist))
    push!(visited, vertex)
  end

  visit(start)

  while !isempty(q)
    vertex, dist = popfirst!(q)
    explore(vertex, dist)

    for v in get_neighbors(grid, vertex)
      if !in(v, visited)
        visit(v, dist + 1)
      end
    end
  end
end

function solve(filename)
  grid = parse_input(filename)

  prices = []
  unexplored = Set(CartesianIndices(grid))

  while !isempty(unexplored)
    plant_pos = first(unexplored)
    region = Set()

    bfs(grid, plant_pos) do vertex, _
      push!(region, vertex)
      delete!(unexplored, vertex)
    end

    num_of_adjacent_sides = region |> @map(length(get_neighbors(grid, _))) |> sum
    area = length(region)

    push!(prices, area * (area * 4 - num_of_adjacent_sides))
  end

  sum(prices)
end

solve("input.txt") |> println

# Test with samples
@assert solve("sample1.txt") === 140
@assert solve("sample2.txt") === 772
@assert solve("sample3.txt") === 1930
