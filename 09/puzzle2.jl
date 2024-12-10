# Day 09: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query

parse_input(filename) = parse.(Int, collect(readline(filename)))

const FREE = -1
is_free((block, segment)) = isequal(block, FREE)

function to_disk_memory(disk_map)
  mem = []
  next = 1

  for (i, len) in enumerate(disk_map)
    if len == 0
      continue
    end

    segment = (next, next + len - 1)
    next = next + len

    push!(mem, (iseven(i) ? FREE : i ÷ 2, segment))
  end

  mem
end

function solve(filename)
  mem = parse_input(filename) |> to_disk_memory |> collect
  map = mem |> @map(fill(_[1], _[2][2] - _[2][1] + 1)) |> Iterators.flatten |> collect

  free_blocks = mem[findall(is_free, mem)]
  file_blocks = mem[findall(!is_free, mem)]

  could_fit((id, (a1, a2))) = ((r, (b1, b2)),) -> b1 < a1 && (a2 - a1) <= (b2 - b1)

  function fit(free, file)
    _, (free_left, free_right) = free
    file_id, (file_left, file_right) = file

    file_len = file_right - file_left
    free_len = free_right - free_left

    new_file = (file_id, (free_left, free_left + file_len))
    new_free = free_len > file_len ? (FREE, (free_left + file_len + 1, free_right)) : nothing

    new_free, new_file
  end

  while !isempty(free_blocks) && !isempty(file_blocks)
    file_block = pop!(file_blocks)
    free = findfirst(could_fit(file_block), free_blocks)

    if !isnothing(free)
      free_block = free_blocks[free]

      new_free, new_file = fit(free_block, file_block)

      deleteat!(free_blocks, free)

      if !isnothing(new_free)
        insert!(free_blocks, free, new_free)
      end

      map[new_file[2][1]:new_file[2][2]] .= new_file[1]
      map[file_block[2][1]:file_block[2][2]] .= FREE
    end
  end

  map |> enumerate |> @map(((pos, id),) -> (pos - 1) * id) |> @filter(_ > 0) |> sum
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === 2858
