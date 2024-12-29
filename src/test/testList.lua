dofile("src/core/list.lua")

local l = { value = 1, prev = nil, next = nil }

local cur = l
for i = 2, 10 do
    cur = List.append(cur, i)
end

cur = l
while cur ~= nil do
    print("value: "..cur.value)
    cur = cur.next
end

cur = l
while cur ~= nil do
    if cur.value == 5 then
        print("remove value: "..5)
        List.removeNode(cur)
        break
    end
    cur = cur.next
end

cur = l
while cur ~= nil do
    print("value: "..cur.value)
    cur = cur.next
end
