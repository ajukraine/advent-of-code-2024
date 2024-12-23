# Day 13: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Match
using Pipe: @pipe

struct Config
  a
  b
  prize
end

parse_line(pattern, line) = parse.(Int, match(pattern, line)) |> NamedTuple{(:x, :y)}

fix_prize_location((x, y)) = (x=x + 10000000000000, y=y + 10000000000000)

parse_config(lines) = Config(
  parse_line(r"Button A: X\+(\d+), Y\+(\d+)", lines[1]),
  parse_line(r"Button B: X\+(\d+), Y\+(\d+)", lines[2]),
  parse_line(r"Prize: X=(\d+), Y=(\d+)", lines[3]) |> fix_prize_location)

parse_input(filename) = @pipe(
  readlines(filename)
  |> filter(!isempty ∘ strip)
  |> reshape(_, 3, :)
  |> permutedims
  |> eachrow
  |> map(parse_config, _)
)

function get_prize_combination((; a, b, prize))
  B = (prize.y * a.x - prize.x * a.y) / (b.y * a.x - b.x * a.y)
  A = (prize.x - B * b.x) / a.x

  if B != trunc(B) || A != trunc(A)
    return (0, 0)
  end

  Int(A), Int(B)
end

get_tokens((A, B)) = A * 3 + B

solve(filename) = parse_input(filename) .|> get_prize_combination .|> get_tokens |> sum

solve("input.txt") |> println
