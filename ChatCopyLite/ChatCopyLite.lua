-- ===========================
--  ChatCopyLite - Final Edition
--  Compatible Ascension / 3.3.5
-- ===========================

local frame = CreateFrame("Frame", "ChatCopyLiteFrame", UIParent)
frame:SetSize(600, 400)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

frame:Hide()

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("TOP", 0, -10)
title:SetText("Chat Copy")

local scroll = CreateFrame("ScrollFrame", "ChatCopyScroll", frame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 10, -40)
scroll:SetPoint("BOTTOMRIGHT", -30, 60)

local editBox = CreateFrame("EditBox", "ChatCopyEditBox", scroll)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(999999)
editBox:SetFontObject(ChatFontNormal)
editBox:SetWidth(550)
editBox:SetAutoFocus(false)
editBox:ClearFocus()
editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

scroll:SetScrollChild(editBox)

for _, region in pairs({ scroll:GetRegions() }) do
    if region.GetTexture and region:GetTexture() then
        region:SetTexture(nil)
    end
end

editBox:SetTextInsets(4, 4, 4, 4)
table.insert(UISpecialFrames, "ChatCopyLiteFrame")

local function ForceHighlight()
    local t = editBox:GetText()
    editBox:SetCursorPosition(#t)
    editBox:HighlightText(0, #t)
end

local infoText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
infoText:SetText("Press CTRL+C to copy the selected text")
infoText:SetPoint("BOTTOM", 0, 35)

local selectAll = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
selectAll:SetSize(120, 25)
selectAll:SetPoint("BOTTOMLEFT", 15, 10)
selectAll:SetText("Select All")
selectAll:SetScript("OnClick", ForceHighlight)

local close = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
close:SetSize(120, 25)
close:SetPoint("BOTTOMRIGHT", -15, 10)
close:SetText("Close")
close:SetScript("OnClick", function() frame:Hide() end)

local button = CreateFrame("Button", "ChatCopyLiteButton", UIParent)
button:SetSize(20, 20)
button:SetPoint("TOPRIGHT", ChatFrame1, "TOPRIGHT", -2, -2)
button:SetFrameStrata("HIGH")

button.texture = button:CreateTexture(nil, "ARTWORK")
button.texture:SetAllPoints()
button.texture:SetTexture("Interface\\ICONS\\INV_Scroll_11")
button.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
button.texture:SetVertexColor(1, 1, 1)

button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:AddLine("|cff00ff00ChatCopyLite|r")
    GameTooltip:AddLine("Click to open chat history copy window", 1, 1, 1)
    GameTooltip:Show()
    self.texture:SetVertexColor(0.3, 0.7, 1)
end)

button:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
    self.texture:SetVertexColor(1, 1, 1)
end)

button:SetScript("OnClick", function()
    local text = ""
    for i = 1, ChatFrame1:GetNumMessages() do
        local msg = ChatFrame1:GetMessageInfo(i)
        if msg then text = text .. msg .. "\n" end
    end
    editBox:SetText(text)
    ForceHighlight()
    frame:Show()
end)
