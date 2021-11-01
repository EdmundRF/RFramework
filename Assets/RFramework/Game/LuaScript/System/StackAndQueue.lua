--
-- Created by 冯康荣
-- Date: 2017/7/28 14:13
-- Brief: 实现栈和队列结构
--

local DefaultCapacity = 128

---@class Stack
Stack = {}

-- 创建化栈
---@return Stack
function Stack.Create(capacity)
    local stack = {}
    stack.data = {}
    stack.top = 0
    stack.capacity = capacity or DefaultCapacity

    setmetatable(stack, { __index = Stack})
    return stack
end

-- 进栈操作
function Stack:Push(element)

    if self.top == self.capacity then -- 栈满
        error("Stack overflow")
        return
    end

    self.top = self.top + 1
    self.data[self.top] = element;
end

-- 出栈操作
function Stack:Pop()

    if self.top == 0 then -- 栈空
        -- error("Stack empty")
        return nil;
    end

    local e = self.data[self.top]
    self.top = self.top - 1
    return e
end

-- 获取顶部元素但不出栈
function Stack:Top()
    if self.top == 0 then -- 栈空
        return nil;
    end

    return self.data[self.top]
end

-- 栈的大小
function Stack:Size()
    return self.top
end

function Stack:Clear()
    self.top = 0
    --self.data = {}
end

-- 遍历栈元素, 从栈顶开始. 5.2才可以自定义__pairs
function Stack:ForEach(func)
    for i = self.top, 1, -1 do
        local result = func(self.data[i])
        if result == false then return end
    end
end

----------------[[ Queue ]]------------------
---@class Queue
Queue = {}
-- 初始化队列
---@return Queue
function Queue.Create(capacity)
    local queue = {}
    queue.data = {}
    queue.front = 1
    queue.rear = 1
    queue.size = 0
    queue.capacity = capacity or DefaultCapacity

    setmetatable(queue,{__index = Queue})
    return queue
end

-- 返回队列长度
function Queue:Length()

    return self.size;
end

-- 入队操作
function Queue:EnQueue(element)

    if self.size == self.capacity then -- 判断队列是否已满
        error("Queue full")
        return
    end

    self.data[self.rear] = element;
    self.size = self.size + 1
    self.rear = self.rear % self.capacity + 1;
end

-- 出队操作
function Queue:DeQueue()

    if self.size == 0 then --队空
        return nil
    end

    local element = self.data[self.front]
    self.size = self.size - 1
    self.front = self.front % self.capacity + 1;
    return element
end

function Queue:Front()
    if self.size ~= 0 then
        return self.data[self.front]
    end
end

function Queue:Tail()
    if self.size ~= 0 then
        if self.front == self.rear then
            return self.data[self.rear]
        else
            local rear = self.rear - 1
            if rear < 1 then rear = self.capacity end
            return self.data[rear]
        end
    end
end

function Queue:Clear()
    self.size = 0
    self.front = 1
    self.rear = 1
    --self.data = {}
end

-- 遍历队列元素, 从队头开始. 5.2才可以自定义__pairs
function Queue:ForEach(func)
    local front = self.front

    local result
    if front == self.rear and self.size ~= 0 then
        result = func(self.data[front])
        if result == false then return end

        front = front % self.capacity + 1
    end

    while front ~= self.rear do
        result = func(self.data[front])
        if result == false then return end

        front = front % self.capacity + 1
    end
end