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

function get_sides(grid, region)
  num_rows, num_cols = size(grid)

  get_plot(grid, pos) = checkbounds(Bool, grid, pos) ? grid[pos] : nothing

  function get_dir_sides(dir)
    sides = 0
    is_horizontal = dir[1] == 0
    I, J = is_horizontal ? (num_cols, num_rows) : (num_rows, num_cols)
    for i in 1:I
      len = 0
      for j in 1:J+1
        pos = (is_horizontal ? (j, i) : (i, j)) |> CartesianIndex

        if in(pos, region) && get_plot(grid, pos + dir) != grid[pos]
          len += 1
        elseif len != 0
          sides += 1
          len = 0
        end
      end
    end
    sides
  end

  DIRECTIONS .|> get_dir_sides |> sum
end

function solve(filename)
  grid = parse_input(filename)

  unexplored = Set(CartesianIndices(grid))
  prices = []

  while !isempty(unexplored)
    plant_pos = first(unexplored)
    region = Set()

    bfs(grid, plant_pos) do vertex, _
      push!(region, vertex)
      delete!(unexplored, vertex)
    end

    push!(prices, length(region) * get_sides(grid, region))
  end

  sum(prices)
end

solve("input.txt") |> println

# Test with samples
@assert solve("sample1.txt") === 80
@assert solve("sample2.txt") === 436
@assert solve("sample4.txt") === 236
@assert solve("sample5.txt") === 368
@assert solve("input.txt") === 870202
