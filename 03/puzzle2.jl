using Pipe: @pipe

function solve()
  input = read("input2.txt", String)
  regex = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don\'t\(\)"

  enabled = true
  result = 0

  for m in eachmatch(regex, input)
    if m.match == "do()"
      enabled = true
    elseif m.match == "don't()"
      enabled = false
    elseif enabled
      result += prod(parse.(Int, m))
    end
  end

  return result
end

solve() |> println
