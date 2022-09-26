local ServerProxy = class("ServerProxy", require("CommonProxy"))

function ServerProxy:__init()
    ServerProxy.super.__init(self)
    -- TODO
end

function ServerProxy:registerProxy()
    ServerProxy.super.registerProxy(self)

    local guiLoader = require("GuiLoader").new()
    Mod.current:RegisterServerGuiLoaderCallback({ guiLoader.GetServerGuiElement, guiLoader })

    local wdIns = require("Data").getInstance()
    Mod.current:RegisterWorldServerSaver({ wdIns.Save, wdIns })
    Mod.current:RegisterWorldServerLoader({ wdIns.Load, wdIns })
end

function ServerProxy:init()
    ServerProxy.super.init(self)
    -- TODO
end

function ServerProxy:start()
    ServerProxy.super.start(self)
    -- TODO
end

function ServerProxy:preUpdate()
    ServerProxy.super.preUpdate(self)
    -- TODO
end

function ServerProxy:update()
    ServerProxy.super.update(self)
    -- TODO
end

function ServerProxy:postUpdate()
    ServerProxy.super.postUpdate(self)
    -- TODO
end

function ServerProxy:exit()
    ServerProxy.super.exit(self)
    -- TODO
end

return ServerProxy