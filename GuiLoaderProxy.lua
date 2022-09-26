local GuiID = require("GuiID")

local serverProxies = {
    [GuiID.Portal] = function(player, xi, yi)
        return require("PortalContainerServer").new(player, xi, yi)
    end,
}

local clientProxies = {
    [GuiID.Portal] = function(player, xi, yi)
        local PortalContainerClient = require("PortalContainerClient")
        local PortalUI = require("PortalUI")
        return PortalUI.new(PortalContainerClient.new(player, xi, yi))
    end,
}

return { serverProxies, clientProxies }