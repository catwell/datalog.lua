local fmt = string.format
local WHAT = (require "datalog.ast").WHAT

local D = {}

local function _dump(accum, ast)
    local what = WHAT[ast.what]
    if not what then
        error(fmt("Unknown AST element %s.", tostring(ast.what)))
    end
    local d = D[WHAT[ast.what]]
    if not d then
        error(fmt("Cannot print AST element %s.", tostring(what)))
    end
    d(accum, ast)
end

D.PROGRAM = function(accum, ast)
    for _, v in ipairs(ast.statements) do
        _dump(accum, v)
        table.insert(accum, "\n")
    end
    if ast.query then
        _dump(accum, ast.query)
        table.insert(accum, "\n")
    end
    table.remove(accum)
end

D.ASSERTION = function(accum, ast)
    _dump(accum, ast.clause)
    table.insert(accum, ".")
end

D.RETRACTION = function(accum, ast)
    _dump(accum, ast.clause)
    table.insert(accum, "~")
end

D.QUERY = function(accum, ast)
    _dump(accum, ast.literal)
    table.insert(accum, "?")
end

D.FACT = function(accum, ast)
    return _dump(accum, ast.literal)
end

D.RULE = function(accum, ast)
    _dump(accum, ast.literal)
    table.insert(accum, " := ")
    for _, v in ipairs(ast.body) do
        _dump(accum, v)
        table.insert(accum, ", ")
    end
    table.remove(accum)
end

D.LITERAL = function(accum, ast)
    table.insert(accum, ast.predicate)
    table.insert(accum, "(")
    for _, v in ipairs(ast.terms) do
        table.insert(accum, v)
        table.insert(accum, ", ")
    end
    table.remove(accum)
    table.insert(accum, ")")
end

local function dump(ast)
    local accum = {}
    _dump(accum, ast)
    return table.concat(accum)
end

return {
    dump = dump,
}
