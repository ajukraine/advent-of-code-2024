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
  num_of_safe_reports = 0

  open("input.txt", "r") do file
    for line in readlines(file)
      parsed = parse.(Int, split(line))

      if is_safe(parsed)
        num_of_safe_reports += 1
      end

    end
  end

  return num_of_safe_reports
end

println(solve())

