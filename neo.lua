--[[
NEO MM2 HUB - ECRAN DE CLE LOCAL - version de test
Cette couche est AJOUTEE devant le script original 6.9.2. Le corps original
reste byte-pour-byte identique. Aucune connexion publicitaire ou serveur.
ATTENTION : un controle de cle dans un code client public est contournable.
Validation memorisee 24 heures pour chaque compte, selon l'horloge locale.
]]
do
  local PlayersKey = game:GetService('Players')
  local meKey = PlayersKey.LocalPlayer
  local HttpKey = game:GetService('HttpService')
  local GUI_NAME = 'NEO_MM2_KEY_GATE_2026'
  local OWNER_USERNAME = '0din01'
  local ACCESS_KEY = 'NEO-9235-7104'
  local VALID_SECONDS = 24 * 60 * 60
  local CACHE_NAME = 'NEO_MM2_KEY_ACCESS.json'
  -- Quand un vrai service de distribution sera pret, renseigner cette URL.
  local GET_KEY_URL = ''

  local envKey = _G
  if type(getgenv) == 'function' then
    local okEnv, resultEnv = pcall(getgenv)
    if okEnv and type(resultEnv) == 'table' then envKey = resultEnv end
  end

  local function nowKey()
    return os.time()
  end
  local function authorizedFromCache()
    local item = envKey.NEO_MM2_KEY_CACHE
    if type(item) == 'table' and item.userId == meKey.UserId
      and type(item.validUntil) == 'number' and item.validUntil > nowKey() then
      return true
    end
    if type(readfile) == 'function' then
      local readOk, contents = pcall(readfile, CACHE_NAME)
      if readOk and type(contents) == 'string' then
        local parsedOk, parsed = pcall(function() return HttpKey:JSONDecode(contents) end)
        if parsedOk and type(parsed) == 'table' and parsed.userId == meKey.UserId
          and type(parsed.validUntil) == 'number' and parsed.validUntil > nowKey() then
          envKey.NEO_MM2_KEY_CACHE = parsed
          return true
        end
      end
    end
    return false
  end
  local function rememberAccess()
    local info = {userId = meKey.UserId, validUntil = nowKey() + VALID_SECONDS}
    envKey.NEO_MM2_KEY_CACHE = info
    if type(writefile) == 'function' then
      local encodeOk, encoded = pcall(function() return HttpKey:JSONEncode(info) end)
      if encodeOk then pcall(writefile, CACHE_NAME, encoded) end
    end
  end

  if string.lower(meKey.Name) ~= string.lower(OWNER_USERNAME) and not authorizedFromCache() then
    local uiParent = meKey:WaitForChild('PlayerGui')
    if type(gethui) == 'function' then
      local okUI, hiddenUI = pcall(gethui)
      if okUI and hiddenUI then uiParent = hiddenUI end
    end
    local oldGate = uiParent:FindFirstChild(GUI_NAME)
    if oldGate then pcall(function() oldGate:Destroy() end) end

    local guiKey = Instance.new('ScreenGui')
    guiKey.Name = GUI_NAME
    guiKey.ResetOnSpawn = false
    guiKey.IgnoreGuiInset = true
    guiKey.DisplayOrder = 99999
    guiKey.Parent = uiParent

    local function round(ui, radius)
      local c = Instance.new('UICorner')
      c.CornerRadius = UDim.new(0, radius)
      c.Parent = ui
    end
    local function makeText(parent, text, posY, height, size, color)
      local item = Instance.new('TextLabel')
      item.Size = UDim2.new(1, -32, 0, height)
      item.Position = UDim2.fromOffset(16, posY)
      item.BackgroundTransparency = 1
      item.Text = text
      item.Font = Enum.Font.GothamBold
      item.TextSize = size
      item.TextColor3 = color
      item.TextWrapped = true
      item.Parent = parent
      return item
    end
    local function makeButton(parent, text, x, y, w, color)
      local b = Instance.new('TextButton')
      b.Size = UDim2.new(0.5, -22, 0, 42)
      b.Position = UDim2.new(x, (x == 0 and 16 or 6), 0, y)
      b.Size = UDim2.new(w, -22, 0, 42)
      b.BackgroundColor3 = color
      b.BorderSizePixel = 0
      b.Font = Enum.Font.GothamBold
      b.TextColor3 = Color3.fromRGB(255,255,255)
      b.TextSize = 13
      b.Text = text
      b.Parent = parent
      round(b, 8)
      return b
    end

    local boxKey = Instance.new('Frame')
    boxKey.Size = UDim2.fromOffset(350, 234)
    boxKey.AnchorPoint = Vector2.new(0.5, 0.5)
    boxKey.Position = UDim2.fromScale(0.5, 0.5)
    boxKey.BackgroundColor3 = Color3.fromRGB(23, 18, 37)
    boxKey.BorderSizePixel = 0
    boxKey.Parent = guiKey
    round(boxKey, 14)
    local border = Instance.new('UIStroke')
    border.Thickness = 1.5
    border.Color = Color3.fromRGB(146, 97, 255)
    border.Parent = boxKey
    makeText(boxKey, 'NEO MM2 HUB  |  ACCESS KEY', 16, 27, 18, Color3.fromRGB(222, 206, 255))
    makeText(boxKey, 'Entrez votre cle pour ouvrir le HUB', 47, 21, 12, Color3.fromRGB(170, 157, 196))
    local entryKey = Instance.new('TextBox')
    entryKey.Size = UDim2.new(1, -32, 0, 43)
    entryKey.Position = UDim2.fromOffset(16, 82)
    entryKey.BackgroundColor3 = Color3.fromRGB(37, 29, 55)
    entryKey.BorderSizePixel = 0
    entryKey.Font = Enum.Font.GothamBold
    entryKey.TextSize = 16
    entryKey.TextColor3 = Color3.fromRGB(255,255,255)
    entryKey.PlaceholderColor3 = Color3.fromRGB(155, 142, 184)
    entryKey.PlaceholderText = 'NEO-XXXX-XXXX'
    entryKey.Text = ''
    entryKey.ClearTextOnFocus = false
    entryKey.Parent = boxKey
    round(entryKey, 8)
    local verify = makeButton(boxKey, 'VERIFY KEY', 0, 138, 0.5, Color3.fromRGB(111, 65, 203))
    local obtain = makeButton(boxKey, 'GET KEY', 0.5, 138, 0.5, Color3.fromRGB(66, 56, 90))
    local resultKey = makeText(boxKey, 'Cle de test : pas encore de site de distribution', 189, 38, 11, Color3.fromRGB(173, 156, 207))
    local release = Instance.new('BindableEvent')
    local accepted = false
    local function verifyKey()
      local candidate = tostring(entryKey.Text or ''):upper():gsub('%s+', '')
      if candidate == ACCESS_KEY then
        accepted = true
        rememberAccess()
        resultKey.Text = 'Cle acceptee. Ouverture...'
        release:Fire()
      else
        resultKey.Text = 'Cle incorrecte. Demandez une cle au createur.'
        resultKey.TextColor3 = Color3.fromRGB(255, 142, 161)
      end
    end
    verify.MouseButton1Click:Connect(verifyKey)
    entryKey.FocusLost:Connect(function(enterPressed)
      if enterPressed then verifyKey() end
    end)
    obtain.MouseButton1Click:Connect(function()
      if GET_KEY_URL ~= '' then
        if type(setclipboard) == 'function' then pcall(setclipboard, GET_KEY_URL) end
        local opened = false
        if type(open_url) == 'function' then opened = pcall(open_url, GET_KEY_URL) end
        resultKey.Text = opened and 'Lien ouvert.' or 'Lien copie. Ouvrez-le dans le navigateur.'
      else
        resultKey.Text = 'La page Get Key sera ajoutee plus tard.'
      end
    end)
    release.Event:Wait()
    if accepted then
      pcall(function() guiKey:Destroy() end)
      pcall(function() release:Destroy() end)
    else
      error('NEO MM2 : acces non valide')
    end
  end
end

-- NEO MM2 HUB | Delta / Roblox client | version 6.9.2 | Fling YARHM + Attach Player
-- SHOOT port du code YARHM 1.21 pour tir manuel et automatique; aucun hit garanti.
-- YARHM: Joystickplays / Aetherion, https://github.com/Joystickplays/psychic-octo-invention
-- YARHM source 1.21: source/yarhm/1.21/yarhm.lua ; GNU GPL v3.
-- Modifications: interface NEO, controles d etat, exclusion du fallback sur un sheriff innocent.
-- Ce fichier derive du code YARHM GPL-3.0: redistribution sous GPL-3.0, voir LICENCE_YARHM_GPL3.txt.
-- V4.6 : Fling physique (methode YARHM 1.21) + Attach Player local.
-- ATTACH local n est pas autoritaire sur le serveur: autres joueurs non garantis.
-- Standalone : aucune execution de code distant. Trade Checker peut charger des prix JSON distants.
-- Correctif v4.5.1 : fonctions organisees dans une table interne pour eviter l erreur
-- "too many local variables (limit is 200)" qui empechait le menu de demarrer.
-- Certaines actions dependent des controles du serveur MM2 et peuvent echouer.
-- X / RED. masquent le menu; bande en haut pour reouvrir.
-- Les effets ESP/clone/freecam sont locaux; les actions du personnage dependent du serveur.
-- AutoFarm : vole vers les pickups reperes si Fly+Noclip ON; collecte non garantie cote serveur.
-- Fly+Noclip utilise un BodyVelocity progressif sans teleporter le CFrame; STOP / mort nettoient le pilote.
-- V4.8 : sauvegarde de tous les reglages de menu et finition de collecte plus precise.
-- V4.9 : fling recentre sur la vraie cible et AutoFarm en vol continu entre bonbons.
-- V5.3 : seulement OUVRIR JOINBLOX et COPIER LE LIEN.
-- V5.4 : farm horizontal prioritaire, sans montee artificielle entre bonbons.
-- Aucune recherche automatique de serveur ni import de JobId.
-- Ouverture du site selon les hooks proposes par Delta / Android (non garantie).
-- V5.5 : ESP restaure des le lancement, personnages reapparus, marqueurs fiables.
-- V5.6 : redirection et copie du lien vers RoJoiner (anciennement Joinblox).
-- V5.7 : cache de 48 objets, parcours local prioritaire et rafraichissement plus reactif.
-- V5.8 : cibles fiables + priorite descente, moins de trajets inutiles sur le toit.
-- V5.9 : veritables bonbons CoinContainer/TouchInterest et validation collecte.
-- Ne charge aucun script externe inconnu; le vol/no-clip et les options sont conserves.
-- V6.0 : farm direct, vitesse reglable 18/22/26, sous-sol optionnel, scan CoinContainer.
-- V6.0 + TRADE MAX : W/F/L, demande, variétés, sauvegarde valeurs manuelles, JSON externe en lecture seule.
-- V6.1 : catalogue EMOTES Roblox pagine jusqu a 3 000 fiches par lot, recherche et favoris.
-- V6.2 : distingue ID du catalogue et ID de l animation ; resolution a la demande, cache durable.
-- V6.3 : PANEL ADMIN pour 0din01 ; commandes par chat du serveur, option par option.
-- V6.4 : nouveaux visuels de l ONGLET DANSES exclusivement : miniatures Roblox, apercu a droite, theme violet.
-- Les autres categories et controles V6.3 ne sont pas modifies.
-- V6.5 : AutoShoot scan 0.02s sans doublons, autoGrab suspendu apres la mort jusqu a une nouvelle manche, diagnostic ADMIN/ACK.
-- V6.6 : boutons TP MAP / TP LOBBY dans CARTE, reperage des points de spawn, blocages admin dedies.
-- ATTENTION : messages publics/filtrables ; applique uniquement par copies non modifiees du HUB.
-- Aucun droit d administration Roblox/MM2 ; pas de blocage des scripts externes.
-- Attribution : le menu AFEM/YARHM utilise lui aussi des correspondances emote / animation.
-- Aucune execution de code distant ; synchronisation soumise aux regles Roblox.
-- Les collisions / collectes restent soumises au serveur Roblox.
-- OP Fly V6.9.6 : code FlyUtility YARHM 1.21 d'origine et controles joystick Roblox.
-- 12/11 : modes SHERIF ORBIT SHOOT + TP MURDER SHOOT, sans collision forcee.
-- 12/11 : ANTI-FLING REACTIF (SURVIE) : annulation des impulsions anormales,
-- retour au dernier point stable quand disponible. N'affecte pas le Fly/TP/Fling du HUB.
-- 12/11 : TP SHERIF et JOUEURS unifies ; le TP ne depend plus de la preparation du tir.
-- 12/11 : FLING SHERIF lance le vrai YARHM de JOUEURS avec tirs paralleles ; JOUEURS inchange.
-- Le Fling classique YARHM est restaure a l identique, pour tous les roles.
-- 12/11 : ORBIT SHERIF lent (17 s, 18-21 studs), pause de tir et priorite Shoot.
-- Le pilote orbital ne garantit pas les hits (serveur Roblox autoritaire).
-- AUTO TOUS ROLES V2.2 : SHERIF/HERO -> TP unique + tirs stables ; MURDER -> TP KILL.
-- Contrôleur unique, confirmation du Gun, annulation des modes au changement de role.
-- ADMIN V6.9.6 : immobilisation locale de copie compatible (codes MOD 104 / 204).

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')
local RS = game:GetService('ReplicatedStorage')
local Lighting = game:GetService('Lighting')
local VU = game:GetService('VirtualUser')
local PathfindingService = game:GetService('PathfindingService')
local Local = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PG = Local:WaitForChild('PlayerGui')
local TextChatService = game:GetService('TextChatService')
-- Nom de compte Roblox, pas le DisplayName. On valide aussi l'ID de l'emetteur.
local adminOwnerName = '0din01'
local isAdminOwner = string.lower(Local.Name)==adminOwnerName


-- V4.7.1 : options conservees en memoire ET dans un fichier Delta si readfile/writefile sont autorises.
-- Les reglages ne sont jamais transmis sur Internet; stockage local uniquement.
local sharedEnv = _G
if type(getgenv)=='function' then
  local ok,env=pcall(getgenv)
  if ok and type(env)=='table' then sharedEnv=env end
end
if type(sharedEnv.NEO_MM2_STOP)=='function' then pcall(sharedEnv.NEO_MM2_STOP)
elseif type(_G.NEO_MM2_STOP)=='function' then pcall(_G.NEO_MM2_STOP) end
local neo = {} -- methods keep this large script within the Lua/Luau 200-local limit
-- Portee partagee : ces pilotes sont initialises plus bas, mais appeles par le menu SHERIF.
-- Sans declaration anticipée, Luau les traiterait comme des globals nil a la ligne 1696.
local autoNav, bodyBlock
local retainedOptions = type(sharedEnv.NEO_MM2_OPTIONS)=='table' and sharedEnv.NEO_MM2_OPTIONS or {}
local profileFile = 'NEO_MM2_HUB_SETTINGS.json'
local backupFile = 'NEO_MM2_HUB_SETTINGS_backup.json'
local HttpService = game:GetService('HttpService')
-- Lecture avec secours : un fichier incomplet ne doit pas effacer les choix precedents.
function neo.loadProfile(fileName)
  if type(readfile)~='function' then return nil end
  local ok,raw=pcall(readfile,fileName)
  if not ok or type(raw)~='string' then return nil end
  local parsed,data=pcall(function() return HttpService:JSONDecode(raw) end)
  if parsed and type(data)=='table' then return data end
  return nil
end
local diskOptions=neo.loadProfile(profileFile) or neo.loadProfile(backupFile)
if diskOptions then
  for key,value in pairs(diskOptions) do
    if type(key)=='string' and (type(value)=='boolean' or type(value)=='number' ) then
      retainedOptions[key]=value
    end
  end
end
-- Enregistrer chaque interrupteur parametrable, pas seulement un sous-ensemble.
-- Un suivi de cible, un spectate et les mouvements ponctuels exigent toujours une cible valide.
local persistentKeys = {
  'aim','autoShoot','triggerBot','prediction','autoEquipGun','knifeAura',
  'esp','gunESP','speed','jump','noclip','infiniteJump','bright','antiAfk',
  'autoGrab','dangerAlert','autoEscape','murderTrail','escapeRoute','threatMeter',
  'safeScan','coinRadar','autoFarm','flyNoclipAuto','farmUnderground','notifications','performance',
  'cameraGuard','tradeHUD','antiFling','autoRoles'
}
local active, connections, highlights = true, {}, {}
-- Restrictions volatiles, pour cette copie et uniquement pendant cette session.
-- Chaque copie compatible doit recevoir la commande de l'admin et l'appliquer elle-meme.
neo.adminBlocked={}
neo.adminReceivedCommands={}
neo.adminLastSent={}
neo.adminSelected=nil
neo.adminSerial=0
neo.adminHasRestrictions=false
neo.adminIsBlocked=function(feature)
  return neo.adminBlocked.ALL==true or neo.adminBlocked[feature]==true
end
local state = {
  aim = false, autoShoot = false, triggerBot = false, combatPosition = false, prediction = true, autoEquipGun = true, knifeAura = false,
  esp = false, gunESP = false, speed = false,
  jump = false, noclip = false, infiniteJump = false,
  bright = false, antiAfk = false, autoGrab = false, dangerAlert = false,
  autoEscape = false, murderTrail = false,
  escapeRoute = false, threatMeter = false, safeScan = false,
  coinRadar = false, autoFarm = false, flyNoclipAuto = true, farmUnderground = false, notifications = true, performance = true,
  manualFly = false,
  freecam = false, followPlayer = false, bodyBlock = false, cameraGuard = true, tradeHUD = true, antiFling = true, autoRoles = false
}
for _,key in ipairs(persistentKeys) do
  if type(retainedOptions[key])=='boolean' then state[key]=retainedOptions[key] end
end
-- Les options du joueur sont mises de cote pendant le pilotage automatique.
neo.autoRole={mode='OFF',saved=nil,comboOwned=false,killOwned=false,
  lastCombat=nil,combatTrials=0,nextCombat=0,nextGrab=0,nextKill=0,
  lastTarget=nil,lastSwitch=0,nextNotice=0,lastError=nil,lastGunSeen=0,
  gunAttempts=0,started=false}
-- Reglage sauvegarde : 26 studs/s correspond au reglage de la video.
local farmSpeed=({[18]=true,[22]=true,[26]=true})[retainedOptions.farmSpeed]
  and retainedOptions.farmSpeed or 26
local manualFlySpeed=(type(retainedOptions.manualFlySpeed)=='number' and
  math.clamp(math.floor(retainedOptions.manualFlySpeed/10+.5)*10,50,350)) or 50
local cameraGuardRange=({[20]=true,[35]=true,[50]=true})[retainedOptions.cameraGuardRange]
  and retainedOptions.cameraGuardRange or 35
local lastSavedOptions=nil
function neo.saveOptions(force)
  for _,key in ipairs(persistentKeys) do
    local keep=neo.autoRole and neo.autoRole.saved and neo.autoRole.saved[key]
    if keep~=nil then retainedOptions[key]=keep
    else retainedOptions[key]=state[key]==true end
  end
  retainedOptions.cameraGuardRange=cameraGuardRange
  retainedOptions.farmSpeed=farmSpeed
  retainedOptions.manualFlySpeed=manualFlySpeed
  retainedOptions.finderUsername=nil  -- retire l ancienne option du fichier sauvegarde
  retainedOptions.version=6.6
  sharedEnv.NEO_MM2_OPTIONS=retainedOptions
  if type(writefile)~='function' or type(readfile)~='function' then return false end
  local encodeOk,encoded=pcall(function() return HttpService:JSONEncode(retainedOptions) end)
  if not encodeOk then return false end
  if not force and encoded==lastSavedOptions then return true end
  local savedOk=pcall(writefile,profileFile,encoded)
  local verified=false
  if savedOk then
    local readOk,actual=pcall(readfile,profileFile)
    verified=readOk and type(actual)=='string' and actual==encoded
  end
  if verified then
    lastSavedOptions=encoded
    -- Copie de secours en cas de sauvegarde partielle au prochain lancement.
    pcall(writefile,backupFile,encoded)
  end
  return verified
end
local roles, selected, watching, lastShot, lastStab, lastGrab = {}, nil, nil, -math.huge, 0, 0
local yarhmRoleData = {}
local rolesReceivedAt = 0
local shotBusy, nextShot = false, 0
-- Seuls les scans sont acceleres : cooldown de tir YARHM inchange.
local combatMoving = false
local shotCtl = {queued=false,token=0,mode='YARHM-1.21-PORT',offset=2.8,cooldown=1.55,
  status='Aucun tir tente pour le moment.',lastTarget='?',lastCheck=0}
local killAllToken = 0
local aimHistory = {}
local waypoint, trailParts, lastTrail = nil, {}, 0
local stats = {start = os.clock(), shots = 0, grabs = 0}
local playerView = 'list'
neo.rojoiner={browserStatusLabel=nil}
local flingBusy, flingStop, flingTarget = false, false, nil
local targetHighlight = nil
local followTarget, playerQuery = nil, ''
local fakeClone, freecamCF, freecamOldType = nil, nil, nil
local freecamPos, freecamYaw, freecamPitch = nil, 0, 0
local freecamInputs = {forward=false,back=false,left=false,right=false,up=false,down=false}
local safeCandidate, safeCandidateAt, coinCache, nextCoinScan = nil, 0, {}, 0
local coinScanBusy=false
local coinDiag={checked=0,candidates=0,nearby=0,examples={},lastAt=0,error=nil}
local coinDiagLabel=nil
function neo.radarMessage()
  if coinScanBusy then return 'Analyse en cours...'
  elseif coinDiag.lastAt==0 then return 'Pas encore analysé. Appuie sur ACTUALISER.'
  elseif coinDiag.error then return 'Erreur de scan : '..tostring(coinDiag.error):sub(1,70)
  elseif coinDiag.candidates>0 then
    return 'Objets possibles : '..coinDiag.candidates..' | à portée : '..#coinCache
  end
  return 'Aucun objet identifiable | éléments examinés : '..coinDiag.checked
end
local notificationToken, lastMurderDanger, lastGunDrop = 0, false, nil
local lastFollow, lastSurvival, lastThreat, lastFPS = 0, 0, 0, os.clock()
local frameCount, fps = 0, 60
-- cameraGuardRange charge depuis la sauvegarde ; distances reglabes dans SURVIE
local cameraGuardMessageToken = 0
local inspectorText = nil
local originalBright = {
  Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime,
  Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient
}
local hue = {primary=Color3.fromRGB(124,86,246), background=Color3.fromRGB(14,16,27), panel=Color3.fromRGB(23,27,42), elevated=Color3.fromRGB(34,39,59), text=Color3.fromRGB(244,245,255), muted=Color3.fromRGB(169,177,199), green=Color3.fromRGB(58,210,155), red=Color3.fromRGB(250,92,113), blue=Color3.fromRGB(74,173,255)}
local function connect(signal, fn)
  local c=signal:Connect(fn); table.insert(connections,c); return c
end
local function char(plr) return plr and plr.Character end
local function root(plr) local c=char(plr); return c and c:FindFirstChild('HumanoidRootPart') end
local function hum(plr) local c=char(plr); return c and c:FindFirstChildOfClass('Humanoid') end
local function alive(plr) local h=hum(plr); return h and h.Health>0 and root(plr) end
local function tool(kind)
  local c=char(Local)
  local bp=Local:FindFirstChildOfClass('Backpack')
  local t=(c and c:FindFirstChild(kind)) or (bp and bp:FindFirstChild(kind))
  if t and t:IsA('Tool') then return t end
  return nil
end
local function equipped(kind)
  local t=tool(kind); local h=hum(Local)
  if t and h and t.Parent~=char(Local) then pcall(function() h:EquipTool(t) end) end
  return t and t.Parent==char(Local) and t or nil
end
local function myRole()
  local entry=roles[Local.Name]
  if os.clock()-rolesReceivedAt<8 and type(entry)=='table' and type(entry.Role)=='string' then return entry.Role end
  if tool('Knife') then return 'Murderer' end
  if tool('Gun') then return 'Sheriff' end
  return 'Innocent / inconnu'
end
local function getRole(plr)
  local entry=roles[plr.Name]
  if os.clock()-rolesReceivedAt<8 and type(entry)=='table' and type(entry.Role)=='string' then return entry.Role end
  local c=char(plr)
  if c and c:FindFirstChild('Knife') then return 'Murderer' end
  local bp=plr:FindFirstChildOfClass('Backpack')
  -- YARHM tient aussi compte du couteau range dans le sac.
  if bp and bp:FindFirstChild('Knife') then return 'Murderer' end
  if c and c:FindFirstChild('Gun') then return 'Sheriff' end
  if bp and bp:FindFirstChild('Gun') then return 'Sheriff' end
  return 'Inconnu'
end
-- Ordre de decouverte YARHM 1.21: Knife dans Backpack, Knife equipe, Role.
-- Adaptation NEO: ignore le joueur local et les personnages elimines.
local function findMurderer()
  for _,p in ipairs(Players:GetPlayers()) do
    local bp=p:FindFirstChildOfClass('Backpack')
    if p~=Local and alive(p) and bp and bp:FindFirstChild('Knife') then return p end
  end
  for _,p in ipairs(Players:GetPlayers()) do
    local c=char(p)
    if p~=Local and alive(p) and c and c:FindFirstChild('Knife') then return p end
  end
  for username,data in pairs(yarhmRoleData) do
    if type(data)=='table' and data.Role=='Murderer' then
      local p=Players:FindFirstChild(username)
      if p and p~=Local and alive(p) then return p end
    end
  end
  for _,p in ipairs(Players:GetPlayers()) do
    local entry=roles[p.Name]
    if p~=Local and alive(p) and os.clock()-rolesReceivedAt<8
      and type(entry)=='table' and entry.Role=='Murderer' then return p end
  end
  return nil
end
-- YARHM reçoit aussi les roles via PlayerDataChanged (pas seulement GetPlayerData).
function neo.connectYARHMRoles()
  local remotes=RS:FindFirstChild('Remotes')
  local gameplay=remotes and remotes:FindFirstChild('Gameplay')
  local event=gameplay and gameplay:FindFirstChild('PlayerDataChanged')
  if event and event:IsA('RemoteEvent') then
    connect(event.OnClientEvent,function(data)
      if active and type(data)=='table' then yarhmRoleData=data end
    end)
    return true
  end
  return false
end
task.spawn(function()
  for i=1,10 do
    if not active then return end
    if neo.connectYARHMRoles() then return end
    task.wait(2)
  end
end)
-- Verifie la ligne de tir vers le corps. Aucun plafond artificiel de distance.
-- Origine de tir : le corps ou le canon, et non la camera en troisieme personne.
function shotCtl.shootingOrigin()
  local c = char(Local)
  if not c then return nil end
  local g = c:FindFirstChild('Gun')
  local handle = g and g:FindFirstChild('Handle')
  if handle and handle:IsA('BasePart') then return handle.Position end
  local head = c:FindFirstChild('Head')
  if head and head:IsA('BasePart') then return head.Position end
  local r = root(Local)
  return r and (r.Position + Vector3.new(0,1.6,0)) or nil
end
function shotCtl.rayTo(plr, point)
  local target = char(plr)
  local own = char(Local)
  local origin = shotCtl.shootingOrigin()
  if not target or not own or not origin or not point then return nil, false end
  local direction = point - origin
  if direction.Magnitude <= .05 then return nil, false end
  local params = RaycastParams.new()
  params.FilterType = Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances = {own}
  params.IgnoreWater = true
  local hit = workspace:Raycast(origin, direction, params)
  return hit, true
end
function neo.lineOfSight(plr, point, allowClearRay)
  local hit, valid = shotCtl.rayTo(plr,point)
  local target=char(plr)
  if not valid or not target then return false end
  if not hit then return allowClearRay == true end
  return hit.Instance:IsDescendantOf(target)
end

-- Echantillonne le mouvement pour completer la vitesse repliquee.
function neo.targetVelocity(plr)
  local r = root(plr)
  if not r then return Vector3.zero end
  local now = os.clock()
  local history = aimHistory[plr]
  if not history or history.part ~= r then
    history = {part = r, pos = r.Position, at = now, velocity = r.AssemblyLinearVelocity}
    aimHistory[plr] = history
  else
    local dt = now - history.at
    if dt >= 0.055 then
      local measured = (r.Position - history.pos) / dt
      if measured.Magnitude <= 95 then
        history.velocity = history.velocity:Lerp(measured, 0.55)
      else
        history.velocity = r.AssemblyLinearVelocity
      end
      history.pos, history.at = r.Position, now
    end
  end
  local replicated = r.AssemblyLinearVelocity
  local velocity = replicated * 0.6 + history.velocity * 0.4
  if velocity.Magnitude < 1 then
    local h = hum(plr)
    if h then velocity = h.MoveDirection * h.WalkSpeed end
  end
  return Vector3.new(velocity.X, math.clamp(velocity.Y, -25, 25), velocity.Z)
end

function neo.predictionTime(distance)
  local ping = 0.07
  local ok, measured = pcall(function() return Local:GetNetworkPing() end)
  if ok and type(measured) == 'number' then ping = math.clamp(measured, 0.015, 0.23) end
  -- MM2 tire quasiment instantanement : distance = correction moderee, pas temps de vol fictif.
  return math.clamp(ping + 0.025 + distance / 4200, 0.035, 0.24)
end

-- Calcule un point sur le Murderer : buste d'abord, tete en dernier recours.
-- Predire trop loin fait rater les tirs, donc le deplacement anticipe est plafonne.
function neo.visibleAimPosition(plr)
  local c, r = char(plr), root(plr)
  if not c or not r or not alive(plr) then return nil end
  local upper = c:FindFirstChild('UpperTorso') or c:FindFirstChild('Torso')
  local head = c:FindFirstChild('Head')
  local options = {}
  if upper and upper:IsA('BasePart') then table.insert(options, upper.Position) end
  table.insert(options, r.Position + Vector3.new(0, 0.85, 0))
  if head and head:IsA('BasePart') then table.insert(options, head.Position) end
  local from = shotCtl.shootingOrigin()
  if not from then return nil end
  local leadTime = state.prediction and neo.predictionTime((from-r.Position).Magnitude) or 0
  local velocity = state.prediction and neo.targetVelocity(plr) or Vector3.zero
  for _,point in ipairs(options) do
    if neo.lineOfSight(plr,point,false) then
      if leadTime > 0 then
        local move = velocity * leadTime
        if move.Magnitude > 5.5 then move = move.Unit * 5.5 end
        local predicted = point + move
        -- Une zone vide devant le joueur ne garantit pas un hit. 
        -- Le decalage reste faible pour ne pas faire tirer a cote du corps.
        if move.Magnitude<=2.2 and neo.lineOfSight(plr,predicted,true) then return predicted end
      end
      return point
    end
  end
  return nil
end

-- Triggerbot mobile : n'active l'arme que si le rayon du viseur touche le Murderer.
-- Ce controle est different d'un aimbot : aucun tir si le rayon touche un innocent.
function neo.crosshairOnMurderer(plr)
  local cam=workspace.CurrentCamera
  if not cam or not plr or not char(plr) or not root(Local) then return false end
  local vp=cam.ViewportSize
  local ray=cam:ViewportPointToRay(vp.X*.5,vp.Y*.5)
  local params=RaycastParams.new()
  params.FilterType=Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances={char(Local)}
  params.IgnoreWater=true
  local hit=workspace:Raycast(ray.Origin,ray.Direction*600,params)
  if not hit or not hit.Instance:IsDescendantOf(char(plr)) then return false end
  -- La vraie ligne depuis le pistolet doit egalement etre degagee.
  local pos=hit.Position
  return neo.lineOfSight(plr,pos,false)
end

function neo.faceAt(pos)
  local cam=workspace.CurrentCamera
  if cam and pos and not state.freecam and watching==nil then
    cam.CFrame=CFrame.lookAt(cam.CFrame.Position,pos)
  end
end

-- ===== CODE PORTE DEPUIS YARHM 1.21 (GPL-3.0) =====
-- Source: https://github.com/Joystickplays/psychic-octo-invention/blob/main/source/yarhm/1.21/yarhm.lua
-- getPredictedPosition + bouton "Shoot murderer" sont reproduits sans notre ancienne visibilite
-- ni notre ancienne correction de vitesse. Ajouts NEO : controles nil et securite de cible.
function neo.yarhmPredictedPosition(player, shootOffset)
  local character=player and player.Character
  -- Compatible avec les avatars R15 et R6 (sans UpperTorso).
  local playerHRP=character and (character:FindFirstChild('UpperTorso')
    or character:FindFirstChild('Torso') or character:FindFirstChild('HumanoidRootPart'))
  local playerHum=character and character:FindFirstChild('Humanoid')
  if not playerHRP or not playerHum then
    return nil,'YARHM : Torso/RootPart ou Humanoid absent.'
  end
  local velocity=playerHRP.AssemblyLinearVelocity
  local playerMoveDirection=playerHum.MoveDirection
  -- Calcul YARHM 1.21 : meme multiplicateur vitesse, meme offset 2.8.
  local predictedPosition=playerHRP.Position +
    ((velocity*Vector3.new(0.75,0.5,0.75)))*(shootOffset/15) +
    playerMoveDirection*shootOffset
  -- YARHM utilise offsetToPingMult=1, ce qui rend son multiplicateur reseau egal a 1.
  -- Aucun deuxieme calcul de ping ou de lead n'est ajoute.
  return predictedPosition
end

function shotCtl.findRemote(gun)
  local remote=gun and gun:FindFirstChild('Shoot')
  if remote and remote:IsA('RemoteEvent') then return remote,'YARHM Gun.Shoot' end
  return nil,'YARHM Gun.Shoot absent'
end

-- Verification YARHM 1.21 pour la boucle AUTO uniquement.
-- Son bouton manuel ne verifie pas les murs et tire au clic.
function neo.yarhmAutoVisible(target)
  local me=root(Local)
  local other=root(target)
  local own=char(Local)
  local tc=char(target)
  if not me or not other or not own or not tc then return false end
  local raycastParams=RaycastParams.new()
  raycastParams.FilterType=Enum.RaycastFilterType.Exclude
  raycastParams.FilterDescendantsInstances={own}
  local hit=workspace:Raycast(me.Position,other.Position-me.Position,raycastParams)
  return not hit or (hit.Instance and hit.Instance:IsDescendantOf(tc))
end

function neo.shootOneTap(mode, confirmedTarget)
  if not active then return false,'Hub desactive.' end
  if neo.adminIsBlocked('shoot') then return false,'SHOOT interdit par le panneau NEO ADMIN.' end
  if shotBusy then return false,'Tir deja en cours.' end
  -- L attente est reservee a l AUTO : le bouton manuel garde le fonctionnement YARHM.
  if (mode=='AUTO' or mode=='FLING' or mode=='SHERIFF_COMBO') and os.clock()<nextShot then return false,'Recharge en cours.' end
  if mode=='FLING' and os.clock()-lastShot<shotCtl.cooldown then return false,'Pistolet encore en recharge.' end
  if state.freecam or watching~=nil then return false,'Quitte Freecam/Spectate pour tirer.' end
  if not alive(Local) then return false,'Ton personnage est elimine.' end
  local murderer=findMurderer()  -- Jamais de choix arbitraire d'un innocent.
  if mode=='SHERIFF_COMBO' and confirmedTarget then
    local roleEntry=roles[confirmedTarget.Name]
    local roleContradicts=os.clock()-rolesReceivedAt<8 and type(roleEntry)=='table'
      and type(roleEntry.Role)=='string' and roleEntry.Role~='Murderer'
    local tc=char(confirmedTarget)
    local tb=confirmedTarget:FindFirstChildOfClass('Backpack')
    local knifePresent=(tc and tc:FindFirstChild('Knife'))
      or (tb and tb:FindFirstChild('Knife'))
    if (roleContradicts and not knifePresent) or (murderer and murderer~=confirmedTarget) then
      return false,'Le joueur confirme n est plus le Murderer.'
    end
    if confirmedTarget.Parent==Players and alive(confirmedTarget) then murderer=confirmedTarget end
  end
  if not murderer or not alive(murderer) then return false,'Murderer non identifie.' end
  local c=char(Local)
  local gun=tool('Gun')
  if not gun then return false,'YARHM : pas de Gun.' end
  if gun.Parent~=c then
    local humanoid=hum(Local)
    if not humanoid then return false,'YARHM : pas de Humanoid.' end
    pcall(function() humanoid:EquipTool(gun) end)
    if gun.Parent~=c then return false,'YARHM : attends que le Gun soit equipe.' end
  end
  local hand=c and c:FindFirstChild('RightHand')
  -- YARHM 1.21 se sert de RightHand (R15). R6: Right Arm en secours.
  if not hand then hand=c and c:FindFirstChild('Right Arm') end
  if not hand or not hand:IsA('BasePart') then return false,'YARHM : main introuvable.' end
  local remote,remoteMethod=shotCtl.findRemote(gun)
  if not remote then return false,remoteMethod end
  if (mode=='AUTO' or mode=='FLING') and not neo.yarhmAutoVisible(murderer) then
    return false,'YARHM : cible masquee.'
  end
  local predictedPosition,reason=neo.yarhmPredictedPosition(murderer,shotCtl.offset)
  if not predictedPosition then return false,reason end
  if not active or not alive(murderer) then return false,'Murderer elimine.' end
  local args={CFrame.new(hand.Position),CFrame.new(predictedPosition)}
  -- Copie du tir YARHM 1.21 : Gun.Shoot:FireServer(unpack(args))
  shotBusy=true
  shotCtl.token=shotCtl.token+1
  local token=shotCtl.token
  shotCtl.lastTarget=murderer.Name
  shotCtl.status='Tir YARHM en cours...'
  local ok,err=pcall(function()
    remote:FireServer(unpack(args))
  end)
  -- Toujours liberer le verrou, meme si un reset survient pendant FireServer.
  shotBusy=false
  if not active or token~=shotCtl.token then
    return false,'Tir interrompu lors du reset.'
  end
  if not ok then
    shotCtl.status='YARHM FireServer : '..tostring(err):sub(1,90)
    return false,shotCtl.status
  end
  stats.shots=stats.shots+1
  lastShot=os.clock()
  if mode=='AUTO' or mode=='FLING' or mode=='SHERIFF_COMBO' then nextShot=os.clock()+shotCtl.cooldown end
  shotCtl.status='YARHM Gun.Shoot envoye vers '..murderer.Name..' (hit non confirme).'
  return true,shotCtl.status
end

local function stab(plr)
  if not plr or plr==Local or not alive(plr) then return false end
  local k=equipped('Knife'); if not k then return false end
  local r=root(plr); if not r then return false end
  local mine=root(Local); if not mine then return false end
  if (mine.Position-r.Position).Magnitude>13 then return false end
  pcall(function() k:Activate() end)
  local handle=k:FindFirstChild('Handle')
  if handle and typeof(firetouchinterest)=='function' then
    pcall(function()
      firetouchinterest(handle,r,0)
      firetouchinterest(handle,r,1)
    end)
  end
  return true
end
-- Kill All TP : ancienne teleportation de joueur en joueur, relancee en continu.
-- On utilise exactement le TP + stab historique; aucune modification du Fly/farm.
-- Arret par bouton STOP, par mort, par fermeture du HUB ou par fin des cibles.
-- La validation des touches appartient au serveur MM2.
neo.killAllBusy=false
function neo.stopKillAllTP()
  if not neo.killAllBusy then return false end
  killAllToken=killAllToken+1
  return true
end
function neo.killAllAttempt(status)
  if neo.adminIsBlocked('killAll') then status('KILL ALL verrouille par NEO ADMIN.');return end
  if neo.killAllBusy then status('Kill All TP deja en cours. Utilise STOP pour arreter.');return end
  if not active or not alive(Local) then status('Personnage vivant requis.');return end
  if not tool('Knife') then status('Couteau requis.');return end
  local initialRoot=root(Local)
  local original=initialRoot and initialRoot.CFrame
  if not original then status('Personnage introuvable.');return end
  if not equipped('Knife') then status('Impossible d equiper le couteau.');return end
  neo.killAllBusy=true
  killAllToken=killAllToken+1
  local currentToken=killAllToken
  status('Kill All TP : parcours continu, STOP pour arreter.')
  task.spawn(function()
    local passes, attempts, completed = 0, 0, false
    local reason=nil
    local ok,err=xpcall(function()
      while active and currentToken==killAllToken do
        if not alive(Local) then reason='personnage elimine';break end
        if neo.adminIsBlocked('killAll') then reason='bloque par NEO ADMIN';break end
        if not equipped('Knife') then reason='couteau indisponible';break end
        local targets={}
        for _,p in ipairs(Players:GetPlayers()) do
          if p~=Local and alive(p) then table.insert(targets,p) end
        end
        if #targets==0 then completed=true;break end
        passes=passes+1
        for _,p in ipairs(targets) do
          if not active or currentToken~=killAllToken or not alive(Local) then break end
          if p~=Local and p.Parent==Players and alive(p) then
            local mine=root(Local)
            local r=root(p)
            if mine and r then
              -- TP historique : meme offset et meme rythme que la version precedente.
              pcall(function() mine.CFrame=r.CFrame*CFrame.new(0,0,2.5) end)
              task.wait(.12)
              if not active or currentToken~=killAllToken or not alive(Local) then break end
              if alive(p) and equipped('Knife') then
                if stab(p) then attempts=attempts+1 end
              end
              task.wait(.45)
            end
          end
        end
        if not active or currentToken~=killAllToken then break end
        -- Un passage ne signifie pas que les cibles sont mortes : le suivant reessaie.
        -- Les cibles restantes sont recalculees chaque tour, pas d arret arbitraire.
        if passes%3==0 then status('Kill All TP : '..passes..' passages, poursuite des cibles vivantes...') end
        task.wait(.10)
      end
    end,function(e) return tostring(e) end)
    -- Si un reset a cree un nouvel avatar, ne jamais teleporter ce nouvel avatar.
    if active and root(Local)==initialRoot and alive(Local) then
      pcall(function() initialRoot.CFrame=original end)
    end
    neo.killAllBusy=false
    if not active then return end
    if not ok then status('Kill All TP : '..tostring(err):sub(1,100))
    elseif completed then status('Kill All TP : plus aucune cible vivante detectee ('..passes..' passages).')
    elseif currentToken~=killAllToken then status('Kill All TP arrete.')
    else status('Kill All TP interrompu : '..(reason or 'conditions de jeu changees')..'.') end
  end)
end

-- GUI V3.2 | large, aerée, responsive iPhone / tablette
-- Ancien menu orphelin : une relance de Delta ne doit pas superposer deux interfaces.
do
  local oldGui=PG:FindFirstChild('NEO_MM2_HUB')
  if oldGui then pcall(function() oldGui:Destroy() end) end
end
local gui=Instance.new('ScreenGui')
gui.Name='NEO_MM2_HUB'
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.DisplayOrder=80
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=PG

local function corner(obj,r)
  local c=Instance.new('UICorner')
  c.CornerRadius=UDim.new(0,r or 12)
  c.Parent=obj
  return c
end
local function stroke(obj,color,width,transparency)
  local x=Instance.new('UIStroke')
  x.Color=color or hue.primary
  x.Thickness=width or 1
  x.Transparency=transparency or .72
  x.Parent=obj
  return x
end
local function make(class,props,parent)
  local x=Instance.new(class)
  for k,v in pairs(props or {}) do x[k]=v end
  x.Parent=parent
  return x
end
local function text(parent,s,size,color)
  return make('TextLabel',{
    BackgroundTransparency=1,Text=s,TextColor3=color or hue.text,
    TextSize=size or 14,Font=Enum.Font.GothamMedium,
    TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true
  },parent)
end
-- V3.4 : style menu sombre avec navigation laterale et recherche globale.
-- Toutes les fonctions gameplay restent celles de la V3.2.
local UI = {
  bg=Color3.fromRGB(20,20,22), side=Color3.fromRGB(17,17,19),
  panel=Color3.fromRGB(33,33,35), item=Color3.fromRGB(24,24,26),
  itemHover=Color3.fromRGB(44,44,47), outline=Color3.fromRGB(66,66,69),
  white=Color3.fromRGB(248,248,250), dim=Color3.fromRGB(165,165,173),
  red=Color3.fromRGB(208,60,85), on=Color3.fromRGB(41,106,82)
}
local function viewSize()
  local cam=workspace.CurrentCamera
  local v=cam and cam.ViewportSize or Vector2.new(390,780)
  if v.X<250 or v.Y<250 then return Vector2.new(390,780) end
  return v
end
local window=make('Frame',{
  Name='Window',Size=UDim2.fromOffset(780,500),
  AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
  BackgroundColor3=UI.bg,BorderSizePixel=0,Active=true,ClipsDescendants=true
},gui)
corner(window,18)
stroke(window,Color3.fromRGB(88,88,92),1,.5)
-- Barre du haut, plus sobre et moins haute que l'ancienne.
local hdr=make('Frame',{
  Name='Header',Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,0,59),
  BackgroundColor3=UI.side,BorderSizePixel=0,Active=true
},window)
local logo=text(hdr,'NEO  /  MM2',19,UI.white)
logo.Font=Enum.Font.GothamBold
logo.Position=UDim2.fromOffset(18,9)
logo.Size=UDim2.new(1,-110,0,25)
local sub=text(hdr,'HUB V6.9.2  •  EMOTES + ADMIN',10,UI.dim)
sub.Position=UDim2.fromOffset(19,34)
sub.Size=UDim2.new(1,-113,0,18)
local minimize=make('TextButton',{
  Text='−',TextSize=23,Font=Enum.Font.GothamBold,TextColor3=UI.white,
  BackgroundColor3=UI.panel,Position=UDim2.new(1,-80,0,12),Size=UDim2.fromOffset(32,34)
},hdr);corner(minimize,8)
local close=make('TextButton',{
  Text='×',TextSize=22,Font=Enum.Font.GothamBold,TextColor3=UI.white,
  BackgroundColor3=UI.panel,Position=UDim2.new(1,-42,0,12),Size=UDim2.fromOffset(32,34)
},hdr);corner(close,8)
make('Frame',{
  Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),
  BackgroundColor3=UI.outline,BorderSizePixel=0
},hdr)

local ribbon=make('TextButton',{
  Name='ReouvrirNEO',AnchorPoint=Vector2.new(.5,0),
  Position=UDim2.new(.5,-24,0,5),Size=UDim2.fromOffset(200,37),
  Text='NEO MM2   |   OUVRIR  ▾',TextSize=13,
  Font=Enum.Font.GothamBold,TextColor3=UI.white,
  BackgroundColor3=UI.side,Visible=false,Active=true
},gui)
corner(ribbon,10);stroke(ribbon,UI.red,1,0)

-- Seul bouton de tir sur le bord DROIT. Visible aussi lorsque le menu est reduit.
shotCtl.sideButton=make('TextButton',{
  Name='ShootYARHM',AnchorPoint=Vector2.new(1,.5),
  Position=UDim2.new(1,-9,.57,0),Size=UDim2.fromOffset(88,66),
  Text='🎯  SHOOT',TextColor3=UI.white,TextSize=16,
  Font=Enum.Font.GothamBold,TextWrapped=true,
  BackgroundColor3=UI.red,Visible=true,Active=true,
  AutoButtonColor=true,ZIndex=50,BorderSizePixel=0
},gui)
corner(shotCtl.sideButton,14)
stroke(shotCtl.sideButton,UI.white,1,.48)
-- Feedback visible meme si la fenetre principale est reduite.
shotCtl.sideNotice=make('TextLabel',{
  Name='ShootStatus',AnchorPoint=Vector2.new(1,0),
  Position=UDim2.new(1,-9,.57,40),Size=UDim2.fromOffset(190,50),
  Text='',TextColor3=UI.white,TextSize=12,TextWrapped=true,
  Font=Enum.Font.GothamMedium,BackgroundColor3=UI.side,
  Visible=false,ZIndex=51,BorderSizePixel=0
},gui)
corner(shotCtl.sideNotice,9)
stroke(shotCtl.sideNotice,UI.outline,1,.4)

-- Colonne de gauche fixe. Seule la liste des rubriques defile.
local sidebar=make('Frame',{
  Name='Sidebar',Position=UDim2.fromOffset(0,59),
  Size=UDim2.new(0,179,1,-88),BackgroundColor3=UI.side,BorderSizePixel=0
},window)
make('Frame',{
  Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),
  BackgroundColor3=UI.outline,BorderSizePixel=0
},sidebar)
local navScroll=make('ScrollingFrame',{
  Name='Navigation',Position=UDim2.fromOffset(8,8),Size=UDim2.new(1,-16,1,-16),
  BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.fromOffset(0,0),
  AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,
  ScrollBarImageColor3=UI.dim,ScrollingDirection=Enum.ScrollingDirection.Y
},sidebar)
local navLayout=make('UIListLayout',{
  Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder
},navScroll)

-- Grand panneau de droite, inspire du menu fourni en capture.
local main=make('Frame',{
  Name='MainPanel',Position=UDim2.fromOffset(179,59),
  Size=UDim2.new(1,-179,1,-88),BackgroundColor3=UI.panel,BorderSizePixel=0
},window)
local search=make('TextBox',{
  Name='Search',Position=UDim2.fromOffset(17,12),Size=UDim2.new(1,-34,0,37),
  Text='',PlaceholderText='Rechercher une fonction...',ClearTextOnFocus=false,
  TextSize=13,Font=Enum.Font.GothamMedium,
  TextColor3=UI.white,PlaceholderColor3=UI.dim,
  BackgroundColor3=UI.item,TextXAlignment=Enum.TextXAlignment.Left
},main)
corner(search,11);stroke(search,UI.outline,1,.45)
make('UIPadding',{PaddingLeft=UDim.new(0,13),PaddingRight=UDim.new(0,12)},search)
local pageTitle=text(main,'ACCUEIL',20,UI.white)
pageTitle.Font=Enum.Font.GothamBold
pageTitle.Position=UDim2.fromOffset(18,60)
pageTitle.Size=UDim2.new(1,-35,0,31)
local pageSubtitle=text(main,'Choisis une rubrique à gauche.',11,UI.dim)
pageSubtitle.Position=UDim2.fromOffset(19,89)
pageSubtitle.Size=UDim2.new(1,-35,0,18)

local content=make('ScrollingFrame',{
  Name='Options',Position=UDim2.fromOffset(17,116),
  Size=UDim2.new(1,-34,1,-125),BackgroundTransparency=1,BorderSizePixel=0,
  ScrollBarThickness=3,ScrollBarImageColor3=UI.dim,
  CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
  ScrollingDirection=Enum.ScrollingDirection.Y
},main)
local layout=make('UIListLayout',{
  Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder
},content)
-- La recherche s'affiche AU-DESSUS des options, sans changer d'onglet.
local searchResults=make('ScrollingFrame',{
  Name='SearchResults',Position=UDim2.fromOffset(17,54),Size=UDim2.new(1,-34,1,-61),
  BackgroundColor3=UI.panel,BorderSizePixel=0,Visible=false,
  CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
  ScrollBarThickness=3,ScrollBarImageColor3=UI.red,
  ZIndex=20
},main)
corner(searchResults,9)
local searchLayout=make('UIListLayout',{
  Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder
},searchResults)
local footer=make('Frame',{
  Name='Footer',Position=UDim2.new(0,0,1,-29),Size=UDim2.new(1,0,0,29),
  BackgroundColor3=UI.side,BorderSizePixel=0
},window)
make('Frame',{
  Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,0,2),
  BackgroundColor3=UI.red,BorderSizePixel=0
},footer)
local info=text(footer,'Rôle : detection...',10,UI.dim)
info.TextTruncate=Enum.TextTruncate.AtEnd
info.Position=UDim2.fromOffset(10,6)
info.Size=UDim2.new(.51,-10,0,19)
local bottom=text(footer,'Prêt.',10,UI.white)
bottom.TextTruncate=Enum.TextTruncate.AtEnd
bottom.TextXAlignment=Enum.TextXAlignment.Right
bottom.Position=UDim2.new(.51,0,0,6)
bottom.Size=UDim2.new(.49,-12,0,19)

function neo.fitResponsive()
  local v=viewSize()
  local wide=v.X>=660
  local width=math.min(wide and 855 or 515, math.max(280,v.X-20))
  local height=math.min(wide and 565 or 650, math.max(250,v.Y-22))
  window.Size=UDim2.fromOffset(width,height)
  local side=width<420 and 112 or (width<600 and 137 or 179)
  sidebar.Size=UDim2.new(0,side,1,-88)
  main.Position=UDim2.fromOffset(side,59)
  main.Size=UDim2.new(1,-side,1,-88)
  if neo.emoteReflow then task.defer(neo.emoteReflow) end
  if width<435 then
    logo.TextSize=16;logo.Size=UDim2.new(1,-100,0,25)
    sub.TextSize=8
    minimize.Position=UDim2.new(1,-77,0,13)
    close.Position=UDim2.new(1,-40,0,13)
    pageTitle.TextSize=17
    search.TextSize=11
  else
    logo.TextSize=19;sub.TextSize=10
    minimize.Position=UDim2.new(1,-80,0,12)
    close.Position=UDim2.new(1,-42,0,12)
    pageTitle.TextSize=20
    search.TextSize=13
  end
end
neo.fitResponsive()
local function status(s) if active then bottom.Text=s end end
shotCtl.showMessage=function(message)
  if not active then return end
  status(message)
  shotCtl.sideNotice.Text=message
  shotCtl.sideNotice.Visible=true
  shotCtl.noticeToken=(shotCtl.noticeToken or 0)+1
  local ticket=shotCtl.noticeToken
  task.delay(3.3,function()
    if active and ticket==shotCtl.noticeToken then
      shotCtl.sideNotice.Visible=false
    end
  end)
end
shotCtl.showStatus=shotCtl.showMessage
-- Le bouton lateral utilise le tir YARHM immediat ; seule la boucle auto est cadencee.
-- Le tir automatique reste desactive par defaut et n'est jamais force.
connect(shotCtl.sideButton.MouseButton1Click,function()
  if shotBusy then
    shotCtl.showMessage('Tir en cours.')
    return
  end
  shotCtl.sideButton.Text='TIR...'
  task.spawn(function()
    local callOK,success,msg=pcall(neo.shootOneTap,'MANUEL')
    if active then
      if callOK then shotCtl.showMessage(msg or (success and 'Tentative envoyee.' or 'Tir impossible.'))
      else shotCtl.showMessage('Erreur SHOOT : '..tostring(success):sub(1,80)) end
    end
  end)
end)
-- Un seul moteur YARHM 1.21 : mode AUTO optionnel, sans bouger la camera.
-- La fonction pcall est lancee en task separee pour ne pas bloquer les frames.
task.spawn(function()
  while active do
    if state.autoShoot and not neo.sheriffComboActive
      and not neo.adminIsBlocked('shoot') and not neo.adminIsBlocked('autoShoot')
      and tool('Gun') and alive(Local) and not shotBusy and not shotCtl.queued
      and os.clock()>=nextShot and not state.freecam and not watching then
      -- Anti-doublon : a 50 scans/s, une seule tentative peut etre en file.
      shotCtl.queued=true
      task.spawn(function()
        local ran,ok,msg=pcall(neo.shootOneTap,'AUTO')
        shotCtl.queued=false
        if active and ran and ok and shotCtl.showMessage then
          shotCtl.showMessage(msg)
        elseif active and not ran and shotCtl.showMessage then
          shotCtl.showMessage('Auto-Shoot erreur : '..tostring(ok):sub(1,65))
        end
      end)
    end
    task.wait(.02)
  end
end)

-- Mise a jour légère de l'apparence du bouton (iPhone compris).
shotCtl.nextButtonUpdate=0
connect(RunService.Heartbeat,function()
  if not active or os.clock()<shotCtl.nextButtonUpdate then return end
  shotCtl.nextButtonUpdate=os.clock()+.16
  if shotBusy then
    shotCtl.sideButton.Text='TIR...'
    shotCtl.sideButton.BackgroundColor3=Color3.fromRGB(140,92,36)
  elseif tool('Gun') and alive(Local) then
    shotCtl.sideButton.Text='🎯 SHOOT'
    shotCtl.sideButton.BackgroundColor3=UI.red
  else
    shotCtl.sideButton.Text='SHOOT'
    shotCtl.sideButton.BackgroundColor3=Color3.fromRGB(76,76,80)
  end
end)

local function minimizeHub()
  window.Visible=false
  ribbon.Visible=true
end
local function restoreHub()
  window.Visible=true
  ribbon.Visible=false
end
local function draggable(handle,target)
  local dragging,dragStart,startPos,inputOrigin=false,nil,nil,nil
  connect(handle.InputBegan,function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
      dragging=true;dragStart=input.Position;startPos=target.Position;inputOrigin=input
      local c
      c=input.Changed:Connect(function()
        if input.UserInputState==Enum.UserInputState.End then
          dragging=false
          if c then c:Disconnect() end
        end
      end)
      table.insert(connections,c)
    end
  end)
  connect(UIS.InputChanged,function(input)
    if dragging and dragStart and (input==inputOrigin or input.UserInputType==Enum.UserInputType.MouseMovement) then
      local diff=input.Position-dragStart
      target.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+diff.X,startPos.Y.Scale,startPos.Y.Offset+diff.Y)
    end
  end)
end
draggable(hdr,window)
connect(minimize.MouseButton1Click,minimizeHub)
connect(close.MouseButton1Click,minimizeHub)
connect(ribbon.MouseButton1Click,restoreHub)
local camera=workspace.CurrentCamera
if camera then connect(camera:GetPropertyChangedSignal('ViewportSize'),neo.fitResponsive) end

local contentOrder=0
local function clearContent()
  contentOrder=0;inspectorText=nil
  if neo.rojoiner then neo.rojoiner.browserStatusLabel=nil end
  for _,child in ipairs(content:GetChildren()) do
    if child~=layout then child:Destroy() end
  end
  content.CanvasPosition=Vector2.zero
end
local function section(s)
  local l=text(content,s,17,UI.white)
  l.Font=Enum.Font.GothamBold
  l.Size=UDim2.new(1,-8,0,32)
  l.TextYAlignment=Enum.TextYAlignment.Center
  contentOrder=contentOrder+1;l.LayoutOrder=contentOrder
  return l
end
local function note(s)
  local l=text(content,s,12,UI.dim)
  l.Size=UDim2.new(1,-8,0,0)
  l.AutomaticSize=Enum.AutomaticSize.Y
  l.TextYAlignment=Enum.TextYAlignment.Top
  local pad=make('UIPadding',{
    PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,10),
    PaddingTop=UDim.new(0,5),PaddingBottom=UDim.new(0,7)
  },l)
  contentOrder=contentOrder+1;l.LayoutOrder=contentOrder
  return l
end
local function button(s,fn,col)
  local b=make('TextButton',{
    Size=UDim2.new(1,-8,0,43),Text=s,TextColor3=UI.white,
    TextSize=13,TextWrapped=false,TextTruncate=Enum.TextTruncate.AtEnd,
    TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,
    BackgroundColor3=(col==hue.red and Color3.fromRGB(85,31,43)) or
      (col==hue.primary and Color3.fromRGB(62,52,91)) or UI.item,
    BorderSizePixel=0,AutoButtonColor=true
  },content)
  corner(b,13)
  make('UIPadding',{
    PaddingLeft=UDim.new(0,17),PaddingRight=UDim.new(0,12)
  },b)
  contentOrder=contentOrder+1;b.LayoutOrder=contentOrder
  b.MouseButton1Click:Connect(function()
    -- Sur une copie cible, le blocage global interdit les actions du HUB.
    -- Laisser accessibles les boutons de securite/arret/menu et la sauvegarde.
    if neo.adminBlocked.ALL and not isAdminOwner then
      local name=string.upper(s)
      local allowed=string.find(name,'STOP',1,true) or
        string.find(name,'ARRETER',1,true) or
        string.find(name,'ARRÊTER',1,true) or
        string.find(name,'FERMER',1,true) or
        string.find(name,'REDUIRE',1,true) or
        string.find(name,'RÉDUIRE',1,true) or
        string.find(name,'RETOUR',1,true) or
        string.find(name,'QUITTER',1,true) or
        string.find(name,'SAUVEGARDER',1,true)
      if not allowed then status('NEO ADMIN : toutes les fonctions sont verrouillees.');return end
    end
    local ok,err=pcall(fn)
    if not ok then status('Erreur : '..tostring(err):sub(1,80)) end
    -- Enregistre aussi les boutons qui changent un etat sans passer par toggle().
    if active then neo.saveOptions() end
  end)
  return b
end
local toggleLighting, restoreNoclip
local function toggle(key,label)
  local renderToggle
  local b=button(label,function()
    if not state[key] and neo.adminIsBlocked(key) then
      status('NEO ADMIN : '..label..' est desactive pour cette copie.')
      return
    end
    state[key]=not state[key]
    if key=='autoRoles' then
      if state.autoRoles then neo.autoRoleBegin() else neo.autoRoleStop('desactive depuis le menu') end
    end
    if key=='manualFly' then
      if state.manualFly then neo.startManualFly() else neo.stopManualFly() end
    end
    if key=='noclip' and not state.noclip and not state._autoGhostActive and not state.manualFly then restoreNoclip() end
    if key=='bright' and not state.bright then toggleLighting() end
    neo.saveOptions()
    if key=='esp' or key=='gunESP' then
      local ok,err=pcall(neo.refreshESP)
      if not ok then status('Erreur ESP : '..tostring(err):sub(1,100)) end
    end
    renderToggle()
  end)
  -- Interrupteur visuel comme sur la capture, rangé toujours à droite.
  local track=make('Frame',{
    Size=UDim2.fromOffset(51,26),AnchorPoint=Vector2.new(1,.5),
    Position=UDim2.new(1,-12,.5,0),BackgroundColor3=Color3.fromRGB(12,12,13),
    BorderSizePixel=0,Active=false
  },b);corner(track,13)
  local knob=make('Frame',{
    Size=UDim2.fromOffset(20,20),Position=UDim2.fromOffset(3,3),
    BackgroundColor3=UI.white,BorderSizePixel=0,Active=false
  },track);corner(knob,10)
  local pad=b:FindFirstChildOfClass('UIPadding')
  if pad then pad.PaddingRight=UDim.new(0,76) end
  renderToggle=function()
    if not active or not b.Parent then return end
    b.Text=label
    track.BackgroundColor3=state[key] and UI.on or Color3.fromRGB(12,12,13)
    knob.Position=UDim2.fromOffset(state[key] and 28 or 3,3)
  end
  renderToggle()
  return b
end

local selectedTab='ACCUEIL'
local navBtns={}
local categoryGroups={
  {name='MENU',tabs={{'ACCUEIL','Accueil'}}},
  {name='MURDER MYSTERY 2',tabs={{'AUTO_ROLES','Auto tous rôles'},{'SHERIF','Shérif'},{'MURDER','Meurtrier'},{'ESP','ESP et rôles'},{'JOUEURS','Joueurs'},{'ECHANGES','Échanges'},{'ROJOINER','RoJoiner'}}},
  {name='EXPLORATION',tabs={{'SURVIE','Survie'},{'CARTE','Carte et pièces'},{'MOVE','Déplacements'}}},
  {name='AUTRES',tabs={{'EXTRAS','Extras'},{'FUN','Fun et clone'},{'EMOTES','Danses et emotes'},{'OUTILS','Outils'},{'OPTIONS','Paramètres'}}}
}
if isAdminOwner then
  table.insert(categoryGroups,2,{name='CONTRÔLEUR',tabs={{'ADMIN','🛡 Panneau ADMIN'}}})
end
local labels={ACCUEIL='Accueil',SHERIF='Shérif',MURDER='Meurtrier',ESP='ESP et rôles',
  JOUEURS='Joueurs',ECHANGES='Échanges',ROJOINER='RoJoiner',SURVIE='Survie',CARTE='Carte et pièces',MOVE='Déplacements',
  EXTRAS='Extras',FUN='Fun et clone',EMOTES='Danses et emotes',OUTILS='Outils',OPTIONS='Paramètres',ADMIN='Panneau ADMIN'}
local subtitles={ACCUEIL='Raccourcis vers toutes les fonctions.',SHERIF='Un bouton SHOOT sur le bord droit.',
  MURDER='Actions avec le couteau.',ESP='Repères et détection.',
  JOUEURS='Choisis un joueur pour Fling YARHM, Attach et Body Block.',ECHANGES='WIN / FAIR / LOSE et prudence pour les gros lots.',ROJOINER='Acces rapide au site RoJoiner.',SURVIE='Dangers, fuite et retour caméra.',
  CARTE='Radar et caméra libre.',MOVE='Vitesse et déplacements.',
  EXTRAS='Trace, position et statistiques.',FUN='Effets visibles sur ton écran.',EMOTES='Catalogue Roblox avec favoris et recherche.',
  OUTILS='Notifications et performances.',OPTIONS='Réglages du hub.',ADMIN='0din01 : contrôle détaillé des copies NEO compatibles.'}
local showTab
local navOrder=0
for _,group in ipairs(categoryGroups) do
  navOrder=navOrder+1
  local heading=text(navScroll,group.name,10,UI.dim)
  heading.Size=UDim2.new(1,-8,0,24)
  heading.TextYAlignment=Enum.TextYAlignment.Bottom
  heading.Font=Enum.Font.GothamBold
  heading.LayoutOrder=navOrder
  for _,item in ipairs(group.tabs) do
    navOrder=navOrder+1
    local tab,caption=item[1],item[2]
    local b=make('TextButton',{
      Name=tab,Text=caption,TextSize=13,Font=Enum.Font.GothamMedium,
      TextColor3=UI.dim,TextXAlignment=Enum.TextXAlignment.Left,
      TextTruncate=Enum.TextTruncate.AtEnd,BackgroundColor3=UI.side,
      BorderSizePixel=0,Size=UDim2.new(1,-5,0,36),LayoutOrder=navOrder
    },navScroll);corner(b,10)
    make('UIPadding',{PaddingLeft=UDim.new(0,11),PaddingRight=UDim.new(0,8)},b)
    navBtns[tab]=b
    b.MouseButton1Click:Connect(function() showTab(tab) end)
  end
end
function neo.refreshNavigation(tab)
  pageTitle.Text=string.upper(labels[tab] or tab)
  pageSubtitle.Text=subtitles[tab] or ''
  for name,b in pairs(navBtns) do
    local selected=(name==tab)
    b.BackgroundColor3=selected and UI.white or UI.side
    b.TextColor3=selected and UI.side or UI.dim
    b.Font=selected and Enum.Font.GothamBold or Enum.Font.GothamMedium
  end
end

-- Recherche par nom : chaque resultat mene a la page exacte.
local searchIndex={
  {'SHOOT lateral (YARHM)','SHERIF','shérif héro bouton côté tirer meurtrier un tap'},
  {'Ramasser le pistolet','SHERIF','auto grab gun'},
  {'Trade Checker W/F/L','ECHANGES','echange trade valeurs win fair lose chroma arme petites armes demande liquidite'},
  {'Kill Aura','MURDER','couteau murder'},
  {'Kill All','MURDER','attaquer meurtrier'},
  {'ESP joueurs','ESP','voir joueurs couleur'},
  {'ESP pistolet tombé','ESP','gun drop'},
  {'FullBright','ESP','lumière éclairage'},
  {'Recherche de joueurs','JOUEURS','pseudo player'},
  {'Ouvrir RoJoiner / copier le lien','ROJOINER','rojoiner ouvrir site copier lien navigateur android'},
  {'Fiche du joueur / Inspecteur','JOUEURS','avatar rôle distance'},
  {'Spectate','JOUEURS','regarder spectateur caméra'},
  {'Follow Player','JOUEURS','suivre joueur'},
  {'Téléportation joueur','JOUEURS','tp position'},
  {'Fling YARHM et Attach Player','JOUEURS','fling coller souder weld detacher'},
  {'Body Block','JOUEURS','troll bloquer passage joueur cible devant stop'},
  {'Auto Escape','SURVIE','fuite danger automatique contrôle bouger chemin'},
  {'Auto Farm bonbons / pièces','CARTE','auto farm candy coins collecte deplacement'},
  {'Ligne rouge au sol','SURVIE','trajet escape route tracer fuite rouge sol'},
  {'Threat Meter','SURVIE','danger murderer'},
  {'Retour urgence caméra','SURVIE','freecam spectate corps protection'},
  {'Safe Zone Scanner','SURVIE','refuge zone'},
  {'Coin Radar','CARTE','bonbons pièces candy coin'},
  {'TP MAP','CARTE','teleportation carte map partie actuelle spawn arene'},
  {'TP LOBBY','CARTE','teleportation lobby accueil spawn'},
  {'Freecam','CARTE','caméra libre explorer'},
  {'Vitesse / Speed','MOVE','marcher rapide'},
  {'Saut infini / Jump','MOVE','sauter'},
  {'Noclip','MOVE','collisions mur'},
  {'Murderer Trail','EXTRAS','trajectoire suivi'},
  {'Position enregistrée','EXTRAS','waypoint tp retour'},
  {'Statistiques de session','EXTRAS','stats'},
  {'Fake Clone','FUN','double avatar'},
  {'Danses et emotes','EMOTES','animations emote payantes gratuites danse catalogue favoris rechercher ID'},
  {'Notifications','OUTILS','alertes'},
  {'Performance / FPS','OUTILS','lag batterie'},
  {'Panneau ADMIN','ADMIN','0din01 modération options bloquer réactiver joueurs NEO'},
  {'Réduire en bande','OPTIONS','minimiser rouvrir fermer'}
}
function neo.renderSearch()
  for _,child in ipairs(searchResults:GetChildren()) do
    if child~=searchLayout then child:Destroy() end
  end
  local query=string.lower(search.Text):gsub('^%s+',''):gsub('%s+$','')
  if query=='' then searchResults.Visible=false;return end
  searchResults.Visible=true
  local matched=0
  for _,entry in ipairs(searchIndex) do
    local title,tab,keywords=entry[1],entry[2],entry[3]
    local pool=string.lower(title..' '..(labels[tab] or '')..' '..keywords)
    if (tab~='ADMIN' or isAdminOwner) and string.find(pool,query,1,true) then
      matched=matched+1
      local result=make('TextButton',{
        Size=UDim2.new(1,-6,0,43),BackgroundColor3=UI.item,
        Text=title..'   ›  '..(labels[tab] or tab),
        Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=UI.white,
        TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,
        BorderSizePixel=0,ZIndex=22
      },searchResults);corner(result,8)
      make('UIPadding',{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,8)},result)
      result.MouseButton1Click:Connect(function()
        search.Text=''
        searchResults.Visible=false
        if tab=='JOUEURS' then playerView='list' end
        showTab(tab)
      end)
    end
  end
  if matched==0 then
    local msg=text(searchResults,'Aucune fonction trouvée.',12,UI.dim)
    msg.Size=UDim2.new(1,-10,0,44)
    msg.ZIndex=22
  end
end
connect(search:GetPropertyChangedSignal('Text'),neo.renderSearch)
-- Ne pas ecraser l'eclairage naturel du jeu toutes les secondes.
local brightApplied=false
toggleLighting=function()
  if state.bright then
    if not brightApplied then
      originalBright={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,
        Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient}
      brightApplied=true
    end
    Lighting.Brightness=3;Lighting.ClockTime=14
    Lighting.Ambient=Color3.new(1,1,1);Lighting.OutdoorAmbient=Color3.new(1,1,1)
  elseif brightApplied then
    for key,value in pairs(originalBright) do Lighting[key]=value end
    brightApplied=false
  end
end
local function roleColor(role)
  if role=='Murderer' then return hue.red end
  if role=='Sheriff' or role=='Hero' then return hue.blue end
  return hue.green
end
local gunHl=nil
-- Deux rendus complementaires : Highlight pour la silhouette, BillboardGui pour
-- identifier le joueur si Roblox n'affiche pas le Highlight (limite du moteur).
neo.espLabels={}
function neo.cleanupESP()
  for p,h in pairs(highlights) do
    pcall(function() h:Destroy() end);highlights[p]=nil
  end
  for p,b in pairs(neo.espLabels) do
    pcall(function() b:Destroy() end);neo.espLabels[p]=nil
  end
  if gunHl then pcall(function() gunHl:Destroy() end);gunHl=nil end
end
function neo.refreshESP()
  if not active then return end
  if not state.esp and not state.gunESP then neo.cleanupESP();return end
  for p,h in pairs(highlights) do
    if p.Parent~=Players or not state.esp then
      pcall(function() h:Destroy() end);highlights[p]=nil
    end
  end
  for p,b in pairs(neo.espLabels) do
    if p.Parent~=Players or not state.esp then
      pcall(function() b:Destroy() end);neo.espLabels[p]=nil
    end
  end
  for _,p in ipairs(Players:GetPlayers()) do
    if p~=Local then
      local c=char(p)
      local r=root(p)
      if state.esp and c and r and alive(p) then
        local color=roleColor(getRole(p))
        local h=highlights[p]
        if not h or h.Parent~=workspace or h.Adornee~=c then
          if h then pcall(function() h:Destroy() end) end
          h=Instance.new('Highlight')
          h.Name='NeoRoleESP';h.Adornee=c
          h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
          h.FillTransparency=.66;h.OutlineTransparency=0
          h.Parent=workspace
          highlights[p]=h
        end
        h.Enabled=true;h.FillColor=color;h.OutlineColor=color
        -- Etiquette independente du Highlight : reste visible au retour sur
        -- le serveur et si plusieurs Highlights excedent la limite du client.
        local anchor=c:FindFirstChild('Head') or r
        local b=neo.espLabels[p]
        if not b or b.Parent~=gui or b.Adornee~=anchor then
          if b then pcall(function() b:Destroy() end) end
          b=Instance.new('BillboardGui')
          b.Name='NEO_ESP_Label';b.Adornee=anchor
          b.Size=UDim2.fromOffset(168,28)
          b.StudsOffsetWorldSpace=Vector3.new(0,anchor==r and 3 or 2,0)
          b.AlwaysOnTop=true;b.MaxDistance=600;b.Enabled=true
          local label=Instance.new('TextLabel')
          label.Name='RoleLabel';label.Size=UDim2.fromScale(1,1)
          label.BackgroundTransparency=.3
          label.BackgroundColor3=Color3.fromRGB(15,15,19)
          label.Font=Enum.Font.GothamBold;label.TextSize=12
          label.TextStrokeTransparency=.4
          label.Parent=b
          b.Parent=gui
          neo.espLabels[p]=b
        end
        b.Enabled=true
        local label=b:FindFirstChild('RoleLabel')
        if label then
          label.Text='@'..p.Name..'  •  '..getRole(p)
          label.TextColor3=color
        end
      else
        if highlights[p] then
          pcall(function() highlights[p]:Destroy() end);highlights[p]=nil
        end
        if neo.espLabels[p] then
          pcall(function() neo.espLabels[p]:Destroy() end);neo.espLabels[p]=nil
        end
      end
    end
  end
  if state.gunESP then
    local gun=workspace:FindFirstChild('GunDrop',true)
    if gun and gun:IsA('BasePart') then
      if not gunHl or gunHl.Adornee~=gun or gunHl.Parent~=workspace then
        if gunHl then pcall(function() gunHl:Destroy() end) end
        gunHl=Instance.new('Highlight')
        gunHl.Name='NeoGunESP';gunHl.Adornee=gun
        gunHl.FillColor=hue.blue;gunHl.OutlineColor=hue.text
        gunHl.FillTransparency=.25
        gunHl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        gunHl.Parent=workspace
      end
      gunHl.Enabled=true
    elseif gunHl then gunHl:Destroy();gunHl=nil end
  elseif gunHl then gunHl:Destroy();gunHl=nil end
end
-- Une option OFF laisse le jeu gerer librement vitesse et saut.
-- Valeurs d'origine relevees sur le Humanoid courant, pas 16/50 imposees.
local movementMemory=setmetatable({},{__mode='k'})
function neo.refreshMovement()
  local h=hum(Local)
  if not h then return end
  local mem=movementMemory[h]
  if not mem then mem={speed=false,jump=false};movementMemory[h]=mem end
  if state.speed then
    if not mem.speed then mem.walk=h.WalkSpeed;mem.speed=true end
    h.WalkSpeed=26
  elseif mem.speed then
    if math.abs(h.WalkSpeed-26)<0.1 then h.WalkSpeed=mem.walk or 16 end
    mem.speed=false
  end
  if state.jump then
    if not mem.jump then
      mem.jumpPower=h.JumpPower
      mem.useJumpPower=h.UseJumpPower
      mem.jump=true
    end
    h.UseJumpPower=true
    h.JumpPower=80
  elseif mem.jump then
    if math.abs(h.JumpPower-80)<0.1 then h.JumpPower=mem.jumpPower or 50 end
    if mem.useJumpPower~=nil then h.UseJumpPower=mem.useJumpPower end
    mem.jump=false
  end
end
local noclipSaved=setmetatable({},{__mode='k'})
restoreNoclip=function()
  for part,collide in pairs(noclipSaved) do
    if part and part.Parent then pcall(function() part.CanCollide=collide end) end
    noclipSaved[part]=nil
  end
end
-- Fling YARHM 1.21 : memes phases physiques de contact circulaire,
-- vitesses elevees et BodyVelocity temporaire. Le STOP et la restauration
-- sont renforces pour eviter un blocage indefini present dans le code origine.
-- YARHM par Aetherion/Joystickplays, GPL-3.0.
local function fling(p, durationOverride)
  if neo.adminIsBlocked('fling') then status('NEO ADMIN : FLING verrouille.');return end
  if flingBusy then status('Fling YARHM deja en cours.'); return end
  if not p or p==Local or p.Parent~=Players or not alive(p) or not alive(Local) then
    status('FLING YARHM : cible indisponible.'); return
  end
  local mineChar, enemyChar = char(Local), char(p)
  local mine, enemy = root(Local), root(p)
  local myHum, enemyHum = hum(Local), hum(p)
  if not mineChar or not enemyChar or not mine or not enemy or not myHum or not enemyHum then
    status('FLING YARHM : avatar introuvable.'); return
  end
  if neo.attachCtl and neo.attachCtl.target then neo.detachPlayer('Fling') end
  flingBusy,flingStop,flingTarget=true,false,p
  local original=mine.CFrame
  local camera=workspace.CurrentCamera
  local oldSubject=camera and camera.CameraSubject or nil
  local mover=nil
  local oldSeated=nil
  local oldFall=workspace.FallenPartsDestroyHeight
  status('FLING YARHM : '..p.Name)
  local ok,err=pcall(function()
    local head=enemyChar:FindFirstChild('Head')
    local accessory=enemyChar:FindFirstChildOfClass('Accessory')
    local handle=accessory and accessory:FindFirstChild('Handle')
    -- Suivre la vraie zone de collision (HumanoidRootPart), pas un accessoire.
    local base=enemy or head or handle
    if not base or not base:IsA('BasePart') then error('aucune partie physique de la cible') end
    if camera then camera.CameraSubject=head or enemyHum end
    -- L originale YARHM utilise FallenPartsDestroyHeight = NaN pendant le fling.
    -- On restaure toujours cette propriete dans le nettoyage, meme en erreur.
    pcall(function() workspace.FallenPartsDestroyHeight=0/0 end)
    mover=Instance.new('BodyVelocity')
    mover.Name='NEO_YARHM_EpixVel'
    mover.Velocity=Vector3.new(9e8,9e8,9e8)
    mover.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    mover.Parent=mine
    oldSeated=myHum:GetStateEnabled(Enum.HumanoidStateType.Seated)
    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
    local function move(delta,spin)
      if not active or flingStop or not mine.Parent or not base.Parent then return false end
      -- Une seule relocalisation par echantillon. L'ancien double CFrame+PivotTo
      -- et les offsets fondes sur la vitesse pouvaient viser plusieurs studs a cote.
      local live=enemyChar:FindFirstChild('HumanoidRootPart') or base
      if not live or not live:IsA('BasePart') or not live.Parent then return false end
      local v=live.AssemblyLinearVelocity
      local flat=Vector3.new(v.X,0,v.Z)
      -- Petite anticipation quand la cible marche/court, toujours <= 1.2 studs.
      local lead=flat.Magnitude>.1 and flat.Unit*math.min(flat.Magnitude*.045,1.2) or Vector3.zero
      local cf=CFrame.new(live.Position+lead+delta)*CFrame.Angles(math.rad(spin),0,0)
      mineChar:PivotTo(cf)
      mine.AssemblyLinearVelocity=Vector3.new(9e7,9e8,9e7)
      mine.AssemblyAngularVelocity=Vector3.new(9e8,9e8,9e8)
      return true
    end
    local start=os.clock()
    local angle=0
    -- Tous les points passent AU CENTRE ou a moins d'un stud de la cible.
    -- Le test physique depend toujours de la replication cote serveur.
    local closeOffsets={
      Vector3.new(0,0,0),Vector3.new(0,.85,0),Vector3.new(0,-.85,0),
      Vector3.new(.65,0,0),Vector3.new(-.65,0,0),
      Vector3.new(0,0,.65),Vector3.new(0,0,-.65),Vector3.new(0,0,0)
    }
    -- JOUEURS : duree originale 2s. SHERIF + SHOOT : duree optionnelle.
    local flingDuration=(type(durationOverride)=='number' and math.clamp(durationOverride,2,6)) or 2
    while active and not flingStop and os.clock()-start<flingDuration do
      if p.Parent~=Players or p.Character~=enemyChar or Local.Character~=mineChar
         or myHum.Health<=0 or enemyHum.Health<=0 or not base.Parent then break end
      if base.AssemblyLinearVelocity.Magnitude>500 or enemyHum.Sit then break end
      for _,delta in ipairs(closeOffsets) do
        angle=(angle+85)%360
        if not move(delta,angle) then break end
        task.wait()
      end
    end
  end)
  -- Nettoyage garanti, meme si la cible quitte la partie au milieu du fling.
  if mover then pcall(function() mover:Destroy() end) end
  if oldSeated~=nil and myHum and myHum.Parent then
    pcall(function() myHum:SetStateEnabled(Enum.HumanoidStateType.Seated,oldSeated) end)
  end
  pcall(function() workspace.FallenPartsDestroyHeight=oldFall end)
  if camera and camera.Parent then
    pcall(function() camera.CameraSubject=(oldSubject and oldSubject.Parent) and oldSubject or hum(Local) end)
  end
  if mine and mine.Parent and Local.Character==mineChar and myHum.Health>0 then
    pcall(function()
      mine.AssemblyAngularVelocity=Vector3.zero
      mine.AssemblyLinearVelocity=Vector3.zero
      mine:PivotTo(original*CFrame.new(0,.5,0))
      myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)
  end
  local cancelled=flingStop
  flingBusy,flingStop,flingTarget=false,false,nil
  if not ok then status('FLING YARHM erreur : '..tostring(err):sub(1,75))
  elseif cancelled then status('FLING YARHM arrete.')
  else status('FLING YARHM tente. Resultat serveur non garanti.') end
end

-- 12/11 : fiabilite Gun en inventaire : role Hero/Sheriff pas toujours synchronise, equipement temporise, relancement des boutons.
-- 12/11 : modes SHERIF corriges.
-- Le bouton JOUEURS realise son TP avec root.CFrame = targetRoot.CFrame*CFrame.new(0,0,3).
-- Les modes SHERIF reutilisent ce mouvement direct qui fonctionne dans JOUEURS.
-- Aucun changement a fling(p), au farm, aux danses, a l'admin ou aux autres modes.
-- Un tir envoye n'est pas un impact confirme par le serveur.
function neo.sheriffSameTarget(p)
  if not p or p==Local or p.Parent~=Players or not alive(p) then return false end
  -- Un seul detecteur de Murderer pour le menu et l action. L ancienne
  -- double validation pouvait refuser la cible affichee dans le HUB.
  return findMurderer()==p
end

-- JOUEURS conserve le TP direct historique a 3 studs.
-- SHERIF/HERO reutilise le meme moteur CFrame avec un recul optionnel.
-- Ne pas bloquer une teleportation parce que le Gun equipe ou le Shoot tarde.
function neo.tpToPlayerDirect(p,distance)
  local me,enemy=root(Local),root(p)
  if not me or not enemy then return false,'RootPart local ou cible absent' end
  if not enemy.Parent or not me.Parent then return false,'Personnage non disponible' end
  local ok,err=pcall(function()
    me.CFrame=enemy.CFrame*CFrame.new(0,0,distance or 3)
  end)
  if not ok then return false,tostring(err) end
  return true
end
-- Ancien nom conserve pour compatibilite interne.
neo.sheriffTPUsingPlayersMethod=neo.tpToPlayerDirect

-- Preparation commune : ne pas interrompre les autres modes tant que le
-- Sheriff/Hero, le pistolet et le Murderer ne sont pas confirmes.
-- Le role Hero obtient le pistolet du Sheriff pendant la manche.
-- Les boutons Shérif sont utilisables par les deux porteurs du Gun.
-- Le port du Gun est une preuve plus fiable que myRole(): dans MM2 un Hero
-- peut recevoir le Gun avant que l'etat des roles soit actualise par le serveur.
-- Ne jamais autoriser un porteur du Knife a utiliser le mode Sheriff.
function neo.sheriffOrHeroWithGun()
  return tool('Gun')~=nil and tool('Knife')==nil
end

-- Equiper un Gun range dans Backpack est parfois asynchrone sur mobile.
-- Attendre brievement que son Parent soit le Character, au lieu d'abandonner
-- des le premier appel a EquipTool. Cette fonction ne change pas le Fling.
function neo.sheriffEnsureGun(timeout)
  local gun=tool('Gun')
  if not gun then return nil,'Gun absent du sac et de la main.' end
  local c,h=char(Local),hum(Local)
  if not c or not h or h.Health<=0 then return nil,'Personnage indisponible.' end
  local deadline=os.clock()+math.max(0,timeout or .6)
  while active and gun.Parent~=c and os.clock()<deadline do
    pcall(function() h:EquipTool(gun) end)
    if gun.Parent==c then break end
    task.wait(.055)
    if char(Local)~=c then return nil,'Personnage remplace pendant l equipement.' end
  end
  if gun.Parent~=c then return nil,'Gun present, mais Roblox ne l a pas encore equipe.' end
  local remote,why=shotCtl.findRemote(gun)
  if not remote then
    local ok,child=pcall(function() return gun:WaitForChild('Shoot',.35) end)
    if ok and child and child:IsA('RemoteEvent') then remote=child end
  end
  if not remote then return nil,tostring(why or 'Commande Shoot absente.') end
  return gun
end

function neo.sheriffActionReady(p,label)
  -- Le teleport du menu JOUEURS fonctionne sans verifier le Remote Gun.Shoot.
  -- Le bouton SHERIF doit aussi pouvoir se deplacer AVANT l equipement / le tir.
  if not active or not alive(Local) then return false,label..' : personnage indisponible.' end
  if flingBusy then return false,label..' : mouvement deja actif (STOP).' end
  if not neo.sheriffOrHeroWithGun() then
    return false,label..' : Gun absent du sac / de la main (ou Knife present).'
  end
  if not p or not neo.sheriffSameTarget(p) then
    return false,label..' : cible Murderer non confirmee ou eliminee.'
  end
  if neo.adminIsBlocked('teleport') then
    return false,label..' : TP verrouille par le panneau ADMIN.'
  end
  if not root(Local) or not root(p) then
    return false,label..' : RootPart manquant.'
  end
  -- PAS de sheriffEnsureGun ici : un Remote absent ne doit pas annuler le TP.
  return true
end

-- Le tir utilise le moteur SHOOT deja present. Si le Gun a ete range par
-- Roblox pendant le deplacement, on le reequipe seulement si necessaire.
function neo.sheriffComboTap(p)
  if shotBusy then return false,'Un autre tir est en cours.' end
  if os.clock()<nextShot then return false,'Recharge du Gun en cours.' end
  if not neo.sheriffOrHeroWithGun() then return false,'Gun absent / Knife equipe.' end
  local gun=tool('Gun')
  if not gun then return false,'Gun non present.' end
  if gun.Parent~=char(Local) or not shotCtl.findRemote(gun) then
    -- Equipement asynchrone mobile et replication du Remote Shoot.
    local ready,why=neo.sheriffEnsureGun(.8)
    if not ready then return false,why end
  end
  return neo.shootOneTap('SHERIFF_COMBO',p)
end

-- SHERIF / HERO : vol ORBIT lent, a distance de securite, avec tirs pendant
-- le mouvement. L'ancien bouton utilisait fling(p,5.5) (vitesse 9e8,
-- contact a moins d'1 stud, retour a la position initiale), ce qui
-- rendait l'arme inefficace et mettait le Sheriff a portee du couteau.
-- Le Fling YARHM classique de JOUEURS reste absolument inchange.
function neo.sheriffOrbitShoot(p)
  local ready,reason=neo.sheriffActionReady(p,'ORBIT + SHOOT')
  if not ready then status(reason);return end
  if neo.adminIsBlocked('shoot') then status('ORBIT : Shoot verrouille par ADMIN.');return end
  if neo.attachCtl and neo.attachCtl.target then neo.detachPlayer('Orbit Sheriff Shoot') end
  -- Ne pas lancer un deplacement silencieux sans avoir pu equiper le Gun.
  local gun,gunWhy=neo.sheriffEnsureGun(1.1)
  if not gun then status('ORBIT : '..tostring(gunWhy));return end
  local c,targetChar=char(Local),char(p)
  local me,target=root(Local),root(p)
  local h=hum(Local)
  if not c or not targetChar or not me or not target or not h then
    status('ORBIT : avatar ou cible indisponible.');return
  end
  local token=neo.sheriffMenuRequest
  local initialAutoRotate=h.AutoRotate
  local sent,attempted=0,0
  local lastFailure='Attente du premier tir.'
  local stopped='Duree du mode atteinte.'
  -- 18 studs par defaut ; 21 si le Murderer s'approche trop.
  -- ~0.38 rad/s = plus de 16 secondes pour faire un tour entier.
  local orbitRadius,retreatRadius=18,21
  local rotationSpeed=.38
  local duration=17
  local start=os.clock()
  local lastFrame=start
  local nextReport=start
  local pauseUntil=0
  local offset=me.Position-target.Position
  local angle=(offset.X*offset.X+offset.Z*offset.Z>0.01)
    and math.atan2(offset.Z,offset.X) or 0
  -- Suspend seulement le scanner AUTO pour qu'il ne vole pas le cooldown
  -- du Gun au moment ou le mode orbital veut tirer.
  neo.sheriffComboActive=true
  flingBusy,flingStop,flingTarget=true,false,p
  status('ORBIT : approche lente, recul et tir sur '..p.Name)
  local ok,err=pcall(function()
    pcall(function() h.AutoRotate=false end)
    while active and not flingStop and neo.sheriffMenuRequest==token
      and os.clock()-start<duration do
      if not alive(Local) or not alive(p) or Local.Character~=c or p.Character~=targetChar
        or not me.Parent or not target.Parent then
        stopped='Personnage ou cible indisponible.';break
      end
      if not neo.sheriffOrHeroWithGun() or not neo.sheriffSameTarget(p) then
        stopped='Gun perdu ou Murderer non confirme.';break
      end
      if neo.adminIsBlocked('teleport') or neo.adminIsBlocked('shoot') then
        stopped='Fonction verrouillee par ADMIN.';break
      end
      local now=os.clock()
      local dt=math.clamp(now-lastFrame,.01,.12)
      lastFrame=now
      local tp=target.Position
      local current=me.Position
      local flat=Vector3.new(current.X-tp.X,0,current.Z-tp.Z)
      local radius=flat.Magnitude<13 and retreatRadius or orbitRadius
      -- Maintient une distance utile, sans spin, vitesse enorme ni contact.
      if now>=pauseUntil then
        angle=angle+rotationSpeed*dt
        local goal=tp+Vector3.new(math.cos(angle)*radius,1.2,
          math.sin(angle)*radius)
        -- Les positions sont interpolees : les petits pas restent doux.
        -- Quand on est tres loin, l'approche initiale est directe mais
        -- n'utilise jamais le fling physique de JOUEURS.
        local delta=goal-current
        local step=delta.Magnitude>0.05 and
          (current+delta*math.min(1,math.max(.12,dt*8))) or goal
        local look=Vector3.new(tp.X,step.Y,tp.Z)
        if (look-step).Magnitude>.05 then
          c:PivotTo(CFrame.lookAt(step,look))
        else
          c:PivotTo(CFrame.new(step))
        end
        -- Evite qu'une impulsion residuelle fasse tomber / tourner l'avatar.
        me.AssemblyAngularVelocity=Vector3.zero
        me.AssemblyLinearVelocity=Vector3.zero
      end
      -- La meme methode Shoot que le bouton manuel/TP, mais lancee
      -- APRES un positionnement stable. Respect du cooldown du Gun.
      if now>=nextShot and not shotBusy then
        if neo.yarhmAutoVisible(p) then
          attempted=attempted+1
          local fired,why=neo.sheriffComboTap(p)
          if fired then
            sent=sent+1
            -- Pause de position courte au moment de tirer : pas de spin.
            pauseUntil=os.clock()+.27
            lastFailure='Tir envoye (impact non confirme).'
          else
            lastFailure=tostring(why or 'Tir non envoye.')
          end
        else
          lastFailure='Angle masque, rotation vers un autre angle de tir.'
        end
      end
      if now-nextReport>=1.2 then
        nextReport=now
        status('ORBIT lent : '..sent..' tirs envoyes / '..attempted..' essais. '..lastFailure)
      end
      task.wait(.055)
    end
    if flingStop or neo.sheriffMenuRequest~=token then stopped='STOP demande.' end
  end)
  -- Nettoyage garanti, sans TP de retour qui faisait chuter le joueur.
  neo.sheriffComboActive=false
  flingBusy,flingStop,flingTarget=false,false,nil
  if h and h.Parent then pcall(function() h.AutoRotate=initialAutoRotate end) end
  if me and me.Parent and Local.Character==c then
    pcall(function()
      me.AssemblyAngularVelocity=Vector3.zero
      me.AssemblyLinearVelocity=Vector3.zero
    end)
  end
  if not ok then
    status('ORBIT erreur : '..tostring(err):sub(1,120))
  else
    status('ORBIT fini : '..sent..' tirs envoyes / '..attempted..' essais. '..
      stopped..' '..(sent==0 and lastFailure or 'Impacts non garantis.'))
  end
end

-- TP MURDER : UN seul TP par activation, puis on reste sur place pour tirer.
-- La version precedente repetait le TP immediatement puis toutes les 0.30 s,
-- ce qui empechait le tir de se stabiliser et rendait la visée incoherente.
-- Le TP direct du menu JOUEURS et le Fling classique ne sont pas modifies.
neo.sheriffTPSafeDistance=7
function neo.sheriffTPMurderShoot(p)
  local ready,reason=neo.sheriffActionReady(p,'TP MURDER')
  if not ready then status(reason);return end
  local mineChar,targetChar=char(Local),char(p)
  local me,enemy=root(Local),root(p)
  if not mineChar or not targetChar or not me or not enemy then
    status('TP MURDER : RootPart absent.');return
  end
  if neo.attachCtl and neo.attachCtl.target then neo.detachPlayer('TP Murder Shoot') end
  flingBusy,flingStop,flingTarget=true,false,p
  local sent,failed=0,'Aucun tir envoye.'
  local reasonEnd='Duree atteinte.'
  local lastTry,lastReport=-math.huge,0
  local ok,err=pcall(function()
    -- Le Gun peut etre dans le sac; l'equiper avant le mouvement si possible.
    local g,h=tool('Gun'),hum(Local)
    if g and h and g.Parent~=mineChar then
      pcall(function() h:EquipTool(g) end)
    end
    -- UNE SEULE teleportation, avec la meme methode que le TP JOUEURS.
    local teleported,why=neo.tpToPlayerDirect(p,neo.sheriffTPSafeDistance)
    if not teleported then reasonEnd='TP refuse : '..tostring(why);return end
    status('TP MURDER : position atteinte, stabilisation puis tirs sans autre TP...')
    -- Laisser au personnage / Gun le temps de se stabiliser sur mobile.
    task.wait(.14)
    local began=os.clock()
    while active and not flingStop and os.clock()-began<6 do
      if Local.Character~=mineChar or p.Character~=targetChar or not alive(Local)
        or not neo.sheriffSameTarget(p) then
        reasonEnd='Personnage / cible indisponible.';break
      end
      if not neo.sheriffOrHeroWithGun() then
        reasonEnd='Pistolet perdu.';break
      end
      if neo.adminIsBlocked('shoot') then
        reasonEnd='Shoot verrouille.';break
      end
      -- Aucun Re-TP : tirer depuis la meme position que le TP manuel.
      -- Le cooldown du Gun est gere dans sheriffComboTap / shootOneTap.
      local now=os.clock()
      if now-lastTry>=.12 and not shotBusy and now>=nextShot then
        lastTry=now
        local didShoot,whyShot=neo.sheriffComboTap(p)
        if didShoot then sent=sent+1
        else failed=tostring(whyShot or 'Tir refuse.') end
      end
      if now-lastReport>=1.25 then
        lastReport=now
        status('TP MURDER stable : 1 TP | '..sent..' tirs envoyes | '..
          (sent==0 and failed or 'pas de nouveau TP pendant le tir'))
      end
      task.wait(.075)
    end
    if flingStop then reasonEnd='STOP demande.' end
  end)
  flingBusy,flingStop,flingTarget=false,false,nil
  if not ok then
    status('TP MURDER erreur : '..tostring(err):sub(1,110))
  else
    status('TP MURDER termine : 1 TP, '..sent..' tirs envoyes. '..reasonEnd..' '..
      (sent==0 and failed or 'Impacts non garantis.'))
  end
end

-- Lance les deux boutons depuis le menu, sans laisser un ancien mode
-- orbital (22 s) faire croire qu un nouveau clic est ignore.
neo.sheriffMenuRequest=0
neo.sheriffMenuMode=nil
function neo.sheriffMenuLaunch(mode)
  neo.sheriffMenuRequest=neo.sheriffMenuRequest+1
  local request=neo.sheriffMenuRequest
  task.spawn(function()
    local ok,err=pcall(function()
      if flingBusy then
        if not neo.sheriffMenuMode then
          status('SHERIF : un Fling classique est en cours. Utilise STOP avant le TP.')
          return
        end
        flingStop=true
        status('SHERIF : remplacement du mode precedent...')
        local deadline=os.clock()+1.5
        while active and flingBusy and os.clock()<deadline do task.wait(.05) end
        if flingBusy then status('SHERIF : ancien mouvement encore actif ; utilise STOP.');return end
      end
      if request~=neo.sheriffMenuRequest or not active then return end
      if not neo.sheriffOrHeroWithGun() then
        status('SHERIF : Gun absent du sac / main, ou Knife present.')
        return
      end
      local murderer=findMurderer()
      if not murderer or not alive(murderer) then
        status('SHERIF : Gun detecte, mais Murderer non identifie pour le moment.')
        return
      end
      -- Verifier la prise du Gun AVANT de desactiver d autres deplacements.
      local ready,why=neo.sheriffActionReady(murderer,mode)
      if not ready then status(why);return end
      if request~=neo.sheriffMenuRequest then return end
      bodyBlock.stop()
      neo.detachPlayer()
      neo.stopCombatPosition();state.combatPosition=false
      state.followPlayer=false;followTarget=nil
      state.autoFarm=false;state.autoEscape=false
      autoNav.halt();autoNav.resetEscape()
      neo.stopManualFly()
      if state.freecam then neo.stopFreecam() end
      if watching then neo.returnCameraToBody() end
      status('SHERIF : Gun detecte ; lancement '..mode..' vers '..murderer.Name)
      neo.sheriffMenuMode=mode
      if mode=='ORBIT' then neo.sheriffOrbitShoot(murderer)
      else neo.sheriffTPMurderShoot(murderer) end
      if neo.sheriffMenuMode==mode then neo.sheriffMenuMode=nil end
    end)
    if request==neo.sheriffMenuRequest and neo.sheriffMenuMode==mode and not flingBusy then
      neo.sheriffMenuMode=nil
    end
    if not ok then
      status('SHERIF erreur de lancement '..tostring(mode)..' : '..tostring(err):sub(1,150))
    end
  end)
end

-- Weld LOCAL: tente de garder un autre avatar colle devant le notre.
-- Sans autorite reseau sur la cible, Roblox peut ignorer ou annuler la soudure.
neo.attachCtl={target=nil,joint=nil,localRoot=nil,targetRoot=nil,lastCheck=0}
function neo.detachPlayer(reason)
  local a=neo.attachCtl
  if not a then return end
  local had=a.target~=nil
  if a.joint then pcall(function() a.joint:Destroy() end) end
  a.target=nil;a.joint=nil;a.localRoot=nil;a.targetRoot=nil
  a.lastCheck=0
  if had and reason then status('ATTACH termine : '..reason) end
end
function neo.attachPlayer(p)
  if neo.adminIsBlocked('attachPlayer') then status('NEO ADMIN : ATTACH verrouille.');return false end
  if flingBusy then status('Termine le fling avant ATTACH.');return false end
  if not p or p==Local or p.Parent~=Players or not alive(p) or not alive(Local) then
    status('ATTACH : cible absente ou eliminee.'); return false
  end
  neo.detachPlayer()
  local ownRoot,otherRoot=root(Local),root(p)
  if not ownRoot or not otherRoot then status('ATTACH : avatar introuvable.'); return false end
  local ok,joint=pcall(function()
    local w=Instance.new('Weld')
    w.Name='NEO_Attach_Local'
    w.Part0=ownRoot
    w.Part1=otherRoot
    w.C0=CFrame.new(0,0,-2.8)
    w.C1=CFrame.new()
    w.Parent=ownRoot
    return w
  end)
  if not ok or not joint then
    status('ATTACH impossible : soudure locale refusee.')
    return false
  end
  neo.attachCtl.target=p
  neo.attachCtl.joint=joint
  neo.attachCtl.localRoot=ownRoot
  neo.attachCtl.targetRoot=otherRoot
  neo.attachCtl.lastCheck=os.clock()
  status('ATTACH LOCAL : '..p.Name..' | DÉTACHER pour arrêter. Serveur non garanti.')
  return true
end
function neo.clearTargetHighlight()
  if targetHighlight then pcall(function() targetHighlight:Destroy() end); targetHighlight=nil end
end
function neo.markTarget(p)
  neo.clearTargetHighlight()
  local c=char(p)
  if not c then status('Avatar introuvable.'); return end
  targetHighlight = Instance.new('Highlight')
  targetHighlight.Name='NEO_Target_Mark'
  targetHighlight.FillColor=hue.primary
  targetHighlight.OutlineColor=hue.text
  targetHighlight.FillTransparency=.73
  targetHighlight.OutlineTransparency=0
  targetHighlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
  targetHighlight.Adornee=c
  targetHighlight.Parent=gui
  status('Cible marquee : '..p.Name..' (localement).')
end
function neo.clearTrail()
  for _,part in ipairs(trailParts) do
    if part and part.Parent then part:Destroy() end
  end
  table.clear(trailParts)
end
function neo.addTrailPoint(pos)
  local p=Instance.new('Part')
  p.Name='NEO_MurderPath_Local'
  p.Shape=Enum.PartType.Ball
  p.Material=Enum.Material.Neon
  p.Color=hue.red
  p.Transparency=.25
  p.Size=Vector3.new(.65,.65,.65)
  p.CanCollide=false
  p.CanTouch=false
  p.Anchored=true
  p.Position=pos-Vector3.new(0,2.2,0)
  p.Parent=workspace
  table.insert(trailParts,p)
  if #trailParts>(state.performance and 12 or 28) then
    local first=table.remove(trailParts,1)
    if first then first:Destroy() end
  end
end

-- ===== V3: HUD minimal et notifications locales =====
local function hudLabel(name, width, height, position, bg)
  local label=make('TextLabel',{
    Name=name,AnchorPoint=Vector2.new(0,0),Position=position,
    Size=UDim2.fromOffset(width,height),BackgroundColor3=bg or hue.panel,
    TextColor3=hue.text,TextSize=12,TextWrapped=true,
    Font=Enum.Font.GothamBold,Visible=false,BorderSizePixel=0,
    ZIndex=12,Text=''
  },gui)
  corner(label,10)
  return label
end
local threatHUD=hudLabel('Threat',174,36,UDim2.new(0,8,0,50),hue.panel)
local routeHUD=hudLabel('Escape',200,36,UDim2.new(.5,-100,0,50),hue.panel)
local safeHUD=hudLabel('Safe',205,37,UDim2.new(0,8,1,-107),hue.panel)
local coinHUD=hudLabel('CoinRadar',195,90,UDim2.new(1,-202,1,-105),hue.panel)
local toast=hudLabel('Notification',245,46,UDim2.new(.5,-122,0,93),hue.elevated)
local guardHUD=hudLabel('RetourUrgence',270,44,UDim2.new(.5,-135,0,146),hue.red)
guardHUD.ZIndex=24
local function notify(message, critical)
  if not state.notifications or not active then return end
  notificationToken=notificationToken+1
  local token=notificationToken
  toast.Text=(critical and '⚠  ' or 'NEO  •  ')..message
  toast.BackgroundColor3=critical and hue.red or hue.elevated
  toast.Visible=true
  task.delay(3.6,function()
    if active and token==notificationToken then toast.Visible=false end
  end)
end

-- ===== V3.4 : ligne de fuite rouge SUR LE SOL, uniquement sur ton client =====
-- Bande lumineuse creee localement. Elle ne deplace personne et n'affecte pas la carte.
-- Les segments sont reutilises pour eviter de creer des centaines d'objets.
local escapeGroundFolder=Instance.new('Folder')
escapeGroundFolder.Name='NEO_EscapeGroundLine_Local'
escapeGroundFolder.Parent=workspace
local escapeGroundParts={}
local escapeGroundLast=0
local MAX_GROUND_SEGMENTS=23
function neo.hideEscapeGroundLine()
  for _,part in ipairs(escapeGroundParts) do
    if part.Parent then part.Transparency=1 end
  end
end
function neo.escapeGroundPart(index)
  local part=escapeGroundParts[index]
  if part and part.Parent then return part end
  part=Instance.new('Part')
  part.Name='RedPath_'..index
  part.Anchored=true
  part.CanCollide=false
  part.CanTouch=false
  part.CanQuery=false
  part.CastShadow=false
  part.Material=Enum.Material.Neon
  part.Color=Color3.fromRGB(255,36,52)
  part.Size=Vector3.new(.28,.09,1)
  part.Transparency=1
  part.Parent=escapeGroundFolder
  escapeGroundParts[index]=part
  return part
end
function neo.drawEscapeGroundLine(goal)
  local me=root(Local)
  if not active or not state.escapeRoute or not alive(Local) or not me or not goal then
    neo.hideEscapeGroundLine()
    return
  end
  local diff=Vector3.new(goal.X-me.Position.X,0,goal.Z-me.Position.Z)
  local maxDist=math.min(diff.Magnitude,36)
  if maxDist<2 then neo.hideEscapeGroundLine();return end
  local count=math.min(MAX_GROUND_SEGMENTS,math.ceil(maxDist/1.8))
  local direction=diff.Unit
  local filter={escapeGroundFolder}
  for _,player in ipairs(Players:GetPlayers()) do
    local model=player.Character
    if model then table.insert(filter,model) end
  end
  local params=RaycastParams.new()
  params.FilterType=Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances=filter
  params.IgnoreWater=true
  local prev=nil
  local used=0
  for step=0,count do
    local groundXY=me.Position+direction*(maxDist*step/count)
    local down=workspace:Raycast(
      Vector3.new(groundXY.X,me.Position.Y+6,groundXY.Z),
      Vector3.new(0,-19,0),params
    )
    if down and down.Normal.Y>.53 then
      local point=down.Position+Vector3.new(0,.16,0)
      -- Ne pas tracer par-dessus un trou ou un changement de niveau abrupt.
      if prev and math.abs(point.Y-prev.Y)<=2.6 then
        local span=point-prev
        if span.Magnitude>.1 then
          used=used+1
          local part=neo.escapeGroundPart(used)
          part.Size=Vector3.new(.28,.09,span.Magnitude+.12)
          part.CFrame=CFrame.lookAt((point+prev)*.5,point)
          part.Transparency=.06
        end
      end
      prev=point
    else
      prev=nil
    end
  end
  for i=used+1,#escapeGroundParts do
    local part=escapeGroundParts[i]
    if part and part.Parent then part.Transparency=1 end
  end
end

-- Trace au sol la route que la navigation suit vraiment, pas une ligne traversant les murs.
function neo.drawPreparedEscapeLine(waypoints)
  local r=root(Local)
  if not r or not waypoints or #waypoints<2 then return false end
  local nearest,distance=1,math.huge
  for i,wp in ipairs(waypoints) do
    local d=(wp.Position-r.Position).Magnitude
    if d<distance then nearest,distance=i,d end
  end
  local filter={escapeGroundFolder}
  for _,player in ipairs(Players:GetPlayers()) do
    if player.Character then table.insert(filter,player.Character) end
  end
  local params=RaycastParams.new()
  params.FilterType=Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances=filter
  params.IgnoreWater=true
  local used,drawn=0,0
  local origin=r.Position
  local prev=nil
  local function pointOnGround(pos)
    local hit=workspace:Raycast(pos+Vector3.new(0,8,0),Vector3.new(0,-22,0),params)
    return hit and hit.Normal.Y>.55 and (hit.Position+Vector3.new(0,.18,0)) or nil
  end
  -- 38 studs maximum pour conserver des FPS corrects sur telephone.
  for i=nearest,math.min(#waypoints,nearest+13) do
    local endpoint=waypoints[i].Position
    local from=origin
    local vec=endpoint-from
    local dist=vec.Magnitude
    if dist>.05 then
      local steps=math.max(1,math.ceil(math.min(dist,38-drawn)/2))
      for j=1,steps do
        if drawn>=38 or used>=MAX_GROUND_SEGMENTS then break end
        local pos=from+vec*(j/steps)
        local floor=pointOnGround(pos)
        if floor and prev and math.abs(floor.Y-prev.Y)<=3 then
          local delta=floor-prev
          if delta.Magnitude>.1 then
            used=used+1
            local part=neo.escapeGroundPart(used)
            part.Size=Vector3.new(.28,.09,delta.Magnitude+.12)
            part.CFrame=CFrame.lookAt((floor+prev)*.5,floor)
            part.Transparency=.06
          end
        end
        prev=floor
        drawn=drawn+dist/steps
      end
    end
    origin=endpoint
    if drawn>=38 or used>=MAX_GROUND_SEGMENTS then break end
  end
  for i=used+1,#escapeGroundParts do
    local p=escapeGroundParts[i]
    if p and p.Parent then p.Transparency=1 end
  end
  return used>0
end

-- ===== V3: scan local de chemins degages; PAS un chemin garanti =====
function neo.scanSafeZone()
  local me, danger=root(Local), findMurderer()
  if not me then return nil, 'Ton avatar est absent.' end
  local enemy=danger and root(danger)
  local params=RaycastParams.new()
  params.FilterType=Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances={char(Local)}
  params.IgnoreWater=true
  local best,score=nil,-math.huge
  for i=0,15 do
    local angle=i*math.pi/8
    local dir=Vector3.new(math.cos(angle),0,math.sin(angle))
    local origin=me.Position+Vector3.new(0,2,0)
    local hit=workspace:Raycast(origin,dir*44,params)
    local distance=hit and math.max(0,(hit.Position-origin).Magnitude-3) or 44
    if distance>=8 then
      local candidate=me.Position+dir*math.min(34,distance)
      local enemyDistance=enemy and (candidate-enemy.Position).Magnitude or 0
      local candidateScore=distance*.6+enemyDistance*.8
      if candidateScore>score then score,best=candidateScore,candidate end
    end
  end
  return best,best and 'Direction indicative, pas une garantie de sécurité.' or 'Aucune zone dégagée détectée.'
end
function neo.directionArrow(worldDirection)
  local cam=workspace.CurrentCamera
  if not cam then return '↑' end
  local forward=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z)
  local right=Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z)
  local flat=Vector3.new(worldDirection.X,0,worldDirection.Z)
  if flat.Magnitude<.1 or forward.Magnitude<.1 or right.Magnitude<.1 then return '↑' end
  local angle=math.atan2(flat.Unit:Dot(right.Unit),flat.Unit:Dot(forward.Unit))
  local index=math.floor((angle+math.pi/8)/(math.pi/4))%8+1
  return ({'↑','↗','→','↘','↓','↙','←','↖'})[index]
end

-- ===== V3.5: radar bonbons asynchrone + diagnostic des noms =====
-- MM2 peut representer ses objets par des MeshParts ou Models aux noms changeants.
-- Ce scanner ne promet pas une detection universelle; il indique ce qu'il a vu.
function neo.pickupKind(part)
  local current=part
  for depth=1,3 do
    if not current or current==workspace then break end
    local name=current.Name:lower():gsub('[^%a]','')
    local kind=nil
    if name:match('^coincontainer') then
      kind='Bonbon/Pièce'
    elseif name:match('^candy') or name:match('^candies') or name:match('^bonbon')
      or name:match('^halloweentoken') or name:match('^sweettoken') then
      kind='Bonbon'
    elseif name:match('^coin') or name:match('^collectiblecoin') then
      kind='Pièce'
    end
    if kind then
      -- Sous MM2, CoinContainer peut être un Folder : ses enfants BasePart
      -- sont de vrais pickups même si le dossier n'est pas un Model.
      if name:match('^coincontainer') then
        if depth==2 and part.Parent==current then
          return kind,part
        end
        if part:FindFirstChild('TouchInterest')
          or part:FindFirstChildOfClass('TouchTransmitter')
          or part:FindFirstChildOfClass('ProximityPrompt') then
          return kind,part
        end
      elseif depth==1 or current:IsA('Model') or (depth==2 and not current:IsA('Folder')) then
        return kind,(current:IsA('Model') and current or part)
      end
    end
    current=current.Parent
  end
  return nil,nil
end
function neo.pickupScore(part)
  if not part or not part:IsA('BasePart') then return -1 end
  local name=part.Name:lower()
  local score=part.CanTouch and 12 or 0
  if part:FindFirstChild('TouchInterest') or part:FindFirstChildOfClass('TouchTransmitter') then score=score+110 end
  if part:FindFirstChildOfClass('ProximityPrompt') then score=score+65 end
  if name:find('coin',1,true) or name:find('candy',1,true) or name:find('bonbon',1,true) then score=score+35 end
  if part:IsA('MeshPart') then score=score+8 end
  if part.Transparency<.9 then score=score+3 end
  return score
end
-- V5.9 : ne jamais prendre une simple decoration pour un bonbon.
-- MM2 utilise des TouchInterest pour les vrais pickups dans CoinContainer.
-- Certains evenements utilisent aussi un attribut CoinID; il n'est pas requis.
function neo.isLivePickup(part)
  if not part or not part:IsA('BasePart') or not part:IsDescendantOf(workspace) then return false end
  local touch=part:FindFirstChild('TouchInterest') or part:FindFirstChildOfClass('TouchTransmitter')
  if not touch then return false end
  local inContainer=false
  local ancestor=part.Parent
  for i=1,3 do
    if not ancestor or ancestor==workspace then break end
    if ancestor.Name:lower()=='coincontainer' then inContainer=true;break end
    ancestor=ancestor.Parent
  end
  if inContainer then return true end
  local id=part:GetAttribute('CoinID')
  if id=='Candy' or id=='Coin' then return true end
  local name=part.Name:lower()
  return name:find('candy',1,true)~=nil or name:find('coin',1,true)~=nil
end
function neo.isVerifiedPickup(part)
  if not neo.isLivePickup(part) then return false end
  local ancestor=part.Parent
  for i=1,3 do
    if not ancestor or ancestor==workspace then break end
    if ancestor.Name:lower()=='coincontainer' then return true end
    ancestor=ancestor.Parent
  end
  return part:GetAttribute('CoinID')=='Candy'
end
-- V6.0 : on cherche d'abord les conteneurs de vraie monnaie de la map.
-- Memoriser les conteneurs evite un scan integral de toute la carte a chaque fois.
local knownCoinContainers={}
local lastContainerRefresh=0
function neo.scanCoins(onDone)
  if coinScanBusy then return false end
  coinScanBusy=true
  task.spawn(function()
    local ok,err=pcall(function()
      local here=root(Local)
      if not here then
        coinCache={};coinDiag={checked=0,candidates=0,nearby=0,examples={},lastAt=os.clock()}
        return
      end
      local seen,found,nearbySample={},{},{}
      local checked=0
      local containers={}
      local fallback={}
      for _,c in ipairs(knownCoinContainers) do
        if c and c:IsDescendantOf(workspace) then containers[#containers+1]=c end
      end
      local all=nil
      if #containers==0 or os.clock()-lastContainerRefresh>14 then
        containers={}
        all=workspace:GetDescendants()
        for i,obj in ipairs(all) do
          if not active then return end
          local n=obj.Name:lower()
          if n=='coincontainer' and (obj:IsA('Folder') or obj:IsA('Model')) then
            containers[#containers+1]=obj
          elseif obj:IsA('BasePart') and obj:GetAttribute('CoinID')=='Candy' then
            fallback[#fallback+1]=obj
          end
          if i%1800==0 then task.wait() end
        end
        knownCoinContainers=containers
        lastContainerRefresh=os.clock()
      end
      local function remember(part)
        if not part or not part:IsA('BasePart') or seen[part]
          or not neo.isLivePickup(part) then return end
        checked=checked+1
        local d=(here.Position-part.Position).Magnitude
        if d>420 or part:FindFirstAncestorOfClass('Tool') then return end
        seen[part]=true
        local verified=neo.isVerifiedPickup(part)
        local kind=part:GetAttribute('CoinID')=='Candy' and 'Bonbon' or 'Bonbon/Pièce'
        found[#found+1]={part=part,dist=d,kind=kind,
          score=neo.pickupScore(part)+(verified and 900 or 0)}
      end
      for _,c in ipairs(containers) do
        for _,obj in ipairs(c:GetDescendants()) do remember(obj) end
      end
      for _,obj in ipairs(fallback) do remember(obj) end
      -- Secours : le jeu peut changer la hierarchie des collectibles.
      -- Aucune decoration non-interactive ne sera acceptée.
      if #found==0 then
        if not all then all=workspace:GetDescendants() end
        for i,obj in ipairs(all) do
          if obj:IsA('BasePart') then
            local n=obj.Name:lower()
            if n:find('candy',1,true) or n:find('coin',1,true) then
              remember(obj)
            end
          end
          if i%1800==0 then task.wait() end
        end
      end
      local function cost(item)
        local delta=item.part.Position-here.Position
        local horiz=Vector3.new(delta.X,0,delta.Z).Magnitude
        local vertical=math.abs(delta.Y)
        return horiz+math.max(0,vertical-1.8)*3.7
      end
      table.sort(found,function(a,b) return cost(a)<cost(b) end)
      local cache={}
      for i=1,math.min(#found,64) do cache[#cache+1]=found[i] end
      coinCache=cache
      coinDiag={checked=checked,candidates=#found,nearby=#cache,
        examples=nearbySample,lastAt=os.clock(),error=nil}
    end)
    if not ok then coinDiag.error=tostring(err) end
    coinScanBusy=false
    if coinDiagLabel and coinDiagLabel.Parent then coinDiagLabel.Text=neo.radarMessage() end
    if onDone then pcall(onDone,ok) end
  end)
  return true
end
function neo.diagnosticRadar()
  local lines={neo.radarMessage()}
  if #coinDiag.examples>0 then
    table.insert(lines,'Objets proches interactifs (noms vus) :')
    for _,v in ipairs(coinDiag.examples) do table.insert(lines,'• '..v) end
  else
    table.insert(lines,'Aucun autre objet interactif proche identifié.')
  end
  table.insert(lines,'Le radar ne voit que les objets repliques sur ce telephone.')
  return table.concat(lines,'\n')
end

autoNav = (function()
-- ===== V3.8 : PREPARATION DE LA FUITE AVANT LE DANGER =====
-- Planifie en arriere-plan quelques chemins autour de TON avatar, sans intervention sur les autres joueurs.
-- Les routes sont choisies suivant le Murderer, avec PathfindingService et anti-blocage.
-- Sheriff et Hero ne fuient JAMAIS, meme si le bouton Auto-Fuite reste active.
local navToken, navMode, navTarget, navGoal = 0, nil, nil, nil
local activeRouteWaypoints=nil
local navSince, navNextFarmTry = 0, 0
local navMessage, escapeEngaged = 'En attente', false
local farmIgnored = setmetatable({}, {__mode='k'})
local planned = {routes={},origin=nil,stamp=0,busy=false,progress=0,attempted=0,note='Pas encore analyse'}
local planGeneration, lastPlanAttempt, lastEnemyReplan, nextEscapeAttempt = 0, 0, 0, 0
local userControls, controlsSuppressed = nil, false
-- Pilote de vol controle pour les deux automatismes. Aucune teleporation de cible.
-- Quand une action se termine, le PlayerModule et les proprietes du Humanoid sont rendus.
local ghost = {mode=nil,goal=nil,target=nil,root=nil,humanoid=nil,attach=nil,velocity=nil,
  oldStand=nil,oldRotate=nil,started=0,startingPosition=nil,stuckAt=0,lastPosition=nil}
function neo.stopGhost()
  state._autoGhostActive=false
  if ghost.velocity then pcall(function() ghost.velocity:Destroy() end) end
  if ghost.attach then pcall(function() ghost.attach:Destroy() end) end
  if ghost.root and ghost.root.Parent then
    pcall(function() ghost.root.AssemblyLinearVelocity=Vector3.zero end)
  end
  if ghost.humanoid and ghost.humanoid.Parent then
    pcall(function()
      ghost.humanoid.PlatformStand=ghost.oldStand==true
      if ghost.oldRotate~=nil then ghost.humanoid.AutoRotate=ghost.oldRotate end
      if ghost.humanoid.Health>0 and not ghost.oldStand then
        ghost.humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
      end
    end)
  end
  ghost.mode=nil;ghost.goal=nil;ghost.target=nil
  ghost.root=nil;ghost.humanoid=nil;ghost.attach=nil;ghost.velocity=nil
  ghost.startingPosition=nil;ghost.lastPosition=nil
  ghost.expected=nil;ghost.snaps=0;ghost.escapeAltitude=nil;ghost.currentVelocity=nil
  ghost.farmNearSince=nil;ghost.farmCruiseY=nil
  ghost.farmPhase=nil;ghost.farmUnderY=nil;ghost.idleSince=nil
  if not state.noclip then restoreNoclip() end
end
pcall(function()
  local scripts=Local:FindFirstChild('PlayerScripts')
  local playerModule=scripts and scripts:FindFirstChild('PlayerModule')
  if playerModule and playerModule:IsA('ModuleScript') then
    userControls=require(playerModule):GetControls()
  end
end)
function neo.suppressManualMovement(suppress)
  if not userControls or suppress==controlsSuppressed then return end
  local ok=pcall(function()
    if suppress then userControls:Disable() else userControls:Enable() end
  end)
  if ok then controlsSuppressed=suppress end
end
function neo.eligibleForEscape()
  -- Sécurité : ne prend les commandes QUE lorsque le rôle Innocent est confirmé.
  -- Si MM2 ne fournit plus les rôles, ne suppose pas que tu es Innocent.
  if tool('Gun') or tool('Knife') then return false end
  local entry=roles[Local.Name]
  if os.clock()-rolesReceivedAt>=8 or type(entry)~='table' then return false end
  local role=string.lower(tostring(entry.Role or ''))
  return role=='innocent'
end
function neo.stopMovement()
  navToken=navToken+1
  navMode,navTarget,navGoal=nil,nil,nil
  activeRouteWaypoints=nil
  neo.stopGhost()
  neo.suppressManualMovement(false)
  local h,r=hum(Local),root(Local)
  if h and r and h.Health>0 then pcall(function() h:MoveTo(r.Position) end) end
end

-- ANTI-FLING : protecteur REACTIF de la physique locale.
-- Au repos : aucune modification du personnage, des collisions ou des commandes.
-- Pendant nos propres vols, flings et teleports pilotes : aucun anti-fling.
-- Sur impulsion anormale seulement : annuler vitesse/rotation et, si possible,
-- revenir sur une position stable recente. Le serveur peut imposer sa physique.
neo.antiFlingCtl={character=nil,safe={},lastSample=0,lastBlock=-math.huge,
  lastNotice=-math.huge,blocked=0,enabled=false}
connect(RunService.Heartbeat,function()
  local a=neo.antiFlingCtl
  if not active or not state.antiFling then
    a.enabled=false
    return
  end
  if not a.enabled then
    a.enabled=true;a.character=nil;a.safe={}
  end
  local c=char(Local)
  local r=root(Local)
  local h=hum(Local)
  if not c or not r or not h or h.Health<=0 or not r.Parent then return end
  if a.character~=c then
    a.character=c;a.safe={};a.lastSample=0;a.lastBlock=-math.huge
  end
  -- Le mouvement choisi par l'utilisateur a priorite. Aucune interference
  -- avec le Fly joystick, Farm/Fuite en vol, Orbit, TP Murder ou Fling.
  if flingBusy or combatMoving or state.manualFly or state._autoGhostActive
    or (neo.manualFlyCtl and neo.manualFlyCtl.active)
    or navMode or state.followPlayer or state.bodyBlock or r.Anchored then
    a.safe={};return
  end
  local now=os.clock()
  local velocity=r.AssemblyLinearVelocity
  local angular=r.AssemblyAngularVelocity
  local horizontal=Vector3.new(velocity.X,0,velocity.Z).Magnitude
  local spin=angular.Magnitude
  -- Seuils places nettement au-dessus de la marche/sprint/saut normaux.
  -- Une projection horizontale, une montee anormale ou une rotation physique
  -- extreme declenche la protection. Une chute naturelle seule n'y suffit pas.
  local attack=(horizontal>125 or velocity.Y>130 or spin>65)
  if not attack and ((horizontal>70 and spin>19) or (velocity.Y>80 and spin>22)) then
    -- Cas de fling plus subtil : rotation suspecte au contact d'un joueur.
    for _,p in ipairs(Players:GetPlayers()) do
      if p~=Local then
        local other=root(p)
        if other and (other.Position-r.Position).Magnitude<14 then
          attack=true;break
        end
      end
    end
  end
  if attack and now-a.lastBlock>=.07 then
    a.lastBlock=now;a.blocked=a.blocked+1
    -- Pas de PlatformStand, pas d'Anchored et pas de changement du joystick.
    pcall(function()
      r.AssemblyAngularVelocity=Vector3.zero
      r.AssemblyLinearVelocity=Vector3.zero
    end)
    local chosen=nil
    -- Point au sol d'au moins .3 s, donc avant le contact suspect.
    for i=#a.safe,1,-1 do
      local item=a.safe[i]
      if now-item.t>=.30 and now-item.t<3.0 then chosen=item.cf;break end
    end
    if chosen and Local.Character==c then
      pcall(function() c:PivotTo(chosen) end)
    end
    if now-a.lastNotice>2.5 then
      a.lastNotice=now
      status('ANTI-FLING : projection anormale detectee, mouvement stabilise.')
    end
  end
  -- Ne pas enregistrer le point d'impact comme "position sure".
  if now-a.lastBlock<.65 then return end
  if now-a.lastSample>=.12 and h.FloorMaterial~=Enum.Material.Air
     and horizontal<45 and math.abs(velocity.Y)<55 and spin<10 then
    a.lastSample=now
    table.insert(a.safe,{cf=r.CFrame,t=now})
    if #a.safe>24 then table.remove(a.safe,1) end
  end
end)

-- ===== OP FLY NEO : PILOTE MOBILE FIABLE, BASE YARHM 1.21 (GPL-3.0) =====
-- Le FlyUtility YARHM est la reference de comportement (joystick + camera).
-- Correction NEO : le module PlayerModule:GetControls():GetMoveVector() lit directement
-- le joystick iPhone lorsque Humanoid.MoveDirection reste nul sous PlatformStand.
-- Aucun bouton tactile directionnel n'est ajoute. NoClip est automatiquement actif pendant Fly.
-- YARHM (Joystickplays/Aetherion) GPL-3.0; licence du code derive en fin de fichier.
function neo.createYarhmFlyUtility()
  local player=Players.LocalPlayer
  local run=RunService
  local utility={}
  local maxSpeed=50
  local isFlying=false
  local flightConnection=nil
  local removingConnection=nil
  local velocityBody=nil
  local gyroBody=nil
  local flightRoot=nil
  local flightHumanoid=nil
  local flightCharacter=nil
  local savedStand=nil
  local savedRotate=nil
  local userControls=nil
  local currentSpeed=0
  local currentVelocity=Vector3.zero

  local function obtainControls()
    local ps=player:FindFirstChild('PlayerScripts')
    local pm=ps and ps:FindFirstChild('PlayerModule')
    if not pm or not pm:IsA('ModuleScript') then return nil end
    local ok,controls=pcall(function() return require(pm):GetControls() end)
    if ok and controls and type(controls.GetMoveVector)=='function' then return controls end
    return nil
  end

  function utility:GetMaxSpeed() return maxSpeed end
  function utility:SetMaxSpeed(n)
    if type(n)=='number' and n==n then maxSpeed=math.clamp(n,50,350) end
  end
  function utility:IsFlying() return isFlying end
  function utility:Stop()
    isFlying=false
    if flightConnection then flightConnection:Disconnect();flightConnection=nil end
    if removingConnection then removingConnection:Disconnect();removingConnection=nil end
    if velocityBody then pcall(function() velocityBody:Destroy() end);velocityBody=nil end
    if gyroBody then pcall(function() gyroBody:Destroy() end);gyroBody=nil end
    if flightHumanoid and flightHumanoid.Parent then
      pcall(function()
        flightHumanoid.PlatformStand=(savedStand==true)
        if savedRotate~=nil then flightHumanoid.AutoRotate=savedRotate end
        if flightHumanoid.Health>0 and not savedStand then
          flightHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
      end)
    end
    flightRoot=nil;flightHumanoid=nil;flightCharacter=nil
    savedStand=nil;savedRotate=nil;userControls=nil
    currentSpeed=0;currentVelocity=Vector3.zero
  end
  function utility:Start()
    if isFlying then return true end
    local ch=player.Character
    local h=ch and ch:FindFirstChildOfClass('Humanoid')
    local r=ch and ch:FindFirstChild('HumanoidRootPart')
    if not h or not r or h.Health<=0 or r.Anchored then return false end
    flightCharacter=ch;flightHumanoid=h;flightRoot=r
    savedStand=h.PlatformStand;savedRotate=h.AutoRotate
    userControls=obtainControls()
    -- Réactive les contrôles Roblox au cas où un trajet Auto-Farm les avait désactivés.
    if userControls then pcall(function() userControls:Enable() end) end

    local ok,err=pcall(function()
      gyroBody=Instance.new('BodyGyro')
      gyroBody.Name='NeoYarhmFlyGyro'
      gyroBody.P=100000
      gyroBody.D=1000
      gyroBody.MaxTorque=Vector3.new(1e9,1e9,1e9)
      gyroBody.CFrame=r.CFrame
      gyroBody.Parent=r
      velocityBody=Instance.new('BodyVelocity')
      velocityBody.Name='NeoYarhmFlyVelocity'
      velocityBody.P=12500
      velocityBody.MaxForce=Vector3.new(1e9,1e9,1e9)
      velocityBody.Velocity=Vector3.zero
      velocityBody.Parent=r
      h.AutoRotate=false
      h.PlatformStand=true
    end)
    if not ok then self:Stop();error('Fly physique: '..tostring(err)) end
    isFlying=true
    currentSpeed=0;currentVelocity=Vector3.zero
    removingConnection=player.CharacterRemoving:Connect(function(oldChar)
      if oldChar==flightCharacter then utility:Stop() end
    end)
    flightConnection=run.Heartbeat:Connect(function(dt)
      local updateOk,updateError=pcall(function()
      if not isFlying then return end
      local liveH,liveR=flightHumanoid,flightRoot
      local camera=workspace.CurrentCamera
      if not liveH or not liveR or liveH.Health<=0 or liveR.Anchored
        or not liveR.Parent or not velocityBody or not velocityBody.Parent
        or not gyroBody or not gyroBody.Parent or not camera
        or player.Character~=flightCharacter then
        utility:Stop()
        return
      end
      dt=math.clamp(tonumber(dt) or .016,.004,.09)
      -- Source primaire : vecteur du joystick natif (fonctionne sous PlatformStand).
      local inputVec=Vector3.zero
      if not userControls then userControls=obtainControls() end
      if userControls then
        local okMv,mv=pcall(function() return userControls:GetMoveVector() end)
        if okMv and typeof(mv)=='Vector3' then inputVec=mv end
      end
      local look=camera.CFrame.LookVector
      local right=camera.CFrame.RightVector
      local flatLook=Vector3.new(look.X,0,look.Z)
      local flatRight=Vector3.new(right.X,0,right.Z)
      if flatLook.Magnitude<.01 then
        local rv=liveR.CFrame.LookVector
        flatLook=Vector3.new(rv.X,0,rv.Z)
      end
      if flatLook.Magnitude<.01 then flatLook=Vector3.new(0,0,-1) end
      flatLook=flatLook.Unit
      if flatRight.Magnitude<.01 then flatRight=Vector3.new(-flatLook.Z,0,flatLook.X) end
      flatRight=flatRight.Unit
      local desired=Vector3.zero
      if inputVec.Magnitude>.035 then
        -- X: décalage latéral, Z négatif: joystick vers l'avant.
        desired=flatRight*inputVec.X-flatLook*inputVec.Z+
          Vector3.new(0,-inputVec.Z*look.Y,0)
      else
        -- Secours si l'API PlayerModule n'est pas accessible via l'exécuteur.
        local worldMove=liveH.MoveDirection
        if worldMove.Magnitude>.035 then
          desired=Vector3.new(worldMove.X,0,worldMove.Z)
          desired=desired+Vector3.new(0,worldMove:Dot(flatLook)*look.Y,0)
        end
      end
      if desired.Magnitude>.035 then
        desired=desired.Unit
        currentSpeed=math.min(maxSpeed,currentSpeed+220*dt)
        local target=desired*currentSpeed
        currentVelocity=currentVelocity:Lerp(target,math.clamp(dt*13,0,1))
      else
        currentSpeed=0
        currentVelocity=currentVelocity:Lerp(Vector3.zero,math.clamp(dt*18,0,1))
        if currentVelocity.Magnitude<.75 then currentVelocity=Vector3.zero end
      end
      velocityBody.Velocity=currentVelocity
      local face=look
      if face.Magnitude<.01 then face=flatLook end
      local tilt=math.rad(math.clamp(currentSpeed/math.max(50,maxSpeed)*26,0,26))
      local okFace,cf=pcall(function()
        return CFrame.lookAt(liveR.Position,liveR.Position+face)*CFrame.Angles(-tilt,0,0)
      end)
      if okFace then gyroBody.CFrame=cf end
      end) -- Fin du calcul physique, surveille les erreurs d'execution.
      if not updateOk then
        utility:Stop()
        if neo.manualFlyCtl and neo.manualFlyCtl.module==utility then neo.stopManualFly() end
        status('OP Fly : erreur moteur '..tostring(updateError):sub(1,85))
      elseif not isFlying and neo.manualFlyCtl and neo.manualFlyCtl.module==utility then
        neo.stopManualFly()
        status('OP Fly interrompu : personnage non disponible.')
      end
    end)
    return true
  end
  return utility
end
neo.manualFlyCtl={module=nil,root=nil,humanoid=nil,oldStand=nil,oldRotate=nil,active=false}
function neo.stopManualFly()
  local ctl=neo.manualFlyCtl
  state.manualFly=false
  ctl.active=false
  if ctl.module then pcall(function() ctl.module:Stop() end) end
  if ctl.humanoid and ctl.humanoid.Parent and ctl.humanoid.Health>0 then
    pcall(function()
      ctl.humanoid.PlatformStand=ctl.oldStand==true
      if ctl.oldRotate~=nil then ctl.humanoid.AutoRotate=ctl.oldRotate end
      if not ctl.oldStand then ctl.humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end)
  end
  ctl.module=nil;ctl.root=nil;ctl.humanoid=nil
  ctl.oldStand=nil;ctl.oldRotate=nil
  if not state.noclip and not state._autoGhostActive then restoreNoclip() end
end
function neo.startManualFly()
  if neo.adminIsBlocked('manualFly') or neo.adminIsBlocked('freezeMove') then
    status('NEO ADMIN : OP Fly indisponible pour cette copie.');state.manualFly=false;return false
  end
  local r,h=root(Local),hum(Local)
  if not r or not h or h.Health<=0 then
    state.manualFly=false;status('OP Fly : personnage vivant requis.');return false
  end
  if r.Anchored then
    state.manualFly=false;status('OP Fly : personnage immobilise (Anchored).');return false
  end
  local ctl=neo.manualFlyCtl
  if ctl.active and ctl.module and ctl.module:IsFlying() then
    state.manualFly=true;return true
  end
  -- Couper les pilotes automatiques avant de lancer le Fly manuel.
  state.autoFarm=false;state.autoEscape=false
  state.followPlayer=false;state.bodyBlock=false
  autoNav.halt();autoNav.resetEscape();neo.stopGhost()
  neo.suppressManualMovement(false)
  neo.detachPlayer('OP Fly manuel')
  bodyBlock.stop('OP Fly manuel')
  neo.stopCombatPosition()
  if state.freecam then neo.stopFreecam() end
  if watching then neo.returnCameraToBody() end
  ctl.root=r;ctl.humanoid=h;ctl.oldStand=h.PlatformStand;ctl.oldRotate=h.AutoRotate
  local ok,err=pcall(function()
    ctl.module=neo.createYarhmFlyUtility()
    ctl.module:SetMaxSpeed(manualFlySpeed)
    if not ctl.module:Start() or not ctl.module:IsFlying() then
      error('Le pilote ne demarre pas (personnage indisponible)')
    end
  end)
  if not ok then
    neo.stopManualFly()
    status('OP Fly erreur : '..tostring(err):sub(1,90))
    return false
  end
  ctl.active=true;state.manualFly=true
  if window.Visible then minimizeHub() end
  status('OP Fly : joystick Roblox + noclip, vitesse '..manualFlySpeed..'.')
  return true
end
-- ===== FIN OP FLY YARHM =====

function neo.clearPlan()
  planGeneration=planGeneration+1
  for _,route in ipairs(planned.routes) do
    if route.path then pcall(function() route.path:Destroy() end) end
  end
  planned.routes={}
  planned.origin=nil
  planned.stamp=0
  planned.busy=false
  planned.progress=0
  planned.attempted=0
  planned.note='Analyse a refaire'
  lastPlanAttempt=0
end
function neo.navPermitted(token)
  return active and token==navToken and alive(Local)
    and not state.freecam and watching==nil and not flingBusy
end
function neo.chooseFarmTarget(except)
  local me=root(Local)
  if not me then return nil end
  local best,bestScore=nil,math.huge
  local now=os.clock()
  for _,item in ipairs(coinCache) do
    local p=item.part
    if p and p~=except and neo.isLivePickup(p) and not p:IsDescendantOf(char(Local))
      and (farmIgnored[p] or 0)<now then
      local delta=p.Position-me.Position
      local horizontal=Vector3.new(delta.X,0,delta.Z).Magnitude
      local vertical=math.abs(delta.Y)
      -- Le farm rapide vise le pickup le plus proche dans le vrai CoinContainer.
      -- Distance verticale penalisee, mais elle ne provoque pas une montee prealable.
      local score=horizontal+math.max(0,vertical-2)*3.1
      if vertical<3 and horizontal<18 then score=score-7 end
      if delta.Y>8 then score=score+9 end
      if neo.isVerifiedPickup(p) then score=score-6 end
      if delta.Magnitude<260 and score<bestScore then
        best,bestScore=p,score
      end
    end
  end
  return best
end
function neo.pathTo(startPoint,endPoint)
  local path
  local ok=pcall(function()
    path=PathfindingService:CreatePath({AgentRadius=2,AgentHeight=5,AgentCanJump=true,WaypointSpacing=4})
    path:ComputeAsync(startPoint,endPoint)
  end)
  if not ok or not path or path.Status~=Enum.PathStatus.Success then
    if path then pcall(function() path:Destroy() end) end
    return nil,nil
  end
  local points=path:GetWaypoints()
  if #points<2 then pcall(function() path:Destroy() end);return nil,nil end
  return path,points
end
function neo.findGround(pos,params)
  local hit=workspace:Raycast(pos+Vector3.new(0,13,0),Vector3.new(0,-35,0),params)
  if hit and hit.Normal.Y>.55 and hit.Instance.CanCollide then
    return hit.Position+Vector3.new(0,2.8,0)
  end
  return nil
end
function neo.planMap(force)
  if planned.busy or not state.autoEscape or not neo.eligibleForEscape()
     or not alive(Local) or state.freecam or watching then return false end
  local r=root(Local)
  if not r then return false end
  local now=os.clock()
  if not force and now-lastPlanAttempt<(state.performance and 12 or 9) then return false end
  local origin=r.Position
  if not force and planned.origin and now-planned.stamp<17
      and (origin-planned.origin).Magnitude<13 and #planned.routes>0 then return false end
  lastPlanAttempt=now
  planned.busy=true;planned.progress=0;planned.attempted=0
  planned.note='Analyse des sorties en cours...'
  planGeneration=planGeneration+1
  local generation=planGeneration
  task.spawn(function()
    local result={}
    local rayParams=RaycastParams.new()
    rayParams.FilterType=Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances={char(Local),escapeGroundFolder}
    rayParams.IgnoreWater=true
    -- 8 directions, proche ET loin. Chaque itineraire est verifie par PathfindingService.
    local angles={0,math.pi/4,math.pi/2,3*math.pi/4,math.pi,5*math.pi/4,3*math.pi/2,7*math.pi/4}
    for i,angle in ipairs(angles) do
      if generation~=planGeneration or not active or not alive(Local) then break end
      local radius=(i%2==0 and 47 or 36)
      local dir=Vector3.new(math.cos(angle),0,math.sin(angle))
      local goal=neo.findGround(origin+dir*radius,rayParams)
      if goal and math.abs(goal.Y-origin.Y)<11 then
        local path,waypoints=neo.pathTo(origin,goal)
        if path and waypoints then
          local length=0
          for j=2,#waypoints do
            length=length+(waypoints[j].Position-waypoints[j-1].Position).Magnitude
          end
          local final=waypoints[#waypoints].Position
          if length>=13 and length<155 and (final-origin).Magnitude>12 then
            table.insert(result,{path=path,waypoints=waypoints,
              goal=final,length=length})
          else pcall(function() path:Destroy() end) end
        end
      end
      if generation==planGeneration then
        planned.progress=i;planned.attempted=#angles
        planned.note='Analyse carte : '..i..'/'..#angles..' directions'
      end
      task.wait(.045) -- ne pas bloquer le mobile pendant les calculs
    end
    if generation~=planGeneration or not active then
      for _,route in ipairs(result) do pcall(function() route.path:Destroy() end) end
      return
    end
    for _,route in ipairs(planned.routes) do
      if route.path then pcall(function() route.path:Destroy() end) end
    end
    planned.routes=result
    planned.origin=origin
    planned.stamp=os.clock()
    planned.busy=false
    planned.note=#result..' chemins pre-calcules'
    if not navMode then navMessage=planned.note end
  end)
  return true
end
function neo.chooseEscapeRoute(me,enemy)
  if planned.busy or not planned.origin or #planned.routes==0
      or (me.Position-planned.origin).Magnitude>13 or os.clock()-planned.stamp>24 then
    return nil
  end
  local predicted=enemy.Position+enemy.AssemblyLinearVelocity*.32
  local fromEnemy=me.Position-predicted
  local best,bestScore=nil,-math.huge
  for _,route in ipairs(planned.routes) do
    local minDistance=math.huge
    for j=1,#route.waypoints,math.max(1,math.floor(#route.waypoints/8)) do
      local pos=route.waypoints[j].Position
      minDistance=math.min(minDistance,(pos-predicted).Magnitude)
    end
    local last=route.goal
    local gain=(last-predicted).Magnitude-(me.Position-predicted).Magnitude
    local direction=last-me.Position
    local away=0
    if direction.Magnitude>.1 and fromEnemy.Magnitude>.1 then
      away=direction.Unit:Dot(fromEnemy.Unit)
    end
    local score=gain*1.6 + minDistance*.36 + away*18 - route.length*.11
    if minDistance<15 then score=score-50 end
    if gain<3 then score=score-35 end
    if score>bestScore then best,bestScore=route,score end
  end
  return best
end
function neo.emergencyGoal(me,enemy)
  -- Solution de secours SEULEMENT si aucun chemin n'etait precharge.
  local away=me.Position-enemy.Position
  away=Vector3.new(away.X,0,away.Z)
  if away.Magnitude<.1 then away=Vector3.new(1,0,0) end
  away=away.Unit
  local rayParams=RaycastParams.new()
  rayParams.FilterType=Enum.RaycastFilterType.Exclude
  rayParams.FilterDescendantsInstances={char(Local),char(findMurderer()),escapeGroundFolder}
  rayParams.IgnoreWater=true
  local best,bestScore=nil,-math.huge
  for _,angle in ipairs({0,-.55,.55,-1.1,1.1,math.pi}) do
    local dir=CFrame.fromAxisAngle(Vector3.yAxis,angle):VectorToWorldSpace(away)
    local goal=neo.findGround(me.Position+dir*31,rayParams)
    if goal then
      local gain=(goal-enemy.Position).Magnitude-(me.Position-enemy.Position).Magnitude
      if gain>bestScore then best,bestScore=goal,gain end
    end
  end
  return best
end
-- Signal de ramassage pour le joueur local, si MM2 expose toujours l'event.
local lastCoinCollectedAt=0
local function hookCoinCollected()
  local remotes=RS:FindFirstChild('Remotes')
  local gameplay=remotes and remotes:FindFirstChild('Gameplay')
  local event=gameplay and gameplay:FindFirstChild('CoinCollected')
  if event and event:IsA('RemoteEvent') then
    connect(event.OnClientEvent,function() lastCoinCollectedAt=os.clock() end)
    return true
  end
  return false
end
task.spawn(function()
  for _=1,8 do
    if not active then return end
    if hookCoinCollected() then return end
    task.wait(2)
  end
end)
-- Changement direct de bonbon : conserve le meme pilote de vol, le meme
-- NoClip et l'etat Physics. Evite le "GettingUp" + redemarrage a chaque objet.
function neo.setFarmFlightTarget(part,now)
  local r=ghost.root
  if not r or not r.Parent or not part or not neo.isLivePickup(part) then return false end
  now=now or os.clock()
  ghost.target=part
  ghost.started=now
  ghost.startingPosition=r.Position
  ghost.stuckAt=now
  ghost.lastPosition=r.Position
  ghost.expected=nil;ghost.snaps=0
  ghost.farmNearSince=nil
  ghost.idleSince=nil
  ghost.collectStartAt=lastCoinCollectedAt
  ghost.farmPhase='DIRECT'
  ghost.farmUnderY=nil
  -- Mode sous-sol facultatif : seul un sol local detecte par raycast est admissible.
  -- Ne descend jamais arbitrairement dans le vide.
  if state.farmUnderground then
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={char(Local),part}
    params.IgnoreWater=true
    local hit=workspace:Raycast(part.Position+Vector3.new(0,1,0),
      Vector3.new(0,-7,0),params)
    if hit and hit.Instance and hit.Instance.CanCollide and hit.Normal.Y>.6
      and math.abs(part.Position.Y-hit.Position.Y)<5 then
      ghost.farmUnderY=hit.Position.Y-1.2
      ghost.farmPhase='UNDER'
    end
  end
  ghost.goal=part.Position
  navTarget=part;navGoal=ghost.goal;navSince=now
  return true
end
function neo.nextFarmFlightTarget(now,success)
  local old=ghost.target
  now=now or os.clock()
  if old then farmIgnored[old]=now+(success and 3 or 5) end
  local nxt=neo.chooseFarmTarget(old)
  if not nxt or not neo.setFarmFlightTarget(nxt,now) then
    navTarget=nil;navGoal=nil
    return false
  end
  navMessage='Bonbon suivant (vol continu)'
  return true
end
-- V4.9 : vol garde + noclip garde; pas de CFrame impose chaque image.
-- BodyVelocity seul et vitesse acceleree progressivement. Le serveur reste autoritaire.
-- Si la validation serveur refuse le passage dans les murs, aucun patch client ne le garantit.
function neo.startGhostNav(mode,target,goal)
  local h,r=hum(Local),root(Local)
  if not state.flyNoclipAuto or not h or not r or h.Health<=0 or not goal then return false end
  -- Passage de OP Fly manuel vers le pilote automatique sans deux forces concurrentes.
  if neo.manualFlyCtl.active then neo.stopManualFly() end
  neo.stopMovement()
  local mover
  local ok,err=pcall(function()
    mover=Instance.new('BodyVelocity')
    mover.Name='NeoFlyController'
    mover.MaxForce=Vector3.new(90000,120000,90000)
    mover.P=1600
    mover.Velocity=Vector3.zero
    mover.Parent=r
  end)
  if not ok or not mover then
    if mover then pcall(function() mover:Destroy() end) end
    navMessage='Pilote indisponible : '..tostring(err):sub(1,45)
    return false
  end
  ghost.mode=mode;ghost.target=target;ghost.goal=goal
  ghost.root=r;ghost.humanoid=h;ghost.attach=nil;ghost.velocity=mover
  ghost.oldStand=h.PlatformStand;ghost.oldRotate=h.AutoRotate
  ghost.started=os.clock();ghost.startingPosition=r.Position
  ghost.stuckAt=ghost.started;ghost.lastPosition=r.Position
  ghost.escapeAltitude=r.Position.Y+7
  ghost.snaps=0;ghost.expected=nil;ghost.currentVelocity=Vector3.zero
  ghost.farmNearSince=nil;ghost.farmCruiseY=nil;ghost.idleSince=nil
  if mode=='FARM' then neo.setFarmFlightTarget(target,ghost.started) end
  state._autoGhostActive=true
  pcall(function()
    h.AutoRotate=false
    h:ChangeState(Enum.HumanoidStateType.Physics)
  end)
  neo.suppressManualMovement(true)
  navMode,navTarget,navGoal,navSince=mode,target,goal,os.clock()
  activeRouteWaypoints=nil
  navMessage=(mode=='FARM' and 'Vol direct vers bonbon/piece' or 'Vol de fuite en cours')
  return true
end

connect(RunService.Heartbeat,function(dt)
  if not ghost.mode then return end
  local mode,r,h=ghost.mode,ghost.root,ghost.humanoid
  local function cancel(reason)
    if mode=='FARM' and ghost.target then farmIgnored[ghost.target]=os.clock()+12 end
    neo.stopMovement()
    if reason then navMessage=reason end
  end
  if not active or not state.flyNoclipAuto or not r or not r.Parent
    or not h or not h.Parent or h.Health<=0 or state.freecam or watching
    or flingBusy or combatMoving or state.bodyBlock then
    cancel('Vol arrete : controle rendu')
    return
  end
  local now=os.clock()
  if mode=='FARM' and not state.autoFarm then
    cancel('Farm desactive')
    return
  end
  if mode=='FARM' and (not ghost.target or not neo.isLivePickup(ghost.target)) then
    if not neo.nextFarmFlightTarget(now,false) then
      -- Ne pas relancer le pilote a chaque objet : attendre un scan en vol stationnaire.
      ghost.target=nil
      ghost.idleSince=ghost.idleSince or now
      if ghost.velocity and ghost.velocity.Parent then ghost.velocity.Velocity=Vector3.zero end
      ghost.currentVelocity=Vector3.zero
      if not coinScanBusy and now-(coinDiag.lastAt or 0)>.7 then neo.scanCoins() end
      if now-ghost.idleSince>2.4 then cancel('Plus de bonbons confirmes : pause farm')
      else navMessage='Recherche du bonbon suivant...' end
    end
    return
  end
  if mode=='ESCAPE' and (not state.autoEscape or not neo.eligibleForEscape()) then
    cancel('Fuite arrete : role non innocent')
    return
  end
  local goal
  if mode=='FARM' then
    local p=ghost.target.Position
    local flat=Vector3.new(r.Position.X-p.X,0,r.Position.Z-p.Z).Magnitude
    local diffY=r.Position.Y-p.Y
    -- Mode rapide : trajectoire sans monter sur un toit au debut de chaque cible.
    -- Sous-sol : si disponible, finir les derniers studs en remontant sur le pickup.
    if ghost.farmPhase=='UNDER' and flat<4.8 then ghost.farmPhase='CONTACT' end
    if ghost.farmPhase=='UNDER' and ghost.farmUnderY then
      goal=Vector3.new(p.X,ghost.farmUnderY,p.Z)
    else
      goal=Vector3.new(p.X,p.Y+math.clamp(diffY,-.6,.6),p.Z)
    end
    ghost.farmCruiseY=goal.Y
    if flat<1.15 and math.abs(diffY)<1.7 then
      ghost.farmNearSince=ghost.farmNearSince or now
      if ghost.velocity and ghost.velocity.Parent then ghost.velocity.Velocity=Vector3.zero end
      ghost.currentVelocity=Vector3.zero
      local success=not neo.isLivePickup(ghost.target)
        or (lastCoinCollectedAt>(ghost.collectStartAt or 0)
          and lastCoinCollectedAt>=ghost.farmNearSince)
      local timedOut=now-ghost.farmNearSince>.72
      if success or timedOut then
        if not neo.nextFarmFlightTarget(now,success) then
          ghost.target=nil
          ghost.currentVelocity=Vector3.zero
          ghost.idleSince=now
          if not coinScanBusy then neo.scanCoins() end
          navMessage=success and 'Bonbon collecte : recherche suivante'
            or 'Bonbon non confirme : recherche suivante'
        end
      end
      return
    else
      ghost.farmNearSince=nil
    end
    if now-ghost.started>math.clamp((ghost.startingPosition-p).Magnitude/math.max(12,farmSpeed-4)+3,4.5,13) then
      farmIgnored[ghost.target]=now+4
      if not neo.nextFarmFlightTarget(now,false) then
        ghost.target=nil;ghost.idleSince=now
        if not coinScanBusy then neo.scanCoins() end
      end
      return
    end
  else
    local murder=findMurderer()
    local enemy=murder and root(murder)
    if not enemy then cancel('Murderer introuvable');return end
    local diff=r.Position-enemy.Position
    if diff.Magnitude>76 then cancel('Distance de securite atteinte');return end
    if now-ghost.started>11 or (r.Position-ghost.startingPosition).Magnitude>145 then
      cancel('Etape de fuite terminee : reevaluation')
      return
    end
    local away=Vector3.new(diff.X,0,diff.Z)
    if away.Magnitude<.1 then away=Vector3.new(1,0,0) end
    goal=Vector3.new(r.Position.X+away.Unit.X*30,
      ghost.escapeAltitude or r.Position.Y+7,
      r.Position.Z+away.Unit.Z*30)
  end
  ghost.goal=goal;navGoal=goal
  local offset=goal-r.Position
  if offset.Magnitude<.1 then
    if mode=='FARM' and ghost.velocity then
      ghost.velocity.Velocity=Vector3.zero
      ghost.currentVelocity=Vector3.zero
    end
    return
  end
  -- Vérifier la correction du serveur AVANT d'écrire notre nouvelle position.
  -- L'ancienne version vérifiait après son propre CFrame, ce qui masquait le rollback.
  local currentPos=r.Position
  if ghost.expected then
    local correction=(currentPos-ghost.expected).Magnitude
    if correction>10 then
      ghost.snaps=(ghost.snaps or 0)+1
    else
      ghost.snaps=math.max(0,(ghost.snaps or 0)-.25)
    end
  end
  if (ghost.snaps or 0)>=4 then
    cancel('Vol refuse / position corrigee par le serveur')
    return
  end
  -- À 60 FPS, 38 studs/s = ~0,63 stud/image : seuil 1 = faux blocage.
  if ghost.lastPosition and (currentPos-ghost.lastPosition).Magnitude>.14 then
    ghost.stuckAt=now
  elseif now-ghost.stuckAt>2.2 then
    cancel('Vol bloque : autre trajet necessaire')
    return
  end
  ghost.lastPosition=currentPos
  -- Le CFrame direct + BodyVelocity doublait le deplacement et pouvait creer
  -- de grands ecarts entre client et serveur. Un seul pilote physique travaille.
  local step=math.clamp(tonumber(dt) or .016,1/240,1/25)
  local maxSpeed=mode=='ESCAPE' and 28 or farmSpeed
  -- Derniers studs du farm a vitesse reduite pour eviter de depasser le hitbox.
  local minSpeed=mode=='FARM' and .7 or 5
  local gain=mode=='FARM' and 4.0 or 2.0
  -- Freinage anticipe : vitesse forte sur la ligne droite, contact plus precis.
  local speed=math.min(maxSpeed,math.max(minSpeed,offset.Magnitude*gain))
  if mode=='FARM' then
    speed=math.min(speed,math.sqrt(2*112*math.max(.03,offset.Magnitude-.5)))
  end
  local want=offset.Unit*speed
  -- Limiter surtout la vitesse verticale pour ne pas bondir hors de la carte.
  want=Vector3.new(want.X,math.clamp(want.Y,
    mode=='FARM' and -18 or -14,mode=='FARM' and 18 or 14),want.Z)
  if mode=='FARM' and (r.Position.Y-goal.Y)>6 then
    -- Si le personnage reste sur un toit au-dessus du bonbon, descendre
    -- d'abord sans arreter completement le mouvement horizontal.
    want=Vector3.new(want.X*.7,math.min(want.Y,-9),want.Z*.7)
  end
  local previous=ghost.currentVelocity or Vector3.zero
  local difference=want-previous
  local maxDelta=(mode=='FARM' and 145 or 95)*step
  local velocity=previous+(difference.Magnitude>maxDelta and difference.Unit*maxDelta or difference)
  ghost.currentVelocity=velocity
  if (currentPos-ghost.startingPosition).Magnitude>600
      or math.abs(currentPos.Y-ghost.startingPosition.Y)>85 then
    cancel('Position anormale : vol stoppe')
    return
  end
  local ok,err=pcall(function()
    if not ghost.velocity or not ghost.velocity.Parent then error('Pilote absent') end
    ghost.velocity.Velocity=velocity
  end)
  if not ok then
    cancel('Erreur pilote Fly : '..tostring(err):sub(1,40))
    return
  end
  ghost.expected=currentPos+velocity*step
end)

function neo.startAutoNav(mode,goal,pickup,preplanned)
  if not goal or not alive(Local) then return end
  neo.stopMovement()
  local token=navToken
  navMode,navTarget,navGoal,navSince=mode,pickup,goal,os.clock()
  neo.suppressManualMovement(true)
  navMessage=(mode=='FARM' and 'Vers un bonbon / une piece' or 'Fuite par chemin verifie')
  task.spawn(function()
    local me,h=root(Local),hum(Local)
    if not me or not h or not neo.navPermitted(token) then return end
    local path,waypoints=preplanned and preplanned.path, preplanned and preplanned.waypoints
    local ownsPath=false
    if not waypoints then
      path,waypoints=neo.pathTo(me.Position,goal)
      ownsPath=true
    end
    if not neo.navPermitted(token) then
      if ownsPath and path then path:Destroy() end
      return
    end
    if not path or not waypoints then
      -- Ne fonce jamais dans un mur lorsqu'un chemin est introuvable.
      if neo.navPermitted(token) then
        navMode,navTarget,navGoal=nil,nil,nil
        navMessage='Chemin bloque : nouvelle analyse'
        neo.suppressManualMovement(false)
        if mode=='ESCAPE' then lastPlanAttempt=0;planned.stamp=0 end
      end
      return
    end
    if mode=='ESCAPE' then activeRouteWaypoints=waypoints end
    local reached,blocked=true,false
    local wpIndex=1
    local blockedConn=path.Blocked:Connect(function(i)
      if i>=wpIndex then blocked=true end
    end)
    for index,wp in ipairs(waypoints) do
      wpIndex=index
      if not neo.navPermitted(token) then break end
      if mode=='ESCAPE' and (not state.autoEscape or not neo.eligibleForEscape()) then break end
      if mode=='FARM' and (not state.autoFarm or not pickup or not pickup:IsDescendantOf(workspace)) then break end
      if blocked then reached=false;break end
      if wp.Action==Enum.PathWaypointAction.Jump then h.Jump=true end
      if (me.Position-wp.Position).Magnitude>2.8 then
        h:MoveTo(wp.Position)
        local started=os.clock()
        local lastProgress=started
        local previous=me.Position
        while neo.navPermitted(token) and (me.Position-wp.Position).Magnitude>3 do
          if mode=='ESCAPE' and not neo.eligibleForEscape() then reached=false;break end
          if mode=='FARM' and (not pickup or not pickup:IsDescendantOf(workspace)) then break end
          if blocked or os.clock()-started>3.5 then reached=false;break end
          if (me.Position-previous).Magnitude>.65 then
            previous=me.Position;lastProgress=os.clock()
          elseif os.clock()-lastProgress>1.25 then
            reached=false;break
          end
          task.wait(.08)
        end
      end
      if not reached or blocked then break end
    end
    blockedConn:Disconnect()
    if ownsPath and path then path:Destroy() end
    if mode=='FARM' and neo.navPermitted(token) and pickup and pickup:IsDescendantOf(workspace) then
      h:MoveTo(pickup.Position)
      local started=os.clock()
      while neo.navPermitted(token) and pickup:IsDescendantOf(workspace) and os.clock()-started<2 do
        if (me.Position-pickup.Position).Magnitude<1.5 then
          task.wait(.25) -- laisser le pickup enregistrer le contact
          break
        end
        task.wait(.08)
      end
      farmIgnored[pickup]=os.clock()+(reached and 5 or 10)
    end
    if neo.navPermitted(token) then
      navMode,navTarget,navGoal=nil,nil,nil
      activeRouteWaypoints=nil
      neo.suppressManualMovement(false)
      navMessage=reached and 'Trajet termine' or 'Obstacle detecte, nouvel itineraire'
      if mode=='ESCAPE' and not reached then lastPlanAttempt=0;planned.stamp=0 end
    end
  end)
end
function neo.tickAutoMovement(murder)
  if not active then return end
  if combatMoving then
    if navMode then neo.stopMovement() end
    return
  end
  local me=root(Local)
  if not me or not alive(Local) or state.freecam or watching or flingBusy then
    if navMode then neo.stopMovement() end
    return
  end
  local canEscape=neo.eligibleForEscape()
  if not canEscape then
    escapeEngaged=false
    if navMode=='ESCAPE' then neo.stopMovement() end
    -- Le farm peut fonctionner meme avec le pistolet; seule la FUITE est bloquee.
    if state.autoEscape then navMessage='FUITE EN ATTENTE : role arme ou non confirme' end
  end
  if state.autoEscape and canEscape and not escapeEngaged and not state.flyNoclipAuto then
    neo.planMap(false)
  end
  local mr=murder and root(murder)
  local distance=mr and (me.Position-mr.Position).Magnitude or math.huge
  if not state.autoEscape or not canEscape then escapeEngaged=false end
  if state.autoEscape and canEscape and mr and distance<=50 then escapeEngaged=true end
  if not mr or distance>76 then escapeEngaged=false end
  if escapeEngaged and mr then
    if state.followPlayer then state.followPlayer=false;followTarget=nil end
    if state.flyNoclipAuto then
      if navMode~='ESCAPE' or ghost.mode~='ESCAPE' then
        local away=me.Position-mr.Position
        away=Vector3.new(away.X,0,away.Z)
        if away.Magnitude<.2 then away=Vector3.new(1,0,0) end
        local goal=me.Position+away.Unit*55+Vector3.new(0,8,0)
        if not neo.startGhostNav('ESCAPE',nil,goal) then
          navMessage='Vol indisponible : fuite au sol en attente'
        end
      end
      return
    end
    local needNew=navMode~='ESCAPE'
    if navMode=='ESCAPE' and os.clock()-navSince>3.3
        and navGoal and (navGoal-mr.Position).Magnitude<23
        and os.clock()-lastEnemyReplan>2.4 then
      needNew=true
    end
    if needNew and os.clock()<nextEscapeAttempt then return end
    if needNew then
      local route=neo.chooseEscapeRoute(me,mr)
      local goal=route and route.goal or neo.emergencyGoal(me,mr)
      if goal then
        if route then
          navMessage='Fuite preplanifiee : chemin deja calcule'
          neo.startAutoNav('ESCAPE',goal,nil,route)
        else
          neo.startAutoNav('ESCAPE',goal,nil,nil)
        end
        lastEnemyReplan=os.clock()
        nextEscapeAttempt=os.clock()+.65
      else
        nextEscapeAttempt=os.clock()+1.7
        navMessage='Aucun itineraire atteignable detecte'
        if navMode then neo.stopMovement() end
      end
    end
    return
  end
  if navMode=='ESCAPE' then neo.stopMovement() end
  if not state.autoFarm or state.followPlayer then
    if navMode=='FARM' then neo.stopMovement() end
    return
  end
  if navMode=='FARM' then
    if ghost.mode=='FARM' and not navTarget then return end
    if not navTarget or not navTarget:IsDescendantOf(workspace) then
      if ghost.mode~='FARM' then neo.stopMovement() end
    elseif ghost.mode~='FARM' and (me.Position-navTarget.Position).Magnitude<1.3 then
      -- Le mode au sol n'abandonne plus une cible encore hors de portee.
      farmIgnored[navTarget]=os.clock()+2
      neo.stopMovement()
    end
    return
  end
  if os.clock()<navNextFarmTry then return end
  local part=neo.chooseFarmTarget()
  if part then
    if not (state.flyNoclipAuto and neo.startGhostNav('FARM',part,part.Position)) then
      neo.startAutoNav('FARM',part.Position,part,nil)
    end
    navNextFarmTry=os.clock()+1
  else
    -- Cache vide ne signifie pas qu'il n'y a plus de bonbons :
    -- rescan rapide au lieu d'attendre la prochaine boucle normale.
    if not coinScanBusy then neo.scanCoins() end
    navMessage=(coinScanBusy and 'Analyse des objets en cours') or 'Aucune cible en cache : nouveau scan'
    navNextFarmTry=os.clock()+1.8
  end
end
-- Un seul pilote conduit le personnage. Les anciens scans et mouvements sont annulables.
task.spawn(function()
  while active do
    local ok,err=pcall(function() neo.tickAutoMovement(findMurderer()) end)
    if not ok then navMessage='Navigation : '..tostring(err):sub(1,70) end
    task.wait(state.performance and .28 or .18)
  end
end)
return {
  halt=neo.stopMovement,
  resetEscape=function() escapeEngaged=false end,
  clearPlan=neo.clearPlan,
  preplan=function() return neo.planMap(true) end,
  planStatus=function() return planned.note end,
  escaping=function() return navMode=='ESCAPE' end,
  pathPoints=function() return navMode=='ESCAPE' and activeRouteWaypoints or nil end,
  escapeGoal=function() return navMode=='ESCAPE' and navGoal or nil end,
  message=function() return navMessage end
}
end)()

-- ===== V3.9 : COMBAT SHERIF - POSITIONNEMENT PRUDENT =====
-- Le positionnement est facultatif. Pas de teleportation, pas de commande envoyee a la cible.
-- Pathfinding sur la carte qui existe sur le client, avec limitation de calcul iPhone.
local tactical={token=0,working=false,at=0,status='Inactif',goal=nil}
function neo.stopCombatPosition()
  tactical.token=tactical.token+1
  local wasMoving=combatMoving
  combatMoving=false
  tactical.working=false
  tactical.goal=nil
  if wasMoving then
    local h,r=hum(Local),root(Local)
    if h and r then pcall(function() h:MoveTo(r.Position) end) end
  end
end
function neo.canCombatPosition()
  local role=myRole()
  return active and state.combatPosition and state.autoShoot
    and (role=='Sheriff' or role=='Hero') and tool('Gun')~=nil
    and alive(Local) and not state.freecam and watching==nil
    and not state.followPlayer and not flingBusy
end
function neo.hasShotFrom(candidate, enemy)
  local c=char(enemy)
  if not c then return false end
  local center=root(enemy)
  if not center then return false end
  local upper=c:FindFirstChild('UpperTorso') or c:FindFirstChild('Torso')
  local target=upper and upper.Position or center.Position+Vector3.new(0,1,0)
  local dir=target-candidate
  if dir.Magnitude<1 or dir.Magnitude>115 then return false end
  local params=RaycastParams.new()
  params.FilterType=Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances={char(Local)}
  params.IgnoreWater=true
  local hit=workspace:Raycast(candidate,dir,params)
  return hit and hit.Instance:IsDescendantOf(c) or false
end
function neo.locateCombatSpot(enemy)
  local r=root(Local)
  local e=root(enemy)
  if not r or not e then return nil end
  local groundParams=RaycastParams.new()
  groundParams.FilterType=Enum.RaycastFilterType.Exclude
  groundParams.FilterDescendantsInstances={char(Local),char(enemy)}
  groundParams.IgnoreWater=true
  local choices={}
  -- Choisit une zone proche de toi, pas un TP dans le murderer.
  for _,distance in ipairs({10,17,24}) do
    for i=0,7 do
      local angle=i*math.pi/4
      local projected=r.Position+Vector3.new(math.cos(angle)*distance,0,math.sin(angle)*distance)
      local ground=workspace:Raycast(projected+Vector3.new(0,11,0),Vector3.new(0,-26,0),groundParams)
      if ground and ground.Normal.Y>.63 and ground.Instance.CanCollide then
        local spot=ground.Position+Vector3.new(0,3,0)
        local enemyDist=(spot-e.Position).Magnitude
        if enemyDist>18 and enemyDist<105 and neo.hasShotFrom(spot+Vector3.new(0,1.6,0),enemy) then
          table.insert(choices,{position=spot,score=distance+math.abs(enemyDist-35)*.13})
        end
      end
    end
  end
  table.sort(choices,function(a,b) return a.score<b.score end)
  return choices
end
function neo.startCombatPosition(enemy)
  if tactical.working or not neo.canCombatPosition() or not enemy then return end
  if neo.visibleAimPosition(enemy) then return end
  if os.clock()-tactical.at<2.0 then return end
  tactical.at=os.clock()
  tactical.working=true
  tactical.token=tactical.token+1
  local token=tactical.token
  tactical.status='Recherche d un angle de tir...'
  task.spawn(function()
    local candidates=neo.locateCombatSpot(enemy)
    if token~=tactical.token or not active then return end
    if not candidates or #candidates==0 then
      tactical.status='Aucun angle de tir accessible autour de toi'
      tactical.working=false
      return
    end
    local route,waypoints=nil,nil
    -- Seulement trois calculs de chemin, pour economiser la batterie.
    for i=1,math.min(3,#candidates) do
      if not neo.canCombatPosition() or token~=tactical.token or neo.visibleAimPosition(enemy) then break end
      local r=root(Local)
      local path=PathfindingService:CreatePath({AgentRadius=2,AgentHeight=5,AgentCanJump=true,WaypointSpacing=4})
      local ok=pcall(function() path:ComputeAsync(r.Position,candidates[i].position) end)
      if ok and path.Status==Enum.PathStatus.Success then
        local points=path:GetWaypoints()
        if #points>=2 then route,waypoints=path,points;break end
      end
      pcall(function() path:Destroy() end)
      task.wait(.08)
    end
    if not route or token~=tactical.token or not neo.canCombatPosition() then
      if route then route:Destroy() end
      tactical.working=false
      tactical.status='Pas de trajet fiable / commande manuelle disponible'
      return
    end
    -- Le farm cede la priorite au combat uniquement sur choix de l'utilisateur.
    autoNav.halt()
    combatMoving=true
    tactical.goal=waypoints[#waypoints].Position
    tactical.status='Deplacement pour trouver une ligne de tir'
    local blocked=false
    local wpIndex=1
    local blocker=route.Blocked:Connect(function(i) if i>=wpIndex then blocked=true end end)
    for i,wp in ipairs(waypoints) do
      wpIndex=i
      if token~=tactical.token or not neo.canCombatPosition() or blocked or neo.visibleAimPosition(enemy)
         or enemy.Parent~=Players or getRole(enemy)~='Murderer' then break end
      local h,r,er=hum(Local),root(Local),root(enemy)
      if not h or not r or not er or (r.Position-er.Position).Magnitude<15 then break end
      if wp.Action==Enum.PathWaypointAction.Jump then h.Jump=true end
      h:MoveTo(wp.Position)
      local beginning=os.clock()
      local progress=os.clock()
      local last=r.Position
      while os.clock()-beginning<3.0 do
        local liveEnemy=root(enemy)
        if token~=tactical.token or not neo.canCombatPosition() or blocked or neo.visibleAimPosition(enemy)
           or not liveEnemy or getRole(enemy)~='Murderer' then break end
        if (r.Position-wp.Position).Magnitude<3.2 then break end
        if (r.Position-liveEnemy.Position).Magnitude<15 then break end
        if (r.Position-last).Magnitude>.7 then last=r.Position;progress=os.clock() end
        if os.clock()-progress>1.2 then break end
        task.wait(.09)
      end
      if (r.Position-wp.Position).Magnitude>4.5 then break end
    end
    blocker:Disconnect();route:Destroy()
    if token==tactical.token then
      combatMoving=false
      tactical.goal=nil
      tactical.working=false
      tactical.status=neo.visibleAimPosition(enemy) and 'Angle de tir obtenu' or 'Repositionnement termine'
      local h,r=hum(Local),root(Local)
      if h and r then h:MoveTo(r.Position) end
    end
  end)
end

-- ===== V3: clone de ton avatar, visible uniquement sur TON ecran =====
function neo.deleteClone()
  if fakeClone then pcall(function() fakeClone:Destroy() end);fakeClone=nil end
end
function neo.createClone()
  neo.deleteClone()
  local c=char(Local)
  if not c or not root(Local) then status('Ton avatar est absent.');return end
  local old=c.Archivable
  c.Archivable=true
  local ok,copy=pcall(function() return c:Clone() end)
  c.Archivable=old
  if not ok or not copy then status('Impossible de copier cet avatar.');return end
  copy.Name='NEO_FakeClone_LOCAL'
  for _,obj in ipairs(copy:GetDescendants()) do
    if obj:IsA('BaseScript') or obj:IsA('Tool') then
      obj:Destroy()
    elseif obj:IsA('BasePart') then
      obj.Anchored=true;obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false
    elseif obj:IsA('Humanoid') then
      obj.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
    end
  end
  copy.Parent=workspace
  local r=root(Local)
  pcall(function() copy:PivotTo(r.CFrame*CFrame.new(0,0,-4)) end)
  fakeClone=copy
  status('Clone local créé. Les autres ne le voient pas.')
end

-- ===== V3: freecam avec commandes tactiles iPhone =====
local fcControls=make('Frame',{
  Name='FreecamControls',AnchorPoint=Vector2.new(1,1),
  Position=UDim2.new(1,-8,1,-10),Size=UDim2.fromOffset(170,205),
  BorderSizePixel=0,BackgroundColor3=hue.panel,Visible=false,Active=true,ZIndex=20
},gui);corner(fcControls,11)
local freecamButtons={
  {'AV', 'forward',0,0},{'AR','back',1,0},
  {'G', 'left',0,1},{'D','right',1,1},
  {'MONTER','up',0,2},{'DESC.','down',1,2}
}
for _,item in ipairs(freecamButtons) do
  local label,key,x,y=item[1],item[2],item[3],item[4]
  local b=make('TextButton',{
    Text=label,TextSize=12,TextColor3=hue.text,Font=Enum.Font.GothamBold,
    BackgroundColor3=hue.elevated,Position=UDim2.fromOffset(8+x*80,8+y*44),
    Size=UDim2.fromOffset(74,38),ZIndex=21
  },fcControls);corner(b,7)
  connect(b.InputBegan,function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
      freecamInputs[key]=true
      local c;c=input.Changed:Connect(function()
        if input.UserInputState==Enum.UserInputState.End then
          freecamInputs[key]=false
          if c then c:Disconnect() end
        end
      end)
      table.insert(connections,c)
    end
  end)
end
local fcExit=make('TextButton',{
  Text='QUITTER FREECAM',Font=Enum.Font.GothamBold,TextSize=11,
  TextColor3=hue.text,BackgroundColor3=hue.red,
  Position=UDim2.fromOffset(8,146),Size=UDim2.fromOffset(154,45),ZIndex=21
},fcControls);corner(fcExit,8)
function neo.stopFreecam()
  if not state.freecam then fcControls.Visible=false;return end
  state.freecam=false;fcControls.Visible=false
  for key in pairs(freecamInputs) do freecamInputs[key]=false end
  local cam=workspace.CurrentCamera
  if cam then
    cam.CameraType=freecamOldType or Enum.CameraType.Custom
    if hum(Local) then cam.CameraSubject=hum(Local) end
  end
  freecamCF,freecamPos=nil,nil
  status('Freecam arrêtée; caméra normale.')
end
-- Retour de camera utilise par Freecam, Spectate et PANIC.
-- Le corps doit etre VIVANT ; seules les positions reelles des avatars comptent.
function neo.returnCameraToBody(reason)
  watching=nil
  neo.stopFreecam()
  local cam=workspace.CurrentCamera
  local ownHumanoid=hum(Local)
  if cam and ownHumanoid then
    cam.CameraType=Enum.CameraType.Custom
    cam.CameraSubject=ownHumanoid
  end
  if reason then
    status(reason)
    cameraGuardMessageToken=cameraGuardMessageToken+1
    local token=cameraGuardMessageToken
    guardHUD.Text='⚠  '..reason
    guardHUD.Visible=true
    task.delay(2.8,function()
      if active and token==cameraGuardMessageToken then guardHUD.Visible=false end
    end)
    notify(reason,true)
  end
end

function neo.startFreecam()
  if not state.freecam and neo.adminIsBlocked('freecam') then status('NEO ADMIN : FREECAM verrouille.');return end
  if state.freecam then neo.stopFreecam();return end
  local cam=workspace.CurrentCamera
  if not cam then status('Caméra indisponible.') return end
  watching=nil
  state.aim=false;state.autoShoot=false
  state.freecam=true
  freecamOldType=cam.CameraType
  freecamCF=cam.CFrame;freecamPos=cam.CFrame.Position
  local look=cam.CFrame.LookVector
  freecamYaw=math.atan2(-look.X,-look.Z)
  freecamPitch=math.asin(math.clamp(look.Y,-1,1))
  cam.CameraType=Enum.CameraType.Scriptable
  fcControls.Visible=true
  minimizeHub()
  notify('Freecam : boutons + glisser à droite.',false)
end
connect(fcExit.MouseButton1Click,neo.stopFreecam)
local mouseLooking=false
local freecamTouch=nil
connect(UIS.TouchStarted,function(input,processed)
  local cam=workspace.CurrentCamera
  if state.freecam and not processed and cam
    and input.Position.X>cam.ViewportSize.X*.48
    and input.Position.Y<cam.ViewportSize.Y*.68 then
    freecamTouch=input
  end
end)
connect(UIS.TouchMoved,function(input)
  if state.freecam and freecamTouch==input then
    freecamYaw=freecamYaw-math.clamp(input.Delta.X,-80,80)*.004
    freecamPitch=math.clamp(freecamPitch-math.clamp(input.Delta.Y,-80,80)*.004,-1.4,1.4)
  end
end)
connect(UIS.TouchEnded,function(input)
  if freecamTouch==input then freecamTouch=nil end
end)
connect(UIS.InputBegan,function(input,processed)
  if not state.freecam or processed then return end
  if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseLooking=true end
end)
connect(UIS.InputEnded,function(input)
  if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseLooking=false end
end)
connect(UIS.InputChanged,function(input,processed)
  if not state.freecam then return end
  local cam=workspace.CurrentCamera
  if not cam then return end
  if input.UserInputType==Enum.UserInputType.MouseMovement and mouseLooking then
    freecamYaw=freecamYaw-input.Delta.X*.004
    freecamPitch=math.clamp(freecamPitch-input.Delta.Y*.004,-1.4,1.4)
  end
end)
connect(RunService.RenderStepped,function(dt)
  if not active or not state.freecam or not freecamPos then return end
  local cam=workspace.CurrentCamera
  if not cam then return end
  local rotation=CFrame.fromOrientation(freecamPitch,freecamYaw,0)
  local input=Vector3.zero
  if freecamInputs.forward or UIS:IsKeyDown(Enum.KeyCode.W) then input=input+Vector3.new(0,0,-1) end
  if freecamInputs.back or UIS:IsKeyDown(Enum.KeyCode.S) then input=input+Vector3.new(0,0,1) end
  if freecamInputs.left or UIS:IsKeyDown(Enum.KeyCode.A) then input=input+Vector3.new(-1,0,0) end
  if freecamInputs.right or UIS:IsKeyDown(Enum.KeyCode.D) then input=input+Vector3.new(1,0,0) end
  if freecamInputs.up or UIS:IsKeyDown(Enum.KeyCode.E) then input=input+Vector3.new(0,1,0) end
  if freecamInputs.down or UIS:IsKeyDown(Enum.KeyCode.Q) then input=input+Vector3.new(0,-1,0) end
  if input.Magnitude>0 then
    freecamPos=freecamPos+rotation:VectorToWorldSpace(input.Unit)*dt*35
  end
  freecamCF=CFrame.new(freecamPos)*rotation
  cam.CFrame=freecamCF
  cam.Focus=freecamCF*CFrame.new(0,0,-12)
end)

-- ===== V4.0 : BODY BLOCK : approche visible + position en avant =====
-- Ne modifie pas le personnage cible, ne teleporte personne, ne force aucune collision serveur.
-- Une seule IA de mouvement a la fois : Body Block suspend follow, farm, fuite et tactique.
bodyBlock={target=nil,gap=({[2]=true,[3]=true,[5]=true})[retainedOptions.bodyBlockGap]
  and retainedOptions.bodyBlockGap or 3,last=0,token=0,pathAt=0,calculating=false,
  waypoints=nil,index=2,goal=nil,status='OFF'}
do
local blockStopButton=make('TextButton',{
  Name='NeoBodyBlockStop',AnchorPoint=Vector2.new(1,0),
  Position=UDim2.new(1,-12,0,56),Size=UDim2.fromOffset(133,36),
  Text='STOP BODY BLOCK',Font=Enum.Font.GothamBold,TextSize=11,
  TextColor3=UI.white,BackgroundColor3=UI.red,
  BorderSizePixel=0,Visible=false,ZIndex=35
},gui)
corner(blockStopButton,10)
function bodyBlock.stop(reason)
  local wasActive=state.bodyBlock
  state.bodyBlock=false
  bodyBlock.token=bodyBlock.token+1
  bodyBlock.target=nil
  bodyBlock.waypoints=nil
  bodyBlock.goal=nil
  bodyBlock.calculating=false
  bodyBlock.status=reason or 'OFF'
  blockStopButton.Visible=false
  if wasActive then
    local h,r=hum(Local),root(Local)
    if h and r then pcall(function() h:MoveTo(r.Position) end) end
  end
  if reason and active then status('BODY BLOCK : '..reason) end
end
connect(blockStopButton.MouseButton1Click,function() bodyBlock.stop('arrete par STOP') end)

function bodyBlock.start(target)
  if neo.adminIsBlocked('bodyBlock') then status('NEO ADMIN : BODY BLOCK verrouille.');return false end
  if not target or target==Local or target.Parent~=Players or not alive(target) then
    status('BODY BLOCK : cible absente ou eliminee.')
    return false
  end
  if not alive(Local) then status('BODY BLOCK : attends ta reapparition.') return false end
  bodyBlock.stop()
  neo.detachPlayer('Body Block')
  -- Evite les deux scripts de navigation qui donnent des ordres opposes.
  neo.stopCombatPosition()
  state.combatPosition=false
  state.followPlayer=false
  followTarget=nil
  state.autoFarm=false
  state.autoEscape=false
  autoNav.resetEscape()
  autoNav.halt()
  if state.freecam then neo.stopFreecam() end
  if watching then neo.returnCameraToBody() end
  flingStop=true
  bodyBlock.target=target
  bodyBlock.status='Suivi de @'..target.Name
  state.bodyBlock=true
  blockStopButton.Visible=true
  status('BODY BLOCK sur @'..target.Name..' | STOP rouge pour quitter.')
  return true
end

-- Pathfinding seulement a moyenne distance; a courte portee, la position est
-- reactualisee rapidement devant la direction de marche du joueur.
function bodyBlock.requestPath(goal)
  if bodyBlock.calculating then return end
  local me=root(Local)
  if not me then return end
  local token=bodyBlock.token
  local from=me.Position
  bodyBlock.calculating=true
  bodyBlock.pathAt=os.clock()
  task.spawn(function()
    local ok,waypoints=pcall(function()
      local path=PathfindingService:CreatePath({AgentRadius=2,AgentHeight=5,
        AgentCanJump=true,WaypointSpacing=4})
      path:ComputeAsync(from,goal)
      if path.Status==Enum.PathStatus.Success then return path:GetWaypoints() end
      return nil
    end)
    if not active or not state.bodyBlock or token~=bodyBlock.token then return end
    bodyBlock.calculating=false
    bodyBlock.waypoints=(ok and type(waypoints)=='table' and #waypoints>=2) and waypoints or nil
    bodyBlock.index=2
    bodyBlock.goal=goal
  end)
end

function bodyBlock.tick(now)
  if not state.bodyBlock or now-bodyBlock.last<.14 then return end
  bodyBlock.last=now
  local target=bodyBlock.target
  local h,r=hum(Local),root(Local)
  local enemy=root(target)
  if not h or not r or not alive(Local) or not target or target.Parent~=Players
     or not enemy or not alive(target) then
    bodyBlock.stop('cible ou personnage indisponible')
    return
  end
  if state.autoFarm or state.autoEscape or state.followPlayer or state.combatPosition
     or state.freecam or watching or flingBusy then
    bodyBlock.stop('autre mode de mouvement active')
    return
  end
  local velocity=enemy.AssemblyLinearVelocity
  local direction=Vector3.new(velocity.X,0,velocity.Z)
  if direction.Magnitude<2 then
    local eh=hum(target)
    if eh then direction=Vector3.new(eh.MoveDirection.X,0,eh.MoveDirection.Z) end
  end
  if direction.Magnitude<.15 then
    local look=enemy.CFrame.LookVector
    direction=Vector3.new(look.X,0,look.Z)
  end
  if direction.Magnitude<.15 then direction=Vector3.new(0,0,-1) end
  local point=enemy.Position+direction.Unit*bodyBlock.gap
  local distance=(r.Position-point).Magnitude
  if distance<1.75 then
    h:MoveTo(r.Position)
    bodyBlock.status='Devant '..target.DisplayName
    return
  end
  if distance>19 then
    if not bodyBlock.calculating and (not bodyBlock.goal or not bodyBlock.waypoints
       or now-bodyBlock.pathAt>2.25 or (bodyBlock.goal-point).Magnitude>10) then
      bodyBlock.requestPath(point)
    end
    local wp=bodyBlock.waypoints and bodyBlock.waypoints[bodyBlock.index]
    if wp then
      if (r.Position-wp.Position).Magnitude<3.3 then
        bodyBlock.index=bodyBlock.index+1
        wp=bodyBlock.waypoints[bodyBlock.index]
      end
      if wp then
        if wp.Action==Enum.PathWaypointAction.Jump then h.Jump=true end
        h:MoveTo(wp.Position)
        bodyBlock.status='Approche par itineraire'
        return
      end
    end
  end
  -- Approche directe sur les derniers studs, pour ne pas suivre un chemin perime.
  h:MoveTo(point)
  bodyBlock.status='Placement devant '..target.DisplayName..' ('..math.floor(distance)..' studs)'
end

end -- scope des outils Body Block
-- ===== V3: PANIC désactive les automatismes, restaure la caméra =====
function neo.panic()
  if not active then return end
  state.autoRoles=false
  if neo.autoRoleStop then neo.autoRoleStop('PANIC') end
  flingStop=true;followTarget=nil;killAllToken=killAllToken+1
  neo.detachPlayer('PANIC')
  shotCtl.token=shotCtl.token+1;shotBusy=false;nextShot=0
  bodyBlock.stop()
  neo.stopCombatPosition()
  neo.stopManualFly()
  autoNav.halt();autoNav.resetEscape()
  restoreNoclip()
  for _,key in ipairs({
    'aim','autoShoot','triggerBot','combatPosition','knifeAura','autoGrab','autoEscape','autoFarm',
    'speed','jump','infiniteJump','noclip','followPlayer','bodyBlock',
    'escapeRoute','safeScan','coinRadar','threatMeter','bright','murderTrail',
    'antiAfk','dangerAlert'
  }) do state[key]=false end
  watching=nil
  neo.stopFreecam()
  neo.deleteClone()
  neo.clearTrail();neo.clearTargetHighlight()
  neo.hideEscapeGroundLine()
  safeCandidate=nil
  state.esp=false;state.gunESP=false
  neo.cleanupESP()
  neo.refreshMovement();toggleLighting()
  local cam=workspace.CurrentCamera
  if cam then cam.CameraType=Enum.CameraType.Custom;cam.CameraSubject=hum(Local) end
  threatHUD.Visible=false;routeHUD.Visible=false;safeHUD.Visible=false;coinHUD.Visible=false
  neo.saveOptions()
  status('PANIC : actions stoppées. Menu toujours disponible.')
  notify('PANIC activé : automatismes arrêtés.',true)
  if showTab then showTab(selectedTab) end
end

-- ===== V3: Player Inspector dynamique =====
function neo.inspectPlayer(p)
  local h=hum(p)
  local a,b=root(Local),root(p)
  local distance=a and b and math.floor((a.Position-b.Position).Magnitude) or nil
  return '@'..p.Name..'  |  ID '..tostring(p.UserId)..'\n'
    ..'Role : '..getRole(p)..'  |  '..(distance and (distance..' studs') or 'distance inconnue')..'\n'
    ..'Vie : '..(h and math.ceil(h.Health)..'/'..math.ceil(h.MaxHealth) or '?')
    ..'  |  '..(alive(p) and 'En vie' or 'Absent / éliminé')
end

-- ===== V5.6 : deux raccourcis RoJoiner, aucun scanner de serveur =====
-- Essaie uniquement les fonctions d'ouverture exposees par Delta a cet environnement Lua.
-- La propre fenetre de cle Delta se trouve dans son interface native, pas dans Lua.
function neo.rojoinerMessage(message)
  if neo.rojoiner.browserStatusLabel and neo.rojoiner.browserStatusLabel.Parent then
    neo.rojoiner.browserStatusLabel.Text=message
  end
  status(message)
end
function neo.openRoJoiner()
  local url='https://rojoin-two.vercel.app/'
  local methodNames={
    'openurl','open_url','openUrl','OpenURL',
    'openbrowser','open_browser','openBrowser','OpenBrowser',
    'openlink','open_link','openLink','openwebsite','open_website'
  }
  local environments={sharedEnv,_G}
  if type(getfenv)=='function' then
    local ok,environment=pcall(getfenv,0)
    if ok and type(environment)=='table' then table.insert(environments,environment) end
  end
  local called={}
  local tried=0
  for _,environment in ipairs(environments) do
    if type(environment)=='table' then
      for _,name in ipairs(methodNames) do
        local exists,method=pcall(function() return environment[name] end)
        if exists and type(method)=='function' and not called[method] then
          called[method]=true
          tried=tried+1
          local ok,result=pcall(method,url)
          -- Certains executors retournent false lorsqu'ils refusent la demande.
          if ok and result~=false then
            neo.rojoinerMessage('Ouverture demandee via '..name..'. Si le navigateur ne s ouvre pas, utilise COPIER LE LIEN.')
            return true
          end
        end
      end
    end
  end
  -- GuiService:OpenBrowserWindow et BrowserService sont reserves au code interne
  -- de Roblox et bloquent les domaines tiers. Ne pas afficher un faux succes.
  local copied=false
  if type(setclipboard)=='function' then
    copied=pcall(setclipboard,url)
  end
  if copied then
    neo.rojoinerMessage('Delta ne fournit pas d ouverture web via script (tests : '..tried..'). Lien RoJoiner copie : colle-le dans ton navigateur.')
  else
    neo.rojoinerMessage('Pas d ouverture web depuis le script. Ouvre https://rojoin-two.vercel.app/ dans ton navigateur.')
  end
  return false
end
function neo.copyRoJoinerLink()
  local url='https://rojoin-two.vercel.app/'
  if type(setclipboard)=='function' and pcall(setclipboard,url) then
    neo.rojoinerMessage('Lien RoJoiner copie. Ouvre ton navigateur et colle-le dans la barre d adresse.')
    return true
  end
  neo.rojoinerMessage('Impossible de copier. Lien : https://rojoin-two.vercel.app/')
  return false
end

-- ===== NEO TRADE MAX | lecture en jeu uniquement, aucune acceptation automatique =====
-- Ce module lit des valeurs JSON et n'execute JAMAIS de code distant.
-- Les prix sont des estimations communautaires en points, pas des Robux.
-- Un chiffre manquant, non-tradable ou ancien est signale au lieu d'etre invente.
neo.trade = {
  values={}, meta={}, aliases={}, source='Supreme Values officiel (capture 09/11/2026)', sourceDate='2026-11-09', verifiedCount=0,
  fetching=false, remoteStatus='Non charge', remoteCount=0, totalRows=0,
  lastMissing='', overrideFile='NEO_MM2_TRADE_CUSTOM.json',
  cacheFile='NEO_MM2_SUPREME_OFFICIEL_CACHE_V2.json',
  remoteURL='https://supremevalues.com/mm2/',
  manualMine=type(retainedOptions.tradeMine)=='string' and retainedOptions.tradeMine or '',
  manualTheirs=type(retainedOptions.tradeTheirs)=='string' and retainedOptions.tradeTheirs or '',
  overrides={}
}
function neo.tradeNormalize(value)
  local s=tostring(value or ''):lower()
  s=s:gsub('’',"'"):gsub('‐','-'):gsub('–','-'):gsub('×','x')
  s=s:gsub("['`´]",''):gsub('[%[%]%(%)%.,:/]',' '):gsub('[-_]+',' ')
  s=s:gsub('%s+',' '):gsub('^%s+',''):gsub('%s+$','')
  local aliases={
    ['scie']='saw',['flamme de bougie']='candleflame',
    ['candle flame']='candleflame',['c saw']='chroma saw',
    ['c cf']='chroma candleflame',['cf']='candleflame',
    ['laser godly']='laser',['saw godly']='saw',
    ['trav gun']='travelers gun',['tg']='travelers gun',
    ['c heat']='chroma heat',['c luger']='chroma luger',
    ['rainbow knife']='rainbow',['flowerwood knife']='flowerwood',
    ['sunset knife']='sunset',['laser vintage']='laser vintage',
    ['chroma travelers gun']='chroma travelers gun',
    ['traveler gun']='travelers gun',['traveler axe']='travelers axe'
  }
  s=s:gsub('^c%s+','chroma ') -- Les chromas Supreme notes C.
  return aliases[s] or s
end

function neo.tradeSeedValues()
  local verified={
    ['saw']=7, ['handsaw']=8, ['candleflame']=33,
    ['chroma saw']=23, ['chroma candleflame']=40,
    ['travelers gun']=5100, ["traveler's gun"]=5100,
    ['evergun']=3450,['evergreen']=2700,['constellation']=2500,
    ['alienbeam']=1900,["vampire's gun"]=1900,['raygun']=1875,['turkey']=1850,
    ['blossom']=1160,['sakura']=1150,['sunrise']=800,
    ['bauble']=675,['snowcannon']=675,['sunset']=650,
    ['rainbow gun']=405,['flora']=400,['rainbow']=400,['bloom']=395,
    ['heart wand']=340,['blizzard']=250,['snowstorm']=250,
    ['ocean']=245,['flowerwood gun']=240,['waves']=240,['flowerwood']=235,
    ['snow dagger']=175,['treat']=155,['sweet']=150,['watergun']=140,
    ['borealis']=135,['immortal']=130,['mortal']=130,['australis']=130,
    ['bat']=125,['pearlshine']=80,['candy']=80,['beachy']=75,
    ['pearl']=75,['sands']=75,['heartblade']=65,['ornament']=65,
    ['phantom']=35,['red luger']=35,['spectre']=35,['luger']=18,
    ['nightblade']=20,['harvester']=250,
    ['darkshot']=1450,['darksword']=1425, ['soul']=580,['spirit']=570,
    ['xenoknife']=400,['xenoshot']=400,['icecream']=135,
    ['darkbringer']=33,['elderwood blade']=33,['elderwood revolver']=33,
    ['iceblaster']=33,['lightbringer']=32,['makeshift']=33,
    ['sugar']=32,['green luger']=23,['amerilaser']=22,['laser']=22,
    ['hallowgun']=20,['shark']=20,['icebeam']=18,['plasmabeam']=18,
    ['swirly gun']=18,['battleaxe ii']=17,['blaster']=17,
    ['ginger luger']=17,['pixel']=17,['gemstone']=15,['iceflake']=15,
    ['old glory']=15,['plasmablade']=15,['slasher']=15,
    ["vampire's edge"]=15,['cookiecane']=13,['deathshard']=13,
    ['eternalcane']=13,['gingerblade']=13,['jinglegun']=13,
    ['lugercane']=13,['minty']=13,['nebula']=13,['virtual']=13,
    ['battleaxe']=12,['gingermint']=12,['swirly blade']=12,
    ['chill']=10,['clockwork']=10,['fang']=10,['frostsaber']=10,
    ['heat']=10,['spider']=10,['tides']=10,
    ['bioblade']=8,['eternal iii']=8,['eternal iv']=8,
    ["hallow's blade"]=8,["hallow's edge"]=8,
    ['boneblade']=7,['eternal']=7,['eternal ii']=7,['frostbite']=7,
    ['ghostblade']=7,['ice dragon']=7,['ice shard']=7,
    ['prismatic']=7,['pumpking']=7,['xmas']=7,
    ['eggblade']=5,['flames']=5,['snowflake']=5,
    ["winter's edge"]=5,['peppermint']=4,['cookieblade']=3,
    ['blue seer']=3,['purple seer']=3,['red seer']=3,
    ['seer']=3,['orange seer']=2,['yellow seer']=2,
    ['emberbow']=525,['emberscythe']=500,['embersickle']=130,
    ['chroma darkbringer']=65,['chroma lightbringer']=60,
    ['chroma luger']=50,['chroma laser']=40,['chroma heat']=28,
    ['chroma shark']=32,['chroma gemstone']=32,['chroma slasher']=32,
    ['chroma fang']=32
  }
  for name,value in pairs(verified) do neo.trade.values[neo.tradeNormalize(name)]=value end
end
neo.tradeSeedValues()

-- Metadonnees minimales pour la base integree. Les nouveaux objets sont charges par JSON.
for key,value in pairs(neo.trade.values) do
  neo.trade.meta[key]={name=key, value=value, source='Ancienne base (non verifiee)', date='inconnue', legacy=true, priced=true}
end
function neo.tradeValidValue(v)
  local n=tonumber(v)
  if n and n==n and n>0 and n<=200000 and n~=math.huge then return n end
  return nil
end
function neo.tradeSetAlias(alias, key)
  local a=neo.tradeNormalize(alias)
  if a~='' and a~=key and neo.trade.values[a]==nil and neo.trade.aliases[a]==nil then
    neo.trade.aliases[a]=key
  end
end
function neo.tradeGetKey(name,isChroma)
  local key=neo.tradeNormalize(name)
  if isChroma and key:sub(1,7)~='chroma ' then key='chroma '..key end
  return neo.trade.aliases[key] or key
end
function neo.tradeCountKnown()
  local n=0
  for _,v in pairs(neo.trade.values) do if neo.tradeValidValue(v) then n=n+1 end end
  return n
end
function neo.tradeIsStale(date)
  local y,m,d=tostring(date or ''):match('^(%d%d%d%d)%-(%d%d)%-(%d%d)$')
  if not y then return true end
  local ok,stamp=pcall(os.time,{year=tonumber(y),month=tonumber(m),day=tonumber(d),hour=12})
  return not ok or not stamp or os.time()-stamp>35*86400
end
function neo.tradeApplyOverrides()
  for name,entry in pairs(neo.trade.overrides) do
    if type(name)=='string' and type(entry)=='table' then
      local value=neo.tradeValidValue(entry.value)
      if value then
        local key=neo.tradeNormalize(name)
        neo.trade.values[key]=value
        neo.trade.meta[key]={name=name,value=value,demand=math.clamp(tonumber(entry.demand) or 0,0,10),
          source='PERSONNALISE (non verifie)',date='2026-11-07',user=true,priced=true}
      end
    end
  end
end
function neo.tradeSaveCustom()
  retainedOptions.tradeMine=neo.trade.manualMine
  retainedOptions.tradeTheirs=neo.trade.manualTheirs
  sharedEnv.NEO_MM2_OPTIONS=retainedOptions
  if type(writefile)~='function' then return false end
  local ok,encoded=pcall(function() return HttpService:JSONEncode({
    overrides=neo.trade.overrides,mine=neo.trade.manualMine,theirs=neo.trade.manualTheirs}) end)
  return ok and pcall(writefile,neo.trade.overrideFile,encoded) or false
end
function neo.tradeLoadCustom()
  local saved=neo.loadProfile(neo.trade.overrideFile)
  if not saved then return end
  if type(saved.mine)=='string' then neo.trade.manualMine=saved.mine end
  if type(saved.theirs)=='string' then neo.trade.manualTheirs=saved.theirs end
  if type(saved.overrides)=='table' then neo.trade.overrides=saved.overrides end
  neo.tradeApplyOverrides()
end
neo.tradeLoadCustom()

-- ===== SUPREME VALUES : catalogue officiel capture le 09/11/2026 =====
-- Source : https://supremevalues.com/mm2/godlies, /ancients, /chromas et changelog.
-- Des prix recents priment sur la vieille base; la vieille base est signalee comme non verifiee.
-- Les valeurs Supreme et MM2Values ne sont jamais additionnees ni moyennées.
-- Si Supreme publie "x3 T1" au lieu d'un prix numerique, ne pas inventer un nombre.
local supremeSnapshot={
  {'Traveler\'s Gun',5000,5,{4900,5000},'Underpaid For'},
  {'Evergun',3450,5,false},
  {'Evergreen',2700,5,false},
  {'Constellation',2500,5,false},
  {'Vampire\'s Gun',1900,5,false},
  {'Alienbeam',1875,5,false},
  {'Turkey',1850,5,false},
  {'Raygun',1850,5,false},
  {'Darkshot',1450,5,false},
  {'Darksword',1425,5,false},
  {'Blossom',1160,5,false},
  {'Sakura',1150,5,false},
  {'Sunrise',800,5,false},
  {'Snowcannon',700,5,false},
  {'Bauble',675,5,false},
  {'Sunset',650,5,false},
  {'Soul',560,5,{550,560},'Underpaid For'},
  {'Spirit',550,5,{540,550},'Underpaid For'},
  {'Rainbow Gun',405,4,false},
  {'Flora',400,4,false},
  {'Rainbow',400,4,false},
  {'Xenoknife',400,4,false},
  {'Xenoshot',400,4,false},
  {'Bloom',395,4,false},
  {'Heart Wand',340,4,false},
  {'Blizzard',250,3,false},
  {'Snowstorm',250,3,false},
  {'Ocean',245,3,false},
  {'Flowerwood Gun',240,3,false},
  {'Waves',240,3,false},
  {'Flowerwood',235,3,false},
  {'Snow Dagger',170,3,false},
  {'Treat',155,3,false},
  {'Sweet',150,3,false},
  {'Embersickle',135,3,{130,145},'Fluctuating'},
  {'Watergun',135,false,false},
  {'Bat',130,false,false},
  {'Borealis',130,false,false},
  {'Icecream',130,false,false},
  {'Australis',125,false,false},
  {'Gingerscope',16000,5,false},
  {'Traveler\'s Axe',7000,5,{6900,7000},'Underpaid For'},
  {'Celestial',1950,5,false},
  {'Vampire\'s Axe',1400,5,false},
  {'Emberbow',650,5,{625,700},'Fluctuating'},
  {'Emberscythe',625,5,{600,675},'Fluctuating'},
  {'Harvester',260,3,false},
  {'Icepiercer',170,3,false},
  {'Chroma Traveler\'s Gun',140000,8,false},
  {'Chroma Evergun',47000,7,false},
  {'Chroma Evergreen',33000,7,false},
  {'Chroma Bauble',29000,7,false},
  {'Chroma Constellation',27000,6,false},
  {'Chroma Vampire\'s Gun',24500,6,false},
  {'Chroma Alienbeam',20000,6,{19000,20000},'Underpaid For'},
  {'Chroma Emberscythe',15000,6,{14000,16000},'Fluctuating'},
  {'Chroma Raygun',12500,5,false},
  {'Chroma Sunrise',8500,5,false},
  {'Chroma Icecream',1800,false,{1750,1800},'Underpaid For'},
  {'Chroma Sands',1100,false,{1050,1100}},
  {'Chroma Beachy',1050,false,{1000,1050}},
  {'Full Chroma Ember Set',22950,false,{21600,24550}},
  {'Chroma Emberscythe Set',21000,false,{19750,22500}},
  {'Full Ember Set',1410,false,{1355,1520}},
  {'Emberscythe Set',1275,false,{1225,1375}},
  {'Embersickle Set',785,false,{755,845}},
  {'Emberknife',3,false,false},
  {'JD',27,false,false},
  {'Red Scratch',3,false,false},
  {'Skulls',3,false,false},
}
function neo.tradeApplySupreme(name,price,demand,range,trend,date,origin)
  local key=neo.tradeNormalize(name)
  if key=='' or key:find('^gold ') or key:find('^silver ') or key:find('^bronze ') then return false end
  if key:find('niks scythe',1,true) or key=='batwing' or key=='black luger' then return false end
  local value=neo.tradeValidValue(price)
  if not value then return false end
  local old=neo.trade.meta[key]
  if old and old.user then return false end
  local d=tonumber(demand)
  if d and (d<1 or d>10) then d=nil end
  local updatedAt=tostring(date or '2026-11-09')
  if old and old.source=='Supreme Values officiel' and updatedAt<tostring(old.date or '') then return false end
  local bounds=nil
  if type(range)=='table' and tonumber(range[1]) and tonumber(range[2]) and tonumber(range[1])<=tonumber(range[2]) then
    bounds={tonumber(range[1]),tonumber(range[2])}
  end
  neo.trade.values[key]=value
  neo.trade.meta[key]={name=name,value=value,supreme=value,demand=d,range=bounds,trend=type(trend)=='string' and trend or nil,
    source='Supreme Values officiel',date=updatedAt,origin=origin or 'capture',priced=true}
  return true
end
for _,line in ipairs(supremeSnapshot) do
  neo.tradeApplySupreme(line[1],line[2],line[3],line[4],line[5],'2026-11-09','capture publique')
end
function neo.tradeVerifiedCount()
  local n=0
  for _,m in pairs(neo.trade.meta) do
    if m.source=='Supreme Values officiel' and not m.user then n=n+1 end
  end
  return n
end
neo.trade.verifiedCount=neo.tradeVerifiedCount()
neo.trade.source='Supreme Values officiel 09/11/2026 ('..neo.trade.verifiedCount..' chiffres verifies) + ancienne base signalee'
neo.trade.remoteStatus='Capture Supreme 09/11/2026 active, prix historiques signales'
neo.tradeApplyOverrides()

-- Cache officiel uniquement : n'accepte pas les anciens fichiers communautaires 09/2026.
local tradeCached=nil
function neo.tradeImportSupremeCache(doc)
  if type(doc)~='table' or doc.provider~='supremevalues.com' or type(doc.items)~='table' then return false end
  local date=tostring(doc.updatedAt or '')
  if not date:match('^%d%d%d%d%-%d%d%-%d%d$') or neo.tradeIsStale(date) then return false end
  local n=0
  for _,item in ipairs(doc.items) do
    if type(item)=='table' and type(item.name)=='string' then
      if neo.tradeApplySupreme(item.name,item.value,item.demand,item.range,item.trend,date,'cache officiel') then n=n+1 end
    end
  end
  if n>0 then
    neo.trade.verifiedCount=neo.tradeVerifiedCount()
    neo.trade.remoteStatus='Cache Supreme du '..date..' ('..n..' valeurs)'
    neo.trade.source='Supreme Values officiel '..date..' + archive signalee'
    neo.trade.sourceDate=date
  end
  neo.tradeApplyOverrides()
  return n>0
end
tradeCached=neo.loadProfile(neo.trade.cacheFile)
if tradeCached then neo.tradeImportSupremeCache(tradeCached) end

-- Supreme a des pages HTML publiques, pas d'API JSON officielle documentee.
-- Lecture de trois tiers principaux (Godly, Chroma, Ancient) avec garde-fous :
-- un echec reseau ou une page changee conserve la capture locale au lieu d'inventer des valeurs.
local supremeTiers={{'godlies',35},{'chromas',16},{'ancients',6}}
local supremeMonth={january=1,february=2,march=3,april=4,may=5,june=6,july=7,august=8,september=9,october=10,november=11,december=12}
function neo.tradePlainHTML(t)
  local s=tostring(t or '')
  s=s:gsub('<script[^>]*>.-</script>',' '):gsub('<style[^>]*>.-</style>',' ')
  s=s:gsub('<[^>]+>',' ')
  s=s:gsub('&amp;','&'):gsub('&#0*39;',"'"):gsub('&apos;',"'"):gsub('&#8217;',"'")
  s=s:gsub('&#x27;',"'"):gsub('&rsquo;',"'"):gsub('&nbsp;',' '):gsub('&quot;','"')
  return s:gsub('%s+',' '):gsub('^%s+',''):gsub('%s+$','')
end
function neo.tradeSupremePageDate(html)
  local plain=neo.tradePlainHTML(html:sub(1,50000))
  local month,day,year=plain:match('Values Last Updated%s*%-%s*(%a+)%s+(%d+)[%a]*,%s*(%d%d%d%d)')
  local m=supremeMonth[tostring(month or ''):lower()]
  if not m then return nil end
  return string.format('%04d-%02d-%02d',tonumber(year),m,tonumber(day))
end
function neo.tradeParseSupremePage(html,slug)
  if type(html)~='string' or #html<5000 or not html:lower():find('supreme values',1,true) then return nil,nil,'HTML non reconnu' end
  local date=neo.tradeSupremePageDate(html)
  if not date then return nil,nil,'Date Supreme introuvable' end
  local chunks={}
  -- Les icones d'items ont un chemin media/mm2<tier>/...; chaque bloc contient la valeur suivante.
  local term='/media/mm2'..slug..'/'
  local from=1
  while true do
    local at=html:find(term,from, true)
    if not at then break end
    local tagEnd=html:find('>',at,true)
    if not tagEnd then break end
    local nextAt=html:find(term,tagEnd+1,true)
    local raw=html:sub(tagEnd+1,nextAt and nextAt-1 or math.min(#html,tagEnd+20000))
    local plain=neo.tradePlainHTML(raw)
    local valueText=plain:match('Value%s*%-%s*([%d,]+)')
    local name=plain:match('^(.-)%s+Class%s*%-%s*[%a ]+%s+Value%s*%-') or plain:match('^(.-)%s+Value%s*%-')
    if name and valueText then
      name=name:gsub('^%s*[%|:]+%s*',''):gsub('%s+Contains%s*%-.*$',''):gsub('^%s+',''):gsub('%s+$','')
      name=name:gsub('^C%.%s*','Chroma ')
      local val=tonumber((valueText:gsub(',','')))
      local d=tonumber(plain:match('Demand%s*%-%s*(%d+)'))
      local lo,hi=plain:match('Range%s*%-%s*%[([%d,]+)%s*%-%s*([%d,]+)%]')
      local range=nil
      if lo and hi then range={tonumber((lo:gsub(',',''))),tonumber((hi:gsub(',','')))} end
      local trend=plain:match('Stability%s*%-%s*(.-)%s+Demand')
      if #name>1 and #name<=65 and val and val>0 and val<=200000 then
        table.insert(chunks,{name=name,value=val,demand=d,range=range,trend=trend})
      end
    end
    from=tagEnd+1
  end
  local filtered,seen={},{}
  for _,it in ipairs(chunks) do
    local k=neo.tradeNormalize(it.name)
    if not seen[k] then seen[k]=true;table.insert(filtered,it) end
  end
  return filtered,date,nil
end
function neo.tradeLoadRemote()
  if neo.trade.fetching then return end
  neo.trade.fetching=true
  neo.trade.remoteStatus='Verification Supreme Values en cours...'
  task.spawn(function()
    local all,successful,failed={},0,{}
    local bestDate=neo.trade.sourceDate
    for _,tier in ipairs(supremeTiers) do
      if not active then break end
      local url=neo.trade.remoteURL..tier[1]
      local ok,html=pcall(function() return game:HttpGet(url,true) end)
      if not ok or type(html)~='string' then
        ok,html=pcall(function() return HttpService:GetAsync(url,true) end)
      end
      local parsed,date,why=nil,nil,'Acces reseau refuse'
      if ok and type(html)=='string' then
        parsed,date,why=neo.tradeParseSupremePage(html,tier[1])
      end
      if parsed and #parsed>=tier[2] and not neo.tradeIsStale(date) then
        successful=successful+1
        if date>bestDate then bestDate=date end
        for _,item in ipairs(parsed) do
          item.date=date
          table.insert(all,item)
        end
      else
        table.insert(failed,tier[1]..' ('..(why or 'page incomplete')..')')
      end
      task.wait(.05)
    end
    local updated=0
    for _,item in ipairs(all) do
      if neo.tradeApplySupreme(item.name,item.value,item.demand,item.range,item.trend,item.date,'site public') then updated=updated+1 end
    end
    neo.tradeApplyOverrides()
    neo.trade.verifiedCount=neo.tradeVerifiedCount()
    if successful>0 then
      neo.trade.sourceDate=bestDate
      neo.trade.source='Supreme Values officiel '..bestDate..' (prix Supreme prioritaires)'
      neo.trade.remoteStatus='Supreme : '..updated..' objets verifies via '..successful..'/'..#supremeTiers..' pages; '..#failed..' page(s) indisponibles'
      if type(writefile)=='function' then
        local ok,serialized=pcall(function() return HttpService:JSONEncode({provider='supremevalues.com',updatedAt=bestDate,items=all}) end)
        if ok then pcall(writefile,neo.trade.cacheFile,serialized) end
      end
    else
      neo.trade.remoteStatus='Supreme en direct inaccessible : capture officielle 09/11/2026 conservee.'
    end
    neo.trade.fetching=false
  end)
end
function neo.tradeValue(name,isChroma)
  local key=neo.tradeGetKey(name,isChroma)
  return neo.trade.values[key],neo.trade.meta[key],key
end
function neo.tradeNewOffer()
  return {total=0,count=0,items={},details={},unknown={},maxUnit=0,maxStack=0,
    lowDemand=0,weakValue=0,oldValue=0,customValue=0,legacyValue=0,unrankedValue=0,largestGap=0}
end
function neo.tradeAddItem(out,name,quantity,isChroma)
  local amount=math.clamp(math.floor(tonumber(quantity) or 1),1,999)
  local price,meta,key=neo.tradeValue(name,isChroma)
  local display=(isChroma and neo.tradeNormalize(name):sub(1,7)~='chroma ' and 'Chroma ' or '')..name
  out.count=out.count+amount
  table.insert(out.items,amount..'x '..display)
  if not price then
    table.insert(out.unknown,display)
    return
  end
  local value=price*amount
  out.total=out.total+value
  out.maxUnit=math.max(out.maxUnit,price)
  out.maxStack=math.max(out.maxStack,amount)
  meta=meta or {}
  local demand=tonumber(meta.demand)
  local trend=tostring(meta.trend or ''):lower()
  if demand and demand<=3 then out.lowDemand=out.lowDemand+value end
  if trend:find('underpaid',1,true) or trend:find('decreas',1,true) or trend:find('drop',1,true) then
    out.weakValue=out.weakValue+value
  end
  if not demand or demand<=0 then out.unrankedValue=out.unrankedValue+value end
  if neo.tradeIsStale(meta.date) then out.oldValue=out.oldValue+value end
  if meta.user then out.customValue=out.customValue+value end
  if meta.legacy then out.legacyValue=(out.legacyValue or 0)+value end
  if meta.supreme and meta.mm2 then
    local gap=math.abs(meta.supreme-meta.mm2)/math.max(meta.supreme,meta.mm2)
    out.largestGap=math.max(out.largestGap,gap)
  end
  table.insert(out.details,{name=display,key=key,quantity=amount,value=price,demand=demand,trend=meta.trend,source=meta.source})
end
function neo.tradeReadOffer(offerFrame)
  local out=neo.tradeNewOffer()
  local list=offerFrame and offerFrame:FindFirstChild('Container')
  if not list then return out end
  -- Les fenetres MM2 ont le plus souvent quatre slots; les variantes peuvent en avoir davantage.
  for i=1,12 do
    local slot=list:FindFirstChild('NewItem'..i)
    if slot and slot:IsA('GuiObject') and slot.Visible then
      local nameNode=slot:FindFirstChild('ItemName',true)
      local nameLabel=nameNode and (nameNode:FindFirstChild('Label') or nameNode)
      local name=nameLabel and nameLabel:IsA('TextLabel') and nameLabel.Text or ''
      if name~='' and name~='ItemName' then
        local tagNode=slot:FindFirstChild('Tags',true)
        local chroma=tagNode and tagNode:FindFirstChild('Chroma',true)
        local isChroma=(chroma and chroma:IsA('GuiObject') and chroma.Visible) or false
        local amountNode=slot:FindFirstChild('Amount',true)
        local rawAmount=amountNode and amountNode:IsA('TextLabel') and amountNode.Text or ''
        local quantity=tonumber(tostring(rawAmount):match('(%d+)')) or 1
        neo.tradeAddItem(out,name,quantity,isChroma)
      end
    end
  end
  return out
end
function neo.tradeReadManual(raw)
  local out=neo.tradeNewOffer()
  for entry in tostring(raw or ''):gmatch('[^,;\n]+') do
    local s=entry:gsub('^%s+',''):gsub('%s+$','')
    if s~='' then
      local quantity,name=s:match('^(%d+)%s*[xX]%s*(.+)$')
      if not name then name,quantity=s:match('^(.-)%s*[xX]%s*(%d+)$') end
      name=(name or s):gsub('^%s+',''):gsub('%s+$','')
      neo.tradeAddItem(out,name,quantity,false)
    end
  end
  return out
end
function neo.tradeLiquidityWarning(mine,theirs)
  if mine.total<=0 or theirs.total<=0 then return '',false end
  local premium=mine.maxUnit or 0
  local receivedTop=theirs.maxUnit or 0
  local fragmented=theirs.count>=mine.count+2 and receivedTop>0 and premium>=receivedTop*1.6
  local stack=(theirs.maxStack or 0)>=4 and premium>=receivedTop*1.3
  local gain=(theirs.total/mine.total-1)*100
  local lowShare=theirs.lowDemand/math.max(1,theirs.total)
  if fragmented or stack then
    if gain<=15 then
      return 'DECONSEILLE : gros downgrade en petites armes pour '..string.format('%+.0f',gain)..'%. Difficile a reechanger.',true
    elseif gain<=30 then
      return 'PRUDENCE : '..string.format('%+.0f',gain)..'% de valeur, mais gros lot difficile a ecouler.',true
    end
    return 'PRUDENCE : gros lot de petites armes. Controle la demande de chaque objet.',true
  end
  if lowShare>=.45 then
    return 'DECONSEILLE : '..string.format('%.0f',lowShare*100)..'% de la valeur recue a une faible demande (1-3/10).',true
  end
  if theirs.weakValue>=theirs.total*.4 then
    return 'PRUDENCE : plusieurs armes sont marquees sous-payees ou en baisse.',true
  end
  if theirs.largestGap>.25 or mine.largestGap>.25 then
    return 'PRUDENCE : MM2Values et Supreme different de plus de 25% sur une arme.',true
  end
  if theirs.unrankedValue>theirs.total*.7 then
    return 'DEMANDE INCONNUE : compare la popularite avant de valider.',true
  end
  return 'Valeur estimee : la liquidite reelle depend du marche.',false
end
function neo.tradeEvaluate(mine,theirs)
  if mine.count==0 and theirs.count==0 then
    return 'EN ATTENTE','Ajoute des objets des deux cotes.',UI.dim,'',false
  end
  local missing={}
  for _,x in ipairs(mine.unknown) do table.insert(missing,x) end
  for _,x in ipairs(theirs.unknown) do table.insert(missing,x) end
  if #missing>0 then
    neo.trade.lastMissing=table.concat(missing,', ')
    return 'INCOMPLET','Objet(s) sans prix : '..neo.trade.lastMissing:sub(1,120),UI.dim,
      'STOP : impossible de juger ce trade tant que des objets sont inconnus.',true
  end
  if mine.count==0 or theirs.count==0 then
    return 'OFFRE INCOMPLETE','Un des deux cotes est vide.',UI.dim,'',false
  end
  local diff=theirs.total-mine.total
  local pct=diff/math.max(1,mine.total)*100
  local limit=math.max(1,math.max(mine.total,theirs.total)*.05)
  local caution,risky=neo.tradeLiquidityWarning(mine,theirs)
  local badDates=(mine.oldValue+theirs.oldValue)>0
  local custom=(mine.customValue+theirs.customValue)>0
  local legacy=(mine.legacyValue+theirs.legacyValue)>0
  if legacy then
    caution=caution..' VALEUR HISTORIQUE NON VERIFIEE : compare sur Supreme avant echange.'
    risky=true
  end
  if badDates then
    caution=caution..' ATTENTION : certaines valeurs ont plus de 35 jours.'
    risky=true
  end
  if custom then
    caution=caution..' Au moins une valeur est personnalisee et non verifiee.'
    risky=true
  end
  -- Ne jamais annoncer un WIN/FAIR si le trade melange Supreme avec des estimations non confirmees.
  if legacy or badDates or custom then
    return 'A VERIFIER', 'Totaux provisoires : certaines valeurs ne sont pas confirmees par Supreme.',hue.red,
      caution..' Ne valide pas cet echange sur ces seuls chiffres.',true
  end
  local title,explanation,color
  if math.abs(diff)<=limit then
    title='FAIR';explanation='Ecart '..string.format('%+.1f%%',pct)..' ('..string.format('%+.2f',diff)..')';color=hue.blue
  elseif diff>0 then
    title='WIN';explanation='Gain estime '..string.format('%+.1f%%',pct)..' ('..string.format('+%.2f',diff)..')';color=hue.green
  else
    title='LOSE';explanation='Perte estimee '..string.format('%.1f%%',pct)..' ('..string.format('%.2f',-diff)..')';color=hue.red
  end
  if risky and title~='LOSE' then title=title..' RISQUE' end
  return title,explanation,color,caution,risky
end
function neo.tradeFindScreen()
  for _,guiName in ipairs({'TradeGUI_Phone','TradeGUI'}) do
    local g=PG:FindFirstChild(guiName)
    if g and g:IsA('ScreenGui') and g.Enabled then
      local container=g:FindFirstChild('Container')
      local tr=container and container:FindFirstChild('Trade')
      if container and tr and container:IsA('GuiObject') and container.Visible
         and tr:IsA('GuiObject') and tr.Visible then
        return tr
      end
    end
  end
  return nil
end
neo.trade.banner=make('Frame',{
  Name='NEO_Trade_WFL',Size=UDim2.fromOffset(345,127),
  AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,56),
  BackgroundColor3=UI.side,Visible=false,ZIndex=85,BorderSizePixel=0
},gui)
corner(neo.trade.banner,12);stroke(neo.trade.banner,hue.primary,2,.16)
neo.trade.bannerTitle=text(neo.trade.banner,'⚖  ÉCHANGE : EN ATTENTE',16,UI.white)
neo.trade.bannerTitle.Size=UDim2.new(1,-18,0,28)
neo.trade.bannerTitle.Position=UDim2.fromOffset(9,3)
neo.trade.bannerTitle.Font=Enum.Font.GothamBold
neo.trade.bannerTitle.ZIndex=86
neo.trade.bannerInfo=text(neo.trade.banner,'MOI : ?   •   LUI : ?',12,UI.white)
neo.trade.bannerInfo.Size=UDim2.new(1,-18,0,23)
neo.trade.bannerInfo.Position=UDim2.fromOffset(9,29)
neo.trade.bannerInfo.ZIndex=86
neo.trade.bannerFoot=text(neo.trade.banner,'Valeurs communautaires, jamais de validation automatique',11,UI.dim)
neo.trade.bannerFoot.Size=UDim2.new(1,-18,0,70)
neo.trade.bannerFoot.Position=UDim2.fromOffset(9,51)
neo.trade.bannerFoot.TextWrapped=true
neo.trade.bannerFoot.ZIndex=86
function neo.tradeRefreshOverlay()
  if not state.tradeHUD then neo.trade.banner.Visible=false;return end
  local tr=neo.tradeFindScreen()
  if not tr then neo.trade.banner.Visible=false;return end
  local own=neo.tradeReadOffer(tr:FindFirstChild('YourOffer'))
  local other=neo.tradeReadOffer(tr:FindFirstChild('TheirOffer'))
  local verdict,explanation,color,advice,risky=neo.tradeEvaluate(own,other)
  neo.trade.banner.Visible=true
  neo.trade.bannerTitle.Text='⚖  '..verdict
  neo.trade.bannerTitle.TextColor3=risky and hue.red or color
  neo.trade.bannerInfo.Text='MOI : '..string.format('%.2f',own.total)..'   •   LUI : '..string.format('%.2f',other.total)
  neo.trade.bannerFoot.Text=(verdict=='INCOMPLET' and explanation or (explanation..'\n'..advice))
end
function neo.tradeMakeTextBox(initial,placeholder)
  local tb=make('TextBox',{
    Size=UDim2.new(1,-8,0,52),Text=initial or '',
    PlaceholderText=placeholder,ClearTextOnFocus=false,
    TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,
    Font=Enum.Font.GothamMedium,TextColor3=UI.white,TextSize=13,
    TextWrapped=true,MultiLine=true,BackgroundColor3=UI.item,BorderSizePixel=0
  },content)
  corner(tb,9)
  contentOrder=contentOrder+1;tb.LayoutOrder=contentOrder
  make('UIPadding',{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12)},tb)
  return tb
end
function neo.tradeDescribeItem(name)
  local value,meta=neo.tradeValue(name)
  if not value then return 'INCONNU : '..name..' | Ne pas inventer de valeur.' end
  local lines={name..' : '..string.format('%.2f',value)..' points',
    'Source : '..tostring(meta.source or 'non specifiee')..' | Date : '..tostring(meta.date or '?')}
  if meta.demand then table.insert(lines,'Demande : '..tostring(meta.demand)..'/10')
  else table.insert(lines,'Demande : inconnue') end
  if meta.trend then table.insert(lines,'Tendance : '..meta.trend) end
  if meta.range and tonumber(meta.range[1]) and tonumber(meta.range[2]) then
    table.insert(lines,'Fourchette : '..meta.range[1]..' a '..meta.range[2])
  end
  if meta.supreme and meta.mm2 then
    table.insert(lines,'Supreme : '..meta.supreme..' | MM2Values : '..meta.mm2)
  end
  if neo.tradeIsStale(meta.date) then table.insert(lines,'ATTENTION : donnee ancienne') end
  return table.concat(lines,'\n')
end
function neo.tradeRenderTab()
  section('⚖  TRADE CHECKER MAX  •  WIN / FAIR / LOSE')
  note('Analyse auto de la fenetre d echange, chromas, doublons, quantites, gros lots et demande. Jamais d acceptation automatique.')
  toggle('tradeHUD','Afficher le verdict sur la fenetre de trade')
  note('Catalogue : '..neo.tradeCountKnown()..' valeurs en memoire, dont '..neo.trade.verifiedCount..' confirmees Supreme. '..neo.trade.remoteStatus)
  note('Prix prioritaires : Supreme Values officiel (09/11/2026). MM2Values sert uniquement de comparaison exterieure : aucun melange de barèmes. Les prix de l ancienne base sont marques NON VERIFIES.')
  button('RECHARGER LES PRIX DE SUPREME VALUES',function()
    neo.tradeLoadRemote()
    status('Verification Supreme en direct lancee. Si le site bloque Roblox, capture locale conservee.')
  end,hue.primary)
  button('DIAGNOSTIC FENETRE DE TRADE',function()
    local tr=neo.tradeFindScreen()
    if not tr then status('Aucun TradeGUI ou TradeGUI_Phone actif. Utilise le calcul manuel.')
    else
      local mine=neo.tradeReadOffer(tr:FindFirstChild('YourOffer'))
      local theirs=neo.tradeReadOffer(tr:FindFirstChild('TheirOffer'))
      local verdict,why=neo.tradeEvaluate(mine,theirs)
      status(verdict..' : '..#mine.items..' pour moi / '..#theirs.items..' pour lui | '..why)
    end
  end)
  button('COPIER LE LIEN SUPREME VALUES',function()
    local url='https://supremevalues.com/mm2/calculator'
    if type(setclipboard)=='function' and pcall(setclipboard,url) then
      status('Lien Supreme Values copie. Ouvre-le dans ton navigateur pour comparer.')
    else status('Ouvre '..url..' dans ton navigateur.') end
  end,hue.primary)
  button('COPIER LE LIEN MM2VALUES (COMPARAISON)',function()
    local url='https://www.mm2values.com/'
    if type(setclipboard)=='function' and pcall(setclipboard,url) then
      status('Lien MM2Values copie pour comparaison independante.')
    else status('Ouvre '..url..' dans ton navigateur.') end
  end)
  section('CALCUL MANUEL')
  note('Noms anglais separes par des virgules, ex. "2x Saw, Chroma Heat".')
  note('CE QUE JE DONNE :')
  local giveBox=neo.tradeMakeTextBox(neo.trade.manualMine,'Ex. Candleflame, 2x Saw')
  note('CE QUE JE REÇOIS :')
  local getBox=neo.tradeMakeTextBox(neo.trade.manualTheirs,'Ex. 4x Saw, Heat')
  local readout=note('Appuie sur CALCULER MON ECHANGE.')
  button('CALCULER MON ECHANGE',function()
    neo.trade.manualMine=giveBox.Text
    neo.trade.manualTheirs=getBox.Text
    neo.tradeSaveCustom()
    local mine=neo.tradeReadManual(giveBox.Text)
    local theirs=neo.tradeReadManual(getBox.Text)
    local verdict,why,_,advice=neo.tradeEvaluate(mine,theirs)
    readout.Text=verdict..' | MOI '..string.format('%.2f',mine.total)
      ..' / LUI '..string.format('%.2f',theirs.total)..'\n'..why..'\n'..advice
    readout.Size=UDim2.new(1,-8,0,125)
  end,hue.primary)
  section('RECHERCHER UNE ARME')
  local findBox=neo.tradeMakeTextBox('','Ex. Chroma Raygun, Saw, Gingerscope')
  local lookup=note('Tape le nom exact, y compris Chroma ou annee si necessaire.')
  button('VOIR SA VALEUR + DEMANDE + DATE',function()
    lookup.Text=neo.tradeDescribeItem(findBox.Text)
    lookup.Size=UDim2.new(1,-8,0,135)
  end,hue.primary)
  section('VALEUR PERSONNALISEE  •  OBJET MANQUANT')
  note('Uniquement si tu as verifie une valeur toi-meme. Le hub l indique comme NON VERIFIEE dans les trades.')
  local customName=neo.tradeMakeTextBox('','Nom exact de l arme')
  local customValue=neo.tradeMakeTextBox('','Valeur en points, ex. 25.5')
  local customDemand=neo.tradeMakeTextBox('','Demande /10 (facultatif)')
  button('ENREGISTRER CETTE VALEUR',function()
    local name=neo.tradeNormalize(customName.Text)
    local value=neo.tradeValidValue(customValue.Text)
    if name=='' or not value then status('Nom ou valeur invalide. Valeur attendue entre 0 et 200000.') return end
    neo.trade.overrides[name]={value=value,demand=math.clamp(tonumber(customDemand.Text) or 0,0,10)}
    neo.tradeApplyOverrides()
    local saved=neo.tradeSaveCustom()
    status('Valeur perso pour '..name..' ('..value..'). '..(saved and 'Sauvegardee.' or 'En memoire seulement.'))
  end)
  button('EFFACER UNE VALEUR PERSONNALISEE',function()
    local key=neo.tradeNormalize(customName.Text)
    if not neo.trade.overrides[key] then status('Aucune valeur perso pour '..key) return end
    neo.trade.overrides[key]=nil
    neo.tradeSaveCustom()
    status('Valeur perso supprimee. Relance le script pour restaurer la valeur de la base.')
  end)
  note('Attention : les sets, les variantes event et les recompenses de classement ne sont pas automatiquement interchangeables. Prix = estimation, pas promesse de vente.')
end
neo.tradeLoadRemote()
task.spawn(function()
  while active and gui.Parent do
    pcall(neo.tradeRefreshOverlay)
    task.wait(.5)
  end
end)

-- ===== NEO V6.1 : EMOTES MEGA CATALOG (catalogue pagine, sans inventer des ID) =====
-- Les donnees sont du JSON public de Roblox. AUCUN code distant n'est execute.
neo.emotes = {
  items={}, byId={}, favorites={}, cursor=nil, exhausted=false,
  busy=false, cancelScan=false, query='', view='all', offset=0,
  pageSize=24, speed=1, loop=true, track=nil, animation=nil,
  label=nil, searchCursor=nil, searchQuery=nil, scanToken=0,
  source='Roblox Marketplace', error=nil, fetchedPages=0, playToken=0
}
local em = neo.emotes
local emoteFile='NEO_MM2_EMOTES_CATALOG.json'
local emoteSavedAt=0
-- AFEM/YARHM (exemples historiques) publiait des ID d animation distincts.
-- Les autres fiches du catalogue sont RESOLUES a la demande : pas de faux ID.
local emotePresets={
  {'Point2',3576823880}, {'Shrug',3576968026}, {'Hello',3576686446},
  {'BabyQueen - BouncyTwirl',14353423348,14352343065},
  {'BabyQueen - FaceFrame',14353421343,14352340648},
  {'Mae Stephens - PianoHands',16553249658,16553163212},
}

-- 1 000 fiches EmoteAnimation (assetType 61) du catalogue Roblox, relevees le 10/11/2026.
local emoteCatalog1000={
  {"Salute",3360689775},
  {"Applaud",5915779043},
  {"Tilt",3360692915},
  {"Jamal Brazil Groove",104131847054135},
  {"Endless Aura Floating",106708015414624},
  {"Godly Aura fly pose idle",76361248833307},
  {"Jeyke Funk Setalcix",81420534734372},
  {"Wall Phase (GLITCH)",79017619155911},
  {"Psycho Teddy ",95325218641213},
  {"WISH NLE",125783279336153},
  {"🔥 I got that feeling 🔥 ",96908245529644},
  {"Scuba Nick Wilde",70919402339484},
  {"Invisible",110348711077449},
  {"neck roller",125277274509344},
  {"💀MM2 Fake Dead",132384701706046},
  {"ReDreaming Angel - Angels of Delusion Dance ZZZ",87891628617367},
  {"Zombie Run",138431313591911},
  {"Popular",71302743123422},
  {"⚡ Raiden Punching Armstrong Loop",115203580644128},
  {"🤣 GOOFY FLAP FLY ANIME - FUNNY MEME",120904242187887},
  {"[BEST] Wyw My Sweetie",111787956256504},
  {"Cute Sit",72947568152049},
  {"I got that feeling",91671584660717},
  {"Tomato Dance",125871567269726},
  {"🕷️ Hornet's Spider Dance 🕷️",74716792202343},
  {"[BEST] It's Gangnam Style!",104142334418357},
  {"🍰Cheer You Up",121499003751453},
  {"Dropkick",127764273000599},
  {"Moonwalk",111378664166805},
  {"Rat Dance",98603994713783},
  {"Crazy Spin 💀",129980712071176},
  {"Sayo Lang Dance",90060828560018},
  {"cute dancy dance",83917238288783},
  {"Pop - ILLIT",107822111841444},
  {"FLAPPY BIRDY FLY",94735585000460},
  {"Jamal Brazil Groove",76975360527314},
  {"Michael Myers Bounce",120728157712439},
  {"★ curiously cute sitting pose",76261461321661},
  {"Wall Aura Farm Pose",118853736905967},
  {"Happy Cat",97712836759707},
  {"KATSEYE - GNARLY",133685484220846},
  {"🇧🇷Professora Six Seven (🇧🇷TT Dance Brasileño)",121067193470437},
  {"Nervy Dance",125328720114284},
  {"Thanos Shuffle",71789532855285},
  {"Money Hop Switch",134222090358172},
  {"💕 Hug",109942383036823},
  {"Effortless Aura Pose",101573394483995},
  {"[BEST] Party Rock Anthem",98918840942712},
  {"ʚ ︵  adorable princess sitting pose",75300958972158},
  {"Cute Feet Kicking",78224683906191},
  {"Tyranno",82026568595380},
  {"w zesty sturdy",104278650550369},
  {"Party Rock Anthem",105248382902194},
  {"/e fly",93511411593120},
  {"Chinese Dance: Da Koto Nai [BEST]",104539498095025},
  {"inchworm",95339769038863},
  {"Jamal Brazil Groove",117119421748582},
  {"/headless /koblox .... kind of",110170230382247},
  {"Godly Aura floating Pose ",102392888934746},
  {"Yuji Jumping Edit",113702736944973},
  {"Passinho do Jamal [BEST] [OG]",137057022541237},
  {"Take The L Emote",124573621747512},
  {"i got that feeling",123807848932065},
  {"Lord Verity (Master of Humanity) R6 ORIGINAL",140634477320440},
  {"Cute Angry Idle 😡 [Dynamic Head]",136895816311970},
  {"Dougie",93675237485386},
  {"Child's Tantrum",104628550103800},
  {"Godly Aura Pose",110276251507187},
  {"🍒Hootie Frutti - KATSEYE",76415854699298},
  {"Iuno Moon Goddess Intro Idle | Wuthering WuWa",117373445253902},
  {"La Salsa Dance",91442631640229},
  {"Jellyous - ILLIT",101770179011834},
  {"Zero Two Dance V2",95385842020103},
  {"Needy Dance👑",76935708594706},
  {"Take The L 🤡",125942108528501},
  {"💀MM2 Fake Dead",133176230287726},
  {"Spongebob",131904940537599},
  {"SPIDERMAN HANG",126963611296305},
  {"I WANNA RUN AWAY",126497397360168},
  {"One-legged Snare Trap",108644020480886},
  {"Flying Floating Aura Emote",112910347435348},
  {"Hype dance ღ",81224179573920},
  {"🐰bam bam bunny dance ",77947790294458},
  {"Da Hood Stomp",92237689732858},
  {"MJ - P.Y.T. Pretty Young Thing",137234266130963},
  {"Worm Floating Endless",125154823571632},
  {"🔥 FAST HANDSTAND PUSH UP ⚡ FUNNY MEME",114319678441531},
  {"Diva Aura",118846519181951},
  {"[🎃Halloween] Headless Floating Aura 2",87952355078673},
  {"Feeling Cute",112540347880956},
  {"Raiden Fighting Armstrong [OG]",91875205749975},
  {"hip sway",80963950541052},
  {"Balenci dance",121270506481434},
  {"[OG] Pick it up, Make it jump",128690499903398},
  {"You The Boss",95857144973775},
  {"🎃Pumpkin King👑",105381637724646},
  {"Cat Nap",105016815489641},
  {"Confident Needy Hip Shake Dance",85115037529002},
  {"🕷️ Spiderman Hanging",82370885440550},
  {"Ghost Floating",75911227509248},
  {"[TREND] Scuba Diving  🌊",122910663197285},
  {"Billy Bounce",93450937830334},
  {"Silly Explosion",122647715259406},
  {"Fairy sit floating anime girl pose",132152702263080},
  {"💕 Hug",125491951751014},
  {"Richard's Dance",71032247715580},
  {"Charming Cute Look Pose",101275066718933},
  {"Sass Drop",123256605275082},
  {"FF Push Up",73630423562709},
  {"Jason Vorhess Emote",81482996473944},
  {"Take The L 💀",110977837649961},
  {"Brazilian Dance Viral Trend",76636280785091},
  {"Emperor Of The Auraverse [[Aura]]",133594786690861},
  {"🎀 Princess Hip Sway Dance",105626165333309},
  {"sharp's Wassup Wiggle",104202708033647},
  {"IShowSpeed Bounce",83215289068456},
  {"Spice Queen of Da Place",126468010841883},
  {"Sad",4849502101},
  {"BAD - Ateez dance",111003986858991},
  {"I Want Money",89114994401113},
  {"Mii Height Swing Setalcix",95276923919374},
  {"Jumpstyle dance",133248139921782},
  {"Agnes Tachyon's Low Cortisol Dance (In Tempo) V1",112396548575695},
  {"Floating",139058906415119},
  {"MM2 Fake Dead",140636507795509},
  {"i got that feeling",119424074146366},
  {"Courtly bow",72613272882226},
  {"Worm Movement",80103516469956},
  {"Gurl When You Setalcix",115617253264416},
  {"♡ : cute just the way you are sway dance",131135832351175},
  {"KATSEYE - TOUCH",73240117461226},
  {"Floating in Love 🥰",97164262994588},
  {"i got that feeling ",117877051978251},
  {"Tornado",82995540773684},
  {"Caramelldansen",130815097772428},
  {"Cute Sit",101619002123242},
  {"❤️ Catch Catch ",122758585008323},
  {"/e invisible",109068467388495},
  {"⏰ Tiki Tiki Dance",76265325940510},
  {"Not My Problem Dance",90459307830074},
  {"Sturdy R6",92335786854446},
  {"Gangnam style",80923445784018},
  {"Random Moves",107591912237291},
  {"Hand to hand combat fighting",117694377985131},
  {"Dump It ",95212194956469},
  {"Kangaroo Dance",82187133586641},
  {"Belly Dance",83005132233615},
  {"🔥I came to GROOVE🔥[A peanut butter house] 4'10",85913265750993},
  {"NON MI INNAMORERO DANCE - Ody",112262217276868},
  {"Toc toc midas dance",128500252702848},
  {"kawaii whimsy airplane profile pose ʚ♡ɞ",122803615354190},
  {" Sad Depressed Crying Sit / Sitting",95339652051393},
  {";invisible me",94292601332790},
  {"Take the L",122624487269599},
  {"♡.  ‿  crawling like a cutesy cat ~",118133473903220},
  {"Michael Jackson",140440735589603},
  {"MASSIVE POOP",83417429144154},
  {"POP DAT THANG",113910843410865},
  {"Pangya Dance🎀",89439360145889},
  {"intrusive awkward wave",85665834724929},
  {"Gojo Floating JJK/ The Honored One",91085159191582},
  {"sombr \"12 to 12\"",101123703629035},
  {"♡ : cute doll sitting pose ",139365392340832},
  {"Jabba Switchway",104940682593173},
  {"Push ups [FAST]",89995257414409},
  {"Cute Kawaii Posing >-<",94064805002669},
  {"You’re Under Arrest - ILLIT (Part 1 Chorus)",96840108562842},
  {"DARE - Gorillaz",136648387080677},
  {"MM2 WALL HACK💀",114537898785444},
  {"how did he hit every beat",134311528115559},
  {"Harley Dance",119258520125004},
  {"ILYF Dance",100879717367092},
  {"[ OG ] BADDIE BOUNCE",116938844814178},
  {"Stylish Floating",88425531063616},
  {"Uh-Oh",123709994654098},
  {"Fake Lag/Disconnect (TROLL)",97523498583729},
  {"🚀 [NEW BEST!] Sit Squat With Style",125577773550133},
  {"Shuffling",115925652377890},
  {"cute sitting with legs out",139076155588413},
  {"♡ : cute sitting idle pose",139828710607670},
  {"My father doesn't pay for my college",90357288391189},
  {"Adorable puppy paws sitting emote ♡",104048167420139},
  {"Yokoyure Step",98233060516583},
  {"Psycho Teddy [OLD]",70810364578663},
  {"Cute kawaii girly idle Profile pose",138515241510970},
  {"۶ৎ doll cutely sitting pose",125243870523332},
  {"Cute Cat Purr [Blair Soul Eater] ",89792686783781},
  {"Baltimore Stomp",73960397485155},
  {"Griddy (BEST)",77017926307035},
  {"Orange Justice",110064349530772},
  {"Little jumping spider",113184956127341},
  {"Brazilian Funk Steps",110099433569655},
  {"✅ Wall Aura Farm Pose",131842573906551},
  {"shake shake da hood dance",128485664532881},
  {"Toc Toc Midas Dance",78563142672686},
  {"Godly Aura Pose",134388005886833},
  {"Dance All Night",97139559228653},
  {"Carti’s Idle pose",133999049708968},
  {"Relax Nonchalant Sit",93040803014581},
  {"Die Lit",121001502815813},
  {"TWICE - What Is Love",91811386043367},
  {"im a demon with this .... [NLE CHOPPA]",71046008175446},
  {"Angry Rage Emote",115344615095212},
  {"🤣 ZEN FLOAT AURA 🔥 FUNNY MEME",109984109215460},
  {"Bubbly Sit",112758073578333},
  {"One Hand Push Ups 💪 ",121644855433565},
  {"Attitude Moves Bounce",132514953046792},
  {"💀 MM2",98654266031450},
  {"Hakari Dance",122147154162464},
  {"🧸Cute Sit 🧸",75263622149373},
  {"Zany Zany dance",98613324013172},
  {"Michael Jackson - Intro Dance",104267675723424},
  {"🕷️ Realy strange Hornet's Spider",114530046828576},
  {"Popstar Moves",87757463565936},
  {"Baby Queen - Bouncy Twirl",14353423348},
  {"Peter Griffin's Death Pose",99005087791705},
  {"♡ cute kawaii hip sway bounce dance",121333705566922},
  {"Backrooms Entity",132849734668819},
  {"୨୧ Sweetest Angel Sit Pose  ",129766891082557},
  {"💕 Hug [Player 1]",102303622774230},
  {"Floating",70615023659736},
  {"Basketball Head",107282826166809},
  {"Hello",3576686446},
  {"Sturdy Dance - Ice Spice [CHEAP]",72333659132786},
  {"🔥Aura Farming Pose Sukuna🔥",99719050691709},
  {"Spice Keep Bouncing",121347449465835},
  {"THROW DAT",115863907078809},
  {"Dali Bounce",82266702067841},
  {"Possessed Soul Scary Floating Horror Possession",106915247531735},
  {"Shrug",3576968026},
  {"Godly Aura Fly Idle Pose",114244857354338},
  {"Helicopter",140547238892659},
  {"Russian Dance",74608751145756},
  {"RICHMAN MEME",110291826434646},
  {"Catwalk Walk",120380776076922},
  {"The Bass Trend",101680191891360},
  {"TrackMaker Dance",75541759268466},
  {"My Life Is A Party",128406725959484},
  {"Sukuna Aura Farming",92116889798388},
  {"Spice Jersey Bounce",126529053628312},
  {"Crying Sit With Legs Out",73828975501908},
  {"Point2",3576823880},
  {"Moon Walk",79127989560307},
  {"Possessed Glitcher",106370760824973},
  {"Nyan Nyan! ",73796726960568},
  {"Stadium",3360686498},
  {"Dance If You're The Best Dia Delicia Dance",78271776483517},
  {"Saudi Dance",94929429545220},
  {"Cute Needy Peaceful Bounce",124917631392507},
  {"SHAKE",132367660388476},
  {"♡ cute bossy sassy girl idle pose",137909901344953},
  {"Hey Ya Move",104338766814874},
  {"Tsundere dance!! ˶>`‸´<˶",99050862206602},
  {"Viltrumite Thragg Aura Pose",92750012853299},
  {"Relax Flying Anime (Floating Emote)",131950236025472},
  {"OOH WEE DANCE [OG]",109207316400685},
  {"L Lawliet",139435106875573},
  {"Louisiana Jigg",75625820126017},
  {"Rat Dance",132679422049257},
  {"Cute Pretty Girly Girl Fierce Slay Idle Pose",135853357333509},
  {"Dorobo Dance V2",89329919584939},
  {"Brazilian Funk Footwork",88693910954718},
  {"Sturdy NYC Dance ",122687759897103},
  {"feelin myself sway",74941409284905},
  {"Tall Scary Monster 😈",73943779926827},
  {"♡ cute shy withdrawn sit",81204065393762},
  {"♡ Cute kiss emote ",126439741324957},
  {"Tall Scary Creature",79216795769647},
  {"Gojo Floating Aura Farming",107572993172129},
  {"RiRiRi Happy Halloween ",98464793617142},
  {"Rose for You 🌹",99167211339375},
  {"Michael Jackson Moonwalk",90850139979211},
  {"TV Time Dance",75017857395637},
  {"I can FLY!! 🐦",90844099582284},
  {"Neck Roll",93641632427451},
  {"sitting squat idle pose ",113960239878969},
  {"[R6] Otsukare Summer",82461557511288},
  {"Pennywise Dance (R6)",127987224673745},
  {"Cyrene Fairy Swing Intro Idle | Honkai HSR",130027779038512},
  {"Dembow - De Lado",111531137576108},
  {"griddy",129149402922241},
  {"Ela Peida Dance",72090551157791},
  {"Take The L ✅",128881942124489},
  {"Shuba Duck Dance",109600145307918},
  {"Baddies Pic",81773345255689},
  {"⚽ Football Control King 👑",100570268344827},
  {"Rampage Dance 🔥",92849748107049},
  {"Summer Flow",94992117850165},
  {"Late Night Shuffle",86842025829758},
  {"[ OG ♡ ] love & joy - kawaii cute dance REUPLOAD",106751283790182},
  {"Just Your Doll ",78724951673945},
  {"Cute Pose Idle",78019059591476},
  {"Wall Lean Aura Farm Pose",92480837999507},
  {"♡: Kawaii Bouncy Anime Girl Dance [OG]",130855166586798},
  {"🤍 cute n timid idle profile pose",110252467018810},
  {"[OG] BOUNCE IT",130723721063508},
  {"Zombie Run",131700009147561},
  {"low cortisol pookie bear",126680028271116},
  {"SUIIIIII",72049728640815},
  {"Default Dance | OG",80877772569772},
  {"Smooth Bounce",107771803442802},
  {"Jojo Torture Dance",82910305160190},
  {"(Original) Gangnam Style",116468071022853},
  {"[NEW] Runway Diva! ",110724441263151},
  {"Street Glide",137284968787523},
  {"Ninja Run",134432120061902},
  {"Cozy Hug Pose V1 [MATCHING]",133508585947629},
  {"Zero Two Dance V3",124963840388798},
  {"Coffin Walkout",117302755748327},
  {"Wally Speedster Run",133948663586698},
  {"[FNF]Psycho Teddy",136747948306228},
  {"Yungblud Happier Jump",15610015346},
  {"Race Car",121936817462716},
  {"Ralsei - Flying Run (BUNDLE)",126059086084576},
  {"[OG] YOUNG BADDIE SWAY",95525444517677},
  {"I WANNA RUN AWAY",135431679610889},
  {"Usagi Dance",84585789712033},
  {"Scene Profile Idle Pose Y2K ",125386993330077},
  {"LAYO Dance",121777224102467},
  {"Kissy Roblox Profile Pose",73398162799786},
  {"Sit Floating Aura Emote",116090470406589},
  {"Spice Watch Me",103716525479556},
  {"Chief Keef Profile Emote 1",88056891350165},
  {"Whoop Dat [REAL OG]",92083165339217},
  {"[LIMITED] Da Koto Nai Dance",122549169509833},
  {"Tom Ford Dance",111490552400129},
  {"Gojo Floating JJK/ The Honored One",103040723950430},
  {"Jump - BLACKPINK [BEST] [OG]",123831614665513},
  {"Car Pose: Wheel Inspection",129952845498897},
  {"FF Push Up",127464706232376},
  {"Fake MM2 Death",107498554725527},
  {"Spice Happy Jumping",133319600812587},
  {"Vibing / Community Animation Aura Idle",70508706371253},
  {"Look at that dance - Ody",76822495364622},
  {"Spice On Floor",126837474178236},
  {"Absolute Sadness",92893440808720},
  {"Ei Moto Táxi Cowboy",123411082901380},
  {"bow bow bounce Dance [OG]",77568709550148},
  {"Your Bias - ILLIT",117488486185600},
  {"Gooba Triple T",91547714912250},
  {"[BEST] Dougie (Everybody Loves Me)",114756515400742},
  {"Korean Greeting! (Annyeong / 안녕)",135719167611495},
  {"Mi Nena",96482393349760},
  {"♡⸝⸝ skittl bouncy emote pop ა",101822968373264},
  {"MOONWALK - MICHAEL JACKSON",123601584523368},
  {"sharp's Bloodpop Jo Slide",124987679420663},
  {"67",79159574589173},
  {"Fireball - Pitbull [OG] [BEST]",93298430995886},
  {"Hello Kitty Dance [OG] ",92504533520053},
  {"Peaceful Sit",99169466290816},
  {"♡ cute bouncy anime dance",108845097487486},
  {"Cristiano Ronaldo SIU Celebration",115392964685334},
  {"Dab Steps",126353729413555},
  {"♡ : super shy girly idle pose",132436768198498},
  {"Balenci - Shoot",89598007624288},
  {"Feel the Vibes",99910322239828},
  {"Tell Me, Tell Me! - Wonder Girls",112118419325053},
  {"Super Saiyan (Goku)🔥",137575224673264},
  {"cute shy doll anime profile pose",124672508835330},
  {"Time is ticking [High]",79138340800842},
  {"Endless Aura Floating",133329596354882},
  {"REDRED - CORTIS",131702629721284},
  {"You're Under Arrest - ILLIT ",82441855800583},
  {"🔥 Menacing Floating Viltrumite Pose (Invincible)",105629184097643},
  {"🕷️Jumpy Spider Emote",128438913234993},
  {"Needy Cat R6",76902290998665},
  {"Windy Circle",137801052569601},
  {"♡ supa cute sonny baby angel pose !!",107121561277305},
  {"Lord Verity",92001248606070},
  {"Jogadinha do malfalado (JOGADA)",87884932747690},
  {"WOOF BARK WOOF ",88859617281337},
  {"Zombie Run",99203482197855},
  {"Spice Floor Call",103399717097173},
  {"WALL HACK 💀",116845760274606},
  {"Bully Emote [Spider-man]",91691744031819},
  {"TWICE - The Feels",79194689807074},
  {"Cute hug ",112236176039637},
  {"Bet You Wont",97939147443804},
  {"We Switchin Lanes Pt 1",95872478260017},
  {"Beautiful Day Dance",115213031358991},
  {"passinho quebradeira, (brazil dance)",99054845091457},
  {"MM2 Fake Dead Pose!",83548980186247},
  {"KATSEYE-Debut",87052392132964},
  {"Sweet Hug Pose V1 [MATCHING] ",100597438247721},
  {"True Heart",103168660352906},
  {"♡ Cute n shy Idle Emote Profile Pose",135994700702758},
  {"🔥Sasuke Mandem Style (Tonex)",135243511815439},
  {"Super Needy Shakey Jiggy",107909747700606},
  {"KATSEYE - Animal",90163227826837},
  {"NewJeans - ETA",94694691436126},
  {"Cutesy Walk",79254145855162},
  {"Catwalk Walk Emote (FIRST,OG)",138140141577966},
  {"Sit",101743582461626},
  {"(Dance) Bouncy needy",120604459283368},
  {"Chill Guy Pose",101634813744727},
  {"⸸ Baddie Stare Pose Look Back",71087030117132},
  {"Head Pat High [Matching Set]",120833029935011},
  {"Gnarly - KATSEYE",79701936708542},
  {"[OG] TALKING BODIES",138811517110383},
  {"♡ : Cutesy cat paws standing pose",132074616269334},
  {"La Detone - Dance",103768845612667},
  {"KATSEYE TOUCH (CHEAP)",75916539353418},
  {"baddie",125699260461610},
  {"fighting ",136699203665480},
  {"There She Goes [TREND] [OG]",93794780495493},
  {"Vibing Animation Idle",140282007971081},
  {"Supalonely Dance",107487776265990},
  {"/e invisible (works in every game)",93415741456478},
  {"FORRÓ BRASIL",71137067237576},
  {"feeling it",83816979197195},
  {"Floating Aura Pose",88318250668110},
  {"MM2 Dead",139859849852362},
  {". ‿♡ cute teensy darling sit pose ♡ ",138241120266753},
  {"Snowman Dance - Left",117498793976482},
  {"Jamal Dancing Emote",117290583615305},
  {"Louisiana Jigg ",95478274272717},
  {"cute nekoya!! ≽^ ˕ • ྀི≼",94630350809580},
  {"Bored",5230661597},
  {"Cute Hands on Hips Pose ♡",73088882547530},
  {"♡  christmas winter ice skating",131222297033593},
  {"[OG] I Like To Move It",76791188992804},
  {"Crazy Upside Down Spin 🙃",106497056052965},
  {"Nervy Emote Dance",79687715577021},
  {"SpiderMan [Original]",130987133773478},
  {"⏳ Take The L",93753629896415},
  {"Bugging Top Rock",131551107575313},
  {"Jester Dance",124057206061364},
  {"Lush Life",82727664018494},
  {"sit",120512834137418},
  {"♡ : Shy Doll Cute Standing Idle Profile Pose",115140876718590},
  {"Ya Funk Brazil Hips",92405532263152},
  {"✅ Obby Head - Emote [ORIGINAL]",122814100170962},
  {"Ciara Body Bend",137380696225154},
  {"disco spin 🎀",87927660544482},
  {"Hands in pockets Idle pose",73197645333580},
  {"apple store girl (do you want me)",86591723458333},
  {"Head Pat Hair Head Scratches",101854949802756},
  {"💩MEGA POOPING 💩 [AURA] 😂",106880906271071},
  {"Blue Shirt Kid Sturdy",93659771713494},
  {"Brooklyn Bloodpop Dance",107029350970343},
  {"Headless",74738520664045},
  {"Traffic Bend (By Zhykir)",82417864250074},
  {"Mystical Magical",122629578509519},
  {"Slowed",126534531783872},
  {"hip swing dance",110806766469743},
  {"Baby Queen - Face Frame",14353421343},
  {"Glitch through walls (phase)",132366431744296},
  {"Pinky Up - Megan's Part [OG]",77094593024567},
  {"y2k club dance ♡",126963352158363},
  {"Cute Diva walking",87143783234148},
  {"STURDY",120302905807132},
  {"Tomodachi Mii Hip Sway",105909453197841},
  {"Garry's Dance (GMOD)",129861012882037},
  {"cute shy idle emote",75625402433882},
  {"Keep Dancing 🔥",82882753823435},
  {"Hyper Spin ☢️",128499330282458},
  {"Christmas Winter Ice Skating",140700426367366},
  {"67 ",117781289000852},
  {"Fireball!",76273772570448},
  {"Cute Sit",116578970554242},
  {"Speed Mirage",108946079729323},
  {"Nya! Arigato 3.0",102162317351795},
  {"Car Pose: Tokyo Lean",118859160373597},
  {"cute sway animation",104612504371741},
  {"[LIMITED] Aura Farm Float",104289684920569},
  {"Iconic Pose",107391441166760},
  {"Relaxed Sit",99568437064777},
  {"Sweet Hug Pose V2 [MATCHING]",79076692213299},
  {"Sitting Idle Pose",124277061474821},
  {"Kawaii Sitting Profile Idle Pose",77375301771213},
  {"Electro Shuffle",96426537876059},
  {"MM2 Death Pose #777",128065900979920},
  {"♡ kawaii pleading beg kitty sitting idle",104327975123706},
  {"Sitting",128065463230898},
  {"Digidigida Setalcix",131849376001090},
  {"Snowman Dance - Right",123032739590624},
  {"That's RED RED - Cortis",78868540419185},
  {"Cool That Setalcix",79471736553300},
  {"xaviersobased",139371349828009},
  {"Fashionable [CHEAP]",93285483814710},
  {"Peep The Reverse",134420814934927},
  {"Creepin Dance",80985588930231},
  {"Faceless Aura",103981563274328},
  {"Vampire Pose [Halloween]",113919169704818},
  {"FF Devil's Move",135024312410136},
  {"Left Right Dance",92471192932938},
  {"Ain't In LA - Adela",81217954651640},
  {"Furry sit tail wagging 🐾",122188854467532},
  {"pain and suffering",93195109588878},
  {"Needy Roll Wave Dance",88522952970107},
  {"[LIMITED] Neck Roller",89795661844146},
  {"Spice No Pressure",84970889771902},
  {"[HOT🔥] Spinning Cat",75739251269771},
  {"mini me in hands",77743690728348},
  {"sharp's French Confidence",113927348020837},
  {"[ OG ] Take her down",111956881466696},
  {"[BEST] Invisiblity",130371895389423},
  {"zombie rawr ฅ^•ﻌ•^ฅ [Pose/Idle]",74963625028514},
  {"Silat Setia Hati_[PSHT]🥋",71840208568470},
  {"Che Che",122937667902627},
  {"PEAK \"There She Goes\"",122817550241080},
  {"Honor Knight Kneel Dark Souls",89198573930777},
  {"[𑣲 OG] LA Kitty",84449348220426},
  {"Its me - ILLIT",133595640131451},
  {"Casual Sitting",113039466758343},
  {"Monkey",3716636630},
  {"⚔️ Jetstream Taunt",84120506908510},
  {"୨୧ Floating Magical Witch",80275898795677},
  {"[🎀CUTE] Catwalk Walk Girly",131907146446807},
  {"Alter Ego ",95944231654385},
  {"cute sit",131875333242836},
  {"[LIMITED] Rat Dance",132258280591430},
  {"Caramelldansen (R6)",92900132509399},
  {"Spooky month dance [R6]",131156687210592},
  {"Slow Dembow",73236219340808},
  {"♡ cute shy doll pose",138525815240480},
  {"Shrug Fashionista Pose Emote",131049501684837},
  {"Cozy Hug Pose V2 [MATCHING]",135268727910642},
  {"Lets Get Sturdy",119341017234649},
  {"⸸꒱ cute knee sit idle pose",72753598082403},
  {"Spicy Flow Vibes",124212021234700},
  {"Needy V Sit Split Drop",97761168412460},
  {"Panic Run",79338722896418},
  {"Body Phone",95714033584938},
  {"R6 Califorina Girls [Forsaken]",84430246447182},
  {"Attitude Moves Groove",75352198387754},
  {"Making Faces",89535391366809},
  {"🐈 Cat Bath 🧼 ",127049078545834},
  {"Rakai Emote",135686271244127},
  {"Backflip",91583499354581},
  {"OMG Dauntless Setalcix",132148363993807},
  {"Creepy Crawl",90347028154387},
  {"KSI - Wake Up Call",107043196201393},
  {"Sit",112866416808102},
  {"Asian Squat",87939646671209},
  {"Oli La Flaka",133012566321432},
  {"Inactivity With Arms Crossed",108771805233715},
  {"Confident Moves",117354815468155},
  {"Sukuna Aura Farming",73532860571147},
  {"Hat tip",139693042352637},
  {"carry me! cute ask for carry uppies — 聖域 ",91569386813348},
  {"˖.♡ : cute sit pose",74507446878323},
  {"Baby You Buggin",133606623293195},
  {"Bleood Walk",134667106003404},
  {"Sdudla",82967702750682},
  {"/e korblox",76878074357829},
  {"Hip shake",104595144561229},
  {"Boxing ",102890708837179},
  {"♡ LOVE 4 YOU! cute silly dance",91148698349529},
  {"Hype dance ღ",120482648445871},
  {"⭐ Thragg's Show Viltrumite Aura Pose (Invincible)",96985407723666},
  {"🤪Skibidi Shake⚡",80115988215727},
  {"Wish NLE Dance Emote",85753915767287},
  {"[Best] All Might Victory Pose R6",100416618991324},
  {"Curtsy",4646306583},
  {"Jookin Steps",76648202382112},
  {"Lil Wayne Idle Pose",108439329967345},
  {"Sleep",4689362868},
  {"cute bunny jump",73743547037696},
  {"[uptade] drop kick ",132101801631355},
  {"🎃 Creepy Pose Halloween Zombie Holding Head 🎃",137620589778424},
  {"Spice TempoSwitch",94892483748973},
  {"GOJO VS. SUKUNA",120672295457021},
  {"Dance If You're The Best - Dia Delicia Dance ",117033010486869},
  {"zesty sturdy (actual original)",120702604995324},
  {"I'm Talm 'Bout Innit (OG)",117301403779781},
  {"Cute Bouncy Hip Shake Dance",87963462118126},
  {"Body Roll Wave",128491941028599},
  {"KISS N TELL - aespa",112351547735373},
  {"Needy Circle Shake",127761797207622},
  {"[LIMITED] Moonwalk & Lean",99630754537444},
  {"Forward Lean",92771038607415},
  {"♡ : shigureui cute hip sway",96768816121605},
  {"🎄All i want for christmas ",71661227686773},
  {"୨ৎ adorable cute kawaii sit pose",86599382047737},
  {"I Never Seen",113584649324281},
  {"⏳[LIMITED] ♡ Chill Sit Pose [Idle, AFK]",87982927823236},
  {"Sonic You're Too Slow (Animated Face)",103737097131582},
  {"🕷️ Spider-Man Hanging 2",139402543978841},
  {"Endless Levitating Aura",78584973519852},
  {"[R6] Monitoring Dance (deco*27) ft. Hatsune Miku",127133357595370},
  {"Ion romance",81937112745434},
  {"♡ : Come Back n' Back (Wyw My Sweetie)",113273786867095},
  {"🤣 SCUBA",109355510139052},
  {"♡ cutesie shy idle !!",120389512169914},
  {"⏳[LIMITED] Cutie Sit",102987467290082},
  {"Legendary Lovers",116256886592834},
  {"R6 Sit",104722042727911},
  {"MONTAGEM RUGADA Dance 🎵 Basketball Zero PREMIUM",131839962880709},
  {"Sukuna aura farming pose",134652549574927},
  {"Spontaneous Combustion [Explosion]",116525123305794},
  {"Nope Finger (emote)",77206866044608},
  {"Napoleon meme",101445494059759},
  {"Low Cortisol hip sway",138149876527113},
  {"Attitude Moves Flow",96048417640957},
  {"Body Down Chic Flawless Bounce",110140180833602},
  {"Cute Moe Zombie Holding head Idle ",107245174135682},
  {"Vogue Crouch Hop",134741005624382},
  {"Zombie Walking",73099178451291},
  {"PARROT PARTY DANCE",121067808279598},
  {"Nya San",118688124889191},
  {"Godly Aura Fly",109998455845225},
  {"Snoop's Walk Emote",110614921871084},
  {"🐾 AI ROBOT DOG RUN 🐕 FUNNY MEME",140613580596441},
  {"Cute Sit",76141389326304},
  {"LA CALABAZA",130967766938032},
  {"Chill sit",120670612025539},
  {"Car Pose: Crossed Arms Lean (3.0)",89010970802963},
  {"♡ cute standing idle",123375532260742},
  {"🤍Me! Me! Me!",115407106598230},
  {"Needy Chinese Split Shake Bounce",96437059740838},
  {"⏳[LIMITED] Cutesy Shy Timid Model Profile Pose ♡",138785982662822},
  {"Belly Dancing",131939729732240},
  {"YEA YEA (made by Mari) ",121069255135091},
  {"Head scratches / Head pats",123663633846435},
  {"♡ kawaii cute hand away pose",105988391359538},
  {"California Girls",130248288787333},
  {"Hoppin Dance Emote",133388744603429},
  {"Thank You Bow Ladies and Gentlemen ",132566708912466},
  {"🔥Effortless Wall Aura Farming Lean Idle Pose🔥",125492222420583},
  {"cute ponpon dance og",114462336086965},
  {"♡ ꒰ Cute Shy Pose",136701250296230},
  {"💕 Hug [Player 2]",105879715898474},
  {"Take The L",114693924122763},
  {"AVGN Dancing Dot Mov [R6] - BYOC",135622334721761},
  {"[Limited] Halloween Headless Football Juggle",106981435636658},
  {"Cute Needy Dance",84724781152365},
  {"🌟\"I'll kill you.\"",116450987409557},
  {"🔥SCUBA ",139138107669285},
  {"Druski Pop Out",98405298116702},
  {"Stray Kids - This And That",71620555693565},
  {"💀MM2 Fake Dead - 2",95407766746448},
  {"Homer Groove Dance",79167366746354},
  {"[Limited] Bored AFK Chill Floating Cross Legged",136732015466579},
  {"head spin",103488665286742},
  {"Spiderman Hang",108635834286627},
  {"♡ adorable hug emote ",124525279306515},
  {"Jotaro Pose (aura)",104330991197585},
  {"🎃 Halloween Floating Holding Head Zombie",123061318413098},
  {"kawaii cute cat girl pose idle",138487798883208},
  {"Tuf Pof Dance",71439556661134},
  {"[⌛Limited] Tomato Dance",98735946106272},
  {"Gangstar dance",84110142550799},
  {"[NEW] watch it move",102126534216131},
  {"A Rose?🌹",91739079549341},
  {"[R6] Cute Cat Girl Sit 😺",103419254861486},
  {"[LIMITED] Cutely Kicking Feet",115123054394314},
  {"♡ : adorable kitty sitting idle pose",83483154476792},
  {"PLEASE MOMMY! ",95148707883309},
  {"Peanut Butter Jelly",101417838306172},
  {"Billy Bounce Dancing",76518972034089},
  {"Upside down floating AURA",89468381929192},
  {"Sassy Fashion Twirl",103924340632445},
  {"Flying Superhero Emote",71574925787532},
  {"FaSHioN - CORTIS",118850907110385},
  {"Happy",4849499887},
  {"Macarena",73946479113094},
  {"Wobbly Zesty Sturdy Dance",77880729614024},
  {"Shoulder Carry Piggyback",92706401579816},
  {"KATSEYE - Gabriela",104919087878238},
  {"China Bounce Setalcix",97401445944521},
  {"Cute Bye Bye Pose",84735057831782},
  {"Chedder Bbq Wavy Sour Cream and Onion /Trend Dance",79729995051649},
  {"sharp's Famous shoulder hold (F)",74400945077223},
  {"Meditation Aura Farm",105433278564870},
  {"Kizuna AI \"Hello, Morning\"",125949163041883},
  {"Hero Flying Emote",130883965996839},
  {"DAI DAI DAI KIRAI",110503252123234},
  {"Foreign Shuffle Dance",101507732056031},
  {"🎃 Headless 🎃",118305672904748},
  {"Possessed",102610758906338},
  {"Cute Needy Hip Bounce",120297764741811},
  {"Vou Pra Pista",82477431412819},
  {"Chinese Sinister Shuffle",101641487657752},
  {"JUMPSTYLE | FALL FROM THE SKY",85528043259864},
  {"♡ Sweetest Angel Sit Emote Profile Pose",77431715819015},
  {"Rambunctious",108128682361404},
  {"Paris Hilton - Sliving For The Groove",92327041931304},
  {"baby boo dance",78428722915978},
  {"Good Boy Dog Emote",100737291015384},
  {"Spider Hang",74280549351005},
  {"Helicopter",110553756436163},
  {"Victory Dance",77727141076962},
  {"KATSEYE - Gnarly (Dance Break)",115663351458368},
  {"[ OG ] Bend On Em",103023522673856},
  {"R15 Death (Accurate)",114899970878842},
  {"💥 Triple Roundhouse Kick",107652660092239},
  {"Piggyback Ride V1 [REUPLOAD]",118812282698876},
  {"China Bounce",85024808869895},
  {"cute laying kicking feet",107799482155621},
  {"Alter Ego Poses Trend",128992953324925},
  {"Tall Giant",126672040102655},
  {"Girly Outfit-Check ",115584191221260},
  {"♡ cute dolly girl idle pose",91771584024127},
  {"Space Flying",88026731867245},
  {"Celestial Flying",134814117663074},
  {"VIBEY FRONT",75499769367603},
  {"۶ৎ cute pose ",73781389282146},
  {"Bby Wow trend",132600795042399},
  {"🕷 SPIDERMAN POSE",112354510576428},
  {"Circle Shake - Dance",79636244876502},
  {"Shake, shake your body",101268482541411},
  {"[ OG ♡ ] brooklyn pop - kawaii hip swing dance",104060042886647},
  {"💀MM2 DEAD FAKE BODY💀",107759055848475},
  {"Siu Cristiano Ronaldo",136290575388000},
  {"[BEST] Scuba diving 🔥",104730373747906},
  {"Khalouni N3ich (Arabic There She Goes Trend)",100074030719487},
  {"♡ ICONIC BY MISTAKE [CHORUS] ",128402456731579},
  {"cute shy girl idle pose",90424039303226},
  {"/e fly 🔥",118660060910620},
  {"/e dance1",122117255044047},
  {"♡ Cute Kawaii Shy Doll Stance",78712622250645},
  {"Melbourne Shuffle",71125711204213},
  {"The Tylil Dance [Kai Cenat Dance]",107010273569673},
  {"🥊 Shadow Boxing Emote 💥 Fighting Stance",138762085713240},
  {"Funny Floppy Fly Emote",111689026005752},
  {"Dabbing dave 🫦",78333625451695},
  {"King Isnar 👑",116584645800704},
  {"♡ cute shy girly idle pose ",118795080987474},
  {"Slow-Mo Backflip | IShowSpeed Flip [NEW]",86617727183442},
  {"Seonghyeon Dance",78795119023025},
  {"Laughing It Up Emote",122240620529815},
  {"HAKKEN",76976190923828},
  {"Catch Catch Setalcix",129411309930167},
  {"South Park \"Alien Experiment\"",100672185893985},
  {"Acid Hues (Splatoon 2) ",89169544922376},
  {"still idle",86375122997153},
  {"cute doll ballerina music box spin",111332667359868},
  {"[💀] MM2 Invisible Box (HIDE)",83522304666655},
  {"Flare R6",96591982387946},
  {"⚡ MM2 Wall Phase Clip {TROLL}",81094285581245},
  {"Gangster Delinquent Crouch",137201675761037},
  {"Boogie Down",139570238573569},
  {"🪙Relax Coin Flip",123310811878570},
  {"Fake R15 Wicked Run Lag",115335830942903},
  {"neck roll",95845717615689},
  {"🔥 BOING! STRETCHY RUBBER GUY 🤪 FUNNY MEME",140727274534245},
  {"Fashion Diva Walk",112924594346600},
  {"Mini Me Superman Fly",135089402831190},
  {"Floating Sit",83475540437708},
  {"Funny Goofy Wiggle",74277551575520},
  {"Come With Me Dance 🎃 Blue Lock Rivals PREMIUM",114231331580017},
  {"Sweet Sit Pose (Ledge sitting)",103541659586127},
  {"Flying Pose Emote",97130179011866},
  {"Michael Myers Dance 🔥",134906869981920},
  {"Cry For Me [TREND] - Ironmouse",129306314449009},
  {"Billy Bounce",126516908191316},
  {"Baby U Buggin AySplash",113986317716030},
  {"Take The L - Meme Emote",133545170540942},
  {"Hit Dem Grooves",99573231781386},
  {"Cool Club Swipe Dance Emote",115585907602167},
  {"Zany dance",88999373058588},
  {"😽 Needy Rolling Kitten🐾 ",86075882228744},
  {"(Forró style) Brazilian PRA PRA PRA",117632781999272},
  {"Dump it",71629309942527},
  {"Fake Lagging (Old School Run)",92556591123190},
  {"[⌛Limited] Nervy Dance",80299727771978},
  {"🐾 Furry Running 🦊 ",127131085046464},
  {"[OG] That's a big ole fact",77379678507765},
  {"The Last Dance - Right",122431369567515},
  {"♡ headpats ",73930469890558},
  {"Rollie (BEST LOOP)",110827382619943},
  {"💕 Hug Emote",121966388920366},
  {"Do the Dance (Billyeoon Goyangi) - ILLIT",134996909014918},
  {"And Go Emote",116497541981303},
  {"DARE - Gorillaz",88840501982686},
  {"kawaii cute shy",80672153848847},
  {"♡ soft elegant stance !!",90478555055303},
  {"Moon Walk  ",96546013051616},
  {"Douyin Guy",119012483329740},
  {"[LIMITED] Gangnam Style",88391763327563},
  {"The Last Dance - Left",126281648413818},
  {"⏳[LIMITED] Cute Sit",94378628515875},
  {"Adorable Shy Emote Pose",123021576398066},
  {"I Just Wanna Dance (BCDI)",138401076826528},
  {"Naruto Run",103687415030735},
  {"👊 Kickboxing Punch & Kick Emote 🦵",105872229257735},
  {"FF LOL (Laugh)",129709531895539},
  {"Camden Bop",130954049366970},
  {"Mr Vain Para Para Dance Emote",76566631526363},
  {"Silly Cartoon Dance",140460683070779},
  {"Arms Crossed Arms Emote",120083676685180},
  {"Floating Head",133286128000600},
  {"Scenario",128771561752851},
  {"Jumpstyle Dance",75044579039280},
  {"[Original] Nervous Dance 🔥",80509251534459},
  {"2 Many Glockies! [OG]",121335645184894},
  {"shake",107944445414859},
  {"Cute anime bounce",97233973386966},
  {"Relaxed Sit",111231236978253},
  {"Bachata dance",93595214952542},
  {"Hotel Transylvania macarena dance",81808860196321},
  {"R6 Peanut Butter Jelly (Die Of Death)",100267888506831},
  {"Yiyo parin shluzov - Ody",140401301990607},
  {"Sleep Floating Emote",97191558540170},
  {"cute bouncy miku dance",97778561381799},
  {"silly jumping spider dance",89157328525577},
  {"[HATSUNE MIKU] Ievan Polkka",119391643501594},
  {"Scary Monster Scream",98202348256143},
  {"Come Back n' Back | Wyw My Sweetie",110012709817467},
  {"Reze Dance (Iris Out)",91032553512904},
  {"Luffy Gear 5 Laugh [High Quality]",106008592717540},
  {"Feel the music ! Aura Pose vive",139782812297837},
  {"Woo Vibes",134990512872985},
  {"Kiss Emote",82810853201599},
  {"[LIMITED] Cute Kawaii Pose",92988504323567},
  {"Springlock Animation",132844034228766},
  {"Lay Down",131780323039895},
  {"♡ Cute hug ♡",91608959447512},
  {"Stylish Flying",104532438168520},
  {"Hug💕",88712283515515},
  {"Jersey FLow",80458041843003},
  {"Olivia Rodrigo Head Bop",15554010118},
  {"RiRiRi Happy Halloween",79811720717387},
  {"Urban Dance",89466407313325},
  {"Teto Birdbrain Dance: Part 1 of 3",104263317795993},
  {"Rat IShowSpeed Dancing Emote",86673370302107},
  {"wassup ",109037425342728},
  {"Friendly Sneaking (Steven)",111271817770263},
  {"Deltarune - Tenna Kick",111434734435321},
  {"Arthur Morgan Idle",107079307862886},
  {"Possessed Glitcher (Scary)",108419372425578},
  {"Cute Ask For Carry",93372734314764},
  {"Springtrap Dance",132007669525235},
  {"Chibi Walk — Adorable Stroll",114896599198832},
  {"Confess to Me",105722319548703},
  {"[HATSUNE MIKU] Miracle Paint",72817312763419},
  {"/e dance2",124072098165199},
  {"Spice Pretty Motion",105706828934091},
  {"Tomato Dance",136178231049566},
  {"MM2 Fake Death (Play Dead)⌛",85972179249643},
  {"Happy Cat Emote",79190676894970},
  {"feeling myself",90456357265054},
  {"1234 Emote",127226959917867},
  {"It's Me - ILLIT",111863394891917},
  {"MJ - P.Y.T. Pretty Young Thing",104918829785757},
  {"The coolest standing pose in the world",110330632237517},
  {"Logan Paul Splits V2",95567185677058},
  {"Naruto Run",120668080412453},
  {"♡ POP - ILLIT",88620362521877},
  {"Bregafunk (Pro Teu Soldado )",78713375853507},
  {"Aura",122592391257572},
  {"[OG] Finna Get Loose",138455860910964},
  {"Subaru Victory Pose! | Aura Monster",84408789003040},
  {"Invincible Wobbly Edit [V2]",112546913961358},
  {"♡ ꒰ Laying Down Splits Pose",119973148778428},
  {"Party Funk",91128800224528},
  {"Dizzy",74797288510399},
  {"Brazilian Groove Dance Trend ",97620794571355},
  {"Universal Peace sign emote ",140454117501654},
  {"[OG BEST] Baddie Needy Smoothie",136601924392223},
  {"Yuji idadori (Aura Farming)",130445580603871},
  {"Ritmo do Bregafunk - Brega Funk (Brazilian Dance)",140174352913611},
  {"Mannrobics (TF2)",83702306317443},
  {"Arnold Flex",139950728717721},
  {"Hero Landing",5104377791},
  {"♡⸝⸝ skittl psycho teddy kitty dance ა",133841468648398},
  {"Fly fly without stopping",101746498500091},
  {"sharp's Famous shoulder hold (M)",72902749637702},
  {"Horror Deformations Body Emote",118691804336328},
  {"Witch Flying Broomstick",86598690263133},
  {"Bombshell Baddie Profile Pose / Idle",115609573460060},
  {"Floss Dance",5917570207},
  {"SEIZURE",83142432500374},
  {"R6 Subject Three (Forsaken)",95568556018445},
  {"cute pose",121994896962604},
  {"SIT DOWN POCA #EMOTE #DANCE",140559415793416},
  {"windy balance (best)",75063069459963},
  {"Low Cortisol [R6]",131890158842463},
  {"Dancing with your eyes closed",129637389787927},
  {"[R6] Happy Halloween Junky Dance",99824709685353},
  {"Needy Bounce Circle Shake Emote",82335103855314},
  {"sit",98193487057348},
  {"[R6] Assumptions",86800672185924},
  {"Hanging Vampire Pose",90764553172054},
  {"Luku Dance",114523209619628},
  {"[LIMITED] Levitating Spinning Head Pose ",84532473178040},
  {"MM2 Fake Dead 💀",135577679359629},
  {"🧛Vampire idle pose",95141891071861},
  {"Blue Top Rock",102222849201801},
  {"Legless (RIGHT)",103657510663195},
  {"Flying UFO",137999659311195},
  {"Baby Queen - Face Frame",82960976595139},
  {"Commander Pose",105430065366949},
  {"(WORKING) WALL HACK💀",75245006025085},
  {"Lamine Yamal - Party Funk ",122976657934343},
  {"Caramelldansen Dance Original ",87440273279654},
  {"Ronaldo suiii prank",110617490683718},
  {"Hear Me Now! ",91110020647774},
  {"Play Dead MM2 - 2",126602260907569},
  {"Crossed arms stance (for non-blocky)",138257865474546},
  {"Fake Lag",116139058158374},
  {"Camden Bop",86411651121424},
  {"Silly happy walk",90540574364321},
  {"Runny Dance",126226506101092},
  {"Gmod Killbind Ragdoll",121792397276961},
  {"[OG] Military Dance",79318911527752},
  {"2 On Dance",80339359842613},
  {"[OG] kawaii misery ⸝⸝♡",112634735026557},
  {"Brazil Groove",122243370061637},
  {"Reese Roll Setalcix",122052794867917},
  {"Hands Up",108894965141226},
  {"kawai shy sit idle pose",105933851371838},
  {"⏳[LIMITED] Walking On Air Aura 😎",77649456774733},
  {"⏳[LIMITED] Cute Kicking Feet Side Lay ♡",124096299386206},
  {"Formal Bow",125708812490674},
  {"[NEW] 💀 Murder Mystery 2 Fake Dead (MM2 DEATH)",128526992756223},
  {"♡ : cute little catgirl nya sit idle ",127703766312900},
  {"Drip - ATEEZ",72176992982126},
  {"(Orginial) Begging Sit",131753090209708},
  {"Got That Feeling Dance",76517282325421},
  {"Dead",98089843652381},
  {"[BEST] Sad Crying",71533397882070},
  {"Hakari Dance",125728650235684},
  {"Jax Toy - Digital Circus",111491569569071},
  {"Mesmerizer",92707348383277},
  {"I see Kareem Groove",85913309003871},
  {"Paris Bop",80157425764591},
  {"Scene Roblox Profile Pose",108221503648290},
  {"My Life Is A Party✨",86942523579704},
  {"[💀BEST] Wall Phase Clip MM2 Move",117753850798024},
  {"꒰ Cutesy Splits Idle 3.0 ",86841993405259},
  {"⏳[LIMITED] Chill Sit Pose",118613422126693},
  {"Cute Finger gun shooting",122951090176712},
  {"[R6] Psycho teddy!",118498503777363},
  {"[OP] Fling troll",129593526235428},
  {"Secret Handshake Dance",120642514156293},
  {"12 to 12 - sombr [OG]",121598715957720},
  {"Creepy levitation",121975254256755},
  {"Spiderman Backflip",116452483869393},
  {"Aura walk",109054312609768},
  {"Ninja Run",115430810461234},
  {"Low Cortisol",127169444865281},
  {"Greatest",3762654854},
  {"Psycho Teddy [+] Updated",112252923868657},
  {"wavy da hood dance",113247144113467},
  {"[LIMITED] Rat Dance",136998207176571},
  {"Just be competent",124041369408613},
  {"Sleep",120351402471188},
  {"Mannrobics",96207177690619},
  {"Gangnam Style",116999664042964},
  {"Cjute Peachy Groove",128574721404774},
  {"FNAF Movement",95919666252639},
  {"Exum Shuffle",125738466226351},
  {"Wall Hack MM2 💀",96483295053378},
  {"♡ SUN KISS - TUIDE",88866662363661},
  {"Spin Around With A Friend Matching",70617440339521},
  {"[OG BEST] Missed and needy",74359676673985},
  {"Fight🤼",88476569980440},
  {"♡ cute shy standing idle",138355324974367},
  {"Catch Catch - YENA ",116913701204152},
  {"In a Minute Wassup",124687556192041},
  {"RISKY - PureSnow",135961232340503},
  {"TF2 Laughing - Spy [R6]",76507949699963},
  {"Smug Dance",136079923684452},
  {"Take The L Dance",96180931834416},
  {"Heavy Sword Stance",109863797124787},
  {"Blow A kiss ",128525144569231},
  {"Sonic the Hedgehog Run",132168791204839},
  {"Scary Horror Head Turn",125928732780921},
  {"🤪 DO THE CHICKEN WALK! 🐔 FUNNY MEME",138384420924492},
  {"head wall bang",72333289441940},
  {"ʚɞ cute kawaii misa sitting pose",120468554793607},
  {"Spice MainCharacter",88363647483612},
  {"Angelic Invincible Overlooking Floating Idle Pose",84270094894494},
  {"Swaying Sit",120565455646158},
  {"[R6] Rampage",76358606468919},
  {"TV TIME / Tenna Dance",115831496985107},
  {"SEA LION",107156317035395},
  {"✅ DropKick - Emote",127550355786448},
  {"Push Up",95217325663790},
  {"Pinky Up! - KATSEYE Dance Break",123144218857765},
  {"Side Sit",85370173309996},
  {"Sad Crying Sit",137798892265594},
  {"Hootie Frutti - KATSEYE",84875290330180},
  {"Tyranno",106272709453753},
  {"Salsa Dance",91838676263471},
  {"Six Seven 67 Emote",138655899616417},
  {"Dorobo Dance",135125100245492},
  {"♡ bossy tsundere pose",123366249253995},
  {"Rose Gift🌹",132380943956928},
  {"La Chona 🇲🇽 MEXICO🎉",119506087814903},
  {"Aura Floating Anime [BEST!]",117275009351711},
  {"Holy Bend",70710250940844},
  {"[BEST] Popular",70768431494704},
  {"BALENCI EMOTE",72743781783520},
  {"Leaning Against Wall Arms Crossed",77806145358673},
  {"Car wheel instructor",84382151844938},
  {"Chappell Roan - HOT TO GO!",98649422659862},
  {" [ CUTE ]🍀Lucky Girl Syndrome (Outro) - ILLIT",93311288865428},
  {"Arona Dance Meme",113818946774721},
  {"[BEST 🔥]💀 MM2 fake death pose",112653819345540},
  {"♡ Shy Kawaii Sit Emote Profile Pose",97812358910519},
  {"Creepy Ventriloquist Puppet",95800106960533},
  {"Signature Series #4: The Moonwalk",107769931495462},
  {"Cute Bouncy Anime Dance",103383253740105},
  {"Gameboy - Katseye",117453574553102},
  {"[LIMITED] Body Tornado",130836074181150},
  {"Fergalicious",99268262150388},
  {"Matching Hug [1]",83878498166514},
}
function neo.emoteCleanId(id)
  local value=type(id)=='number' and tostring(math.floor(id)) or tostring(id or '')
  local parsed=value:match('^%s*%d+%s*$') and value:match('(%d+)') or
      value:match('[?&]id=(%d+)') or value:match('rbxassetid://(%d+)')
  local number=tonumber(parsed)
  if not number or number<1 or number~=math.floor(number) then return nil end
  return math.floor(number)
end
function neo.emoteAdd(name,id,animationId,isDirect)
  id=neo.emoteCleanId(id)
  if not id then return false end
  local anim=neo.emoteCleanId(animationId)
  local entry=em.byId[id]
  if entry then
    if type(name)=='string' and name~='' and entry.name==('Emote #'..id) then entry.name=name end
    if anim then entry.animId=anim end
    if isDirect then entry.direct=true end
    return false
  end
  entry={id=id,name=type(name)=='string' and name~='' and name or ('Emote #'..id)}
  if anim then entry.animId=anim end
  if isDirect then entry.direct=true end
  em.byId[id]=entry
  em.items[#em.items+1]=entry
  return true
end
-- Unicite par article et, lorsque connu, par animation effective.
function neo.emoteDedupe()
  local items,byId,byAnimation={},{},{}
  for _,item in ipairs(em.items) do
    local anim=neo.emoteCleanId(item.animId or (item.direct and item.id))
    local existing=byId[item.id] or (anim and byAnimation[anim])
    local canonical=existing or item
    if not existing then items[#items+1]=item end
    if not canonical.animId and anim then canonical.animId=anim end
    if anim then byAnimation[anim]=canonical end
    -- Conserver les ID fusionnes dans le JSON, puis reconstruire leurs alias.
    local aliases,seen={},{}
    local function register(id)
      id=neo.emoteCleanId(id)
      if not id or seen[id] then return end
      seen[id]=true;byId[id]=canonical
      if id~=canonical.id then aliases[#aliases+1]=id end
      if em.favorites[tostring(id)] then em.favorites[tostring(canonical.id)]=true end
      if id~=canonical.id then em.favorites[tostring(id)]=nil end
      if em.selectedId==id then em.selectedId=canonical.id;em.selectedItem=canonical end
    end
    register(canonical.id)
    for _,id in ipairs(canonical.aliases or {}) do register(id) end
    register(item.id)
    for _,id in ipairs(item.aliases or {}) do register(id) end
    canonical.aliases=aliases
    if em.selectedItem==item then em.selectedItem=canonical;em.selectedId=canonical.id end
  end
  em.items=items;em.byId=byId
end
function neo.emoteLoad()
  local previous=sharedEnv.NEO_MM2_EMOTES
  if type(previous)=='table' then
    em.favorites=type(previous.favorites)=='table' and previous.favorites or em.favorites
    if type(previous.items)=='table' then
      for _,x in ipairs(previous.items) do
        if type(x)=='table' then
          neo.emoteAdd(x.name,x.id,x.animId or x.animationid,x.direct)
          local entry=em.byId[neo.emoteCleanId(x.id)]
          if entry and type(x.aliases)=='table' then entry.aliases=x.aliases end
        end
      end
    end
    if type(previous.cursor)=='string' then em.cursor=previous.cursor end
    if previous.exhausted==true then em.exhausted=true end
  end
  local saved=neo.loadProfile(emoteFile)
  if type(saved)=='table' then
    if type(saved.items)=='table' then
      for _,x in ipairs(saved.items) do
        if type(x)=='table' then
          neo.emoteAdd(x.name,x.id,x.animId or x.animationid,x.direct)
          local entry=em.byId[neo.emoteCleanId(x.id)]
          if entry and type(x.aliases)=='table' then entry.aliases=x.aliases end
        end
      end
    end
    if type(saved.favorites)=='table' then em.favorites=saved.favorites end
    if type(saved.cursor)=='string' then em.cursor=saved.cursor end
    if saved.exhausted==true then em.exhausted=true end
  end
  neo.emoteDedupe()
  for _,p in ipairs(emotePresets) do neo.emoteAdd(p[1],p[2],p[3]) end
  for _,p in ipairs(emoteCatalog1000) do neo.emoteAdd(p[1],p[2]) end
  neo.emoteDedupe()
end
function neo.emoteSave(force)
  sharedEnv.NEO_MM2_EMOTES={items=em.items,favorites=em.favorites,cursor=em.cursor,exhausted=em.exhausted}
  if type(writefile)~='function' then return false end
  if not force and os.clock()-emoteSavedAt<7 then return false end
  local ok,json=pcall(function()
    return HttpService:JSONEncode({version=2,items=em.items,favorites=em.favorites,cursor=em.cursor,exhausted=em.exhausted})
  end)
  if not ok then return false end
  local worked=pcall(writefile,emoteFile,json)
  if worked then emoteSavedAt=os.clock() end
  return worked
end
neo.emoteLoad()
function neo.emoteStop()
  em.playToken=em.playToken+1 -- annule aussi une resolution asynchrone en cours
  if em.track then pcall(function() em.track:Stop(.15) end);pcall(function() em.track:Destroy() end) end
  if em.animation then pcall(function() em.animation:Destroy() end) end
  em.track=nil;em.animation=nil
end
function neo.emoteResolve(item)
  -- 1. La fiche contient deja le VRAI identifiant d animation (cache ou correspondance).
  if neo.emoteCleanId(item.animId) then return item.animId,'cache' end
  if item.direct then return item.id,'animation directe' end
  -- 2. Sur les executors qui l autorisent, le Marketplace fournit une instance Animation
  -- contenant AnimationId. A NE PAS confondre avec son propre ID d article.
  local id=neo.emoteCleanId(item.id)
  if not id then return nil,'ID du catalogue incorrect' end
  local roots
  local ok,obj=pcall(function() return game:GetObjects('rbxassetid://'..id) end)
  if ok and type(obj)=='table' then roots=obj end
  -- 3. Secours Roblox. InsertService peut refuser un objet non partage : c est normal.
  if (not roots or #roots==0) then
    local loaded,model=pcall(function() return game:GetService('InsertService'):LoadAsset(id) end)
    if loaded and model then roots={model} end
  end
  if not roots then return nil,'Lecture de l objet Roblox refusee par le jeu / Delta' end
  local animationId=nil
  for _,root in ipairs(roots) do
    if typeof(root)=='Instance' then
      local anim=root:IsA('Animation') and root or root:FindFirstChildWhichIsA('Animation',true)
      if anim then animationId=neo.emoteCleanId(anim.AnimationId) end
      pcall(function() root:Destroy() end) -- aucune instance inutile gardee en memoire
      if animationId then break end
    end
  end
  if not animationId then return nil,'Cette fiche ne contient pas d animation lisible' end
  item.animId=animationId
  neo.emoteDedupe()
  neo.emoteSave(true)
  return animationId,'objet Roblox'
end
function neo.emoteTryOwned(h,item)
  -- Secours pour une emote deja presente sur le personnage du joueur.
  local ok,desc=pcall(function() return h:GetAppliedDescription() end)
  if not ok or not desc then return false end
  local fine,known=pcall(function() return desc:GetEmotes() end)
  if not fine or type(known)~='table' then return false end
  for name,ids in pairs(known) do
    if type(ids)=='table' then
      for _,id in ipairs(ids) do
        if neo.emoteCleanId(id)==item.id then
          local succeeded,played=pcall(function() return h:PlayEmote(name) end)
          if succeeded and played then return true end
        end
      end
    end
  end
  return false
end
function neo.emotePlay(item)
  if neo.adminIsBlocked('emotes') then status('NEO ADMIN : EMOTES verrouillees.');return end
  neo.emoteStop()
  local token=em.playToken
  local h=hum(Local)
  if not h or h.Health<=0 then status('Emotes : ton personnage n est pas disponible.');return end
  if h.RigType~=Enum.HumanoidRigType.R15 then
    status('Emotes : avatar R15 necessaire pour la plupart des danses.');return
  end
  status('Recherche de l animation pour '..item.name..'...')
  task.spawn(function()
    local animationId,reason=neo.emoteResolve(item)
    if not active or token~=em.playToken then return end
    if not animationId then
      if neo.emoteTryOwned(h,item) then
        status('Emote de ton avatar lancee : '..item.name)
      else
        status('Emote indisponible : '..tostring(reason)..'. Essaie un autre ID ou la correspondance exacte.')
      end
      return
    end
    if h~=hum(Local) or h.Health<=0 then status('Personnage change pendant le chargement.');return end
    local animator=h:FindFirstChildOfClass('Animator')
    if not animator then pcall(function() animator=h:WaitForChild('Animator',2) end) end
    if not animator then status('Animator serveur introuvable : lecture impossible.');return end
    local ani=Instance.new('Animation')
    ani.Name='NEO_Emote_'..tostring(item.id)
    ani.AnimationId='rbxassetid://'..tostring(animationId)
    local ok,track=pcall(function() return animator:LoadAnimation(ani) end)
    if not active or token~=em.playToken then
      if ok and track then pcall(function() track:Destroy() end) end
      ani:Destroy();return
    end
    if not ok or not track then
      ani:Destroy();status('Roblox a refuse l animation '..tostring(animationId)..'.');return
    end
    em.track=track;em.animation=ani
    local started,err=pcall(function()
      track.Priority=Enum.AnimationPriority.Action
      track.Looped=em.loop
      track:Play(.15,1,em.speed)
    end)
    if not started then
      neo.emoteStop();status('Lecture impossible : '..tostring(err):sub(1,90));return
    end
    status('Lecture demandee : '..item.name..' | animation '..tostring(animationId)..' ('..reason..').')
    -- LoadAnimation peut reussir avant que Roblox rejette le chargement reel.
    task.delay(2,function()
      if active and token==em.playToken and em.track==track and track.Length==0 then
        status('Animation non chargee sous MM2 (ID / autorisation Roblox / reseau).')
      end
    end)
  end)
end
function neo.emoteGet(url)
  local ok,res=pcall(function() return game:HttpGet(url,false) end)
  if ok and type(res)=='string' and res~='' then return res end
  -- Fallback facultatif selon l'executor ; uniquement GET et sans secret.
  local getters={}
  if type(request)=='function' then getters[#getters+1]=request end
  if type(http_request)=='function' then getters[#getters+1]=http_request end
  if type(syn)=='table' and type(syn.request)=='function' then getters[#getters+1]=syn.request end
  for _,fn in ipairs(getters) do
    if type(fn)=='function' then
      local success,data=pcall(fn,{Url=url,Method='GET',Headers={Accept='application/json'}})
      if success and type(data)=='table' and tonumber(data.StatusCode or data.Status)==200
        and type(data.Body)=='string' then return data.Body end
    end
  end
  return nil
end
function neo.emoteFetch(query,cursor)
  local suffix='Category=12&Subcategory=39&Limit=30&IncludeNotForSale=true'
  if type(query)=='string' and query~='' then suffix=suffix..'&Keyword='..HttpService:UrlEncode(query) end
  if type(cursor)=='string' and cursor~='' then suffix=suffix..'&Cursor='..HttpService:UrlEncode(cursor) end
  local raw=neo.emoteGet('https://catalog.roblox.com/v1/search/items/details?'..suffix)
  local source='Roblox'
  -- Le proxy est utilise uniquement si le domaine officiel est inaccessible par Delta.
  if not raw then
    raw=neo.emoteGet('https://catalog.roproxy.com/v1/search/items/details?'..suffix)
    source='RoProxy'
  end
  if not raw then return nil,'Connexion au catalogue indisponible (Delta / HTTP).'
  end
  local ok,data=pcall(function() return HttpService:JSONDecode(raw) end)
  if not ok or type(data)~='table' or type(data.data)~='table' then return nil,'Reponse catalogue invalide.' end
  local added=0
  for _,item in ipairs(data.data) do
    if type(item)=='table' and (tonumber(item.assetType)==61 or item.assetTypeName=='EmoteAnimation') then
      if neo.emoteAdd(item.name,item.id,item.animationId or item.animationid) then added=added+1 end
    end
  end
  neo.emoteDedupe()
  em.source=source
  local nextCursor=type(data.nextPageCursor)=='string' and data.nextPageCursor~='' and data.nextPageCursor or nil
  return nextCursor,added,#data.data
end
function neo.emoteBulkScan(maxPages)
  if neo.adminIsBlocked('emotes') then status('NEO ADMIN : EMOTES verrouillees.');return end
  if em.busy then status('Le catalogue est deja en cours de chargement.');return end
  if em.exhausted then status('Catalogue termine : '..#em.items..' emotes memorisees.');return end
  em.busy=true;em.cancelScan=false;em.scanToken=em.scanToken+1
  local token=em.scanToken
  em.error=nil
  task.spawn(function()
    local pages=0
    while active and em.busy and not em.cancelScan and em.scanToken==token and pages<(maxPages or 100) do
      local cursor,added,count=neo.emoteFetch(nil,em.cursor)
      if em.scanToken~=token or not active then return end
      if not count then em.error=added or 'HTTP indisponible';break end
      pages=pages+1;em.fetchedPages=em.fetchedPages+1
      em.cursor=cursor
      if not cursor then em.exhausted=true;break end
      if pages%25==0 then neo.emoteSave(true) end
      if pages%3==0 then status('Catalogue : '..#em.items..' emotes | '..pages..' pages chargees') end
      task.wait(.45)
    end
    if em.scanToken~=token then return end
    em.busy=false;neo.emoteSave(true)
    if not active then return end
    if em.error then
      status('Catalogue : '..#em.items..' emotes | '..em.error)
    else
      status('Catalogue : '..#em.items..' emotes reelles en cache. '..(em.exhausted and 'Termine.' or 'Reprise possible.'))
    end
    if selectedTab=='EMOTES' then showTab('EMOTES') end
  end)
end
function neo.emoteFindOnline(query)
  if em.busy then status('Arrete le chargement global pour chercher en ligne.');return end
  query=tostring(query or ''):gsub('^%s+',''):gsub('%s+$','')
  if query=='' then status('Entre un nom pour chercher dans le catalogue Roblox.');return end
  em.busy=true
  task.spawn(function()
    local cursor,added,count=neo.emoteFetch(query,nil)
    em.busy=false
    if count then
      neo.emoteSave(true)
      status('Recherche "'..query:sub(1,24)..'" : '..added..' ajouts sur '..count..' resultats. Recherche locale ensuite.')
    else status('Recherche impossible : '..tostring(added)) end
    if selectedTab=='EMOTES' and active then em.query=query;em.offset=0;showTab('EMOTES') end
  end)
end
function neo.emoteMatches()
  local list={}
  local q=string.lower(tostring(em.query or ''))
  for _,item in ipairs(em.items) do
    local fav=em.favorites[tostring(item.id)]==true
    if (em.view~='favorites' or fav) and
       (q=='' or string.find(string.lower(item.name),q,1,true) or string.find(tostring(item.id),q,1,true)) then
      list[#list+1]=item
    end
  end
  table.sort(list,function(a,b)
    local af=em.favorites[tostring(a.id)]==true
    local bf=em.favorites[tostring(b.id)]==true
    if af~=bf then return af end
    if a.name==b.name then return a.id<b.id end
    return string.lower(a.name)<string.lower(b.name)
  end)
  return list
end
-- ===== V6.4 : INTERFACE DANSES VIOLETTE, ISOLEE DES AUTRES ONGLETS =====
-- Les images viennent des miniatures d'emotes du catalogue officiel Roblox.
-- AUCUN chargement d'animation au seul affichage, et jamais plus de 12 vignettes/page.
function neo.emoteRender()
  if neo.emoteClear3D then neo.emoteClear3D();neo.emoteClear3D=nil end
  if neo.emoteScreen then neo.emoteScreen:Destroy() end
  em.pageSize=12
  local purple=Color3.fromRGB(168,74,250)
  local pale=Color3.fromRGB(223,198,255)
  local white=Color3.fromRGB(247,245,254)
  local gray=Color3.fromRGB(175,165,193)
  local dark=Color3.fromRGB(20,15,31)
  local tile=Color3.fromRGB(35,27,49)
  local selectedTile=Color3.fromRGB(67,35,92)
  local boundary=Color3.fromRGB(82,58,102)
  local screen=make('Frame',{
    Name='DansesViolettes_V64',Position=UDim2.fromOffset(6,6),
    Size=UDim2.new(1,-12,1,-12),BackgroundColor3=dark,
    BorderSizePixel=0,ClipsDescendants=true,ZIndex=2
  },main)
  neo.emoteScreen=screen
  corner(screen,13);stroke(screen,purple,1,.18)

  local function label(parent,msg,x,y,w,h,fontSize,color,bold)
    local obj=make('TextLabel',{
      BackgroundTransparency=1,Text=msg,TextSize=fontSize or 12,
      TextColor3=color or white,TextXAlignment=Enum.TextXAlignment.Left,
      TextYAlignment=Enum.TextYAlignment.Center,TextTruncate=Enum.TextTruncate.AtEnd,
      Font=bold and Enum.Font.GothamBold or Enum.Font.GothamMedium,
      Size=UDim2.fromOffset(w,h),Position=UDim2.fromOffset(x,y),ZIndex=4
    },parent)
    return obj
  end
  local function action(parent,title,fn,background)
    local obj=make('TextButton',{
      Text=title,TextColor3=white,TextSize=11,Font=Enum.Font.GothamBold,
      TextTruncate=Enum.TextTruncate.AtEnd,BackgroundColor3=background or tile,
      AutoButtonColor=true,BorderSizePixel=0,ZIndex=6
    },parent)
    corner(obj,9)
    obj.MouseButton1Click:Connect(function()
      if not active or selectedTab~='EMOTES' then return end
      local ok,err=pcall(fn)
      if not ok then status('Emotes : '..tostring(err):sub(1,95)) end
    end)
    return obj
  end
  local title=label(screen,'✦  DANSES / EMOTES',12,6,340,28,17,pale,true)
  local count=label(screen,'Catalogue : '..#em.items..' fiches  •  12 images/page',13,32,360,17,10,gray)
  local left=make('ScrollingFrame',{Name='Galerie',BackgroundTransparency=1,BorderSizePixel=0,
    CanvasSize=UDim2.fromOffset(0,0),ScrollBarThickness=2,ScrollingDirection=Enum.ScrollingDirection.Y,ZIndex=3},screen)
  local right=make('ScrollingFrame',{Name='Apercu',BackgroundColor3=Color3.fromRGB(31,21,46),
    BorderSizePixel=0,ZIndex=3,ClipsDescendants=true,
    CanvasSize=UDim2.fromOffset(0,0),ScrollBarThickness=2,
    ScrollBarImageColor3=purple,ScrollingDirection=Enum.ScrollingDirection.Y},screen)
  corner(right,11);stroke(right,purple,1,.36)

  local field=make('TextBox',{
    Name='ChercherUneDanse',Text=em.query or '',PlaceholderText='🔎 Nom ou ID...',ClearTextOnFocus=false,
    Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=white,
    PlaceholderColor3=gray,TextXAlignment=Enum.TextXAlignment.Left,
    BackgroundColor3=tile,BorderSizePixel=0,ZIndex=5
  },left)
  corner(field,9);stroke(field,boundary,1,.4)
  make('UIPadding',{PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,5)},field)
  local searchBtn=action(left,'⌕',function()
    em.query=field.Text;em.offset=0;em.gridScroll=0;showTab('EMOTES')
  end,purple)
  field.FocusLost:Connect(function()
    if active and selectedTab=='EMOTES' and field.Text~=em.query then
      em.query=field.Text;em.offset=0;em.gridScroll=0
      task.defer(function() if active and selectedTab=='EMOTES' then showTab('EMOTES') end end)
    end
  end)
  local tabs={}
  for _,mode in ipairs({{'all','Toutes'},{'favorites','★ Favoris'},{'known','ID connus'}}) do
    local thisMode=mode[1]
    tabs[#tabs+1]=action(left,mode[2],function()
      em.view=thisMode;em.offset=0;em.gridScroll=0;showTab('EMOTES')
    end,em.view==thisMode and purple or tile)
  end
  local results=neo.emoteMatches()
  if em.view=='known' then
    local filtered={}
    for _,item in ipairs(results) do
      if item.animId or item.direct then filtered[#filtered+1]=item end
    end
    results=filtered
  end
  if em.offset>=#results then
    em.offset=math.max(0,math.floor((#results-1)/em.pageSize)*em.pageSize)
  end
  local resultCount=label(left,#results..' résultats',1,77,220,16,10,gray)
  local gallery=make('ScrollingFrame',{
    Name='CartesEmotes',BackgroundTransparency=1,BorderSizePixel=0,
    CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ScrollBarThickness=3,ScrollBarImageColor3=purple,
    ScrollingDirection=Enum.ScrollingDirection.Y,ZIndex=4
  },left)
  local grid=make('UIGridLayout',{
    FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,
    HorizontalAlignment=Enum.HorizontalAlignment.Left,
    CellPadding=UDim2.fromOffset(5,6),CellSize=UDim2.fromOffset(90,105)
  },gallery)
  local previousPosition=em.gridScroll or 0
  task.defer(function()
    if active and neo.emoteScreen==screen then gallery.CanvasPosition=Vector2.new(0,previousPosition) end
  end)
  gallery:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
    if neo.emoteScreen==screen then em.gridScroll=gallery.CanvasPosition.Y end
  end)

  local pageBack=action(left,'◀',function()
    if em.offset>0 then em.offset=math.max(0,em.offset-em.pageSize);em.gridScroll=0;showTab('EMOTES') end
  end,tile)
  local pageCount=label(left,'Page 1 / 1',0,0,100,26,10,gray)
  pageCount.TextXAlignment=Enum.TextXAlignment.Center
  local pageNext=action(left,'▶',function()
    if em.offset+em.pageSize<#results then em.offset=em.offset+em.pageSize;em.gridScroll=0;showTab('EMOTES') end
  end,tile)
  local loadMore=action(left,em.busy and '⏸ Stop chargement' or '↓ Charger +',function()
    if em.busy then
      em.cancelScan=true;em.scanToken=em.scanToken+1;em.busy=false
      neo.emoteSave(true);status('Téléchargement emotes interrompu.')
      showTab('EMOTES')
    else neo.emoteBulkScan(100) end
  end,purple)
  local online=action(left,'🌐 Roblox',function()
    local q=field.Text
    if q=='' then status('Saisis un nom de danse avant la recherche en ligne.')
    else neo.emoteFindOnline(q) end
  end,tile)
  local addId=action(left,'+ ID',function()
    local catalog,anim=tostring(field.Text):match('^%s*(%d+)%s*:%s*(%d+)%s*$')
    local id=neo.emoteCleanId(catalog or field.Text)
    if not id then status('Entrer un ID ou catalogue:animation.');return end
    neo.emoteAdd('Emote #'..id,id,anim)
    em.query='';em.offset=0;em.gridScroll=0
    neo.emoteSave(true);showTab('EMOTES')
  end,tile)
  local addDirect=action(left,'+ Animation',function()
    local id=neo.emoteCleanId(field.Text)
    if not id then status('Entrer un ID numérique d animation.');return end
    neo.emoteAdd('Animation '..id,id,id,true)
    em.query='';em.offset=0;em.gridScroll=0
    neo.emoteSave(true);showTab('EMOTES')
  end,tile)
  local reset=action(left,'↻',function()
    if em.busy then status('Arrête le chargement avant de recommencer.');return end
    em.cursor=nil;em.exhausted=false;neo.emoteSave(true)
    neo.emoteBulkScan(100)
  end,tile)

  -- L'aperçu latéral utilise une seule miniature Roblox de 420 px.
  local previewTitle=label(right,'◉ APERÇU',10,5,180,25,12,pale,true)
  -- Vue 3D FACULTATIVE et chargee uniquement sur demande.
  -- La miniature statique reste disponible si Roblox refuse l'animation.
  local previewTrack=nil
  local preview3D=nil
  local function clear3D()
    if previewTrack then pcall(function() previewTrack:Stop(0);previewTrack:Destroy() end) end
    previewTrack=nil
    if preview3D then pcall(function() preview3D:Destroy() end) end
    preview3D=nil
  end
  neo.emoteClear3D=clear3D
  local imageFrame=make('Frame',{Name='CadreImage',BackgroundColor3=dark,
    BorderSizePixel=0,ZIndex=4,ClipsDescendants=true},right)
  corner(imageFrame,11)
  local selectedThumb=make('ImageLabel',{
    Name='MiniatureSelection',BackgroundTransparency=1,Image='',ScaleType=Enum.ScaleType.Fit,
    Size=UDim2.new(1,-12,1,-12),Position=UDim2.fromOffset(6,6),ZIndex=5
  },imageFrame)
  local preview3DBtn=action(right,'3D',function()
    local item=em.selectedItem
    if not item then return end
    local id=neo.emoteCleanId(item.animId or (item.direct and item.id))
    if not id then
      status('Aperçu 3D : ID d animation inconnu. Essaie de jouer la danse une fois.')
      return
    end
    local char=Local.Character
    if not char then status('Aperçu 3D : avatar indisponible.');return end
    clear3D()
    local oldArchivable=char.Archivable
    char.Archivable=true
    local ok,clone=pcall(function() return char:Clone() end)
    char.Archivable=oldArchivable
    if not ok or not clone then status('Aperçu 3D : clone du personnage refusé.');return end
    for _,obj in ipairs(clone:GetDescendants()) do
      if obj:IsA('LuaSourceContainer') or obj:IsA('Tool') or obj:IsA('ForceField') then
        obj:Destroy()
      elseif obj:IsA('BasePart') then
        obj.Anchored=false;obj.CanCollide=false
      end
    end
    local vp=make('ViewportFrame',{
      Name='Apercu3D',BackgroundTransparency=1,
      Size=UDim2.fromScale(1,1),ZIndex=6,
      Ambient=Color3.fromRGB(190,155,245),LightColor=Color3.fromRGB(245,220,255)
    },imageFrame)
    preview3D=vp
    local model=make('WorldModel',{},vp)
    local camera=make('Camera',{},vp)
    vp.CurrentCamera=camera
    clone.Parent=model
    local rootPart=clone:FindFirstChild('HumanoidRootPart')
    local humanoid=clone:FindFirstChildOfClass('Humanoid')
    if not rootPart or not humanoid then
      clear3D();status('Aperçu 3D : rig incompatible.');return
    end
    clone:PivotTo(CFrame.new(0,0,0))
    rootPart.Anchored=true
    camera.CFrame=CFrame.new(Vector3.new(0,2,-8),Vector3.new(0,2,0))
    local animator=humanoid:FindFirstChildOfClass('Animator')
    if not animator then animator=Instance.new('Animator');animator.Parent=humanoid end
    local anim=make('Animation',{AnimationId='rbxassetid://'..tostring(id)},vp)
    local loaded,track=pcall(function() return animator:LoadAnimation(anim) end)
    if not loaded or not track then
      clear3D();status('Aperçu 3D bloqué par Roblox pour cet ID.');return
    end
    previewTrack=track
    local started=pcall(function()
      track.Looped=true
      track.Priority=Enum.AnimationPriority.Action
      track:Play(.1,1,em.speed)
    end)
    if not started then clear3D();status('Aperçu 3D non disponible.');return end
    status('Aperçu 3D local lancé pour '..item.name..'.')
    task.delay(2,function()
      if active and neo.emoteScreen==screen and previewTrack==track and track.Length==0 then
        clear3D()
        status('Roblox refuse de charger cette danse dans l aperçu 3D.')
      end
    end)
  end,tile)
  local nameLbl=label(right,'Choisis une danse',10,0,160,39,13,white,true)
  nameLbl.TextWrapped=true
  local idLbl=label(right,'ID : -',10,0,160,19,10,gray)
  local playBtn=action(right,'▶ Jouer',function()
    local item=em.selectedItem
    if item then neo.emotePlay(item) else status('Choisis une danse.') end
  end,purple)
  local stopBtn=action(right,'■ Stop',function()
    neo.emoteStop();status('Danse arrêtée.')
  end,tile)
  local loopBtn
  loopBtn=action(right,'↻ Boucle : '..(em.loop and 'ON' or 'OFF'),function()
    em.loop=not em.loop
    if em.track then pcall(function() em.track.Looped=em.loop end) end
    loopBtn.Text='↻ Boucle : '..(em.loop and 'ON' or 'OFF')
  end,tile)
  local speedBtn
  speedBtn=action(right,'⚡ '..tostring(em.speed)..'×',function()
    local speeds={.5,1,1.25,1.5,2}
    local pos=1
    for i,n in ipairs(speeds) do if n==em.speed then pos=i;break end end
    em.speed=speeds[pos%#speeds+1]
    if em.track then pcall(function() em.track:AdjustSpeed(em.speed) end) end
    speedBtn.Text='⚡ '..tostring(em.speed)..'×'
  end,tile)
  local favBtn=action(right,'☆ Favori',function()
    local item=em.selectedItem
    if not item then return end
    local k=tostring(item.id)
    em.favorites[k]=not em.favorites[k]
    neo.emoteSave(true)
    local keep=item.id
    em.selectedId=keep
    showTab('EMOTES')
  end,tile)
  local previewInfo=label(right,'Image du catalogue Roblox',10,0,180,25,9,gray)
  local cards={}
  local function selectItem(item)
    clear3D()
    em.selectedItem=item
    em.selectedId=item and item.id or nil
    if item then
      nameLbl.Text=item.name
      idLbl.Text='ID : '..tostring(item.id)
      selectedThumb.Image='rbxthumb://type=Asset&id='..tostring(item.id)..'&w=420&h=420'
      favBtn.Text=(em.favorites[tostring(item.id)] and '★ Retirer favori' or '☆ Ajouter favori')
    else
      nameLbl.Text='Aucune danse';idLbl.Text='ID : -';selectedThumb.Image=''
      favBtn.Text='☆ Favori'
    end
    for _,pair in ipairs(cards) do
      pair.background.BackgroundColor3=(pair.item==item) and selectedTile or tile
      pair.border.Color=(pair.item==item) and purple or boundary
      pair.border.Transparency=(pair.item==item) and 0 or .73
    end
  end
  for index=em.offset+1,math.min(#results,em.offset+em.pageSize) do
    local item=results[index]
    local outer=make('Frame',{
      Name='Carte_'..tostring(item.id),BackgroundColor3=tile,
      BorderSizePixel=0,ClipsDescendants=true,LayoutOrder=index,ZIndex=5
    },gallery)
    corner(outer,10)
    local border=stroke(outer,boundary,1,.7)
    local tap=make('TextButton',{
      Name='Choisir',Text='',BackgroundTransparency=1,Size=UDim2.fromScale(1,1),
      ZIndex=6
    },outer)
    local thumbnail=make('ImageLabel',{
      Name='ImageEmote',BackgroundTransparency=1,Image='rbxthumb://type=Asset&id='..tostring(item.id)..'&w=150&h=150',
      ScaleType=Enum.ScaleType.Fit,Position=UDim2.fromOffset(6,4),
      Size=UDim2.new(1,-12,1,-33),ZIndex=6
    },outer)
    local caption=make('TextLabel',{
      Text=item.name,TextTruncate=Enum.TextTruncate.AtEnd,
      Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=white,
      TextXAlignment=Enum.TextXAlignment.Center,BackgroundTransparency=1,
      Position=UDim2.new(0,3,1,-28),Size=UDim2.new(1,-6,0,24),ZIndex=7
    },outer)
    local star=make('TextButton',{
      Text=em.favorites[tostring(item.id)] and '★' or '☆',
      TextSize=17,Font=Enum.Font.GothamBold,TextColor3=pale,
      BackgroundColor3=dark,BackgroundTransparency=.22,BorderSizePixel=0,
      Size=UDim2.fromOffset(23,23),Position=UDim2.new(1,-25,0,2),ZIndex=8
    },outer);corner(star,8)
    tap.MouseButton1Click:Connect(function() selectItem(item) end)
    star.MouseButton1Click:Connect(function()
      local k=tostring(item.id)
      em.favorites[k]=not em.favorites[k]
      star.Text=em.favorites[k] and '★' or '☆'
      neo.emoteSave(true)
      if em.selectedItem==item then favBtn.Text=em.favorites[k] and '★ Retirer favori' or '☆ Ajouter favori' end
      if em.view=='favorites' then showTab('EMOTES') end
    end)
    cards[#cards+1]={item=item,background=outer,border=border}
  end
  if #results==0 then
    label(gallery,'Aucune danse trouvée. Essaie « Charger + ».',4,10,275,43,11,gray)
  end
  local initial=nil
  for _,pair in ipairs(cards) do
    if pair.item.id==em.selectedId then initial=pair.item;break end
  end
  if not initial and cards[1] then initial=cards[1].item end
  selectItem(initial)
  pageCount.Text='Page '..(math.floor(em.offset/em.pageSize)+1)..' / '..math.max(1,math.ceil(#results/em.pageSize))

  -- Mise en page adaptative dans le panneau principal EXISTANT uniquement.
  -- Les autres categories, le sidebar, le farm et l'admin restent identiques.
  neo.emoteReflow=function()
    if not active or neo.emoteScreen~=screen then return end
    local w=math.max(210,screen.AbsoluteSize.X)
    local h=math.max(220,screen.AbsoluteSize.Y)
    local gap=8
    local rightW=(w>=590 and 190 or (w>=440 and 165 or math.max(100,math.floor(w*.37))))
    local leftW=math.max(110,w-rightW-gap-23)
    local rightX=leftW+gap+12
    left.Position=UDim2.fromOffset(12,56)
    left.Size=UDim2.new(0,leftW,1,-66)
    right.Position=UDim2.fromOffset(rightX,53)
    right.Size=UDim2.new(0,rightW,1,-63)
    title.TextSize=w<340 and 13 or 17
    title.Size=UDim2.new(1,-15,0,26)
    preview3DBtn.Position=UDim2.new(1,-44,0,5)
    preview3DBtn.Size=UDim2.fromOffset(36,25)
    previewTitle.Size=UDim2.new(1,-56,0,25)
    count.Size=UDim2.new(1,-15,0,15)
    field.Position=UDim2.fromOffset(0,0)
    field.Size=UDim2.new(1,-36,0,35)
    searchBtn.Position=UDim2.new(1,-32,0,0)
    searchBtn.Size=UDim2.fromOffset(32,35)
    for i,b in ipairs(tabs) do
      local xx=math.floor((i-1)*(leftW/3))
      b.Position=UDim2.fromOffset(xx,42)
      b.Size=UDim2.fromOffset(math.floor(leftW/3)-3,29)
      b.TextSize=leftW<240 and 9 or 11
      b.Text=(leftW<180 and ({'Tout','★','ID ✓'})[i]) or ({'Toutes','★ Favoris','ID connus'})[i]
    end
    loadMore.Text=leftW<180 and (em.busy and '⏸' or '↓ +') or (em.busy and '⏸ Stop chargement' or '↓ Charger +')
    online.Text=leftW<180 and '🌐' or '🌐 Roblox'
    addDirect.Text=leftW<180 and '+ Anim' or '+ Animation'
    resultCount.Size=UDim2.new(1,-3,0,16)
    gallery.Position=UDim2.fromOffset(0,97)
    local cols=leftW>=395 and 3 or (leftW>=210 and 2 or 1)
    local cardWidth=math.max(68,math.floor((leftW-3-(cols-1)*5)/cols))
    local cardHeight=leftW<250 and 94 or 110
    grid.FillDirectionMaxCells=cols
    grid.CellSize=UDim2.fromOffset(cardWidth,cardHeight)
    local leftH=h-66
    local pagerY
    if leftH<350 then
      -- Ecran en paysage bas : panneau gauche entierement defilant.
      -- Les cartes et les controles restent tous accessibles.
      local rows=math.ceil(math.min(em.pageSize,math.max(1,#results-em.offset))/cols)
      local galleryH=math.max(86,rows*(cardHeight+6)+6)
      gallery.Size=UDim2.fromOffset(leftW-3,galleryH)
      gallery.ScrollingEnabled=false
      left.ScrollingEnabled=true
      pagerY=97+galleryH+8
      left.CanvasSize=UDim2.fromOffset(0,pagerY+105)
    else
      -- Ecran confortable : apercu fixe et galerie defilante.
      pagerY=leftH-103
      gallery.Size=UDim2.new(1,-3,0,math.max(85,pagerY-104))
      gallery.ScrollingEnabled=true
      left.ScrollingEnabled=false
      left.CanvasSize=UDim2.fromOffset(0,0)
    end
    pageBack.Position=UDim2.fromOffset(0,pagerY)
    pageBack.Size=UDim2.fromOffset(35,28)
    pageCount.Position=UDim2.fromOffset(39,pagerY)
    pageCount.Size=UDim2.new(1,-82,0,28)
    pageNext.Position=UDim2.new(1,-35,0,pagerY)
    pageNext.Size=UDim2.fromOffset(35,28)
    local row1=pagerY+34
    loadMore.Position=UDim2.fromOffset(0,row1)
    loadMore.Size=UDim2.new(.61,-3,0,28)
    online.Position=UDim2.new(.61,2,0,row1)
    online.Size=UDim2.new(.39,-2,0,28)
    local row2=row1+34
    addId.Position=UDim2.fromOffset(0,row2)
    addId.Size=UDim2.new(.31,-2,0,28)
    addDirect.Position=UDim2.new(.31,1,0,row2)
    addDirect.Size=UDim2.new(.53,-3,0,28)
    reset.Position=UDim2.new(.84,2,0,row2)
    reset.Size=UDim2.new(.16,-2,0,28)
    -- Espace preview: vignette, texte, boutons et parametres.
    local thumbH=math.min(math.max(83,rightW-20),math.max(84,math.floor((h-88)*.40)))
    imageFrame.Position=UDim2.fromOffset(8,31)
    imageFrame.Size=UDim2.new(1,-16,0,thumbH)
    local afterThumb=thumbH+37
    nameLbl.Position=UDim2.fromOffset(9,afterThumb)
    nameLbl.Size=UDim2.new(1,-18,0,31)
    nameLbl.TextSize=rightW<135 and 10 or 12
    idLbl.Position=UDim2.fromOffset(9,afterThumb+31)
    idLbl.Size=UDim2.new(1,-18,0,17)
    local btnY=afterThumb+52
    local compactRight=rightW<145
    local half=math.floor((rightW-22)/2)
    if compactRight then
      playBtn.Position=UDim2.fromOffset(8,btnY)
      playBtn.Size=UDim2.new(1,-16,0,31)
      stopBtn.Position=UDim2.fromOffset(8,btnY+34)
      stopBtn.Size=UDim2.new(1,-16,0,31)
    else
      playBtn.Position=UDim2.fromOffset(8,btnY)
      playBtn.Size=UDim2.fromOffset(half,33)
      stopBtn.Position=UDim2.fromOffset(half+14,btnY)
      stopBtn.Size=UDim2.fromOffset(half,33)
    end
    local offset=compactRight and 33 or 0
    loopBtn.Position=UDim2.fromOffset(8,btnY+39+offset)
    loopBtn.Size=UDim2.new(.62,-9,0,29)
    speedBtn.Position=UDim2.new(.62,1,0,btnY+39+offset)
    speedBtn.Size=UDim2.new(.38,-9,0,29)
    favBtn.Position=UDim2.fromOffset(8,btnY+74+offset)
    favBtn.Size=UDim2.new(1,-16,0,30)
    previewInfo.Position=UDim2.fromOffset(9,btnY+108+offset)
    previewInfo.Size=UDim2.new(1,-18,0,20)
    previewInfo.TextSize=9
    right.CanvasSize=UDim2.fromOffset(0,btnY+136+offset)
    right.ScrollingEnabled=(btnY+136+offset)>right.AbsoluteSize.Y
  end
  neo.emoteReflow()
  task.defer(function() if active and neo.emoteScreen==screen then neo.emoteReflow() end end)
  screen:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
    if active and neo.emoteScreen==screen then neo.emoteReflow() end
  end)
end
-- ===== FIN V6.4 UI DANSES =====
-- ===== FIN MODULE EMOTES =====

-- ===== NEO ADMIN : IMMOBILISATION LOCALE DE COPIE COMPATIBLE =====
-- Aucune autorite sur le serveur Roblox et aucun effet garanti sur des clients externes.
neo.adminFreezeCtl={root=nil,humanoid=nil,anchor=nil,walk=nil,jump=nil,autoRotate=nil}
function neo.adminFreezeMovement(blocked)
  local ctl=neo.adminFreezeCtl
  if not blocked then
    if ctl.root and ctl.root.Parent and ctl.anchor~=nil then
      pcall(function() ctl.root.Anchored=ctl.anchor end)
    end
    if ctl.humanoid and ctl.humanoid.Parent then
      pcall(function()
        if ctl.walk~=nil then ctl.humanoid.WalkSpeed=ctl.walk end
        if ctl.jump~=nil then ctl.humanoid.JumpPower=ctl.jump end
        if ctl.autoRotate~=nil then ctl.humanoid.AutoRotate=ctl.autoRotate end
      end)
    end
    ctl.root=nil;ctl.humanoid=nil;ctl.anchor=nil;ctl.walk=nil;ctl.jump=nil;ctl.autoRotate=nil
    neo.suppressManualMovement(false)
    return
  end
  if not neo.adminIsBlocked('freezeMove') then return end
  local r,h=root(Local),hum(Local)
  if not r or not h or h.Health<=0 then return end
  if ctl.root~=r then
    -- Restoration des anciennes refs si le personnage change.
    if ctl.root and ctl.root.Parent and ctl.anchor~=nil then
      pcall(function() ctl.root.Anchored=ctl.anchor end)
    end
    ctl.root=r;ctl.humanoid=h;ctl.anchor=r.Anchored
    ctl.walk=h.WalkSpeed;ctl.jump=h.JumpPower;ctl.autoRotate=h.AutoRotate
  end
  pcall(function()
    r.AssemblyLinearVelocity=Vector3.zero
    r.AssemblyAngularVelocity=Vector3.zero
    r.Anchored=true
    h.WalkSpeed=0
    h.JumpPower=0
    h.AutoRotate=false
  end)
end
-- ===== FIN IMMOBILISATION =====

-- ===== NEO V6.3 : PANNEAU ADMIN / CHAT-RELAY EXPERIMENTAL =====
-- Format court MOD / OK v1 : commandes et confirmations de 3 chiffres, ciblage et controle de l'emetteur.
-- Les commandes sont envoyees dans le canal de chat du JEU (elles sont publiques).
-- Seul le veritable UserId du joueur Roblox @0din01 peut etre source de commandes.
-- Un autre exploit, une copie modifiee, un chat filtre ou ferme contourne ce systeme.
local adminGroups={
  {name='SHERIF / MEURTRIER',features={
    {'shoot','SHOOT manuel YARHM'},{'autoShoot','Tir automatique'},
    {'aim','Aimbot'},{'triggerBot','Trigger Bot'},{'prediction','Prediction du tir'},
    {'autoEquipGun','Auto-equiper gun'},{'knifeAura','Knife Aura'},{'killAll','Kill All'},
    {'combatPosition','Position de combat'}
  }},
  {name='DEPLACEMENTS',features={
    {'speed','Speed'},{'jump','Jump'},{'infiniteJump','Jump Spam / Saut infini'},
    {'noclip','Noclip'},{'manualFly','OP Fly YARHM (manuel)'},{'flyNoclipAuto','Vol automatique'},
    {'freezeMove','Immobiliser / liberer le joueur'},
    {'freecam','Freecam'},{'followPlayer','Suivre joueur'},
    {'teleport','Teleportation'},
    {'tpMap','TP vers la map'},{'tpLobby','TP vers le lobby'}
  }},
  {name='FARM / SURVIE',features={
    {'autoFarm','Farm bonbons'},{'autoRoles','Auto tous rôles'},{'farmUnderground','Farm sous-sol'},
    {'autoGrab','Ramasser le pistolet'},{'coinRadar','Radar bonbons'},
    {'autoEscape','Fuite automatique'},{'escapeRoute','Trace de fuite'},
    {'threatMeter','Indicateur de danger'},{'safeScan','Zone sure'}
  }},
  {name='JOUEURS / ACTIONS',features={
    {'fling','Fling YARHM'},{'attachPlayer','Attach Player'},
    {'bodyBlock','Body Block'},{'spectate','Spectate'}
  }},
  {name='AFFICHAGE / EXTRA',features={
    {'esp','ESP joueurs'},{'gunESP','ESP gun'},{'bright','FullBright'},
    {'emotes','Danses et emotes'},{'clone','Faux clone'},
    {'antiAfk','Anti AFK'},{'murderTrail','Trace murderer'},
    {'dangerAlert','Alerte danger'},{'notifications','Notifications'}
  }}
}
neo.adminValidFeatures={ALL=true}
for _,group in ipairs(adminGroups) do
  for _,entry in ipairs(group.features) do neo.adminValidFeatures[entry[1]]=true end
end
-- On ne manipule jamais les vrais droits du jeu ni les autres scripts.
function neo.adminStopFeature(key)
  if key=='ALL' then
    neo.panic()
    if neo.emotes then
      neo.emotes.cancelScan=true
      neo.emotes.scanToken=neo.emotes.scanToken+1
      neo.emotes.busy=false
      neo.emoteStop()
    end
    return
  end
  if state[key]~=nil and type(state[key])=='boolean' then state[key]=false end
  if key=='autoRoles' and neo.autoRoleStop then neo.autoRoleStop('verrou ADMIN') end
  if key=='shoot' or key=='autoShoot' then
    shotCtl.token=shotCtl.token+1;shotBusy=false;state.autoShoot=false
  elseif key=='fling' then
    flingStop=true
  elseif key=='attachPlayer' then
    neo.detachPlayer('verrou ADMIN')
  elseif key=='bodyBlock' then
    bodyBlock.stop('verrou ADMIN')
  elseif key=='freecam' or key=='spectate' then
    neo.returnCameraToBody()
  elseif key=='followPlayer' then
    state.followPlayer=false;followTarget=nil
  elseif key=='manualFly' then
    neo.stopManualFly()
  elseif key=='freezeMove' then
    -- Stopper les pilotes de cette copie avant de l'immobiliser localement.
    neo.stopManualFly()
    state.autoFarm=false;state.autoEscape=false;state.followPlayer=false
    autoNav.halt();neo.stopGhost();neo.suppressManualMovement(false)
    neo.adminFreezeMovement(true)
  elseif key=='autoFarm' or key=='flyNoclipAuto' or key=='autoEscape' then
    if key=='autoFarm' then state.autoFarm=false end
    if key=='autoEscape' then state.autoEscape=false;autoNav.resetEscape() end
    autoNav.halt();neo.stopGhost()
  elseif key=='killAll' then
    killAllToken=killAllToken+1
  elseif key=='emotes' and neo.emotes then
    neo.emotes.cancelScan=true
    neo.emotes.scanToken=neo.emotes.scanToken+1
    neo.emotes.busy=false
    neo.emoteStop()
  elseif key=='clone' then
    neo.deleteClone()
  end
  if key=='speed' or key=='jump' then neo.refreshMovement() end
  if key=='noclip' then restoreNoclip() end
  if key=='bright' then toggleLighting() end
  if key=='esp' or key=='gunESP' then neo.refreshESP() end
  neo.saveOptions()
end
function neo.adminApply(key,blocked)
  if not neo.adminValidFeatures[key] then return false end
  if key=='ALL' and not blocked then
    -- Debloquer tout doit aussi effacer les restrictions individuelles.
    neo.adminBlocked={}
  else
    neo.adminBlocked[key]=blocked or nil
  end
  neo.adminHasRestrictions=false
  for feature,yes in pairs(neo.adminBlocked) do
    if yes then neo.adminHasRestrictions=true;break end
  end
  if blocked then neo.adminStopFeature(key) end
  if (key=='freezeMove' and not blocked) or (key=='ALL' and not blocked) then
    neo.adminFreezeMovement(false)
  end
  return true
end
-- Un message peut etre filtre, transforme ou ne jamais parvenir aux autres clients.
function neo.adminSendRaw(message,silent)
  local sent=false;local why='Canal de chat absent'
  local channels=TextChatService:FindFirstChild('TextChannels')
  local general=channels and channels:FindFirstChild('RBXGeneral')
  if general then
    local ok,result=pcall(function() return general:SendAsync(message) end)
    if ok and result and result.Status==Enum.TextChatMessageStatus.Success then
      sent=true
    elseif ok and result then
      why='Etat Roblox : '..tostring(result.Status)
    else
      why=tostring(result)
    end
  else
    -- API legacy uniquement si le chat moderne est absent.
    local ev=RS:FindFirstChild('DefaultChatSystemChatEvents')
    local send=ev and ev:FindFirstChild('SayMessageRequest')
    if send and send:IsA('RemoteEvent') then
      local ok,err=pcall(function() send:FireServer(message,'All') end)
      if ok then sent=true else why=tostring(err) end
    end
  end
  if not sent and not silent then status('ADMIN : envoi refuse ou impossible. '..tostring(why):sub(1,75)) end
  return sent,why
end
-- Protocole court MOD v1. Le code d'action a 3 chiffres :
-- 000 : test; 100/200 : tout; 101 Fly, 102 Speed, 103 Kill All; 104/204 immobiliser/liberer.
-- MOD <action> <cible> <nonce> ; le destinataire repond OK <nonce>.
-- Le tag cible est calcule depuis son UserId (3 chiffres), avec refus des collisions.
-- La source est toujours verifiee via le UserId du chat, pas le texte du message.
neo.adminCodes={['000']={key='PING',blocked=false}}
neo.adminActionCodes={['PING']='000',['ALL:1']='100',['ALL:0']='200'}
neo.adminCodes['100']={key='ALL',blocked=true}
neo.adminCodes['200']={key='ALL',blocked=false}
do
  local preferred={manualFly=1,speed=2,killAll=3,freezeMove=4}
  local index=4
  for _,group in ipairs(adminGroups) do
    for _,entry in ipairs(group.features) do
      local key=entry[1]
      local number=preferred[key]
      if not number then index=index+1;number=index end
      local block=string.format('%03d',100+number)
      local unblock=string.format('%03d',200+number)
      neo.adminCodes[block]={key=key,blocked=true}
      neo.adminCodes[unblock]={key=key,blocked=false}
      neo.adminActionCodes[key..':1']=block
      neo.adminActionCodes[key..':0']=unblock
    end
  end
end
function neo.adminTargetTag(player)
  if not player or not player.UserId then return nil end
  local tag=(player.UserId%900)+100
  for _,other in ipairs(Players:GetPlayers()) do
    if other~=player and ((other.UserId%900)+100)==tag then return nil end
  end
  return string.format('%03d',tag)
end
function neo.adminProcessChat(raw,senderId)
  if type(raw)~='string' or type(senderId)~='number' then return end
  local code,targetTag,seq=raw:match('^MOD%s+(%d%d%d)%s+(%d%d%d)%s+(%d%d%d)$')
  if code then
    local command=neo.adminCodes[code]
    if not command or not active or senderId==Local.UserId then return end
    local source=Players:GetPlayerByUserId(senderId)
    if not source or string.lower(source.Name)~=adminOwnerName then return end
    if neo.adminTargetTag(Local)~=targetTag then return end
    local dedupe=tostring(senderId)..':'..seq
    local seen=neo.adminReceivedCommands[dedupe]
    local now=os.clock()
    if seen and now-seen.at<45 then
      if seen.code~=code then return end
    else
      if command.key~='PING' then
        if not neo.adminApply(command.key,command.blocked) then return end
        status('ADMIN : '..command.key..(command.blocked and ' BLOQUE' or ' REACTIVE'))
      end
      neo.adminReceivedCommands[dedupe]={at=now,code=code}
    end
    -- Confirmation publique tres courte ; peut aussi etre filtree par Roblox.
    task.spawn(function()
      if active then neo.adminSendRaw('OK '..seq,true) end
    end)
    return
  end
  if not isAdminOwner then return end
  local ackSeq=raw:match('^OK%s+(%d%d%d)$')
  if not ackSeq then return end
  local source=Players:GetPlayerByUserId(senderId)
  local pending=neo.adminLastSent[ackSeq]
  if not source or not pending or pending.target~=senderId then return end
  if pending.confirmed then return end
  pending.confirmed=true
  if pending.key~='PING' then
    neo.adminSelectedModes=neo.adminSelectedModes or {}
    neo.adminSelectedModes[tostring(senderId)..':'..pending.key]=pending.blocked
    if pending.key=='ALL' and not pending.blocked then
      for _,group in ipairs(adminGroups) do
        for _,entry in ipairs(group.features) do
          neo.adminSelectedModes[tostring(senderId)..':'..entry[1]]=false
        end
      end
    end
  end
  neo.adminLastStatus='@'..source.Name..' : '..pending.key..' CONFIRME'
  status('ADMIN : '..neo.adminLastStatus)
end
-- Seul le chat du joueur est pris comme source, jamais un texte declare par autrui.
local receiveChatConnection
local receivedChatOK=pcall(function()
  receiveChatConnection=connect(TextChatService.MessageReceived,function(msg)
    if not active or not msg or not msg.TextSource then return end
    neo.adminProcessChat(msg.Text,msg.TextSource.UserId)
  end)
end)
-- Ecouter aussi le chat historique : certains jeux gardent les deux API.
-- Le numero seq empeche qu'une meme commande soit appliquee deux fois.
local function watchLegacyPlayer(p)
  pcall(function()
    connect(p.Chatted,function(message)
      if active then neo.adminProcessChat(message,p.UserId) end
    end)
  end)
end
for _,p in ipairs(Players:GetPlayers()) do watchLegacyPlayer(p) end
connect(Players.PlayerAdded,watchLegacyPlayer)
-- Controle leger : empeche les autres boutons du meme HUB de relancer une option.
task.spawn(function()
  while active do
    if neo.adminHasRestrictions then
      if neo.adminBlocked.freezeMove then neo.adminFreezeMovement(true) end
      for key,blocked in pairs(neo.adminBlocked) do
        if blocked and key~='ALL' and state[key]==true then
          neo.adminStopFeature(key)
        end
      end
      if neo.adminBlocked.ALL then
        for k,v in pairs(state) do
          if v==true and neo.adminValidFeatures[k] then neo.adminStopFeature(k) end
        end
      end
    end
    task.wait(.8)
  end
end)
function neo.adminSendCommand(target,key,wantBlocked)
  if not isAdminOwner then status('ADMIN : réservé au compte @0din01.');return end
  if not target or target==Local or target.Parent~=Players or (key~='PING' and not neo.adminValidFeatures[key]) then
    status('ADMIN : joueur ou option indisponible.');return
  end
  local tag=neo.adminTargetTag(target)
  if not tag then
    status('ADMIN : code destinataire en conflit, impossible de cibler sans risque.');return
  end
  local code=(key=='PING') and '000' or neo.adminActionCodes[key..':'..(wantBlocked and '1' or '0')]
  if not code then status('ADMIN : code option indisponible.');return end
  local seq
  for _=1,900 do
    neo.adminSerial=neo.adminSerial+1
    seq=string.format('%03d',(neo.adminSerial%900)+100)
    if not neo.adminLastSent[seq] then break end
  end
  if neo.adminLastSent[seq] then status('ADMIN : trop de commandes en cours.');return end
  local record={target=target.UserId,key=key,blocked=wantBlocked,confirmed=false,attempts=0}
  neo.adminLastSent[seq]=record
  neo.adminLastStatus='@'..target.Name..' : '..key..' EN ATTENTE'
  -- Message court : MOD 101 456 123, reponse : OK 123.
  local msg='MOD '..code..' '..tag..' '..seq
  task.spawn(function()
    for attempt=1,2 do
      if not active or record.confirmed or target.Parent~=Players then break end
      record.attempts=attempt
      local sent,why=neo.adminSendRaw(msg,true)
      if not sent then record.lastError=why else record.lastError=nil end
      if record.confirmed then break end
      task.wait(4)
    end
    if not active then return end
    if not record.confirmed then
      neo.adminLastStatus='@'..target.Name..' : '..key..' NON CONFIRME'
      status('ADMIN : aucune confirmation de @'..target.Name..' ('..tostring(record.lastError or 'chat non recu / non compatible')..').')
    end
    neo.adminLastSent[seq]=nil
  end)
end
function neo.adminRenderTab()
  if not isAdminOwner then
    section('ACCES REFUSE')
    note('Le panneau est reserve a @0din01.')
    return
  end
  section('🛡  ADMIN  •  @0din01')
  note('Selectionne une copie NEO compatible. Les boutons restent inchanges tant que la cible ne confirme pas la commande.')
  note('Protocole court : MOD 101 456 123 / OK 123. La cible ne confirme que si elle applique la commande. Roblox peut encore filtrer le chat.')
  if not neo.adminSelected or neo.adminSelected.Parent~=Players then
    section('SELECTIONNE UN JOUEUR')
    for _,player in ipairs(Players:GetPlayers()) do
      if player~=Local then
        local p=player
        button('@'..p.Name..'   •   '..p.DisplayName..'  ›',function()
          neo.adminSelected=p;showTab('ADMIN')
        end)
      end
    end
    button('ACTUALISER LES JOUEURS',function() showTab('ADMIN') end,hue.primary)
    return
  end
  local target=neo.adminSelected
  section('CIBLE  •  @'..target.Name)
  note('UserId : '..target.UserId..' | MOD court : reponse OK sur les copies compatibles.')
  note(neo.adminLastStatus or 'Statut : aucun test effectue')
  button('📡  TESTER LA COMMUNICATION AVEC CE JOUEUR',function()
    neo.adminSendCommand(target,'PING',false)
  end,hue.primary)
  button('←  CHANGER DE JOUEUR',function()
    neo.adminSelected=nil;showTab('ADMIN')
  end,hue.primary)
  button('🔒  TOUT BLOQUER SUR SA COPIE NEO',function()
    neo.adminSendCommand(target,'ALL',true)
    showTab('ADMIN')
  end,hue.red)
  button('🔓  TOUT DEBLOQUER SUR SA COPIE NEO',function()
    neo.adminSendCommand(target,'ALL',false)
    showTab('ADMIN')
  end,hue.primary)
  for _,group in ipairs(adminGroups) do
    section(group.name)
    for _,entry in ipairs(group.features) do
      local key,caption=entry[1],entry[2]
      local expected=(neo.adminSelectedModes and
        (neo.adminSelectedModes[tostring(target.UserId)..':'..key]==true or
         neo.adminSelectedModes[tostring(target.UserId)..':ALL']==true)) or false
      button((key=='freezeMove' and (expected and '🔓  LIBÉRER LE JOUEUR' or '🔒  IMMOBILISER LE JOUEUR')) or
        ((expected and '🔓  RÉACTIVER : ' or '🔒  BLOQUER : ')..caption),function()
        if neo.adminSelectedModes and neo.adminSelectedModes[tostring(target.UserId)..':ALL']==true then
          status('Debloque TOUT d abord pour liberer une fonction seule.')
          return
        end
        neo.adminSendCommand(target,key,not expected)
        task.defer(function() if active and selectedTab=='ADMIN' then
          local old=content.CanvasPosition
          showTab('ADMIN')
          task.defer(function() if active and selectedTab=='ADMIN' then content.CanvasPosition=old end end)
        end end)
      end,expected and hue.primary or nil)
    end
  end
  note('Un blocage n est affiche que s il a ete confirme par le client cible. Version incompatible, chat filtre ou modifie : aucune garantie. Pas de droit admin serveur.')
end
-- ===== FIN NEO ADMIN =====

-- ===== NEO V6.6 : TELEPORTATIONS MANUELLES MAP / LOBBY =====
-- Points connus de MM2 : workspace.Lobby.Spawns.Spawn et
-- la map active (modele possedant Spawns). Ne jamais TP a (0,0,0) par defaut.
function neo.tpIsLobbyDescendant(inst)
  local node=inst
  while node and node~=workspace do
    if string.find(string.lower(node.Name),'lobby',1,true) then return true end
    node=node.Parent
  end
  return false
end
function neo.tpPickSpawn(container)
  if not container then return nil end
  if container:IsA('BasePart') then return container end
  -- Spawns est en general un Folder/Model contenant des BaseParts.
  local spawns=container:FindFirstChild('Spawns') or container:FindFirstChild('SpawnLocations')
    or container:FindFirstChild('SpawnPoints')
  if not spawns and container~=workspace then
    spawns=container:FindFirstChild('Spawns',true)
      or container:FindFirstChild('SpawnLocations',true)
      or container:FindFirstChild('SpawnPoints',true)
  end
  if spawns and spawns:IsA('BasePart') then return spawns end
  local holder=spawns or container
  local best,bestScore=nil,-math.huge
  -- Trie implicitement par pertinence, sans teleporter vers une piece de decor.
  for _,item in ipairs(holder:GetDescendants()) do
    if item:IsA('BasePart') then
      local name=string.lower(item.Name)
      local score=0
      if name=='spawn' then score=100
      elseif name=='spawnlocation' then score=95
      elseif name=='spawnpoint' or name=='playerspawn' then score=90
      elseif string.find(name,'spawn',1,true) then score=65
      elseif spawns then score=30 end
      if item:IsA('SpawnLocation') then score=score+15 end
      if score>bestScore and score>0 then best,bestScore=item,score end
    end
  end
  return best
end
function neo.tpFindLobby()
  local lobby=workspace:FindFirstChild('Lobby')
  if not lobby then
    for _,obj in ipairs(workspace:GetChildren()) do
      if string.find(string.lower(obj.Name),'lobby',1,true) then lobby=obj;break end
    end
  end
  if not lobby then return nil,'Lobby absent de Workspace' end
  -- Chemin MM2 historique exact : Lobby.Spawns.Spawn.
  local folder=lobby:FindFirstChild('Spawns')
  local exact=folder and (folder:FindFirstChild('Spawn') or folder:FindFirstChild('SpawnLocation'))
  if exact and exact:IsA('BasePart') then return exact.CFrame*CFrame.new(0,3,0) end
  local part=neo.tpPickSpawn(lobby)
  if part then return part.CFrame*CFrame.new(0,3,0) end
  return nil,'Point de spawn du lobby introuvable'
end
function neo.tpFindMap()
  -- Recherche d'abord le modele de carte MM2 instancie pour la manche en cours.
  -- Cette detection ne cible jamais les personnages ni le Lobby.
  local bestPart,bestScore,bestName=nil,-math.huge,nil
  for _,obj in ipairs(workspace:GetChildren()) do
    if (obj:IsA('Model') or obj:IsA('Folder')) and not neo.tpIsLobbyDescendant(obj)
      and not Players:GetPlayerFromCharacter(obj) then
      local spawns=obj:FindFirstChild('Spawns')
      local nested=obj:FindFirstChild('Map')
      if not spawns and nested then spawns=nested:FindFirstChild('Spawns',true) end
      if not spawns and (string.lower(obj.Name)=='map' or string.lower(obj.Name)=='normal') then
        spawns=obj:FindFirstChild('Spawns',true)
      end
      if spawns then
        local spawn=neo.tpPickSpawn(spawns)
        if spawn then
          local score=100
          if obj:FindFirstChild('CoinContainer',true) then score=score+20 end
          if obj:FindFirstChild('GunDrop',true) then score=score+5 end
          if score>bestScore then bestPart,bestScore,bestName=spawn,score,obj.Name end
        end
      end
    end
  end
  if bestPart then return bestPart.CFrame*CFrame.new(0,3,0),bestName end
  -- Plan B : veritable piece de la manche, situee dans CoinContainer.
  -- Ne jamais utiliser une position inventee : si aucun signal, refuser le TP.
  local container=workspace:FindFirstChild('CoinContainer',true)
  if container and not neo.tpIsLobbyDescendant(container) then
    local activePickup=nil
    for _,obj in ipairs(container:GetDescendants()) do
      if obj:IsA('BasePart') and neo.isLivePickup(obj) then
        activePickup=obj;break
      end
    end
    if activePickup then
      return CFrame.new(activePickup.Position+Vector3.new(0,3,0)),'CoinContainer'
    end
  end
  return nil,'Map active ou point de spawn introuvable (attends la manche)'
end
function neo.tpTravel(destination)
  local option=(destination=='map') and 'tpMap' or 'tpLobby'
  if neo.adminIsBlocked('teleport') or neo.adminIsBlocked(option) then
    status('NEO ADMIN : '..(destination=='map' and 'TP MAP' or 'TP LOBBY')..' verrouille.')
    return false
  end
  local model=char(Local)
  if not alive(Local) or not model then
    status('TP : attends de reapparaitre avec un personnage vivant.')
    return false
  end
  local goal,label
  if destination=='map' then goal,label=neo.tpFindMap()
  else goal,label=neo.tpFindLobby() end
  if not goal then
    status('TP '..(destination=='map' and 'MAP' or 'LOBBY')..' : '..tostring(label))
    return false
  end
  -- Interrompre les automatismes en cours qui annuleraient immediatement un TP manuel.
  neo.stopManualFly()
  state.autoFarm=false;state.autoEscape=false;state.followPlayer=false;followTarget=nil
  autoNav.halt();autoNav.resetEscape();neo.stopGhost()
  if state.freecam then neo.stopFreecam() end
  if watching then neo.returnCameraToBody() end
  -- Le TP manuel doit garder le dessus sur la collecte de gun pendant quelques secondes.
  neo.manualTPHoldUntil=os.clock()+8
  local ok,err=pcall(function()
    model:PivotTo(goal)
    local r=root(Local)
    if r then
      r.AssemblyLinearVelocity=Vector3.zero
      r.AssemblyAngularVelocity=Vector3.zero
    end
  end)
  if not ok then
    status('TP : erreur locale '..tostring(err):sub(1,70))
    return false
  end
  status(destination=='map' and ('TP MAP tente ('..tostring(label)..'). Le serveur peut corriger la position.')
    or 'TP LOBBY tente. Le serveur peut corriger la position.')
  return true
end
-- ===== FIN TELEPORTATIONS V6.6 =====

showTab=function(tab)
  selectedTab=tab;clearContent()
  -- Interface personnalisee pour l'onglet DANSES uniquement.
  if neo.emoteClear3D then neo.emoteClear3D();neo.emoteClear3D=nil end
  if neo.emoteScreen then neo.emoteScreen:Destroy();neo.emoteScreen=nil end
  neo.emoteReflow=nil
  local onlyDance=tab=='EMOTES'
  search.Visible=not onlyDance
  pageTitle.Visible=not onlyDance
  pageSubtitle.Visible=not onlyDance
  content.Visible=not onlyDance
  if onlyDance then searchResults.Visible=false end
  neo.refreshNavigation(tab)
  if tab=='ACCUEIL' then
    section('ACCÈS RAPIDE')
    note('Choisis une rubrique à gauche. Recherche une fonction en haut à droite pour la retrouver immédiatement. La croix réduit le menu en une bande.')
    note('AUTO TOUS RÔLES : '..(state.autoRoles and 'ACTIVÉ' or 'DÉSACTIVÉ')..' | '..tostring(neo.autoRole.mode))
    button('🤖  AUTO TOUS RÔLES',function() showTab('AUTO_ROLES') end,hue.primary)
    button('🎯  OPTIONS DU SHERIF',function() showTab('SHERIF') end,hue.primary)
    button('🔪  OPTIONS DU MURDERER',function() showTab('MURDER') end)
    if isAdminOwner then button('🛡  PANNEAU ADMIN',function() showTab('ADMIN') end,hue.primary) end
    button('👥  JOUEURS / BODY BLOCK',function() playerView='list';showTab('JOUEURS') end)
    button('⚖  ÉCHANGES : WIN / FAIR / LOSE',function() showTab('ECHANGES') end,hue.primary)
    button('🌐  ROJOINER : OUVRIR / COPIER LIEN',function() showTab('ROJOINER') end,hue.primary)
    button('👁  VOIR LES JOUEURS (ESP)',function() showTab('ESP') end)
    button('🛡  SURVIE / FUITE / DANGER',function() showTab('SURVIE') end)
    button('🪙  CARTE / COINS / FREECAM',function() showTab('CARTE') end)
    button('✨  EXTRAS ET STATISTIQUES',function() showTab('EXTRAS') end)
    button('🕺  EMOTES ET DANSES',function() showTab('EMOTES') end,hue.primary)
    button('⚙  OUTILS ET PERFORMANCES',function() showTab('OUTILS') end)
    button('▴  REDUIRE EN BANDE EN HAUT',minimizeHub)
    note('Important : un bouton actif ne garantit pas que le serveur MM2 accepte son action.')
  elseif tab=='ADMIN' then
    neo.adminRenderTab()
  elseif tab=='ECHANGES' then
    neo.tradeRenderTab()
  elseif tab=='ROJOINER' then
    section('ROJOINER  •  ACCÈS AU SITE')
    note('Uniquement deux actions : ouvrir RoJoiner ou copier son lien. Aucune recherche de serveur integree.')
    button('🌐  OUVRIR ROJOINER (ESSAI DIRECT)',function()
      neo.openRoJoiner()
    end,hue.primary)
    button('📋  COPIER LE LIEN ROJOINER',function()
      neo.copyRoJoinerLink()
    end)
    neo.rojoiner.browserStatusLabel=note('Selon Delta, la redirection peut fonctionner sur Android ou etre bloquee. Si rien ne se passe, copie le lien puis ouvre-le dans le navigateur.')
    note('Adresse : https://rojoin-two.vercel.app/')
  elseif tab=='AUTO_ROLES' then
    section('🤖  AUTO TOUS RÔLES  •  CONTRÔLEUR UNIQUE')
    note('Un seul pilote : INNOCENT -> bonbons ; GunDrop -> TP + confirmation ; SHERIF/HERO -> TP MURDER + SHOOT uniquement ; MURDERER -> TP KILL.')
    toggle('autoRoles','🤖  ACTIVER AUTO TOUS RÔLES')
    local ar=neo.autoRole
    note('Mode : '..tostring(ar.mode or 'OFF')..' | Tentatives Gun : '..tostring(ar.gunAttempts or 0))
    note('L activation suspend temporairement tes options manuelles de farm/ramassage/tir. Elles reviennent a la desactivation.')
    button('🔄  AFFICHER L ÉTAT AUTO',function()
      local a=neo.autoRole
      status('AUTO : '..tostring(a.mode)..' | Gun : '..(tool('Gun') and 'OUI' or 'NON')..' | Knife : '..(tool('Knife') and 'OUI' or 'NON')..' | cible : '..tostring(a.lastTarget or '?')..' | '..tostring(a.lastError or 'aucune erreur'))
      showTab('AUTO_ROLES')
    end,hue.primary)
    button('■  STOP AUTO / RETOUR AU MANUEL',function()
      state.autoRoles=false
      neo.autoRoleStop('arret manuel')
      showTab('AUTO_ROLES')
    end)
    note('Le moteur ne garantit ni les collectes ni les hits : le serveur valide les actions. STOP pour revenir aux boutons manuels.')
  elseif tab=='SHERIF' then
    section('SHERIF / HERO  •  TIR YARHM 1.21')
    note('Bouton SHOOT : meme commande Gun.Shoot et meme prediction YARHM 1.21 (offset 2.8), sans cooldown impose au clic. Pas de tir sur le Sheriff.')
    toggle('autoShoot','AUTO-SHOOT : cible visible uniquement')
    toggle('autoGrab','Auto-ramasser le pistolet')
    -- Les boutons passent par le meme controle d equipement (Gun en Backpack ou main).
    button('🌀  FLY LENT AUTOUR + SHOOT MURDERER',function()
      neo.sheriffMenuLaunch('ORBIT')
    end,hue.primary)
    button('🎯  TP MURDER + SHOOT',function()
      neo.sheriffMenuLaunch('TP MURDER')
    end,hue.primary)
    button('■  STOP ORBIT / TP SHOOT',function()
      neo.sheriffMenuRequest=neo.sheriffMenuRequest+1 -- annule aussi un lancement en attente
      if flingBusy then flingStop=true;status('Arret du vol/TP et des tirs demande.')
      else status('Aucun vol orbital ou TP actif.') end
    end)
    note('SHERIF / HERO : Gun dans le sac ou en main. TP MURDER = UN TP a 7 studs puis tirs sans repositionnements. FLY LENT AUTOUR reste manuel. Fling JOUEURS inchange. STOP pour interrompre.')
    note(neo.grabRound and neo.grabRound.locked and 'TP GUN : pause apres elimination, jusqu a la nouvelle manche.' or 'TP GUN : actif seulement vivant ; pause automatique apres mort.')
    button('DIAGNOSTIC DE L ARME',function()
      local g=tool('Gun')
      if not g then status('DIAGNOSTIC : pas de Gun dans le sac ou la main.');return end
      local remote,method=shotCtl.findRemote(g)
      status('DIAGNOSTIC : '..method..' | Cible : '..(findMurderer() and findMurderer().Name or 'inconnue')..' | '..(remote and 'commande trouvee' or 'commande absente'))
    end,hue.primary)
    note('Shoot manuel = YARHM 1.21. ORBIT et TP MURDER + SHOOT restent independants du Fling classique. Le serveur decide des hits.')
  elseif tab=='MURDER' then
    section('MURDERER  •  COUTEAU')
    note('Kill Aura : 12 studs. Kill All TP : boucle de teleportations sur les joueurs encore vivants. STOP manuel. Hits non garantis.')
    toggle('knifeAura','Kill Aura (12 studs)')
    button('KILL ALL  •  TP SEQUENTIEL CONTINU',function() neo.killAllAttempt(status) end,hue.red)
    button('STOP KILL ALL TP',function()
      status(neo.stopKillAllTP() and 'Arret Kill All TP demande.' or 'Kill All TP deja inactif.')
    end)
    button('ÉQUIPER LE COUTEAU',function() status(equipped('Knife') and 'Couteau équipé.' or 'Aucun couteau disponible.') end)
  elseif tab=='ESP' then
    section('ESP  •  VISIBILITÉ')
    note('Rouge : Murderer • Bleu : Sheriff/Hero • Vert : autre/inconnu. Rôle inconnu = approximation.')
    toggle('esp','ESP des joueurs')
    toggle('gunESP','ESP pistolet au sol')
    toggle('dangerAlert','Alerte Murderer proche')
    toggle('bright','FullBright')
    button('ACTUALISER LES RÔLES',function() status('Actualisation automatique toutes les 3 s.') end)
  elseif tab=='JOUEURS' then
    if playerView=='actions' and (not selected or selected.Parent~=Players) then
      playerView='list';selected=nil;neo.clearTargetHighlight()
    end
    if playerView=='list' then
      section('JOUEURS  •  APPUIE SUR UN PSEUDO')
      note('Recherche par pseudo ou nom affiché. Touche une personne pour ouvrir directement sa fiche.')
      local search=make('TextBox',{
        Name='ChercherJoueur',Size=UDim2.new(1,-6,0,49),
        Text=playerQuery,PlaceholderText='🔎 Chercher un pseudo...',
        ClearTextOnFocus=false,TextSize=14,Font=Enum.Font.GothamMedium,
        TextColor3=hue.text,PlaceholderColor3=hue.muted,
        BackgroundColor3=hue.elevated
      },content)
      corner(search,9)
      contentOrder=contentOrder+1;search.LayoutOrder=contentOrder
      search.FocusLost:Connect(function()
        if active then playerQuery=search.Text;showTab('JOUEURS') end
      end)
      if playerQuery~='' then
        button('EFFACER LA RECHERCHE',function()
          playerQuery='';showTab('JOUEURS')
        end)
      end
      local results=0
      for _,p in ipairs(Players:GetPlayers()) do
        if p~=Local and (playerQuery=='' or
          string.find(string.lower(p.Name),string.lower(playerQuery),1,true) or
          string.find(string.lower(p.DisplayName),string.lower(playerQuery),1,true)) then
          results=results+1
          local target=p
          local label=p.DisplayName..'   @'..p.Name..'  ['..getRole(p)..']   ›'
          local b=button(label,function()
            selected=target
            playerView='actions'
            status('Cible : '..target.Name)
            showTab('JOUEURS')
          end)
          b.TextSize=12
        end
      end
      if results==0 then note('Aucun joueur ne correspond à cette recherche.') end
      button('ACTUALISER LA LISTE',function() showTab('JOUEURS') end,hue.primary)
    else
      local target=selected
      section('CIBLE  •  '..target.DisplayName)
      local distance='?'
      local myRoot,otherRoot=root(Local),root(target)
      if myRoot and otherRoot then distance=tostring(math.floor((myRoot.Position-otherRoot.Position).Magnitude)) end
      local details=note(neo.inspectPlayer(target))
      details.AutomaticSize=Enum.AutomaticSize.None
      details.Size=UDim2.new(1,-6,0,100)
      inspectorText=details
      local avatar=make('ImageLabel',{
        Name='Avatar',Size=UDim2.new(1,-6,0,104),
        Image='',ScaleType=Enum.ScaleType.Fit,BackgroundColor3=hue.elevated
      },content)
      corner(avatar,9)
      contentOrder=contentOrder+1;avatar.LayoutOrder=contentOrder
      task.spawn(function()
        local ok,asset=pcall(function()
          return Players:GetUserThumbnailAsync(target.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
        end)
        if ok and avatar.Parent and active then avatar.Image=asset end
      end)
      button('←  RETOUR A LA LISTE',function() playerView='list';showTab('JOUEURS') end,hue.primary)
      section('TROLL  •  BODY BLOCK')
      note('Ton avatar va devant le joueur en suivant sa direction. Collision REELLE non garantie : certains serveurs desactivent le contact entre avatars.')
      button('BODY BLOCK : '..(state.bodyBlock and bodyBlock.target==target and 'ACTIF (STOP)' or 'DEMARRER'),function()
        if state.bodyBlock and bodyBlock.target==target then bodyBlock.stop('STOP manuel')
        else bodyBlock.start(target) end
        showTab('JOUEURS')
      end,hue.primary)
      button('DISTANCE : '..bodyBlock.gap..' STUDS  •  CHANGER',function()
        bodyBlock.gap=(bodyBlock.gap==2 and 3) or (bodyBlock.gap==3 and 5) or 2
        retainedOptions.bodyBlockGap=bodyBlock.gap
        neo.saveOptions()
        showTab('JOUEURS')
      end)
      button('STOP BODY BLOCK / RENDRE LES COMMANDES',function()
        bodyBlock.stop('STOP manuel')
        showTab('JOUEURS')
      end,hue.red)
      note('Etat : '..bodyBlock.status..'. STOP rouge flottant egalement visible quand le hub est reduit.')
      button('📷  REGARDER / ARRETER',function()
        if watching~=target and neo.adminIsBlocked('spectate') then status('NEO ADMIN : SPECTATE verrouille.');return end
        if watching==target then
          neo.returnCameraToBody()
          status('Spectate OFF')
        elseif hum(target) then
          if state.freecam then neo.stopFreecam() end
          watching=target
          state.aim=false;state.autoShoot=false -- pas de tir ni rotation pendant Spectate
          local cam=workspace.CurrentCamera
          if cam then
            cam.CameraType=Enum.CameraType.Custom
            cam.CameraSubject=hum(target)
          end
          status('Spectate : '..target.Name..' | retour auto si Murderer proche')
        else status('Cible indisponible.') end
      end)
      button('👣  SUIVRE / ARRÊTER DE SUIVRE',function()
        if not state.followPlayer and neo.adminIsBlocked('followPlayer') then status('NEO ADMIN : SUIVRE verrouille.');return end
        if state.followPlayer and followTarget==target then
          state.followPlayer=false;followTarget=nil
          if hum(Local) and root(Local) then hum(Local):MoveTo(root(Local).Position) end
          status('Suivi terminé.')
        elseif alive(target) then
          bodyBlock.stop()
          followTarget=target;state.followPlayer=true;state.autoEscape=false
          status('Suivi : '..target.Name..' (déplacement local)')
        else status('Ce joueur ne peut pas être suivi.') end
      end,hue.primary)
      button('📍  TELEPORTATION VERS LA CIBLE',function()
        if neo.adminIsBlocked('teleport') then status('NEO ADMIN : TELEPORT verrouille.');return end
        local moved,why=neo.tpToPlayerDirect(target)
        if moved then status('TP tente.')
        else status('TP JOUEURS : '..tostring(why)) end
      end)
      button('👁  MARQUER / ENLEVER MARQUE',function()
        if targetHighlight and targetHighlight.Adornee==char(target) then
          neo.clearTargetHighlight();status('Marque enlevee.')
        else neo.markTarget(target) end
      end)
      section('FLING YARHM 1.21  •  ATTACH PLAYER')
      note('Fling YARHM : en Sheriff avec Gun contre Murderer, tir avant contact. En Innocent, Hero, Murderer ou autres modes : Fling classique inchangé. Attach : soudure locale.')
      button('🌀  FLING YARHM (METHODE 1.21)',function()
        bodyBlock.stop()
        neo.detachPlayer()
        neo.stopCombatPosition();state.combatPosition=false
        state.followPlayer=false;followTarget=nil
        state.autoFarm=false;state.autoEscape=false
        autoNav.halt();autoNav.resetEscape()
        if state.freecam then neo.stopFreecam() end
        if watching then neo.returnCameraToBody() end
        task.spawn(fling,target)
      end,hue.primary)
      button('■  STOPPER LE FLING',function() flingStop=true;status('Arret du fling demande.') end)
      button('🧲  ATTACH PLAYER  •  COLLER A MOI',function()
        bodyBlock.stop()
        flingStop=true
        neo.stopCombatPosition();state.combatPosition=false
        state.followPlayer=false;followTarget=nil
        state.autoFarm=false;state.autoEscape=false
        autoNav.halt();autoNav.resetEscape()
        if state.freecam then neo.stopFreecam() end
        if watching then neo.returnCameraToBody() end
        neo.attachPlayer(target)
        showTab('JOUEURS')
      end)
      button('✖  DETACH PLAYER  •  DETACHER',function()
        neo.detachPlayer('STOP manuel')
        showTab('JOUEURS')
      end,hue.red)
      note('Attach : '..(neo.attachCtl.target and ('@'..neo.attachCtl.target.Name) or 'OFF')..'. Cela peut etre seulement visible sur ton ecran.')
      button('📋  COPIER LE PSEUDO',function()
        if type(setclipboard)=='function' then
          local ok=pcall(function() setclipboard(target.Name) end)
          status(ok and 'Pseudo copie.' or 'Copie impossible sur cet appareil.')
        else status('Copie non disponible dans Delta.') end
      end)
      button('↻  ACTUALISER LA FICHE',function() showTab('JOUEURS') end)
      button('📢  NOTIFIER SI CIBLE PART',function()
        status('Cette alerte est incluse si Notifications est actif.')
      end)
      note('YARHM : la physique est tentee localement; les protections du serveur MM2 peuvent bloquer Fling et Attach.')
    end
  elseif tab=='SURVIE' then
    section('SURVIE  •  FUITE INTELLIGENTE')
    section('PROTECTION  •  ANTI-FLING')
    toggle('antiFling','🛡 ANTI-FLING INTELLIGENT (conseille)')
    note('ON : detecte les projections/rotations physiques anormales et tente de stopper la propulsion. Aucun effet pendant une partie normale. Ton Fly, tes TP et ton propre Fling restent prioritaires. Protection serveur non garantie.')
    note('Fuite : VOL + NOCLIP automatique si active. Traverse les murs cote client; le serveur peut corriger la position. Jamais Sheriff ou Hero.')
    toggle('autoEscape','AUTO-FUITE : innocents uniquement')
    toggle('flyNoclipAuto','VOL + NOCLIP automatique (Fuite et Farm)')
    note('A moins de 50 studs, fuite par vol direct si active. Sinon, chemins au sol pre-calcules. STOP a 76 studs. Role Innocent confirme uniquement.')
    note('ETAT DE LA CARTE : '..autoNav.planStatus())
    button('PREPARER LES ITINERAIRES MAINTENANT',function()
      if neo.adminIsBlocked('autoEscape') then status('NEO ADMIN : AUTO-FUITE verrouillee.');return end
      if state.flyNoclipAuto then
        status('Mode VOL + NOCLIP : aucun itineraire au sol necessaire.')
        return
      end
      if not state.autoEscape then state.autoEscape=true;neo.saveOptions() end
      local ok=autoNav.preplan()
      status(ok and 'Analyse des chemins lancee...' or 'Analyse indisponible : role Innocent non confirme, avatar absent ou analyse deja en cours.')
      showTab('SURVIE')
    end,hue.primary)
    toggle('escapeRoute','TRACE ROUGE AU SOL : guider ma fuite')
    toggle('threatMeter','Indicateur de danger')
    toggle('safeScan','Scanner de zone dégagée')
    section('CAMERA  •  SECURITE AUTOMATIQUE')
    note('En Freecam ou en Spectate : si le Murderer detecte arrive pres de TON corps, retour immediat sur ton avatar (pas sur la camera).')
    toggle('cameraGuard','Retour camera automatique')
    button('DISTANCE : '..cameraGuardRange..' STUDS  •  CHANGER',function()
      cameraGuardRange=(cameraGuardRange==20 and 35) or (cameraGuardRange==35 and 50) or 20
      showTab('SURVIE')
      status('Retour camera a '..cameraGuardRange..' studs.')
    end,hue.primary)
    button('REVENIR DANS MON CORPS',function()
      neo.returnCameraToBody()
      status('Camera revenue sur ton personnage.')
    end)
    button('CALCULER UN REFUGE POSSIBLE',function()
      local pos,msg=neo.scanSafeZone()
      safeCandidate=pos;safeCandidateAt=os.clock()
      status(pos and ('Zone estimée à '..math.floor((pos-root(Local).Position).Magnitude)..' studs. '..msg) or msg)
    end,hue.primary)
    button('STOP AUTO-FUITE / SUIVI IMMEDIAT',function()
      followTarget=nil;state.followPlayer=false;state.autoEscape=false
      autoNav.resetEscape();autoNav.halt();neo.saveOptions()
      status('Auto-Fuite et suivi stoppes. Joystick rendu.')
      showTab('SURVIE')
    end,hue.red)
  elseif tab=='CARTE' then
    section('CARTE  •  RADAR ET CAMÉRA')
    button('🗺  TP MAP  •  REJOINDRE LA MANCHE',function() neo.tpTravel('map') end,hue.primary)
    button('🏠  TP LOBBY  •  RETOUR AU HALL',function() neo.tpTravel('lobby') end,hue.primary)
    note('Teleportations manuelles : points de spawn de la map active et du lobby. Sans map chargee, TP MAP refuse au lieu de partir dans le vide.')
    note('Auto-Farm : vole en NOCLIP vers les bonbons et pieces si active. Le serveur peut refuser certaines collectes. Fuite prioritaire.')
    toggle('coinRadar','Radar pièces / bonbons')
    toggle('autoFarm','AUTO-FARM : aller vers bonbons / pieces')
    toggle('flyNoclipAuto','VOL + NOCLIP automatique (Farm et Fuite)')
    button('VITESSE FARM : '..farmSpeed..' STUDS/S  |  CHANGER',function()
      farmSpeed=(farmSpeed==18 and 22) or (farmSpeed==22 and 26) or 18
      neo.saveOptions();showTab('CARTE')
      status('Vitesse farm reglee sur '..farmSpeed..' studs/s.')
    end,hue.primary)
    toggle('farmUnderground','FARM SOUS-SOL (experimental, risque erreur 267)')
    note('V6.0 : cible les vrais bonbons, vol continu a vitesse reglable. Le mode sous-sol est facultatif et peut etre refuse par le serveur.')
    button('STOPPER FARM ET FUITE',function()
      state.autoFarm=false;state.autoEscape=false;autoNav.resetEscape()
      autoNav.halt();neo.saveOptions();showTab('CARTE')
      status('Auto-Farm et Auto-Fuite arrêtés.')
    end,hue.red)
    button('ACTUALISER RADAR MAINTENANT',function()
      if neo.adminIsBlocked('coinRadar') then status('NEO ADMIN : RADAR verrouille.');return end
      nextCoinScan=os.clock()+(state.performance and 12 or 8)
      if neo.scanCoins(function() status(neo.radarMessage()) end) then
        status('Recherche en cours... résultats dans le radar.')
      else status('Un scan est déjà en cours.') end
    end,hue.primary)
    coinDiagLabel=note(neo.radarMessage())
    note('Navigation : '..autoNav.message())
    button('DIAGNOSTIC : NOMS DETECTES',function()
      local detail=neo.diagnosticRadar()
      if type(setclipboard)=='function' then
        local ok=pcall(function() setclipboard(detail) end)
        status(ok and 'Diagnostic copié : colle-le dans le chat.' or neo.radarMessage())
      else
        status(neo.radarMessage()..' | '..table.concat(coinDiag.examples,', '):sub(1,80))
      end
    end)
    button('FREECAM : ACTIVER / DÉSACTIVER',neo.startFreecam)
    note('Retour auto ON par défaut : si le Murderer s approche à moins de '..cameraGuardRange..' studs de ton corps, la caméra revient immédiatement. Réglage dans SURVIE.')
    note('Freecam iPhone : AV/AR/G/D/MONTER/DESC. Glisse à droite pour tourner la vue. QUITTER pour revenir.')
    if #coinCache>0 then
      section('OBJETS PROCHES')
      for i,item in ipairs(coinCache) do
        if item.part and item.part.Parent then
          local kind=item.kind or 'Objet'
          local rr=root(Local)
          local dist=rr and math.floor((rr.Position-item.part.Position).Magnitude) or math.floor(item.dist)
          local pos=Vector3.new(item.part.Position.X,item.part.Position.Y,item.part.Position.Z)
          button(i..'. '..kind..'  |  '..dist..' studs',function()
            status('Objet repéré vers '..directionArrow(pos-(root(Local) and root(Local).Position or pos)))
          end)
        end
      end
    end
  elseif tab=='EMOTES' then
    neo.emoteRender()
  elseif tab=='FUN' then
    section('FUN  •  CLONE LOCAL')
    note('Ton double est un effet visuel local : les autres joueurs de MM2 ne peuvent pas le voir.')
    button('CRÉER UN FAUX CLONE',function()
      if neo.adminIsBlocked('clone') then status('NEO ADMIN : CLONE verrouille.');return end
      neo.createClone()
    end,hue.primary)
    button('SUPPRIMER MON CLONE',function() neo.deleteClone();status('Clone supprimé.') end)
  elseif tab=='OUTILS' then
    section('OUTILS  •  CONFORT IPHONE')
    toggle('notifications','Notifications en jeu')
    toggle('performance','Mode Performance / batterie')
    note('Le mode Performance ralentit les scans, limite les effets visuels et réduit la charge sur iPhone.')
    button('TESTER UNE NOTIFICATION',function() notify('Voici une notification NEO.',false) end)
    button('RAFRAÎCHIR L INTERFACE',function() showTab('OUTILS') end)
  elseif tab=='MOVE' then
    section('DÉPLACEMENTS')
    toggle('speed','Speed 26')
    toggle('jump','Jump 80')
    toggle('infiniteJump','Saut infini')
    toggle('noclip','Noclip')
    section('OP FLY YARHM  •  VOL MANUEL')
    toggle('manualFly','🚀 OP FLY (independant du farm)')
    note('Fly manuel : joystick Roblox classique, camera inclinee pour monter/descendre. Noclip automatique pendant le vol. Aucun bouton de direction supplementaire.')
    button('VITESSE FLY : '..manualFlySpeed..'  |  -10',function()
      manualFlySpeed=math.max(50,manualFlySpeed-10)
      if neo.manualFlyCtl.module then neo.manualFlyCtl.module:SetMaxSpeed(manualFlySpeed) end
      neo.saveOptions();showTab('MOVE')
    end)
    button('VITESSE FLY : '..manualFlySpeed..'  |  +10',function()
      manualFlySpeed=math.min(350,manualFlySpeed+10)
      if neo.manualFlyCtl.module then neo.manualFlyCtl.module:SetMaxSpeed(manualFlySpeed) end
      neo.saveOptions();showTab('MOVE')
    end,hue.primary)
    button('VITESSE MAX FLY : 350',function()
      manualFlySpeed=350
      if neo.manualFlyCtl.module then neo.manualFlyCtl.module:SetMaxSpeed(manualFlySpeed) end
      neo.saveOptions();showTab('MOVE')
      status('OP Fly : vitesse maxi 350 (si le serveur autorise).')
    end,hue.primary)
    button('STOP OP FLY (rendre les commandes)',function()
      neo.stopManualFly();showTab('MOVE');status('OP Fly arrete.')
    end,hue.red)
    button('RÉTABLIR LES MOUVEMENTS',function()
      neo.stopManualFly()
      state.speed=false;state.jump=false;state.noclip=false;state.infiniteJump=false
      neo.refreshMovement();showTab('MOVE')
    end)
  elseif tab=='EXTRAS' then
    section('EXTRAS  •  NOUVELLES FONCTIONS')
    note('Outils en plus des onglets classiques. Les effets de déplacement sont locaux et peuvent être corrigés par le serveur.')
    toggle('autoEscape','AUTO-FUITE : innocents uniquement')
    toggle('murderTrail','Trace du chemin du Murderer')
    button('SAUVER MA POSITION',function()
      local r=root(Local)
      if r then waypoint=r.CFrame;status('Position sauvegardée pour cette session.')
      else status('Ton personnage doit être présent.') end
    end)
    button('REVENIR A LA POSITION',function()
      if neo.adminIsBlocked('teleport') then status('NEO ADMIN : TELEPORT verrouille.');return end
      local r=root(Local)
      if r and waypoint then r.CFrame=waypoint;status('Retour tenté (serveur peut annuler).')
      else status('Sauvegarde d abord une position.') end
    end)
    button('EFFACER LA TRACE DU MURDERER',function()
      neo.clearTrail();status('Trace effacée.')
    end)
    button('STATISTIQUES DE SESSION',function()
      local mins=math.floor((os.clock()-stats.start)/60)
      status('Session '..mins..' min | Tirs '..stats.shots..' | Grabs '..stats.grabs)
    end)
  elseif tab=='OPTIONS' then
    section('OPTIONS  •  INTERFACE')
    note('La croix X et RED. masquent le menu. La bande NEO MM2 reste en HAUT : touche OUVRIR pour revenir.')
    toggle('antiAfk','Anti-AFK')
    section('SAUVEGARDE DES REGLAGES')
    note('Enregistrement automatique des interrupteurs : FARM, NOCLIP, fuite, combat, ESP, etc. La distance de camera et celle du Body Block sont aussi retenues.')
    note('Suivi d un joueur, Body Block actif, spectate et Freecam ne se restaurent pas sans cible valide.')
    note(type(writefile)=='function' and type(readfile)=='function' and 'Delta : enregistrement fichier disponible.' or 'Delta : lecture/ecriture indisponibles, sauvegarde limitee a la session.')
    button('SAUVEGARDER MES REGLAGES',function()
      local ok=neo.saveOptions(true)
      status(ok and 'Tous les reglages de menu sauvegardes dans '..profileFile
        or 'Reglages gardes en memoire uniquement : writefile indisponible.')
    end,hue.primary)
    button('REDUIRE EN HAUT DE L ECRAN',minimizeHub,hue.primary)
    button('RÉINITIALISER LA CAMÉRA',function() neo.returnCameraToBody() end)
    button('FERMER COMPLÈTEMENT',function() if _G.NEO_MM2_STOP then _G.NEO_MM2_STOP() end end,hue.red)
  end
end
showTab('ACCUEIL')

-- Main ticks
local nextESP=0
-- Un respawn ne signifie pas une nouvelle manche. Ne re-activer la collecte que
-- lorsque les donnees de roles du serveur indiquent qu'une nouvelle manche a commence.
neo.grabRound={locked=false,sawDead=false,sawIntermission=false,token=0,reason=''}
function neo.grabMarkDead(reason)
  local g=neo.grabRound
  g.locked=true;g.sawDead=false;g.sawIntermission=false
  g.token=g.token+1;g.reason=reason or 'mort'
end
function neo.grabObserveRound(data)
  local g=neo.grabRound
  if not g.locked or type(data)~='table' then return end
  local entry=data[Local.Name]
  if type(entry)~='table' or type(entry.Role)~='string' or entry.Role=='' then
    g.sawIntermission=true
    return
  end
  if entry.Dead==true or entry.Killed==true then
    g.sawDead=true
    return
  end
  -- La transition mort -> statut vivant dans les donnees de MM2 est le signal.
  -- Sans signal de serveur fiable, on reste bloque : pas de TP en spectateur.
  if (g.sawDead or g.sawIntermission) and entry.Dead~=true and entry.Killed~=true and alive(Local) then
    g.locked=false;g.sawDead=false;g.sawIntermission=false
    g.reason='Nouvelle manche detectee'
    lastGrab=0
  end
end
function neo.grabWatchCharacter(c)
  if not c then return end
  task.spawn(function()
    local h=c:FindFirstChildOfClass('Humanoid') or c:WaitForChild('Humanoid',8)
    if not active or not h then return end
    connect(h.Died,function()
      if active then neo.grabMarkDead('Humanoid.Died') end
    end)
    if h.Health<=0 then neo.grabMarkDead('Humanoid deja elimine') end
  end)
end
if Local.Character then neo.grabWatchCharacter(Local.Character) end
function neo.tryGrabGun()
  if (neo.manualTPHoldUntil or 0)>os.clock() then return end
  if state.manualFly or neo.adminIsBlocked('autoGrab') or neo.grabRound.locked or not alive(Local) then return end
  local entry=roles[Local.Name]
  if type(entry)=='table' and (entry.Dead==true or entry.Killed==true) then
    neo.grabMarkDead('Role MM2 : elimine')
    return
  end
  if not state.autoGrab or state.autoFarm or autoNav.escaping() or tool('Gun') or tool('Knife') or os.clock()-lastGrab<5 then return end
  local gun=workspace:FindFirstChild('GunDrop',true)
  local r=root(Local)
  local h=hum(Local)
  if not gun or not gun:IsA('BasePart') or not r or not h or h.Health<=0 then return end
  lastGrab=os.clock()
  stats.grabs=stats.grabs+1
  local saved=r.CFrame
  local token=neo.grabRound.token
  task.spawn(function()
    if active and not neo.grabRound.locked and token==neo.grabRound.token
      and r.Parent and gun.Parent and hum(Local)==h and alive(Local) then
      r.CFrame=gun.CFrame*CFrame.new(0,2,0)
    end
    task.wait(.3)
    if active and not neo.grabRound.locked and token==neo.grabRound.token
      and r.Parent and hum(Local)==h and alive(Local) then
      r.CFrame=saved
    end
  end)
end
-- ===== AUTO TOUS ROLES V2 : un seul orchestrateur (13/11) =====
-- Auto utilise Farm/Gun/TP+Shoot/TP Kill existants ; ORBIT reste uniquement manuel.
-- Les autres onglets restent disponibles ; OFF restitue leurs choix manuels.
function neo.autoRoleReleaseActions(reason)
  local a=neo.autoRole
  if a.comboOwned then
    neo.sheriffMenuRequest=neo.sheriffMenuRequest+1
    if neo.sheriffMenuMode or flingBusy then flingStop=true end
    a.comboOwned=false
  end
  if a.killOwned then
    neo.stopKillAllTP()
    a.killOwned=false
  end
  if a.mode=='FARM' or a.mode=='GUN' then
    if autoNav then autoNav.halt() end
    if neo.stopGhost then neo.stopGhost() end
  end
  state.autoFarm=false
end
function neo.autoRoleBegin()
  local a=neo.autoRole
  if a.started then return end
  if not state.autoRoles then return end
  a.saved={autoFarm=state.autoFarm,autoGrab=state.autoGrab,
    autoShoot=state.autoShoot,autoEscape=state.autoEscape}
  a.started=true;a.mode='ATTENTE';a.lastSwitch=os.clock();a.lastError=nil
  a.nextCombat=0;a.nextGrab=0;a.nextKill=0;a.comboOwned=false;a.killOwned=false
  a.combatTrials=0;a.lastCombat=nil;a.lastTarget=nil
  -- AUTO est seul proprietaire des mouvements et du cooldown. Pas de doublon AUTO-SHOOT.
  state.autoFarm=false;state.autoGrab=false;state.autoShoot=false;state.autoEscape=false
  if autoNav then autoNav.halt();autoNav.resetEscape() end
  neo.stopManualFly()
  status('AUTO ROLES : demarrage, detection de ton role...')
end
function neo.autoRoleStop(why)
  local a=neo.autoRole
  if not a.started and not a.saved then a.mode='OFF';return end
  neo.autoRoleReleaseActions(why)
  local saved=a.saved
  a.started=false;a.mode='OFF';a.saved=nil;a.lastTarget=nil
  a.nextCombat=0;a.nextGrab=0;a.nextKill=0;a.lastCombat=nil
  if saved then
    for key,value in pairs(saved) do state[key]=value end
  end
  if active then
    status('AUTO TOUS RÔLES OFF : '..tostring(why or 'retour au mode manuel'))
  end
end
function neo.autoRoleSetMode(mode,why)
  local a=neo.autoRole
  if a.mode==mode then return end
  neo.autoRoleReleaseActions('changement de role')
  a.mode=mode;a.lastSwitch=os.clock();a.lastError=nil
  a.nextCombat=0;a.nextGrab=0;a.nextKill=0;a.combatTrials=0
  a.lastCombat=nil;a.lastTarget=nil;a.gunAttempts=0
  -- Etat recalcule depuis le serveur et l'inventaire ; pas de tir si le Gun n'a pas ete confirme.
  if mode=='FARM' then
    state.autoFarm=true
  else
    state.autoFarm=false
  end
  if mode=='GUN' or mode=='SHOOT' or mode=='MURDER' then
    if autoNav then autoNav.halt() end
  end
  status('AUTO ROLES : '..mode..' | '..tostring(why or ''))
end
function neo.autoRoleDesired()
  if not alive(Local) then return 'MORT','Personnage elimine ou absent.' end
  local entry=roles[Local.Name]
  if os.clock()-rolesReceivedAt<8 and type(entry)=='table'
    and (entry.Dead==true or entry.Killed==true) then
    return 'MORT','Elimine dans les donnees de manche.'
  end
  if neo.grabRound and neo.grabRound.locked then
    return 'MORT','Attente de nouvelle manche apres elimination.'
  end
  if state.freecam or watching~=nil or state.manualFly or state.followPlayer then
    return 'PAUSE','Commande manuelle en cours.'
  end
  -- Priorite a l'inventaire : le remote de role a parfois 3 secondes de retard.
  if tool('Knife') then return 'MURDER','Knife confirme dans le sac ou la main.' end
  if tool('Gun') then return 'SHOOT','Gun confirme : mode Sheriff / Hero.' end
  local role=myRole()
  if role=='Murderer' then return 'ATTENTE','Murderer signale, Knife non confirme.' end
  local dropped=workspace:FindFirstChild('GunDrop',true)
  if dropped and dropped:IsA('BasePart') and dropped.Parent then
    return 'GUN','GunDrop detecte : tentative de recuperation.'
  end
  if role=='Sheriff' or role=='Hero' then
    return 'ATTENTE','Sheriff / Hero signale, Gun pas encore dans le sac.'
  end
  -- Pas de farm a l'intermission : un CoinContainer confirme la carte de manche.
  if workspace:FindFirstChild('CoinContainer',true) then
    return 'FARM','Innocent : collecte des bonbons.'
  end
  return 'ATTENTE','Carte / manche pas encore chargee.'
end
function neo.autoRoleChooseCombat(target)
  local me,enemy=root(Local),root(target)
  if not me or not enemy then return nil,'Avatar ou Murderer absent.' end
  -- AUTO TOUS ROLES : TP MURDER + SHOOT uniquement.
  -- Ne plus choisir ORBIT, quelle que soit la distance, la vitesse ou la visibilite.
  -- Le TP utilise exactement la fonction manuelle SHERIF/HERO deja presente.
  return 'TP MURDER',math.floor((me.Position-enemy.Position).Magnitude)
end
function neo.autoRoleTick()
  local a=neo.autoRole
  if not active or not state.autoRoles or not a.started then return end
  local wanted,why=neo.autoRoleDesired()
  if a.mode~=wanted then neo.autoRoleSetMode(wanted,why) end
  if wanted=='MORT' or wanted=='ATTENTE' or wanted=='PAUSE' then return end
  if wanted=='FARM' then
    -- Le tick de navigation historique fait la collecte ; aucune nouvelle physique.
    if not neo.adminIsBlocked('autoFarm') and not state.autoFarm then state.autoFarm=true end
    if neo.adminIsBlocked('autoFarm') then state.autoFarm=false end
    return
  end
  if wanted=='GUN' then
    state.autoFarm=false
    -- Reutilise exactement le TP Gun existant, mais apres l'avoir tente,
    -- attend que tool('Gun') soit effectivement present AVANT de passer HERO.
    if neo.adminIsBlocked('autoGrab') or neo.adminIsBlocked('teleport') then
      a.lastError='AUTO GUN : ramassage / TP verrouille par ADMIN.';return
    end
    if not (neo.grabRound and neo.grabRound.locked) and os.clock()>=a.nextGrab then
      a.nextGrab=os.clock()+5.15
      a.gunAttempts=a.gunAttempts+1
      -- neo.tryGrabGun utilise une limite interne de 5 sec et respecte le respawn.
      state.autoGrab=true
      neo.tryGrabGun()
      state.autoGrab=false
      status('AUTO GUN : tentative '..a.gunAttempts..'; attente confirmation inventaire...')
    end
    return
  end
  if wanted=='SHOOT' then
    state.autoFarm=false
    if neo.adminIsBlocked('shoot') or neo.adminIsBlocked('teleport') then
      a.lastError='AUTO SHERIFF : Shoot ou TP verrouille.';return
    end
    local target=findMurderer()
    if not target or not alive(target) then
      a.lastError='AUTO SHERIFF : Murderer non identifie (aucun innocent cible).';return
    end
    if a.lastTarget and a.lastTarget~=target.Name then
      a.combatTrials=0;a.lastCombat=nil;a.nextCombat=0
    end
    if flingBusy or neo.sheriffMenuMode then return end
    if os.clock()<a.nextCombat then return end
    local mode,dist=neo.autoRoleChooseCombat(target)
    if not mode then a.lastError=tostring(dist);return end
    a.comboOwned=true
    a.combatTrials=a.combatTrials+1
    a.lastCombat=mode;a.lastTarget=target.Name
    -- Si un lancement echoue immediatement, reessayer rapidement.
    -- Si le mode est en cours, flingBusy empeche les doublons.
    a.nextCombat=os.clock()+14 -- Ne pas relancer un autre TP des la fin des tirs.
    status('AUTO SHERIFF : '..mode..' vers '..target.Name..' ('..dist..' studs)')
    neo.sheriffMenuLaunch(mode)
    return
  end
  if wanted=='MURDER' then
    state.autoFarm=false
    if neo.adminIsBlocked('killAll') or neo.adminIsBlocked('teleport') then
      a.lastError='AUTO MURDER : TP Kill verrouille.';return
    end
    if not neo.killAllBusy and os.clock()>=a.nextKill then
      a.nextKill=os.clock()+5
      a.killOwned=true
      neo.killAllAttempt(status)
    end
    return
  end
end
-- Les commandes manuelles restent accessibles quand AUTO OFF ; un seul automate.
if state.autoRoles then neo.autoRoleBegin() end
task.spawn(function()
  while active do
    if state.autoRoles then
      local ok,err=pcall(neo.autoRoleTick)
      if not ok then
        neo.autoRole.lastError=tostring(err):sub(1,150)
        if os.clock()>=neo.autoRole.nextNotice then
          neo.autoRole.nextNotice=os.clock()+3
          status('AUTO ROLES erreur : '..neo.autoRole.lastError)
        end
      end
    end
    task.wait(.45)
  end
end)
-- ===== FIN AUTO TOUS ROLES =====

stats.nextCoinHudRefresh=0
connect(RunService.Heartbeat,function()
  if not active then return end
  local now=os.clock()
  local murder=findMurderer()
  local myRoot=root(Local)

  -- Scan sur chaque Heartbeat (pas toutes les 3 s) pour un retour rapide.
  -- Important : mesure la distance Murderer <-> TON avatar, jamais la freecam.
  if state.cameraGuard and (state.freecam or watching~=nil) and alive(Local) then
    local mr=murder and root(murder)
    if mr and (myRoot.Position-mr.Position).Magnitude<=cameraGuardRange then
      local distance=math.floor((myRoot.Position-mr.Position).Magnitude)
      neo.returnCameraToBody('MURDERER À '..distance..' STUDS : RETOUR D URGENCE !')
    end
  end

  -- V4.1 : plus de tir automatique ni de deplacement tactique du Sheriff.
  -- Le joueur declenche UNIQUEMENT via le bouton lateral SHOOT.
  if state.knifeAura and tool('Knife') and now-lastStab>.36 then
    local closest,dist=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
      if p~=Local and alive(p) and myRoot then
        local distance=(root(p).Position-myRoot.Position).Magnitude
        if distance<dist then closest,dist=p,distance end
      end
    end
    if closest and dist<=12 then lastStab=now;stab(closest) end
  end
  -- V4.0 Body Block : placement reel via Humanoid:MoveTo.
  bodyBlock.tick(now)
  -- La fuite automatique est maintenant gérée par le navigateur commun au farm.
  if state.murderTrail and murder and root(murder) and now-lastTrail>(state.performance and 2.2 or 1.0) then
    lastTrail=now
    neo.addTrailPoint(root(murder).Position)
  end
  -- Follow Player: utilisation de MoveTo; ne déplace jamais directement la cible.
  if state.followPlayer and followTarget and now-lastFollow>.32 then
    lastFollow=now
    if followTarget.Parent~=Players or not alive(followTarget) then
      state.followPlayer=false;followTarget=nil;status('Le joueur suivi est indisponible.')
    elseif myRoot and hum(Local) then
      local pr=root(followTarget)
      if (myRoot.Position-pr.Position).Magnitude>5 then
        hum(Local):MoveTo(pr.Position-pr.CFrame.LookVector*3)
      else
        hum(Local):MoveTo(myRoot.Position)
      end
    end
  end
  if now-lastSurvival>(state.performance and 1.25 or .45) then
    lastSurvival=now
    local mr=murder and root(murder)
    local distance=myRoot and mr and (myRoot.Position-mr.Position).Magnitude or nil
    threatHUD.Visible=state.threatMeter
    if state.threatMeter then
      if distance then
        local level=distance<14 and 'CRITIQUE' or distance<28 and 'ÉLEVÉ' or distance<55 and 'MOYEN' or 'FAIBLE'
        threatHUD.Text='DANGER '..level..'  '..math.floor(distance)..' studs'
        threatHUD.BackgroundColor3=distance<28 and hue.red or hue.panel
      else threatHUD.Text='DANGER : meurtrier inconnu';threatHUD.BackgroundColor3=hue.panel end
    end
    if state.notifications then
      local inDanger=distance and distance<22 or false
      if inDanger and not lastMurderDanger then notify('Le Murderer est très proche !',true) end
      lastMurderDanger=inDanger
      local currentGun=workspace:FindFirstChild('GunDrop',true)
      if currentGun and not lastGunDrop then notify('Le pistolet est tombé !',false) end
      lastGunDrop=currentGun
    else
      lastMurderDanger=false
    end
    if (state.escapeRoute or state.safeScan) and myRoot then
      local pos,msg=neo.scanSafeZone()
      safeCandidate=pos;safeCandidateAt=now
    end
    routeHUD.Visible=state.escapeRoute and myRoot~=nil and murder~=nil and safeCandidate~=nil
    if routeHUD.Visible then
      local heading=neo.directionArrow((autoNav.escapeGoal() or safeCandidate)-myRoot.Position)
      routeHUD.Text='FUITE '..heading..'  •  SUIS LE TRAIT ROUGE'
    end
    safeHUD.Visible=not state.autoFarm and state.safeScan and myRoot~=nil and safeCandidate~=nil
    if safeHUD.Visible then
      safeHUD.Text='ZONE DÉGAGÉE '..directionArrow(safeCandidate-myRoot.Position)
        ..'  '..math.floor((safeCandidate-myRoot.Position).Magnitude)..' studs'
    end
  end
  -- Mise a jour de la ligne 3D au sol, depuis la vraie position du personnage.
  if state.escapeRoute and murder and myRoot and (safeCandidate or autoNav.escapeGoal()) then
    if now-escapeGroundLast>(state.performance and .38 or .20) then
      escapeGroundLast=now
      local points=autoNav.pathPoints()
      if not points or not neo.drawPreparedEscapeLine(points) then
        neo.drawEscapeGroundLine(autoNav.escapeGoal() or safeCandidate)
      end
    end
  elseif #escapeGroundParts>0 then
    neo.hideEscapeGroundLine()
  end
  if (state.coinRadar or state.autoFarm) and now>nextCoinScan then
    nextCoinScan=now+(state.autoFarm and (state.performance and 2.2 or 1.5) or (state.performance and 12 or 8))
    neo.scanCoins()
  end
  coinHUD.Visible=state.coinRadar and not state.autoFarm
  if (state.coinRadar or state.autoFarm) and now>=stats.nextCoinHudRefresh then
    stats.nextCoinHudRefresh=now+.35
    local lines={state.autoFarm and ('AUTO-FARM : '..autoNav.message()) or 'RADAR PIÈCES / BONBONS'}
    local r=root(Local)
    for i=1,math.min(#coinCache,3) do
      local item=coinCache[i]
      if item.part and item.part.Parent and r then
        local kind=string.upper(item.kind or 'OBJET')
        table.insert(lines,kind..'  '..math.floor((r.Position-item.part.Position).Magnitude)..' studs')
      end
    end
    if #lines==1 then
      table.insert(lines,coinScanBusy and 'Analyse en cours...'
        or (coinDiag.candidates>0 and 'Objets detectes, cible en cours de selection'
        or 'Aucun objet identifiable'))
    end
    coinHUD.Text=table.concat(lines,'\n')
  end
  frameCount=frameCount+1
  if now-lastFPS>=1.2 then
    fps=math.floor(frameCount/(now-lastFPS))
    frameCount=0;lastFPS=now
  end
  if inspectorText and inspectorText.Parent and selected and selected.Parent==Players then
    if now-lastThreat>.8 then
      lastThreat=now
      inspectorText.Text=neo.inspectPlayer(selected)
    end
  end
  if now>=nextESP then
    nextESP=now+(state.performance and 1.8 or .65)
    neo.refreshESP();neo.refreshMovement();toggleLighting();neo.tryGrabGun()
  end
end)
connect(RunService.Stepped,function()
  if not active or (not state.noclip and not state._autoGhostActive and not state.manualFly) then return end
  local c=char(Local);if not c then return end
  for _,part in ipairs(c:GetDescendants()) do
    if part:IsA('BasePart') then
      if noclipSaved[part]==nil then noclipSaved[part]=part.CanCollide end
      part.CanCollide=false
    end
  end
end)
connect(UIS.JumpRequest,function()
  if state.infiniteJump and hum(Local) then hum(Local):ChangeState(Enum.HumanoidStateType.Jumping) end
end)
-- ATTACH : surveillance des references et nettoyage lorsque d autres mouvements reprennent.
connect(RunService.Heartbeat,function()
  local a=neo.attachCtl
  if not active or not a.target then return end
  local now=os.clock()
  if now-a.lastCheck<.35 then return end
  a.lastCheck=now
  if not a.joint or not a.joint.Parent or not a.targetRoot or not a.targetRoot.Parent
    or not a.localRoot or not a.localRoot.Parent or a.target.Parent~=Players
    or root(Local)~=a.localRoot or root(a.target)~=a.targetRoot
    or not alive(a.target) or not alive(Local) then
    neo.detachPlayer('avatar indisponible')
    return
  end
  if state.bodyBlock or state.autoFarm or state.autoEscape or state.followPlayer
     or state.combatPosition or state.freecam or watching or flingBusy then
    neo.detachPlayer('autre mode actif')
  end
end)
-- Reconstruit l'ESP rapidement lors de l'arrivee ou du respawn d'un joueur.
function neo.watchESPPlayer(p)
  if p==Local then return end
  connect(p.CharacterAdded,function()
    task.spawn(function()
      task.wait(.25)
      if active and (state.esp or state.gunESP) then pcall(neo.refreshESP) end
      task.wait(1)
      if active and (state.esp or state.gunESP) then pcall(neo.refreshESP) end
    end)
  end)
  connect(p.CharacterRemoving,function()
    local h=highlights[p]
    if h then pcall(function() h:Destroy() end);highlights[p]=nil end
    local b=neo.espLabels[p]
    if b then pcall(function() b:Destroy() end);neo.espLabels[p]=nil end
  end)
  if p.Character then
    task.defer(function()
      if active and (state.esp or state.gunESP) then pcall(neo.refreshESP) end
    end)
  end
end
connect(Players.PlayerAdded,neo.watchESPPlayer)
for _,p in ipairs(Players:GetPlayers()) do neo.watchESPPlayer(p) end
connect(Local.CharacterAdded,function(c)
  neo.grabWatchCharacter(c)
  neo.detachPlayer('reapparition')
  neo.stopManualFly()
  if neo.adminBlocked.freezeMove then
    neo.adminFreezeCtl.root=nil;neo.adminFreezeCtl.humanoid=nil
    task.defer(function() if active then neo.adminFreezeMovement(true) end end)
  end
  bodyBlock.stop('arrete apres reapparition')
  neo.stopCombatPosition()
  autoNav.halt();autoNav.resetEscape();autoNav.clearPlan()
  watching=nil;nextShot=0;shotBusy=false;shotCtl.queued=false;shotCtl.token=shotCtl.token+1;neo.stopFreecam();guardHUD.Visible=false;neo.deleteClone()
  safeCandidate=nil;neo.hideEscapeGroundLine();coinCache={}
  coinDiag.lastAt=0;nextCoinScan=0
  task.wait(.7)
  -- La GUI et les preferences restent; seuls les effets lies a l'ancien avatar sont retires.
  if active then neo.refreshMovement();pcall(neo.refreshESP);notify('Réapparition : options conservées.',false) end
end)
connect(Local.CharacterRemoving,function(c)
  local h=c and c:FindFirstChildOfClass('Humanoid')
  if h and h.Health<=0 and not neo.grabRound.locked then neo.grabMarkDead('CharacterRemoving mort') end
  neo.detachPlayer('mort')
  neo.stopManualFly()
  -- Ne pas laisser l'ancien BodyVelocity ou un MoveTo piloter le nouvel avatar.
  flingStop=true;killAllToken=killAllToken+1
  shotCtl.token=shotCtl.token+1;shotBusy=false;nextShot=0
  bodyBlock.stop('personnage elimine')
  neo.stopCombatPosition()
  autoNav.halt();autoNav.resetEscape();autoNav.clearPlan()
  neo.hideEscapeGroundLine()
end)
connect(Players.PlayerRemoving,function(plr)
  if neo.attachCtl.target==plr then neo.detachPlayer('cible partie') end
  aimHistory[plr]=nil
  if plr==selected then
    selected=nil;playerView='list';neo.clearTargetHighlight();flingStop=true
    if selectedTab=='JOUEURS' then showTab('JOUEURS') end
  end
  if plr==bodyBlock.target then bodyBlock.stop('la cible a quitte la partie') end
  if plr==followTarget then
    followTarget=nil;state.followPlayer=false
    notify('Le joueur suivi a quitté la partie.',false)
  end
  if plr==watching then
    neo.returnCameraToBody()
  end
end)
connect(Local.Idled,function()
  if state.antiAfk then
    pcall(function() VU:Button2Down(Vector2.zero,Camera.CFrame); task.wait(.2);VU:Button2Up(Vector2.zero,Camera.CFrame) end)
  end
end)
-- Croix deja branchee sur minimizeHub : ne pas detruire le menu.
-- Rate-limited role discovery; if MM2 removes the remote, weapon detection still works.
task.spawn(function()
  while active do
    local getter=RS:FindFirstChild('GetPlayerData',true)
    if getter and getter:IsA('RemoteFunction') then
      local ok,data=pcall(function() return getter:InvokeServer() end)
      if ok and type(data)=='table' then
        roles=data;rolesReceivedAt=os.clock()
        neo.grabObserveRound(data)
      end
    end
    local murder=findMurderer()
    local role=myRole()
    local alert=''
    if state.dangerAlert and murder and root(Local) then
      local distance=(root(murder).Position-root(Local).Position).Magnitude
      if distance<25 then alert='  |  DANGER : '..math.floor(distance)..' studs' end
    end
    if active then info.Text='Rôle : '..role..' | Murderer : '..(murder and murder.Name or '?')..' | '..fps..' FPS'..alert end
    task.wait(3)
  end
end)

_G.NEO_MM2_STOP=function()
  if not active then return end
  state.autoRoles=false
  if neo.autoRoleStop then neo.autoRoleStop('fermeture') end
  if neo.emotes then
    neo.emotes.cancelScan=true;neo.emotes.busy=false;neo.emotes.scanToken=neo.emotes.scanToken+1
    neo.emoteStop();neo.emoteSave(true)
  end
  neo.detachPlayer('fermeture du hub')
  -- Cleanup V4.0 : arret Body Block, puis rend les commandes et la camera.
  bodyBlock.stop()
  neo.stopCombatPosition()
  shotCtl.token=shotCtl.token+1;shotBusy=false;nextShot=0
  flingStop=true;killAllToken=killAllToken+1
  -- Sauvegarder les preferences AVANT de couper les automatismes.
  neo.saveOptions()
  neo.stopManualFly()
  neo.adminFreezeMovement(false)
  autoNav.halt();autoNav.resetEscape();autoNav.clearPlan();state.autoFarm=false;state.autoEscape=false
  state.followPlayer=false;followTarget=nil
  restoreNoclip()
  neo.stopFreecam()
  neo.deleteClone()
  threatHUD.Visible=false;routeHUD.Visible=false;safeHUD.Visible=false
  coinHUD.Visible=false;toast.Visible=false;guardHUD.Visible=false
  active=false
  neo.cleanupESP()
  neo.clearTrail()
  neo.hideEscapeGroundLine()
  if escapeGroundFolder and escapeGroundFolder.Parent then escapeGroundFolder:Destroy() end
  flingStop=true
  neo.clearTargetHighlight()
  state.speed=false;state.jump=false;state.bright=false
  pcall(neo.refreshMovement);pcall(toggleLighting)
  if hum(Local) then pcall(function() Camera.CameraSubject=hum(Local) end) end
  for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
  gui:Destroy()
  _G.NEO_MM2_STOP=nil
  if sharedEnv.NEO_MM2_STOP then sharedEnv.NEO_MM2_STOP=nil end
end
sharedEnv.NEO_MM2_STOP=_G.NEO_MM2_STOP
-- Le flag venant de la sauvegarde doit produire immediatement un effet visuel.
-- Plusieurs essais courts couvrent le chargement tardif des personnages sur mobile.
if state.esp or state.gunESP then
  pcall(neo.refreshESP)
  task.spawn(function()
    for _,delay in ipairs({.4,1.4,3.0}) do
      task.wait(delay)
      if not active then return end
      if state.esp or state.gunESP then pcall(neo.refreshESP) end
    end
  end)
end
neo.saveOptions()

-- V4.6 : tir YARHM 1.21, fling physique YARHM 1.21, et soudure locale ATTACH.
-- Source : https://github.com/Joystickplays/psychic-octo-invention
-- Le fling conserve les trajectoires et impulsions de YARHM avec nettoyage renforcé.
-- Le serveur MM2 peut refuser fling et weld local.

--[[
Source YARHM: Joystickplays / Aetherion
https://github.com/Joystickplays/psychic-octo-invention
Source: source/yarhm/1.21/yarhm.lua
Extraits adaptes pour NEO MM2 HUB V4.5.

                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.

  To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.

  Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.

  For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.

  Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.

  Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.

  The precise terms and conditions for copying, distribution and
modification follow.

                       TERMS AND CONDITIONS

  0. Definitions.

  "This License" refers to version 3 of the GNU General Public License.

  "Copyright" also means copyright-like laws that apply to other kinds of
works, such as semiconductor masks.

  "The Program" refers to any copyrightable work licensed under this
License.  Each licensee is addressed as "you".  "Licensees" and
"recipients" may be individuals or organizations.

  To "modify" a work means to copy from or adapt all or part of the work
in a fashion requiring copyright permission, other than the making of an
exact copy.  The resulting work is called a "modified version" of the
earlier work or a work "based on" the earlier work.

  A "covered work" means either the unmodified Program or a work based
on the Program.

  To "propagate" a work means to do anything with it that, without
permission, would make you directly or secondarily liable for
infringement under applicable copyright law, except executing it on a
computer or modifying a private copy.  Propagation includes copying,
distribution (with or without modification), making available to the
public, and in some countries other activities as well.

  To "convey" a work means any kind of propagation that enables other
parties to make or receive copies.  Mere interaction with a user through
a computer network, with no transfer of a copy, is not conveying.

  An interactive user interface displays "Appropriate Legal Notices"
to the extent that it includes a convenient and prominently visible
feature that (1) displays an appropriate copyright notice, and (2)
tells the user that there is no warranty for the work (except to the
extent that warranties are provided), that licensees may convey the
work under this License, and how to view a copy of this License.  If
the interface presents a list of user commands or options, such as a
menu, a prominent item in the list meets this criterion.

  1. Source Code.

  The "source code" for a work means the preferred form of the work
for making modifications to it.  "Object code" means any non-source
form of a work.

  A "Standard Interface" means an interface that either is an official
standard defined by a recognized standards body, or, in the case of
interfaces specified for a particular programming language, one that
is widely used among developers working in that language.

  The "System Libraries" of an executable work include anything, other
than the work as a whole, that (a) is included in the normal form of
packaging a Major Component, but which is not part of that Major
Component, and (b) serves only to enable use of the work with that
Major Component, or to implement a Standard Interface for which an
implementation is available to the public in source code form.  A
"Major Component", in this context, means a major essential component
(kernel, window system, and so on) of the specific operating system
(if any) on which the executable work runs, or a compiler used to
produce the work, or an object code interpreter used to run it.

  The "Corresponding Source" for a work in object code form means all
the source code needed to generate, install, and (for an executable
work) run the object code and to modify the work, including scripts to
control those activities.  However, it does not include the work's
System Libraries, or general-purpose tools or generally available free
programs which are used unmodified in performing those activities but
which are not part of the work.  For example, Corresponding Source
includes interface definition files associated with source files for
the work, and the source code for shared libraries and dynamically
linked subprograms that the work is specifically designed to require,
such as by intimate data communication or control flow between those
subprograms and other parts of the work.

  The Corresponding Source need not include anything that users
can regenerate automatically from other parts of the Corresponding
Source.

  The Corresponding Source for a work in source code form is that
same work.

  2. Basic Permissions.

  All rights granted under this License are granted for the term of
copyright on the Program, and are irrevocable provided the stated
conditions are met.  This License explicitly affirms your unlimited
permission to run the unmodified Program.  The output from running a
covered work is covered by this License only if the output, given its
content, constitutes a covered work.  This License acknowledges your
rights of fair use or other equivalent, as provided by copyright law.

  You may make, run and propagate covered works that you do not
convey, without conditions so long as your license otherwise remains
in force.  You may convey covered works to others for the sole purpose
of having them make modifications exclusively for you, or provide you
with facilities for running those works, provided that you comply with
the terms of this License in conveying all material for which you do
not control copyright.  Those thus making or running the covered works
for you must do so exclusively on your behalf, under your direction
and control, on terms that prohibit them from making any copies of
your copyrighted material outside their relationship with you.

  Conveying under any other circumstances is permitted solely under
the conditions stated below.  Sublicensing is not allowed; section 10
makes it unnecessary.

  3. Protecting Users' Legal Rights From Anti-Circumvention Law.

  No covered work shall be deemed part of an effective technological
measure under any applicable law fulfilling obligations under article
11 of the WIPO copyright treaty adopted on 20 December 1996, or
similar laws prohibiting or restricting circumvention of such
measures.

  When you convey a covered work, you waive any legal power to forbid
circumvention of technological measures to the extent such circumvention
is effected by exercising rights under this License with respect to
the covered work, and you disclaim any intention to limit operation or
modification of the work as a means of enforcing, against the work's
users, your or third parties' legal rights to forbid circumvention of
technological measures.

  4. Conveying Verbatim Copies.

  You may convey verbatim copies of the Program's source code as you
receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy an appropriate copyright notice;
keep intact all notices stating that this License and any
non-permissive terms added in accord with section 7 apply to the code;
keep intact all notices of the absence of any warranty; and give all
recipients a copy of this License along with the Program.

  You may charge any price or no price for each copy that you convey,
and you may offer support or warranty protection for a fee.

  5. Conveying Modified Source Versions.

  You may convey a work based on the Program, or the modifications to
produce it from the Program, in the form of source code under the
terms of section 4, provided that you also meet all of these conditions:

    a) The work must carry prominent notices stating that you modified
    it, and giving a relevant date.

    b) The work must carry prominent notices stating that it is
    released under this License and any conditions added under section
    7.  This requirement modifies the requirement in section 4 to
    "keep intact all notices".

    c) You must license the entire work, as a whole, under this
    License to anyone who comes into possession of a copy.  This
    License will therefore apply, along with any applicable section 7
    additional terms, to the whole of the work, and all its parts,
    regardless of how they are packaged.  This License gives no
    permission to license the work in any other way, but it does not
    invalidate such permission if you have separately received it.

    d) If the work has interactive user interfaces, each must display
    Appropriate Legal Notices; however, if the Program has interactive
    interfaces that do not display Appropriate Legal Notices, your
    work need not make them do so.

  A compilation of a covered work with other separate and independent
works, which are not by their nature extensions of the covered work,
and which are not combined with it such as to form a larger program,
in or on a volume of a storage or distribution medium, is called an
"aggregate" if the compilation and its resulting copyright are not
used to limit the access or legal rights of the compilation's users
beyond what the individual works permit.  Inclusion of a covered work
in an aggregate does not cause this License to apply to the other
parts of the aggregate.

  6. Conveying Non-Source Forms.

  You may convey a covered work in object code form under the terms
of sections 4 and 5, provided that you also convey the
machine-readable Corresponding Source under the terms of this License,
in one of these ways:

    a) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by the
    Corresponding Source fixed on a durable physical medium
    customarily used for software interchange.

    b) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by a
    written offer, valid for at least three years and valid for as
    long as you offer spare parts or customer support for that product
    model, to give anyone who possesses the object code either (1) a
    copy of the Corresponding Source for all the software in the
    product that is covered by this License, on a durable physical
    medium customarily used for software interchange, for a price no
    more than your reasonable cost of physically performing this
    conveying of source, or (2) access to copy the
    Corresponding Source from a network server at no charge.

    c) Convey individual copies of the object code with a copy of the
    written offer to provide the Corresponding Source.  This
    alternative is allowed only occasionally and noncommercially, and
    only if you received the object code with such an offer, in accord
    with subsection 6b.

    d) Convey the object code by offering access from a designated
    place (gratis or for a charge), and offer equivalent access to the
    Corresponding Source in the same way through the same place at no
    further charge.  You need not require recipients to copy the
    Corresponding Source along with the object code.  If the place to
    copy the object code is a network server, the Corresponding Source
    may be on a different server (operated by you or a third party)
    that supports equivalent copying facilities, provided you maintain
    clear directions next to the object code saying where to find the
    Corresponding Source.  Regardless of what server hosts the
    Corresponding Source, you remain obligated to ensure that it is
    available for as long as needed to satisfy these requirements.

    e) Convey the object code using peer-to-peer transmission, provided
    you inform other peers where the object code and Corresponding
    Source of the work are being offered to the general public at no
    charge under subsection 6d.

  A separable portion of the object code, whose source code is excluded
from the Corresponding Source as a System Library, need not be
included in conveying the object code work.

  A "User Product" is either (1) a "consumer product", which means any
tangible personal property which is normally used for personal, family,
or household purposes, or (2) anything designed or sold for incorporation
into a dwelling.  In determining whether a product is a consumer product,
doubtful cases shall be resolved in favor of coverage.  For a particular
product received by a particular user, "normally used" refers to a
typical or common use of that class of product, regardless of the status
of the particular user or of the way in which the particular user
actually uses, or expects or is expected to use, the product.  A product
is a consumer product regardless of whether the product has substantial
commercial, industrial or non-consumer uses, unless such uses represent
the only significant mode of use of the product.

  "Installation Information" for a User Product means any methods,
procedures, authorization keys, or other information required to install
and execute modified versions of a covered work in that User Product from
a modified version of its Corresponding Source.  The information must
suffice to ensure that the continued functioning of the modified object
code is in no case prevented or interfered with solely because
modification has been made.

  If you convey an object code work under this section in, or with, or
specifically for use in, a User Product, and the conveying occurs as
part of a transaction in which the right of possession and use of the
User Product is transferred to the recipient in perpetuity or for a
fixed term (regardless of how the transaction is characterized), the
Corresponding Source conveyed under this section must be accompanied
by the Installation Information.  But this requirement does not apply
if neither you nor any third party retains the ability to install
modified object code on the User Product (for example, the work has
been installed in ROM).

  The requirement to provide Installation Information does not include a
requirement to continue to provide support service, warranty, or updates
for a work that has been modified or installed by the recipient, or for
the User Product in which it has been modified or installed.  Access to a
network may be denied when the modification itself materially and
adversely affects the operation of the network or violates the rules and
protocols for communication across the network.

  Corresponding Source conveyed, and Installation Information provided,
in accord with this section must be in a format that is publicly
documented (and with an implementation available to the public in
source code form), and must require no special password or key for
unpacking, reading or copying.

  7. Additional Terms.

  "Additional permissions" are terms that supplement the terms of this
License by making exceptions from one or more of its conditions.
Additional permissions that are applicable to the entire Program shall
be treated as though they were included in this License, to the extent
that they are valid under applicable law.  If additional permissions
apply only to part of the Program, that part may be used separately
under those permissions, but the entire Program remains governed by
this License without regard to the additional permissions.

  When you convey a copy of a covered work, you may at your option
remove any additional permissions from that copy, or from any part of
it.  (Additional permissions may be written to require their own
removal in certain cases when you modify the work.)  You may place
additional permissions on material, added by you to a covered work,
for which you have or can give appropriate copyright permission.

  Notwithstanding any other provision of this License, for material you
add to a covered work, you may (if authorized by the copyright holders of
that material) supplement the terms of this License with terms:

    a) Disclaiming warranty or limiting liability differently from the
    terms of sections 15 and 16 of this License; or

    b) Requiring preservation of specified reasonable legal notices or
    author attributions in that material or in the Appropriate Legal
    Notices displayed by works containing it; or

    c) Prohibiting misrepresentation of the origin of that material, or
    requiring that modified versions of such material be marked in
    reasonable ways as different from the original version; or

    d) Limiting the use for publicity purposes of names of licensors or
    authors of the material; or

    e) Declining to grant rights under trademark law for use of some
    trade names, trademarks, or service marks; or

    f) Requiring indemnification of licensors and authors of that
    material by anyone who conveys the material (or modified versions of
    it) with contractual assumptions of liability to the recipient, for
    any liability that these contractual assumptions directly impose on
    those licensors and authors.

  All other non-permissive additional terms are considered "further
restrictions" within the meaning of section 10.  If the Program as you
received it, or any part of it, contains a notice stating that it is
governed by this License along with a term that is a further
restriction, you may remove that term.  If a license document contains
a further restriction but permits relicensing or conveying under this
License, you may add to a covered work material governed by the terms
of that license document, provided that the further restriction does
not survive such relicensing or conveying.

  If you add terms to a covered work in accord with this section, you
must place, in the relevant source files, a statement of the
additional terms that apply to those files, or a notice indicating
where to find the applicable terms.

  Additional terms, permissive or non-permissive, may be stated in the
form of a separately written license, or stated as exceptions;
the above requirements apply either way.

  8. Termination.

  You may not propagate or modify a covered work except as expressly
provided under this License.  Any attempt otherwise to propagate or
modify it is void, and will automatically terminate your rights under
this License (including any patent licenses granted under the third
paragraph of section 11).

  However, if you cease all violation of this License, then your
license from a particular copyright holder is reinstated (a)
provisionally, unless and until the copyright holder explicitly and
finally terminates your license, and (b) permanently, if the copyright
holder fails to notify you of the violation by some reasonable means
prior to 60 days after the cessation.

  Moreover, your license from a particular copyright holder is
reinstated permanently if the copyright holder notifies you of the
violation by some reasonable means, this is the first time you have
received notice of violation of this License (for any work) from that
copyright holder, and you cure the violation prior to 30 days after
your receipt of the notice.

  Termination of your rights under this section does not terminate the
licenses of parties who have received copies or rights from you under
this License.  If your rights have been terminated and not permanently
reinstated, you do not qualify to receive new licenses for the same
material under section 10.

  9. Acceptance Not Required for Having Copies.

  You are not required to accept this License in order to receive or
run a copy of the Program.  Ancillary propagation of a covered work
occurring solely as a consequence of using peer-to-peer transmission
to receive a copy likewise does not require acceptance.  However,
nothing other than this License grants you permission to propagate or
modify any covered work.  These actions infringe copyright if you do
not accept this License.  Therefore, by modifying or propagating a
covered work, you indicate your acceptance of this License to do so.

  10. Automatic Licensing of Downstream Recipients.

  Each time you convey a covered work, the recipient automatically
receives a license from the original licensors, to run, modify and
propagate that work, subject to this License.  You are not responsible
for enforcing compliance by third parties with this License.

  An "entity transaction" is a transaction transferring control of an
organization, or substantially all assets of one, or subdividing an
organization, or merging organizations.  If propagation of a covered
work results from an entity transaction, each party to that
transaction who receives a copy of the work also receives whatever
licenses to the work the party's predecessor in interest had or could
give under the previous paragraph, plus a right to possession of the
Corresponding Source of the work from the predecessor in interest, if
the predecessor has it or can get it with reasonable efforts.

  You may not impose any further restrictions on the exercise of the
rights granted or affirmed under this License.  For example, you may
not impose a license fee, royalty, or other charge for exercise of
rights granted under this License, and you may not initiate litigation
(including a cross-claim or counterclaim in a lawsuit) alleging that
any patent claim is infringed by making, using, selling, offering for
sale, or importing the Program or any portion of it.

  11. Patents.

  A "contributor" is a copyright holder who authorizes use under this
License of the Program or a work on which the Program is based.  The
work thus licensed is called the contributor's "contributor version".

  A contributor's "essential patent claims" are all patent claims
owned or controlled by the contributor, whether already acquired or
hereafter acquired, that would be infringed by some manner, permitted
by this License, of making, using, or selling its contributor version,
but do not include claims that would be infringed only as a
consequence of further modification of the contributor version.  For
purposes of this definition, "control" includes the right to grant
patent sublicenses in a manner consistent with the requirements of
this License.

  Each contributor grants you a non-exclusive, worldwide, royalty-free
patent license under the contributor's essential patent claims, to
make, use, sell, offer for sale, import and otherwise run, modify and
propagate the contents of its contributor version.

  In the following three paragraphs, a "patent license" is any express
agreement or commitment, however denominated, not to enforce a patent
(such as an express permission to practice a patent or covenant not to
sue for patent infringement).  To "grant" such a patent license to a
party means to make such an agreement or commitment not to enforce a
patent against the party.

  If you convey a covered work, knowingly relying on a patent license,
and the Corresponding Source of the work is not available for anyone
to copy, free of charge and under the terms of this License, through a
publicly available network server or other readily accessible means,
then you must either (1) cause the Corresponding Source to be so
available, or (2) arrange to deprive yourself of the benefit of the
patent license for this particular work, or (3) arrange, in a manner
consistent with the requirements of this License, to extend the patent
license to downstream recipients.  "Knowingly relying" means you have
actual knowledge that, but for the patent license, your conveying the
covered work in a country, or your recipient's use of the covered work
in a country, would infringe one or more identifiable patents in that
country that you have reason to believe are valid.

  If, pursuant to or in connection with a single transaction or
arrangement, you convey, or propagate by procuring conveyance of, a
covered work, and grant a patent license to some of the parties
receiving the covered work authorizing them to use, propagate, modify
or convey a specific copy of the covered work, then the patent license
you grant is automatically extended to all recipients of the covered
work and works based on it.

  A patent license is "discriminatory" if it does not include within
the scope of its coverage, prohibits the exercise of, or is
conditioned on the non-exercise of one or more of the rights that are
specifically granted under this License.  You may not convey a covered
work if you are a party to an arrangement with a third party that is
in the business of distributing software, under which you make payment
to the third party based on the extent of your activity of conveying
the work, and under which the third party grants, to any of the
parties who would receive the covered work from you, a discriminatory
patent license (a) in connection with copies of the covered work
conveyed by you (or copies made from those copies), or (b) primarily
for and in connection with specific products or compilations that
contain the covered work, unless you entered into that arrangement,
or that patent license was granted, prior to 28 March 2007.

  Nothing in this License shall be construed as excluding or limiting
any implied license or other defenses to infringement that may
otherwise be available to you under applicable patent law.

  12. No Surrender of Others' Freedom.

  If conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot convey a
covered work so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you may
not convey it at all.  For example, if you agree to terms that obligate you
to collect a royalty for further conveying from those to whom you convey
the Program, the only way you could satisfy both those terms and this
License would be to refrain entirely from conveying the Program.

  13. Use with the GNU Affero General Public License.

  Notwithstanding any other provision of this License, you have
permission to link or combine any covered work with a work licensed
under version 3 of the GNU Affero General Public License into a single
combined work, and to convey the resulting work.  The terms of this
License will continue to apply to the part which is the covered work,
but the special requirements of the GNU Affero General Public License,
section 13, concerning interaction through a network will apply to the
combination as such.

  14. Revised Versions of this License.

  The Free Software Foundation may publish revised and/or new versions of
the GNU General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

  Each version is given a distinguishing version number.  If the
Program specifies that a certain numbered version of the GNU General
Public License "or any later version" applies to it, you have the
option of following the terms and conditions either of that numbered
version or of any later version published by the Free Software
Foundation.  If the Program does not specify a version number of the
GNU General Public License, you may choose any version ever published
by the Free Software Foundation.

  If the Program specifies that a proxy can decide which future
versions of the GNU General Public License can be used, that proxy's
public statement of acceptance of a version permanently authorizes you
to choose that version for the Program.

  Later license versions may give you additional or different
permissions.  However, no additional obligations are imposed on any
author or copyright holder as a result of your choosing to follow a
later version.

  15. Disclaimer of Warranty.

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

  16. Limitation of Liability.

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

  17. Interpretation of Sections 15 and 16.

  If the disclaimer of warranty and limitation of liability provided
above cannot be given local legal effect according to their terms,
reviewing courts shall apply local law that most closely approximates
an absolute waiver of all civil liability in connection with the
Program, unless a warranty or assumption of liability accompanies a
copy of the Program in return for a fee.

                     END OF TERMS AND CONDITIONS

            How to Apply These Terms to Your New Programs

  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
state the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) <year>  <name of author>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

Also add information on how to contact you by electronic and paper mail.

  If the program does terminal interaction, make it output a short
notice like this when it starts in an interactive mode:

    <program>  Copyright (C) <year>  <name of author>
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.

The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, your program's commands
might be different; for a GUI interface, you would use an "about box".

  You should also get your employer (if you work as a programmer) or school,
if any, to sign a "copyright disclaimer" for the program, if necessary.
For more information on this, and how to apply and follow the GNU GPL, see
<https://www.gnu.org/licenses/>.

  The GNU General Public License does not permit incorporating your program
into proprietary programs.  If your program is a subroutine library, you
may consider it more useful to permit linking proprietary applications with
the library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.  But first, please read
<https://www.gnu.org/licenses/why-not-lgpl.html>.

]]
