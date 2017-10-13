#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This script is a simple wrapper which prefixes each i3status line with custom
# information. It is a python reimplementation of:
# http://code.stapelberg.de/git/i3status/tree/contrib/wrapper.pl
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.py
# In the 'bar' section.
#
# This program is free software. It comes without any warranty, to the extent
# permitted by applicable law. You can redistribute it and/or modify it under
# the terms of the Do What The Fuck You Want To Public License (WTFPL), Version
# 2, as published by Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more
# details.

import os
import sys
import json

def get_volume():
    """ Get the volume info of Master """
    os.system('amixer sget Master | tail -1 > /tmp/amixer_out')
    with open('/tmp/amixer_out') as fp:
        parts = fp.readlines()[0].strip().split(' ')
        return parts
        # return 'Vol: %s %s' % (parts[2], parts[3])

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        vol_info = get_volume()
        # Test if not muted
        # If muted, output in red
        if (vol_info[5].find('on') > 0):
            j.insert(0, {'full_text' : 'Vol: %s %s' % (vol_info[2], vol_info[3]), 'name' : 'vol'})
        else:
            j.insert(0, {'full_text' : 'Vol: %s %s' % (vol_info[2], vol_info[3]), 'name' : 'vol', 'color' : '#FF0000'})
        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
