---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by asus.
--- DateTime: 2021/12/4 22:01
---
PlayerController = require('Moudles/PlayerController')
BlackScreenController = {}

BlackScreenController.UI = world.Resources.UI.BlackScreen

function BlackScreenController:Black()
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

return BlackScreenController