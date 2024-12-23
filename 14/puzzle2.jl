# Day 14: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query

parse_robot(line) =
  parse.(Int, match(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", line)) |>
  NamedTuple{(:px, :py, :vx, :vy)}

parse_input(filename) = readlines(filename) .|> parse_robot

function print_robots(positions, w, h)
  matrix = fill('.', (w, h))
  for (x, y) in positions
    matrix[x+1, y+1] = '#'
  end
  matrix |> eachrow .|> join .|> println
end

function solve(filename; seconds=nothing, w=nothing, h=nothing)
  robots = parse_input(filename)
  h = something(h, (robots |> @map(_.py) |> maximum) + 1)
  w = something(w, (robots |> @map(_.px) |> maximum) + 1)
  seconds = something(seconds, 0)

  for i in seconds:seconds+100000
    c = robots |> @map((mod(_.px + i * _.vx, w), mod(_.py + i * _.vy, h)))

    rows = c |> @groupby(_[1]) |> @map(length(_)) |> @filter(_ > 10) |> collect |> length
    cols = c |> @groupby(_[2]) |> @map(length(_)) |> @filter(_ > 22) |> collect |> length

    if cols > 3 && rows > 10
      println("Elapsed: $i")
      print_robots(c, w, h)
      break
    end

  end

end

solve("input.txt", w=101, h=103, seconds=parse(Int, get(ARGS, 1, '0'))) .|> println
