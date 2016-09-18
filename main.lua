#!/usr/bin/env lua

local fmt = string.format
local datalog = require "datalog"

local die = function(s)
    io.stderr:write(s .. "\n")
    os.exit(1)
end

local usage = function(arg)
    die(fmt("USAGE: %s [file]", arg[0]))
end

local read_file = function(path)
    local f, r, e
    f, e = io.open(path, "rb")
    if not f then return nil, e end
    r, e = f:read("*all")
    f:close()
    return r, e
end

if not arg[1] then usage(arg) end
local program, err = read_file(arg[1])
if err then die(err) end

local ast = datalog.parser.parse(program)
local r = datalog.interpreter.process(ast)
if r then print(datalog.pretty.dump(r)) end
