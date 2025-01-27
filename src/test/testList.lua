print("Create empty")
local l = List.new()
l.dump()

print("fill")
for i = 1, 10 do
    l.append(i)
end
l.dump()

print("Remove node in the middle")
local cur = l.head
while cur ~= nil do
    if cur.value == 5 then
        l.remove(cur)
        break
    end
    cur = cur.next
end
l.dump()

print("Remove first node")
local cur = l.head
while cur ~= nil do
    if cur.value == 1 then
        l.remove(cur)
        break
    end
    cur = cur.next
end
l.dump()

print("Remove first node again")
local cur = l.head
while cur ~= nil do
    if cur.value == 2 then
        l.remove(cur)
        break
    end
    cur = cur.next
end
l.dump()

print("Remove last node")
local cur = l.head
while cur ~= nil do
    if cur.value == 10 then
        l.remove(cur)
        break
    end
    cur = cur.next
end
l.dump()

print("Remove last node again")
local cur = l.head
while cur ~= nil do
    if cur.value == 9 then
        l.remove(cur)
        break
    end
    cur = cur.next
end
l.dump()

print("Remove all except one (filter)")
l.filter(function(v) return v > 3 end, false)
l.dump()

print("Remove last one")
l.remove(l.tail)
l.dump()