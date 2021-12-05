local AudioManager = {}
function AudioManager:new()
	local obj = {}
	self.__index = self
	setmetatable(obj, self)
	return obj
end
--继承
function AudioManager:subClass(className)
	_G[className] = {}
	local obj = _G[className]
	obj.base = self
	self.__index = self
	setmetatable(obj, self)
end
-----------------------------------------
------
local Effect = world.Audios.Effect
local BGMs = world.Audios.BGMs

---换音乐  参数为新旧 BGMindex
function AudioManager:ChangeBGM(OldBGM, TransBGM, NewBGM)
	for _, v in pairs(BGMs:GetChildren()) do
		if v.BGMIndex.Value == OldBGM then
			v.FadeOut = 2
			v:Stop()
			print('已停止')
		end
	end

	if TransBGM then
		Effect.Trans_Long:Play()
	else
		wait(1.5)
	end

	for _, v in pairs(BGMs:GetChildren()) do
		if v.BGMIndex.Value == NewBGM then
			v.Loop = true
			v.Volume = 30
			v.FadeIn = 2
			v:Play()
			print('已开始播放')
		end
		print(v.BGMIndex.Value)
	end
	print('已更改')
end

function AudioManager:Photograph()
	Effect.Photograph:Play()
end

function AudioManager:OpenPasswordDoor()
	Effect.OpenPasswordDoor:Play()
end

function AudioManager:PasswordInput()
	Effect.PasswordInput:Play()
end

function AudioManager:OpenBox()
	Effect.OpenBox:Play()
end

function AudioManager:Breath()
	Effect.Breath:Play()
end

function AudioManager:classRing()
	Effect.classRing:Play()
end

function AudioManager:AllTheF()
	Effect.AllTheF:Play()
end

function AudioManager:Heart()
	Effect.Heart:Play()
end

function AudioManager:Trans_Long()
	Effect.Trans_Long:Play()
end

function AudioManager:Trans_Short()
	Effect.Trans_Short:Play()
end

function AudioManager:OpenByKey()
	Effect.OpenByKey:Play()
end

return AudioManager
