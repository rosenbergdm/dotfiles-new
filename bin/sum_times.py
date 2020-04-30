#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 David Rosenberg <dmr@davidrosenberg.me>
#
# Distributed under terms of the MIT license.

"""
Sums times from a list of times in a file
"""

import sys

def get_times(fname):
    fh = open(fname)
    lines = [x.strip() for x in fh.readlines()]
    h_m = [x.split(':') for x in lines]
    tmins = sum(int(x[1]) for x in h_m)
    mins = tmins % 60
    hours = int(tmins / 60) + sum(int(x[0]) for x in h_m)
    if mins < 10:
        smins = "0" + str(mins)
    else:
        smins = str(mins)
    result = str(hours) + ":" + smins
    return result

if __name__ == "__main__":
    if len(sys.argv) == 2:
        print(get_times(sys.argv[1]))
    else:
        print("Usage: " + sys.argv[0] + " INPUT_TIME_FILE")


