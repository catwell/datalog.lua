# datalog.lua

![CI Status](https://github.com/catwell/datalog.lua/actions/workflows/ci.yml/badge.svg?branch=master)

## Presentation

This is a pure Lua (+ LPEG) implementation of Datalog.

The core interpreter (`datalog/datalog.lua`) is a modified version of [John D. Ramsdell's Datalog](http://datalog.sourceforge.net/) from the MITRE corporation.

## Usage

    lua main.lua examples/path.dl

## Dependencies

PUC Lua 5.1 or above + LPEG. This is not tested with LuaJIT (but it probably works).

Tests depend on [cwtest](https://github.com/catwell/cwtest).

## Copyright

- `datalog/datalog.lua` is Copyright (C) 2004 The MITRE Corporation and released under the GNU LGPL.

- All other files are Copyright (c) 2016-2022 Pierre Chapuis and released under the MIT license, see LICENSE.txt.
