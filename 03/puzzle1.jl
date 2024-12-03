using Pipe: @pipe

input = read("input.txt", String)

regex = r"mul\((\d{1,3}),(\d{1,3})\)"

result = @pipe (
  eachmatch(regex, input)
  .|> parse.(Int, _)
  .|> prod
  |> sum
)

println(result)
