---@class Portal.Gen:TC.ModChunkGenerator
local Gen = class("Gen", require("tc.world_gen.ModChunkGenerator"))
---@type TC.WorldGenDefine
local Define = require("tc.world_gen.WorldGenDefine")

local SURFACE_LINE = Define.SURFACE_LINE
local UNDERGROUND_LINE = Define.UNDERGROUND_LINE
local NETHER_LINE = Define.NETHER_LINE

---@param generator TC.ChunkGenerator
function Gen:__init(generator)
    Gen.super.__init(self, generator)
    self.generator = generator
    ---@type WorldGenNoise
    self.noise = generator.noise
    ---@type WorldGenChunkBuffer
    self.buffer = generator.buffer
    self.chunkXi = generator.chunkXi
    self.chunkYi = generator.chunkYi
    self.chunkXiInMap = generator.chunkXiInMap
    self.chunkYiInMap = generator.chunkYiInMap

end

function Gen:onInitLayer()
end

function Gen:onGenerateBuildings()
    local noise = self.noise
    local chunkYiInMap = self.chunkYiInMap
    if self.generator.isGenSurface then
        -- Every chunk will generate 3 portals randomly.
        local surfaceBoundary = self.generator.surfaceBoundary
        -- Pick 3 positions.
        for i = 1, 111 do
            local rate = math.abs(noise:GetDoubleFromInt1D(self.chunkXi * 13 + i * 7))
            local xi = 10 + math.ceil(rate * 1000)
            local yi = surfaceBoundary[xi + 1] - chunkYiInMap

            self.generator:createPendingBuildings(Reg.BuildingID("portal:nature_portal"), xi, yi, 15)
        end
    end
end

return Gen