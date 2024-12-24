using Base: nextL
# Day 15: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Logging
using Query

global_logger(ConsoleLogger(stderr, Logging.Warn))

is_box = isequal('O')
is_wall = isequal('#')
is_robot = isequal('@')
is_empty = isequal('.')

function wider(tile)
  if is_wall(tile) return "##"
  elseif is_box(tile) return "[]"
  elseif is_empty(tile) return ".."
  elseif is_robot(tile) return "@."
  else return tile
  end
end

# @ - robot, O - box, # - wall
function parse_input(filename)
  lines = readlines(filename)
  emptyline = findfirst(isempty, lines)

  grid = stack(lines[begin:emptyline-1].|> @map(join(_ .|> wider)) |> collect .|> join, dims=1)
  moves = join(lines[emptyline+1:end]) |> collect

  grid, moves
end

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

function can_move_v(grid, pos, next_move)
  next_pos = pos + next_move
  next_sym = grid[next_pos]

  if is_wall(next_sym) return false
  elseif is_empty(next_sym) return true
  end

  box_poses = [next_pos, next_pos + CartesianIndex(next_sym == '[' ? (0, 1) : (0, -1))]

  part1 = can_move_v(grid, box_poses[1], next_move)
  part2 = can_move_v(grid, box_poses[2], next_move)

  part1 && part2
end

function move_v(grid, pos, next_move)
  next_pos = pos + next_move
  next_sym = grid[next_pos]

  box_poses = [next_pos, next_pos + CartesianIndex(next_sym == '[' ? (0, 1) : (0, -1))]

  attempt_move(grid, box_poses[1], next_move)
  attempt_move(grid, box_poses[2], next_move)
end

function attempt_move(grid, pos, next_move)
  @debug "Attempt to move" next_move pos
  next_pos = pos + next_move
  next_sym = grid[next_pos]

  can_move = is_empty(next_sym)

  if (next_sym == '[' || next_sym == ']')
    if next_move[1] != 0
      can_move = can_move_v(grid, pos, next_move)
      if can_move
        move_v(grid, pos, next_move)
      end
    else
      can_move, _ = attempt_move(grid, next_pos, next_move)
    end
  end

  can_move ? (true, move(grid, pos, next_pos)) : (false, pos)
end

function solve(filename)
  grid, moves = parse_input(filename)
  pos = findfirst(is_robot, grid)

  @debug grid
  @info "\n" * join(grid |> eachrow .|> join, "\n")

  while !isempty(moves)
    next_move = popfirst!(moves)

    moved, pos = attempt_move(grid, pos, MOVE_MAP[next_move])
    @info "Next move?" next_move moved
    @info "\n" * join(grid |> eachrow .|> join, "\n")
  end

  findall(isequal('['), grid) |> @map((_[1] - 1) * 100 + (_[2] - 1)) |> sum
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample_larger.txt") === 9021
