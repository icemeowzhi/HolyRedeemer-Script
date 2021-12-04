local SelectManager = {}
local SelectPicture = Workspace.Resources.UI.SelectPicture
local Figure = SelectPicture.Figure
---调整间隔
local Sapces = 150

---刷新UI
function SelectManager:Refresh()
	local Offset_record = 80
	local num = 1
	for i, v in pairs(Figure:GetChildren()) do
		print(v.Name)
		if v.Visual.Value == true then
			---打开并设置位置等属性
			v:SetActive(true)
			v.Offset = Vector2(Offset_record, 0)
			if v.MouseEnter.Value == true then
				Offset_record = Offset_record + 200
			end
			Offset_record = Offset_record + 150
			v:ToTop()
		end
	end
end

function SelectManager:Open()
	SelectManager:Refresh()
	local SelectOpenTweener = Tween:TweenProperty(SelectPicture, {Position = {100,100}, 0.5, Enum.EaseCurve.Linear)
	--出现
	SelectOpenTweener:play()
end

function SelectManager:Close()
	SelectManager:Refresh()
	local SelectCloseTweener = Tween:TweenProperty(SelectPicture, {Offset = Vector2(0, 0)}, 0.5, Enum.EaseCurve.Linear)
	--出现--移出
	SelectCloseTweener:play()
end

return SelectManager
