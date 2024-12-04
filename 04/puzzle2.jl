using Pipe: @pipe
using LinearAlgebra

function is_xmas_shape(matrix)
  shape = ["MAS", "SAM"]
  join(diag(matrix)) in shape && join(diag(reverse(matrix, dims=2))) in shape
end

function solve(filename)
  matrix = stack(collect.(readlines(filename)), dims=1)
  (rows, cols) = size(matrix)

  num_of_shapes = 0

  for i in 1:rows-2, j in 1:cols-2
    m = @views matrix[i:i+2, j:j+2]
    if is_xmas_shape(m)
      num_of_shapes += 1
    end
  end

  num_of_shapes
end

solve("sample.txt") |> println
