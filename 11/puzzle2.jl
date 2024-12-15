# Day 11: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Memoize

parse_input(filename) = read(filename, String) |> split

trim_leading_zeros(n) = string(parse(Int, n))

function change(stone)
  if stone == "0"
    "1"
  elseif iseven(length(stone))
    middle = length(stone) ÷ 2
    [stone[1:middle], stone[middle+1:end]] .|> trim_leading_zeros
  else
    parse(Int, stone) * 2024 |> string
  end
end

function solve(filename)
  stones = parse_input(filename)

  num_of_blinks = 75

  @memoize function rec(stone, step=1)
    if step > num_of_blinks
      return 1
    end

    stone = change(stone)
    step = step + 1

    if stone isa Vector
      return rec(stone[1], step) + rec(stone[2], step)
    end

    return rec(stone, step)
  end

  sum(rec.(stones))
end

solve("input.txt") |> println
