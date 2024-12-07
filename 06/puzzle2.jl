using Pipe: @pipe
using Match

@enum Direction Up Right Down Left

next(direction) = @match direction begin
  $Up => CartesianIndex(-1, 0)
  $Right => CartesianIndex(0, 1)
  $Down => CartesianIndex(1, 0)
  $Left => CartesianIndex(0, -1)
end

turn(direction) = @match direction begin
  $Up => Right
  $Right => Down
  $Down => Left
  $Left => Up
end

function walk(map, move)
  route = Set()

  function move_next((pos, dir))
    next_pos = pos + next(dir)
    while checkbounds(Bool, map, next_pos) && (in(map[next_pos], ['#'; 'O']))
      dir = turn(dir)
      next_pos = pos + next(dir)
    end

    (next_pos, dir)
  end

  while checkbounds(Bool, map, move[1])
    push!(route, move)

    move = move_next(move)

    if move in route
      return (route, move)
    end
  end

  (route, nothing)
end

function with_obstacle(f, map, obstacle)
  tmp = map[obstacle]
  map[obstacle] = 'O'

  f(map)

  map[obstacle] = tmp
end

function solve(filename)
  map = stack(readlines(filename), dims=1)

  start = findfirst(isequal('^'), map), Up

  route, _ = walk(map, start)

  num_of_loops = 0
  for obstacle in unique(first.(route))
    with_obstacle(map, obstacle) do map
      _, loop = walk(map, start)

      if !isnothing(loop)
        num_of_loops += 1
      end
    end
  end

  num_of_loops
end

solve("input.txt") |> println
