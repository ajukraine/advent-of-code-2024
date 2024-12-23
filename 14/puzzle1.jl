# Day 14: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Match
using Query

parse_robot(line) =
  parse.(Int, match(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", line)) |>
  NamedTuple{(:px, :py, :vx, :vy)}

parse_input(filename) = readlines(filename) .|> parse_robot

get_quadrant((mx, my), (px, py)) =
  if mx - px == 0.5 || my - py == 0.5
    nothing
  else
    (trunc(Int, px / mx), trunc(Int, py / my))
  end

function solve(filename; w=nothing, h=nothing)
  robots = parse_input(filename)
  h = something(h, (robots |> @map(_.py) |> maximum) + 1)
  w = something(w, (robots |> @map(_.px) |> maximum) + 1)

  seconds = 100
  middle = (w / 2, h / 2)

  robots |>
  @map((mod(_.px + seconds * _.vx, w), mod(_.py + seconds * _.vy, h))) |>
  @groupby(get_quadrant(middle, _)) |>
  @filter(!isnothing(key(_))) |>
  @map(length(_)) |>
  prod
end

solve("input.txt", w=101, h=103) |> println

# Test with sample
@assert solve("sample.txt") === 12
