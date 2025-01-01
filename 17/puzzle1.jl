# Day 17: Advent of Code 2024
_ = nothing # fix 'Missing reference: _' warnings

using Match
using Logging
using Query

global_logger(ConsoleLogger(stderr, Logging.Warn))

mutable struct Computer
  registers
  program
  pointer
  output
end

Base.getindex(c::Computer, reg::Symbol) = c.registers[reg]
Base.setindex!(c::Computer, val, reg::Symbol) = c.registers[reg] = val

combo(c, op) = @match op begin
  0:3 => op
  4 => c[:A]
  5 => c[:B]
  6 => c[:C]
  7 => error("Invalid operand is reserved: 7")
  _ => error("Invalid operand: $op")
end

jump(f) = function (c, operand)
  f(c, operand)
  c.pointer += 2
end

ins!(name, f) = (name, jump(f))
ins(name, f) = (name, f)

const INSTRUCTIONS = Dict(
  0 => ins!(:adv, (c, op) -> c[:A] = trunc(Int, c[:A] / (2^combo(c, op)))),
  1 => ins!(:bxl, (c, op) -> c[:B] = xor(c[:B], op)),
  2 => ins!(:bst, (c, op) -> c[:B] = mod(combo(c, op), 8)),
  3 => ins(:jnz, (c, op) -> c[:A] != 0 ? c.pointer = op : c.pointer += 2),
  4 => ins!(:bxc, (c, _) -> c[:B] = xor(c[:B], c[:C])),
  5 => ins!(:out, (c, op) -> push!(c.output, mod(combo(c, op), 8))),
  6 => ins!(:bdv, (c, op) -> c[:B] = trunc(Int, c[:A] / (2^combo(c, op)))),
  7 => ins!(:cdv, (c, op) -> c[:C] = trunc(Int, c[:A] / (2^combo(c, op)))),
)

function run(computer)
  index() = div(computer.pointer, 2) + 1
  while checkbounds(Bool, computer.program, index())
    ((name, fun), operand) = computer.program[index()]

    @debug "Executing $name($operand)" computer.registers computer.pointer
    fun(computer, operand)
  end
end

function parse_input(filename)
  lines = readlines(filename)
  @debug lines

  registers =
    lines[1:3] |>
    @map(match(r"Register (?<name>A|B|C): (?<value>\d+)", _)) |>
    @map(Symbol(_["name"]) => parse(Int, _["value"])) |>
    Dict

  numbers = parse.(Int, split(match(r"Program: (?<instructions>.*)", lines[5])["instructions"], ","))
  instructions = Base.Iterators.partition(numbers, 2) |> @map((INSTRUCTIONS[_[1]], _[2])) |> collect

  Computer(registers, instructions, 0, [])
end

function solve(filename)
  computer = parse_input(filename)

  run(computer)

  join(computer.output, ",")
end

solve("input.txt") |> println

# Test with sample
@assert solve("sample.txt") === "4,6,3,5,6,3,5,2,1,0"
