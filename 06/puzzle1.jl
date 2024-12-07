using Pipe: @pipe
using Match

@enum Direction Up Right Down Left

next(direction) = (@match direction begin
  $Up => (-1, 0)
  $Right => (0, 1)
  $Down => (1, 0)
  $Left => (0, -1)
end) |> CartesianIndex

turn(direction) = @match direction begin
  $Up => Right
  $Right => Down
  $Down => Left
  $Left => Up
end

function solve(filename)
  map = stack(readlines(filename), dims=1)

  current_pos = findfirst(isequal('^'), map)
  direction = Up

  function move(pos)
    next_pos = pos + next(direction)
    while checkbounds(Bool, map, next_pos) && map[next_pos] == '#'
      direction = turn(direction)
      next_pos = pos + next(direction)
    end
    next_pos
  end

  while checkbounds(Bool, map, current_pos)
    map[current_pos] = 'X'
    current_pos = move(current_pos)
  end

  count(isequal('X'), map)
end

solve("input.txt") |> println
