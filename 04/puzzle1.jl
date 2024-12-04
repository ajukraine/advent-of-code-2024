using Pipe: @pipe
using LinearAlgebra

calculate(matrix) = @pipe(
  matrix
  .|> join
  .|> eachmatch(r"(XMAS)|(SAMX)", _, overlap=true)
  .|> collect
  .|> length
  |> sum
)

function eachdiag(matrix)
  rows, _ = size(matrix)
  @pipe(collect(-rows+4:rows-4) .|> diag(matrix, _))
end

function solve(filename)
  matrix = hcat(collect.(readlines(filename))...)

  return @pipe(
    [eachrow(matrix), eachcol(matrix), eachdiag(matrix), eachdiag(reverse(matrix, dims=2))]
    .|> calculate
    |> sum
  )
end

solve("input.txt") |> println
