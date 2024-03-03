#!/bin/python




import sys

args = sys.argv[1:]


file1 = args[0]

l1 = []
a = input()
while a:
    l1.append(a)
    try:
        a = input()
    except EOFError:
        break

with open(file1, 'r') as f1:
    l2 = f1.read().split('\n')
    both = l1 + l2

    for i in both:
        c1 = i in l1
        c2 = i in l2

        if c1 and c2:
            # print(f"b {i}")
            continue
        elif c1 and not c2:
            print(f"+ {i}")
            continue
        elif not c1 and c2:
            print(f"- {i}")
            continue
        elif not c1 and not c2:
            print(f"n {i}")
            continue
