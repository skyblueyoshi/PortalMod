local CommonProxy = class("CommonProxy")
function CommonProxy:__init()
    -- TODO
end

function CommonProxy:registerProxy()
    local networkProxyHandler = require("NetworkProxyHandler")
    networkProxyHandler.new()
end

function CommonProxy:init()
    require("tc.languages.LocaleHelper").reload(require("Locale"))
end

function CommonProxy:start()
    -- TODO
end

function CommonProxy:preUpdate()
    -- TODO
end

function CommonProxy:update()
    -- TODO
end

function CommonProxy:postUpdate()
    -- TODO
end

function CommonProxy:exit()
    -- TODO
end

return CommonProxy