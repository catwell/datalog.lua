local fmt = string.format
local parser = require "parser"
local pretty = require "pretty"
local interpreter = require "interpreter"

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

local ast = parser.parse(program)
local r = interpreter.process(ast)
if r then print(pretty.dump(r)) end
