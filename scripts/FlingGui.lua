-- ============================================================
--  FLING GUI + ESP + SPEED/JUMP HACK — Script Unificado v3
--  Fox & Jack · LocalScript · StarterPlayerScripts
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
--  CONFIG
-- ============================================================
local CFG = {
    FlingForce    = 500000,
    FlingDuration = 0.2,
    AutoDelay     = 0.8,
    SpeedValue    = 50,       -- WalkSpeed default Roblox = 16
    JumpValue     = 100,      -- JumpPower default Roblox = 50
    GuiColor      = Color3.fromRGB(15, 15, 20),
    AccentColor   = Color3.fromRGB(255, 60, 60),
    TextColor     = Color3.fromRGB(240, 240, 240),
    SubTextColor  = Color3.fromRGB(160, 160, 160),
    GreenColor    = Color3.fromRGB(60, 200, 100),
}

-- ============================================================
--  GUI BUILD
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "FlingGui"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name             = "Main"
MainFrame.Size             = UDim2.new(0, 280, 0, 480)
MainFrame.Position         = UDim2.new(0, 20, 0.5, -240)
MainFrame.BackgroundColor3 = CFG.GuiColor
MainFrame.BorderSizePixel  = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent           = ScreenGui

do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,10); c.Parent = MainFrame
    local s = Instance.new("UIStroke"); s.Color = CFG.AccentColor; s.Thickness = 1.5; s.Parent = MainFrame
end

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TitleBar.BorderSizePixel  = 0
TitleBar.Parent           = MainFrame

do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,10); c.Parent = TitleBar
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0.5,0); f.Position = UDim2.new(0,0,0.5,0)
    f.BackgroundColor3 = Color3.fromRGB(25,25,32); f.BorderSizePixel = 0; f.Parent = TitleBar
end

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text           = "⚡ FLING GUI"
TitleLabel.Size           = UDim2.new(1, -70, 1, 0)
TitleLabel.Position       = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3     = CFG.AccentColor
TitleLabel.TextSize       = 14
TitleLabel.Font           = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent         = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Text             = "—"
MinBtn.Size             = UDim2.new(0, 30, 0, 24)
MinBtn.Position         = UDim2.new(1, -36, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinBtn.TextColor3       = CFG.TextColor
MinBtn.TextSize         = 14
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.BorderSizePixel  = 0
MinBtn.Parent           = TitleBar
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = MinBtn end

-- Content
local Content = Instance.new("Frame")
Content.Name               = "Content"
Content.Size               = UDim2.new(1, 0, 1, -36)
Content.Position           = UDim2.new(0, 0, 0, 36)
Content.BackgroundTransparency = 1
Content.Parent             = MainFrame

do
    local l = Instance.new("UIListLayout"); l.Padding = UDim.new(0,8); l.Parent = Content
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0,10); p.PaddingRight = UDim.new(0,10); p.PaddingTop = UDim.new(0,10)
    p.Parent = Content
end

local function MakeLabel(text, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text; lbl.Size = UDim2.new(1,0,0,16)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = CFG.SubTextColor
    lbl.TextSize = 11; lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = parent
    return lbl
end

-- Toggle row helper (label + ON/OFF button)
local function MakeToggleRow(labelText, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,30); frame.BackgroundTransparency = 1; frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Text = labelText; lbl.Size = UDim2.new(1,-58,1,0)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = CFG.TextColor
    lbl.TextSize = 12; lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Text = "OFF"; btn.Size = UDim2.new(0,50,0,24)
    btn.Position = UDim2.new(1,-50,0.5,-12)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,60); btn.TextColor3 = CFG.SubTextColor
    btn.TextSize = 11; btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0; btn.Parent = frame
    do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn end

    return btn
end

-- Slider helper
local function MakeSlider(parent, defaultRatio)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,0,8); bg.Position = UDim2.new(0,0,0.5,-4)
    bg.BackgroundColor3 = Color3.fromRGB(40,40,52); bg.BorderSizePixel = 0
    bg.Parent = parent
    do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = bg end

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(defaultRatio,0,1,0); fill.BackgroundColor3 = CFG.GreenColor
    fill.BorderSizePixel = 0; fill.Parent = bg
    do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = fill end

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,16,0,16); knob.Position = UDim2.new(defaultRatio,-8,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.BorderSizePixel = 0
    knob.Parent = bg
    do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = knob end

    return bg, fill, knob
end

-- ============================================================
--  ESP / HIGHLIGHT — DECLARADA PRIMEIRO
-- ============================================================
local ESPFolder       = Instance.new("Folder")
ESPFolder.Name        = "FlingESP"
ESPFolder.Parent      = workspace

local ActiveHighlight = nil
local ActiveBox       = nil
local ActiveBillboard = nil

local function ClearESP()
    if ActiveHighlight then ActiveHighlight:Destroy(); ActiveHighlight = nil end
    if ActiveBox       then ActiveBox:Destroy();       ActiveBox       = nil end
    if ActiveBillboard then ActiveBillboard:Destroy(); ActiveBillboard = nil end
end

local function ApplyESP(target)
    ClearESP()
    if not target then return end
    local char = target.Character; if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end

    local hl = Instance.new("Highlight")
    hl.Adornee             = char
    hl.FillColor           = Color3.fromRGB(255, 30, 30)
    hl.FillTransparency    = 0.45
    hl.OutlineColor        = Color3.fromRGB(255, 80, 80)
    hl.OutlineTransparency = 0
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent              = ESPFolder
    ActiveHighlight        = hl

    local box = Instance.new("SelectionBox")
    box.Adornee             = char
    box.Color3              = Color3.fromRGB(255, 60, 60)
    box.LineThickness       = 0.04
    box.SurfaceTransparency = 1
    box.SurfaceColor3       = Color3.fromRGB(255, 60, 60)
    box.Parent              = ESPFolder
    ActiveBox               = box

    local bb = Instance.new("BillboardGui")
    bb.Adornee      = hrp
    bb.Size         = UDim2.new(0, 140, 0, 40)
    bb.StudsOffset  = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop  = true
    bb.ResetOnSpawn = false
    bb.Parent       = ESPFolder
    ActiveBillboard = bb

    local bbFrame = Instance.new("Frame")
    bbFrame.Size = UDim2.new(1,0,1,0)
    bbFrame.BackgroundColor3 = Color3.fromRGB(10,10,14)
    bbFrame.BackgroundTransparency = 0.3
    bbFrame.BorderSizePixel = 0; bbFrame.Parent = bb
    do
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = bbFrame
        local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(255,60,60); s.Thickness = 1.2; s.Parent = bbFrame
    end

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = "⚡ " .. target.DisplayName
    nameLabel.Size = UDim2.new(1,0,0.55,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255,80,80)
    nameLabel.TextSize = 13; nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextScaled = true; nameLabel.Parent = bbFrame

    local userLabel = Instance.new("TextLabel")
    userLabel.Text = "@" .. target.Name
    userLabel.Size = UDim2.new(1,0,0.45,0); userLabel.Position = UDim2.new(0,0,0.55,0)
    userLabel.BackgroundTransparency = 1
    userLabel.TextColor3 = Color3.fromRGB(180,180,180)
    userLabel.TextSize = 10; userLabel.Font = Enum.Font.Gotham
    userLabel.TextScaled = true; userLabel.Parent = bbFrame

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "Dist"; distLabel.Text = ""
    distLabel.Size = UDim2.new(0,40,0.45,0); distLabel.Position = UDim2.new(1,-42,0.55,0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(255,200,60)
    distLabel.TextSize = 10; distLabel.Font = Enum.Font.GothamBold
    distLabel.TextScaled = true; distLabel.Parent = bbFrame
end

-- ============================================================
--  PLAYER LIST
-- ============================================================
MakeLabel("TARGET", Content)

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size                 = UDim2.new(1, 0, 0, 100)
ListFrame.BackgroundColor3     = Color3.fromRGB(22, 22, 28)
ListFrame.BorderSizePixel      = 0
ListFrame.ScrollBarThickness   = 3
ListFrame.ScrollBarImageColor3 = CFG.AccentColor
ListFrame.CanvasSize           = UDim2.new(0,0,0,0)
ListFrame.AutomaticCanvasSize  = Enum.AutomaticSize.Y
ListFrame.Parent               = Content

do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = ListFrame
    local l = Instance.new("UIListLayout"); l.Padding = UDim.new(0,2); l.Parent = ListFrame
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0,6); p.PaddingRight = UDim.new(0,6)
    p.PaddingTop = UDim.new(0,4); p.PaddingBottom = UDim.new(0,4)
    p.Parent = ListFrame
end

local SelectedTarget = nil
local PlayerButtons  = {}

local function SetTarget(player, btn)
    SelectedTarget = player
    for _, b in pairs(PlayerButtons) do
        b.BackgroundColor3 = Color3.fromRGB(35,35,45)
        b.TextColor3       = CFG.TextColor
    end
    if btn then
        btn.BackgroundColor3 = CFG.AccentColor
        btn.TextColor3       = Color3.fromRGB(255,255,255)
    end
    ApplyESP(player)
end

local function AddPlayerBtn(player)
    if player == LocalPlayer then return end
    local btn = Instance.new("TextButton")
    btn.Text             = player.DisplayName .. " (@" .. player.Name .. ")"
    btn.Size             = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
    btn.TextColor3       = CFG.TextColor
    btn.TextSize         = 12
    btn.Font             = Enum.Font.Gotham
    btn.TextXAlignment   = Enum.TextXAlignment.Left
    btn.BorderSizePixel  = 0
    btn.Parent           = ListFrame
    do
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
        local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0,8); p.Parent = btn
    end
    PlayerButtons[player.Name] = btn
    local function onTap() SetTarget(player, btn) end
    btn.MouseButton1Click:Connect(onTap)
    btn.TouchTap:Connect(onTap)
end

local function RemovePlayerBtn(player)
    if PlayerButtons[player.Name] then
        PlayerButtons[player.Name]:Destroy()
        PlayerButtons[player.Name] = nil
        if SelectedTarget == player then
            SelectedTarget = nil; ClearESP()
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do AddPlayerBtn(p) end
Players.PlayerAdded:Connect(AddPlayerBtn)
Players.PlayerRemoving:Connect(RemovePlayerBtn)

-- ============================================================
--  FORCE SLIDER
-- ============================================================
MakeLabel("FLING FORCE", Content)

local SliderContainer = Instance.new("Frame")
SliderContainer.Size = UDim2.new(1,0,0,34)
SliderContainer.BackgroundTransparency = 1
SliderContainer.Parent = Content

local SliderBg, SliderFill, SliderKnob = MakeSlider(SliderContainer, 0.5)
SliderFill.BackgroundColor3 = CFG.AccentColor

local ForceLabel = Instance.new("TextLabel")
ForceLabel.Text = "500k"; ForceLabel.Size = UDim2.new(1,0,0,14)
ForceLabel.Position = UDim2.new(0,0,1,2); ForceLabel.BackgroundTransparency = 1
ForceLabel.TextColor3 = CFG.AccentColor; ForceLabel.TextSize = 11
ForceLabel.Font = Enum.Font.GothamBold; ForceLabel.TextXAlignment = Enum.TextXAlignment.Right
ForceLabel.Parent = SliderContainer

local MIN_F, MAX_F   = 1000, 999000
local draggingSlider = false

local function UpdateSlider(absX)
    local ratio = math.clamp((absX - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    CFG.FlingForce      = math.floor(MIN_F + (MAX_F - MIN_F) * ratio)
    SliderFill.Size     = UDim2.new(ratio, 0, 1, 0)
    SliderKnob.Position = UDim2.new(ratio, -8, 0.5, -8)
    ForceLabel.Text     = math.floor(CFG.FlingForce / 1000) .. "k"
end

SliderKnob.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or
       i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)

-- ============================================================
--  FLING CORE
-- ============================================================
local function FlingTarget(target)
    if not target then return end
    local char = target.Character; if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    pcall(function()
        local ok = pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.Velocity  = Vector3.new(math.random(-1,1)*CFG.FlingForce, CFG.FlingForce, math.random(-1,1)*CFG.FlingForce)
            bv.MaxForce  = Vector3.new(1e9,1e9,1e9); bv.P = 1e9; bv.Parent = hrp
            local bav = Instance.new("BodyAngularVelocity")
            bav.AngularVelocity = Vector3.new(math.random(10,40),math.random(10,40),math.random(10,40))
            bav.MaxTorque = Vector3.new(1e9,1e9,1e9); bav.P = 1e9; bav.Parent = hrp
            task.delay(CFG.FlingDuration, function()
                pcall(function() bv:Destroy(); bav:Destroy() end)
            end)
        end)
        if not ok then
            hrp.AssemblyLinearVelocity  = Vector3.new(math.random(-1,1)*CFG.FlingForce, CFG.FlingForce, math.random(-1,1)*CFG.FlingForce)
            hrp.AssemblyAngularVelocity = Vector3.new(math.random(10,40),math.random(10,40),math.random(10,40))
        end
    end)
end

-- ============================================================
--  FLING BUTTON
-- ============================================================
local FlingBtn = Instance.new("TextButton")
FlingBtn.Text = "⚡  FLING"; FlingBtn.Size = UDim2.new(1,0,0,36)
FlingBtn.BackgroundColor3 = CFG.AccentColor; FlingBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlingBtn.TextSize = 14; FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.BorderSizePixel = 0; FlingBtn.Parent = Content
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = FlingBtn end

FlingBtn.MouseButton1Click:Connect(function() FlingTarget(SelectedTarget) end)
FlingBtn.TouchTap:Connect(function() FlingTarget(SelectedTarget) end)

-- ============================================================
--  AUTO FLING TOGGLE
-- ============================================================
local AutoActive = false
local AutoToggle = MakeToggleRow("AUTO FLING", Content)

local function SetAutoState(state)
    AutoActive = state
    if state then
        AutoToggle.Text = "ON"; AutoToggle.BackgroundColor3 = CFG.AccentColor
        AutoToggle.TextColor3 = Color3.fromRGB(255,255,255)
    else
        AutoToggle.Text = "OFF"; AutoToggle.BackgroundColor3 = Color3.fromRGB(50,50,60)
        AutoToggle.TextColor3 = CFG.SubTextColor
    end
end

AutoToggle.MouseButton1Click:Connect(function() SetAutoState(not AutoActive) end)
AutoToggle.TouchTap:Connect(function() SetAutoState(not AutoActive) end)

task.spawn(function()
    while true do
        task.wait(CFG.AutoDelay)
        if AutoActive and SelectedTarget then FlingTarget(SelectedTarget) end
    end
end)

-- ============================================================
--  SPEED HACK
-- ============================================================
MakeLabel("SPEED HACK", Content)

local SpeedActive  = false
local SpeedDefault = 16 -- WalkSpeed padrão Roblox

local SpeedSliderContainer = Instance.new("Frame")
SpeedSliderContainer.Size = UDim2.new(1,0,0,34)
SpeedSliderContainer.BackgroundTransparency = 1
SpeedSliderContainer.Parent = Content

local SpeedBg, SpeedFill, SpeedKnob = MakeSlider(SpeedSliderContainer, 0.25)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "50 ws"; SpeedLabel.Size = UDim2.new(1,0,0,14)
SpeedLabel.Position = UDim2.new(0,0,1,2); SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = CFG.GreenColor; SpeedLabel.TextSize = 11
SpeedLabel.Font = Enum.Font.GothamBold; SpeedLabel.TextXAlignment = Enum.TextXAlignment.Right
SpeedLabel.Parent = SpeedSliderContainer

local MIN_SPD, MAX_SPD = 16, 500
local draggingSpeed = false

local function UpdateSpeedSlider(absX)
    local ratio = math.clamp((absX - SpeedBg.AbsolutePosition.X) / SpeedBg.AbsoluteSize.X, 0, 1)
    CFG.SpeedValue      = math.floor(MIN_SPD + (MAX_SPD - MIN_SPD) * ratio)
    SpeedFill.Size      = UDim2.new(ratio, 0, 1, 0)
    SpeedKnob.Position  = UDim2.new(ratio, -8, 0.5, -8)
    SpeedLabel.Text     = CFG.SpeedValue .. " ws"
end

SpeedKnob.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or
       i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSpeed = true
    end
end)

local SpeedToggle = MakeToggleRow("SPEED ON/OFF", Content)

local function SetSpeedState(state)
    SpeedActive = state
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if state then
        SpeedToggle.Text = "ON"; SpeedToggle.BackgroundColor3 = CFG.GreenColor
        SpeedToggle.TextColor3 = Color3.fromRGB(255,255,255)
        if hum then hum.WalkSpeed = CFG.SpeedValue end
    else
        SpeedToggle.Text = "OFF"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(50,50,60)
        SpeedToggle.TextColor3 = CFG.SubTextColor
        if hum then hum.WalkSpeed = SpeedDefault end
    end
end

SpeedToggle.MouseButton1Click:Connect(function() SetSpeedState(not SpeedActive) end)
SpeedToggle.TouchTap:Connect(function() SetSpeedState(not SpeedActive) end)

-- ============================================================
--  JUMP HACK
-- ============================================================
MakeLabel("JUMP HACK", Content)

local JumpActive  = false
local JumpDefault = 50 -- JumpPower padrão Roblox

local JumpSliderContainer = Instance.new("Frame")
JumpSliderContainer.Size = UDim2.new(1,0,0,34)
JumpSliderContainer.BackgroundTransparency = 1
JumpSliderContainer.Parent = Content

local JumpBg, JumpFill, JumpKnob = MakeSlider(JumpSliderContainer, 0.2)

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Text = "100 jp"; JumpLabel.Size = UDim2.new(1,0,0,14)
JumpLabel.Position = UDim2.new(0,0,1,2); JumpLabel.BackgroundTransparency = 1
JumpLabel.TextColor3 = CFG.GreenColor; JumpLabel.TextSize = 11
JumpLabel.Font = Enum.Font.GothamBold; JumpLabel.TextXAlignment = Enum.TextXAlignment.Right
JumpLabel.Parent = JumpSliderContainer

local MIN_JMP, MAX_JMP = 50, 1000
local draggingJump = false

local function UpdateJumpSlider(absX)
    local ratio = math.clamp((absX - JumpBg.AbsolutePosition.X) / JumpBg.AbsoluteSize.X, 0, 1)
    CFG.JumpValue      = math.floor(MIN_JMP + (MAX_JMP - MIN_JMP) * ratio)
    JumpFill.Size      = UDim2.new(ratio, 0, 1, 0)
    JumpKnob.Position  = UDim2.new(ratio, -8, 0.5, -8)
    JumpLabel.Text     = CFG.JumpValue .. " jp"
end

JumpKnob.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or
       i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingJump = true
    end
end)

local JumpToggle = MakeToggleRow("JUMP ON/OFF", Content)

local function SetJumpState(state)
    JumpActive = state
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if state then
        JumpToggle.Text = "ON"; JumpToggle.BackgroundColor3 = CFG.GreenColor
        JumpToggle.TextColor3 = Color3.fromRGB(255,255,255)
        if hum then
            hum.JumpPower  = CFG.JumpValue
            hum.JumpHeight = CFG.JumpValue / 5
        end
    else
        JumpToggle.Text = "OFF"; JumpToggle.BackgroundColor3 = Color3.fromRGB(50,50,60)
        JumpToggle.TextColor3 = CFG.SubTextColor
        if hum then hum.JumpPower = JumpDefault; hum.JumpHeight = 7.2 end
    end
end

JumpToggle.MouseButton1Click:Connect(function() SetJumpState(not JumpActive) end)
JumpToggle.TouchTap:Connect(function() SetJumpState(not JumpActive) end)

-- ============================================================
--  INPUT CHANGED — processa todos os sliders
-- ============================================================
UserInputService.InputChanged:Connect(function(i)
    local isTouch = i.UserInputType == Enum.UserInputType.Touch
    local isMouse = i.UserInputType == Enum.UserInputType.MouseMovement
    if not (isTouch or isMouse) then return end

    if draggingSlider then UpdateSlider(i.Position.X) end
    if draggingSpeed  then
        UpdateSpeedSlider(i.Position.X)
        -- aplica em tempo real se ativo
        if SpeedActive then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = CFG.SpeedValue end
        end
    end
    if draggingJump then
        UpdateJumpSlider(i.Position.X)
        if JumpActive then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = CFG.JumpValue; hum.JumpHeight = CFG.JumpValue / 5 end
        end
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or
       i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
        draggingSpeed  = false
        draggingJump   = false
    end
end)

-- ============================================================
--  HEARTBEAT — ESP dist + reaplica speed/jump após respawn
-- ============================================================
RunService.Heartbeat:Connect(function()
    -- ESP
    if not SelectedTarget then ClearESP()
    elseif not ActiveHighlight or not ActiveHighlight.Parent then
        ApplyESP(SelectedTarget)
    else
        local myChar = LocalPlayer.Character
        local myHrp  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local tChar  = SelectedTarget.Character
        local tHrp   = tChar and tChar:FindFirstChild("HumanoidRootPart")
        if myHrp and tHrp and ActiveBillboard then
            local dist = math.floor((myHrp.Position - tHrp.Position).Magnitude)
            local f = ActiveBillboard:FindFirstChildWhichIsA("Frame")
            local d = f and f:FindFirstChild("Dist")
            if d then d.Text = dist .. "m" end
        end
    end

    -- Speed/Jump — mantém valores mesmo após respawn
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if SpeedActive and hum.WalkSpeed ~= CFG.SpeedValue then
            hum.WalkSpeed = CFG.SpeedValue
        end
        if JumpActive and hum.JumpPower ~= CFG.JumpValue then
            hum.JumpPower  = CFG.JumpValue
            hum.JumpHeight = CFG.JumpValue / 5
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == SelectedTarget then ClearESP(); SelectedTarget = nil end
end)

-- ============================================================
--  DRAG SYSTEM
-- ============================================================
local dragging  = false
local dragStart = nil
local startPos  = nil

TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or
       i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.Touch or
       i.UserInputType == Enum.UserInputType.MouseMovement) then
        local d = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                        startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or
       i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ============================================================
--  MINIMIZE
-- ============================================================
local minimized = false
local function ToggleMinimize()
    minimized       = not minimized
    Content.Visible = not minimized
    MainFrame.Size  = minimized and UDim2.new(0,280,0,36) or UDim2.new(0,280,0,480)
    MinBtn.Text     = minimized and "+" or "—"
end
MinBtn.MouseButton1Click:Connect(ToggleMinimize)
MinBtn.TouchTap:Connect(ToggleMinimize)
