local Config = {}

Config.Setup = {
    ['Kame'] = {
        Combo = {
            {text = 'combo impact', cooldown = 5, targetDistance = 8, targetLife = 90},
            {text = 'old striker', cooldown = 5, targetDistance = 8, targetLife = 80},
            {text = 'turtle devastation', cooldown = 1, targetDistance = 8, targetLife = 100},
        },
        AntiRed = {
            {targetSpells = 'combo impact, old striker, turtle devastation', areaSpell = 'full spirit'},
        },
        Buff = {
            {spell = 'ultimate old power', cooldown = 30},
        },
    },
    ['Cooler'] = {
        Combo = {
            {text = 'combo impact', cooldown = 5, targetDistance = 8, targetLife = 90},
            {text = 'old striker', cooldown = 5, targetDistance = 8, targetLife = 80},
            {text = 'nova blast', cooldown = 1, targetDistance = 8, targetLife = 100},
        },
        AntiRed = {
            {targetSpells = 'combo impact, old striker, nova blast', areaSpell = 'psycho barrier'},
        },
        Buff = {
            {spell = 'ultimate old power', cooldown = 30},
        },
    },
    ['Kaio'] = {
        Combo = {
            {text = 'combo impact', cooldown = 5, targetDistance = 8, targetLife = 90},
            {text = 'old striker', cooldown = 5, targetDistance = 8, targetLife = 80},
            {text = 'supreme blast', cooldown = 1, targetDistance = 8, targetLife = 100},
        },
        AntiRed = {
            {targetSpells = 'combo impact, old striker, supreme blast', areaSpell = 'shockwave'},
        },
        Buff = {
            {spell = 'ultimate old power', cooldown = 30},
        },
    },
    ['Goku Anjo'] = {
        Combo = {
            {text = 'angel fist dragon', cooldown = 3, targetDistance = 8, targetLife = 90},
            {text = 'old striker', cooldown = 3, targetDistance = 8, targetLife = 80},
            {text = 'chybie angel', cooldown = 1, targetDistance = 8, targetLife = 100},
        },
        AntiRed = {
            {targetSpells = 'angel fist dragon, old striker, chybie angel', areaSpell = 'power angel destruction'},
        },
        Buff = {
            {spell = 'ultimate old power', cooldown = 30},
        },
    },
    ['Janemba'] = {
        Combo = {
            {text = 'combo impact', cooldown = 5, targetDistance = 8, targetLife = 90},
            {text = 'old striker', cooldown = 5, targetDistance = 8, targetLife = 80},
            {text = 'sword throw', cooldown = 1, targetDistance = 8, targetLife = 100},
        },
        AntiRed = {
            {targetSpells = 'combo impact, old striker, sword throw', areaSpell = 'demon fury'},
        },
        Buff = {
            {spell = 'ask for moon power', cooldown = 30},
        },
    },
}

local notFound = false;

checkVoc = macro(100, function()
    if notFund then return; end
    if not vocacaoLogada then
        g_game.look(player)
    else
        checkVoc.setOff()
    end
end)

--You see você mesmo. Você é Super Uub Reborn.

getVocationFromString = function(str)
    local strStart = str:find(".")
    local strEnd = str:find("Reborn")
    if (not strStart or not strEnd) then return; end
    return str:sub(strStart + 26, strEnd - 1):trim()
end


vocacaoLogada = nil

onTextMessage(function(mode, text)
    if vocacaoLogada then return; end
    if text:find('You see') then
        local vocation = getVocationFromString(text)
        if vocation then
            vocacaoLogada = Config.Setup[vocation]
            modules.game_textmessage.displayGameMessage('Voc�o encontrada e definida, voca��o: ' .. vocation)
        end
        if not Config.Setup[vocation] then
            modules.game_textmessage.displayGameMessage('Vocação não encontrada.')
            notFound = true;
        end
    end
end)





------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------- [[ COMBO ]] -------------------------------------------------------------------------------

local scriptCombo = macro(100, "Combo", function()
    local target, pos = g_game.getAttackingCreature(), pos()
    if not vocacaoLogada then return; end
    if not g_game.isAttacking() then return; end
    if target and target:getPosition() then
        targetPos = getDistanceBetween(pos, target:getPosition())
        targetHealth = target:getHealthPercent()
        for index, value in ipairs(vocacaoLogada.Combo) do
            if targetPos <= value.targetDistance and targetHealth <= value.targetLife then
                if (not value.cooldownSpells or value.cooldownSpells <= now) then
                    say(value.text)
                end
            end
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------- [[ UTILITES ]] --------------------------------------------------------------------------------

macro(100, "Buff", function()
    if isInPz() then return; end
    if not vocacaoLogada then return; end
    for index, value in ipairs(vocacaoLogada.Buff) do
        if (not value.cooldownBuff or value.cooldownBuff <= now) then
            say(value.spell)
        end
    end
end)

macro(100, "Senzu", function()
    if hppercent() < 100 or manapercent() < 95 then
        if not (Config.cdSenzu or Config.cdSenzu <= now) then
            useWith(11862, player)
        end
    end
end)

macro(100, "Regeneration", function()
    if hppercent() >= 100 then return; end
    if (not Config.cdRegen or Config.cdRegen <= now) then
        say('big regeneration')
    end
end)

macro(100, "Mystic Full", function()
    if isInPz() then return; end
    if level() < 75 then return; end
    say('mystic defense')
    delay(2500)
end)

macro(100, function()
    if hasHaste() then return; end
    if level() < 100 then
        say('super speed')
    else
        say('speed up')
    end
end)

macro(100, "Stamina", function()
    if stamina() <= 20*60 then
        if not findItem(11372) then return; end
        useWith(11372, player)
    end
end)

macro(1000, "Open Next BP", function()
    for _, c in pairs(getContainers()) do
        if #c:getItems() == 1 then
            local nextC = c:getItems()[1]
            if nextC and nextC:isContainer() then
                g_game.open(nextC)
                return g_game.close(c)
            end
        end
    end
end)


macro(200, "Keep Open Main BP", function()
    if not getContainers()[0] and getBack() then
        g_game.open(getBack())
    end
end)

onTalk(function(name, level, mode, text, channelId, pos)
    if name ~= player:getName() then return; end
    if not vocacaoLogada then return; end
    text = text:lower()
    for index, value in ipairs(vocacaoLogada.Combo) do
        value.text = value.text:lower():trim()
        if text == value.text then
            value.cooldownSpells = now + (value.cooldown * 1000)
            break
        end
    end
    for index, value in ipairs(vocacaoLogada.Buff) do
        if text == value.spell then
            value.cooldownBuff = now + (value.cooldown * 1000)
            break
        end
    end
    if text == 'big regeneration' then
        s.cdRegen = now + 1000
    elseif text == 'aaahhh! muito melhor!' then
        s.cdSenzu = now + 1500
    end
end)

local bugMap = {};

bugMap.checkBox = setupUI([[
CheckBox
  id: checkBox
  font: cipsoftFont
  text: Use Diagonal
]]);

bugMap.checkBox.onCheckChange = function(widget, checked)
    storage.bugMapCheck = checked;
end

if storage.bugMapCheck == nil then
	storage.bugMapCheck = true;
end

bugMap.checkBox:setChecked(storage.bugMapCheck);

bugMap.isKeyPressed = modules.corelib.g_keyboard.isKeyPressed;

bugMap.directions = {
    ["W"] = {x = 0, y = -5, direction = 0},
    ["E"] = {x = 3, y = -3},
    ["D"] = {x = 5, y = 0, direction = 1},
    ["C"] = {x = 3, y = 3},
    ["S"] = {x = 0, y = 5, direction = 2},
    ["Z"] = {x = -3, y = 3},
    ["A"] = {x = -5, y = 0, direction = 3},
    ["Q"] = {x = -3, y = 3}
};

bugMap.macro = macro(1, "Bug Map", function()
    if (modules.game_console:isChatEnabled() or modules.corelib.g_keyboard.isCtrlPressed()) then return; end
    local pos = pos();
    for key, config in pairs(bugMap.directions) do
        if (bugMap.isKeyPressed(key)) then
            if (storage.bugMapCheck or config.direction) then
                if (config.direction) then
					turn(config.direction);
				end
                local tile = g_map.getTile({x = pos.x + config.x, y = pos.y + config.y, z = pos.z});
                if (tile) then
					return g_game.use(tile:getTopUseThing());
				end
            end
        end
    end
end)

TH = macro(100, "Hide Messages", function() end)
onStaticText(function(thing, text)
    if TH.isOff() then return end
    if not text:find('says:') then
        g_map.cleanTexts()
    end
end)

sprh = macro(100, "Hide Sprites", function() end)
onAddThing(function(tile, thing)
    if sprh.isOff() then return end
    if thing:isEffect() then
        thing:hide()
    end
end)

local high_ram = false
macro(1, function()
        if not g_window.isVisible() and not high_ram then
            modules.game_bot.g_adaptiveRenderer.setLevel(4)
            modules.game_bot.g_app.setSmooth()
            modules.game_bot.g_app.setMaxFps(5)
		high_ram = false
        else
            modules.game_bot.g_adaptiveRenderer.setLevel(0)
            modules.game_bot.g_app.setSmooth("false")
            modules.game_bot.g_app.setMaxFps(60)
	high_ram = true
        end
end)

local moneyIds = {3031, 3035, 12578} -- gold coin, platinium coin
macro(1000, "Exchange money", function()
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(moneyIds) do
            if item:getId() == moneyId then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------- [[ ANTI RED ]] --------------------------------------------------------------------------------

storage.widgetPos = storage.widgetPos or {};

local antiRedTimeWidget = setupUI([[
UIWidget
  background-color: black
  opacity: 0.8
  padding: 0 5
  focusable: true
  phantom: false
  draggable: true
]], g_ui.getRootWidget());

local isMobile = modules._G.g_app.isMobile();
g_keyboard = g_keyboard or modules.corelib.g_keyboard;

local isDragKeyPressed = function()
	return isMobile and g_keyboard.isKeyPressed("F2") or g_keyboard.isCtrlPressed();
end

antiRedTimeWidget.onDragEnter = function(widget, mousePos)
	if (not isDragKeyPressed()) then return; end
	widget:breakAnchors();
	local widgetPos = widget:getPosition();
	widget.movingReference = {x = mousePos.x - widgetPos.x, y = mousePos.y - widgetPos.y};
	return true;
end

antiRedTimeWidget.onDragMove = function(widget, mousePos, moved)
	local parentRect = widget:getParent():getRect();
	local x = math.min(math.max(parentRect.x, mousePos.x - widget.movingReference.x), parentRect.x + parentRect.width - widget:getWidth());
	local y = math.min(math.max(parentRect.y - widget:getParent():getMarginTop(), mousePos.y - widget.movingReference.y), parentRect.y + parentRect.height - widget:getHeight());   
	widget:move(x, y);
	storage.widgetPos.antiRedTime = {x = x, y = y};
	return true;
end

local name = "antiRedTime";
storage.widgetPos[name] = storage.widgetPos[name] or {};
antiRedTimeWidget:setPosition({x = storage.widgetPos[name].x or 50, y = storage.widgetPos[name].y or 50});

if (not getSpectators or #getSpectators(true) == 0) then
	getSpectators = function()
		local specs = {};
		local tiles = g_map.getTiles(posz());
		for i = 1, #tiles do
			local tile = tiles[i];
			local creatures = tile:getCreatures();
			for _, spec in ipairs(creatures) do
				table.insert(specs, creature);
			end
		end
		return specs;
	end
end

if (not storage.antiRedTime or storage.antiRedTime - 30000 > now) then
	storage.antiRedTime = 0;
end

local addAntiRedTime = function()
	storage.antiRedTime = now + 30000;
end

local toInteger = function(number)
	number = tostring(number);
	number = number:split(".");
	return tonumber(number[1]);
end



macro(1, "Anti-Red", function()
    if not vocacaoLogada then return; end
	local pos, monstersCount = pos(), 0;
	if (player:getSkull() >= 3) then
		addAntiRedTime();
	end
	local specs = getSpectators(true);
    for _, spell in ipairs(vocacaoLogada.AntiRed) do
	for _, spec in ipairs(specs) do
		local specPos = spec:getPosition();
		local floorDiff = math.abs(specPos.z - pos.z);
		if (floorDiff > 3) then 
			goto continue;
		end
		if (spec ~= player and spec:isPlayer() and spec:getEmblem() ~= 1 and spec:getShield() < 3) then
			addAntiRedTime();
			break
		elseif (floorDiff == 0 and spec:isMonster() and getDistanceBetween(specPos, pos) == 1) then
			monstersCount = monstersCount + 1;
		end
		::continue::
	end
	if (storage.antiRedTime >= now) then
		antiRedTimeWidget:show();
		local diff = storage.antiRedTime - now;
		diff = diff / 1000;
		antiRedTimeWidget:setText(tr("Area blocked for %ds.", toInteger(diff)));
		antiRedTimeWidget:setColor("red");
	elseif (not antiRedTimeWidget:isHidden()) then
		antiRedTimeWidget:hide();
	end
	if (monstersCount > 1 and storage.antiRedTime < now) then
		return say(spell.areaSpell);
	end
	if (not g_game.isAttacking()) then return; end
        local saySpells = spell.targetSpells:split(',');
        for _, targetSpell in ipairs(saySpells) do
        say(targetSpell);
        end
	end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------- [[ BLESS ]] --------------------------------------------------------------------------------



local CONFIG = {
    BLESS_COMMAND = '!bless', -- comando p comprar a bless
    BLESS_PRICE = 10, -- golds
    BLESS_MONEY = 'ja esta com bless', -- messagem se ja tem bless.
    BLESS_NOTMONEY = 'gold coins to get', -- mensagem se não tem gold
    UPDATE_GOLD = true, -- se estiver true, vai ficar atualizando a quantidade de gold
    ID_GOLD = 3043, -- id do gold
    ID_DOLLAR = 3035,  -- id do dolar
    TEXT_GOLD = 'Using one of ([0-9]+) Golds...' -- texto de qndo vc usa o gold, não altere o () e o que está dentro
}

storage.widgetPos = storage.widgetPos or {}

local widgetConfig = [[
UIWidget
  background-color: black
  opacity: 0.8
  padding: 0 5
  focusable: true
  phantom: false
  draggable: true
  text-auto-resize: true

]]

local blessWidget = {}

blessWidget['goldWidget'] = setupUI(widgetConfig, g_ui.getRootWidget())
blessWidget['blessWidget'] = setupUI(widgetConfig, g_ui.getRootWidget())

local function attachSpellWidgetCallbacks(key)
    blessWidget[key].onDragEnter = function(widget, mousePos)
        if not modules.corelib.g_keyboard.isCtrlPressed() then
            return false
        end
        widget:breakAnchors()
        widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
        return true
    end

    blessWidget[key].onDragMove = function(widget, mousePos, moved)
        local parentRect = widget:getParent():getRect()
        local x = math.min(math.max(parentRect.x, mousePos.x - widget.movingReference.x), parentRect.x + parentRect.width - widget:getWidth())
        local y = math.min(math.max(parentRect.y - widget:getParent():getMarginTop(), mousePos.y - widget.movingReference.y), parentRect.y + parentRect.height - widget:getHeight())
        widget:move(x, y)
        return true
    end

    blessWidget[key].onDragLeave = function(widget, pos)
        storage.widgetPos[key] = {}
        storage.widgetPos[key].x = widget:getX();
        storage.widgetPos[key].y = widget:getY();
        return true
    end
end

for key, value in pairs(blessWidget) do
    attachSpellWidgetCallbacks(key)
    blessWidget[key]:setPosition(
        storage.widgetPos[key] or {0, 50}
    )
end

local goldCount = 0;
onTextMessage(function(mode, text)
    if text:find(CONFIG.TEXT_GOLD) then
        goldCount = tonumber(text:match("%d+"))
        blessWidget['goldWidget']:setText('Golds: ' .. goldCount)
    end
end)
storage.haveBless = false
local blessScript = macro(100, "Bless", function()
    if not storage.haveBless then
        NPC.say(CONFIG.BLESS_COMMAND)
        delay(1000)
        blessWidget['blessWidget']:setText("Bless: None | Bless Restante: " .. math.floor(goldCount / CONFIG.BLESS_PRICE))
        blessWidget['blessWidget']:setColor("red")
    else
        blessWidget['blessWidget']:setText("Bless: True | Bless Restante: " .. math.floor(goldCount / CONFIG.BLESS_PRICE))
        blessWidget['blessWidget']:setColor("green")
    end
end)


macro(1, function()
    if blessScript.isOff() then return; end
    if CONFIG.UPDATE_GOLD then
        if findItem(CONFIG.ID_GOLD) and (not X or X <= os.time()) then
            use(CONFIG.ID_GOLD)
            delay(400)
        end
        if findItem(CONFIG.ID_DOLLAR) then
            use(CONFIG.ID_DOLLAR)
            X = os.time() + 180
        end
    end
end)

onTextMessage(function(mode, text)
    if blessScript.isOff() then return; end
    if text:lower():find(CONFIG.BLESS_NOTMONEY) then
        storage.haveBless = false
    end
    if text:lower():find(CONFIG.BLESS_MONEY) then
        storage.haveBless = true
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------- [[ REVIDE ]] --------------------------------------------------------------------------------



local ignoreEmblems = {1,4} -- Guild Emblems (Allies)

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Fight Back (Revide)')
    font: verdana-11px-rounded

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
    font: verdana-11px-rounded
]])

local edit = setupUI([[
RevideBox < CheckBox
  font: verdana-11px-rounded
  margin-top: 5
  margin-left: 5
  anchors.top: prev.bottom
  anchors.left: parent.left
  anchors.right: parent.right
  color: lightGray

Panel
  height: 123

  RevideBox
    id: pauseTarget
    anchors.top: parent.top
    text: Pause TargetBot 
    !tooltip: tr('Pause TargetBot While fighting back.')

  RevideBox
    id: pauseCave
    text: Pause CaveBot 
    !tooltip: tr('Pause CaveBot While fighting back.')

  RevideBox
    id: followTarget
    text: Follow Target 
    !tooltip: tr('Set Chase Mode to Follow While fighting back.')

  RevideBox
    id: ignoreParty
    text: Ignore Party Members

  RevideBox
    id: ignoreGuild
    text: Ignore Guild Members

  RevideBox
    id: attackAll
    text: Attack All Skulled
    !tooltip: tr("Attack every skulled player, even if he didn't attacked you.")

  BotTextEdit
    id: esc
    width: 83
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    text: Escape
    color: red
    font: verdana-11px-rounded

  Label
    text: Cancel Attack:
    font: verdana-11px-rounded
    anchors.left: parent.left
    margin-left: 5
    anchors.verticalCenter: esc.verticalCenter
]])
edit:hide()

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end
-- End Basic UI

-- Storage
local st = "RevideFight"
storage[st] = storage[st] or {
  enabled = false,
  pauseTarget = true,
  pauseCave = true,
  followTarget = true,
  ignoreParty = false,
  ignoreGuild = false,
  attackAll = false,
  esc = "Escape",
}
local config = storage[st]

-- UI Functions
-- Main Button
ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

-- Checkboxes
do
  edit.pauseTarget:setChecked(config.pauseTarget)
  edit.pauseTarget.onClick = function(widget)
    config.pauseTarget = not config.pauseTarget
    widget:setChecked(config.pauseTarget)
    widget:setImageColor(config.pauseTarget and "green" or "red")
  end
  edit.pauseTarget:setImageColor(config.pauseTarget and "green" or "red")
  
  edit.pauseCave:setChecked(config.pauseCave)
  edit.pauseCave.onClick = function(widget)
    config.pauseCave = not config.pauseCave
    widget:setChecked(config.pauseCave)
    widget:setImageColor(config.pauseCave and "green" or "red")
  end
  edit.pauseCave:setImageColor(config.pauseCave and "green" or "red")

  edit.followTarget:setChecked(config.followTarget)
  edit.followTarget.onClick = function(widget)
    config.followTarget = not config.followTarget
    widget:setChecked(config.followTarget)
    widget:setImageColor(config.followTarget and "green" or "red")
  end
  edit.followTarget:setImageColor(config.followTarget and "green" or "red")

  edit.ignoreParty:setChecked(config.ignoreParty)
  edit.ignoreParty.onClick = function(widget)
    config.ignoreParty = not config.ignoreParty
    widget:setChecked(config.ignoreParty)
    widget:setImageColor(config.ignoreParty and "green" or "red")
  end
  edit.ignoreParty:setImageColor(config.ignoreParty and "green" or "red")

  edit.ignoreGuild:setChecked(config.ignoreGuild)
  edit.ignoreGuild.onClick = function(widget)
    config.ignoreGuild = not config.ignoreGuild
    widget:setChecked(config.ignoreGuild)
    widget:setImageColor(config.ignoreGuild and "green" or "red")
  end
  edit.ignoreGuild:setImageColor(config.ignoreGuild and "green" or "red")

  edit.attackAll:setChecked(config.attackAll)
  edit.attackAll.onClick = function(widget)
    config.attackAll = not config.attackAll
    widget:setChecked(config.attackAll)
    widget:setImageColor(config.attackAll and "green" or "red")
  end
  edit.attackAll:setImageColor(config.attackAll and "green" or "red")
end

-- TextEdit
edit.esc:setText(config.esc)
edit.esc.onTextChange = function(widget, text)
  config.esc = text
end
edit.esc:setTooltip("Hotkey to cancel attack.")

-- End of setup.

local target = nil
local c = config

-- Main Loop
macro(250, function()
  if not c.enabled then return end
  if not target then
    if c.pausedTarget then
      c.pausedTarget = false
      TargetBot.setOn()
    end
    if c.pausedCave then
      c.pausedCave = false
      CaveBot.setOn()
    end
    -- Search for attackers
    local creatures = getSpectators(false)
    for s, spec in ipairs(creatures) do
      if spec ~= player and spec:isPlayer() then
        if (c.attackAll and spec:getSkull() > 2) or spec:isTimedSquareVisible() then
          if c.ignoreParty or spec:getShield() < 3 then
            if c.ignoreGuild or not table.find(ignoreEmblems, spec:getEmblem()) then
              target = spec:getName()
              break
            end
          end
        end
      end
    end
    return
  end

  local creature = getPlayerByName(target)
  if not creature then target = nil return end
  if c.pauseTargetBot then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if c.pauseTarget then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if c.pauseCave then
    c.pausedCave = true
    CaveBot.setOff()
  end

  if c.followTarget then
    g_game.setChaseMode(2)
  end

  if g_game.isAttacking() then
    if g_game.getAttackingCreature():getName() == target then
      return
    end
  end
  g_game.attack(creature)
end)

onKeyDown(function(keys)
  if not c.enabled then return end
  if keys == config.esc then
    target = nil
  end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------- [[ TARGET E CAVE ]] --------------------------------------------------------------------------------



local uiCavebot = setupUI([[
Panel
  width: 300
  height:300
        
  Label
    id: targetLabel
    x: 200            
    y: 250
    font: verdana-11px-rounded
        
  Label
    id: caveLabel
    x: 200
    y: 265
    font: verdana-11px-rounded
  Label 
    id: chaseTargetBot
    x: 200
    y: 280
    font: verdana-11px-rounded    
]], g_ui.getRootWidget())



--local function getTargetBotStattus()
---  return chaseTargetBot and "ON" or not chaseTargetBot and "OFF"
--end

-- Obtém o status atual do TargetBot
local function getTargetBotStatus()
  return TargetBot.isOn() and "ON" or TargetBot.isOff() and "OFF"
end

-- Obtém o status atual do CaveBot
local function getCaveBotStatus()
  return CaveBot.isOn() and "ON" or CaveBot.isOff() and "OFF"
end

-- Obtém a cor do status atual
local function getColorFromStatus(status)
  return status == "ON" and "green" or status == "OFF" and "red"
end

-- Atualiza a interface do usuário com o status atual do TargetBot e CaveBot
macro(100, function()
  local targetStatus = getTargetBotStatus()
  local caveStatus = getCaveBotStatus()
  local targetColor = getColorFromStatus(targetStatus)
  local caveColor = getColorFromStatus(caveStatus)
  --local ttargetStatus = getTargetBotStattus()
  --local ttargetColor = getColorFromStatus(ttargetStatus)
          
  uiCavebot.targetLabel:setColoredText({"Target: ", "white", targetStatus, targetColor})
  uiCavebot.caveLabel:setColoredText({"Cavebot: ",  "white", caveStatus, caveColor})
  --uiCavebot.chaseTargetBot:setColoredText({"Chase Targetbot: ",  "white", ttargetStatus, ttargetColor})
end)

-- Liga ou desliga o TargetBot quando o usuário clica na etiqueta
uiCavebot.targetLabel.onClick = function(widget)
    TargetBot.setOn(not TargetBot.isOn())
end

-- Liga ou desliga o CaveBot quando o usuário clica na etiqueta
uiCavebot.caveLabel.onClick = function(widget)
    CaveBot.setOn(not CaveBot.isOn())
end

-- Liga ou desliga o TargetBot ou CaveBot quando o usuário clica em qualquer etiqueta
for _, child in ipairs(uiCavebot:getChildren()) do
    child.onMouseRelease = function(widget, pos, button)
        widget:onClick()
    end
end


----------------------------------------------------------------------------------------------------------------------------------------------------


if type(storage["death"]) ~= "table" then storage["death"] = { count = 0 } end
local deathCount = storage["death"].count
UI.Separator()
deathLabel = UI.Label("Death count: " .. deathCount)

if deathCount >= logoutDeaths then
  CaveBot:setOff()
  warn("Death Count Logout")
  schedule(5000, function()
    modules.game_interface.tryLogout(false)
  end)
end

if deathCount >= 4 then
  deathLabel:setColor("red")
elseif deathCount >= 2 then
  deathLabel:setColor("orange")
else
  deathLabel:setColor("green")
end

UI.Button("Reset Deaths", function()
  storage["death"].count = 0
  deathLabel:setText("Death count: " .. storage["death"].count)
  deathLabel:setColor("green")
end )

local macroDeathCount = macro(10000, "Death Counter", function() end)

onTextMessage(function(mode, text)
  if macroDeathCount.isOff() then return end
  if text:find("You were downgraded") then
    storage["death"].count = storage["death"].count + 1
    deathLabel:setText("Death count: " .. storage["death"].count)
    modules.client_entergame.CharacterList.doLogin()
  end
end)

UI.Separator()

macro(1, function()
  if not getFinger() then
    NPC.say('!bol')
  end
end)
  

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

local mkPanelname = "monsterKill"
if not storage[mkPanelname] then storage[mkPanelname] = { min = false } end

local monsterKill = setupUI([[
Panel
  margin-top:2
  height: 115
  Button
    id: resetList
    anchors.left: parent.left
    anchors.top: parent.top
    width: 20
    height: 17
    margin-top: 2
    margin-left: 3
    text: !
    color: red
    tooltip: Reset Data
  Button
    id: showList
    anchors.right: parent.right
    anchors.top: parent.top
    width: 20
    height: 17
    margin-top: 2
    margin-right: 3
    text: -
    color: red

  Label
    id: title
    text: Monster Kills
    text-align: center
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20

  ScrollablePanel
    id: content
    image-source: /images/ui/menubox
    image-border: 4
    image-border-top: 17
    anchors.top: showList.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 88
    padding: 3
    vertical-scrollbar: mkScroll
    layout:
      type: verticalBox

  BotSmallScrollBar
    id: mkScroll
    anchors.top: content.top
    anchors.bottom: content.bottom
    anchors.right: content.right
    margin-top: 2
    margin-bottom: 5
    margin-right: 5
  ]], parent)
monsterKill:setId(mkPanelname)
local config = storage[mkPanelname]
config.killList = config.killList or {}
local lbls = {}

local function toggleWin(load)
  if load then
    monsterKill:setHeight(20)
    monsterKill.showList:setText("+")
    monsterKill.showList:setColor("green")
  else
    monsterKill:setHeight(115)
    monsterKill.showList:setText("-")
    monsterKill.showList:setColor("red")
  end
end

function refreshMK()
  if #lbls > 0 and (#config.killList == #lbls) then
    local i = 1
    for k, v in pairs(config.killList) do
      lbls[i].name:setText(k .. ':')
      lbls[i].count:setText("x"..v)
      i = i + 1
    end
  else
    for _, child in pairs(monsterKill.content:getChildren()) do
      child:destroy()
    end
    for k, v in pairs(config.killList) do
      lbls[k] = g_ui.loadUIFromString([[
Panel
  height: 16
  margin-left: 2

  Label
    id: name
    text:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    text-auto-resize: true
    font: verdana-11px-bold

  Label
    id: count
    text:
    anchors.top: name.top
    anchors.right: parent.right
    margin-right: 15
    text-auto-resize: true
    color: orange
    font: verdana-11px-bold

]], monsterKill.content)
      if lbls[k] then
        lbls[k].name:setText(k .. ':')
        lbls[k].count:setText("x"..v)
      end
    end
  end
end
refreshMK()
toggleWin(storage[mkPanelname].min)

monsterKill.showList.onClick = function(widget)
  storage[mkPanelname].min = (monsterKill:getHeight() == 115)
  toggleWin(storage[mkPanelname].min)
end

monsterKill.resetList.onClick = function(widget)
  config.killList = {}
  refreshMK()
end

function checkKill(mode, text)
  local mobName = nil
  local reg = { "Loot of a (.*):", "Loot of an (.*):", "Loot of the (.*):","Loot of (.*):"}
  for x = 1, #reg do
    _, _, mobName = string.find(text, reg[x])
    if mobName then
      if config.killList[mobName] then
        config.killList[mobName] = config.killList[mobName] + 1
      else
        config.killList[mobName] = 1
      end
      refreshMK()
      break
    end
  end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId == 11 then checkKill(mode, text) end
end)

onTextMessage(function(mode, text)
  checkKill(mode, text)
end)

--- examples NOT NEEDED
function getKills(mobName)
  -- example: warn(getKills("Troll"))
  if config.killList[mobName] then
    return config.killList[mobName]
  end
  return nil
end

function getDumpAllKills() -- test dump
  for k, v in pairs(config.killList) do
    warn(v .. "x " .. k)
  end
end
