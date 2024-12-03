using Pipe: @pipe

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


solve(filename) = @pipe (
  eachline(filename)
  .|> split
  .|> parse.(Int, _)
  |> filter(is_safe)
  |> length
)

solve("input.txt") |> println

