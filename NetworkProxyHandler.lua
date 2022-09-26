---@class Portal.NetworkProxyHandler:TC.ModNetworkProxyHandler
local NetworkProxyHandler = class("TCNetworkProxyHandler", require("tc.network.ModNetworkProxyHandler"))
local RPC_ID = require("RPC_ID")
local ClientBoundResponse = require("tc.network.ClientBoundResponse")
local NetworkProxy = require("tc.network.NetworkProxy")
local Data = require("Data")

function NetworkProxyHandler:__init()
    NetworkProxyHandler.super.__init(self, Mod.current)

    local SERVER_BOUND_MAPPINGS = {
        [RPC_ID.SB_REQUEST_PORTALS] = NetworkProxyHandler.RequestPortals,
        [RPC_ID.SB_ADD_PORTAL] = NetworkProxyHandler.AddPortal,
    }
    local CLIENT_BOUND_MAPPINGS = {
        [RPC_ID.CB_RESPONSE_PORTALS] = NetworkProxyHandler.ResponsePortals,
        [RPC_ID.CB_RESPONSE_ADD_PORTAL] = NetworkProxyHandler.ResponseAddPortals,
    }

    self:RegisterRPCHandlerServerBoundMappings(SERVER_BOUND_MAPPINGS)
    self:RegisterRPCHandlerClientBoundMappings(CLIENT_BOUND_MAPPINGS)
end

local function GetPortalListData()
    local portals = Data.getInstance().portals:GetList()
    local res = {}
    for _, portalData in ipairs(portals) do
        table.insert(res, {
            xi = portalData.xi,
            yi = portalData.yi,
            name = portalData.name,
            owner = portalData.owner,
        })
    end
    return res
end

function NetworkProxyHandler:RequestPortals(player, xi, yi)
    NetworkProxy.RPCSendClientBound(
            Mod.current, RPC_ID.CB_RESPONSE_PORTALS, player, GetPortalListData())
end

function NetworkProxyHandler:ResponsePortals(data)
    ClientBoundResponse.getInstance():doResponse(
            Mod.current, RPC_ID.CB_RESPONSE_PORTALS, data)
end

function NetworkProxyHandler:AddPortal(player, xi, yi, name)
    Data.getInstance().portals:Register(xi, yi, name, player.name)

    NetworkProxy.RPCSendClientBound(
            Mod.current, RPC_ID.CB_RESPONSE_ADD_PORTAL, player, GetPortalListData())
end

function NetworkProxyHandler:ResponseAddPortals(data)
    ClientBoundResponse.getInstance():doResponse(
            Mod.current, RPC_ID.CB_RESPONSE_ADD_PORTAL, data)
end

return NetworkProxyHandler