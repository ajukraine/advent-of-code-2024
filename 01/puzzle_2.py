from collections import Counter


def solve(filepath):
  with open(filepath, "r") as file:
    left, right = zip(*(map(int, line.split()) for line in file))

  counter = Counter(right)

  return sum(map(lambda x: x * counter[x], left))


result = solve("input.txt")

print(result)
