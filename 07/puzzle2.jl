using Pipe: @pipe

parse_input(filename) = @pipe (
  readlines(filename)
  .|> split(_, ':')
  .|> ((left, right),) -> (parse(Int, left), parse.(Int, split(strip(right))))
)

concat(a, b) = a * (10^length(digits(b))) + b

is_equation((test, numbers), total=0) =
  if total > test
    false
  elseif isempty(numbers)
    test == total
  else
    num, rest... = numbers

    is_eq(op) = is_equation((test, rest), op(total, num))
    any(is_eq, [concat, *, +])
  end

solve(filename) = @pipe(
  parse_input(filename)
  |> filter(is_equation)
  .|> first
  |> sum
)

solve("input.txt") |> println
