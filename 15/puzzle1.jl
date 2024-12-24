using Base: nextL
# Day 15: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Logging
using Query

global_logger(ConsoleLogger(stderr, Logging.Info))

# @ - robot, O - box, # - wall
function parse_input(filename)
  lines = readlines(filename)
  emptyline = findfirst(isempty, lines)

  grid = stack(lines[begin:emptyline-1], dims=1)
  moves = join(lines[emptyline+1:end]) |> collect

  grid, moves
end

is_box = isequal('O')
is_wall = isequal('#')
is_robot = isequal('@')
is_empty = isequal('.')

MOVE_MAP = Dict(
  '^' => CartesianIndex(-1, 0),
  '>' => CartesianIndex(0, 1),
  'v' => CartesianIndex(1, 0),
  '<' => CartesianIndex(0, -1)
)

function move(grid, pos, next_pos)
  grid[pos], grid[next_pos] = grid[next_pos], grid[pos]
  next_pos
end

function attempt_move(grid, pos, next_move)
  @debug "Attempt to move" next_move pos
  next_pos = pos + next_move
  next_sym = grid[next_pos]

  can_move = next_sym |> is_empty

  if next_sym |> is_box
    can_move, _ = attempt_move(grid, next_pos, next_move)
  end

  can_move ? (true, move(grid, pos, next_pos)) : (false, pos)
end

function solve(filename)
  grid, moves = parse_input(filename)
  pos = findfirst(is_robot, grid)

  while !isempty(moves)
    next_move = popfirst!(moves)
    @debug "Next move" next_move

    moved, pos = attempt_move(grid, pos, MOVE_MAP[next_move])
    @debug "Moved?" moved
  end

  @info join(grid |> eachrow .|> join, "\n")

  findall(isequal('O'), grid) |> @map((_[1] - 1) * 100 + (_[2] - 1)) |> sum
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample_smaller.txt") === 2028
@assert solve("sample_larger.txt") === 10092
