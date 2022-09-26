local ModProxy = class("ModProxy")

function ModProxy:__init()
    self.m_proxy = nil
    if NetMode.current == NetMode.Server then
        self.m_proxy = require("Server").new()
    else
        self.m_proxy = require("Client").new()
    end
    self.m_proxy:registerProxy()
end

function ModProxy:init()
    self.m_proxy:init()
end

function ModProxy:start()
    self.m_proxy:start()
end

function ModProxy:preUpdate()
    self.m_proxy:preUpdate()
end

function ModProxy:update()
    self.m_proxy:update()
end

function ModProxy:postUpdate()
    self.m_proxy:postUpdate()
end

function ModProxy:render()
    if NetMode.current == NetMode.Client then
        self.m_proxy:render()
    end
end

function ModProxy:exit()
    self.m_proxy:exit()
end

return ModProxy