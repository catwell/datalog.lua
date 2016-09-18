# datalog.lua

## Presentation

This is a pure Lua (+ LPEG) implementation of Datalog.

The core interpreter (`datalog.lua`) is a modified version of
[John D. Ramsdell's Datalog](http://datalog.sourceforge.net/) from the
MITRE corporation.

This is a work in progress, don't expect it to work flawlessly.

## Usage

    lua main.lua examples/path.dl

## Dependencies

This is currently only tested with Lua 5.3 compiled with backwards
compatibility for 5.1 and 5.2 and LPEG 0.12. It probably works fine with
other Luas though.

## Copyright

- `datalog.lua` is Copyright (C) 2004 The MITRE Corporation.
- All other files are Copyright (c) 2016 Pierre Chapuis.