local SelectManager = {}
local SelectPicture = Workspace.Resources.UI.SelectPicture
---调整间隔
local Sapces = 150


---刷新UI
function SelectManager:Refresh()
    local Offset_record = 80
    local num = 1
    for i,v in pairs(SelectPicture:GetChildren()) do
        if v.Visual.Value then
            v:SetActive(true)
            v.Offset = Vector2(Offset_record,0)
            if v.MouseEnter.Value then
                Offset_record = Offset_record + 200
            end
            Offset_record = Offset_record + 150;
            v:ToTop()
        end
    end

end

function SelectManager:Open()
    local SelectOpenTweener = Tween:SelectPicture(PropImage,{Offset = Vector2(0，500)},1,Enum.EaseCurve.QuarticInOut)--出现
    SelectOpenTweener:play()
end

function SelectManager:Close()
    local SelectCloseTweener = Tween:SelectPicture(PropImage,{Offset = Vector2(0，0)},1,Enum.EaseCurve.QuarticInOut)--移出
    SelectCloseTweener:play()
end

function SelectManager:MouseEnter(Button)
    Button.MouseEnter = true
end

function SelectManager:MouseLeave(Button)
    Button.MouseEnter = false
end
return SelectManager
