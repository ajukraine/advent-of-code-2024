using Pipe: @pipe

function parse_input(filename)
  @pipe (
    readlines(filename)
    .|> split(_, ':')
    .|> ((left, right),) -> (parse(Int, left), parse.(Int, split(strip(right))))
  )
end

function is_equation((test, numbers))
  len = length(numbers) - 1
  combinations = Iterators.product(fill([*, +], len)...)

  for ops in combinations
    total = numbers[1]
    for i in 1:len
      total = ops[i](total, numbers[i+1])
    end

    if total == test
      return true
    end
  end

  return false
end

function solve(filename)
  @pipe(
    parse_input(filename)
    |> filter(is_equation)
    .|> first
    |> sum
  )
end

solve("input.txt") |> println
