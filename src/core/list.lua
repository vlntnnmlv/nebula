-- TODO: Move to new class system

local function getValueString(value)
    if type(value) == "table" then
        if value.toString == nil then
            return "table"
        else
            return value.toString(value)
        end
    end

    return tostring(value)
end

local ListNode = CreateClass()

function ListNode:init(value)
    self.value = value
    self.next = nil
    self.prev = nil
end

-- N <-> N <-> N --
List = CreateClass()

function List:init()
    self.head = nil
    self.tail = nil
    self.len = 0
end

function List:dump()
    local stringView = ""

    stringView = stringView.."L<"..self.len.."> "
    if self.head == nil then io.write("nil\n") return end

    local cur = self.head
    stringView = stringView.."nil<-"
    while cur ~= nil do
        if cur.next == nil then
            stringView = stringView..getValueString(cur.value).."->"
        else
            stringView = stringView..getValueString(cur.value).."<->"
        end
        cur = cur.next
    end
    stringView = stringView.."nil"

    if Logger == nil then
        print(stringView)
    else
        Logger.notice(stringView)
    end
end

function List:append(value)
    if self.head == nil then
        self.head = ListNode.create(value)
        self.tail = self.head
    else
        self.tail.next = ListNode.create(value)
        self.tail.next.prev = self.tail
        self.tail = self.tail.next
    end

    self.len = self.len + 1
end

function List:remove(node)
    local result = node.next

    if node == self.head then
        self.head = node.next
    end

    if node == self.tail then
        self.tail = node.prev
    end

    if node.prev ~= nil then
        node.prev.next = node.next
    end

    if node.next ~= nil then
        node.next.prev = node.prev
    end

    node.prev = nil
    node.next = nil
    node.value = nil
    node = nil

    self.len = self.len - 1

    return result
end

function List:filter(func, first)
    local cur = self.head
    while cur ~= nil do
        if func(cur.value) then
            cur = self:remove(cur)
            if first then return end
        else
            cur = cur.next
        end
    end
end

function List:apply(func)
    local cur = self.head
    while cur ~= nil do
        func(cur.value)
        cur = cur.next
    end
end

function List:applyUntil(func, condition)
    local cur = self.head
    local tempResult = nil
    while cur ~= nil do
        tempResult = func(cur.value)
        if condition(tempResult) then return tempResult end
        cur = cur.next
    end
end