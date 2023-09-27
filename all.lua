local logoutDeaths = 10

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

checkVoc = false


--You see você mesmo. Você é Super Uub Reborn.

getVocationFromString = function(str)
    local strStart = str:find(".")
    local strEnd = str:find("Reborn")
    if (not strStart or not strEnd) then return; end
    return str:sub(strStart + 26, strEnd - 1):trim()
end


vocacaoLogada = nil

onTextMessage(function(mode, text)
    if notFound then return; end
    if vocacaoLogada then return; end
    if text:find('mesmo') then
        local vocation = getVocationFromString(text)
        if vocation then
            vocacaoLogada = Config.Setup[vocation]
            modules.game_textmessage.displayGameMessage('Voc?o encontrada e definida, voca??o: ' .. vocation)
      else
            modules.game_textmessage.displayGameMessage('Vocation not find.')
        end
    end
end)

macro(100, function()
    if vocacaoLogada then return; end
    if not checkVoc then
        g_game.look(player)
        modules.game_textmessage.clearMessages()
         checkVoc = true
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


function sayMultipleSpells(spells)
  splitSpells = spells:split(",");
    for _, spell in ipairs(splitSpells) do
      say(spell)
    end
end

macro(200, "Ataque", function()
  if not g_game.isAttacking() then return; end
  sayMultipleSpells(storage.Spellss)
end)

addTextEdit("Spells", storage.Spellss or "Spells ", function(widget, text)
  storage.Spellss = text
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
        if (not Config.cdSenzu or Config.cdSenzu <= now) then
            useWith(tonumber(storage.idSenzu), player)
        end
    end
end)

addTextEdit("ID Senzu", storage.idSenzu or "Id Senzu", function(widget, text)
    storage.idSenzu = text;
end);


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
    if level() < 10 then return; end
    if level() > 100 then
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
        Config.cdRegen = now + 1000
    elseif text == 'aaahhh! muito melhor!' then
        Config.cdSenzu = now + 1500
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

g_window = modules._G.g_window;
mapPanel = g_ui.getRootWidget():recursiveGetChildById("gameMapPanel");
local switch;
local removeThings = false;


onAddThing(function(tile, thing)
    if (not removeThings) then return; end
    if (thing:isTile() or thing:isCreature()) then return; end
    
    
    g_map.removeThing(thing);
end)

onAnimatedText(function(thing, text)
    if (not removeThings) then return; end
    g_map.removeThing(thing);
end)

onStaticText(function(thing, text)
    if (not removeThings) then return; end
    g_map.removeThing(thing);
end)

onMissle (function(thing)
    if (not removeThings) then return; end
    g_map.removeThing(thing);
end)


doSwitch = function(value)

    if (value == switch) then return; end
    
    if (value == true) then
        removeThings = false;
        mapPanel:show();
    else
        removeThings = true;
        mapPanel:hide();
    end
    switch = value;
end


macro(1000, function()
    doSwitch(g_window.isMaximized());
end)

if type(storage.moneyItems) ~= "table" then
    storage.moneyItems = {3031, 3035}
end
macro(1000, "Exchange money", function()
    if not storage.moneyItems[1] then return end
    local containers = g_game.getContainers()
    for index, container in pairs(containers) do
        if not container.lootContainer then -- ignore monster containers
            for i, item in ipairs(container:getItems()) do
                if item:getCount() == 100 then
                    for m, moneyId in ipairs(storage.moneyItems) do
                        if item:getId() == moneyId.id then
                            return g_game.use(item)
                        end
                    end
                end
        end
        end
    end
end)

local moneyContainer = UI.Container(function(widget, items)
    storage.moneyItems = items
end, true)
moneyContainer:setHeight(35)
moneyContainer:setItems(storage.moneyItems)


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
    BLESS_MONEY = 'voce ja tem bless', -- messagem se ja tem bless.
    BLESS_NOTMONEY = 'voce nao tem dinheiro suficiente', -- mensagem se não tem gold
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

local idGold = 3043

function itemAmount(id)
    return player:getItemsCount(id)
end

macro(1, function()
  if not (findItem(idGold) and itemAmount(idGold) > 3) then return; end
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
FollowPlayer = {
    targetId = nil,
    obstaclesQueue = {},
    obstacleWalkTime = 0,
    currentTargetId = nil,
    keyToClearTarget = 'Escape',
    walkDirTable = {
        [0] = {'y', -1},
        [1] = {'x', 1},
        [2] = {'y', 1},
        [3] = {'x', -1},
    },
    flags = {
        ignoreNonPathable = true,
        precision = 0,
        ignoreCreatures = true
    },
    jumpSpell = {
        up = 'jump up',
        down = 'jump down'
    },
    defaultItem = 1111,
    defaultSpell = 'skip',
    customIds = {
        {
            id = 1948,
            castSpell = false
        },
        {
            id = 595,
            castSpell = false
        },
        {
            id = 1067,
            castSpell = false
        },
        {
            id = 1080,
            castSpell = false
        },
        {
            id = 386,
            castSpell = true
        },
    },
    lastCancelFollow = 0,
    followDelay = 300
};


FollowPlayer.distanceFromPlayer = function(position)
    local distx = math.abs(posx() - position.x);
    local disty = math.abs(posy() - position.y);

    return math.sqrt(distx * distx + disty * disty);
end

FollowPlayer.walkToPathDir = function(path)
    if (path) then
        g_game.walk(path[1], false);
    end
end

FollowPlayer.getDirection = function(playerPos, direction)
    local walkDir = FollowPlayer.walkDirTable[direction];
    if (walkDir) then
        playerPos[walkDir[1]] = playerPos[walkDir[1]] + walkDir[2];
    end
    return playerPos;
end


FollowPlayer.checkItemOnTile = function(tile, table)
    if (not tile) then return nil end;
    for _, item in ipairs(tile:getItems()) do
        local itemId = item:getId();
        for _, itemSelected in ipairs(table) do
            if (itemId == itemSelected.id) then
                return itemSelected;
            end
        end
    end
    return nil;
end

FollowPlayer.shiftFromQueue = function()
    g_game.cancelFollow();
    lastCancelFollow = now + FollowPlayer.followDelay;
    table.remove(FollowPlayer.obstaclesQueue, 1);
end

FollowPlayer.checkIfWentToCustomId = function(creature, newPos, oldPos, scheduleTime)
    local tile = g_map.getTile(oldPos);

    local customId = FollowPlayer.checkItemOnTile(tile, FollowPlayer.customIds);

    if (not customId) then return; end

    if (not scheduleTime) then
        scheduleTime = 0;
    end

    schedule(scheduleTime, function()
        if (oldPos.z == posz() or #FollowPlayer.obstaclesQueue > 0) then
            table.insert(FollowPlayer.obstaclesQueue, {
                oldPos = oldPos,
                newPos = newPos,
                tilePos = oldPos,
                customId = customId,
                tile = g_map.getTile(oldPos),
                isCustom = true
            });
            g_game.cancelFollow();
            lastCancelFollow = now + FollowPlayer.followDelay;
        end
    end);
end


FollowPlayer.checkIfWentToStair = function(creature, newPos, oldPos, scheduleTime)

    if (g_map.getMinimapColor(oldPos) ~= 210) then return; end
    local tile = g_map.getTile(oldPos);

    if (tile:isPathable()) then return; end

    if (not scheduleTime) then
        scheduleTime = 0;
    end

    schedule(scheduleTime, function()
        if (oldPos.z == posz() or #FollowPlayer.obstaclesQueue > 0) then
            table.insert(FollowPlayer.obstaclesQueue, {
                oldPos = oldPos,
                newPos = newPos,
                tilePos = oldPos,
                tile = tile,
                isStair = true
            });
            g_game.cancelFollow();
            lastCancelFollow = now + FollowPlayer.followDelay;
        end
    end);
end


FollowPlayer.checkIfWentToDoor = function(creature, newPos, oldPos)
    if (FollowPlayer.obstaclesQueue[1] and FollowPlayer.distanceFromPlayer(newPos) < FollowPlayer.distanceFromPlayer(oldPos)) then return; end
    if (math.abs(newPos.x - oldPos.x) == 2 or math.abs(newPos.y - oldPos.y) == 2) then
            

        local doorPos = {
            z = oldPos.z
        }

        local directionX = oldPos.x - newPos.x
        local directionY = oldPos.y - newPos.y

        if math.abs(directionX) > math.abs(directionY) then

            if directionX > 0 then
                doorPos.x = newPos.x + 1
                doorPos.y = newPos.y
            else
                doorPos.x = newPos.x - 1
                doorPos.y = newPos.y
            end
        else
            if directionY > 0 then
                doorPos.x = newPos.x
                doorPos.y = newPos.y + 1
            else
                doorPos.x = newPos.x
                doorPos.y = newPos.y - 1
            end
        end

        local doorTile = g_map.getTile(doorPos);

        if (not doorTile:isPathable() or doorTile:isWalkable()) then return; end

        table.insert(FollowPlayer.obstaclesQueue, {
            newPos = newPos,
            tilePos = doorPos,
            tile = doorTile,
            isDoor = true,
        });
        g_game.cancelFollow();
        lastCancelFollow = now + FollowPlayer.followDelay;
    end
end


FollowPlayer.checkifWentToJumpPos = function(creature, newPos, oldPos)
    local pos1 = { x = oldPos.x - 1, y = oldPos.y - 1 };
    local pos2 = { x = oldPos.x + 1, y = oldPos.y + 1 };

    local hasStair = nil
    for x = pos1.x, pos2.x do
        for y = pos1.y, pos2.y do
            local tilePos = { x = x, y = y, z = oldPos.z };
            if (g_map.getMinimapColor(tilePos) == 210) then
                hasStair = true;
                goto continue;
            end
        end
    end
    ::continue::

    if (hasStair) then return; end

    local spell = newPos.z > oldPos.z and FollowPlayer.jumpSpell.down or FollowPlayer.jumpSpell.up;
    local dir = creature:getDirection();

    if (newPos.z > oldPos.z) then
        spell = FollowPlayer.jumpSpell.down;
    end

    table.insert(FollowPlayer.obstaclesQueue, {
        oldPos = oldPos,
        oldTile = g_map.getTile(oldPos),
        spell = spell,
        dir = dir,
        isJump = true,
    });
    g_game.cancelFollow();
    lastCancelFollow = now + FollowPlayer.followDelay;
end


onCreaturePositionChange(function(creature, newPos, oldPos)
    if (FollowPlayer.mainMacro.isOff()) then return; end

    if creature:getId() == FollowPlayer.currentTargetId and newPos and oldPos and oldPos.z == newPos.z then
        FollowPlayer.checkIfWentToDoor(creature, newPos, oldPos);
    end
end);


onCreaturePositionChange(function(creature, newPos, oldPos)
    if (FollowPlayer.mainMacro.isOff()) then return; end

    if creature:getId() == FollowPlayer.currentTargetId and newPos and oldPos and oldPos.z == posz() and oldPos.z ~= newPos.z then
        FollowPlayer.checkifWentToJumpPos(creature, newPos, oldPos);
    end
end);


onCreaturePositionChange(function(creature, newPos, oldPos)
    if (FollowPlayer.mainMacro.isOff()) then return; end

    if creature:getId() == FollowPlayer.currentTargetId and oldPos and g_map.getMinimapColor(oldPos) == 210 then
        local scheduleTime = oldPos.z == posz() and 0 or 250;

        FollowPlayer.checkIfWentToStair(creature, newPos, oldPos, scheduleTime);
    end
end);



onCreaturePositionChange(function(creature, newPos, oldPos)
    if (FollowPlayer.mainMacro.isOff()) then return; end
    if creature:getId() == FollowPlayer.currentTargetId and oldPos and oldPos.z == posz() and (not newPos or oldPos.z ~= newPos.z) then
        FollowPlayer.checkIfWentToCustomId(creature, newPos, oldPos);
    end
end);


macro(1, function()
    if (FollowPlayer.mainMacro.isOff()) then return; end

    if (FollowPlayer.obstaclesQueue[1] and ((not FollowPlayer.obstaclesQueue[1].isJump and FollowPlayer.obstaclesQueue[1].tilePos.z ~= posz()) or (FollowPlayer.obstaclesQueue[1].isJump and FollowPlayer.obstaclesQueue[1].oldPos.z ~= posz()))) then
        table.remove(FollowPlayer.obstaclesQueue, 1);
    end
end);



macro(100, function()
    if (FollowPlayer.mainMacro.isOff()) then return; end
    if (FollowPlayer.obstaclesQueue[1] and FollowPlayer.obstaclesQueue[1].isStair) then
        local start = now
        local playerPos = pos();
        local walkingTile = FollowPlayer.obstaclesQueue[1].tile;
        local walkingTilePos = FollowPlayer.obstaclesQueue[1].tilePos;

        if (FollowPlayer.distanceFromPlayer(walkingTilePos) < 2) then
            if (FollowPlayer.obstacleWalkTime < now) then
                local nextFloor = g_map.getTile(walkingTilePos); -- workaround para caso o TILE descarregue, conseguir pegar os atributos ainda assim.
                if (nextFloor:isPathable()) then
                    FollowPlayer.obstacleWalkTime = now + 250;
                    use(nextFloor:getTopUseThing());
                else
                    FollowPlayer.obstacleWalkTime = now + 250;
                    FollowPlayer.walkToPathDir(findPath(playerPos, walkingTilePos, 1, { ignoreCreatures = false, precision = 0, ignoreNonPathable = true }));
                end
                FollowPlayer.shiftFromQueue();
                return 
            end
        end
        local path = findPath(playerPos, walkingTilePos, 50, { ignoreNonPathable = true, precision = 0, ignoreCreatures = false });
        if (path == nil or #path <= 1) then
            if (path == nil) then
                use(walkingTile:getTopUseThing());
            end
            return
        end
        
        local tileToUse = playerPos;
        for i, value in ipairs(path) do
            if (i > 5) then break; end
            tileToUse = FollowPlayer.getDirection(tileToUse, value);
        end
        tileToUse = g_map.getTile(tileToUse);
        if (tileToUse) then
            use(tileToUse:getTopUseThing());
        end
    end
end);


macro(1, function()
    if (FollowPlayer.mainMacro.isOff()) then return; end

    if (FollowPlayer.obstaclesQueue[1] and FollowPlayer.obstaclesQueue[1].isDoor) then
        local playerPos = pos();
        local walkingTile = FollowPlayer.obstaclesQueue[1].tile;
        local walkingTilePos = FollowPlayer.obstaclesQueue[1].tilePos;
        if (table.compare(playerPos, FollowPlayer.obstaclesQueue[1].newPos)) then
            FollowPlayer.obstacleWalkTime = 0;
            FollowPlayer.shiftFromQueue();
        end
        
        local path = findPath(playerPos, walkingTilePos, 50, { ignoreNonPathable = true, precision = 0, ignoreCreatures = false });
        if (path == nil or #path <= 1) then
            if (path == nil) then

                if (FollowPlayer.obstacleWalkTime < now) then
                    g_game.use(walkingTile:getTopThing());
                    FollowPlayer.obstacleWalkTime = now + 500;
                end
            end
            return
        end
    end
end);


macro(100, function()
    if (FollowPlayer.mainMacro.isOff()) then return; end
    
    if (FollowPlayer.obstaclesQueue[1] and FollowPlayer.obstaclesQueue[1].isJump) then
        local playerPos = pos();
        local walkingTilePos = FollowPlayer.obstaclesQueue[1].oldPos;
        local distance = FollowPlayer.distanceFromPlayer(walkingTilePos);
        if (playerPos.z ~= walkingTilePos.z) then
            FollowPlayer.shiftFromQueue();
            return;
        end

        local path = findPath(playerPos, walkingTilePos, 50, { ignoreNonPathable = true, precision = 0, ignoreCreatures = false });
        
        if (distance == 0) then
            g_game.turn(FollowPlayer.obstaclesQueue[1].dir);
            schedule(50, function()
                if (FollowPlayer.obstaclesQueue[1]) then
                    say(FollowPlayer.obstaclesQueue[1].spell);
                end
            end)
            return;
        elseif (distance < 2) then
            local nextFloor = g_map.getTile(walkingTilePos); -- workaround para caso o TILE descarregue, conseguir pegar os atributos ainda assim.
            if (FollowPlayer.obstacleWalkTime < now) then
                FollowPlayer.walkToPathDir(findPath(playerPos, walkingTilePos, 1, { ignoreCreatures = false, precision = 0, ignoreNonPathable = true }));
                FollowPlayer.obstacleWalkTime = now + 500;
            end
            return 
        elseif (distance >= 2 and distance < 5 and path) then
            use(FollowPlayer.obstaclesQueue[1].oldTile:getTopUseThing());
        elseif (path) then
            local tileToUse = playerPos;
            for i, value in ipairs(path) do
                if (i > 5) then break; end
                tileToUse = FollowPlayer.getDirection(tileToUse, value);
            end
            tileToUse = g_map.getTile(tileToUse);
            if (tileToUse) then
                use(tileToUse:getTopUseThing());
            end
        end
    end
end);


macro(100, function()
    if (FollowPlayer.mainMacro.isOff()) then return; end
    
    if (FollowPlayer.obstaclesQueue[1] and FollowPlayer.obstaclesQueue[1].isCustom) then
        local playerPos = pos();
        local walkingTile = FollowPlayer.obstaclesQueue[1].tile;
        local walkingTilePos = FollowPlayer.obstaclesQueue[1].tilePos;
        local distance = FollowPlayer.distanceFromPlayer(walkingTilePos);
        if (playerPos.z ~= walkingTilePos.z) then
            FollowPlayer.shiftFromQueue();
            return;
        end
        
        if (distance == 0) then
            if (FollowPlayer.obstaclesQueue[1].customId.castSpell) then
                say(FollowPlayer.defaultSpell);
                return;
            end
        elseif (distance < 2) then
            local item = findItem(FollowPlayer.defaultItem)
            if (FollowPlayer.obstaclesQueue[1].customId.castSpell or not item) then
                local nextFloor = g_map.getTile(walkingTilePos); -- workaround para caso o TILE descarregue, conseguir pegar os atributos ainda assim.
                if (FollowPlayer.obstacleWalkTime < now) then
                    FollowPlayer.walkToPathDir(findPath(playerPos, walkingTilePos, 1, { ignoreCreatures = false, precision = 0, ignoreNonPathable = true }));
                    FollowPlayer.obstacleWalkTime = now + 500;
                end
            elseif (item) then
                g_game.useWith(item, walkingTile);
                FollowPlayer.shiftFromQueue();
            end
            return 
        end

        local path = findPath(playerPos, walkingTilePos, 50, { ignoreNonPathable = true, precision = 0, ignoreCreatures = false });
        if (path == nil or #path <= 1) then
            if (path == nil) then
                use(walkingTile:getTopUseThing());
            end
            return
        end
        
        local tileToUse = playerPos;
        for i, value in ipairs(path) do
            if (i > 5) then break; end
            tileToUse = FollowPlayer.getDirection(tileToUse, value);
        end
        tileToUse = g_map.getTile(tileToUse);
        if (tileToUse) then
            use(tileToUse:getTopUseThing());
        end
    end
end);


addTextEdit("FollowPlayer", storage.FollowPlayerName or "Nome do player", function(widget, text)
    storage.FollowPlayerName = text;
end);

FollowPlayer.mainMacro = macro(FollowPlayer.followDelay, 'Follow Player', function()
    local followingPlayer = g_game.getFollowingCreature();
    local playerToFollow = getCreatureByName(storage.FollowPlayerName);
    if (not playerToFollow) then return; end
    if (not findPath(pos(), playerToFollow:getPosition(), 50, { ignoreNonPathable = true, precision = 0, ignoreCreatures = true })) then
        if (followingPlayer and followingPlayer:getId() == playerToFollow:getId()) then
            lastCancelFollow = now + FollowPlayer.followDelay;
            return g_game.cancelFollow();
        end
    elseif (not followingPlayer and playerToFollow and playerToFollow:canShoot() and FollowPlayer.lastCancelFollow < now) then
        g_game.follow(playerToFollow);
    end
end);


macro(1, function()
    if (FollowPlayer.mainMacro.isOff()) then return; end
    local playerToFollow = getCreatureByName(storage.FollowPlayerName);

    if (playerToFollow and FollowPlayer.currentTargetId ~= playerToFollow:getId()) then
        FollowPlayer.currentTargetId = playerToFollow:getId();
    end
end);

macro(1000, function()
    if (FollowPlayer.mainMacro.isOff()) then return; end
    local target = g_game.getFollowingCreature();


    if (target) then
        local targetPos = target:getPosition();

        if (not targetPos or targetPos.z ~= posz()) then
            g_game.cancelFollow();
        end
    end
end);

UI.Button("Others Macros", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="Hotkeys editor", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)

UI.Separator()

for _, scripts in ipairs({storage.ingame_hotkeys}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame edior error:\n" .. result)
    end
  end
end

