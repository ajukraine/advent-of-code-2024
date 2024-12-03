using Pipe: @pipe
using InvertedIndices

function is_safe(report)
  asc = nothing
  for (a, b) in zip(report[1:end-1], report[2:end])
    increasing = b > a
    diff = abs(a - b)

    if diff > 3 || diff == 0
      return false
    end

    if asc == nothing
      asc = increasing
      continue
    end

    if asc != increasing
      return false
    end
  end

  return true
end

function is_safe_tolerate(report)
  if is_safe(report)
    return true
  end

  for i in 1:length(report)
    if is_safe(report[Not(i)])
      return true
    end
  end

  return false
end

function solve()
  return @pipe (
    open("input.txt", "r")
    |> readlines
    |> map(line -> parse.(Int, split(line)), _)
    |> filter(is_safe_tolerate, _)
    |> length
  )
end

println(solve())

# 10 12 8 4 2
