# Day 09: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query

parse_input(filename) = parse.(Int, collect(readline(filename)))

const FREE = -1
is_free(block) = isequal(block, FREE)

function to_disk_memory(disk_map)
  to_block((index, len)) = fill(iseven(index) ? FREE : index ÷ 2, len)

  enumerate(disk_map) .|> to_block |> Iterators.flatten
end

function solve(filename)
  mem = parse_input(filename) |> to_disk_memory |> collect

  free_blocks = findall(is_free, mem)
  file_blocks = reverse(findall(!is_free, mem))
  num_file_blocks = length(file_blocks)

  while !isempty(free_blocks) && free_blocks[1] <= num_file_blocks
    free = popfirst!(free_blocks)
    file = popfirst!(file_blocks)

    mem[file], mem[free] = mem[free], mem[file]
  end

  mem |> filter(!is_free) |> enumerate |> @map(((pos, id),) -> (pos - 1) * id) |> sum
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === 1928
