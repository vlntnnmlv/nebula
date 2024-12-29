dofile("src/core/list.lua")

local function func(v)
    return tostring(v.id)
end

local l = { value = { id = 1, toString = func }, prev = nil, next = nil }

local cur = l
for i = 2, 10 do
    cur = List.append(cur, { id = i, toString = func } )
end

List.dump(l)
l = List.filter(l, function(value) return value.id == 5 end, true)
List.dump(l)
l = List.filter(l, function(value) return value.id == 1 or value.id == 2 end, false)
List.dump(l)
l = List.filter(l, function(value) return value.id % 2 == 0 end, false)
List.dump(l)
