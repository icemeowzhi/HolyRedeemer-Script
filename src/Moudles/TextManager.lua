local TextManager = {}
--[[
function TextManager:new()
	local obj = {}
	self.__index = self
	setmetatable(obj,self)
	return obj
end
--继承
function TextManager:subClass(className)
	_G[className] = {}
	local obj = _G[className]
	obj.base = self
	self.__index = self
	setmetatable(obj,self)
end
]]--
--逐字打印
--传入字符串和字符串放置的Text
function TextManager:TextOutput(_Text,_UIText)
	local _TargetText = ""
	local i = 1
	while i<=#_text and wait(0.07)  do
		asc2 = string.byte(_Text,i,i)
		if acs2 > 127 then
			--汉字
			_TargetText = _TargetText..string.sub(_Text,i,i+2)
			_UIText.Text = _TargetText
		else
			--字母
			_TargetText = _TargetText..string.sub(_Text,i,i)
			if asc2 == 10 then
				wait(0.5)
			end
			_UIText.Text = _TargetText
			i = i+1
		end
	end

end

return TextManager