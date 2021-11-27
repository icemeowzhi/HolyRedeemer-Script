local RefreshManager = {}

function RefreshManager:DR(Name)
	---赋值
	local discern = Workspace.DiarySystem.discern
	BoolValue = discern:GetChild(Name)
	BoolValue.value = true
	
	---动画
	local inform1 = Workspace.UI.inform1
	local inform1ap = Tween:TweenProperty(PropImage,{Offset = Vector2(700,0)},1,Enum.EaseCurve.Linear)--出现动画
	local inform1disap = Tween:TweenProperty(PropImage,{Offset = Vector2(0,0)},1,Enum.EaseCurve.Linear)--消失动画
	inform1ap:Play()
	wait(2)
	inform1disap:Play()
	
end

return RefreshManager