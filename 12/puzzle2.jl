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

function get_sides(grid, regions)
  num_rows, num_cols = size(grid)
  num_regions = length(regions)

  sides = fill(0, num_regions)

  get_plot(grid, pos) = checkbounds(Bool, grid, pos) ? grid[pos] : nothing

  for (k, region) in enumerate(regions)

    function calc(pos, dir, len)
      next_pos = pos + dir
      if in(pos, region) && get_plot(grid, next_pos) != grid[pos]
        len += 1
      elseif len != 0
        sides[k] += 1
        len = 0
      end
      len
    end

    for i in 1:num_rows
      up = down = 0
      for j in 1:num_cols
        pos = CartesianIndex(i, j)

        up = calc(pos, CartesianIndex(-1, 0), up)
        down = calc(pos, CartesianIndex(1, 0), down)
      end
      if up != 0
        sides[k] +=1
      end
      if down != 0
        sides[k] += 1
      end
    end

    for j in 1:num_cols
      left = right = 0
      for i in 1:num_rows
        pos = CartesianIndex(i, j)

        right = calc(pos, CartesianIndex(0, 1), right)
        left = calc(pos, CartesianIndex(0, -1), left)
      end
      if left != 0
        sides[k] +=1
      end
      if right != 0
        sides[k] += 1
      end
    end
  end

  sides
end

function solve(filename)
  grid = parse_input(filename)

  unexplored = Set(CartesianIndices(grid))
  regions = []
  areas = []

  while !isempty(unexplored)
    plant_pos = first(unexplored)
    region = Set()

    bfs(grid, plant_pos) do vertex, _
      push!(region, vertex)
      delete!(unexplored, vertex)
    end

    area = length(region)

    push!(regions, region)
    push!(areas, area)
  end

  sides = get_sides(grid, regions)

  dot(sides, areas)
end

solve("input.txt") |> println

# Test with samples
@assert solve("sample1.txt") === 80
@assert solve("sample2.txt") === 436
@assert solve("sample4.txt") === 236
@assert solve("sample5.txt") === 368
