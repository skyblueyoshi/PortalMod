---@class Portal.PortalUI:GuiContainer
local PortalUI = class("PortalUI", GuiContainer)
local Locale = require("Locale")
local TCLocale = require("tc.languages.Locale")
---@type TC.UIUtil
local UIUtil = require("tc.ui.UIUtil")
---@type TC.UIDefault
local UIDefault = require("tc.ui.UIDefault")
---@type TC.NetworkProxy
local NetworkProxy = require("tc.network.NetworkProxy")
local RPC_ID = require("RPC_ID")
---@type TC.ClientBoundResponse
local ClientBoundResponse = require("tc.network.ClientBoundResponse")

function PortalUI.GetUI()
    local UI_SIZE = Size.new(600, 450)
    local root = UIUtil.createBlackFullScreenLayer("portal_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:getChild("bg").visible = false
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.PORTAL_TITLE,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    local panelNew = UIUtil.createPanel("panel_new", 0, 0, 32, 32, {
        margins = { 0, 0, 0, 0, true, true },
    })
    panel:addChild(panelNew)

    panelNew:addChild(UIUtil.createLabel("lb_pos", "", 0, 250, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize,
                color = Color.new(255, 255, 128)
            }))

    panelNew:addChild(UIUtil.createLabel("lb_new_pos", Locale.PORTAL_NEW, 0, 70, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 12,
                color = Color.new(188, 188, 188)
            }))

    local inputs = {
        { "name", "传送门名称", "Portal Name Here" },
    }
    local inputY = 160

    for _, input in ipairs(inputs) do
        panelNew:addChild(UIUtil.createLabel("lb_" .. input[1], input[2],
                0, inputY, 180, 48,
                TextAlignment.HCenter, TextAlignment.VCenter, {}))
        local panelInput = UIUtil.createPanel("input_panel_" .. input[1], 0, inputY, 180, 48, {
            marginsLR = { 180, 32 },
            sprite = {
                name = "tc:round_rect_white",
                color = Color.new(60, 60, 85)
            }
        })
        panelNew:addChild(panelInput)
        panelInput:addChild(UIUtil.createPanelNoPos("bg", {
            margins = { 2, 2, 2, 2 },
            sprite = {
                name = "tc:round_rect_white",
                color = Color.new(30, 30, 45)
            }
        }))
        local editBox = UIInputField.new("edit")
        UIUtil.setMargins(editBox, 8, 8, 8, 8)
        panelInput:addChild(editBox)

        if input[3] then
            editBox.text = input[3]
        end

        inputY = inputY + 64
    end

    local panelJump = UIUtil.createPanel("panel_jump", 0, 0, 32, 32, {
        margins = { 0, 0, 0, 0, true, true },
    })
    panel:addChild(panelJump)

    panelJump:addChild(UIUtil.createLabel("lb_pos", Locale.PORTAL_CHOOSE, 0, 320, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize,
                color = Color.new(255, 255, 128)
            }))

    local panelList = UIUtil.createScrollViewNoPos("panel_list", {
        margins = { 16, 64, 16, 140 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    })
    panelJump:addChild(panelList)
    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 64)
    panelList:addChild(panelItem)
    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        visible = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 80, 222)
        }
    }))
    panelItem:addChild(UIUtil.createImage("img_line", 0, 64, 100, 2, {
        marginsLR = { 16, 16 },
        sprite = {
            name = "tc:white",
            color = Color.new(60, 60, 80, 100)
        }
    }))
    panelItem:addChild(UIUtil.createLabel("lb_name", "Test Portal Name",
            16, 16, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter, {
                isRichText = true,
            }))

    panel:addChild(UIUtil.createButton("btn_back", TCLocale.BACK, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 60, nil, nil, 32, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", TCLocale.OK, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { nil, nil, 60, 32, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    return root
end

function PortalUI:__init(container)
    PortalUI.super.__init(self, container)
    self.ui = require("tc.ui.UIWindow").new(PortalUI.GetUI())
    self._rootLayer = self.ui.root:getChild("layer")

    self._lbTitle = self.ui.root:getChild("layer.lb_title")
    self._panelJump = self.ui.root:getChild("layer.panel_jump")
    self._panelNew = self.ui.root:getChild("layer.panel_new")
    self._edit = UIInputField.cast(self._panelNew:getChild("input_panel_name.edit"))
    self._lbPos = UIText.cast(self._panelNew:getChild("lb_pos"))

    self._panelList = self._panelJump:getChild("panel_list")
    self._panelItem = self._panelList:getChild("panel_item")

    self._portalList = {}
    self._isNew = false
    self._isWaitingData = true

    self.xi = container.xi
    self.yi = container.yi

    self._indexSelected = 0
    self._itemNodes = {}

    self:_initContent()
end

function PortalUI:_initContent()
    self._lbTitle.visible = false
    self._panelJump.visible = false
    self._panelNew.visible = false
    self.itemSize = Size.new(self._panelItem.width / 1, self._panelItem.height)

    self.ui.root:addTouchUpListener({ self._onBgClicked, self })
    self._rootLayer:getChild("btn_back"):addTouchUpListener({ self._onBackClicked, self })
    self._rootLayer:getChild("btn_ok"):addTouchUpListener({ self._onOkClicked, self })
    self:TriggerServerEvent(1, "hello server!")

    ClientBoundResponse.getInstance():addResponseCallback(Mod.GetByID("portal"),
            RPC_ID.CB_RESPONSE_PORTALS, self.OnGetData, self
    )

    ClientBoundResponse.getInstance():addResponseCallback(Mod.GetByID("portal"),
            RPC_ID.CB_RESPONSE_ADD_PORTAL, self.OnGetPortalResponse, self
    )

    NetworkProxy.RPCSendServerBound(Mod.GetByID("portal"),
            RPC_ID.SB_REQUEST_PORTALS, self.xi, self.yi)

    self:FlushListLayout()
end

function PortalUI:RecvData(data)
    local function array_reverse(x)
        local n, m = #x, #x / 2
        for i = 1, m do
            x[i], x[n - i + 1] = x[n - i + 1], x[i]
        end
        return x
    end
    self._portalList = clone(data)
    self._portalList = array_reverse(self._portalList)
end

function PortalUI:OnGetData(data)
    print("PortalUI:OnGet", data)
    self:RecvData(data)
    if self._isWaitingData then
        self._isWaitingData = false

        if not self:IsInPortalList() then
            print("First Time Open Portal at:", self.xi, self.yi)
            self._isNew = true
            self._panelJump.visible = false
            self._panelNew.visible = true

            self._edit.text = self:getDefaultName()
            self._lbPos.text = string.format(Locale.PORTAL_LOC, self.xi, self.yi)

            -- TEST
            -- NetworkProxy.RPCSendServerBound(Mod.GetByID("portal"), RPC_ID.SB_ADD_PORTAL, self.xi, self.yi, "Test Portal")
        else
            self:ShowList()
        end
    end
end

function PortalUI:ShowList()
    self._isNew = false
    self._panelJump.visible = true
    self._panelNew.visible = false
    self._lbTitle.visible = true

    UIText.cast(self._rootLayer:getChild("btn_ok.lb_caption")).text = Locale.PORTAL_DO

    self:FlushListLayout()
end

function PortalUI:OnGetPortalResponse(data)
    self:RecvData(data)
    self:ShowList()
end

function PortalUI:FlushListLayout()
    self._indexSelected = 0
    self._itemNodes = {}
    UIUtil.setTable(self._panelList, self, true, 1)
end

function PortalUI:_getTableElementCount()
    return #self._portalList
end

function PortalUI:_getTableElementSize()
    return self.itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function PortalUI:_setTableElement(node, index)
    node.tag = index

    local data = self._portalList[index]
    local lbName = UIText.cast(node:getChild("lb_name"))
    local name = data.name .. string.format(" (%d,%d)", data.xi, data.yi)

    lbName.text = name

    node:addTouchUpListener({ self._onElementClicked, self })
    table.insert(self._itemNodes, node)
end

---_onElementClicked
---@param node UINode
---@param _ Touch
function PortalUI:_onElementClicked(node)
    local index = node.tag
    if self._indexSelected ~= index then
        self.ui.manager:playClickSound()
        self._indexSelected = index
        self:updateSelection()
    end
end

function PortalUI:updateSelection()
    ---@param node UINode
    for _, node in pairs(self._itemNodes) do
        local show = false
        if node.tag == self._indexSelected then
            show = true
        end
        node:getChild("img_selected").visible = show
    end
end

function PortalUI:IsInPortalList()
    for _, data in ipairs(self._portalList) do
        if data.xi == self.xi and data.yi == self.yi then
            return true
        end
    end
    return false
end

function PortalUI:OnClose()
    print("OnClose!")
    ClientBoundResponse.getInstance():removeResponse(self)
    self.ui:closeWindow()
end

function PortalUI:_onBackClicked()
    self.ui.manager:playClickSound()
    self:DoClose()
end

function PortalUI:_onBgClicked()
    self:DoClose()
end

function PortalUI:DoClose()
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        local GuiID = require("GuiID")
        player:CloseGui(Mod.current, GuiID.Portal)
    end
end

function PortalUI:getDefaultName()
    return string.format("Portal #%d", #self._portalList + 1)
end

function PortalUI:_onOkClicked()
    self.ui.manager:playClickSound()
    if self._isNew then
        local text = self._edit.text
        if not text then
            text = self:getDefaultName()
        end
        NetworkProxy.RPCSendServerBound(Mod.GetByID("portal"), RPC_ID.SB_ADD_PORTAL, self.xi, self.yi, text)
    else
        if self._indexSelected > 0 and self._indexSelected <= #self._portalList then
            local data = self._portalList[self._indexSelected]
            local xi, yi = data.xi, data.yi
            NetworkProxy.RPCSendServerBound(Mod.GetByID("portal"), RPC_ID.SB_DO_TELEPORT, xi, yi)
        end

        SoundUtils.PlaySoundGroup(Reg.SoundGroupID("portal"))

        self:DoClose()
    end
end

return PortalUI