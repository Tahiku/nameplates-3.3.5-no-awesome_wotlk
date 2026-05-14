

    -- Name Text
	-- Changes Font text

	-- HealthBar
	-- Adds Health % text on Target
	-- Adds Class Icons (squared)
	-- Adds recoloring of healthbar (depending on the GUID)

	-- Castingbar
	-- Adds CastingBars for non-targets (in Arena)
	-- Adds Time left of cast
	-- Adds spellName of the cast
	-- Adds recoloring of castbar (depending on the spell)

local activePlates = {}
local max, strformat = math.max, string.format
local ipairs, strfind = ipairs, string.find
local max, min = math.max, math.min

local RedName = {
    ["Viper"] = true,
    ["Venomous Snake"] = true,
}

local PinkName = {
    ["Lightwell"] = true,
}

local ShrinkPlates = {
    ["Tremor Totem"] = 1,
    ["Cleansing Totem"] = 1,
    ["Mana Tide Totem"] = 1,
    ["Grounding Totem"] = 1,
    ["Earthbind Totem"] = 0.8,
    ["Magma Totem"] = 0.75,
    ["Searing Totem"] = 0.75,
    ["Stoneclaw Totem"] = 0.75,
    ["Mana Spring Totem"] = 0.7,
    ["Healing Stream Totem"] = 0.7,
    ["Totem of Wrath"] = 0.65,
    ["Flametongue Totem"] = 0.65,
    ["Stoneskin Totem"] = 0.65,
    ["Windfury Totem"] = 0.65,
    ["Wrath of Air Totem"] = 0.65,
    ["Frost Resistance Totem"] = 0.65,
    ["Nature Resistance Totem"] = 0.65,
    ["Fire Resistance Totem"] = 0.6,
    ["Strength of Earth Totem"] = 0.6,
    ["Earth Elemental"] = 0.6,
    ["Fire Elemental"] = 0.6,
    ["Sentry Totem"] = 0.5,
    ["Viper"] = 0.5,
    ["Venomous Snake"] = 0.5,
    ["Bloodworm"] = 0.5,
    ["Ghoul"] = 0.8,
    ["Gargoyle"] = 1,
    ["Army of the Dead Ghoul"] = 0.5,
    ["Treant"] = 0.7,
    ["Spirit Wolf"] = 0.7,
    ["Shadowfiend"] = 1,
    ["Water Elemental"] = 0.8,
}

local HideNameplateUnits = {
    ["Vern"] = true,
    ["Underbelly Croc"] = true,
    ["Mirror Image"] = true
}

local ghoulPets = {
    "Risen", "Stone", "Eye", "Dirt", "Blight", "Bat", "Rat", "Corpse", "Grave", "Carrion",
    "Skull", "Bone", "Crypt", "Rib", "Brain", "Tomb", "Rot", "Gravel", "Plague",
    "Casket", "Limb", "Worm", "Earth", "Spine", "Pebble", "Root", "Marrow", "Hammer"
}

local cIcon = { -- Edited / flipped textures are: Priest, Rogue, Paladin, Druid, Shaman
    ["MAGE"]        = "Interface\\Icons\\inv_staff_13",
    ["WARRIOR"]     = "Interface\\Icons\\inv_sword_27",
    ["HUNTER"]      = "Interface\\Icons\\inv_weapon_bow_07",
    ["WARLOCK"]     = "Interface\\Icons\\spell_nature_drowsy",
    ["DEATHKNIGHT"] = "Interface\\Icons\\spell_deathknight_classIcon",
    ["DRUID"]       = "Interface\\AddOns\\NamePlates\\medias\\classicon_druid.blp",
    ["PALADIN"]     = "Interface\\AddOns\\NamePlates\\medias\\inv_hammer_100.blp",
    ["PRIEST"]      = "Interface\\AddOns\\NamePlates\\medias\\inv_staff_300", -- inv_staff_30
    ["ROGUE"]       = "Interface\\AddOns\\NamePlates\\medias\\inv_throwingknife_0400", -- inv_throwingknife_04
    ["SHAMAN"]      = "Interface\\AddOns\\NamePlates\\medias\\inv_jewelry_talisman_04", -- "Interface\\Icons\\spell_nature_bloodlust",
}


local spellColors = {
    ["Mass Dispel"] = { r = 0.1, g = 0.78, b = 0.92 },
    ["First Aid"] = { r = .97, g = .97, b = .97 },
    ["Hearthstone"] = { r = .97, g = .97, b = .97 },
    ["Attack"] = { r = .97, g = .97, b = .97 },
    ["Volley"] = { r = .97, g = .97, b = .97 },
    ["Steady Shot"] = { r = .97, g = .97, b = .97 },
    ["Shattering Throw"] = { r = .97, g = .97, b = .97 },
    ["War Stomp"] = { r = .97, g = .97, b = .97 },
    ["Basic Campfire"] = { r = .97, g = .97, b = .97 },
    ["Grand Spellstone"] = { r = .97, g = .97, b = .97 },
    ["Deadly Poison IX"] = { r = .97, g = .97, b = .97 },
    ["Wound Poison VII"] = { r = .97, g = .97, b = .97 },
    ["Crippling Poison"] = { r = .97, g = .97, b = .97 },
    ["Instant Poison IX"] = { r = .97, g = .97, b = .97 },
    ["Mind Numbing Poison"] = { r = .97, g = .97, b = .97 },
    ["Anesthetic Poison II"] = { r = .97, g = .97, b = .97 },
    ["Felsteed"] = { r = .97, g = .97, b = .97 },
    ["Dreadsteed"] = { r = .97, g = .97, b = .97 },
    ["Charger"] = { r = .97, g = .97, b = .97 },
    ["Warhorse"] = { r = .97, g = .97, b = .97 },
    ["Argent Charger"] = { r = .97, g = .97, b = .97 },
    ["Argent Warhorse"] = { r = .97, g = .97, b = .97 },
    ["Crimson Deathcharger"] = { r = .97, g = .97, b = .97 },
    ["Acherus Deathcharger"] = { r = .97, g = .97, b = .97 },
    ["Explode"] = { r = .97, g = .97, b = .97 },
    ["Pin"] = { r = .97, g = .97, b = .97 },
    ["Huddle"] = { r = .97, g = .97, b = .97 },

    -- PvE
    -- ["Empower"] = { r = .97, g = .97, b = .97 }, -- Test mob in Dragonblight
}

local trackedUnits = {
    "target", "mouseover", "focus",
    "arena1", "arena2", "arena3",
    "arenapet1", "arenapet2", "arenapet3",
    "party1", "party2", "party3",
    "partypet1", "partypet2", "partypet3",
}


local unitKeys = {}
local arenaNames = {}

local function isGhoul(name, unit)
    local _, instanceType = IsInInstance()
    if instanceType ~= "arena" then
        return false
    end
    if unit and UnitIsPlayer(unit) then
        return false
    end
    if name then
        if strfind(name, "Totem") then
            return false
        end
        for _, v in ipairs(ghoulPets) do
            if strfind(name, "^" .. v) then
                return true
            end
        end
    end
    return false
end


local function getWarlockPet(unit)
    local _, instanceType = IsInInstance()
    if instanceType == "arena" and unit then
        return UnitCreatureFamily(unit)
    end
    return nil
end


local function getSpellColor(spellName)
    local color = spellName and spellColors[spellName]
    if color then
        return color.r, color.g, color.b
    else
        return 1.0, 0.7, 0.0
    end
end


------------------------------------------------------------------------------------------------------------------------------------------

---- font scaling
---- Add this somewhere near your utilities:
-- local function UpdateFontScaling(plate)
    -- local uf = plate.UnitFrame
    -- if not uf then return end

    -- local scale = plate:GetScale() or 1
    -- if uf.lastScale and math.abs(uf.lastScale - scale) < 0.01 then -- Avoid constant updates (VERY IMPORTANT)
        -- return
    -- end

    -- uf.lastScale = scale

    ---- Base sizes (your defaults)
    -- local baseNameSize = 13
    -- local baseCastSize = 11
    -- local baseHPSize   = 10

    ---- Apply scaling (if you want to shrink the names)
	---- local nameSize = max(9, min(16, baseNameSize * scale))
	---- local castSize = max(7, baseCastSize * scale * 0.9)
	---- local hpSize   = max(7, baseHPSize * scale)

	---- Dampen scaling so fonts don't shrink as much
	-- local fontScale = 0.7 + (scale * 0.3)
	---- 70% fixed size, 30% follows plate scale

	-- local nameSize = max(10, min(16, baseNameSize * fontScale))
	-- local castSize = max(8, baseCastSize * fontScale)
	-- local hpSize   = max(8, baseHPSize * fontScale)

    ---- Apply fonts
    -- if uf.newName then
        -- uf.newName:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", nameSize, "OUTLINE") -- SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", nameSize, "OUTLINE")
    -- end
    -- if plate.castText then
        -- plate.castText:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", castSize, "OUTLINE") -- SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", castSize, "OUTLINE")
    -- end
    -- if plate.timer then
        -- plate.timer:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", castSize, "OUTLINE") -- SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", castSize, "OUTLINE")
    -- end
    -- if uf.hptext then
        -- uf.hptext:SetFont("Interface\\AddOns\\NamePlates\\Archangelsk.ttf", hpSize, "OUTLINE") -- SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", hpSize, "OUTLINE")
    -- end
-- end
-----------------------------------------------------------------------------------------------------------------------------------------

local function PlayerClassIcons(nameplate, unit, nameText)
    local _, instanceType = IsInInstance()
    if instanceType ~= "arena" then
        if nameplate.classTexture then
            nameplate.classTexture:Hide()
        end
        return
    end

    local iconTexture = nil
    if nameText then
        for i = 1, 3 do -- Ignoring 5s, non-existant
            local arenaUnit = "arena" .. i
            if UnitName(arenaUnit) == nameText then
                local _, unitClass = UnitClass(arenaUnit)
                iconTexture = cIcon and unitClass and cIcon[unitClass]
                break
            end
        end
    end

    if not iconTexture and unit and UnitIsPlayer(unit) then
        local _, unitClass = UnitClass(unit)
        iconTexture = cIcon and unitClass and cIcon[unitClass]
    end

    if not nameplate.classTexture then
        nameplate.classTexture = nameplate:CreateTexture(nil, "OVERLAY")
        nameplate.classTexture:SetSize(22.6, 22.6)
        -- nameplate.classTexture:SetTexCoord(.06, .94, .06, .94)
        nameplate.classTexture:SetPoint("RIGHT", nameplate, "RIGHT", 8, -5.8) -- ("RIGHT", nameplate, "RIGHT", 8, -7.4)
        nameplate.classTexture:Hide()
    end

    if iconTexture then
        nameplate.classTexture:SetTexture(iconTexture)
        nameplate.classTexture:Show()
    else
        nameplate.classTexture:Hide()
    end
end


local function RenameOrColorPlates(nameplate, unit, HealthBar, name)
    if name and RedName[name] and nameplate.newName then -- Snakes
        nameplate.newName:SetTextColor(1, 0, 0) -- (0.65, 0.12, 0.15)
	-- Lightwell
    elseif name and PinkName[name] and nameplate.newName then
        nameplate.newName:SetTextColor(.95, .75, .95) -- dark purple (0.45, 0.25, 0.95)
    elseif name and nameplate.newName then
        nameplate.newName:SetTextColor(1, 1, 1)
    end

    if nameplate.newName and name then
        local displayName = name

        if unit and strfind(unit, "arena") and not strfind(unit, "pet") then
            local _, type = IsInInstance()
            if type == "arena" then
                for i = 1, 3 do
                    if unit == ("arena" .. i) then
                        displayName = tostring(i)
                        break
                    end
                end
            end
        elseif strfind(name, "Cleansing Totem") then displayName = "Cleansing"; HealthBar:SetStatusBarColor(0, 1, 0.596)
        elseif strfind(name, "Mana Tide Totem") then displayName = "Mana Tide"; HealthBar:SetStatusBarColor(.1, .75, .65)
        elseif strfind(name, "Healing Stream Totem") then displayName = "Healing"
        elseif strfind(name, "Mana Spring Totem") then displayName = "MP5"
        elseif strfind(name, "Fire Resistance Totem") then displayName = "Fire Resist"
        elseif strfind(name, "Tremor Totem") then displayName = "Tremor"; HealthBar:SetStatusBarColor(1, 1, 0)
        elseif strfind(name, "Earthbind Totem") then displayName = "Earthbind"
        elseif strfind(name, "Stoneclaw Totem") then displayName = "Stoneclaw"
        elseif strfind(name, "Stoneskin Totem") then displayName = "Stoneskin"
        elseif strfind(name, "Strength of Earth Totem") then displayName = "Strength"
        elseif strfind(name, "Earth Elemental") then displayName = "Ele"
        elseif strfind(name, "Grounding Totem") then displayName = "Grounding"
        elseif strfind(name, "Windfury Totem") then displayName = "Windfury"
        elseif strfind(name, "Wrath of Air Totem") then displayName = "Haste"
        elseif strfind(name, "Nature Resistance Totem") then displayName = "Nature"
        elseif strfind(name, "Sentry Totem") then displayName = "Sentry"
        elseif strfind(name, "Magma Totem") then displayName = "Magma"
        elseif strfind(name, "Totem of Wrath") then displayName = "Wrath"
        elseif strfind(name, "Searing Totem") then displayName = "Searing"
        elseif strfind(name, "Flametongue Totem") then displayName = "Flametongue"
        elseif strfind(name, "Frost Resistance Totem") then displayName = "Frost Resist"
        elseif strfind(name, "Fire Elemental") then displayName = "Ele"
        elseif name == "Water Elemental" then
            displayName = "wele"
        elseif name == "Lightwell" then
            HealthBar:SetStatusBarColor(0.95, 0.75, 0.95) -- 1.0, 0.4, 0.8
        elseif name == "Shadowfiend" then
            displayName = "Fiend"
        elseif name == "Spirit Wolf" then
            displayName = " "
        elseif name == "Ebon Gargoyle" then
            displayName = "Gargoyle"
        elseif isGhoul(name, unit) then
            displayName = "Ghoul"
        else
            local family = getWarlockPet(unit)
            if family then
                if family == "Succubus" then
                    displayName = "Succubus"
                elseif family == "Felhunter" then
                    displayName = "Felhunter"
                elseif family == "Voidwalker" then
                    displayName = "Voidwalker"
                elseif family == "Felguard" then
                    displayName = "Felguard"
                elseif family == "Imp" then
                    displayName = "Imp"
                end
            end
        end

        nameplate.newName:SetText(displayName)
    end
end


local function PlateShowOrSize(nameplate, name, unit)
    if nameplate.isMirrorImage or (name and HideNameplateUnits[name]) then
        nameplate:Hide()
        if nameplate.castBar then
            nameplate.castBar:Hide()
        end
        return
    else
        nameplate:Show()
    end

    if nameplate:IsShown() then
        local scale = 1.2 
        if isGhoul(name, unit) and ShrinkPlates["Ghoul"] then
            scale = ShrinkPlates["Ghoul"]
        elseif name then
            for k, v in pairs(ShrinkPlates) do
                if strfind(name, k) then
                    scale = v
                    break
                end
            end
        end
        nameplate:SetScale(scale)
		-- UpdateFontScaling(nameplate) -- font scaling
		-- nameplate.castBar:SetScale(scale) -- abc
    end
end


local function InitNamePlate(plate)
    if plate.UnitFrame then
        return
    end

    local healthBar, castBar = plate:GetChildren()
    local threat, border, cbborder, cbshield, cbicon, overlay, origName, level, bossicon, raidicon, elite = plate:GetRegions()

    local UnitFrame = CreateFrame("Frame", nil, plate)
    UnitFrame:SetAllPoints(plate)
    UnitFrame:EnableMouse(false)
    plate.UnitFrame = UnitFrame

    healthBar:SetParent(UnitFrame)
    healthBar:SetFrameLevel(UnitFrame:GetFrameLevel() + 1)
    UnitFrame.healthBar = healthBar

    UnitFrame.castBar = castBar
    cbborder:SetTexture("Interface\\AddOns\\NamePlates\\textures\\nameplate-border-castbar")
    cbshield:SetTexture("Interface\\AddOns\\NamePlates\\textures\\nameplate-castbar-shield")

    UnitFrame.castBarBorder = cbborder
    UnitFrame.cbicon = cbicon
    UnitFrame.cbshield = cbshield
    cbicon:SetSize(16, 15) -- 16, 16
    cbicon:SetTexCoord(.1, .9, .1, .9)
    border:Hide()
    border:SetTexture(.3, .3, .3)

    local newBorder = CreateFrame("Frame", nil, healthBar)
    newBorder:SetSize(128, 16)
    newBorder:SetPoint("LEFT", healthBar, "LEFT", -4, 0)
    newBorder:SetFrameLevel(healthBar:GetFrameLevel() + 1)

    local borderTex = newBorder:CreateTexture(nil, "ARTWORK")
    borderTex:SetTexture("Interface\\AddOns\\NamePlates\\textures\\Nameplate-Border")
    borderTex:SetTexCoord(0, 1, .5, 1)
    borderTex:SetAllPoints()
    UnitFrame.border = newBorder

    cbicon:SetParent(newBorder)

    overlay:SetTexture(1, 1, 1, 0) 
    UnitFrame.origOverlay = overlay

    local name = UnitFrame:CreateFontString(nil, "ARTWORK")
    name:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", 13, "OUTLINE")

    name:SetWordWrap(false)

    name:SetPoint("BOTTOM", newBorder, "TOP", -7, 0.5)
    name:SetJustifyH("CENTER")
    name:SetTextColor(0.9, 0.9, 0.7)
    name:SetText(origName:GetText())
    origName:Hide()
    UnitFrame.newName = name
    UnitFrame.origName = origName

    level:SetAlpha(0)
    UnitFrame.origLevel = level

    elite:SetAlpha(0)
    elite:Hide()

    raidicon:SetParent(UnitFrame)
    raidicon:ClearAllPoints()
    raidicon:SetPoint("BOTTOM", newBorder, "TOP", 0, 18)
    raidicon:SetSize(22, 22)

    if not castBar then
        return
    end

    -- spell text
    if not plate.castText then
        plate.castText = plate:CreateFontString(nil, "ARTWORK", "SystemFont_Outline") 
        plate.castText:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", 11, "OUTLINE") -- plate.castText:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", 11, "OUTLINE")
        plate.castText:SetSize(150, 16) -- 120, 16
        -- plate.castText:SetPoint("CENTER", castBar, "CENTER", -20, 0.5) -- plate.castText:SetPoint("CENTER", castBar, "CENTER", -20, 1)
        -- plate.castText:SetJustifyH("RIGHT")
    end

    -- time
    if not plate.timer then
        plate.timer = plate:CreateFontString(nil, "ARTWORK", "SystemFont_Outline")
        plate.timer:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", 11, "OUTLINE")
        plate.timer:SetSize(150, 16)
        plate.timer:SetPoint("RIGHT", castBar, "RIGHT", 86, 0) -- ("RIGHT", castBar, "RIGHT", 92, 0)
    end

    -- hp text
    if not UnitFrame.hptext then
        UnitFrame.hptext = newBorder:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
        UnitFrame.hptext:SetFont("Interface\\AddOns\\NamePlates\\Archangelsk.ttf", 10, "OUTLINE")
        UnitFrame.hptext:SetPoint("CENTER", healthBar, "CENTER", 2, 0)
        UnitFrame.hptext:SetJustifyH("CENTER")
        UnitFrame.hptext:SetTextColor(1, 1, 1)
    end

    -- Spark
    if not plate.barSpark then
        plate.barSpark = plate:CreateTexture(nil, "OVERLAY")
        plate.barSpark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        plate.barSpark:SetSize(14, 28) -- 32, 32
        plate.barSpark:SetPoint("CENTER", castBar, 0, 0)
        plate.barSpark:SetBlendMode("ADD")
    end

	-- UpdateFontScaling(plate)
end


local function TimerHook(self, elapsed, value, maxValue, casting)
    if not self.timer then
        return
    end
    self.update = (self.update or 0) - elapsed
    if self.update <= 0 then
        local remainingTime = 0
        if casting then
            remainingTime = max(maxValue - value, 0)
        elseif not casting then
            remainingTime = max(value, 0)
        end
        if remainingTime <= 0 then
            self.timer:SetAlpha(0)
        else
            self.timer:SetText(strformat("%.1f", remainingTime))
            self.timer:SetAlpha(1)
        end
        self.update = 0.1
    end
end


local function CastBarPosition(frame, point, relativeTo, relativePoint, xOfs, yOfs)
    local p, relTo, relPoint, x, y = frame:GetPoint()
    if p ~= point or relTo ~= relativeTo or relPoint ~= relativePoint or x ~= xOfs or y ~= yOfs then
        frame:ClearAllPoints()
        frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
end


local function NamePlate_OnShow(plate)
    local uf = plate.UnitFrame
    if not uf then
        return
    end

    local name = uf.origName:GetText()

    if name and not uf.unit and unitKeys[name] then
        uf.unit = unitKeys[name]
    end

    if uf.origLevel then
        uf.origLevel:SetAlpha(0)
        uf.origLevel:Hide()
    end

    uf.healthBar:ClearAllPoints()
    uf.healthBar:SetPoint("BOTTOM", uf, "BOTTOM", 0, 4)
    uf.healthBar:SetSize(103, 10)
    RenameOrColorPlates(uf, uf.unit, uf.healthBar, name)
    PlateShowOrSize(uf, name, uf.unit)
    PlayerClassIcons(plate, uf.unit, name)
end


local scanFrame = CreateFrame("Frame")
local numChildren = -1
local updateTimer = 0

scanFrame:SetScript("OnUpdate", function(self, elapsed)
    updateTimer = updateTimer + elapsed
    if updateTimer > 0.1 then
        wipe(unitKeys)
        wipe(arenaNames)

        for i = 1, 3 do
            local unit = "arena" .. i
            if UnitExists(unit) then
                local name = UnitName(unit)
                if name then
                    arenaNames[name] = true
                end
            end
        end

        for _, unit in ipairs(trackedUnits) do
            if UnitExists(unit) then
                local name = UnitName(unit)
                if name then
                    if not unitKeys[name] or strfind(unit, "arena") or strfind(unit, "party") then
                        unitKeys[name] = unit
                    end
                end
            end
        end
        updateTimer = 0
    end


    local count = WorldFrame:GetNumChildren()
    if count ~= numChildren then
        numChildren = count
        for _, frame in ipairs({WorldFrame:GetChildren()}) do
            if not frame:GetName() and not activePlates[frame] then
                local region1, region2 = frame:GetRegions()
                if region2 and region2:GetObjectType() == "Texture" and region2:GetTexture() == "Interface\\Tooltips\\Nameplate-Border" then
                    activePlates[frame] = true
                    InitNamePlate(frame)
                    frame:HookScript("OnShow", function(self) NamePlate_OnShow(self) end)
                    frame:HookScript("OnHide", function(self) 
                        self.UnitFrame.unit = nil 
                        self.UnitFrame.isMirrorImage = false
                    end)
                    NamePlate_OnShow(frame)
                end
            end
        end
    end


---------------------------------------------------------------------------------------------------
    for nameplate in pairs(activePlates) do
        if nameplate:IsShown() then
		    -- nameplate:SetAlpha(1) ---- disable for target nameplate detection method
            local uf = nameplate.UnitFrame
			-- local uf = nameplate.UnitFrame
			local hptext = uf and uf.hptext
			if hptext then
				if nameplate:GetAlpha() == 1 and UnitIsUnit("target", uf.unit or "") then
					local maxhp = UnitHealthMax("target")

					if maxhp > 0 then
					    local hp = (UnitHealth("target") / maxhp) * 100
						local hpRounded = floor(hp + 0.5)
						if hp == hpRounded then
	                        hptext:SetText(hpRounded)
                        else
                            hptext:SetText(strformat("%.1f", hp))
                        end
						hptext:Show()
					end
				else
					hptext:Hide()
				end
			end
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
            if uf then
                local name = uf.origName:GetText()

                if name then
                    local nameChanged = (uf.lastName ~= name)
                    uf.lastName = name

                    if unitKeys[name] then
                        local r, g, b = uf.healthBar:GetStatusBarColor()

                        if arenaNames[name] and r > 0.8 and g < 0.2 and b < 0.2 then
                            uf.isMirrorImage = true
                            PlateShowOrSize(uf, name, nil)
                        else
                            uf.isMirrorImage = false
                            if uf.unit ~= unitKeys[name] or nameChanged then
                                uf.unit = unitKeys[name]
                                PlayerClassIcons(nameplate, uf.unit, name)
                                RenameOrColorPlates(uf, uf.unit, uf.healthBar, name)
                                PlateShowOrSize(uf, name, uf.unit)
                            end
                        end
                    else
                        if uf.unit ~= nil or nameChanged then
                            uf.unit = nil
                            PlayerClassIcons(nameplate, nil, name)
                            RenameOrColorPlates(uf, nil, uf.healthBar, name)
                            PlateShowOrSize(uf, name, nil)
                        end
                    end
                end

                if not uf.isMirrorImage then
                    local cb = uf.castBar
                    if cb then
                        local castName, texture, startTime, endTime, notInterruptible
                        local isChanneling = false
                        local hasManualCast = false
                        local value, maxValue = 0, 0

                        if uf.unit then
                            castName, _, _, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(uf.unit)
                            if castName then
                                hasManualCast = true
                            else
                                castName, _, _, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(uf.unit)
                                if castName then
                                    hasManualCast = true
                                    isChanneling = true
                                end
                            end
                        end

                        if hasManualCast then
                            local now = GetTime() * 1000
                            maxValue = (endTime - startTime) / 1000
                            if isChanneling then
                                value = (endTime - now) / 1000
                            else
                                value = (now - startTime) / 1000
                            end
                            
                            cb:SetMinMaxValues(0, maxValue)
                            cb:SetValue(value)
                            
                            if not cb:IsShown() then 
                                cb:Show() 
                            end
                            
                            if uf.cbicon and texture then
                                uf.cbicon:SetTexture(texture)
                            end
                            
                            if uf.cbshield then
                                if notInterruptible then uf.cbshield:Show() else uf.cbshield:Hide() end
                            end
                        end

                        if hasManualCast or cb:IsShown() then
                            if not hasManualCast then
                                value = cb:GetValue()
                                _, maxValue = cb:GetMinMaxValues()
                            end

                            if maxValue > 0 then
                                CastBarPosition(uf.castBar, "BOTTOMRIGHT", uf.healthBar, "BOTTOMRIGHT", 26, -16)
                                CastBarPosition(uf.castBarBorder, "CENTER", nameplate, "CENTER", 35, -15.581398151124)
                                CastBarPosition(uf.cbicon, "CENTER", uf.castBarBorder, "BOTTOMLEFT", -6, 8) -- -7, 8)
                                CastBarPosition(uf.cbshield, "CENTER", uf, "CENTER", 13, -26.581398151124)

                                uf.castBarBorder:Show()
                                uf.cbicon:Show()

                                local r, g, b = getSpellColor(castName)
                                cb:SetStatusBarColor(r, g, b)

								-- abc
								-- if uf.cbshield:IsShown() then
									-- cb:SetStatusBarColor(0.97, 0.97, 0.97)
								-- end

                                -- if nameplate.castText then
                                    -- nameplate.castText:SetText(castName or "")
                                    -- if not nameplate.castText:IsShown() then nameplate.castText:Show() end
                                -- end

------------------------------ abc ------------------------------------------------------------------------------------------------------------------
								-- if nameplate.castText then
									-- local text = castName or ""
									-- nameplate.castText:SetText(text)
									-- local textWidth = nameplate.castText:GetStringWidth() ---- Dynamically adjust position based on text width
									-- if textWidth < 16 then -- abc
										-- nameplate.castText:SetPoint("CENTER", cb, "CENTER", 0, 1)
										-- nameplate.castText:SetJustifyH("CENTER")
									-- else
										-- nameplate.castText:SetPoint("LEFT", cb, "LEFT", -2, 1)
										-- nameplate.castText:SetJustifyH("LEFT")
									-- end

									-- nameplate.castText:ClearAllPoints()
									-- nameplate.castText:SetPoint("LEFT", cb, "LEFT", -2, 1) ---- Anchor from LEFT so it grows left naturally

									-- Optional clamp: prevent overflow into icon
									-- local maxWidth = cb:GetWidth() - 20
									-- if textWidth > maxWidth then
										-- nameplate.castText:SetWidth(maxWidth)
										-- nameplate.castText:SetWordWrap(false)
										-- nameplate.castText:SetJustifyH("LEFT")
									-- else
										-- nameplate.castText:SetWidth(0) ---- auto size
									-- end
									-- nameplate.castText:Show()
									-- if not nameplate.castText:IsShown() then nameplate.castText:Show() end
								-- end

								-- opt 2
								if nameplate.castText then
									local text = castName or ""
									nameplate.castText:SetText(text)
									local textWidth = nameplate.castText:GetStringWidth()
									-- nameplate.castText:SetText(text)

									if textWidth < 16 then
										nameplate.castText:SetPoint("CENTER", cb, "CENTER", 0, 0.5)
										nameplate.castText:SetJustifyH("CENTER")
									else
										nameplate.castText:SetPoint("LEFT", cb, "LEFT", 2, 0.5)
										nameplate.castText:SetJustifyH("LEFT")
									end
									if not nameplate.castText:IsShown() then nameplate.castText:Show() end
								end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                if math.ceil(nameplate:GetAlpha()) == 1 and UnitExists("target") then
                                    TimerHook(nameplate, elapsed, value, maxValue, not isChanneling)
                                else
                                    if nameplate.timer and nameplate.timer:GetAlpha() > 0 then
                                        nameplate.timer:SetAlpha(0)
                                    end
                                end

                                if nameplate.barSpark then
                                    local sparkPosition = (value / maxValue) * cb:GetWidth()
                                    nameplate.barSpark:SetPoint("CENTER", cb, "LEFT", sparkPosition, -0.4)
                                    if not nameplate.barSpark:IsShown() then nameplate.barSpark:Show() end
                                end
                            end
                        else
                            cb:Hide()
                            uf.castBarBorder:Hide()
                            uf.cbicon:Hide()
                            cb:SetStatusBarColor(1.0, 0.7, 0.0)
                            if nameplate.castText then nameplate.castText:Hide() end
                            if nameplate.barSpark then nameplate.barSpark:Hide() end
                            if nameplate.timer then nameplate.timer:SetAlpha(0) end
                            if uf.cbshield then uf.cbshield:Hide() end
                        end
                    end
                end
            end
        end
    end
end)
