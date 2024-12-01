from itertools import starmap


def solve(filepath):
  with open(filepath, "r") as file:
    left, right = zip(*(map(int, line.split()) for line in file))

  return sum(starmap(lambda a, b: abs(a - b), zip(sorted(left), sorted(right))))


result = solve("input.txt")

print(result)
