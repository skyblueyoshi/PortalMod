---@class Portal.PortalEntity
local PortalEntity = class("PortalEntity")

function PortalEntity:__init(xi, yi, name, owner)
    self.xi = xi
    self.yi = yi
    self.name = name
    self.owner = owner
end

local Portals = class("Portals")

function Portals:__init()
    self._dataList = {}  ---@type Portal.PortalEntity[]
end

function Portals:Register(xi, yi, name, owner)
    if self:IsExist(xi, yi) then
        return
    end
    table.insert(self._dataList, PortalEntity.new(xi, yi, name, owner))
end

function Portals:IsExist(xi, yi)
    return self:GetData(xi, yi) ~= nil
end

function Portals:GetList()
    return self._dataList
end

function Portals:GetData(xi, yi)
    for _, e in ipairs(self._dataList) do
        if e.xi == xi and e.yi == yi then
            return e
        end
    end
    return nil
end

function Portals:Save()
    local resList = {}
    for _, e in ipairs(self._dataList) do
        local elementData = {
            xi = e.xi,
            yi = e.yi,
            name = e.name,
            owner = e.owner,
        }
        table.insert(resList, elementData)
    end
    return {
        list = resList
    }
end

function Portals:Load(data)
    if data.list ~= nil then
        local resList = data.list
        for _, e in ipairs(resList) do
            local xi, yi, name, owner = e.xi, e.yi, e.name, e.owner
            self:Register(xi, yi, name, owner)
        end
    end
end

---@class Portal.Data
local Data = class("Data")

local s_instance
---@return Portal.Data
function Data.getInstance()
    if s_instance == nil then
        s_instance = Data.new()
    end
    return s_instance
end

function Data:__init()
    self.portals = Portals.new()
end

function Data:Save()
    local resPortals = self.portals:Save()
    return {
        portals = resPortals
    }
end

function Data:Load(data)
    if data.portals ~= nil then
        self.portals:Load(data.portals)
    end
end

return Data