function parse_input(filename)
  rules = Set()
  updates = []

  parse_rules = true
  for line in readlines(filename)
    if line == ""
      parse_rules = false
      continue
    end
    if parse_rules
      push!(rules, (parse.(Int, split(line, "|"))...,))
    else
      push!(updates, parse.(Int, split(line, ",")))
    end
  end

  (rules, updates)
end

function is_correct_order(update, rules)
  len = length(update)
  for i in 1:len
    for j in i+1:len
      a, b = update[i], update[j]
      if !((a, b) in rules)
        return false
      end
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
