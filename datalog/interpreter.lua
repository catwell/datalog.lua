local datalog = require "datalog.datalog"
local WHAT = (require "datalog.ast").WHAT

local function is_variable(s)
    return string.match(s, "[A-Z]")
end

local function literal(ast)
    local terms = {}
    for _, v in ipairs(ast.terms) do
        table.insert(
            terms,
            is_variable(v) and datalog.make_var(v) or datalog.make_const(v)
        )
    end
    return datalog.make_literal(ast.predicate, terms)
end

local function clause(ast)
    local head, body = literal(ast.literal), {}
    if ast.what == WHAT.RULE then
        for _, v in ipairs(ast.body) do
            table.insert(body, literal(v))
        end
    end
    return datalog.make_clause(head, body)
end

local function process(ast)
    assert(ast.what == WHAT.PROGRAM)
    for _, v in ipairs(ast.statements) do
        if v.what == WHAT.ASSERTION then
            datalog.assert(clause(v.clause))
        else
            assert(v.what == WHAT.RETRACTION)
            datalog.retract(clause(v.clause))
        end
    end
    if ast.query then
        local answer, r = datalog.ask(literal(ast.query.literal)) or {}, {}
        for _, v in ipairs(answer) do
            local terms = {}; for i, t in ipairs(v) do terms[i] = t end
            table.insert(
                r, {
                    what = WHAT.ASSERTION,
                    clause = {
                        what = WHAT.FACT,
                        literal = {
                            what = WHAT.LITERAL,
                            predicate = answer.name,
                            terms = terms
                        }
                    }
                }
            )
        end
        return { what = WHAT.PROGRAM, statements = r }
    end
end

return {
    process = process,
}
