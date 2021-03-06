---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by asus.
--- DateTime: 2021/12/4 22:01
---
PlayerController = require('Moudles/PlayerController')
BlackScreenController = {}

BlackScreenController.UI = world.Resources.UI.BlackScreen

function BlackScreenController:Black()
    BlackScreenController.UI.Black.Color = Color(0,0,0,255)
    BlackScreenController.UI:SetActive(true)
    PlayerController:SetBlackOn(true)
    PlayerController.AllowMove = false
end

function BlackScreenController:DisableBlack()
    BlackScreenController.UI:SetActive(false)
    PlayerController:SetBlackOn(false)
    PlayerController:SetDefault()
end

function BlackScreenController:DisableBlackIn(sec)
    wait(sec)
    BlackScreenController.UI:SetActive(false)
    PlayerController:SetBlackOn(false)
    PlayerController:SetDefault()
end

function BlackScreenController:TransparentBlackOn() ---需要重构
    BlackScreenController.UI.Black.Color = Color(0,0,0,0)
    PlayerController:SetBlackOn(true)
    PlayerController.AllowMove = false
    BlackScreenController.UI:SetActive(true)
    while BlackScreenController.UI.Black.Color.A < 255 do
        BlackScreenController.UI.Black.Color = Color(0,0,0,BlackScreenController.UI.Black.Color.A + 1)
        wait(0.04)
    end

end

return BlackScreenController