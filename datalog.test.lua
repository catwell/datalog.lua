local datalog = require "datalog"
local cwtest = require "cwtest"

local T = cwtest.new()

local function sort_lines(s)
    local r = {}
    for l in string.gmatch(s, "[^\n]+") do
       table.insert(r, l)
    end
    table.sort(r)
    return table.concat(r, "\n")
end

local _path_input = [[
edge(a, b). edge(b, c). edge(c, d). edge(d, a).
path(X, Y) :- edge(X, Y).
path(X, Y) :- edge(X, Z), path(Z, Y).
path(X, Y)?
]]

local _path_output = [[
path(a, a).
path(a, b).
path(a, c).
path(a, d).
path(b, a).
path(b, b).
path(b, c).
path(b, d).
path(c, a).
path(c, b).
path(c, c).
path(c, d).
path(d, a).
path(d, b).
path(d, c).
path(d, d).]]

T:start("path"); do
    local ast = datalog.parser.parse(_path_input)
    local r = datalog.interpreter.process(ast)
    r = datalog.pretty.dump(r)
    T:eq( sort_lines(r), _path_output )
end; T:done()

T:exit()
