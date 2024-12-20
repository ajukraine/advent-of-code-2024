using Pipe: @pipe

function parse_input(filename)
  lines = readlines(filename)
  empty_line = findfirst(isempty, lines)

  rules = @pipe lines[begin:empty_line-1] .|> parse.(Int, split(_, "|"))
  updates = @pipe lines[empty_line+1:end] .|> parse.(Int, split(_, ","))

  rules, updates
end

function is_correct_order(update, rules)
  len = length(update)
  for i in 1:len, j in i+1:len
    if !([update[i], update[j]] in rules)
      return false
    end
  end

  return true
end

function solve(filename)
  rules, updates = parse_input(filename)

  is_correct(update) = is_correct_order(update, rules)
  middle(arr) = arr[cld(length(arr), 2)]

  updates |> filter(is_correct) .|> middle |> sum
end

solve("input.txt") |> println
