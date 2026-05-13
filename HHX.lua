for k, v in pairs(getgc(true)) do
    if pcall(function()
        return rawget(v, "indexInstance")
    end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
        setreadonly(v, false)
        v.tvk = {
            "kick",
            function()
                print("✅ Hexa.lua | Adonis get counter, suck your own XD...")
                return game.Workspace:WaitForChild("")
            end
        }
    end
end
print("✅ Game authorized | Hexa.Lua - Loading script...")

if Hexalua then print("Hexa.Lua | Script Has been loaded before, Rejoin to fix this issue!...") return end
if IY_LOADED and not _G.IY_DEBUG then print("Hexa.Lua | The Script has been protect, Rejoin to fix this issue!...") return end
pcall(function() getgenv().Hexalua = true end)

print("Loading")
task.wait(2)
print("===============================================")
print("Checking Complate - Time To Show")
print("CREADIT - Hexa_lua (Discord only)")
print("===============================================")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/Mentality/Library.lua"))()

local function missing(t, f, fallback) if type(f) == t then return f end return fallback end

cloneref = missing("function", cloneref, function(...) return ... end)
sethidden = missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden = missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
queueteleport = missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
httprequest = missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
everyClipboard = missing("function", setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set))
firetouchinterest = missing("function", firetouchinterest)
fireproximityprompt = missing("function", fireproximityprompt)
hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)
getnamecallmethod = missing("function", getnamecallmethod or get_namecall_method)
checkcaller = missing("function", checkcaller, function() return false end)
newcclosure = missing("function", newcclosure, function(f) return f end)
getgc = missing("function", getgc or get_gc_objects)
setthreadidentity = missing("function", setthreadidentity or (syn and syn.set_thread_identity) or syn_context_set or setthreadcontext)
replicatesignal = missing("function", replicatesignal)
getconnections = missing("function", getconnections or get_signal_cons)
makefolder = missing("function", makefolder)
isfolder = missing("function", isfolder)
waxgetcustomasset = missing("function", getcustomasset or getsynasset)

waxwritefile, waxreadfile = writefile, readfile
writefile = missing("function", waxwritefile) and function(file, data, safe) if safe == true then return pcall(waxwritefile, file, data) end waxwritefile(file, data) end
readfile = missing("function", waxreadfile) and function(file, safe) if safe == true then return pcall(waxreadfile, file) end return waxreadfile(file) end
isfile = missing("function", isfile, readfile and function(file) local s, r = pcall(function() return readfile(file) end) return s and r ~= nil and r ~= "" end)

Services = setmetatable({}, {
    __index = function(self, name)
        local ok, svc = pcall(function() return cloneref(game:GetService(name)) end)
        if ok and svc then rawset(self, name, svc); return svc end
        error("Invalid Service: "..tostring(name))
    end
})
task.defer(function()
    local _ = Services.Players
    _ = Services.RunService
    _ = Services.UserInputService
    _ = Services.ReplicatedStorage
    _ = Services.Workspace
end)

--================================================================
-- UTILITIES
--================================================================
local Utils = {}
local Features = {}

function Utils.Alert(title, content, duration)
    return Library:Notification({
        Title = title or "Notification",
        Description = content or "",
        Duration = duration or 10,
        Icon = 84474740888511,
    })
end

function Utils.CopyToClipboard(text)
    if not text or text == "" then return false end
    local ok = pcall(function()
        if setclipboard then setclipboard(tostring(text))
        elseif everyClipboard then everyClipboard(tostring(text)) end
    end)
    if ok then return true end
    Utils.Alert("Copy Manually", "Text: "..tostring(text), 10)
    return false
end

function Utils.NewLine(color, thickness)
    local l = Drawing.new("Line")
    l.Visible = false; l.From = Vector2.new(0,0); l.To = Vector2.new(0,0)
    l.Color = color; l.Thickness = thickness; l.Transparency = 1
    return l
end

function Utils.NewText(color, size, center, outline)
    local t = Drawing.new("Text")
    t.Visible = false; t.Text = ""; t.Color = color
    t.Size = size or 14; t.Center = center ~= false; t.Outline = outline ~= false
    t.OutlineColor = Color3.new(0,0,0); t.Transparency = 1; t.Position = Vector2.new(0,0)
    return t
end

function Utils.NewSquare(color, filled, thickness)
    local ok, s = pcall(function()
        local sq = Drawing.new("Square")
        sq.Visible = false; sq.Color = color or Color3.new(1,1,1)
        sq.Filled = filled ~= false; sq.Thickness = thickness or 1
        sq.Transparency = 1; sq.Size = Vector2.new(0,0); sq.Position = Vector2.new(0,0)
        return sq
    end)
    return ok and s or nil
end

function Utils.NewCircle(color, filled, thickness)
    local ok, c = pcall(function()
        local ci = Drawing.new("Circle")
        ci.Visible = false; ci.Color = color or Color3.new(1,1,1)
        ci.Filled = filled ~= false; ci.Thickness = thickness or 1
        ci.Transparency = 1; ci.Radius = 0; ci.Position = Vector2.new(0,0); ci.NumSides = 30
        return ci
    end)
    return ok and c or nil
end

function Utils.SetVisible(dr, s) for _, d in pairs(dr) do if d then d.Visible = s end end end
function Utils.SetColor(dr, c) for _, d in pairs(dr) do if d then d.Color = c end end end
function Utils.RemoveDrawings(dr) for k, d in pairs(dr) do if d then pcall(function() d:Remove() end) end; dr[k] = nil end end
function Utils.DisconnectAll(cn) for k, c in pairs(cn) do if typeof(c) == "RBXScriptConnection" then c:Disconnect() end; cn[k] = nil end end

function Utils.IsCharacterValid(plr)
    if not plr or not plr.Parent then return false end
    local char = plr.Character; if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not hum or not hrp or not head or hum.Health <= 0 then return false end
    return true, char, hum, hrp, head
end

function Utils.WaitForCharacter(plr, timeout)
    timeout = timeout or 15; local t = 0
    while not Utils.IsCharacterValid(plr) do
        task.wait(0.1); t = t + 0.1
        if t > timeout or not plr or not plr.Parent then return false end
    end
    return true
end

function Utils.GetWorldDistance(pos)
    local lp = Services.Players.LocalPlayer; if not lp then return math.huge end
    local char = lp.Character; if not char then return math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return math.huge end
    return (hrp.Position - pos).Magnitude
end

function Utils.GetTeamNames()
    local names = {}
    pcall(function() for _, team in pairs(game:GetService("Teams"):GetTeams()) do names[#names+1] = team.Name end end)
    if #names == 0 then names = {"None"} end
    return names
end

function Utils.GetPlayerTeamName(plr)
    local name = ""
    pcall(function() if plr.Team then name = plr.Team.Name end end)
    return name
end

function Utils.HasForceField(plr)
    if not plr then return false end
    local char = plr.Character
    if not char then return false end
    return char:FindFirstChildOfClass("ForceField") ~= nil
end

function Utils.RandomName()
    local prefixes = {"Gui","UI","Effect","Particle","Light","Ambient","Render","Camera","Sound","Decal"}
    local suffixes = {"Handler","Manager","Controller","System","Module","Service","Helper","Wrapper","Cache","Pool"}
    return prefixes[math.random(#prefixes)]..suffixes[math.random(#suffixes)]..tostring(math.random(1000,9999))
end

function Utils.LerpColor(c1, c2, t)
    return Color3.new(
        c1.R + (c2.R - c1.R) * t,
        c1.G + (c2.G - c1.G) * t,
        c1.B + (c2.B - c1.B) * t
    )
end

function Utils.GetServerPlayerNames(excludeLocal)
    local names = {}
    for _, plr in ipairs(Services.Players:GetPlayers()) do
        if excludeLocal and plr == Services.Players.LocalPlayer then continue end
        names[#names+1] = plr.Name
    end
    if #names == 0 then names = {"(No Players)"} end
    return names
end

-- ============= --
-- MOVEMENT SYSTEM
-- ============= --
local Movement = {
    WalkSpeed  = { Enabled=false, Value=16,  Method="Instant", OriginalValue=16,  Connection=nil, SmoothSpeed=0.1 },
    JumpPower  = { Enabled=false, Value=50,  Method="Instant", OriginalValue=50,  Connection=nil, SmoothSpeed=0.1 },
    JumpHeight = { Enabled=false, Value=7.2, Method="Instant", OriginalValue=7.2, Connection=nil, SmoothSpeed=0.1 },
    Speed      = { Enabled=false, Value=1,   Method="Smooth",  Connection=nil },
}

function Movement.WalkSpeed:Toggle(state)
    self.Enabled = state
    local player = Services.Players.LocalPlayer; if not player then return end
    if self.Connection then self.Connection:Disconnect(); self.Connection = nil end
    if state then
        local function apply()
            local char = player.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            if self.OriginalValue == 16 then self.OriginalValue = hum.WalkSpeed end
            if self.Method == "Smooth" then
                local cur = hum.WalkSpeed; hum.WalkSpeed = cur + (self.Value - cur) * self.SmoothSpeed
            else hum.WalkSpeed = self.Value end
        end
        if self.Method == "Looping" or self.Method == "Smooth" then
            self.Connection = Services.RunService.Heartbeat:Connect(apply)
        else apply() end
    else
        local char = player.Character
        if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed = self.OriginalValue end end
    end
end

function Movement.JumpPower:Toggle(state)
    self.Enabled = state
    local player = Services.Players.LocalPlayer; if not player then return end
    if self.Connection then self.Connection:Disconnect(); self.Connection = nil end
    if state then
        local function apply()
            local char = player.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid"); if not hum or not hum.UseJumpPower then return end
            if self.OriginalValue == 50 then self.OriginalValue = hum.JumpPower end
            if self.Method == "Smooth" then
                local cur = hum.JumpPower; hum.JumpPower = cur + (self.Value - cur) * self.SmoothSpeed
            else hum.JumpPower = self.Value end
        end
        if self.Method == "Looping" or self.Method == "Smooth" then
            self.Connection = Services.RunService.Heartbeat:Connect(apply)
        else apply() end
    else
        local char = player.Character
        if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum and hum.UseJumpPower then hum.JumpPower = self.OriginalValue end end
    end
end

function Movement.JumpHeight:Toggle(state)
    self.Enabled = state
    local player = Services.Players.LocalPlayer; if not player then return end
    if self.Connection then self.Connection:Disconnect(); self.Connection = nil end
    if state then
        local function apply()
            local char = player.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid"); if not hum or hum.UseJumpPower then return end
            if self.OriginalValue == 7.2 then self.OriginalValue = hum.JumpHeight end
            if self.Method == "Smooth" then
                local cur = hum.JumpHeight; hum.JumpHeight = cur + (self.Value - cur) * self.SmoothSpeed
            else hum.JumpHeight = self.Value end
        end
        if self.Method == "Looping" or self.Method == "Smooth" then
            self.Connection = Services.RunService.Heartbeat:Connect(apply)
        else apply() end
    else
        local char = player.Character
        if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum and not hum.UseJumpPower then hum.JumpHeight = self.OriginalValue end end
    end
end

function Movement.Speed:Toggle(state)
    self.Enabled = state
    local player = Services.Players.LocalPlayer; if not player then return end
    if self.Connection then self.Connection:Disconnect(); self.Connection = nil end
    if state then
        self.Connection = Services.RunService.Heartbeat:Connect(function()
            local char = player.Character; if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local mult = self.Method == "Instant" and 1 or (self.Method == "Looping" and 0.05 or 0.1)
                hrp.CFrame = hrp.CFrame + (moveDir * self.Value * mult)
            end
        end)
    end
end

-- ============= --
-- RAPID FIRE SYSTEM
-- ============= --
-- ============= --
-- RAPID FIRE SYSTEM (SPAM KEYBIND)
-- ============= --
local RapidFire = {
    Enabled = false,
    KeyBind = Enum.UserInputType.MouseButton1,
    Delay = 0,
    _holding = false,
    _fireLoop = nil,
    _inputBeganConn = nil,
    _inputEndedConn = nil,
}

function RapidFire:_IsMatch(input)
    if typeof(self.KeyBind) == "EnumItem" and self.KeyBind.EnumType == Enum.UserInputType then
        return input.UserInputType == self.KeyBind
    end
    if typeof(self.KeyBind) == "EnumItem" and self.KeyBind.EnumType == Enum.KeyCode then
        return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.KeyBind
    end
    return false
end

function RapidFire:_SimulateInput()
    -- SPAM KEYBIND ASLI, bukan tool:Activate()
    pcall(function()
        if typeof(self.KeyBind) == "EnumItem" and self.KeyBind.EnumType == Enum.UserInputType then
            -- Mouse button (klik kiri/kanan)
            if self.KeyBind == Enum.UserInputType.MouseButton1 then
                mouse1click() -- Fungsi exploit untuk spam klik kiri
            elseif self.KeyBind == Enum.UserInputType.MouseButton2 then
                mouse2click() -- Fungsi exploit untuk spam klik kanan
            end
        elseif typeof(self.KeyBind) == "EnumItem" and self.KeyBind.EnumType == Enum.KeyCode then
            -- Keyboard key (G, Q, E, dll)
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendKeyEvent(true, self.KeyBind, false, game)
            task.wait(0.01) -- Delay kecil biar kedetect
            VirtualInputManager:SendKeyEvent(false, self.KeyBind, false, game)
        end
    end)
end

function RapidFire:Start()
    self:Stop()
    self.Enabled = true

    self._inputBeganConn = Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if not self:_IsMatch(input) then return end
        if self._holding then return end
        
        self._holding = true

        self._fireLoop = task.spawn(function()
            while self._holding and self.Enabled do
                self:_SimulateInput() -- SPAM KEYBIND INI
                local d = self.Delay
                task.wait(d > 0 and d or 0.03)
            end
            self._fireLoop = nil
        end)
    end)

    self._inputEndedConn = Services.UserInputService.InputEnded:Connect(function(input)
        if not self:_IsMatch(input) then return end
        self._holding = false
        self._fireLoop = nil
    end)
end

function RapidFire:Stop()
    self.Enabled = false
    self._holding = false
    self._fireLoop = nil
    if self._inputBeganConn then
        self._inputBeganConn:Disconnect()
        self._inputBeganConn = nil
    end
    if self._inputEndedConn then
        self._inputEndedConn:Disconnect()
        self._inputEndedConn = nil
    end
end

function RapidFire:SetKeyBind(keyStr)
    local wasEnabled = self.Enabled
    if wasEnabled then self:Stop() end

    if keyStr == "MouseButton1" then
        self.KeyBind = Enum.UserInputType.MouseButton1
    elseif keyStr == "MouseButton2" then
        self.KeyBind = Enum.UserInputType.MouseButton2
    else
        local ok, kc = pcall(function() return Enum.KeyCode[keyStr] end)
        if ok and kc then
            self.KeyBind = kc
        else
            warn("RapidFire: Unknown keybind: " .. tostring(keyStr))
        end
    end

    if wasEnabled then self:Start() end
end

function RapidFire:Toggle(state)
    if state then
        self:Start()
    else
        self:Stop()
    end
end

-- ============= --
-- AIMBOT SYSTEM
-- ============= --
do
    local getrawmetatable=getrawmetatable; local pcall=pcall; local getgenv=getgenv
    local next=next; local tick=tick; local Vector2new=Vector2.new; local Vector3zero=Vector3.zero
    local CFramenew=CFrame.new; local Color3fromRGB=Color3.fromRGB; local Color3fromHSV=Color3.fromHSV
    local Drawingnew=Drawing.new; local TweenInfonew=TweenInfo.new
    local mousemoverel=mousemoverel or (Input and Input.MouseMove)
    local tablefind=table.find; local tableremove=table.remove
    local stringlower=string.lower; local stringsub=string.sub; local mathclamp=math.clamp
    local GameMetatable=getrawmetatable and getrawmetatable(game) or {}
    local __index=GameMetatable.__index; local __newindex=GameMetatable.__newindex
    local getrenderproperty=getrenderproperty or __index; local setrenderproperty=setrenderproperty or __newindex
    local GetService=__index(game,"GetService")
    local RunService=GetService(game,"RunService"); local UserInputService=GetService(game,"UserInputService")
    local TweenService=GetService(game,"TweenService"); local Players=GetService(game,"Players")
    local LocalPlayerAimbot=__index(Players,"LocalPlayer"); local Camera=__index(workspace,"CurrentCamera")
    local FindFirstChild=__index(game,"FindFirstChild"); local FindFirstChildOfClass=__index(game,"FindFirstChildOfClass")
    local GetDescendants=__index(game,"GetDescendants"); local WorldToViewportPoint=__index(Camera,"WorldToViewportPoint")
    local GetPartsObscuringTarget=__index(Camera,"GetPartsObscuringTarget")
    local GetMouseLocation=__index(UserInputService,"GetMouseLocation"); local GetPlayers=__index(Players,"GetPlayers")
    local RequiredDistance,Typing,Running,ServiceConnections,Animation,OriginalSensitivity=2000,false,false,{}
    local Connect=__index(game,"DescendantAdded").Connect

    local function AimbotHasForceField(plr)
        local ok, char = pcall(function() return __index(plr,"Character") end)
        if not ok or not char then return false end
        local ok2, ff = pcall(function() return FindFirstChildOfClass(char,"ForceField") end)
        return ok2 and ff ~= nil
    end

    if ExunysDeveloperAimbot and ExunysDeveloperAimbot.Exit then ExunysDeveloperAimbot:Exit() end
    getgenv().ExunysDeveloperAimbot = {
        DeveloperSettings = {UpdateMode="RenderStepped",TeamCheckOption="TeamColor",RainbowSpeed=1},
        Settings = {
            Enabled=false,TeamCheck=false,AliveCheck=true,WallCheck=false,
            OffsetToMoveDirection=false,OffsetIncrement=15,Sensitivity=0,Sensitivity2=3.5,
            LockMode=1,LockPart="Head",TriggerKey=Enum.UserInputType.MouseButton2,Toggle=false,
            MaxDistance=500,DistanceCheckEnabled=false,SmartTargeting=false,
            TeamWhitelistEnabled=false,TeamWhitelist={},TeamPriorityEnabled=false,TeamPriority={},
            HealthCheck=false,HealthCheckMin=0,
            PredictionEnabled=false,PredictionX=0,PredictionY=0,PredictionMode="None"
        },
        FOVSettings = {
            Enabled=false,Visible=false,Radius=90,NumSides=60,Thickness=1,Transparency=1,
            Filled=false,RainbowColor=false,RainbowOutlineColor=false,
            Color=Color3fromRGB(255,255,255),OutlineColor=Color3fromRGB(0,0,0),
            LockedColor=Color3fromRGB(255,150,150)
        },
        Blacklisted={},
        FOVCircleOutline=Drawingnew("Circle"),
        FOVCircle=Drawingnew("Circle")
    }
    local Env = getgenv().ExunysDeveloperAimbot

    setrenderproperty(Env.FOVCircle,"Visible",false)
    setrenderproperty(Env.FOVCircleOutline,"Visible",false)

    local FixUsername = function(S)
        local R
        for _,V in next,GetPlayers(Players) do
            local N=__index(V,"Name")
            if stringsub(stringlower(N),1,#S)==stringlower(S) then R=N end
        end
        return R
    end

    local GetRainbowColor = function() local s=Env.DeveloperSettings.RainbowSpeed; return Color3fromHSV(tick()%s/s,1,1) end
    local ConvertVector = function(V) return Vector2new(V.X,V.Y) end
    local CancelLock = function()
        Env.Locked=nil
        setrenderproperty(Env.FOVCircle,"Color",Env.FOVSettings.Color)
        __newindex(UserInputService,"MouseDeltaSensitivity",OriginalSensitivity)
        if Animation then Animation:Cancel() end
    end

    local function IsTeamWL(p)
        local S=Env.Settings; if not S.TeamWhitelistEnabled then return false end
        local tn=""; pcall(function() local t=__index(p,"Team"); if t then tn=__index(t,"Name") end end)
        if tn=="" then return false end
        for _,t in next,S.TeamWhitelist do if t==tn then return true end end
        return false
    end

    local function IsTeamPR(p)
        local S=Env.Settings; if not S.TeamPriorityEnabled then return false end
        local tn=""; pcall(function() local t=__index(p,"Team"); if t then tn=__index(t,"Name") end end)
        if tn=="" then return false end
        for _,t in next,S.TeamPriority do if t==tn then return true end end
        return false
    end

    local function GetPredictionOffset(targetChar)
        local S=Env.Settings
        if not S.PredictionEnabled then return Vector3zero end
        local mode=S.PredictionMode or "None"
        local px=S.PredictionX or 0; local py=S.PredictionY or 0
        if mode=="None" then return Vector3.new(px,py,0) end
        local hrp=targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp then return Vector3.new(px,py,0) end
        local hum=targetChar:FindFirstChildOfClass("Humanoid")
        if mode=="Velocity" then
            local vel=hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3zero
            return Vector3.new(vel.X*(px/10),vel.Y*(py/10),vel.Z*(px/10))
        elseif mode=="Position" then return Vector3.new(px*0.5,py*0.5,0)
        elseif mode=="Distance" then
            local lc=__index(LocalPlayerAimbot,"Character")
            local lhrp=lc and FindFirstChild(lc,"HumanoidRootPart")
            if lhrp then
                local dist=(__index(hrp,"Position")-__index(lhrp,"Position")).Magnitude
                local factor=mathclamp(dist/200,0.1,3)
                return Vector3.new(px*factor,py*factor,0)
            end
            return Vector3.new(px,py,0)
        elseif mode=="MoveDirection" then
            if hum then local md=__index(hum,"MoveDirection"); return md*(px/5)+Vector3.new(0,py*0.3,0) end
            return Vector3.new(px,py,0)
        end
        return Vector3.new(px,py,0)
    end

    local GetClosestPlayer = function()
        local S=Env.Settings; local LP=S.LockPart; local MD=S.MaxDistance or 500
        local ST=S.SmartTargeting; local DC=S.DistanceCheckEnabled
        local LC=__index(LocalPlayerAimbot,"Character"); local LH=LC and FindFirstChild(LC,"HumanoidRootPart")

        if not Env.Locked then
            if ST then
                local best=-1
                for _,V in next,GetPlayers(Players) do
                    local C=__index(V,"Character"); local H=C and FindFirstChildOfClass(C,"Humanoid")
                    if V~=LocalPlayerAimbot and not tablefind(Env.Blacklisted,__index(V,"Name")) and C and FindFirstChild(C,LP) and H then
                        if IsTeamWL(V) then continue end
                        if AimbotHasForceField(V) then continue end
                        local PP=__index(C[LP],"Position")
                        if DC and LH and (PP-__index(LH,"Position")).Magnitude>MD then continue end
                        if S.TeamCheck and __index(V,Env.DeveloperSettings.TeamCheckOption)==__index(LocalPlayerAimbot,Env.DeveloperSettings.TeamCheckOption) then continue end
                        local hp=__index(H,"Health"); local mhp=__index(H,"MaxHealth")
                        if S.AliveCheck and hp<=0 then continue end
                        if S.HealthCheck then local hpPct=(mhp>0) and (hp/mhp*10) or 10; if hpPct<S.HealthCheckMin then continue end end
                        if S.WallCheck then local BT=GetDescendants(LC); for _,v in next,GetDescendants(C) do BT[#BT+1]=v end; if #GetPartsObscuringTarget(Camera,{PP},BT)>0 then continue end end
                        local Vec,OS=WorldToViewportPoint(Camera,PP); if not OS then continue end
                        if Env.FOVSettings.Enabled and (GetMouseLocation(UserInputService)-ConvertVector(Vec)).Magnitude>Env.FOVSettings.Radius then continue end
                        local wd=LH and (PP-__index(LH,"Position")).Magnitude or 0; local rd=DC and MD or 2000
                        local ts=mathclamp(1-wd/rd,0,1)*0.5+(1-(mhp>0 and hp/mhp or 1))*0.5
                        if S.HealthCheck then local hpPct=(mhp>0) and (hp/mhp) or 1; ts=ts+(1-hpPct)*0.2 end
                        if IsTeamPR(V) then ts=ts+0.3 end
                        if ts>best then best=ts; Env.Locked=V end
                    end
                end
            else
                RequiredDistance=Env.FOVSettings.Enabled and Env.FOVSettings.Radius or 2000
                for _,V in next,GetPlayers(Players) do
                    local C=__index(V,"Character"); local H=C and FindFirstChildOfClass(C,"Humanoid")
                    if V~=LocalPlayerAimbot and not tablefind(Env.Blacklisted,__index(V,"Name")) and C and FindFirstChild(C,LP) and H then
                        if IsTeamWL(V) then continue end
                        if AimbotHasForceField(V) then continue end
                        local PP=__index(C[LP],"Position")
                        if DC and LH and (PP-__index(LH,"Position")).Magnitude>MD then continue end
                        if S.TeamCheck and __index(V,Env.DeveloperSettings.TeamCheckOption)==__index(LocalPlayerAimbot,Env.DeveloperSettings.TeamCheckOption) then continue end
                        local hp=__index(H,"Health"); local mhp=__index(H,"MaxHealth")
                        if S.AliveCheck and hp<=0 then continue end
                        if S.HealthCheck then local hpPct=(mhp>0) and (hp/mhp*10) or 10; if hpPct<S.HealthCheckMin then continue end end
                        if S.WallCheck then local BT=GetDescendants(LC); for _,v in next,GetDescendants(C) do BT[#BT+1]=v end; if #GetPartsObscuringTarget(Camera,{PP},BT)>0 then continue end end
                        local Vec,OS=WorldToViewportPoint(Camera,PP); Vec=ConvertVector(Vec)
                        local D=(GetMouseLocation(UserInputService)-Vec).Magnitude
                        if IsTeamPR(V) then D=D*0.5 end
                        if D<RequiredDistance and OS then RequiredDistance=D; Env.Locked=V end
                    end
                end
            end
        else
            local LC2=__index(Env.Locked,"Character"); if not LC2 then CancelLock() return end
            local LPI=FindFirstChild(LC2,LP); if not LPI then CancelLock() return end
            if AimbotHasForceField(Env.Locked) then CancelLock() return end
            if S.AliveCheck then local LHum=FindFirstChildOfClass(LC2,"Humanoid"); if not LHum or __index(LHum,"Health")<=0 then CancelLock() return end end
            if S.HealthCheck then
                local LHum=FindFirstChildOfClass(LC2,"Humanoid")
                if LHum then
                    local hp=__index(LHum,"Health"); local mhp=__index(LHum,"MaxHealth")
                    if (mhp>0) and (hp/mhp*10)<S.HealthCheckMin then CancelLock() return end
                end
            end
            if DC and LH and (__index(LPI,"Position")-__index(LH,"Position")).Magnitude>MD then CancelLock() return end
            if not ST and (GetMouseLocation(UserInputService)-ConvertVector(WorldToViewportPoint(Camera,__index(LPI,"Position")))).Magnitude>RequiredDistance then CancelLock() end
        end
    end

    local LoadAimbot = function()
        OriginalSensitivity=__index(UserInputService,"MouseDeltaSensitivity")
        local S,FC,FCO,FS=Env.Settings,Env.FOVCircle,Env.FOVCircleOutline,Env.FOVSettings

        local renderCB = function()
            if FS.Enabled and S.Enabled then
                for I,V in next,FS do
                    if I=="Color" then continue end
                    if pcall(getrenderproperty,FC,I) then setrenderproperty(FC,I,V); setrenderproperty(FCO,I,V) end
                end
                setrenderproperty(FC,"Color",(Env.Locked and FS.LockedColor) or (FS.RainbowColor and GetRainbowColor()) or FS.Color)
                setrenderproperty(FCO,"Color",FS.RainbowOutlineColor and GetRainbowColor() or FS.OutlineColor)
                setrenderproperty(FCO,"Thickness",FS.Thickness+1)
                setrenderproperty(FC,"Position",GetMouseLocation(UserInputService))
                setrenderproperty(FCO,"Position",GetMouseLocation(UserInputService))
            else
                setrenderproperty(FC,"Visible",false)
                setrenderproperty(FCO,"Visible",false)
            end

            if Running and S.Enabled then
                GetClosestPlayer()
                if Env.Locked then
                    local targetChar=__index(Env.Locked,"Character")
                    local predOffset=GetPredictionOffset(targetChar)
                    local Off=S.OffsetToMoveDirection
                        and __index(FindFirstChildOfClass(targetChar,"Humanoid"),"MoveDirection")*(mathclamp(S.OffsetIncrement,1,30)/10)
                        or Vector3zero
                    local LP3=__index(targetChar[S.LockPart],"Position")+predOffset
                    local LPV=WorldToViewportPoint(Camera,LP3+Off)
                    if S.LockMode==2 then
                        local jX=(math.random()-0.5)*0.3; local jY=(math.random()-0.5)*0.3
                        mousemoverel(
                            (LPV.X-GetMouseLocation(UserInputService).X)/S.Sensitivity2+jX,
                            (LPV.Y-GetMouseLocation(UserInputService).Y)/S.Sensitivity2+jY
                        )
                    else
                        if S.Sensitivity>0 then
                            Animation=TweenService:Create(Camera,TweenInfonew(S.Sensitivity,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{CFrame=CFramenew(Camera.CFrame.Position,LP3)})
                            Animation:Play()
                        else
                            __newindex(Camera,"CFrame",CFramenew(Camera.CFrame.Position,LP3+Off))
                        end
                        __newindex(UserInputService,"MouseDeltaSensitivity",0)
                    end
                    setrenderproperty(FC,"Color",FS.LockedColor)
                end
            end
        end
        ServiceConnections.RS=Connect(__index(RunService,Env.DeveloperSettings.UpdateMode), renderCB)

        local ibCB=function(Input)
            if Typing then return end
            if Input.UserInputType==Enum.UserInputType.Keyboard and Input.KeyCode==S.TriggerKey or Input.UserInputType==S.TriggerKey then
                if S.Toggle then Running=not Running; if not Running then CancelLock() end else Running=true end
            end
        end
        ServiceConnections.IB=Connect(__index(UserInputService,"InputBegan"), ibCB)

        local ieCB=function(Input)
            if S.Toggle or Typing then return end
            if Input.UserInputType==Enum.UserInputType.Keyboard and Input.KeyCode==S.TriggerKey or Input.UserInputType==S.TriggerKey then
                Running=false; CancelLock()
            end
        end
        ServiceConnections.IE=Connect(__index(UserInputService,"InputEnded"), ieCB)
    end

    local tsCB=function() Typing=true end; ServiceConnections.TS=Connect(__index(UserInputService,"TextBoxFocused"),tsCB)
    local teCB=function() Typing=false end; ServiceConnections.TE=Connect(__index(UserInputService,"TextBoxFocusReleased"),teCB)

    function Env.Exit(self)
        assert(self)
        Services.Players.LocalPlayer:Kick("Hexa.lua\nCleaning Complete!\n ")
        for I in next,ServiceConnections do pcall(function() ServiceConnections[I]:Disconnect() end) end
        self.FOVCircle:Remove(); self.FOVCircleOutline:Remove()
        getgenv().ExunysDeveloperAimbot=nil
    end
    function Env.Restart() for I in next,ServiceConnections do pcall(function() ServiceConnections[I]:Disconnect() end) end; LoadAimbot() end
    function Env.Blacklist(self,U) assert(self and U); U=FixUsername(U); assert(U); self.Blacklisted[#self.Blacklisted+1]=U end
    function Env.Whitelist(self,U) assert(self and U); U=FixUsername(U); assert(U); local I=tablefind(self.Blacklisted,U); assert(I); tableremove(self.Blacklisted,I) end
    function Env.GetClosestPlayer() GetClosestPlayer(); local V=Env.Locked; CancelLock(); return V end

    Env.Load=LoadAimbot; setmetatable(Env,{__call=LoadAimbot})
    Env.FOVSettings.Color=Color3fromRGB(255,50,50)
    Env.FOVSettings.LockedColor=Color3fromRGB(50,255,50)
end

local LocalPlayer = Services.Players.LocalPlayer
local SCRIPT_VERSION = "V.1.4.2"
local COSTUME_SCRIPT_VERSION = "V.1.0.0"

local function GetAimbotModule() return getgenv().ExunysDeveloperAimbot end

local AllBodyParts = {
    "Head","HumanoidRootPart","UpperTorso","LowerTorso","Torso",
    "LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand",
    "LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot",
    "Left Arm","Right Arm","Left Leg","Right Leg","Closest Part"
}

Features.Aimbot = {
    Module = ExunysDeveloperAimbot,
    Config = {Enabled=false,FOVCircle=false,TargetPart="Head",FOVSize=90,TriggerKey="MouseButton2",MaxDistance=500,DistanceCheckEnabled=false,SmartTargeting=false},
    Toggle = function(s) local M=GetAimbotModule(); Features.Aimbot.Config.Enabled=s; M.Settings.Enabled=s end,
    ToggleFOV = function(s) local M=GetAimbotModule(); Features.Aimbot.Config.FOVCircle=s; M.FOVSettings.Enabled=s; M.FOVSettings.Visible=s end,
    SetFOVSize = function(v) local M=GetAimbotModule(); Features.Aimbot.Config.FOVSize=v; M.FOVSettings.Radius=v end,
    SetTargetPart = function(p)
        local M=GetAimbotModule()
        if p=="Closest Part" then M.Settings.LockPart="HumanoidRootPart"; M.Settings._closestPartMode=true
        else M.Settings.LockPart=p; M.Settings._closestPartMode=false end
        Features.Aimbot.Config.TargetPart=p
    end,
    SetTriggerKey = function(k)
        local M=GetAimbotModule()
        local kc
        if k=="MouseButton1" then kc=Enum.UserInputType.MouseButton1
        elseif k=="MouseButton2" then kc=Enum.UserInputType.MouseButton2
        else local ok,v=pcall(function() return Enum.KeyCode[k] end); if ok then kc=v end end
        if kc then Features.Aimbot.Config.TriggerKey=k; M.Settings.TriggerKey=kc end
    end,
    SetMaxDistance = function(v) local M=GetAimbotModule(); Features.Aimbot.Config.MaxDistance=v; M.Settings.MaxDistance=v end,
    ToggleDistanceCheck = function(s) local M=GetAimbotModule(); Features.Aimbot.Config.DistanceCheckEnabled=s; M.Settings.DistanceCheckEnabled=s end,
    ToggleSmartTargeting = function(s) local M=GetAimbotModule(); Features.Aimbot.Config.SmartTargeting=s; M.Settings.SmartTargeting=s end,
}
pcall(function() Features.Aimbot.Module() end)

--================================
-- WORLD FEATURES
--================================
local WorldFeatures = {
    Lighting = { Enabled=false, OriginalValues={}, CurrentHour=14, LoopConnection=nil, NoFog=false }
}

function WorldFeatures.Lighting:SetTimeOfDay(hour)
    local L=Services.Lighting
    if not self.OriginalValues.ClockTime then
        self.OriginalValues.ClockTime=L.ClockTime; self.OriginalValues.Ambient=L.Ambient
        self.OriginalValues.OutdoorAmbient=L.OutdoorAmbient; self.OriginalValues.Brightness=L.Brightness
    end
    self.CurrentHour=hour; L.ClockTime=hour
end

function WorldFeatures.Lighting:StartLoop()
    if self.LoopConnection then self.LoopConnection:Disconnect() end
    self.Enabled=true
    self.LoopConnection=Services.RunService.Heartbeat:Connect(function()
        if self.Enabled then Services.Lighting.ClockTime=self.CurrentHour end
    end)
end

function WorldFeatures.Lighting:StopLoop()
    self.Enabled=false
    if self.LoopConnection then self.LoopConnection:Disconnect(); self.LoopConnection=nil end
    local L=Services.Lighting
    if self.OriginalValues.ClockTime then
        L.ClockTime=self.OriginalValues.ClockTime
        L.Ambient=self.OriginalValues.Ambient or Color3.fromRGB(128,128,128)
        L.OutdoorAmbient=self.OriginalValues.OutdoorAmbient or Color3.fromRGB(128,128,128)
        L.Brightness=self.OriginalValues.Brightness or 2
    end
end

function WorldFeatures.Lighting:ToggleNoFog(state)
    local L=Services.Lighting
    if not self.OriginalValues.FogEnd then self.OriginalValues.FogEnd=L.FogEnd; self.OriginalValues.FogStart=L.FogStart end
    self.NoFog=state
    if state then L.FogEnd=100000; L.FogStart=0
    else L.FogEnd=self.OriginalValues.FogEnd or 100000; L.FogStart=self.OriginalValues.FogStart or 0 end
end

function WorldFeatures.Lighting:Reset() self:StopLoop(); self:ToggleNoFog(false) end

--================================
-- SETTINGS SYSTEM
--================================
local SettingsManager = { FolderName="HexaLua_Settings", FileName="config.json", CurrentConfig={} }

function SettingsManager:Init()
    if makefolder and isfolder then
        if not isfolder(self.FolderName) then makefolder(self.FolderName) end
    end
end

function SettingsManager:Save()
    if not writefile then Utils.Alert("Settings","Save not supported!",5); return false end
    local config = {
        Version=SCRIPT_VERSION, Timestamp=os.time(),
        Aimbot={Enabled=Features.Aimbot.Config.Enabled,FOVCircle=Features.Aimbot.Config.FOVCircle,TargetPart=Features.Aimbot.Config.TargetPart,FOVSize=Features.Aimbot.Config.FOVSize,TriggerKey=Features.Aimbot.Config.TriggerKey,MaxDistance=Features.Aimbot.Config.MaxDistance,DistanceCheckEnabled=Features.Aimbot.Config.DistanceCheckEnabled,SmartTargeting=Features.Aimbot.Config.SmartTargeting},
        RapidFire={Enabled=RapidFire.Enabled,Delay=RapidFire.Delay},
        Movement={WalkSpeed={Enabled=Movement.WalkSpeed.Enabled,Value=Movement.WalkSpeed.Value,Method=Movement.WalkSpeed.Method},JumpPower={Enabled=Movement.JumpPower.Enabled,Value=Movement.JumpPower.Value,Method=Movement.JumpPower.Method},JumpHeight={Enabled=Movement.JumpHeight.Enabled,Value=Movement.JumpHeight.Value,Method=Movement.JumpHeight.Method},Speed={Enabled=Movement.Speed.Enabled,Value=Movement.Speed.Value,Method=Movement.Speed.Method}},
        ESP={Settings={}},
        World={Lighting={CurrentHour=WorldFeatures.Lighting.CurrentHour,NoFog=WorldFeatures.Lighting.NoFog,Enabled=WorldFeatures.Lighting.Enabled}}
    }
    if ESP and ESP.Settings then config.ESP.Settings=ESP.Settings end
    local ok, enc = pcall(function() return game:GetService("HttpService"):JSONEncode(config) end)
    if ok then
        writefile(self.FolderName.."/"..self.FileName, enc)
        Utils.Alert("Settings","Saved!",3); self.CurrentConfig=config; return true
    end
    Utils.Alert("Settings","Save failed!",5); return false
end

function SettingsManager:Load()
    if not readfile or not isfile then Utils.Alert("Settings","Load not supported!",5); return false end
    local path=self.FolderName.."/"..self.FileName
    if not isfile(path) then Utils.Alert("Settings","No config found!",5); return false end
    local ok, content = pcall(function() return readfile(path) end)
    if not ok then Utils.Alert("Settings","Load failed!",5); return false end
    local decoded; ok, decoded = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
    if not ok or not decoded then Utils.Alert("Settings","Invalid config!",5); return false end
    if decoded.Aimbot then pcall(function()
        Features.Aimbot.Toggle(decoded.Aimbot.Enabled or false)
        Features.Aimbot.ToggleFOV(decoded.Aimbot.FOVCircle or false)
        Features.Aimbot.SetTargetPart(decoded.Aimbot.TargetPart or "Head")
        Features.Aimbot.SetFOVSize(decoded.Aimbot.FOVSize or 90)
        Features.Aimbot.SetMaxDistance(decoded.Aimbot.MaxDistance or 500)
        Features.Aimbot.ToggleDistanceCheck(decoded.Aimbot.DistanceCheckEnabled or false)
        Features.Aimbot.ToggleSmartTargeting(decoded.Aimbot.SmartTargeting or false)
    end) end
    if decoded.RapidFire then pcall(function()
        RapidFire.Delay = decoded.RapidFire.Delay or 0
        RapidFire:Toggle(decoded.RapidFire.Enabled or false)
    end) end
    if decoded.Movement then pcall(function()
        if decoded.Movement.WalkSpeed then Movement.WalkSpeed.Value=decoded.Movement.WalkSpeed.Value or 16; Movement.WalkSpeed.Method=decoded.Movement.WalkSpeed.Method or "Instant"; Movement.WalkSpeed:Toggle(decoded.Movement.WalkSpeed.Enabled or false) end
        if decoded.Movement.JumpPower then Movement.JumpPower.Value=decoded.Movement.JumpPower.Value or 50; Movement.JumpPower.Method=decoded.Movement.JumpPower.Method or "Instant"; Movement.JumpPower:Toggle(decoded.Movement.JumpPower.Enabled or false) end
        if decoded.Movement.JumpHeight then Movement.JumpHeight.Value=decoded.Movement.JumpHeight.Value or 7.2; Movement.JumpHeight.Method=decoded.Movement.JumpHeight.Method or "Instant"; Movement.JumpHeight:Toggle(decoded.Movement.JumpHeight.Enabled or false) end
        if decoded.Movement.Speed then Movement.Speed.Value=decoded.Movement.Speed.Value or 1; Movement.Speed.Method=decoded.Movement.Speed.Method or "Smooth"; Movement.Speed:Toggle(decoded.Movement.Speed.Enabled or false) end
    end) end
    if decoded.World then pcall(function()
        if decoded.World.Lighting then
            if decoded.World.Lighting.Enabled then WorldFeatures.Lighting:SetTimeOfDay(decoded.World.Lighting.CurrentHour or 14); WorldFeatures.Lighting:StartLoop() end
            WorldFeatures.Lighting:ToggleNoFog(decoded.World.Lighting.NoFog or false)
        end
    end) end
    Utils.Alert("Settings","Loaded!",3); self.CurrentConfig=decoded; return true
end

function SettingsManager:Reset()
    local path=self.FolderName.."/"..self.FileName
    if isfile and isfile(path) and delfile then pcall(function() delfile(path) end) end
    pcall(function() Features.Aimbot.Toggle(false); Features.Aimbot.ToggleFOV(false) end)
    pcall(function() RapidFire:Toggle(false) end)
    pcall(function() Movement.WalkSpeed:Toggle(false); Movement.JumpPower:Toggle(false); Movement.JumpHeight:Toggle(false); Movement.Speed:Toggle(false) end)
    if ESP and ESP.CleanupAll then pcall(function() ESP.CleanupAll() end) end
    pcall(function() WorldFeatures.Lighting:Reset() end)
    Utils.Alert("Settings","Reset complete!",3); self.CurrentConfig={}
end

SettingsManager:Init()

--================================
-- ESP SYSTEM
--================================
local HealthText = {Enabled=false, Data={}}
local ESP = {
    Settings = {
        Color=Color3.fromRGB(255,0,0), RainbowEnabled=false, RainbowSpeed=0.2,
        TeamCheck=false, TeamColor=true, Thickness=2, AutoThickness=true,
        ArrowDistance=80, ArrowHeight=16, ArrowWidth=16, ArrowFilled=true,
        NameSize=14, EquipSize=12, HealthTextSize=14, HealthBarWidth=4,
        DistanceTextSize=12, CornerScale=1.0, TeamNameSize=12,
        ChamsFillTransparency=0.25, ChamsOutlineColor=Color3.new(1,1,1), ChamsOutlineTransparency=0,
        TracerOrigin="Bottom", TracerThickness=2, MaxDistance=500, DistanceCheckEnabled=false,
        HealthColorBase=false,
        BackgroundEnabled=false,
        BackgroundTransparency=0,
        TextColor=Color3.fromRGB(255,255,255),
        TextSize=14,
        ShowForceField=false,
        TeamWhitelistEnabled=false, TeamWhitelist={}, TeamPriorityEnabled=false, TeamPriority={},
        RefreshInterval=20,
        GradientEnabled=false, GradientColor1=Color3.fromRGB(255,0,0), GradientColor2=Color3.fromRGB(0,0,255),
        HeadDotRadius=3, HeadDotFilled=true,
    },
    _healthTrack={}, _refreshRunning=false
}

function ESP.GetColor(plr)
    if ESP.Settings.GradientEnabled then
        local t=(math.sin(tick()*2+(plr and plr.UserId or 0)*0.1)+1)/2
        return Utils.LerpColor(ESP.Settings.GradientColor1, ESP.Settings.GradientColor2, t)
    end
    if ESP.Settings.RainbowEnabled then return Color3.fromHSV(tick()*ESP.Settings.RainbowSpeed%1,0.6,1) end
    if ESP.Settings.TeamCheck then
        local ok,same=pcall(function() return plr.TeamColor==LocalPlayer.TeamColor end)
        if ok then return same and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0) end
    end
    if ESP.Settings.TeamColor then
        local ok,c=pcall(function() return plr.TeamColor.Color end); if ok then return c end
    end
    return ESP.Settings.Color
end

function ESP.GetChamsColor(plr, hum)
    if ESP.Settings.HealthColorBase and hum then return ESP.GetHealthColor(plr, hum) end
    if ESP.Settings.TeamColor then local ok,c=pcall(function() return plr.TeamColor.Color end); if ok then return c end end
    return ESP.GetColor(plr)
end

function ESP.GetThickness(pos)
    if not ESP.Settings.AutoThickness then return ESP.Settings.Thickness end
    local c=LocalPlayer.Character; if not c or not c:FindFirstChild("HumanoidRootPart") then return ESP.Settings.Thickness end
    return math.clamp(100/(c.HumanoidRootPart.Position-pos).Magnitude,1,4)
end

function ESP.IsWithinDistance(pos)
    if not ESP.Settings.DistanceCheckEnabled then return true end
    return Utils.GetWorldDistance(pos) <= ESP.Settings.MaxDistance
end

function ESP.IsTeamWhitelisted(plr)
    if not ESP.Settings.TeamWhitelistEnabled then return false end
    local tn=Utils.GetPlayerTeamName(plr); if tn=="" then return false end
    for _,t in ipairs(ESP.Settings.TeamWhitelist) do if t==tn then return true end end
    return false
end

function ESP.GetHealthColor(plr, hum)
    if not ESP._healthTrack[plr] then
        local ip=math.clamp(hum.Health/hum.MaxHealth,0,1)
        ESP._healthTrack[plr]={prevPct=ip, displayPct=ip, flashTime=0, lastTick=tick()}
    end
    local tr=ESP._healthTrack[plr]; local now=tick()
    if now-tr.lastTick>0.005 then
        local hp=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
        if tr.prevPct-hp>0.15 then tr.flashTime=now end
        tr.displayPct=tr.displayPct+(hp-tr.displayPct)*0.08
        tr.prevPct=hp; tr.lastTick=now
    end
    local bc=Color3.fromHSV(math.clamp(tr.displayPct*0.33,0,0.33),1,1)
    local el=now-tr.flashTime
    if el<0.5 then bc=bc:Lerp(Color3.new(1,1,1),math.clamp(1-el/0.5,0,1)*0.7) end
    return bc
end

function ESP.GetHealthDisplayPct(plr)
    local t=ESP._healthTrack[plr]; return t and t.displayPct or 1
end

function ESP.CommonCheck(plr, hrp)
    if not ESP.IsWithinDistance(hrp.Position) then return false end
    if ESP.IsTeamWhitelisted(plr) then return false end
    if not ESP.Settings.ShowForceField and Utils.HasForceField(plr) then return false end
    return true
end

local function CreateSegmentFrame(parent, layoutOrder)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = layoutOrder
    frame.AutomaticSize = Enum.AutomaticSize.X
    frame.Size = UDim2.new(0, 0, 1, -4)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.35, 0)
    corner.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35)),
    })
    gradient.Rotation = 90
    gradient.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 90)
    stroke.Thickness = 1
    stroke.Transparency = 0
    stroke.Parent = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)
    padding.PaddingTop = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 2)
    padding.Parent = frame

    frame.Parent = parent
    return frame, stroke, corner
end

local function CreateSegmentLabel(parent, textSize)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = textSize or 12
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = ""
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.RichText = false
    lbl.Parent = parent
    return lbl
end

local function BuildBillboard(plr)
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local Head = char and char:FindFirstChild("Head")
    if not hrp or not Head then return nil end

    local bb = Instance.new("BillboardGui")
    bb.Name = "HexaESP_BG"
    bb.MaxDistance = 2000000000
    bb.Size = UDim2.new(0, 220, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.Adornee = Head
    bb.Enabled = false

    local ok = pcall(function() bb.Parent = Services.CoreGui end)
    if not ok then bb.Parent = char end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainRow"
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.Parent = bb

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 3)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = mainFrame

    local healthFrame, healthStroke, healthCorner = CreateSegmentFrame(mainFrame, 0)
    local healthLabel = CreateSegmentLabel(healthFrame, 12)

    local nameFrame, nameStroke, nameCorner = CreateSegmentFrame(mainFrame, 1)
    local nameLabel = CreateSegmentLabel(nameFrame, 12)

    local distFrame, distStroke, distCorner = CreateSegmentFrame(mainFrame, 2)
    local distLabel = CreateSegmentLabel(distFrame, 11)

    local teamFrame, teamStroke, teamCorner = CreateSegmentFrame(mainFrame, 3)
    local teamLabel = CreateSegmentLabel(teamFrame, 11)

    local bbTool = Instance.new("BillboardGui")
    bbTool.Name = "HexaESP_Tool"
    bbTool.MaxDistance = 2000000000
    bbTool.Size = UDim2.new(0, 220, 0, 30)
    bbTool.StudsOffset = Vector3.new(0, -3.5, 0)
    bbTool.AlwaysOnTop = true
    bbTool.ResetOnSpawn = false
    bbTool.Adornee = hrp
    bbTool.Enabled = false
    local ok2 = pcall(function() bbTool.Parent = Services.CoreGui end)
    if not ok2 then bbTool.Parent = char end

    local toolFrame, toolStroke, toolCorner = CreateSegmentFrame(bbTool, 0)
    toolFrame.Size = UDim2.new(0.5, 0, 0.7, 0)
    toolFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
    toolFrame.AutomaticSize = Enum.AutomaticSize.None
    local toolLabel = CreateSegmentLabel(toolFrame, 11)
    toolLabel.Size = UDim2.new(1, 0, 1, 0)
    toolLabel.AutomaticSize = Enum.AutomaticSize.None

    return {
        billboard = bb,
        bbTool = bbTool,
        healthFrame = healthFrame, healthLabel = healthLabel, healthStroke = healthStroke, healthCorner = healthCorner,
        nameFrame   = nameFrame,   nameLabel   = nameLabel,   nameStroke   = nameStroke,   nameCorner   = nameCorner,
        distFrame   = distFrame,   distLabel   = distLabel,   distStroke   = distStroke,   distCorner   = distCorner,
        teamFrame   = teamFrame,   teamLabel   = teamLabel,   teamStroke   = teamStroke,   teamCorner   = teamCorner,
        toolFrame   = toolFrame,   toolLabel   = toolLabel,   toolStroke   = toolStroke,   toolCorner   = toolCorner,
    }
end

local function ApplyBillboardTransparency(bbData, transparency)
    local frames = {bbData.healthFrame, bbData.nameFrame, bbData.distFrame, bbData.teamFrame, bbData.toolFrame}
    for _, frame in ipairs(frames) do
        if frame then
            frame.BackgroundTransparency = transparency
            local stroke = frame:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Transparency = transparency end
        end
    end
end

local TextOverlay = { Data = {} }
local NameESP = {Enabled=false, Data={}}
local TeamNameESP = {Enabled=false, Data={}}
local DistanceESP = {Enabled=false, Data={}}
local EquipESP = {Enabled=false, Data={}}

function TextOverlay.Start(plr)
    if plr == LocalPlayer or TextOverlay.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) then return end
        if TextOverlay.Data[plr] then return end

        local bbData = BuildBillboard(plr)
        if not bbData then return end

        local conns = {}
        TextOverlay.Data[plr] = { bbData=bbData, conns=conns }

        local aimbotLockedColor = Color3.fromRGB(255, 80, 80)
        local aimbotNormalColor = Color3.fromRGB(80, 80, 90)

        conns.render = Services.RunService.RenderStepped:Connect(function()
            if not ESP.Settings.BackgroundEnabled then
                bbData.billboard.Enabled = false
                bbData.bbTool.Enabled = false
                return
            end

            local ok, char, hum, hrp, head = Utils.IsCharacterValid(plr)
            if not ok then
                bbData.billboard.Enabled = false
                bbData.bbTool.Enabled = false
                return
            end

            if not ESP.CommonCheck(plr, hrp) then
                bbData.billboard.Enabled = false
                bbData.bbTool.Enabled = false
                return
            end

            local bgTrans = math.clamp(ESP.Settings.BackgroundTransparency or 0, 0, 1)
            ApplyBillboardTransparency(bbData, bgTrans)

            local M = GetAimbotModule()
            local isLocked = M and M.Locked == plr

            local strokeColor = isLocked and aimbotLockedColor or aimbotNormalColor
            bbData.healthStroke.Color = strokeColor
            bbData.nameStroke.Color   = strokeColor
            bbData.distStroke.Color   = strokeColor
            bbData.teamStroke.Color   = strokeColor
            bbData.toolStroke.Color   = strokeColor

            bbData.healthStroke.Transparency = bgTrans
            bbData.nameStroke.Transparency   = bgTrans
            bbData.distStroke.Transparency   = bgTrans
            bbData.teamStroke.Transparency   = bgTrans
            bbData.toolStroke.Transparency   = bgTrans

            local curHRP = char:FindFirstChild("HumanoidRootPart")
            if curHRP and bbData.billboard.Adornee ~= curHRP then
                bbData.billboard.Adornee = curHRP
                bbData.bbTool.Adornee   = curHRP
            end

            local showHealth = HealthText.Enabled
            bbData.healthFrame.Visible = showHealth
            if showHealth then
                local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                local hpInt = math.floor(hum.Health)
                local hColor
                if ESP.Settings.HealthColorBase then
                    hColor = ESP.GetHealthColor(plr, hum)
                elseif ESP.Settings.TeamColor then
                    local tok, tc = pcall(function() return plr.TeamColor.Color end)
                    hColor = tok and tc or Color3.fromHSV(math.clamp(hpPct*0.33,0,0.33),1,1)
                else
                    hColor = Color3.fromHSV(math.clamp(hpPct*0.33,0,0.33),1,1)
                end
                bbData.healthLabel.Text = hpInt .. " ♥"
                bbData.healthLabel.TextColor3 = hColor
            end

            local showName = NameESP.Enabled
            bbData.nameFrame.Visible = showName
            if showName then
                local dn, un = plr.DisplayName, plr.Name
                local dname = (dn ~= un) and ("@"..un) or un
                bbData.nameLabel.Text = dname
                bbData.nameLabel.TextColor3 = isLocked and aimbotLockedColor or Color3.fromRGB(230, 230, 230)
            end

            local showDist = DistanceESP.Enabled
            bbData.distFrame.Visible = showDist
            if showDist then
                local dist = math.floor(Utils.GetWorldDistance(hrp.Position))
                bbData.distLabel.Text = dist .. "m"
                bbData.distLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            end

            local showTeam = TeamNameESP.Enabled
            bbData.teamFrame.Visible = showTeam
            if showTeam then
                local tn = Utils.GetPlayerTeamName(plr)
                if tn ~= "" then
                    bbData.teamLabel.Text = tn
                    local tok, tc = pcall(function() return plr.TeamColor.Color end)
                    bbData.teamLabel.TextColor3 = tok and tc or Color3.fromRGB(200,200,200)
                    bbData.teamFrame.Visible = true
                else
                    bbData.teamFrame.Visible = false
                end
            end

            local showTool = EquipESP.Enabled
            if showTool then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    bbData.toolLabel.Text = tool.Name
                    bbData.toolLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
                    bbData.bbTool.Enabled = true
                else
                    bbData.bbTool.Enabled = false
                end
            else
                bbData.bbTool.Enabled = false
            end

            local anyVisible = (showHealth or showName or showDist or showTeam)
            bbData.billboard.Enabled = anyVisible
        end)
    end)
end

function TextOverlay.Stop(plr)
    local d = TextOverlay.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns)
    pcall(function() d.bbData.billboard:Destroy() end)
    pcall(function() d.bbData.bbTool:Destroy() end)
    TextOverlay.Data[plr] = nil
end

local R15Bones = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
}
local R6Bones = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}
}

local function GetBoundingBox2D(head, hrp, cam)
    local topY=head.Position.Y+head.Size.Y/2+0.3; local botY=hrp.Position.Y-3
    local cx,cz=hrp.Position.X,hrp.Position.Z; local hw,hd=2.5,1.5
    local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge; local count=0
    for _,xm in ipairs({-1,1}) do for _,y in ipairs({topY,botY}) do for _,zm in ipairs({-1,1}) do
        local sp=cam:WorldToViewportPoint(Vector3.new(cx+hw*xm,y,cz+hd*zm))
        if sp.Z>0 then
            if sp.X<minX then minX=sp.X end; if sp.X>maxX then maxX=sp.X end
            if sp.Y<minY then minY=sp.Y end; if sp.Y>maxY then maxY=sp.Y end
            count=count+1
        end
    end end end
    if count<4 then return nil end
    local p=3; return {minX=minX-p, minY=minY-p, maxX=maxX+p, maxY=maxY+p}
end

local Corner = {Enabled=false, Data={}}
function Corner.Start(plr)
    if plr==LocalPlayer or Corner.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not Corner.Enabled then return end
        if Corner.Data[plr] then return end
        local dr={}
        for _,n in ipairs({"TL1","TL2","TR1","TR2","BL1","BL2","BR1","BR2"}) do
            dr[n]=Utils.NewLine(Color3.new(1,1,1),2)
        end
        Corner.Data[plr]={drawings=dr, conns={}}
        Corner.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not Corner.Enabled then Utils.SetVisible(dr,false); return end
            local cam=workspace.CurrentCamera
            local ok,_,hum,hrp,head=Utils.IsCharacterValid(plr)
            if not ok then Utils.SetVisible(dr,false); return end
            if not ESP.CommonCheck(plr,hrp) then Utils.SetVisible(dr,false); return end
            local _,vis=cam:WorldToViewportPoint(hrp.Position)
            if not vis or (cam.CFrame.Position-hrp.Position).Magnitude<2 then Utils.SetVisible(dr,false); return end
            local box=GetBoundingBox2D(head,hrp,cam); if not box then Utils.SetVisible(dr,false); return end
            local color=ESP.GetColor(plr); local thick=ESP.GetThickness(hrp.Position)
            local scale=ESP.Settings.CornerScale
            local cLen=math.max(math.min(box.maxX-box.minX,box.maxY-box.minY)*0.2*scale,2)
            local tlX,tlY,trX,blY=box.minX,box.minY,box.maxX,box.maxY
            dr.TL1.From=Vector2.new(tlX,tlY); dr.TL1.To=Vector2.new(tlX+cLen,tlY)
            dr.TL2.From=Vector2.new(tlX,tlY); dr.TL2.To=Vector2.new(tlX,tlY+cLen)
            dr.TR1.From=Vector2.new(trX,tlY); dr.TR1.To=Vector2.new(trX-cLen,tlY)
            dr.TR2.From=Vector2.new(trX,tlY); dr.TR2.To=Vector2.new(trX,tlY+cLen)
            dr.BL1.From=Vector2.new(tlX,blY); dr.BL1.To=Vector2.new(tlX+cLen,blY)
            dr.BL2.From=Vector2.new(tlX,blY); dr.BL2.To=Vector2.new(tlX,blY-cLen)
            dr.BR1.From=Vector2.new(trX,blY); dr.BR1.To=Vector2.new(trX-cLen,blY)
            dr.BR2.From=Vector2.new(trX,blY); dr.BR2.To=Vector2.new(trX,blY-cLen)
            for _,d in pairs(dr) do d.Color=color; d.Thickness=thick; d.Visible=true end
        end)
    end)
end
function Corner.Stop(plr)
    local d=Corner.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); Corner.Data[plr]=nil
end

local Skeleton = {Enabled=false, Data={}}
function Skeleton.Start(plr)
    if plr==LocalPlayer or Skeleton.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not Skeleton.Enabled then return end
        if Skeleton.Data[plr] then return end
        local char=plr.Character
        local hum=char:FindFirstChild("Humanoid"); if not hum then return end
        local bones=(hum.RigType==Enum.HumanoidRigType.R15) and R15Bones or R6Bones
        local dr={}; for i=1,#bones do dr[i]=Utils.NewLine(ESP.Settings.Color,2) end
        local data={drawings=dr, conns={}, bones=bones}; Skeleton.Data[plr]=data
        data.conns.render=Services.RunService.RenderStepped:Connect(function()
            if not Skeleton.Enabled then Utils.SetVisible(dr,false); return end
            local cam=workspace.CurrentCamera
            local ok,c2,_,hrp=Utils.IsCharacterValid(plr)
            if not ok then Utils.SetVisible(dr,false); return end
            if not ESP.CommonCheck(plr,hrp) then Utils.SetVisible(dr,false); return end
            local _,vis=cam:WorldToViewportPoint(hrp.Position); if not vis then Utils.SetVisible(dr,false); return end
            local color=ESP.GetColor(plr); local thick=ESP.GetThickness(hrp.Position)
            for i,bone in ipairs(data.bones) do
                local a,b=c2:FindFirstChild(bone[1]),c2:FindFirstChild(bone[2])
                if a and b then
                    local pa=cam:WorldToViewportPoint(a.Position); local pb=cam:WorldToViewportPoint(b.Position)
                    dr[i].From=Vector2.new(pa.X,pa.Y); dr[i].To=Vector2.new(pb.X,pb.Y)
                    dr[i].Color=color; dr[i].Thickness=thick; dr[i].Visible=true
                else dr[i].Visible=false end
            end
        end)
    end)
end
function Skeleton.Stop(plr)
    local d=Skeleton.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); Skeleton.Data[plr]=nil
end

local Arrow = {Enabled=false, Data={}}
local function getRelative(pos,char)
    if not char or not char.PrimaryPart then return Vector2.new(0,0) end
    local rp=char.PrimaryPart.Position; local cp=workspace.CurrentCamera.CFrame.Position
    local rel=CFrame.new(Vector3.new(rp.X,cp.Y,rp.Z),cp):PointToObjectSpace(pos)
    return Vector2.new(rel.X,rel.Z)
end
local function relToCenter(v) return workspace.CurrentCamera.ViewportSize/2-v end
local function rotV2(v,a)
    local r=math.rad(a)
    return Vector2.new(v.X*math.cos(r)-v.Y*math.sin(r), v.X*math.sin(r)+v.Y*math.cos(r))
end
function Arrow.Start(plr)
    if plr==LocalPlayer or Arrow.Data[plr] then return end
    local tri=Drawing.new("Triangle"); tri.Visible=false; tri.Filled=ESP.Settings.ArrowFilled; tri.Thickness=1; tri.Transparency=1
    Arrow.Data[plr]={drawing=tri, conns={}}
    Arrow.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
        if not Arrow.Enabled then tri.Visible=false; return end
        local lc=LocalPlayer.Character
        if not plr or not plr.Parent or not plr.Character or not plr.Character.PrimaryPart or not lc or not lc.PrimaryPart then tri.Visible=false; return end
        local ch=plr.Character; local hum=ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then tri.Visible=false; return end
        if not ESP.CommonCheck(plr,ch.PrimaryPart) then tri.Visible=false; return end
        local _,vis=workspace.CurrentCamera:WorldToViewportPoint(ch.PrimaryPart.Position)
        if vis then tri.Visible=false; return end
        local s=ESP.Settings
        local rel=getRelative(ch.PrimaryPart.Position,lc); local dir=rel.Unit
        local base=dir*s.ArrowDistance; local side=s.ArrowWidth/2
        tri.PointA=relToCenter(base+rotV2(dir,90)*side)
        tri.PointB=relToCenter(base+rotV2(dir,-90)*side)
        tri.PointC=relToCenter(dir*(s.ArrowDistance+s.ArrowHeight))
        tri.Color=ESP.GetColor(plr); tri.Visible=true
    end)
end
function Arrow.Stop(plr)
    local d=Arrow.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); if d.drawing then d.drawing:Remove() end; Arrow.Data[plr]=nil
end

function NameESP.Start(plr)
    if plr==LocalPlayer or NameESP.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not NameESP.Enabled then return end
        if NameESP.Data[plr] then return end
        local nt=Utils.NewText(Color3.new(1,1,1),14,true,true)
        NameESP.Data[plr]={drawings={nt}, conns={}}
        NameESP.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not NameESP.Enabled or ESP.Settings.BackgroundEnabled then nt.Visible=false; return end
            local cam=workspace.CurrentCamera
            local ok,_,_,hrp,head=Utils.IsCharacterValid(plr)
            if not ok then nt.Visible=false; return end
            if not ESP.CommonCheck(plr,hrp) then nt.Visible=false; return end
            local sp,vis=cam:WorldToViewportPoint(head.Position+Vector3.new(0,1.5,0))
            if not vis then nt.Visible=false; return end
            local dn,un=plr.DisplayName,plr.Name
            nt.Text=(dn~=un) and (dn.." (@"..un..")") or un
            nt.Size=ESP.Settings.NameSize; nt.Color=ESP.GetColor(plr)
            nt.Position=Vector2.new(sp.X,sp.Y); nt.Visible=true
        end)
    end)
end
function NameESP.Stop(plr)
    local d=NameESP.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); NameESP.Data[plr]=nil
end

function TeamNameESP.Start(plr)
    if plr==LocalPlayer or TeamNameESP.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not TeamNameESP.Enabled then return end
        if TeamNameESP.Data[plr] then return end
        local tt=Utils.NewText(Color3.new(1,1,1),12,true,true)
        TeamNameESP.Data[plr]={drawings={tt}, conns={}}
        TeamNameESP.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not TeamNameESP.Enabled or ESP.Settings.BackgroundEnabled then tt.Visible=false; return end
            local cam=workspace.CurrentCamera
            local ok,_,_,hrp,head=Utils.IsCharacterValid(plr)
            if not ok then tt.Visible=false; return end
            if not ESP.CommonCheck(plr,hrp) then tt.Visible=false; return end
            local tn=Utils.GetPlayerTeamName(plr); if tn=="" then tt.Visible=false; return end
            local sp,vis=cam:WorldToViewportPoint(head.Position+Vector3.new(0,2.5,0))
            if not vis then tt.Visible=false; return end
            tt.Text="["..tn.."]"; tt.Size=ESP.Settings.TeamNameSize; tt.Color=ESP.GetColor(plr)
            tt.Position=Vector2.new(sp.X,sp.Y); tt.Visible=true
        end)
    end)
end
function TeamNameESP.Stop(plr)
    local d=TeamNameESP.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); TeamNameESP.Data[plr]=nil
end

function EquipESP.Start(plr)
    if plr==LocalPlayer or EquipESP.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not EquipESP.Enabled then return end
        if EquipESP.Data[plr] then return end
        local et=Utils.NewText(Color3.new(1,1,1),12,true,true)
        EquipESP.Data[plr]={drawings={et}, conns={}}
        EquipESP.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not EquipESP.Enabled or ESP.Settings.BackgroundEnabled then et.Visible=false; return end
            local cam=workspace.CurrentCamera
            local ok,char,_,hrp,head=Utils.IsCharacterValid(plr)
            if not ok then et.Visible=false; return end
            if not ESP.CommonCheck(plr,hrp) then et.Visible=false; return end
            local sp,vis=cam:WorldToViewportPoint(head.Position+Vector3.new(0,0.5,0))
            if not vis then et.Visible=false; return end
            local tool=char:FindFirstChildOfClass("Tool"); if not tool then et.Visible=false; return end
            et.Text="["..tool.Name.."]"; et.Size=ESP.Settings.EquipSize; et.Color=ESP.GetColor(plr)
            et.Position=Vector2.new(sp.X,sp.Y); et.Visible=true
        end)
    end)
end
function EquipESP.Stop(plr)
    local d=EquipESP.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); EquipESP.Data[plr]=nil
end

function HealthText.Start(plr)
    if plr==LocalPlayer or HealthText.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not HealthText.Enabled then return end
        if HealthText.Data[plr] then return end
        local ht=Utils.NewText(Color3.new(1,1,1),14,true,true)
        HealthText.Data[plr]={drawings={ht}, conns={}}
        HealthText.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not HealthText.Enabled or ESP.Settings.BackgroundEnabled then ht.Visible=false; return end
            local cam=workspace.CurrentCamera
            local ok,_,hum,hrp,head=Utils.IsCharacterValid(plr)
            if not ok then ht.Visible=false; return end
            if not ESP.CommonCheck(plr,hrp) then ht.Visible=false; return end
            local sp,vis=cam:WorldToViewportPoint(head.Position+Vector3.new(0,3.5,0))
            if not vis then ht.Visible=false; return end
            ht.Text=math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).." HP"
            ht.Size=ESP.Settings.HealthTextSize; ht.Color=ESP.GetHealthColor(plr,hum)
            ht.Position=Vector2.new(sp.X,sp.Y); ht.Visible=true
        end)
    end)
end
function HealthText.Stop(plr)
    local d=HealthText.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); HealthText.Data[plr]=nil
end

local HealthBar = {Enabled=false, Data={}}
function HealthBar.Start(plr)
    if plr==LocalPlayer or HealthBar.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not HealthBar.Enabled then return end
        if HealthBar.Data[plr] then return end
        local bg=Utils.NewSquare(Color3.fromRGB(30,30,30),true,1)
        local fg=Utils.NewSquare(Color3.fromRGB(0,255,0),true,1)
        local ol=Utils.NewSquare(Color3.fromRGB(0,0,0),false,1)
        if not bg or not fg then return end
        local drawings={bg,fg}; if ol then drawings[3]=ol end
        HealthBar.Data[plr]={drawings=drawings, conns={}}
        HealthBar.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not HealthBar.Enabled then Utils.SetVisible(drawings,false); return end
            local cam=workspace.CurrentCamera
            local ok,_,hum,hrp,head=Utils.IsCharacterValid(plr)
            if not ok then Utils.SetVisible(drawings,false); return end
            if not ESP.CommonCheck(plr,hrp) then Utils.SetVisible(drawings,false); return end
            local _,vis=cam:WorldToViewportPoint(hrp.Position)
            if not vis or (cam.CFrame.Position-hrp.Position).Magnitude<2 then Utils.SetVisible(drawings,false); return end
            local box=GetBoundingBox2D(head,hrp,cam); if not box then Utils.SetVisible(drawings,false); return end
            local dp=ESP.GetHealthDisplayPct(plr); ESP.GetHealthColor(plr,hum)
            local bw=ESP.Settings.HealthBarWidth; local bx=box.minX-bw-3
            local bt=box.minY; local bh=math.max(box.maxY-box.minY,4)
            local fh=bh*dp; local fy=bt+(bh-fh); local bc=ESP.GetHealthColor(plr,hum)
            bg.Position=Vector2.new(bx,bt); bg.Size=Vector2.new(bw,bh); bg.Color=Color3.fromRGB(30,30,30); bg.Filled=true; bg.Visible=true
            fg.Position=Vector2.new(bx,fy); fg.Size=Vector2.new(bw,math.max(fh,1)); fg.Color=bc; fg.Filled=true; fg.Visible=true
            if ol then ol.Position=Vector2.new(bx-1,bt-1); ol.Size=Vector2.new(bw+2,bh+2); ol.Color=Color3.fromRGB(0,0,0); ol.Filled=false; ol.Thickness=1; ol.Visible=true end
        end)
    end)
end
function HealthBar.Stop(plr)
    local d=HealthBar.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); HealthBar.Data[plr]=nil
end

function DistanceESP.Start(plr)
    if plr==LocalPlayer or DistanceESP.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not DistanceESP.Enabled then return end
        if DistanceESP.Data[plr] then return end
        local dt=Utils.NewText(Color3.new(1,1,1),12,true,true)
        DistanceESP.Data[plr]={drawings={dt}, conns={}}
        DistanceESP.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not DistanceESP.Enabled or ESP.Settings.BackgroundEnabled then dt.Visible=false; return end
            local cam=workspace.CurrentCamera
            local ok,_,_,hrp=Utils.IsCharacterValid(plr)
            if not ok then dt.Visible=false; return end
            if not ESP.CommonCheck(plr,hrp) then dt.Visible=false; return end
            local sp,vis=cam:WorldToViewportPoint(hrp.Position-Vector3.new(0,3.5,0))
            if not vis then dt.Visible=false; return end
            dt.Text="["..math.floor(Utils.GetWorldDistance(hrp.Position)).."m]"
            dt.Size=ESP.Settings.DistanceTextSize; dt.Color=ESP.GetColor(plr)
            dt.Position=Vector2.new(sp.X,sp.Y); dt.Visible=true
        end)
    end)
end
function DistanceESP.Stop(plr)
    local d=DistanceESP.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); DistanceESP.Data[plr]=nil
end

local Chams = {Enabled=false, Data={}}
function Chams.Start(plr)
    if plr==LocalPlayer or Chams.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not Chams.Enabled then return end
        if Chams.Data[plr] then return end
        local hl=Instance.new("Highlight")
        hl.Name=Utils.RandomName()
        hl.FillTransparency=ESP.Settings.ChamsFillTransparency
        hl.OutlineTransparency=ESP.Settings.ChamsOutlineTransparency
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee=plr.Character; hl.Enabled=true
        local ok=pcall(function() hl.Parent=Services.CoreGui end)
        if not ok then hl.Parent=plr.Character end
        Chams.Data[plr]={highlight=hl, conns={}}
        Chams.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not Chams.Enabled then hl.Enabled=false; return end
            if plr.Character and hl.Adornee~=plr.Character then hl.Adornee=plr.Character end
            local ok2,_,hum,hrp=Utils.IsCharacterValid(plr)
            if not ok2 then hl.Enabled=false; return end
            if not ESP.CommonCheck(plr,hrp) then hl.Enabled=false; return end
            local color=ESP.GetChamsColor(plr,hum)
            hl.FillColor=color
            hl.OutlineColor=color
            hl.FillTransparency=ESP.Settings.ChamsFillTransparency
            hl.OutlineTransparency=ESP.Settings.ChamsOutlineTransparency
            hl.Enabled=true
        end)
    end)
end
function Chams.Stop(plr)
    local d=Chams.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); pcall(function() d.highlight:Destroy() end); Chams.Data[plr]=nil
end

local Tracer = {Enabled=false, Data={}}
function Tracer.GetOrigin()
    local vs=workspace.CurrentCamera.ViewportSize
    return ({Bottom=Vector2.new(vs.X/2,vs.Y),Center=Vector2.new(vs.X/2,vs.Y/2),Top=Vector2.new(vs.X/2,0)})[ESP.Settings.TracerOrigin] or Vector2.new(vs.X/2,vs.Y)
end
function Tracer.Start(plr)
    if plr==LocalPlayer or Tracer.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not Tracer.Enabled then return end
        if Tracer.Data[plr] then return end
        local line=Utils.NewLine(ESP.Settings.Color,2)
        Tracer.Data[plr]={drawings={line}, conns={}}
        Tracer.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not Tracer.Enabled then line.Visible=false; return end
            local cam=workspace.CurrentCamera
            local ok,_,_,hrp=Utils.IsCharacterValid(plr)
            if not ok then line.Visible=false; return end
            if not ESP.CommonCheck(plr,hrp) then line.Visible=false; return end
            local footPos=hrp.Position-Vector3.new(0,hrp.Size.Y/2+1,0)
            local sp,vis=cam:WorldToViewportPoint(footPos)
            if not vis then line.Visible=false; return end
            line.From=Tracer.GetOrigin(); line.To=Vector2.new(sp.X,sp.Y)
            line.Color=ESP.GetColor(plr); line.Thickness=ESP.Settings.TracerThickness; line.Visible=true
        end)
    end)
end
function Tracer.Stop(plr)
    local d=Tracer.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); Tracer.Data[plr]=nil
end

local HeadDot = {Enabled=false, Data={}}
function HeadDot.Start(plr)
    if plr==LocalPlayer or HeadDot.Data[plr] then return end
    task.spawn(function()
        if not Utils.WaitForCharacter(plr) or not HeadDot.Enabled then return end
        if HeadDot.Data[plr] then return end
        local circle=Utils.NewCircle(ESP.Settings.Color,ESP.Settings.HeadDotFilled,1)
        if not circle then return end
        HeadDot.Data[plr]={drawings={circle}, conns={}}
        HeadDot.Data[plr].conns.render=Services.RunService.RenderStepped:Connect(function()
            if not HeadDot.Enabled then circle.Visible=false; return end
            local cam=workspace.CurrentCamera
            local ok,_,_,hrp,head=Utils.IsCharacterValid(plr)
            if not ok then circle.Visible=false; return end
            if not ESP.CommonCheck(plr,hrp) then circle.Visible=false; return end
            local sp,vis=cam:WorldToViewportPoint(head.Position)
            if not vis then circle.Visible=false; return end
            local dist=(cam.CFrame.Position-head.Position).Magnitude
            circle.Position=Vector2.new(sp.X,sp.Y)
            circle.Radius=math.clamp(ESP.Settings.HeadDotRadius*(100/dist),1,20)
            circle.Color=ESP.GetColor(plr)
            circle.Filled=ESP.Settings.HeadDotFilled
            circle.Visible=true
        end)
    end)
end
function HeadDot.Stop(plr)
    local d=HeadDot.Data[plr]; if not d then return end
    Utils.DisconnectAll(d.conns); Utils.RemoveDrawings(d.drawings); HeadDot.Data[plr]=nil
end

ESP.Corner=Corner; ESP.Skeleton=Skeleton; ESP.Arrow=Arrow
ESP.NameESP=NameESP; ESP.TeamNameESP=TeamNameESP; ESP.EquipESP=EquipESP
ESP.HealthText=HealthText; ESP.HealthBar=HealthBar; ESP.DistanceESP=DistanceESP
ESP.Chams=Chams; ESP.Tracer=Tracer; ESP.TextOverlay=TextOverlay; ESP.HeadDot=HeadDot
ESP.AllModules = {Corner,Skeleton,Arrow,NameESP,TeamNameESP,EquipESP,HealthText,HealthBar,DistanceESP,Chams,Tracer,HeadDot}
ESP._connections={}; ESP._playerCharConns={}

function ESP.SetupPlayer(plr)
    if plr==LocalPlayer then return end
    for _,mod in ipairs(ESP.AllModules) do
        if mod.Enabled and not mod.Data[plr] then mod.Start(plr) end
    end
    if not TextOverlay.Data[plr] then TextOverlay.Start(plr) end
    if not ESP._playerCharConns[plr] then
        ESP._playerCharConns[plr]=plr.CharacterAdded:Connect(function()
            ESP._healthTrack[plr]=nil
            task.spawn(function()
                task.wait(0.3)
                for _,mod in ipairs(ESP.AllModules) do if mod.Data[plr] then mod.Stop(plr) end end
                TextOverlay.Stop(plr)
                if not Utils.WaitForCharacter(plr,10) then return end
                if not plr or not plr.Parent then return end
                task.wait(0.5)
                if not plr or not plr.Parent then return end
                for _,mod in ipairs(ESP.AllModules) do if mod.Enabled and not mod.Data[plr] then mod.Start(plr) end end
                if not TextOverlay.Data[plr] then TextOverlay.Start(plr) end
            end)
        end)
    end
end

function ESP.CleanupPlayer(plr)
    if ESP._playerCharConns[plr] then
        if ESP._playerCharConns[plr].Connected then ESP._playerCharConns[plr]:Disconnect() end
        ESP._playerCharConns[plr]=nil
    end
    ESP._healthTrack[plr]=nil
    for _,mod in ipairs(ESP.AllModules) do if mod.Data[plr] then mod.Stop(plr) end end
    TextOverlay.Stop(plr)
end

function ESP.StartRefreshLoop()
    if ESP._refreshRunning then return end
    ESP._refreshRunning=true
    task.spawn(function()
        while ESP._refreshRunning do
            task.wait(ESP.Settings.RefreshInterval)
            if not ESP._refreshRunning then break end
            local anyOn=false
            for _,mod in ipairs(ESP.AllModules) do if mod.Enabled then anyOn=true; break end end
            if ESP.Settings.BackgroundEnabled then anyOn=true end
            if not anyOn then continue end
            for _,plr in ipairs(Services.Players:GetPlayers()) do
                if plr==LocalPlayer or not plr or not plr.Parent then continue end
                if not ESP._playerCharConns[plr] then ESP.SetupPlayer(plr) end
                for _,mod in ipairs(ESP.AllModules) do
                    if mod.Enabled and not mod.Data[plr] and Utils.IsCharacterValid(plr) then mod.Start(plr) end
                    if mod.Enabled and mod.Data[plr] and mod.Data[plr].conns and mod.Data[plr].conns.render
                        and not mod.Data[plr].conns.render.Connected then
                        mod.Stop(plr); if Utils.IsCharacterValid(plr) then mod.Start(plr) end
                    end
                end
                if not TextOverlay.Data[plr] and Utils.IsCharacterValid(plr) then TextOverlay.Start(plr) end
            end
            local rm={}
            for _,mod in ipairs(ESP.AllModules) do
                for plr in pairs(mod.Data) do if not plr or not plr.Parent then rm[#rm+1]=plr end end
                for _,p in ipairs(rm) do mod.Stop(p) end
                rm={}
            end
            local toRm={}
            for plr in pairs(TextOverlay.Data) do if not plr or not plr.Parent then toRm[#toRm+1]=plr end end
            for _,p in ipairs(toRm) do TextOverlay.Stop(p) end
        end
    end)
end

function ESP.StopRefreshLoop() ESP._refreshRunning=false end

function ESP.Init()
    for _,conn in ipairs(ESP._connections) do if conn.Connected then conn:Disconnect() end end
    ESP._connections={}
    for plr,conn in pairs(ESP._playerCharConns) do if conn and conn.Connected then conn:Disconnect() end end
    ESP._playerCharConns={}
    ESP.StopRefreshLoop()
    table.insert(ESP._connections, Services.Players.PlayerAdded:Connect(function(plr) ESP.SetupPlayer(plr) end))
    table.insert(ESP._connections, Services.Players.PlayerRemoving:Connect(function(plr) ESP.CleanupPlayer(plr) end))
    for _,plr in ipairs(Services.Players:GetPlayers()) do ESP.SetupPlayer(plr) end
    ESP.StartRefreshLoop()
end

local function makeToggleAutoUpdate(mod)
    return function(state)
        mod.Enabled=state
        if state then
            for _,plr in ipairs(Services.Players:GetPlayers()) do
                if plr~=LocalPlayer and not mod.Data[plr] then mod.Start(plr) end
            end
        else
            local keys={}; for plr in pairs(mod.Data) do keys[#keys+1]=plr end
            for _,plr in ipairs(keys) do mod.Stop(plr) end
        end
    end
end
for _,mod in ipairs(ESP.AllModules) do mod.Toggle=makeToggleAutoUpdate(mod) end

function ESP.CleanupAll()
    ESP.StopRefreshLoop()
    for _,conn in ipairs(ESP._connections) do if conn.Connected then conn:Disconnect() end end
    ESP._connections={}
    for plr,conn in pairs(ESP._playerCharConns) do if conn and conn.Connected then conn:Disconnect() end end
    ESP._playerCharConns={}; ESP._healthTrack={}
    for _,mod in ipairs(ESP.AllModules) do
        mod.Enabled=false
        local keys={}; for plr in pairs(mod.Data) do keys[#keys+1]=plr end
        for _,plr in ipairs(keys) do mod.Stop(plr) end
    end
    local toKeys={}; for plr in pairs(TextOverlay.Data) do toKeys[#toKeys+1]=plr end
    for _,plr in ipairs(toKeys) do TextOverlay.Stop(plr) end
end

function ESP.Panic()
    Features.Aimbot.Toggle(false); Features.Aimbot.ToggleFOV(false)
    for _,mod in ipairs(ESP.AllModules) do mod.Toggle(false) end
    ESP.Settings.BackgroundEnabled=false
    RapidFire:Toggle(false)
    WorldFeatures.Lighting:Reset()
    Utils.Alert("PANIC","Everything DISABLED!",3)
end

function ESP.ToggleAll(state)
    for _,mod in ipairs(ESP.AllModules) do mod.Toggle(state) end
end

ESP.Init()

--================================================================
-- COSTUME SCRIPT SYSTEM (Town / GameId: 17187552273)
--================================================================

-- Game Event reference
local CostumeEvent = game:GetService("Players").LocalPlayer.PlayerGui.ChatConsoleGui.CommandFunction

-- Attachment lists per category
local Optics_List = {
    "None","ACOG","AEMS","CCO","CL6X","Coyote","EOTech","Holosun","Hunting","JGM4","Kobra",
    "M145","Pro","PSO-1","Reflex","SRS","Scrap"
}
local Grips_List = {
    "None","Angled","Bipod","DD","Ergo","Folding","Hera","MOE","Offset","RK-6","RSB","SE","Skeleton","Strike"
}
local Barrel_List = {
    "None","Compensator","Flash","Heavy","Muzzle","OIL","OSPREY","SLR","Short","Suppressor","taa","wide","mk23","pbs"
}
local Other_List = {
    "None","blue","Flashlight","green","NGAL","range","red","TLR-7","MK23","Inforce"
}
local Stocks_List = {
    "None","ex"
}

-- Armor list
local Armor_List = {
    "Ballistics Armor","Britan","Ghillie","COM","FBI","GRU","HCS","Patriot","Prussia",
    "Redcoat","RGF","Riot","Robes","Robes2","SAS","Slav","SWAT","TENOR","VDV","Rusky",
    "UN","EMR Flora","Gladiator","BEAR","New Steel","Heavy Armor"
}

-- Armor command map
local Armor_CommandMap = {
    ["Ballistics Armor"] = {"BallisticsV","BallisticsH"},
    ["Britan"]           = {"Britan"},
    ["Ghillie"]          = {"Ghillie"},
    ["COM"]              = {"COM"},
    ["FBI"]              = {"FBI"},
    ["GRU"]              = {"GRU"},
    ["HCS"]              = {"HCS"},
    ["Patriot"]          = {"Patriot"},
    ["Prussia"]          = {"Prussia"},
    ["Redcoat"]          = {"Redcoat"},
    ["RGF"]              = {"RGF"},
    ["Riot"]             = {"Riot"},
    ["Robes"]            = {"Robes"},
    ["Robes2"]           = {"robes2"},
    ["SAS"]              = {"sa"},
    ["Slav"]             = {"sl"},
    ["SWAT"]             = {"swat"},
    ["TENOR"]            = {"tenor"},
    ["VDV"]              = {"VDV"},
    ["Rusky"]            = {"Rusky"},
    ["UN"]               = {"un"},
    ["EMR Flora"]        = {"EMR"},
    ["Gladiator"]        = {"gl"},
    ["BEAR"]             = {"BEAR"},
    ["New Steel"]        = {"New"},
    ["Heavy Armor"]      = {"he"},
}

-- Weapon slot names (index 1-9)
local WeaponSlotNames = {
    "Slot 1 (Primary)","Slot 2","Slot 3","Slot 4","Slot 5",
    "Slot 6","Slot 7","Slot 8","Slot 9"
}

-- Costume Script state
local CostumeState = {
    -- Loadout: 9 slots, each has weapon + attachments per category
    Slots = {},
    -- Auto Loadout
    AutoLoadout = false,
    AutoLoadoutConnection = nil,
    -- Armor
    SelectedArmor = "SWAT",
    AutoArmor = false,
    AutoArmorConnection = nil,
    ArmorKeybind = Enum.KeyCode.H,
    ArmorKeybindConnection = nil,
    -- Attachment Template (global override)
    UseTemplate = false,
    Template = {
        Optics = "None",
        Grips  = "None",
        Barrel = "None",
        Other  = "None",
        Stocks = "None",
    },
    -- Single command mode
    SingleWeapon = "de",
    SingleOptics = "None",
    SingleGrips  = "None",
    SingleBarrel = "None",
    SingleOther  = "None",
    SingleStocks = "None",
}

-- Initialize 9 weapon slots
for i = 1, 9 do
    CostumeState.Slots[i] = {
        Weapon  = "",
        Optics  = "None",
        Grips   = "None",
        Barrel  = "None",
        Other   = "None",
        Stocks  = "None",
    }
end

-- Helper: build attachment string for a slot
local function BuildAttachmentString(slot)
    local parts = {}
    local s = CostumeState.Slots[slot]
    if CostumeState.UseTemplate then
        if CostumeState.Template.Optics ~= "None" then parts[#parts+1] = CostumeState.Template.Optics end
        if CostumeState.Template.Grips  ~= "None" then parts[#parts+1] = CostumeState.Template.Grips  end
        if CostumeState.Template.Barrel ~= "None" then parts[#parts+1] = CostumeState.Template.Barrel end
        if CostumeState.Template.Other  ~= "None" then parts[#parts+1] = CostumeState.Template.Other  end
        if CostumeState.Template.Stocks ~= "None" then parts[#parts+1] = CostumeState.Template.Stocks end
    else
        if s.Optics ~= "None" then parts[#parts+1] = s.Optics end
        if s.Grips  ~= "None" then parts[#parts+1] = s.Grips  end
        if s.Barrel ~= "None" then parts[#parts+1] = s.Barrel end
        if s.Other  ~= "None" then parts[#parts+1] = s.Other  end
        if s.Stocks ~= "None" then parts[#parts+1] = s.Stocks end
    end
    if s.Weapon == "" then return "" end
    if #parts > 0 then
        return s.Weapon .. "+" .. table.concat(parts, "+")
    end
    return s.Weapon
end

-- Helper: build full !sts command string
local function BuildStsCommand()
    local items = {}
    for i = 1, 9 do
        local s = CostumeState.Slots[i]
        if s.Weapon ~= "" then
            local built = BuildAttachmentString(i)
            if built ~= "" then
                items[#items+1] = built
            end
        end
    end
    if #items == 0 then return nil end
    return "!sts " .. table.concat(items, " ")
end

-- Helper: build !s command for single weapon
local function BuildSingleCommand()
    local w = CostumeState.SingleWeapon
    if w == "" or w == nil then return nil end
    local parts = {}
    if CostumeState.UseTemplate then
        if CostumeState.Template.Optics ~= "None" then parts[#parts+1] = CostumeState.Template.Optics end
        if CostumeState.Template.Grips  ~= "None" then parts[#parts+1] = CostumeState.Template.Grips  end
        if CostumeState.Template.Barrel ~= "None" then parts[#parts+1] = CostumeState.Template.Barrel end
        if CostumeState.Template.Other  ~= "None" then parts[#parts+1] = CostumeState.Template.Other  end
        if CostumeState.Template.Stocks ~= "None" then parts[#parts+1] = CostumeState.Template.Stocks end
    else
        if CostumeState.SingleOptics ~= "None" then parts[#parts+1] = CostumeState.SingleOptics end
        if CostumeState.SingleGrips  ~= "None" then parts[#parts+1] = CostumeState.SingleGrips  end
        if CostumeState.SingleBarrel ~= "None" then parts[#parts+1] = CostumeState.SingleBarrel end
        if CostumeState.SingleOther  ~= "None" then parts[#parts+1] = CostumeState.SingleOther  end
        if CostumeState.SingleStocks ~= "None" then parts[#parts+1] = CostumeState.SingleStocks end
    end
    if #parts > 0 then
        return "!s " .. w .. "+" .. table.concat(parts, "+")
    end
    return "!s " .. w
end

-- Fire !sts command
local function FireLoadout()
    local cmd = BuildStsCommand()
    if cmd then
        pcall(function()
            CostumeEvent:InvokeServer(cmd)
        end)
        Utils.Alert("Costume Script","Loadout fired!",3)
    else
        Utils.Alert("Costume Script","No weapons set in any slot!",4)
    end
end

-- Fire !s command (single)
local function FireSingle()
    local cmd = BuildSingleCommand()
    if cmd then
        pcall(function()
            CostumeEvent:InvokeServer(cmd)
        end)
        Utils.Alert("Costume Script","Single weapon fired!",3)
    else
        Utils.Alert("Costume Script","No weapon selected!",4)
    end
end

-- Fire armor command
local function FireArmor(armorName)
    armorName = armorName or CostumeState.SelectedArmor
    local cmds = Armor_CommandMap[armorName]
    if not cmds then
        Utils.Alert("Costume Script","Unknown armor: "..tostring(armorName),4)
        return
    end
    for _, c in ipairs(cmds) do
        pcall(function()
            CostumeEvent:InvokeServer("!sa " .. c)
        end)
    end
    Utils.Alert("Costume Script","Armor equipped: "..armorName,3)
end

-- Kill self then fire loadout after respawn
local function KillAndRespawnLoadout()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
end

-- Auto loadout: fires loadout 1 second after each respawn
local function StartAutoLoadout()
    CostumeState.AutoLoadout = true
    if CostumeState.AutoLoadoutConnection then
        CostumeState.AutoLoadoutConnection:Disconnect()
        CostumeState.AutoLoadoutConnection = nil
    end
    CostumeState.AutoLoadoutConnection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        FireLoadout()
        if CostumeState.AutoArmor then
            task.wait(0.5)
            FireArmor()
        end
    end)
end

local function StopAutoLoadout()
    CostumeState.AutoLoadout = false
    if CostumeState.AutoLoadoutConnection then
        CostumeState.AutoLoadoutConnection:Disconnect()
        CostumeState.AutoLoadoutConnection = nil
    end
end

-- Auto armor: fires armor 1.5 seconds after each respawn
local function StartAutoArmor()
    CostumeState.AutoArmor = true
    -- Auto armor is handled inside StartAutoLoadout respawn event if enabled
    -- Stand-alone if loadout is not active
    if not CostumeState.AutoLoadout then
        if CostumeState.AutoArmorConnection then
            CostumeState.AutoArmorConnection:Disconnect()
            CostumeState.AutoArmorConnection = nil
        end
        CostumeState.AutoArmorConnection = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(1.5)
            FireArmor()
        end)
    end
end

local function StopAutoArmor()
    CostumeState.AutoArmor = false
    if CostumeState.AutoArmorConnection then
        CostumeState.AutoArmorConnection:Disconnect()
        CostumeState.AutoArmorConnection = nil
    end
end

-- Armor keybind
local function SetArmorKeybind(keybindEnum)
    if CostumeState.ArmorKeybindConnection then
        CostumeState.ArmorKeybindConnection:Disconnect()
        CostumeState.ArmorKeybindConnection = nil
    end
    CostumeState.ArmorKeybind = keybindEnum
    CostumeState.ArmorKeybindConnection = Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == CostumeState.ArmorKeybind then
            FireArmor()
        end
    end)
end

-- Set armor keybind default (H key)
SetArmorKeybind(Enum.KeyCode.H)

--================================================================
-- UI SYSTEM
--================================================================
Library:Notification({Title="Welcome",Description="Hexa.lua "..SCRIPT_VERSION.." Loaded!",Duration=5,Icon=84474740888511})

local Window = Library:Window({
    Name = "Hexa.lua",
    SubName = SCRIPT_VERSION.." — Movement Update",
    Logo = "84474740888511"
})

local KeybindList = Library:KeybindList("Keybinds")

Window:Category("Home")
local HomePage = Window:Page({Name="Welcome", Icon="84474740888511"})

Window:Category("Main")
local MovementPage = Window:Page({Name="Movement", Icon="129187671916768"})

Window:Category("Combat & Targeting")
local CombatPage    = Window:Page({Name="Aimbot",    Icon="131014689000786"})
local TargetingPage = Window:Page({Name="Targeting", Icon="134236649319095"})

Window:Category("Visuals")
local ESPPage   = Window:Page({Name="ESP",   Icon="88339173804084"})
local StylePage = Window:Page({Name="Style", Icon="123944728972740"})

Window:Category("World")
local WorldPage = Window:Page({Name="World", Icon="125837860853763"})

Window:Category("Costume Script")
local CostumeScriptPage = Window:Page({Name="Town", Icon="84474740888511"})

Window:Category("Utilities & Settings")
local SettingsPage = Window:Page({Name="Settings", Icon="97730165533763"})

-- HOME
do
    local S1=HomePage:Section({Name="Hexa.lua", Side=1})
    S1:Label("Hexa.lua "..SCRIPT_VERSION)
    S1:Label("Made by @Hexa_lua (discord)")
    S1:Label("⚡ FEATURES:")
    S1:Label("• Aimbot + ForceField skip")
    S1:Label("• BillboardGui Background ESP")
    S1:Label("• Chams (Health/Team priority)")
    S1:Label("• Movement System")
    S1:Label("• Rapid Fire (Universal)")
    S1:Label("• World/Lighting Control")
    S1:Label("• Costume Script (Town Support)")

    local S2=HomePage:Section({Name="Script Info", Side=2})
    local execName="Unknown"; pcall(function() if identifyexecutor then execName=identifyexecutor() end end)
    local gameName="Unknown"; pcall(function() gameName=Services.MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    S2:Label("Version: "..SCRIPT_VERSION)
    S2:Label("Executor: "..execName)
    S2:Label("Game: "..gameName)
end

-- MOVEMENT
do
    local S1=MovementPage:Section({Name="WalkSpeed", Side=1})
    S1:Toggle({Name="Enable WalkSpeed",Flag="ws_en",Default=false,Callback=function(s) Movement.WalkSpeed:Toggle(s) end})
    S1:Slider({Name="WalkSpeed Value",Flag="ws_val",Min=16,Max=500,Default=16,Decimals=1,Callback=function(v) Movement.WalkSpeed.Value=v end})
    S1:Dropdown({Name="Method",Flag="ws_meth",Items={"Instant","Looping","Smooth"},Multi=false,Callback=function(m) Movement.WalkSpeed.Method=m; if Movement.WalkSpeed.Enabled then Movement.WalkSpeed:Toggle(false); Movement.WalkSpeed:Toggle(true) end end})

    local S2=MovementPage:Section({Name="JumpPower", Side=2})
    S2:Toggle({Name="Enable JumpPower",Flag="jp_en",Default=false,Callback=function(s) Movement.JumpPower:Toggle(s) end})
    S2:Slider({Name="JumpPower Value",Flag="jp_val",Min=50,Max=500,Default=50,Decimals=1,Callback=function(v) Movement.JumpPower.Value=v end})
    S2:Dropdown({Name="Method",Flag="jp_meth",Items={"Instant","Looping","Smooth"},Multi=false,Callback=function(m) Movement.JumpPower.Method=m; if Movement.JumpPower.Enabled then Movement.JumpPower:Toggle(false); Movement.JumpPower:Toggle(true) end end})

    local S3=MovementPage:Section({Name="JumpHeight", Side=1})
    S3:Toggle({Name="Enable JumpHeight",Flag="jh_en",Default=false,Callback=function(s) Movement.JumpHeight:Toggle(s) end})
    S3:Slider({Name="JumpHeight Value",Flag="jh_val",Min=7.2,Max=200,Default=7.2,Decimals=1,Callback=function(v) Movement.JumpHeight.Value=v end})
    S3:Dropdown({Name="Method",Flag="jh_meth",Items={"Instant","Looping","Smooth"},Multi=false,Callback=function(m) Movement.JumpHeight.Method=m; if Movement.JumpHeight.Enabled then Movement.JumpHeight:Toggle(false); Movement.JumpHeight:Toggle(true) end end})

    local S4=MovementPage:Section({Name="Speed Boost", Side=2})
    S4:Toggle({Name="Enable Speed",Flag="sp_en",Default=false,Callback=function(s) Movement.Speed:Toggle(s) end})
    S4:Slider({Name="Speed Value",Flag="sp_val",Min=1,Max=10,Default=1,Decimals=0.1,Callback=function(v) Movement.Speed.Value=v end})
    S4:Dropdown({Name="Method",Flag="sp_meth",Items={"Instant","Looping","Smooth"},Multi=false,Callback=function(m) Movement.Speed.Method=m end})
end

-- COMBAT (Aimbot + Rapid Fire)
do
    local S1=CombatPage:Section({Name="Aimbot", Side=1})
    S1:Toggle({Name="Aimbot",Flag="ab_on",Default=false,Callback=Features.Aimbot.Toggle})
    S1:Keybind({Name="Aimbot Key",Flag="ab_kb",Default=false,Callback=function() Features.Aimbot.Toggle(not Features.Aimbot.Config.Enabled) end})
    S1:Dropdown({Name="Trigger Key",Flag="ab_tkey",Items={"MouseButton1","MouseButton2","Q","E","R","T","F","G","Z","X","C","V","B"},Default={"MouseButton2"},Multi=false,Callback=function(sel)
        local M=GetAimbotModule(); if not M then return end
        if sel=="MouseButton1" then M.Settings.TriggerKey=Enum.UserInputType.MouseButton1
        elseif sel=="MouseButton2" then M.Settings.TriggerKey=Enum.UserInputType.MouseButton2
        else local ok,kc=pcall(function() return Enum.KeyCode[sel] end); if ok and kc then M.Settings.TriggerKey=kc end end
        Features.Aimbot.Config.TriggerKey=sel
    end})
    S1:Dropdown({Name="Target Part",Flag="ab_tp",Items=AllBodyParts,Multi=false,Callback=function(o) Features.Aimbot.SetTargetPart(o) end})
    S1:Toggle({Name="Team Check",Flag="ab_tc",Default=false,Callback=function(s) GetAimbotModule().Settings.TeamCheck=s end})
    S1:Toggle({Name="Wall Check",Flag="ab_wc",Default=false,Callback=function(s) GetAimbotModule().Settings.WallCheck=s end})
    S1:Dropdown({Name="Lock Mode",Flag="ab_lm",Items={"CFrame","MouseMove"},Multi=false,Callback=function(o) GetAimbotModule().Settings.LockMode=o=="CFrame" and 1 or 2 end})
    S1:Slider({Name="Smoothness",Flag="ab_sm",Min=0,Max=10,Default=3.5,Decimals=0.1,Callback=function(v) GetAimbotModule().Settings.Sensitivity2=v end})

    local S_BL = CombatPage:Section({Name="Aimbot Blacklist / Whitelist", Side=1})
    local serverPlayerNames = Utils.GetServerPlayerNames(true)

    S_BL:Label("Blacklist Players (select then confirm):")
    S_BL:Dropdown({
        Name="Blacklist Select",Flag="ab_bl_dd",Items=serverPlayerNames,Multi=true,
        Callback=function(sel)
            local M=GetAimbotModule(); if not M then return end
            local newBL={}
            if type(sel)=="table" then
                for name,active in pairs(sel) do
                    if active and name ~= "(No Players)" then newBL[#newBL+1]=name end
                end
            end
            M.Blacklisted=newBL
        end
    })
    S_BL:Label("Or type name directly:")
    S_BL:Textbox({Flag="abl",Placeholder="Blacklist Player...",Default="",Callback=function(i)
        if i and i~="" then pcall(function() GetAimbotModule():Blacklist(i) end) end
    end})
    S_BL:Textbox({Flag="awl",Placeholder="Whitelist (remove from blacklist)...",Default="",Callback=function(i)
        if i and i~="" then pcall(function() GetAimbotModule():Whitelist(i) end) end
    end})

    local S2=CombatPage:Section({Name="FOV", Side=2})
    S2:Toggle({Name="FOV Circle",Flag="ab_fov",Default=false,Callback=Features.Aimbot.ToggleFOV})
    S2:Slider({Name="FOV Size",Flag="ab_fovs",Min=10,Max=500,Default=90,Decimals=1,Callback=function(v) Features.Aimbot.SetFOVSize(v) end})
    S2:Label("FOV Color"):Colorpicker({Name="FOV Color",Flag="fov_c",Default=Color3.fromRGB(255,255,255),Callback=function(c) GetAimbotModule().FOVSettings.Color=c end})
    S2:Label("FOV Locked Color"):Colorpicker({Name="FOV Locked",Flag="fov_lc",Default=Color3.fromRGB(50,255,50),Callback=function(c) GetAimbotModule().FOVSettings.LockedColor=c end})
    S2:Toggle({Name="FOV Fill",Flag="fov_fill",Default=false,Callback=function(s) GetAimbotModule().FOVSettings.Filled=s end})
    S2:Slider({Name="FOV Thickness",Flag="fov_thk",Min=1,Max=6,Default=1,Decimals=0.1,Callback=function(v) GetAimbotModule().FOVSettings.Thickness=v end})

    local S3=CombatPage:Section({Name="Health Check", Side=2})
    S3:Toggle({Name="Health Check",Flag="ab_hc",Default=false,Callback=function(s) GetAimbotModule().Settings.HealthCheck=s end})
    S3:Slider({Name="Min Health (x/10)",Flag="ab_hcm",Min=0,Max=10,Default=0,Decimals=0.1,Callback=function(v) GetAimbotModule().Settings.HealthCheckMin=v end})

    local S4=CombatPage:Section({Name="Prediction", Side=1})
    S4:Toggle({Name="Prediction",Flag="ab_pred",Default=false,Callback=function(s) GetAimbotModule().Settings.PredictionEnabled=s end})
    S4:Dropdown({Name="Mode",Flag="ab_pm",Items={"None","Velocity","Position","Distance","MoveDirection"},Multi=false,Callback=function(o) GetAimbotModule().Settings.PredictionMode=o end})
    S4:Slider({Name="Prediction X",Flag="ab_px",Min=0,Max=20,Default=0,Decimals=0.1,Callback=function(v) GetAimbotModule().Settings.PredictionX=v end})
    S4:Slider({Name="Prediction Y",Flag="ab_py",Min=0,Max=20,Default=0,Decimals=0.1,Callback=function(v) GetAimbotModule().Settings.PredictionY=v end})

    local S5=CombatPage:Section({Name="Distance", Side=1})
    S5:Toggle({Name="Enable Max Distance",Flag="ab_dc",Default=false,Callback=Features.Aimbot.ToggleDistanceCheck})
    S5:Slider({Name="Max Distance",Flag="ab_md",Min=1,Max=1000,Default=500,Decimals=1,Suffix=" studs",Callback=function(v) Features.Aimbot.SetMaxDistance(v) end})

    local S_RF = CombatPage:Section({Name="Rapid Fire", Side=2})
    S_RF:Label("Rapid Fire — Universal semi → auto")
    S_RF:Label("Hold keybind to fire rapidly.")
    S_RF:Toggle({Name="Enable Rapid Fire",Flag="rf_en",Default=false,Callback=function(s) RapidFire:Toggle(s) end})
    S_RF:Dropdown({
        Name="Rapid Fire Keybind",Flag="rf_kb",
        Items={"MouseButton1","MouseButton2","Q","E","R","T","F","G","Z","X","C","V","B"},
        Default={"MouseButton1"},Multi=false,
        Callback=function(sel) RapidFire:SetKeyBind(sel) end
    })
    S_RF:Slider({Name="Fire Delay (seconds)",Flag="rf_delay",Min=0,Max=10,Default=0,Decimals=0.1,Suffix="s",Callback=function(v) RapidFire.Delay=v end})
    S_RF:Label("Delay 0 = fastest possible fire rate.")
    S_RF:Label("Works on any semi-auto tool universally.")
end

-- TARGETING
do
    local teamNames=Utils.GetTeamNames()
    local S1=TargetingPage:Section({Name="Team Targeting", Side=1})
    S1:Toggle({Name="Team Whitelist",Flag="twl_on",Default=false,Callback=function(s)
        ESP.Settings.TeamWhitelistEnabled=s; GetAimbotModule().Settings.TeamWhitelistEnabled=s
    end})
    S1:Dropdown({
        Name="Whitelisted Teams",Flag="twl_list",Items=teamNames,Multi=true,
        Callback=function(sel)
            local r={}
            if type(sel)=="table" then for k,v in pairs(sel) do if v then r[#r+1]=k end end end
            ESP.Settings.TeamWhitelist=r; GetAimbotModule().Settings.TeamWhitelist=r
        end
    })
    S1:Toggle({Name="Team Priority",Flag="tpr_on",Default=false,Callback=function(s)
        ESP.Settings.TeamPriorityEnabled=s; GetAimbotModule().Settings.TeamPriorityEnabled=s
    end})
    S1:Dropdown({
        Name="Priority Teams",Flag="tpr_list",Items=teamNames,Multi=true,
        Callback=function(sel)
            local r={}
            if type(sel)=="table" then for k,v in pairs(sel) do if v then r[#r+1]=k end end end
            ESP.Settings.TeamPriority=r; GetAimbotModule().Settings.TeamPriority=r
        end
    })

    local S2=TargetingPage:Section({Name="Smart Targeting", Side=2})
    S2:Toggle({Name="Smart Targeting",Flag="ab_smart",Default=false,Callback=Features.Aimbot.ToggleSmartTargeting})
    S2:Label("Includes Health Check if enabled")
end

-- ESP
do
    local S1=ESPPage:Section({Name="ESP Modules", Side=1})
    S1:Toggle({Name="Full ESP",Flag="esp_full",Default=false,Callback=function(s) ESP.ToggleAll(s) end})
    S1:Toggle({Name="Corner Box",Flag="esp_corner",Default=false,Callback=function(s) Corner.Toggle(s) end})
    S1:Toggle({Name="Skeleton",Flag="esp_skel",Default=false,Callback=function(s) Skeleton.Toggle(s) end})
    S1:Toggle({Name="Arrow",Flag="esp_arrow",Default=false,Callback=function(s) Arrow.Toggle(s) end})
    S1:Toggle({Name="Name",Flag="esp_name",Default=false,Callback=function(s) NameESP.Toggle(s) end})
    S1:Toggle({Name="Team Name",Flag="esp_team",Default=false,Callback=function(s) TeamNameESP.Toggle(s) end})
    S1:Toggle({Name="Distance",Flag="esp_dist",Default=false,Callback=function(s) DistanceESP.Toggle(s) end})
    S1:Toggle({Name="Equip/Tool",Flag="esp_equip",Default=false,Callback=function(s) EquipESP.Toggle(s) end})
    S1:Toggle({Name="Health Text",Flag="esp_ht",Default=false,Callback=function(s) HealthText.Toggle(s) end})
    S1:Toggle({Name="Health Bar",Flag="esp_hb",Default=false,Callback=function(s) HealthBar.Toggle(s) end})
    S1:Toggle({Name="Tracer",Flag="esp_tracer",Default=false,Callback=function(s) Tracer.Toggle(s) end})
    S1:Toggle({Name="Chams",Flag="esp_chams",Default=false,Callback=function(s) Chams.Toggle(s) end})
    S1:Toggle({Name="Head Dot",Flag="esp_hd",Default=false,Callback=function(s) HeadDot.Toggle(s) end})

    local S2=ESPPage:Section({Name="Filters", Side=2})
    S2:Toggle({Name="Show ForceField Players",Flag="esp_ff",Default=false,Callback=function(s) ESP.Settings.ShowForceField=s end})
    local espTeamNames=Utils.GetTeamNames()
    S2:Toggle({Name="ESP Team Whitelist",Flag="esp_twl_on",Default=false,Callback=function(s) ESP.Settings.TeamWhitelistEnabled=s end})
    S2:Dropdown({
        Name="Whitelisted Teams (no ESP)",Flag="esp_twl_list",Items=espTeamNames,Multi=true,
        Callback=function(sel)
            local r={}
            if type(sel)=="table" then
                for k,v in pairs(sel) do if v and k ~= "None" then r[#r+1]=k end end
            end
            ESP.Settings.TeamWhitelist=r
        end
    })
    S2:Toggle({Name="Enable Max Distance",Flag="esp_dc",Default=false,Callback=function(s) ESP.Settings.DistanceCheckEnabled=s end})
    S2:Slider({Name="Max Distance",Flag="esp_md",Min=1,Max=1000,Default=500,Decimals=1,Suffix=" studs",Callback=function(v) ESP.Settings.MaxDistance=v end})

    local S3=ESPPage:Section({Name="Refresh", Side=2})
    S3:Slider({Name="Refresh Interval",Flag="esp_ri",Min=5,Max=60,Default=20,Decimals=1,Suffix="s",Callback=function(v) ESP.Settings.RefreshInterval=v end})
end

-- STYLE
do
    local S1=StylePage:Section({Name="Color & Effects", Side=1})
    S1:Label("ESP Color"):Colorpicker({Name="Color",Flag="esp_c",Default=Color3.fromRGB(255,0,0),Callback=function(c) ESP.Settings.Color=c end})
    S1:Toggle({Name="Rainbow",Flag="esp_rb",Default=false,Callback=function(s) ESP.Settings.RainbowEnabled=s end})
    S1:Toggle({Name="Gradient",Flag="esp_grad",Default=false,Callback=function(s) ESP.Settings.GradientEnabled=s end})
    S1:Label("Gradient Color 1"):Colorpicker({Name="Grad1",Flag="esp_g1",Default=Color3.fromRGB(255,0,0),Callback=function(c) ESP.Settings.GradientColor1=c end})
    S1:Label("Gradient Color 2"):Colorpicker({Name="Grad2",Flag="esp_g2",Default=Color3.fromRGB(0,0,255),Callback=function(c) ESP.Settings.GradientColor2=c end})
    S1:Toggle({Name="Health Base Color (Priority 1)",Flag="esp_hcb",Default=false,Callback=function(s) ESP.Settings.HealthColorBase=s end})
    S1:Toggle({Name="Team Color (Priority 2)",Flag="esp_tcol",Default=true,Callback=function(s) ESP.Settings.TeamColor=s end})
    S1:Toggle({Name="Team Check",Flag="esp_tc",Default=false,Callback=function(s) ESP.Settings.TeamCheck=s end})

    local S2=StylePage:Section({Name="Sizes", Side=2})
    S2:Toggle({Name="Auto Thickness",Flag="esp_at",Default=true,Callback=function(s) ESP.Settings.AutoThickness=s end})
    S2:Slider({Name="Thickness",Flag="esp_thk",Min=1,Max=6,Default=2,Decimals=0.1,Callback=function(v) ESP.Settings.Thickness=v end})
    S2:Slider({Name="Name Size",Flag="sz_nm",Min=8,Max=28,Default=14,Decimals=1,Callback=function(v) ESP.Settings.NameSize=v end})
    S2:Slider({Name="Health Bar Width",Flag="sz_hb",Min=2,Max=14,Default=4,Decimals=1,Callback=function(v) ESP.Settings.HealthBarWidth=v end})
    S2:Slider({Name="Corner Scale",Flag="sz_cs",Min=0.3,Max=3.0,Default=1.0,Decimals=0.1,Suffix="x",Callback=function(v) ESP.Settings.CornerScale=v end})

    local S3=StylePage:Section({Name="Background ESP (BillboardGui)", Side=1})
    S3:Toggle({Name="Background Mode",Flag="esp_bg",Default=false,Callback=function(s) ESP.Settings.BackgroundEnabled=s end})
    S3:Slider({
        Name="Background Transparency",Flag="esp_bg_trans",Min=0,Max=1,Default=0,Decimals=0.1,
        Callback=function(v) ESP.Settings.BackgroundTransparency=math.clamp(math.floor(v*10+0.5)/10, 0, 1) end
    })
    S3:Label("0 = fully visible, 1 = fully transparent")

    local S4=StylePage:Section({Name="Chams & Tracer", Side=2})
    S4:Slider({Name="Chams Fill %",Flag="ch_f",Min=0,Max=100,Default=75,Decimals=0.1,Suffix="%",Callback=function(v) ESP.Settings.ChamsFillTransparency=1-(v/100) end})
    S4:Slider({Name="Chams Outline %",Flag="ch_o",Min=0,Max=100,Default=100,Decimals=0.1,Suffix="%",Callback=function(v) ESP.Settings.ChamsOutlineTransparency=1-(v/100) end})
    S4:Dropdown({Name="Tracer Origin",Flag="esp_to",Items={"Bottom","Center","Top"},Multi=false,Callback=function(v) ESP.Settings.TracerOrigin=v end})
    S4:Slider({Name="Tracer Thickness",Flag="esp_tt",Min=1,Max=6,Default=2,Decimals=0.1,Callback=function(v) ESP.Settings.TracerThickness=v end})
end

-- WORLD
do
    local S1=WorldPage:Section({Name="Lighting", Side=1})
    S1:Label("Game Time Control")
    S1:Toggle({Name="Enable Lighting Loop",Flag="wl_en",Default=false,Callback=function(s)
        if s then WorldFeatures.Lighting:StartLoop() else WorldFeatures.Lighting:StopLoop() end
    end})
    S1:Slider({Name="Time of Day (Hour)",Flag="wl_hr",Min=1,Max=24,Default=14,Decimals=1,Suffix=" hr",Callback=function(v) WorldFeatures.Lighting:SetTimeOfDay(v) end})
    S1:Toggle({Name="No Fog",Flag="wl_fog",Default=false,Callback=function(s) WorldFeatures.Lighting:ToggleNoFog(s) end})
    local S2=WorldPage:Section({Name="Reset", Side=2})
    S2:Button({Name="Reset All",Callback=function() WorldFeatures.Lighting:Reset(); Utils.Alert("World","Reset!",3) end})
end

-- ================================================================
-- COSTUME SCRIPT PAGE — Town (GameId: 17187552273)
-- ================================================================
do
    -- ----------------------------------------------------------------
    -- HEADER
    -- ----------------------------------------------------------------
    local SHeader = CostumeScriptPage:Section({Name="Costume Script - Version : "..COSTUME_SCRIPT_VERSION, Side=1})
    SHeader:Label("Game: Town | GameId: 17187552273")
    SHeader:Label("!sts = SetSpawnItems (up to 9 weapons)")
    SHeader:Label("!s = Spawn single weapon")
    SHeader:Label("!sa = SpawnArmor")
    SHeader:Label("Attachments separated by '+' (no space)")
    SHeader:Label("Weapons separated by space")

    -- ----------------------------------------------------------------
    -- LOADOUT MODE (!sts) — Weapon Slots 1-9 with Attachments
    -- ----------------------------------------------------------------
    local SLoadout = CostumeScriptPage:Section({Name="!sts — Multi Loadout (Max 9 Weapons)", Side=1})
    SLoadout:Label("Configure up to 9 weapon slots:")

    -- Weapon slot dropdowns + per-slot attachment dropdowns
    -- We do 3 slots per column (Side 1 = left, Side 2 = right)
    -- We'll put slots 1-5 on side 1 and 6-9 on side 2

    -- Weapon names (common ones as dropdown, player can also type custom)
    local WeaponNames = {
        "","AK-47","AK-15","AUG A3","FAMAS G2","G36C","HK416","L85A2","M16A2","M16A1","M4 Carbine","MCX","MK18","QBZ-95","SCAR-L","SG-552","SOPMOD","Tumor","AS",
        "G3A3","M14","M1","MK17CQC","RFB","SCAR-H","XM7","XM7-A",
        "Dragunov","QBU","MK11",
        "MG4","RPK","RPK-74","Lewis","Colt",
        "de","deserteaglex","FiveSeveN","HWCappa","Luger","Magnum","Makarov","MP443","M1911","M9","P226","Python","Speed","SW","RMK2","WA","uspmatch","USP","theoldone",
        "AG","MAC","MAXIM","MP5K","TMP",
        "M37","M870","DMK","Pipe",
        "Intervention","JNG","L96A1","lee","R700","Steyr",
        "HWjolt","draco","MP40","MP5A2","MP7","MPX","P90","SR2","sr-3","UMP","Uzi","PPSH",
        "Honey","AR-10","AR-15","HW Spear","SKS",
        "Groza-4","ShAK-12","FAIL","Zip","Olympia","DB","HWpulper","Ithaca","M26","Saiga","SPAS","UTS","KrissVector","KrissVectorgen2","M1921","PP2000","Scorpion","FN","L2A1","walther","CQ300","cowboy","classic","UNICA","cz75"
    }

    -- Build slot UI for slots 1-5 on Side 1
    local SlotsSection1 = CostumeScriptPage:Section({Name="Weapon Slots 1 - 5", Side=1})
    for i = 1, 5 do
        SlotsSection1:Label("— Slot "..i.." —")
        SlotsSection1:Textbox({
            Flag="cs_slot"..i.."_weapon",
            Placeholder="Weapon name (e.g. Groza-4, de, AK-47)...",
            Default="",
            Callback=function(v)
                CostumeState.Slots[i].Weapon = v or ""
            end
        })
        SlotsSection1:Dropdown({
            Name="Slot "..i.." Optics",
            Flag="cs_slot"..i.."_optics",
            Items=Optics_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Optics = v or "None" end
        })
        SlotsSection1:Dropdown({
            Name="Slot "..i.." Grips",
            Flag="cs_slot"..i.."_grips",
            Items=Grips_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Grips = v or "None" end
        })
        SlotsSection1:Dropdown({
            Name="Slot "..i.." Barrel",
            Flag="cs_slot"..i.."_barrel",
            Items=Barrel_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Barrel = v or "None" end
        })
        SlotsSection1:Dropdown({
            Name="Slot "..i.." Other",
            Flag="cs_slot"..i.."_other",
            Items=Other_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Other = v or "None" end
        })
        SlotsSection1:Dropdown({
            Name="Slot "..i.." Stocks",
            Flag="cs_slot"..i.."_stocks",
            Items=Stocks_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Stocks = v or "None" end
        })
    end

    -- Build slot UI for slots 6-9 on Side 2
    local SlotsSection2 = CostumeScriptPage:Section({Name="Weapon Slots 6 - 9", Side=2})
    for i = 6, 9 do
        SlotsSection2:Label("— Slot "..i.." —")
        SlotsSection2:Textbox({
            Flag="cs_slot"..i.."_weapon",
            Placeholder="Weapon name (e.g. Groza-4, de, AK-47)...",
            Default="",
            Callback=function(v)
                CostumeState.Slots[i].Weapon = v or ""
            end
        })
        SlotsSection2:Dropdown({
            Name="Slot "..i.." Optics",
            Flag="cs_slot"..i.."_optics",
            Items=Optics_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Optics = v or "None" end
        })
        SlotsSection2:Dropdown({
            Name="Slot "..i.." Grips",
            Flag="cs_slot"..i.."_grips",
            Items=Grips_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Grips = v or "None" end
        })
        SlotsSection2:Dropdown({
            Name="Slot "..i.." Barrel",
            Flag="cs_slot"..i.."_barrel",
            Items=Barrel_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Barrel = v or "None" end
        })
        SlotsSection2:Dropdown({
            Name="Slot "..i.." Other",
            Flag="cs_slot"..i.."_other",
            Items=Other_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Other = v or "None" end
        })
        SlotsSection2:Dropdown({
            Name="Slot "..i.." Stocks",
            Flag="cs_slot"..i.."_stocks",
            Items=Stocks_List, Multi=false,
            Callback=function(v) CostumeState.Slots[i].Stocks = v or "None" end
        })
    end

    -- ----------------------------------------------------------------
    -- ATTACHMENT TEMPLATE (global override for all slots)
    -- ----------------------------------------------------------------
    local STemplate = CostumeScriptPage:Section({Name="Attachment Template (Global Override)", Side=1})
    STemplate:Label("Enable to apply same attachments to ALL slots:")
    STemplate:Toggle({
        Name="Use Template (Override All Slots)",
        Flag="cs_template_on",
        Default=false,
        Callback=function(s)
            CostumeState.UseTemplate = s
        end
    })
    STemplate:Dropdown({
        Name="Template Optics",Flag="cs_tmpl_optics",Items=Optics_List,Multi=false,
        Callback=function(v) CostumeState.Template.Optics = v or "None" end
    })
    STemplate:Dropdown({
        Name="Template Grips",Flag="cs_tmpl_grips",Items=Grips_List,Multi=false,
        Callback=function(v) CostumeState.Template.Grips = v or "None" end
    })
    STemplate:Dropdown({
        Name="Template Barrel",Flag="cs_tmpl_barrel",Items=Barrel_List,Multi=false,
        Callback=function(v) CostumeState.Template.Barrel = v or "None" end
    })
    STemplate:Dropdown({
        Name="Template Other",Flag="cs_tmpl_other",Items=Other_List,Multi=false,
        Callback=function(v) CostumeState.Template.Other = v or "None" end
    })
    STemplate:Dropdown({
        Name="Template Stocks",Flag="cs_tmpl_stocks",Items=Stocks_List,Multi=false,
        Callback=function(v) CostumeState.Template.Stocks = v or "None" end
    })

    -- ----------------------------------------------------------------
    -- LOADOUT FIRE BUTTONS & AUTO LOADOUT
    -- ----------------------------------------------------------------
    local SLoadoutFire = CostumeScriptPage:Section({Name="!sts — Fire & Auto Loadout", Side=2})
    SLoadoutFire:Button({
        Name="Fire !sts Loadout Now",
        Callback=function()
            FireLoadout()
        end
    })
    SLoadoutFire:Button({
        Name="Kill Self & Respawn (for loadout refresh)",
        Callback=function()
            KillAndRespawnLoadout()
        end
    })
    SLoadoutFire:Toggle({
        Name="Auto Loadout (fires on every respawn)",
        Flag="cs_auto_loadout",
        Default=false,
        Callback=function(s)
            if s then StartAutoLoadout() else StopAutoLoadout() end
        end
    })
    SLoadoutFire:Label("Auto Loadout fires 1s after respawn")

    -- Current command preview label
    SLoadoutFire:Label("Preview current !sts command:")
    SLoadoutFire:Button({
        Name="Copy !sts Command to Clipboard",
        Callback=function()
            local cmd = BuildStsCommand()
            if cmd then
                Utils.CopyToClipboard(cmd)
                Utils.Alert("Costume Script","Copied: "..cmd:sub(1,60).."...",5)
            else
                Utils.Alert("Costume Script","No weapons set!",4)
            end
        end
    })

    -- ----------------------------------------------------------------
    -- SINGLE WEAPON MODE (!s)
    -- ----------------------------------------------------------------
    local SSingle = CostumeScriptPage:Section({Name="!s — Single Weapon", Side=2})
    SSingle:Label("Fire a single weapon with attachments:")
    SSingle:Textbox({
        Flag="cs_single_weapon",
        Placeholder="Weapon name (e.g. de, Groza-4)...",
        Default="de",
        Callback=function(v)
            CostumeState.SingleWeapon = v or ""
        end
    })
    SSingle:Dropdown({
        Name="Single Optics",Flag="cs_single_optics",Items=Optics_List,Multi=false,
        Callback=function(v) CostumeState.SingleOptics = v or "None" end
    })
    SSingle:Dropdown({
        Name="Single Grips",Flag="cs_single_grips",Items=Grips_List,Multi=false,
        Callback=function(v) CostumeState.SingleGrips = v or "None" end
    })
    SSingle:Dropdown({
        Name="Single Barrel",Flag="cs_single_barrel",Items=Barrel_List,Multi=false,
        Callback=function(v) CostumeState.SingleBarrel = v or "None" end
    })
    SSingle:Dropdown({
        Name="Single Other",Flag="cs_single_other",Items=Other_List,Multi=false,
        Callback=function(v) CostumeState.SingleOther = v or "None" end
    })
    SSingle:Dropdown({
        Name="Single Stocks",Flag="cs_single_stocks",Items=Stocks_List,Multi=false,
        Callback=function(v) CostumeState.SingleStocks = v or "None" end
    })
    SSingle:Button({
        Name="Fire !s Single Weapon Now",
        Callback=function()
            FireSingle()
        end
    })

    -- ----------------------------------------------------------------
    -- ARMOR SECTION (!sa)
    -- ----------------------------------------------------------------
    local SArmor = CostumeScriptPage:Section({Name="!sa — Armor", Side=1})
    SArmor:Label("Select and equip armor:")
    SArmor:Dropdown({
        Name="Select Armor",
        Flag="cs_armor_select",
        Items=Armor_List,
        Multi=false,
        Default={"SWAT"},
        Callback=function(v)
            if v and v ~= "" then
                CostumeState.SelectedArmor = v
            end
        end
    })
    SArmor:Button({
        Name="Equip Armor Now",
        Callback=function()
            FireArmor()
        end
    })
    SArmor:Toggle({
        Name="Auto Armor (fires on every respawn)",
        Flag="cs_auto_armor",
        Default=false,
        Callback=function(s)
            if s then StartAutoArmor() else StopAutoArmor() end
        end
    })
    SArmor:Label("Auto Armor fires 1.5s after respawn")
    SArmor:Label("If Auto Loadout is ON, armor fires 0.5s after loadout")

    -- ----------------------------------------------------------------
    -- ARMOR KEYBIND SECTION
    -- ----------------------------------------------------------------
    local SArmorKeybind = CostumeScriptPage:Section({Name="Armor Repair Keybind", Side=2})
    SArmorKeybind:Label("Press keybind to re-equip/repair selected armor")
    SArmorKeybind:Label("Default keybind: H")
    SArmorKeybind:Dropdown({
        Name="Armor Keybind Key",
        Flag="cs_armor_kb",
        Items={
            "H","J","K","L","N","M","B","G","T","Y","U","I","O","P",
            "F1","F2","F3","F4","F5","F6","F7","F8","F9","F10",
            "Z","X","C","V","Q","E","R"
        },
        Multi=false,
        Default={"H"},
        Callback=function(sel)
            if sel then
                local ok, kc = pcall(function() return Enum.KeyCode[sel] end)
                if ok and kc then
                    SetArmorKeybind(kc)
                    Utils.Alert("Costume Script","Armor keybind set to: "..sel,3)
                end
            end
        end
    })
    SArmorKeybind:Label("Keybind instantly fires !sa for selected armor")
    SArmorKeybind:Label("Useful for repairing damaged armor mid-game")
    SArmorKeybind:Button({
        Name="Test Armor Keybind (Fire Now)",
        Callback=function()
            FireArmor()
        end
    })

    -- ----------------------------------------------------------------
    -- INFO SECTION
    -- ----------------------------------------------------------------
    local SInfo = CostumeScriptPage:Section({Name="Costume Script Info", Side=2})
    SInfo:Label("Version: "..COSTUME_SCRIPT_VERSION)
    SInfo:Label("Game: Town | ID: 17187552273")
    SInfo:Label("Gamepass ID: 9545602")
    SInfo:Label("Donation GP ID: 10010441")
    SInfo:Label("Commands used:")
    SInfo:Label("  !sts = SetSpawnItems (multi)")
    SInfo:Label("  !s   = Spawn single item")
    SInfo:Label("  !sa  = SpawnArmor")
end

-- SETTINGS
do
    local S1=SettingsPage:Section({Name="Config Manager", Side=1})
    S1:Label("Save / Load Config")
    S1:Button({Name="Save",Callback=function() SettingsManager:Save() end})
    S1:Button({Name="Load",Callback=function() SettingsManager:Load() end})
    S1:Button({Name="Reset",Callback=function() SettingsManager:Reset() end})

    local S2=SettingsPage:Section({Name="Panic", Side=1})
    S2:Toggle({Name="PANIC MODE",Flag="panic",Default=false,Callback=function(s) if s then ESP.Panic() end end})

    local S3=SettingsPage:Section({Name="Theme", Side=2})
    if Library.Theme then
        for Index, Value in Library.Theme do
            S3:Label(Index):Colorpicker({
                Name=Index, Flag="Theme"..Index, Default=Value,
                Callback=function(v) Library.Theme[Index]=v; Library:ChangeTheme(Index,v) end
            })
        end
    end
end

Library:Notification({Title="Ready!",Description="Hexa.lua "..SCRIPT_VERSION.." + Costume Script "..COSTUME_SCRIPT_VERSION.." Loaded!",Duration=3,Icon=84474740888511})

Window:Init()
print("===============================================")
print("CREDIT - Hexa.lua — Full Upgrade + Costume Script Update")
print("===============================================")
