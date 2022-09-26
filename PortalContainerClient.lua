---@class Portal.PortalContainerClient:Container
local PortalContainerClient = class("PortalContainerClient", Container)

---@param player Player
---@param xi int
---@param yi int
function PortalContainerClient:__init(player, xi, yi)
    PortalContainerClient.super.__init(self)
    self.player = player
    self.xi = xi
    self.yi = yi
end

function PortalContainerClient:OnEvent(eventId, eventString)
    print(eventId, eventString)
end

function PortalContainerClient:OnClose()
end

function PortalContainerClient:CanInteractWith(player)
    return true
end

return PortalContainerClient