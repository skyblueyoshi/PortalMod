local PortalWorldGen = class("PortalWorldGen")
local ModChunkGenerator = require("tc.world_gen.ModChunkGenerator")
local Gen = require("Gen")

function PortalWorldGen:init()
    ModChunkGenerator.register(Gen)
end

return PortalWorldGen