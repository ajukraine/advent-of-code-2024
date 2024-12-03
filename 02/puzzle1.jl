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


function solve()
  return @pipe (
    open("input.txt", "r")
    |> readlines
    |> map(line -> parse.(Int, split(line)), _)
    |> filter(report -> is_safe(report), _)
    |> length
  )
end

println(solve())

