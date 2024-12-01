from itertools import starmap


def solve(filepath):
  left = []
  right = []

  with open(filepath, "r") as file:
    for line in file:
      a, b = [int(x) for x in line.split()]

      left.append(a)
      right.append(b)

  left.sort()
  right.sort()

  return sum(starmap(lambda a, b: abs(a - b), zip(left, right)))


result = solve("input.txt")

print(result)
