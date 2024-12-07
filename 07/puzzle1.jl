using Pipe: @pipe

parse_input(filename) = @pipe (
  readlines(filename)
  .|> split(_, ':')
  .|> ((left, right),) -> (parse(Int, left), parse.(Int, split(strip(right))))
)

is_equation((test, numbers), total=0) =
  if total > test
    false
  elseif isempty(numbers)
    test == total
  else
    num = numbers[1]
    rest = @view numbers[2:end]

    is_equation((test, rest), total * num) || is_equation((test, rest), total + num)
  end

solve(filename) = @pipe(
  parse_input(filename)
  |> filter(is_equation)
  .|> first
  |> sum
)

solve("input.txt") |> println
