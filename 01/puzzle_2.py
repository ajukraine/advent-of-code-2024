from collections import Counter


def solve(filepath):
  left = []
  right = []

  with open(filepath, "r") as file:
    for line in file:
      a, b = [int(x) for x in line.split()]

      left.append(a)
      right.append(b)

  counter = Counter(right)

  return sum(map(lambda x: x * counter[x], left))


result = solve("input.txt")

print(result)
