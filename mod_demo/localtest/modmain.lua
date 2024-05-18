local _G = GLOBAL
local TheNet = _G.TheNet
local TheSim = _G.TheSim

Assets = {
	Asset("IMAGE", "images/gesture_bg.tex"),
	Asset("ATLAS", "images/gesture_bg.xml"),
}

-- function onStatusResponse(response, isSuccessful, resultCode)
-- 	local result = "empty result"
-- 	if isSuccessful and string.len(response) > 0 and resultCode == 200 then
-- 		result = "Successful GET"
-- 	else
-- 		result = "GET Failed."
-- 		--print("Failed to announce status ["..resultcode.."] response")
-- 	end
-- 	return result, response
-- end

function onStatusResponse(response, isSuccessful, resultCode)
    local result
    if isSuccessful and string.len(response) > 0 and resultCode == 200 then
        result = "Successful GET"
    else
        result = "GET Failed."
        --print("Failed to announce status ["..resultCode.."] response")
    end
    TheNet:Say("The GET result is " .. result)
    TheNet:Say("The response is " .. string.sub(response, 1, 50))
end

function sendRequest(emoteName)
    local url = "https://www.bing.com/search?q=" .. emoteName
    TheNet:Say("send a GET request to " .. url)
    TheSim:QueryServer(
        "https://www.bing.com/search?q=" .. emoteName,
        function(...) onStatusResponse(...) end,
        "GET"
    )
end




-- 从mod的配置中获取键盘切换键（KEYBOARDTOGGLEKEY），如果没有设置，则默认为"G"。如果获取的键是字符串类型，那么将其转为小写并获取其ASCII值
KEYBOARDTOGGLEKEY = GetModConfigData("KEYBOARDTOGGLEKEY") or "G"
if type(KEYBOARDTOGGLEKEY) == "string" then
	KEYBOARDTOGGLEKEY = KEYBOARDTOGGLEKEY:lower():byte()
end
-- 图像缩放比例
local SCALEFACTOR = GetModConfigData("SCALEFACTOR") or 1
-- 是否中心化轮盘
local CENTERWHEEL = GetModConfigData("CENTERWHEEL")
--Gross way of handling the default behavior, but I don't see a better option
if CENTERWHEEL == nil then CENTERWHEEL = true end
-- 恢复光标选项
local RESTORECURSOROPTIONS = GetModConfigData("RESTORECURSOR") or 3
if not CENTERWHEEL and RESTORECURSOROPTIONS == 3 then
	--if the wheel isn't centered, then restoring basically just puts it where it was already
	-- so turn that off to prevent jitter
	RESTORECURSOROPTIONS = 0
end
-- 根据之前的设置，定义是否中心化光标（CENTERCURSOR），是否恢复光标（RESTORECURSOR），以及是否调整光标（ADJUSTCURSOR
--0 means don't center or restore, even if the wheel is centered
local CENTERCURSOR  = CENTERWHEEL and (RESTORECURSOROPTIONS >= 1)
local RESTORECURSOR = RESTORECURSOROPTIONS >= 2
local ADJUSTCURSOR  = RESTORECURSOROPTIONS >= 3
-- 从mod的配置中获取图像文本（IMAGETEXT），如果没有设置，则默认为2。
-- 根据图像文本的值，定义是否显示图像（SHOWIMAGE）和是否显示文本（SHOWTEXT）
local IMAGETEXT = GetModConfigData("IMAGETEXT") or 2
local SHOWIMAGE = IMAGETEXT > 1
local SHOWTEXT = IMAGETEXT%2 == 1
-- 从mod的配置中获取是否使用右摇杆（RIGHTSTICK）。如果在配置中设置了不使用左摇杆，那么将使用右摇杆。
local RIGHTSTICK = GetModConfigData("RIGHTSTICK")
--Backward-compatibility if they had changed the option
if GetModConfigData("LEFTSTICK") == false then RIGHTSTICK = true end
-- ONLYEIGHT isn't compatible with multiple rings; it will disable Party and Old emotes
-- 从mod的配置中获取是否只有八个选项（ONLYEIGHT）。
local ONLYEIGHT = GetModConfigData("ONLYEIGHT")
local EIGHTS = {}
for i=1,8 do
	EIGHTS[i] = GetModConfigData("EIGHT"..i)
end

--Constants for the emote definitions; name is used for display text, anim for puppet animation

local DEFAULT_EMOTES = {
	{name = "rude",		anim = {anim="emoteXL_waving4", randomanim=true}},
	{name = "annoyed",	anim = {anim="emoteXL_annoyed"}},
	{name = "sad",		anim = {anim="emoteXL_sad", fx="tears", fxoffset={0.25,3.25,0}, fxdelay=17*GLOBAL.FRAMES}},
	{name = "joy",		anim = {anim="research", fx=false}},
	{name = "facepalm",	anim = {anim="emoteXL_facepalm"}},
	{name = "wave",		anim = {anim={"emoteXL_waving1", "emoteXL_waving2", "emoteXL_waving3"}, randomanim=true}},
	{name = "dance",	anim = {anim ={ "emoteXL_pre_dance0", "emoteXL_loop_dance0" }, loop = true, fx = false, beaver = true }},
	{name = "pose",		anim = {anim = "emote_strikepose", zoom = true, soundoverride = "/pose"}},
	{name = "kiss",		anim = {anim="emoteXL_kiss"}},
	{name = "bonesaw",	anim = {anim="emoteXL_bonesaw"}},
	{name = "happy",	anim = {anim="emoteXL_happycheer"}},
	{name = "angry",	anim = {anim="emoteXL_angry"}},
	{name = "sit",		anim = {anim={{"emote_pre_sit2", "emote_loop_sit2"}, {"emote_pre_sit4", "emote_loop_sit4"}}, randomanim = true, loop = true, fx = false}},
	{name = "squat",	anim = {anim={{"emote_pre_sit1", "emote_loop_sit1"}, {"emote_pre_sit3", "emote_loop_sit3"}}, randomanim = true, loop = true, fx = false}},
	{name = "toast",	anim = {anim={ "emote_pre_toast", "emote_loop_toast" }, loop = true, fx = false }},
	-- TODO: make sure this list stays up to date
}
--These emotes are unlocked by certain cosmetic Steam/skin items
local EMOTE_ITEMS = {
	{name = "sleepy",	anim = {anim="emote_sleepy"},		item = "emote_sleepy"},
	{name = "yawn",		anim = {anim="emote_yawn"},			item = "emote_yawn"},
	{name = "swoon",	anim = {anim="emote_swoon"},		item = "emote_swoon"},
	{name = "chicken",	anim = {anim="emoteXL_loop_dance6"},item = "emote_dance_chicken"},
	{name = "robot",	anim = {anim="emoteXL_loop_dance8"},item = "emote_dance_robot"},
	{name = "step",		anim = {anim="emoteXL_loop_dance7"},item = "emote_dance_step"},
	{name = "fistshake",anim = {anim="emote_fistshake"},	item = "emote_fistshake"},
	{name = "flex",		anim = {anim="emote_flex"},			item = "emote_flex"},
	{name = "impatient",anim = {anim="emote_impatient"},	item = "emote_impatient"},
	{name = "cheer",	anim = {anim="emote_jumpcheer"},	item = "emote_jumpcheer"},
	{name = "laugh",	anim = {anim="emote_laugh"},		item = "emote_laugh"},
	{name = "shrug",	anim = {anim="emote_shrug"},		item = "emote_shrug"},
	{name = "slowclap",	anim = {anim="emote_slowclap"},		item = "emote_slowclap"},
	{name = "carol",	anim = {anim="emote_loop_carol"},	item = "emote_carol"},
}

--Checking for other emote mods
-- 检查两个特定的mod是否已经启用
-- PARTY DANCE https://steamcommunity.com/sharedfiles/filedetails/?id=437521942
-- Old Emotes https://steamcommunity.com/sharedfiles/filedetails/?id=732180082
local PARTY_ADDED = GLOBAL.KnownModIndex:IsModEnabled("workshop-437521942")
local OLD_ADDED = GLOBAL.KnownModIndex:IsModEnabled("workshop-732180082")
for k,v in pairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
	PARTY_ADDED = PARTY_ADDED or v == "workshop-437521942"
	OLD_ADDED = OLD_ADDED or v == "workshop-732180082"
end

-- 如果 PARTY_ADDED "workshop-437521942" 这个mod被启用，并且只有八个选项的设置（ONLYEIGHT）为 false，
-- 那么定义一个名为 "party" 的表情集，包含了一系列的表情。每个表情都有一个名称和一个动画设置。
local PARTY_EMOTES = nil
if PARTY_ADDED and not ONLYEIGHT then
	PARTY_EMOTES = 
		{
			name = "party",
			emotes = 
			{
				{name = "dance2",	anim = {anim = "idle_onemanband1_loop"}},
				{name = "dance3",	anim = {anim = "idle_onemanband2_loop"}},
				{name = "run",		anim = {anim = {"run_pre", "run_loop", "run_loop", "run_loop", "run_pst"}}},
				{name = "thriller",	anim = {anim = "mime2"}},
				{name = "choochoo",	anim = {anim = "mime3"}},
				{name = "plsgo",	anim = {anim = "mime4"}},
				{name = "ez",		anim = {anim = "mime5"}},
				{name = "box",		anim = {anim = "mime6"}},
				{name = "bicycle",	anim = {anim = "mime8"}},
				{name = "comehere",	anim = {anim = "mime7"}},
				{name = "wasted",	anim = {anim = "sleep_loop"}},
				{name = "buffed",	anim = {anim = "powerup"}},
				{name = "pushup",	anim = {anim = "powerdown"}},
				{name = "fakebed",	anim = {anim = "bedroll_sleep_loop"}},
				{name = "shocked",	anim = {anim = "shock"}},
				{name = "dead",		anim = {anim = {"death", "wakeup"}}},
				{name = "spooked",	anim = {anim = "distress_loop"}},
			},
			radius = 375,
			color = GLOBAL.PLAYERCOLOURS.FUSCHIA,
		}
end


-- 如果 "workshop-732180082" 这个mod被启用，并且只有八个选项的设置（ONLYEIGHT）为 false，
-- 那么定义一个名为 "old" 的表情集，也包含了一系列的表情。
local OLD_EMOTES = nil
if OLD_ADDED and not ONLYEIGHT then
	OLD_EMOTES = 
		{
			name = "old",
			emotes = 
			{
				{name = "angry2",	anim = {anim = "emote_angry"}},
				{name = "annoyed2",	anim = {anim = "emote_annoyed_palmdown"}},
				{name = "gdi",		anim = {anim = "emote_annoyed_facepalm"}},
				{name = "pose2",	anim = {anim = "emote_feet"}},
				{name = "pose3",	anim = {anim = "emote_hands"}},
				{name = "pose4",	anim = {anim = "emote_hat"}},
				{name = "pose5",	anim = {anim = "emote_pants"}},
				{name = "grats",	anim = {anim = "emote_happycheer"}},
				{name = "sigh",		anim = {anim = "emote_sad"}},
				{name = "heya",		anim = {anim = "emote_waving"}},
			},
			radius = 175,
			color = GLOBAL.DARKGREY,
		}
end

local emote_sets = {}

local function BuildEmoteSets()
	emote_sets = {}
	-- 如果 PARTY_EMOTES 或 OLD_EMOTES 不为 nil（即之前检查的mod已启用），则将它们添加到 emote_sets 表中
	if PARTY_EMOTES ~= nil then
		table.insert(emote_sets, PARTY_EMOTES)
	end

	if OLD_EMOTES ~= nil then
		table.insert(emote_sets, OLD_EMOTES)
	end
	
	-- EMOTES 用于存储所有默认的表情，EMOTE_ITEMS_OWNED 用于存储玩家已经拥有的通过Steam/skin项目解锁的表情
	--Add in all the default emotes
	local EMOTES = {}
	--Check if we have some of the emote items
	local EMOTE_ITEMS_OWNED = {}
	local TheInventory = GLOBAL.TheInventory
	-- 遍历 EMOTE_ITEMS 表，使用 GLOBAL.TheInventory:CheckOwnership 函数检查玩家是否拥有每个表情所需的项目。
	-- 如果玩家拥有，那么将这个表情添加到 EMOTE_ITEMS_OWNED 表中
	for _,item in pairs(EMOTE_ITEMS) do
		if TheInventory:CheckOwnership(item.item) then
			table.insert(EMOTE_ITEMS_OWNED, item)
		end
	end

	-- 如果 ONLYEIGHT 为 true，那么将只使用 DEFAULT_EMOTES 和 EMOTE_ITEMS_OWNED 中的表情，
	-- 并将它们添加到 EIGHTABLE_EMOTES 表中，然后将 EIGHTS 表中的表情添加到 EMOTES 表中
	if ONLYEIGHT then
		-- Build a lookup table for emotes that are allowable here
		EIGHTABLE_EMOTES = {}
		for _,e in pairs(DEFAULT_EMOTES) do
			EIGHTABLE_EMOTES[e.name] = e
		end
		for _,e in pairs(EMOTE_ITEMS_OWNED) do
			EIGHTABLE_EMOTES[e.name] = e
		end
		for _,v in ipairs(EIGHTS) do
			table.insert(EMOTES, EIGHTABLE_EMOTES[v])
		end
	-- 否则，将 DEFAULT_EMOTES 中的所有表情添加到 EMOTES 表中
	else
		for _,v in ipairs(DEFAULT_EMOTES) do
			table.insert(EMOTES, v)
		end
		-- If we have only two emotes, put them in the normal wheel; a 2-item wheel is... not round
		-- Otherwise, we can make an inner wheel for them
		-- 如果 EMOTE_ITEMS_OWNED 中的表情数量大于2，那么将它们作为一个新的表情集添加到 emote_sets 表中
		if #EMOTE_ITEMS_OWNED > 2 then
			table.insert(emote_sets, {
				name = "unlockable",
				emotes = EMOTE_ITEMS_OWNED,
				radius = 260, -- will need to be adjusted if number of emotes changes
				color = GLOBAL.PLAYERCOLOURS.PERU,
			})
		-- 如果 EMOTE_ITEMS_OWNED 中的表情数量大于0，那么将它们添加到 EMOTES 表中
		elseif #EMOTE_ITEMS_OWNED > 0 then
			for _,v in pairs(EMOTE_ITEMS_OWNED) do
				table.insert(EMOTES, v)
			end
		end
	end
	-- 最后，将包含所有 EMOTES 的表情集添加到 emote_sets 表中。这个表情集的名称是 "default"，半径和颜色根据 ONLYEIGHT 的值来确定
	table.insert(
		emote_sets, 
		{
			name = "default",
			emotes = EMOTES,
			radius = ONLYEIGHT and 250 or 325,
			color = GLOBAL.BROWN,
		}
	)
end

--All code below is for handling the wheel
-- 导入了 GestureWheel 类，这是一个游戏中的控件，用于显示和处理表情轮盘
local GestureWheel = GLOBAL.require("widgets/gesturewheel")

--Variables to control the display of the wheel
-- 定义了一些变量，用于控制表情轮盘的显示和交互，包括鼠标的位置（cursorx 和 cursory），
-- 表情轮盘的中心位置（centerx 和 centery），控制器（controls），表情轮盘（gesturewheel），
-- 键盘是否按下（keydown），是否正在使用表情轮盘（using_gesture_wheel），
-- 以及一些用于控制表情轮盘的缩放的变量（NORMSCALE 和 STARTSCALE）
local cursorx = 0
local cursory = 0
local centerx = 0
local centery = 0
local controls = nil
local gesturewheel = nil
local keydown = false
local using_gesture_wheel = false
local NORMSCALE = nil
local STARTSCALE = nil

-- CanUseGestureWheel 函数用于检查玩家是否可以使用表情轮盘。
-- 它首先检查当前的屏幕是否是HUD屏幕，然后检查玩家是否存在，最后检查玩家的控制器是否启用。
local function CanUseGestureWheel()
	local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
	screen = (screen and type(screen.name) == "string") and screen.name or ""
	if screen:find("HUD") == nil or not GLOBAL.ThePlayer then
		return false
	end
	local full_enabled, soft_enabled = GLOBAL.ThePlayer.components.playercontroller:IsEnabled()
	return full_enabled or soft_enabled or using_gesture_wheel
end

-- ResetTransform 函数用于重置表情轮盘的位置和缩放。
-- 它首先获取屏幕的大小，然后计算表情轮盘的中心位置，然后计算屏幕的缩放因子，最后设置表情轮盘的位置和缩放
local function ResetTransform()
	local screenwidth, screenheight = GLOBAL.TheSim:GetScreenSize()
	centerx = math.floor(screenwidth/2 + 0.5)
	centery = math.floor(screenheight/2 + 0.5)
	local screenscalefactor = math.min(screenwidth/1920, screenheight/1080) --normalize by my testing setup, 1080p
	gesturewheel.screenscalefactor = SCALEFACTOR*screenscalefactor
	NORMSCALE = SCALEFACTOR*screenscalefactor
	STARTSCALE = 0
	gesturewheel:SetPosition(centerx, centery, 0)
	gesturewheel.inst.UITransform:SetScale(STARTSCALE, STARTSCALE, 1)
end

-- ShowGestureWheel 函数用于显示表情轮盘
local function ShowGestureWheel(controller_mode)
	-- 如果 keydown（表示按键是否已经按下）为 true，函数就直接返回，不执行后续的代码
	if keydown then return end
	-- 检查 GLOBAL.ThePlayer 和 GLOBAL.ThePlayer.HUD 是否存在并且是表类型。如果不是，函数就直接返回
	if type(GLOBAL.ThePlayer) ~= "table" or type(GLOBAL.ThePlayer.HUD) ~= "table" then return end
	-- 调用 CanUseGestureWheel 函数检查玩家是否可以使用表情轮盘。如果不能，函数就直接返回
	if not CanUseGestureWheel() then return end
	
	-- 表示按键已经按下
	keydown = true
	-- 调用 SetModHUDFocus 函数，将 HUD 的焦点设置到表情轮盘上
	SetModHUDFocus("GestureWheel", true)
	-- 表示正在使用表情轮盘
	using_gesture_wheel = true
	
	-- 重置表情轮盘的位置和缩放
	ResetTransform()
	
	-- 如果 SHOWIMAGE 为 true，则遍历 gesturewheel.gestures 中的每一个表情，调用其 RefreshSkins 方法来刷新表情的显示
    if SHOWIMAGE then
        for _,gesturebadge in pairs(gesturewheel.gestures) do
            gesturebadge:RefreshSkins()
        end
    end
	
	-- 如果 RESTORECURSOR 为 true，则获取当前的鼠标位置，并将其保存在 cursorx 和 cursory 中
	if RESTORECURSOR then
		cursorx, cursory = GLOBAL.TheInputProxy:GetOSCursorPos()
	end
	
	-- 如果 CENTERCURSOR 为 true，则将鼠标位置设置到表情轮盘的中心位置
	if CENTERCURSOR then
		GLOBAL.TheInputProxy:SetOSCursorPos(centerx, centery)
	end

	-- 如果 CENTERWHEEL 为 true，则将表情轮盘的位置设置到屏幕的中心，否则将表情轮盘的位置设置到鼠标当前的位置
	if CENTERWHEEL then
		gesturewheel:SetPosition(centerx, centery, 0)
	else
		gesturewheel:SetPosition(GLOBAL.TheInput:GetScreenPosition():Get())
	end

	-- 设置表情轮盘的控制器模式
	gesturewheel:SetControllerMode(controller_mode)
	-- 显示表情轮盘
	gesturewheel:Show()
	-- 将表情轮盘从 STARTSCALE 缩放到 NORMSCALE，缩放过程的时间为0.25秒
	gesturewheel:ScaleTo(STARTSCALE, NORMSCALE, .25)
end

-- 用于隐藏和重置表情轮盘
local function HideGestureWheel(delay_focus_loss)
	-- 检查 GLOBAL.ThePlayer 和 GLOBAL.ThePlayer.HUD 是否存在并且是表类型。如果不是，函数就直接返回
	if type(GLOBAL.ThePlayer) ~= "table" or type(GLOBAL.ThePlayer.HUD) ~= "table" then return end
	-- 按键没有被按下
	keydown = false
	-- 如果 delay_focus_loss 为 true 并且当前有激活的表情，那么就延迟0.5秒后取消对表情轮盘的焦点，否则就立即取消对表情轮盘的焦点
	if delay_focus_loss and gesturewheel.activegesture then
		--delay a little on controllers to prevent canceling the emote by moving
		GLOBAL.ThePlayer:DoTaskInTime(0.5, function() SetModHUDFocus("GestureWheel", false) end)
	else
		SetModHUDFocus("GestureWheel", false)
	end
	
	-- 隐藏表情轮盘
	gesturewheel:Hide()
	-- 将表情轮盘的缩放设置为 STARTSCALE
	gesturewheel.inst.UITransform:SetScale(STARTSCALE, STARTSCALE, 1)
	
	-- 调用 CanUseGestureWheel 函数检查玩家是否可以使用表情轮盘，并将结果保存在 can_use_wheel 中
	local can_use_wheel = CanUseGestureWheel()
	using_gesture_wheel = false
	-- 如果 can_use_wheel 为 false，函数就直接返回
	if not can_use_wheel then return end
	
	-- 如果 RESTORECURSOR 为 true，那么就将鼠标的位置恢复到之前保存的位置
	if RESTORECURSOR then
		-- 如果 ADJUSTCURSOR 也为 true，那么在恢复鼠标位置之前，还会根据表情轮盘的位置调整鼠标的位置
		if ADJUSTCURSOR then
			local x,y = GLOBAL.TheInputProxy:GetOSCursorPos()
			local gx, gy = gesturewheel:GetPosition():Get()
			local dx, dy = x-gx, y-gy
			cursorx = cursorx + dx
			cursory = cursory + dy
		end
		GLOBAL.TheInputProxy:SetOSCursorPos(cursorx, cursory)
	end
	-- 如果当前有激活的表情，那么就向服务器发送一个命令，执行这个表情
	-- if gesturewheel.activegesture then
	-- 	GLOBAL.TheNet:SendSlashCmdToServer(gesturewheel.activegesture, true)
	-- end
	if gesturewheel.activegesture then
		sendRequest(gesturewheel.activegesture)
	end
	
end

local handlers_applied = false

-- 用于构建和设置表情轮盘，以及添加相关的控制器和键盘输入处理程序
local function AddGestureWheel(self)
	-- 创建或更新表情集的。这个函数被延迟调用是为了确保账号项检查更有可能成功
	BuildEmoteSets() --delay this so that the account item checks are more likely to work
	-- 这行代码将函数的参数 self 赋值给 controls，使得 controls 可以在 modmain 的其他函数中使用
	controls = self -- this just makes controls available in the rest of the modmain's functions
	-- 如果 gesturewheel 已经存在，那么就调用其 Kill 方法
	if gesturewheel then
		gesturewheel:Kill()
	end
	-- 创建一个新的 GestureWheel 实例，并将其添加到 controls 中
	gesturewheel = controls:AddChild(GestureWheel(emote_sets, SHOWIMAGE, SHOWTEXT, RIGHTSTICK))
	-- 将新创建的 GestureWheel 实例赋值给 controls.gesturewheel
	controls.gesturewheel = gesturewheel
	-- 重置表情轮盘的位置和缩放
	ResetTransform()
	-- 隐藏新创建的表情轮盘
	gesturewheel:Hide()
	
	-- 如果还没有添加输入处理程序，那么就添加键盘和控制器的输入处理程序
	if not handlers_applied then
		-- Keyboard controls
		GLOBAL.TheInput:AddKeyDownHandler(KEYBOARDTOGGLEKEY, ShowGestureWheel)
		GLOBAL.TheInput:AddKeyUpHandler(KEYBOARDTOGGLEKEY, HideGestureWheel)
		
		-- Controller controls
		-- This is pressing the left stick in
		-- CONTROL_MENU_MISC_3 is the same thing as CONTROL_OPEN_DEBUG_MENU
		-- CONTROL_MENU_MISC_4 is the right stick click
		GLOBAL.TheInput:AddControlHandler(GLOBAL.CONTROL_MENU_MISC_3, function(down)
			if down then
				ShowGestureWheel(true)
			else
				HideGestureWheel(true)
			end
		end)
		
		-- this is just a lock system to make it only register one shift at a time
		local rotate_left_free = true
		GLOBAL.TheInput:AddControlHandler(GLOBAL.CONTROL_ROTATE_LEFT, function(down)
			if down then
				if keydown and rotate_left_free then
					gesturewheel:SwitchWheel(-1)
					rotate_left_free = false
				end
			else
				rotate_left_free = true
			end
		end)
		local rotate_right_free = true
		GLOBAL.TheInput:AddControlHandler(GLOBAL.CONTROL_ROTATE_RIGHT, function(down)
			if down then
				if keydown and rotate_right_free then
					gesturewheel:SwitchWheel(1)
					rotate_right_free = false
				end
			else
				rotate_right_free = true
			end
		end)
		-- 表示已经添加了输入处理程序
		handlers_applied = true
	end
end

-- 使用 AddClassPostConstruct 函数为 widgets/controls 类添加了一个后置构造函数 AddGestureWheel。
-- 后置构造函数在类的实例被创建后立即执行，所以这行代码的作用是在创建 widgets/controls 类的实例后立即调用 AddGestureWheel 函数
AddClassPostConstruct( "widgets/controls", AddGestureWheel)

-- 修改了 widgets/controls 类的 OnUpdate 方法
--Patch the class definition directly instead of each new instance
local Controls = GLOBAL.require("widgets/controls")
-- 保存了原来的 OnUpdate 方法
local OldOnUpdate = Controls.OnUpdate
-- 定义了一个新的 OnUpdate 方法
local function OnUpdate(self, ...)
	-- 这个新的方法首先调用原来的 OnUpdate 方法
	OldOnUpdate(self, ...)
	-- 如果 keydown 为 true，就调用 self.gesturewheel:OnUpdate()
	if keydown then
		self.gesturewheel:OnUpdate()
	end
end
-- 将新的 OnUpdate 方法赋值给 Controls.OnUpdate
Controls.OnUpdate = OnUpdate

--In order to update the emote set when a skin is received, hook into the giftitempopup
-- 为 screens/giftitempopup 类添加了一个后置构造函数
AddClassPostConstruct("screens/giftitempopup", function(self)
	-- 在5秒后调用 AddGestureWheel(controls)。这样做的目的可能是在关闭礼物弹窗或应用皮肤后，更新表情轮盘
	local function ScheduleRebuild()
		--give it a little time to update the skin inventory
		controls.owner:DoTaskInTime(5, function() AddGestureWheel(controls) end)
	end
	-- 修改了 self.OnClose 和 self.ApplySkin 两个方法
	-- 在这两个方法被调用后，都会调用 ScheduleRebuild 函数
	local OldOnClose = self.OnClose
	function self:OnClose(...)
		OldOnClose(self, ...)
		ScheduleRebuild()
	end
	local OldApplySkin = self.ApplySkin
	function self:ApplySkin(...)
		OldApplySkin(self, ...)
		ScheduleRebuild()
	end
end)