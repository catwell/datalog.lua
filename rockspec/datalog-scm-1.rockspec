package = "datalog"
version = "scm-1"

source = {
    url = "git://github.com/catwell/datalog.lua.git",
}

description = {
    summary = "A lightweight deductive database system.",
    detailed = [[
        datalog.lua is a pure Lua implementation of Datalog,
        with a LPEG parser, based on John D. Ramsdell's
        MITRE Datalog.
    ]],
    homepage = "http://github.com/catwell/datalog.lua",
    license = "MIT/X11",
}

dependencies = { "lua >= 5.1", "lpeg" }

build = {
    type = "builtin",
    modules = {
        ["datalog"] = "datalog/init.lua",
        ["datalog.ast"] = "datalog/ast.lua",
        ["datalog.datalog"] = "datalog/datalog.lua",
        ["datalog.interpreter"] = "datalog/interpreter.lua",
        ["datalog.parser"] = "datalog/parser.lua",
        ["datalog.pretty"] = "datalog/pretty.lua",
    },
   install = { bin = { ["datalog.lua"] = "main.lua" } },
}
