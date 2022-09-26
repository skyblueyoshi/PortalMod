---@class TC.BlockPortal:ModBlock
local BlockPortal = class("BlockPortal", ModBlock)
local GuiID = require("GuiID")

function BlockPortal.OnClicked(xi, yi, parameterClick)
    local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        player:OpenGui(Mod.current, GuiID.Portal, xi, yi)
    end
end

function BlockPortal.UpdateScreen(xi, yi, tickTime)
    local checkTime = xi + yi + tickTime
    if checkTime % 32 == 0 then
        local effectAngle = Utils.RandSym(math.pi)
        local d = 120
        local effectX = xi * 16 + 8 + math.cos(effectAngle) * d
        local effectY = (yi - 1) * 16 + 8 + math.sin(effectAngle) * d

        local effectSpeed = 1
        local effectSpeedAngle = Utils.FixAngle(effectAngle + math.pi)
        local spx = math.cos(effectSpeedAngle) * effectSpeed
        local spy = math.sin(effectSpeedAngle) * effectSpeed

        local colorChannel = Utils.RandIntArea(200, 50)

        local effect = EffectUtils.Create(
                Reg.EffectID("flash2"),
                effectX,
                effectY,
                spx,
                spy,
                Utils.RandSym(0.5),
                Utils.RandDoubleArea(0.5,0.7),
                1,
                Color.new(colorChannel * 0.75, colorChannel * 0.75, colorChannel)
        )
        effect:SetDisappearTime(240)
    end
end

return BlockPortal