-- TODO:
-- - comments
-- - all escape characters in string

local lpeg = require "lpeg"
local WHAT = (require "ast").WHAT

local NONPRINTABLE = lpeg.R("\x00\x31")
local SPACE = lpeg.S(" \t\r\n")
local TILDE = lpeg.S("~")
local PERIOD = lpeg.S(".")
local QUESTION_MARK = lpeg.S("?")
local COMMENT = lpeg.S("%") * lpeg.P(1) ^ 0 + lpeg.S("\n")
local W = (COMMENT + SPACE) ^ 0

-- A variable is a sequence of Latin capital and small letters, digits, and the
-- underscore character. A variable must begin with a Latin capital letter.
local VARIABLE = lpeg.R("AZ") * (lpeg.R("09", "az", "AZ") + lpeg.S("_")) ^ 0

-- An identifier is a sequence of printing characters that does not contain any
-- of the following characters: ‘(’, ‘,’, ‘)’, ‘=’, ‘:’, ‘.’, ‘~’, ‘?’, ‘"’,
-- ‘%’, and space. An identifier must not begin with a Latin capital letter.
local identifier_char = lpeg.P(1) -
    (NONPRINTABLE + lpeg.S([[(,)=:.~?"%]]) + SPACE)
local IDENTIFIER = (identifier_char - lpeg.R("AZ")) * identifier_char ^ 0

-- A string is a sequence of characters enclosed in double quotes.
-- Characters other than double quote, newline, and backslash can be directly
-- included in a string. The remaining characters can be specified using escape
-- characters, ‘\"’, ‘\n’, and ‘\\’ respectively.
local STRING = '"' * lpeg.Cs((
    (lpeg.P(1) - lpeg.S("\"\n\\")) +
    lpeg.P("\\\"") / "\"" + lpeg.P("\\\n") / "\n" + lpeg.P("\\\\") / "\\"
) ^ 0 ) * '"'

local function program(p)
    return p / function(...)
        local statements = {...}
        local query = nil
        local last_statement = statements[#statements]
        if last_statement and last_statement.what == WHAT.QUERY then
            query = last_statement
            table.remove(statements)
        end
        return { what = WHAT.PROGRAM, statements = statements, query = query }
    end
end

local function assertion(p)
    return p / function(clause)
        return { what = WHAT.ASSERTION, clause = clause }
    end
end

local function retraction(p)
    return p / function(clause)
        return { what = WHAT.RETRACTION, clause = clause }
    end
end

local function query(p)
    return p / function(literal)
        return { what = WHAT.QUERY, literal = literal }
    end
end

local function fact(p)
    return p / function(literal)
        return { what = WHAT.FACT, literal = literal }
    end
end

local function rule(p)
    return p / function(literal, ...)
        return { what = WHAT.RULE, literal = literal, body = {...} }
    end
end

local function literal(p)
    return p / function(predicate, ...)
        return { what = WHAT.LITERAL, predicate = predicate, terms = {...} }
    end
end

local grammar = lpeg.P {
    "program",
    -- A program is a sequence of zero or more statements,
    -- followed by an optional query.
    program = program(
        W* (lpeg.V("statement") ^ 0) *W* (lpeg.V("query") ^ -1) *W* -1
    ),
    -- A statement is an assertion or a retraction.
    statement = (lpeg.V("assertion") + lpeg.V("retraction")) * W,
    -- An assertion is a clause followed by a period.
    assertion = assertion(lpeg.V("clause") *W* PERIOD),
    -- A retraction is a clause followed by a tilde.
    retraction = retraction(lpeg.V("clause") *W* TILDE),
    -- A query is a literal followed by a question mark.
    query = query(lpeg.V("literal") *W* QUESTION_MARK * W),
    -- A clause is a head literal followed by an optional body.
    -- A clause without a body is called a fact, and a rule when it has one.
    -- The punctuation ‘:-’ separates the head of a rule from its body.
    clause = lpeg.V("rule") + lpeg.V("fact"),
    fact = fact(lpeg.V("literal")),
    rule = rule(lpeg.V("literal") *W* lpeg.P(":-") *W* lpeg.V("body")),
    -- A body is a comma separated list of literals.
    body = lpeg.V("literal") *W* ("," *W* lpeg.V("literal")) ^ 0,
    -- A literal is a predicate symbol followed by an optional
    -- parenthesized list of comma separated terms.
    literal = literal(
        lpeg.V("predicate") *W*
        ("(" *W* lpeg.V("term") *W* ("," *W* lpeg.V("term")) ^ 0 *W* ")") ^ -1
    ),
    -- A predicate symbol is either an identifier or a string.
    predicate = lpeg.C(IDENTIFIER + STRING),
    -- A term is either a variable or a constant.
    term = lpeg.C(VARIABLE + lpeg.V("constant")),
    --  As with predicate symbols,
    -- a constant is either an identifier or a string.
    constant = IDENTIFIER + STRING,
}

local function parse(input)
    return grammar:match(input)
end

return {
    parse = parse,
    WHAT = WHAT,
}
