local ClientProxy = class("ClientProxy", require("CommonProxy"))

function ClientProxy:__init()
    ClientProxy.super.__init(self)
    -- TODO
end

function ClientProxy:registerProxy()
    ClientProxy.super.registerProxy(self)

    local guiLoader = require("GuiLoader").new()
    Mod.current:RegisterClientGuiLoaderCallback({ guiLoader.GetClientGuiElement, guiLoader })
end

function ClientProxy:init()
    ClientProxy.super.init(self)
    -- TODO
end

function ClientProxy:start()
    ClientProxy.super.start(self)
    -- TODO
end

function ClientProxy:preUpdate()
    ClientProxy.super.preUpdate(self)
    -- TODO
end

function ClientProxy:update()
    ClientProxy.super.update(self)
    -- TODO
end

function ClientProxy:postUpdate()
    ClientProxy.super.postUpdate(self)
    -- TODO
end

function ClientProxy:render()
    -- TODO
end

function ClientProxy:exit()
    ClientProxy.super.exit(self)
    -- TODO
end

return ClientProxy