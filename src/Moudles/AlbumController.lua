---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by asus.
--- DateTime: 2021/11/28 22:38
---

Utils = require('Moudles/Utils')

---@class AlbumController 相册控制器，传入两个gui，在初始化的时候会初始化CheckDetailController类
AlbumController = {}

---构造器
---@param albumGUI userdata 相册GUI
---@param detailGUI userdata 详细GUI
function AlbumController:new(o,albumGUI,detailGUI)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    self.albumGUI = albumGUI
    self.detailGUI = detailGUI
    ---开始初始化slot
    self.slots = {}
    self.currentSlot = 0
    self.pressFunc = {}
    for _, v in ipairs(albumGUI:GetChildren()) do
        if v.ClassName == 'UiFigureObject' then
            if v:GetChild('SlotIndex') ~= nil then
                table.insert(self.slots,v)
                table.insert(self.pressFunc,function() self:ToDetail(v:GetChild('SlotIndex').Value) end)
            end
        end
    end
    return o
end

---保存照片到相册,传入待保存的照片的物体，去picture文件夹里查找该名，获得所有回溯形态，找到对应形态，将其克隆到GUI节点下。
---如果slot全部沾满，直接返回false，如果没找着（遇到bug）直接返回false
---@param objectName userdata 待保存的照片的物体
---@param recallIndex number 回溯的状态序号
---@return boolean 保存是否成功
function AlbumController:SavePic(objectName,recallIndex)
    local pictures = world.Resources.Picture
    ---从picture文件夹里查找此名称
    if pictures:GetChild(objectName) ~= nil then
        local targetFolder = pictures:GetChild(objectName)
        ---遍历所有recall的形态，判断值
        for _, picture in ipairs(targetFolder:GetChildren()) do
            if picture:GetChild('recallIndex') ~= nil then
                if picture:GetChild('recallIndex').Value == recallIndex then
                    ---遍历slot
                    for _, slot in ipairs(self.slots) do
                        ---@field canInsert boolean 是否能插入
                        local canInsert = true
                        ---寻找slot中是否有UiImageObject节点,即为照片
                        if slot:FindFirstChildByType('UiImageObject') ~= nil then
                            canInsert = false
                        end
                        ---如果没有这个节点，进行插入，将这个照片与子节点克隆到节点下
                        if canInsert then
                            local cloned = picture:Clone(slot,false)
                            ---改变尺寸，名字为物体名方便查找
                            cloned.Size = Vector2(600,338)
                            ---改变图层位置
                            cloned:Up()
                            cloned:Up()
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

---通过slot数值来找到照片，关掉albumGUI打开详细信息GUI，交给CheckDetailController的实例处理
---@param slotValue number 待进入预览的slot的值
---@return void
function AlbumController:ToDetail(slotValue)
    if slotValue > 9 then
        slotValue = 1
    end
    if slotValue < 1 then
        slotValue = 9
    end
    self.currentSlot = slotValue
    local targetSlot = self.slots[slotValue]
	--print(slotValue)
    local picture = targetSlot:FindFirstChildByType('UiImageObject')
    if picture ~= nil then
        assert(self.detailGUI:GetChild('Photo'),"文件结构错误")
        for _,child in ipairs(self.detailGUI:GetChild('Photo'):GetChildren()) do
            child:Destroy()
        end
        local cloned = picture:Clone(self.detailGUI:GetChild('Photo'),false)
        cloned.Size = Vector2(1550,870)
        self.albumGUI:SetActive(false)
        self.detailGUI:SetActive(true)
    end
end

---详细GUI中返回
function AlbumController:Back()
    self:Refresh()
    self.albumGUI:SetActive(true)
    self.detailGUI:SetActive(false)
end

---详细GUI中上一张
function AlbumController:PgUp()
    self:ToDetail(self.currentSlot - 1)
end

---详细GUI中下一张
function AlbumController:PgDn()
    self:ToDetail(self.currentSlot + 1)
end

---详细GUI中回溯
function AlbumController:Recall()
    assert(self.detailGUI:GetChild('Photo'):FindFirstChildByType('UiImageObject'):GetChild('recallIndex'),'图片或recallData未正确加载')
    local pictureName = self.detailGUI:GetChild('Photo'):FindFirstChildByType('UiImageObject').Name
    local currentRecallIndex = self.detailGUI:GetChild('Photo'):FindFirstChildByType('UiImageObject'):GetChild('recallIndex').Value
    local pictures = world.Resources.Picture
    assert(pictures:GetChild(pictureName),'未找到同名图片')
    local recalledPic
    if currentRecallIndex < pictures:GetChild(pictureName).ChildCount then
        currentRecallIndex = currentRecallIndex + 1
    else
        currentRecallIndex = 1
    end
    ---得到这次回溯的图片
    for _, picRecall in ipairs(pictures:GetChild(pictureName):GetChildren()) do
		print(picRecall)
        if picRecall:GetChild('recallIndex').Value == currentRecallIndex then
            recalledPic = picRecall
            break
        end
    end
    if recalledPic ~= nil then
        for _, slot in ipairs(self.slots) do
            if slot:FindFirstChildByType('UiImageObject') ~= nil then
                if slot:FindFirstChildByType('UiImageObject').Name == pictureName then
                    slot:FindFirstChildByType('UiImageObject'):Destroy()
                    local recalledPicCloned =  recalledPic:Clone(slot,false)
                    self:ToDetail(slot:GetChild('SlotIndex').Value)
                    print(currentRecallIndex)
                    break
                end
            end
        end
    end
end

---将某个slot的照片转移到另一个slot中
---@return void 若参数错误，不会转移
function AlbumController:Transfer(startSlotIndex,targetSlotIndex)
	print('Transfer called!')
    local startSlot = self.slots[startSlotIndex]
    local targetSlot = self.slots[targetSlotIndex]
    assert(startSlot)
    assert(targetSlot)
    if (startSlot ~= nil) and (targetSlot ~= nil) then
        ---检查start是否有照片
        if startSlot:FindFirstChildByType('UiImageObject') == nil then
			print("失败！，转移的格子没有照片！")
            return
        end
        ---检查target是否没照片
        if targetSlot:FindFirstChildByType('UiImageObject') == nil then
            local picture = startSlot:FindFirstChildByType('UiImageObject')
            picture:Clone(targetSlot,false)
            picture:Destroy()
        else
            print("失败！，转移的格子已被占据！")
        end
    end
end

---重新调整相册，保持相册不留空，保证没有图片的空位是disconnect了ToDetail
---对于每个有照片的slot，检查它之前的所有slot是否都不为空，如果不是，找到第一个不为空的slot，转移照片
---检查每个slot，如果有照片，connect，没有，disconnect
---@return void
function AlbumController:Refresh()

    for index, slot in ipairs(self.slots) do
        ---拿到每个有照片的slot
        if slot:FindFirstChildByType('UiImageObject') ~= nil then
            ---如果是第一张，不在考虑之内
            if index ~= 1 then
                ---遍历之前的所有slot
                for _,slotBefore in ipairs(Utils.GetSubTable(self.slots,1,index-1)) do
                    ---检查它之前的所有slot是否都不为空
                    if slotBefore:FindFirstChildByType('UiImageObject') == nil then
                        ---找到第一个不为空的slot，转移照片
                        local slotIndex = slotBefore:GetChild('SlotIndex')
						print(index..'->'..slotIndex.Value)						
                        self:Transfer(index,slotIndex.Value)
                        break
                    end
                end
            end
        end
    end
	


    for i,slot in ipairs(self.slots) do

        if slot:FindFirstChildByType('UiImageObject') == nil then
            slot:GetChild('CheckDetailBtn').OnClick:Disconnect(self.pressFunc[i])
            --print('disconnect '..i)
        else
            slot:GetChild('CheckDetailBtn').OnClick:Connect(self.pressFunc[i])
            --print('connect '..i)
        end

    end
end

---删除某张照片，然后refresh
---@param slotIndex number 待删除的slot序号
---@return boolean 是否成功删除
function AlbumController:Delete(slotIndex)
	print(slotIndex)
    if self.slots[slotIndex] ~= nil then
		print('del s1')
        if self.slots[slotIndex]:FindFirstChildByType('UiImageObject') ~= nil then
			print('del s2')
            local picture = self.slots[slotIndex]:FindFirstChildByType('UiImageObject')
            picture:Destroy()
			self:Refresh()
			print('deled')
			self:Back()
            return true
        end
    end
    self:Refresh()
	print('del failed')
    return false
end

---尝试删除某个目标并返回删除结果
---由放置系统使用
---检查所有slot有没有照片，有照片的slot是不是此照片，检查照片的recallIndex
---@param name string
---@param needIndex number
---@return boolean 删除是否成功
function AlbumController:tryDeleteByName(name,needIndex)
    for index, slot in ipairs(self.slots) do
        local picture = slot:FindFirstChildByType('UiImageObject')
        if picture ~= nil then
            if picture.Name == name then
                print('found!')
                assert(picture:GetChild('recallIndex'))
                if picture:GetChild('recallIndex').Value == needIndex then
                    self:Delete(index)
                    world.Resources.UI.Album:SetActive(false)
                    return true
                end
            end
        end
    end
    return false
end

return AlbumController
