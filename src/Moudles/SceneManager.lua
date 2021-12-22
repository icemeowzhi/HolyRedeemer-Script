local SceneManager = {}

local SceneGroup = nil

--实例化
function SceneManager:new()
    local obj = {}
    self.__index = self
    setmetatable(obj, self)
    return obj
end
--继承
function SceneManager:subClass(className)
    _G[className] = {}
    local obj = _G[className]
    obj.base = self
    self.__index = self
    setmetatable(obj, self)
end

function SceneManager:SC_Begin()
    --这里写要执行前的操作
    print('SC_Begin')
    wait(0.5)
    print('Out SC_Begin')
    self:SC_Playing()
end

function SceneManager:SC_Playing()
    --执行中的操作
    print('SC_Playing')
    for i, v in pairs(self.SceneGroup:GetChildren()) do
        v:SetActive(true)
        v.Alpha = 0
        while v.Alpha <= 1 do
            v.Alpha = v.Alpha + 0.01
            wait(0.01)
        end
        v:SetActive(false)
        --里面写动画切换事件
    end
    print('out SC_Playing')
    self:SC_End()
end

function SceneManager:SC_End()
    --执行完毕的操作
    print('SC_End')
    wait(0.5)
    print('out SC_End')
end

--这是一些改动

return SceneManager
