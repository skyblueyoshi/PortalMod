---@class TC.PortalContainerServer:Container
local PortalContainerServer = class("PortalContainerServer", Container)

---@param player Player
---@param xi int
---@param yi int
function PortalContainerServer:__init(player, xi, yi)
    PortalContainerServer.super.__init(self)
    self.xi = xi
    self.yi = yi
end

function PortalContainerServer:OnEvent(eventId, eventString)
    if eventId == 1 then
        print(eventString)
    end
end

function PortalContainerServer:OnClose()

end

function PortalContainerServer:CanInteractWith(_)
    return true
end

return PortalContainerServer