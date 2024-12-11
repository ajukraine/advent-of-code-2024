# Day 09: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Query
using Curry

parse_input(filename) = parse.(Int, collect(readline(filename)))

struct Block
  id
  pos
  len
end

const FREE = -1
is_free(block) = isequal(block.id, FREE)

function to_disk_memory(disk_map)
  mem = []
  next = 1

  to_block((i, len)) = Block(iseven(i) ? FREE : i ÷ 2, next, len)

  for (i, len) in enumerate(disk_map)
    if len == 0
      continue
    end

    push!(mem, to_block((i, len)))
    next = next + len
  end

  mem

  # [(b-a+1,a) for (a,b) in zip(disk_map, cumsum(disk_map))] |>
  # enumerate |>
end

function solve(filename)
  mem = parse_input(filename) |> to_disk_memory |> collect
  map = mem |> @map(fill(_.id, _.len)) |> Iterators.flatten |> collect

  free_blocks = mem[findall(is_free, mem)]
  file_blocks = mem[findall(!is_free, mem)]

  could_fit(file) = free -> free.pos < file.pos && file.len <= free.len

  function fit(free, file)
    new_file = Block(file.id, free.pos, file.len)
    new_free = free.len > file.len ? Block(FREE, free.pos + file.len, free.len - file.len) : nothing

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

      map[range(new_file.pos, length=new_file.len)] .= new_file.id
      map[range(file_block.pos, length=file_block.len)] .= FREE
    end
  end

  map |> enumerate |> @map(((pos, id),) -> (pos - 1) * id) |> @filter(_ > 0) |> sum
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === 2858
