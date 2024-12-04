using Pipe: @pipe
using LinearAlgebra

is_xmas_shape(matrix) = @pipe(
  [[matrix]; [reverse(matrix, dims=2)]]
  .|> diag
  .|> join
  |> all(in(["MAS", "SAM"]), _)
)

function solve(filename)
  matrix = stack(collect.(readlines(filename)), dims=1)
  (rows, cols) = size(matrix)

  @pipe(
    [@views matrix[i:i+2, j:j+2] for i in 1:rows-2, j in 1:cols-2]
    |> filter(is_xmas_shape)
    |> length
  )
end

solve("input2.txt") |> println
