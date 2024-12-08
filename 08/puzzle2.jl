# Day 08: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query, Combinatorics

parse_input(filename) = stack(readlines(filename), dims=1)

function get_antinodes((a, b), grid)
  dy, dx = Tuple(a - b)
  d = gcd(dy, dx)
  step = CartesianIndex(dy ÷ d, dx ÷ d)

  function get_nodes(start, diff)
    nodes = Set()
    while checkbounds(Bool, grid, start)
      push!(nodes, start)
      start += diff
    end
    nodes
  end

  union(get_nodes(a, -step), get_nodes(a, step))
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
