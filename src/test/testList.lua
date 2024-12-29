dofile("src/core/list.lua")

local function func(v)
    return tostring(v.id)
end

local function double(v)
    print(v*2)
end

local l = List.append(nil, { id = 1, toString = func, double = double })

local cur = l
for i = 2, 10 do
    cur = List.append(cur, { id = i, toString = func, double = double } )
end

List.dump(l)
l = List.filter(l, function(value) return value.id == 5 end, true)
List.dump(l)
l = List.filter(l, function(value) return value.id == 1 or value.id == 2 end, false)
List.dump(l)
l = List.filter(l, function(value) return value.id % 2 == 0 end, false)
List.dump(l)
List.apply(l, function(v) v.double(v.id) end)