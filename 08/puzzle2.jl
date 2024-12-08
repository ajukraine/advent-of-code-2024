# Day 08: Advent of Code 2024

using Query, Combinatorics

parse_input(filename) = stack(readlines(filename), dims=1)

function get_antinodes((a, b), grid)
  dy, dx = Tuple(a - b)
  d = gcd(dy, dx)
  step = CartesianIndex(dy ÷ d, dx ÷ d)

  nodes = Set()

  function fill_nodes(start, incr)
    while checkbounds(Bool, grid, start)
      push!(nodes, start)
      start += incr
    end
  end

  fill_nodes(a, step)
  fill_nodes(a, -step)

  nodes
end

function solve(filename)
  grid = parse_input(filename)

  findall(!isequal('.'), grid) |>
  @groupby(grid[_]) |>
  Iterators.flatten ∘ @map(combinations(_, 2)) |>
  Iterators.flatten ∘ @map(get_antinodes(_, grid)) |>
  @unique() |>
  @filter(checkbounds(Bool, grid, _)) |>
  @count()
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === 34
