List = {}

List.removeNode = function(node)
    -- N <-> N <-> N --
    if node.prev ~= nil then
        node.prev.next = node.next
    end

    if node.next ~= nil then
        node.next.prev = node.prev
    end

    node.prev = nil
    node.next = nil
    node = nil
end

List.append = function(node, value)
    node.next = { value = value, prev = node, next = nil}
    return node.next
end