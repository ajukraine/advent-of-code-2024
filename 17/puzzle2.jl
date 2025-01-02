# Day 17: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Logging

global_logger(ConsoleLogger(stderr, Logging.Debug))

function parse_input(filename)
  _, _, _, program... = parse.(Int, getfield.(eachmatch(r"\d+", read(filename, String)), :match))
  program
end

function find(program, answer)
  if isempty(program)
    return answer
  end

  for a in 0:7
    a = answer << 3 | a
    b = a % 8
    b = xor(b, 0b011)
    c = a >> b
    b = xor(b, 0b101)
    b = xor(b, c)

    if b % 8 == program[end]
      sub = find(program[begin:end-1], a)
      if isnothing(sub)
        continue
      end
      return sub
    end
  end
end

function solve(filename)
  program = parse_input(filename)

  find(program, 0)
end

solve("input.txt") |> println

# Test with sample
# @assert solve("sample.txt") === "4,6,3,5,6,3,5,2,1,0"
