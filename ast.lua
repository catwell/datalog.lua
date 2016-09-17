local function enum(t)
    local r = {}
    for k, v in pairs(t) do r[k] = v; r[v] = k end
    return r
end

local WHAT = enum {
    "PROGRAM", "ASSERTION", "RETRACTION", "QUERY", "FACT", "RULE", "LITERAL"
}

return {
    WHAT = WHAT,
}
