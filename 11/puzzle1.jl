# Day 11: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query

parse_input(filename) = read(filename, String) |> split

trim_leading_zeros(n) = string(parse(Int, n))

function change(stone)
  if stone == "0"
    return "1"
  elseif iseven(length(stone))
    middle = length(stone) ÷ 2
    [stone[1:middle], stone[middle+1:end]] .|> trim_leading_zeros
  else
    parse(Int, stone) * 2024 |> string
  end
end

function solve(filename)
  stones = parse_input(filename)

  for _ in 1:25
    stones = reduce(vcat, stones .|> change)
  end

  length(stones)
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === 55312
