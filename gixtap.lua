ui.add_label("     --{ double tap / resolver }--                  ")
--dt
local resolver = ui.add_checkbox(" новый резольвер ")


local angles = { 
     [1] = -55, 
     [2] = 55, 
     [3] = 38, 
     [4] = -38, 
     [5] = -29, 
     [6] = 29, 
     [7] = -15, 
     [8] = 15, 
     [9] = 180, 
     [10] = -180, 
     [11] = 360, 
     [12] = -360, 
     [13] = 20, 
     [14] = -20, 
     [15] = -12, 
     [16] = 12, 
     [17] = 40, 
     [18] = -40, 
     [19] = 90,
     [20] = - 90,
     [21] = 95,
     [22] = - 95,
     [23] = 35,
     [24] = - 35,
     [25] = 28,
     [26] = - 28,
     [27] = 14,
     [28] = - 14,
     [29] = 175,
     [30] = - 175,
     [31] = 0,
  
 }
local last_angle = 31
local new_angle = 1
local switch1 = false
local switch2 = false
local i = 31
local function resolve(player)
   plist.set(player, "Correction active", false)        
   plist.set(player, "Force body yaw", true)            
                                                        
   if last_angle == new_angle and switch1 then
       new_angle = -angles[i]
       if switch2 == true then
           switch1 = not switch1
       end
   else
       if i < #angles then
           i = i + 1
       else
           i = 31
       end
       new_angle = angles[i]
   end
   plist.set(player, "Force body yaw value", new_angle)
   last_angle = new_angle
   switch2 = false
end 

local enable_override_doubletap_speed = ui.add_checkbox("Скорость дабл тапа")                                         
enable_override_doubletap_speed:set(false)                                                                                  
local override_doubletap_speed_dropdown = ui.add_dropdown("Виды скорости", { "перекрыть", "обычная", "немного быстрее", "Быстрее", "Быстрый" })
override_doubletap_speed_dropdown:set(1)             

local sv_maxusrcmdprocessticks = cvar.find_var("sv_maxusrcmdprocessticks")
local sv_maxusrcmdprocessticks_cache = cvar.find_var("sv_maxusrcmdprocessticks"):get_int()

if enable_override_doubletap_speed:get() == true then

        local get_active_weapon = entity_list.get_client_entity(entity_list.get_client_entity(engine.get_local_player()):get_prop("DT_BaseCombatCharacter", "m_hActiveWeapon"))

        if override_doubletap_speed_dropdown:get() == 0 then

            if get_double_tap_key:get() == true then

                sv_maxusrcmdprocessticks:set_value_int(8)
                get_fake_lag:set(false)

            elseif get_hide_shots_key:get() == true then

                sv_maxusrcmdprocessticks:set_value_int(12)
                get_fake_lag:set(false)
                get_double_tap_key:set(false)

            else

                sv_maxusrcmdprocessticks:set_value_int(8)
                get_fake_lag:set(get_fake_lag_cache)

            end

        elseif override_doubletap_speed_dropdown:get() == 1 then

            sv_maxusrcmdprocessticks:set_value_int(15)

        elseif override_doubletap_speed_dropdown:get() == 2 then

            sv_maxusrcmdprocessticks:set_value_int(16)

        elseif override_doubletap_speed_dropdown:get() == 3 then

            if get_active_weapon:class_id() == 267 or get_active_weapon:class_id() == 233 or get_active_weapon:class_id() == 46 or get_active_weapon:class_id() == 107 or get_active_weapon:class_id() == 34 or get_active_weapon:class_id() == 96 or get_active_weapon:class_id() == 156 or get_active_weapon:class_id() == 113 or get_active_weapon:class_id() == 99 or get_active_weapon:class_id() == 77 or get_active_weapon:class_id() == 47 then

                sv_maxusrcmdprocessticks:set_value_int(16)

            else

                if get_hide_shots_key:get() == true then

                    sv_maxusrcmdprocessticks:set_value_int(16)

                else

                    sv_maxusrcmdprocessticks:set_value_int(17)

                end

            end

        elseif override_doubletap_speed_dropdown:get() == 4 then

            if get_active_weapon:class_id() == 267 or get_active_weapon:class_id() == 233 or get_active_weapon:class_id() == 46 or get_active_weapon:class_id() == 107 or get_active_weapon:class_id() == 34 or get_active_weapon:class_id() == 96 or get_active_weapon:class_id() == 156 or get_active_weapon:class_id() == 113 or get_active_weapon:class_id() == 99 or get_active_weapon:class_id() == 77 or get_active_weapon:class_id() == 47 then

                sv_maxusrcmdprocessticks:set_value_int(16)

            else

                if get_hide_shots_key:get() == true then

                    sv_maxusrcmdprocessticks:set_value_int(16)

                else

                    sv_maxusrcmdprocessticks:set_value_int(18)

                end

            end

        end

    else

        sv_maxusrcmdprocessticks:set_value_int(sv_maxusrcmdprocessticks_cache)

    end

-- dt

local disable_lc_checkbox = ui.add_checkbox( "Анти Дэфэнсив" );

local globals = {
    local_player = nil,
    alive = nil,
    weapon = nil,
    weapon_type = nil,
    view_angles = nil,
    on_ground = nil
}
local cstrike = {
    cmd = nil,
    roll = 0
}
cstrike.get_velocity = function(entity)
	if entity then
		local x = entity:get_prop("DT_BasePlayer", "m_vecVelocity[0]"):get_float()
		local y = entity:get_prop("DT_BasePlayer", "m_vecVelocity[1]"):get_float()

		return math.round(math.sqrt(x * x + y * y))
	end
end

cstrike.is_standing = function(entity)
	if entity then
		local is_moving = cstrike.is_moving(entity)
		if not is_moving then
			return true
		end
	end

	return false
end

cstrike.is_moving = function(entity)
    local local_player = entity_list.get_client_entity(engine.get_local_player())
	if entity then
        local velocity = cstrike.get_velocity(entity)
		if velocity > 4 then
			return true
		end
	end
    return false
end

cstrike.is_inair = function(entity)
	if entity then
        local local_player = entity_list.get_client_entity(engine.get_local_player())
		local ground_entity = local_player:get_prop("DT_BasePlayer", "m_hGroundEntity"):get_int()

		if ground_entity == -1 then
			return true
		end
	end

	return false
end


cstrike.is_alive = function(entity)
    if entity then
        local health = cstrike.get_health(entity)
        if health > 0 then
            return true
        end
    end

    return false
end
cstrike.update = function(pdr_cmd)
    cstrike.cmd = pdr_cmd
    cstrike.roll = pdr_cmd.viewangles.z
end

globals.update = function()
    globals.local_player = entity_list.get_client_entity(engine.get_local_player())
    globals.alive = client.is_alive()
    globals.weapon = entity_list.get_client_entity(globals.local_player:get_prop("DT_BaseCombatCharacter", "m_hActiveWeapon"))
    globals.weapon_type = globals.weapon:get_prop("DT_BaseAttributableItem", "m_iItemDefinitionIndex"):get_int()
    globals.view_angles = engine.get_view_angles()
end

local enable_js = ui.add_checkbox("Джамп Скаут")

local jscout = {}

jscout.run = function()
    if not enable_js:get() then
        return
    end

    local as = ui.get("Misc", "General", "Movement", "Auto strafe")

    if (cstrike.is_inair(globals.local_player) and not cstrike.is_standing(globals.local_player)) then 
        as:set(true)
    end

    if (cstrike.is_inair(globals.local_player) and not cstrike.is_moving(globals.local_player)) then 
        as:set(false)
    end
end

jscout.handle_visibility = function()
    local state = enable_js:get()
end
local on_post_move = function(cmd)
    globals.update()
    cstrike.update(cmd)

    jscout.run()
end

callbacks.register("post_move", on_post_move)

local hc_main = {
   shanc = ui.add_checkbox("Джамп Скаут хитшанс X3"),
   fag = ui.add_slider_float("Скаут хитшанс в воздухе", 1, 100),
   fag2 = ui.add_slider_float("Скаут хит шанс", 1, 100),
}

--hc_main.fag2:set(84)
--hc_main.fag:set(30)

local function _misc()
    local local_player = entity_list.get_client_entity(engine.get_local_player());
    if not local_player then return end
    local inair = local_player:get_prop("DT_BasePlayer","m_fFlags"):get_int()
    local inair_flag = bit.band(math.floor(inair),bit.lshift(1, 0)) ~= 0

    local hitchance = ui.get("Rage", "Aimbot", "Accuracy", "Hitchance", "Scout")
    local new_hitchance = hc_main.fag:get()
    local old_hitchance = hc_main.fag2:get()

    if hc_main.shanc:get() then
        if not inair_flag then
            hitchance:set(new_hitchance)
        else
            hitchance:set(old_hitchance)
        end
    end
end

function on_paint()
    _misc()
end

callbacks.register("paint", function()
if hc_main.shanc:get() then
  hc_main.fag:set_visible(true)
  hc_main.fag2:set_visible(true)
  else
  hc_main.fag:set_visible(false)
  hc_main.fag2:set_visible(false)
end
end)

callbacks.register("paint", _misc)

local PreviousSimulationTime = 0
local DifferenceOfSimulation = 0
function SimulationDifference()
   local LocalPlayer = entity_list.get_client_entity(engine.get_local_player())
   local CurrentSimulationTime = LocalPlayer:get_prop("DT_BaseAnimating", "m_flSimulationTime"):get_int()
   local Difference = CurrentSimulationTime - (PreviousSimulationTime + 0.75)
   PreviousSimulationTime = CurrentSimulationTime
   DifferenceOfSimulation = Difference
   return DifferenceOfSimulation
end


-- AX --

local cl_lagcompensation = cvar.find_var( "cl_lagcompensation" );

local TEAM_TERRORIST = 2;
local TEAM_CT = 3;

local function get_player_team( player )
    local m_iTeamNum = player:get_prop( "DT_BaseEntity", "m_iTeamNum" );

    return m_iTeamNum:get_int( );
end


local function IsConnectedUserInfoChangeAllowed( player )
    local team_num = get_player_team( player );

    if team_num == TEAM_TERRORIST or team_num == TEAM_CT then
        return false;
    end

    return true;
end

local previous_dlc_state = disable_lc_checkbox:get( );

local changing_from_team = false;
local previous_team_num = -1;
local team_swap_time = -1;

local function on_paint( )

    local local_player_idx = engine.get_local_player( );

    local local_player = entity_list.get_client_entity( local_player_idx );

    if not engine.is_connected( ) or IsConnectedUserInfoChangeAllowed( local_player ) then

        cl_lagcompensation:set_value_int( disable_lc_checkbox:get( ) and 0 or 1 );

        if changing_from_team and global_vars.curtime > team_swap_time then

            engine.execute_client_cmd( "jointeam " .. tostring( previous_team_num ) .. " 1" );

            changing_from_team = false;
        end
    else

        if disable_lc_checkbox:get( ) ~= previous_dlc_state then

            previous_team_num = get_player_team( local_player );

            engine.execute_client_cmd( "spectate" );

            changing_from_team = true;
            team_swap_time = global_vars.curtime + 1.5;

            previous_dlc_state = disable_lc_checkbox:get( );
        end
    end
end

local function init( )
    callbacks.register( "paint", on_paint );
end
init( );

-- AX end --



local tickbase_boost = ui.add_checkbox("Дабл тап буст")
tickbase_boost:set(false)

local ideal_tick = ui.add_checkbox("Идеальные тики")
local cmd_ticks = cvar.find_var("sv_maxusrcmdprocessticks")

callbacks.register("post_move", function()

    if ideal_tick:get() == true then
        cmd_ticks:set_value_int(30)
    end

    if ideal_tick:get() == false then
        cmd_ticks:set_value_int(25)
    end

end)

--something--
local cmd_ticks = cvar.find_var("sv_maxusrcmdprocessticks")

--function--
function TickbaseBoost()
    if tickbase_boost:get() == true then
       cmd_ticks:set_value_int(19)          
    else
          cmd_ticks:set_value_int(16)  
    end    
end

--callbacks--
callbacks.register("post_move", TickbaseBoost)

local brr = ui.add_checkbox("брутфорс резольвер")

local function resolve(target)
 if brr:get() then
    plist.set(target, "Correction active", false)
    plist.set(target, "Anti-aim Bruteforce resolver", true)
    ::continue::
 end
 if not brr:get() then
    plist.set(target, "Correction active", true) -- i like men
    plist.set(target, "Anti-aim Bruteforce resolver", true)
    ::continue::
end
end

-- init.
local function init( )
    callbacks.register( "paint", on_paint );
end
init( );

local function resolve(target)
 if brr:get() then
    plist.set(target, "Correction active", false)
    plist.set(target, "Anti-aim Bruteforce resolver", true)
    ::continue::
 end
 if not brr:get() then
    plist.set(target, "Correction active", true) -- i like men
    plist.set(target, "Anti-aim Bruteforce resolver", true)
    ::continue::
end
end

-- init.
local function init( )
    callbacks.register( "paint", on_paint );
end
init( );


local resolver = ui.add_checkbox ("Резольвер БЕТА")
local doubletap = ui.add_checkbox("Дабл тап тики")
local speed_slider = ui.add_slider("дабл тик", 0, 60)




speed_slider:set(150)


local function resolve(player)
plist_set(player, "Correction active", false)-- fucking retard this shit gae


plist_set(player, "Force body yaw", true)
plist_get(player, "Force body yaw", math.random)(-15,60)




resolve(player)


end


local function resolver(target)
plist_set(target, "Correction active", false)


plist_set(target, "Anti-aim Bruteforce resolver", true)
plist_get(target, "Anti-aim Bruteforce resolver", math.random)(0,1)

resolve(info.target)


end



local function doubletap(player)

plist_set(doubletap, "doubletap active", true)

plist_set(doubletap, "doubletap ticks", true)
plist_get(doubletap, "doubletap ticks value", value) (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60)


doubletap (player)


end








local function doubletaprecharge(doubletap)
plist_set(doubletap, "doubletaprecharge", true)
plist_get(doubletap, "doubletaprecharge") math.random(0,1)


recharge(doubletap)

end
--antiaim
ui.add_label("     --{ anti aim }--                  ")
local states = ""
local ex_states = ""
local state = 0
local active_states = ""
local hyacinths = {
    menu = {},
    states = {"Global", "Stand", "Move", "Slow Motion", "In Air", "Crouch", "Air+D", "Use"},
    scriptname = "MORF1LOSS",
    version = "0.0.1",
    date = "01 01 01",
    build = "anti aim",
    dev = "MORF1K",
    yt = "@MORF1K",
}
hyacinths.menu.selection = ui.add_dropdown(" ["..hyacinths.build.."]", {"Допол.", "Анти Аим"})
hyacinths.menu.misc = {
    fakeflick_checkbox = ui.add_checkbox("Фейк Флик"),
    fakeflick_hotkey = ui.add_cog("Fakeflick hotkey", false, true),
    --[[social = ui.add_button("My Social Media"),
    config = ui.add_button("Load Default Settings"),
    logs = ui.add_button("Update Logs"),]]
}
hyacinths.menu.ref = {
    dt = ui.get("Rage", "Exploits", "General", "Double tap key"),
    ex_fl = ui.get("Rage", "Exploits", "General", "Exploit lag limit"),
    slow = ui.get("Misc", "General", "Movement", "Slow motion key"),
    hs = ui.get("Rage", "Exploits", "General", "Hide shots key"),
    fb = ui.get("Rage", "Aimbot", "Accuracy", "Force body-aim key"),
    sp = ui.get("Rage", "Aimbot", "General", "Force Safety key"),
    peek = ui.get("Misc", "General", "Movement", "Auto peek key"),
    freestanding = ui.get("Rage", "Anti-aim", "General", "Freestanding key"),
    pitch = ui.get("Rage", "Anti-aim", "General","Pitch"),
    custom_pitch = ui.get("Rage", "Anti-aim", "General","Custom pitch"),
    yaw_base = ui.get("Rage", "Anti-aim", "General","Yaw base"),
    yaw = ui.get("Rage", "Anti-aim", "General","Yaw"),
    yaw_additive = ui.get("Rage", "Anti-aim", "General","Yaw additive"),
    yaw_jitter = ui.get("Rage", "Anti-aim", "General","Yaw jitter"),
    yaw_jitter_conditions = ui.get("Rage", "Anti-aim", "General","Yaw jitter conditions"),
    yaw_jitter_type = ui.get("Rage", "Anti-aim", "General","Yaw jitter type"),
    random_jitter_range = ui.get("Rage", "Anti-aim", "General","Random jitter range"),
    yaw_jitter_range = ui.get("Rage", "Anti-aim", "General","Yaw jitter range"),
    fake_yaw_type = ui.get("Rage", "Anti-aim", "General","Fake yaw type"),
    fake_yaw_on_use = ui.get("Rage", "Anti-aim", "General","Fake yaw on use"),
    body_yaw_limit = ui.get("Rage", "Anti-aim", "General","Body yaw limit"),
    fake_yaw_direction = ui.get("Rage", "Anti-aim", "General","Fake yaw direction"),
}

hyacinths.menu.anti_aimbot = {
    master_switch = ui.add_checkbox("Включить Анти Аим"),
    conditions = ui.add_dropdown("Player Conditions", hyacinths.states),
    mode = {},
    manual = ui.add_multi_dropdown("Anti-aimbot Adjustment", {--[["Manual Yaw Base","Freestanding Yaw",]]"Debug Panel"}),
    --manual_option = ui.add_multi_dropdown("Adjustment Manual", {"Disable Yaw Modifiers","Freestand Body Yaw"})
}
for i = 1, # hyacinths.states do
    hyacinths.menu.anti_aimbot.mode[i] = {
        override = i and ui.add_checkbox("Redefine "..hyacinths.states[i].." Condition"),
        pitch = i and ui.add_dropdown("["..hyacinths.states[i].."] Pitch", {"Off", "Down", "Up", "Zero", "Random"}),
        yawbase = i and ui.add_dropdown("["..hyacinths.states[i].."] Yaw Base", {"Local View", "At Target"}), 
        yaw = i and ui.add_dropdown("["..hyacinths.states[i].."] Yaw", {"Off", "Backward", "Static"}), 
        yawaddleft =  i and ui.add_slider("["..hyacinths.states[i].."] Left Yaw", -180, 180), 
        yawaddright =  i and ui.add_slider("["..hyacinths.states[i].."] Right Yaw", -180, 180), 
        yawmodifier = i and ui.add_dropdown("["..hyacinths.states[i].."] Yaw Modifier", {"Off", "Offset", "Random", "Center"}), 
        offset =  i and ui.add_slider("["..hyacinths.states[i].."] Offset", -180, 180), 
        bodyyaw = i and ui.add_dropdown("["..hyacinths.states[i].."] Body Yaw", {"Off", "Static", "Jitter"}),
        fakeyaw =  i and ui.add_slider("["..hyacinths.states[i].."] Fake Yaw Limit", 0, 60),  
        fsbodyyaw = i and ui.add_dropdown("["..hyacinths.states[i].."] Freesdanding", {"Off", "Peek Fake", "Peek Real"}), 
    }
end

function on_paint()
    if hyacinths.menu.selection:get() == 0 then
	hyacinths.menu.misc.fakeflick_checkbox:set_visible(true)
	hyacinths.menu.misc.fakeflick_hotkey:set_visible(true)
        --[[hyacinths.menu.misc.social:set_visible(true)
        hyacinths.menu.misc.config:set_visible(true)
        hyacinths.menu.misc.logs:set_visible(true)]]
    else
	hyacinths.menu.misc.fakeflick_checkbox:set_visible(false)
	hyacinths.menu.misc.fakeflick_hotkey:set_visible(false)
        --[[hyacinths.menu.misc.social:set_visible(false)
        hyacinths.menu.misc.config:set_visible(false)
        hyacinths.menu.misc.logs:set_visible(false)]]
    end
    for i = 1, # hyacinths.states do
        visible_conditions = i == hyacinths.menu.anti_aimbot.conditions:get() + 1
        if hyacinths.menu.selection:get() == 1 then
            hyacinths.menu.anti_aimbot.master_switch:set_visible(true)
            if hyacinths.menu.anti_aimbot.master_switch:get() then
                hyacinths.menu.anti_aimbot.conditions:set_visible(true)
                if hyacinths.menu.anti_aimbot.conditions:get() ~= 0 then
                    hyacinths.menu.anti_aimbot.mode[i].override:set_visible(visible_conditions)
                else
                    hyacinths.menu.anti_aimbot.mode[i].override:set_visible(false)
                end
                if hyacinths.menu.anti_aimbot.conditions:get() ~= 0 and hyacinths.menu.anti_aimbot.conditions:get() ~= 7 and hyacinths.menu.anti_aimbot.mode[i].override:get() then
                    hyacinths.menu.anti_aimbot.mode[i].pitch:set_visible(visible_conditions)
                    hyacinths.menu.anti_aimbot.mode[i].yawbase:set_visible(visible_conditions)
                    hyacinths.menu.anti_aimbot.mode[i].yaw:set_visible(visible_conditions)
                    hyacinths.menu.anti_aimbot.mode[i].bodyyaw:set_visible(visible_conditions)
                    if hyacinths.menu.anti_aimbot.mode[i].yaw:get() ~= 0 then
                        hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(visible_conditions)
                        hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(visible_conditions)
                    else
                        hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(false)
                        hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(false)
                    end
                    hyacinths.menu.anti_aimbot.mode[i].yawmodifier:set_visible(visible_conditions)
                    if hyacinths.menu.anti_aimbot.mode[i].yawmodifier:get() ~= 0 then
                        hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(visible_conditions)
                    else
                        hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(false)
                    end
                    if hyacinths.menu.anti_aimbot.mode[i].bodyyaw:get() ~= 0 then
                        hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(visible_conditions) 
                        hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(visible_conditions)
                    else
                        hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(false)
                        hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(false)
                    end
                elseif hyacinths.menu.anti_aimbot.conditions:get() == 0 then               
                    hyacinths.menu.anti_aimbot.mode[i].pitch:set_visible(visible_conditions)
                    hyacinths.menu.anti_aimbot.mode[i].yawbase:set_visible(visible_conditions)
                    hyacinths.menu.anti_aimbot.mode[i].yaw:set_visible(visible_conditions)
                    hyacinths.menu.anti_aimbot.mode[i].bodyyaw:set_visible(visible_conditions)
                    if hyacinths.menu.anti_aimbot.mode[i].yaw:get() ~= 0 then
                        hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(visible_conditions)
                        hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(visible_conditions)
                    else
                        hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(false)
                        hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(false)
                    end
                    hyacinths.menu.anti_aimbot.mode[i].yawmodifier:set_visible(visible_conditions)
                    if hyacinths.menu.anti_aimbot.mode[i].yawmodifier:get() ~= 0 then
                        hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(visible_conditions)
                    else
                        hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(false)
                    end
                    if hyacinths.menu.anti_aimbot.mode[i].bodyyaw:get() ~= 0 then
                        hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(visible_conditions) 
                        hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(visible_conditions)
                    else
                        hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(false)
                        hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(false)
                    end
                elseif hyacinths.menu.anti_aimbot.conditions:get() == 7 then               
                    hyacinths.menu.anti_aimbot.mode[i].pitch:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yawbase:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yaw:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].bodyyaw:set_visible(visible_conditions)
                    hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yawmodifier:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(false)
                    if hyacinths.menu.anti_aimbot.mode[i].bodyyaw:get() ~= 0 then
                        hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(visible_conditions) 
                        hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(visible_conditions)
                    else
                        hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(false)
                        hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(false)
                    end
                else
                    hyacinths.menu.anti_aimbot.mode[i].pitch:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yawbase:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yaw:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].yawmodifier:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].bodyyaw:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(false)
                    hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(false)
                end
            else
                hyacinths.menu.anti_aimbot.conditions:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].override:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].pitch:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].yawbase:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].yaw:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].yawmodifier:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].bodyyaw:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(false)
                hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(false)
            end
        else
            hyacinths.menu.anti_aimbot.master_switch:set_visible(false)
            hyacinths.menu.anti_aimbot.conditions:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].override:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].pitch:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].yawbase:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].yaw:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].yawaddleft:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].yawaddright:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].yawmodifier:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].offset:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].bodyyaw:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].fakeyaw:set_visible(false)
            hyacinths.menu.anti_aimbot.mode[i].fsbodyyaw:set_visible(false)
        end
    end
    if hyacinths.menu.selection:get() == 2 then
        hyacinths.menu.anti_aimbot.manual:set_visible(true)
        --[[if hyacinths.menu.anti_aimbot.manual:get("Manual Yaw Base") or hyacinths.menu.anti_aimbot.manual:get("Freestanding Yaw")then
            hyacinths.menu.anti_aimbot.manual_option:set_visible(true)
        else
            hyacinths.menu.anti_aimbot.manual_option:set_visible(false)
        end]]
    else
        hyacinths.menu.anti_aimbot.manual:set_visible(false)
        --hyacinths.menu.anti_aimbot.manual_option:set_visible(false)
    end
    local lp = entity_list.get_client_entity(engine.get_local_player())
    if not client.is_alive() then return end
    local flags = lp:get_prop("DT_CSPlayer", "m_fFlags"):get_int()
    local slowmotion = hyacinths.menu.ref.slow:get_key()
    local crouch = flags == 263
    local duck = flags == 261
    local air = flags == 256
    local cair = flags == 262
    local use = input.key_down(0x45)
    local modifier = lp:get_prop("DT_CSPlayer", "m_flVelocityModifier"):get_float()
    local recharge = math.ceil((exploits.process_ticks() / exploits.max_process_ticks()) * 100) 
    if recharge > 0 and recharge < 100 then
        ex_states = "Recharging ("..recharge.."%)"
    elseif recharge == 0 then
        ex_states = "Disabled"
    elseif recharge == 100 then
        ex_states = "Ready"
    end
    local desync_inverted = anti_aim.inverted()
    if desync_inverted then
        side = "Left"
    else
        side = "Right"
    end
    local speed = function()
        local vel = {
            [1] = lp:get_prop("DT_BasePlayer", "m_vecVelocity[0]"):get_float(), 
            [2] = lp:get_prop("DT_BasePlayer", "m_vecVelocity[1]"):get_float()
        }
        return math.floor(math.sqrt(vel[1] * vel[1] + vel[2] * vel[2]))
    end
    local velocity = speed()
    if velocity > 3 then 
        states = "Move"
        state = 3
    else
        states = "Stand"
        state = 2
    end
    if crouch then
        states = "Crouch (Low)"
        state = 6
    end
    if duck then
        states = "Crouch (High)"
        state = 6
    end
    if air then
        states = "Air" 
        state = 5
    end
    if cair then
        states = "Crouch+Air" 
        state = 7
    end
    if slowmotion then
        states = "Slow Motion" 
        state = 4
    end
    if use then
        states = "Use" 
        state = 8
    end
    local active = ""
    if hyacinths.menu.anti_aimbot.master_switch:get() then
        if hyacinths.menu.anti_aimbot.mode[state].override:get() then
            active = "True"
            active_states = states
            hyacinths.menu.ref.pitch:set(hyacinths.menu.anti_aimbot.mode[state].pitch:get())
            hyacinths.menu.ref.custom_pitch:set(math.random(-89.0, 89.0))
            hyacinths.menu.ref.yaw_base:set(hyacinths.menu.anti_aimbot.mode[state].yawbase:get())
            hyacinths.menu.ref.yaw:set(hyacinths.menu.anti_aimbot.mode[state].yaw:get())
            if anti_aim.inverted() then
                hyacinths.menu.ref.yaw_additive:set(hyacinths.menu.anti_aimbot.mode[state].yawaddleft:get())
            elseif not anti_aim.inverted() then
                hyacinths.menu.ref.yaw_additive:set(hyacinths.menu.anti_aimbot.mode[state].yawaddright:get())
            end
            hyacinths.menu.ref.body_yaw_limit:set(hyacinths.menu.anti_aimbot.mode[state].fakeyaw:get())
            if hyacinths.menu.anti_aimbot.mode[state].yawmodifier:get() == 0 then
                hyacinths.menu.ref.yaw_jitter:set(false)
            else
                hyacinths.menu.ref.yaw_jitter:set(true)
                hyacinths.menu.ref.yaw_jitter_type:set(hyacinths.menu.anti_aimbot.mode[state].yawmodifier:get() - 1)
                hyacinths.menu.ref.yaw_jitter_range:set(math.abs(hyacinths.menu.anti_aimbot.mode[state].offset:get() / 2))
            end
            if hyacinths.menu.anti_aimbot.mode[state].bodyyaw:get() == 0 then
                hyacinths.menu.ref.body_yaw_limit:set(0)
            else
                hyacinths.menu.ref.fake_yaw_type:set(hyacinths.menu.anti_aimbot.mode[state].bodyyaw:get() -  1)
                hyacinths.menu.ref.body_yaw_limit:set(hyacinths.menu.anti_aimbot.mode[state].fakeyaw:get())
            end
            hyacinths.menu.ref.fake_yaw_direction:set(hyacinths.menu.anti_aimbot.mode[state].fsbodyyaw:get())
            hyacinths.menu.ref.random_jitter_range:set(false)
        else
            active = "False"
            active_states = "Global"
            hyacinths.menu.ref.pitch:set(hyacinths.menu.anti_aimbot.mode[1].pitch:get())
            hyacinths.menu.ref.custom_pitch:set(math.random(-89.0, 89.0))
            hyacinths.menu.ref.yaw_base:set(hyacinths.menu.anti_aimbot.mode[1].yawbase:get())
            hyacinths.menu.ref.yaw:set(hyacinths.menu.anti_aimbot.mode[1].yaw:get())
            if anti_aim.inverted() then
                hyacinths.menu.ref.yaw_additive:set(hyacinths.menu.anti_aimbot.mode[1].yawaddleft:get())
            elseif not anti_aim.inverted() then
                hyacinths.menu.ref.yaw_additive:set(hyacinths.menu.anti_aimbot.mode[1].yawaddright:get())
            end
            hyacinths.menu.ref.body_yaw_limit:set(hyacinths.menu.anti_aimbot.mode[1].fakeyaw:get())
            if hyacinths.menu.anti_aimbot.mode[1].yawmodifier:get() == 0 then
                hyacinths.menu.ref.yaw_jitter:set(false)
            else
                hyacinths.menu.ref.yaw_jitter:set(true)
                hyacinths.menu.ref.yaw_jitter_type:set(hyacinths.menu.anti_aimbot.mode[1].yawmodifier:get() - 1)
                hyacinths.menu.ref.yaw_jitter_range:set(math.abs(hyacinths.menu.anti_aimbot.mode[1].offset:get() / 2))
            end
            if hyacinths.menu.anti_aimbot.mode[1].bodyyaw:get() == 0 then
                hyacinths.menu.ref.body_yaw_limit:set(0)
            else
                hyacinths.menu.ref.fake_yaw_type:set(hyacinths.menu.anti_aimbot.mode[1].bodyyaw:get() -  1)
                hyacinths.menu.ref.body_yaw_limit:set(hyacinths.menu.anti_aimbot.mode[1].fakeyaw:get())
            end
            hyacinths.menu.ref.fake_yaw_direction:set(hyacinths.menu.anti_aimbot.mode[1].fsbodyyaw:get())
            hyacinths.menu.ref.random_jitter_range:set(false)
        end
    else
        active = "False"
        active_states = "Disabled"
    end
    if hyacinths.menu.anti_aimbot.manual:get("Debug Panel") then
        render.text(960, 540, "Velocity: "..tostring(velocity), color.new(255,255,255,255))
        render.text(960, 550, "States: "..states.." (Active: "..active..")", color.new(255,255,255,255))
        render.text(960, 560, "Redefine Condiction: "..active_states, color.new(255,255,255,255))
        render.text(960, 570, "Desync Invert: "..side, color.new(255,255,255,255))
        render.text(960, 580, "Velocity Modifier: "..modifier, color.new(255,255,255,255))
        render.text(960, 590, "Recharge States: "..ex_states, color.new(255,255,255,255))
    end
end
callbacks.register("paint", on_paint)

--visual
ui.add_label("			--{visual}--                  ")
local size_x, size_y = render.get_screen()
local kb_keybinds = ui.add_checkbox("меню биндов")
local kb_accent_color_text = ui.add_label("цвет меню")
local kb_accent_color = ui.add_cog("Accent color for keybinds", true, false)
local kb_circle_accent_color_text = ui.add_label("цвет текста")
local kb_circle_accent_color = ui.add_cog("Accent color for Circle", true, false)
local kb_pos_x = ui.add_slider("позиция X", 0, size_x)
local kb_pos_y = ui.add_slider("позиция Y", 0, size_y)

local small_fonts = render.create_font("Small Fonts", 13, 500, bit.bor(font_flags.dropshadow, font_flags.antialias));
local small_fonts2 = render.create_font("Small Fonts", 12, 500, bit.bor(font_flags.dropshadow, font_flags.antialias));

local Verdana_KB = render.create_font("Verdana", 12.2, 500, bit.bor(font_flags.antialias));
local Verdana_KB2 = render.create_font("Verdana", 12.2, 500, bit.bor(font_flags.dropshadow, font_flags.antialias));

callbacks.register("paint", function()
    if kb_keybinds:get() then

        local x_pos, y_pos = kb_pos_x:get(), kb_pos_y:get()

        local kb_double_tap = ui.get("Rage", "Exploits", "General", "Double tap key")
        local kb_body_aim = ui.get("Rage", "Aimbot", "Accuracy", "Force body-aim key")
        local kb_fake_duck = ui.get("Rage", "Anti-aim", "Fake-lag", "Fake duck key")
        local kb_dmg_ovr = ui.get("Rage", "Aimbot", "General", "Minimum damage override key")
        local kb_force_safe = ui.get("Rage", "Aimbot", "General", "Force safety key")
        local kb_roll_reso = ui.get("Rage", "Aimbot", "General", "Roll resolver")
        local kb_hide_shots = ui.get("Rage", "Exploits", "General", "Hide shots key")
        local kb_third_person = ui.get("Visuals", "General", "Other group", "Third person key")
        local kb_slow_motion = ui.get("Misc", "General", "Movement", "Slow motion key")
        local kb_auto_peek = ui.get("Misc", "General", "Movement", "Auto peek key")
        local kb_freestanding = ui.get("Rage", "Anti-aim", "General", "Freestanding key")
        local kb_manual_left = ui.get("Rage", "Anti-aim", "General", "Manual left key")
        local kb_manual_right = ui.get("Rage", "Anti-aim", "General", "Manual right key")
        local kb_manual_back = ui.get("Rage", "Anti-aim", "General", "Manual backwards key")

        local kb_i = {}

        if kb_third_person:get_key() then
            table.insert(kb_i, {text = "Thirdperson", color = color.new(255,255,255,200)})
        end

        if kb_dmg_ovr:get_key() then
            table.insert(kb_i, {text = "Minimum damage", color = color.new(255,255,255,200)})
        end

        if kb_double_tap:get_key() then
            table.insert(kb_i, {text = "Double Tap", color = color.new(255,255,255,200)})
        end

        if kb_hide_shots:get_key() then
            table.insert(kb_i, {text = "Hide Shots", color = color.new(255,255,255,200)})
        end

        if kb_body_aim:get_key() then
            table.insert(kb_i, {text = "Body Aim", color = color.new(255,255,255,200)})
        end

        if kb_fake_duck:get_key() then
            table.insert(kb_i, {text = "Fakeduck", color = color.new(255,255,255,200)})
        end

        if kb_force_safe:get_key() then
            table.insert(kb_i, {text = "Force Safety", color = color.new(255,255,255,200)})
        end

        if kb_roll_reso:get_key() then
            table.insert(kb_i, {text = "Roll Resolver", color = color.new(255,255,255,200)})
        end

        if kb_slow_motion:get_key() then
            table.insert(kb_i, {text = "Slow Walk", color = color.new(255,255,255,200)})
        end

        if kb_auto_peek:get_key() then
            table.insert(kb_i, {text = "Auto Peek", color = color.new(255,255,255,200)})
        end

        if kb_manual_left:get_key() then
            table.insert(kb_i, {text = "Manual Left", color = color.new(255,255,255,200)})
        end

        if kb_manual_back:get_key() then
            table.insert(kb_i, {text = "Manual Back", color = color.new(255,255,255,200)})
        end

        if kb_manual_right:get_key() then
            table.insert(kb_i, {text = "Manual Right", color = color.new(255,255,255,200)})
        end

        if kb_freestanding:get_key() then
            table.insert(kb_i, {text = "Freestanding", color = color.new(255,255,255,200)})
        end

        -- Verdana_KB:text(x_pos +75, y_pos +3, text_color_ref:get_color(), "Hotkeys");
        -- render.text(x_pos +75, y_pos +3, "Hotkeys", text_color_ref:get_color());

        render.rectangle_filled(x_pos + 0, y_pos + 0, 165, 21, color.new(0, 0, 0, 170))
        render.rectangle_filled(x_pos + 0, y_pos + 0, 165, 2, kb_accent_color:get_color())
        small_fonts2:text(x_pos + 59, y_pos + 3.5, color.new(255, 255, 255, 255), "  Keybinds");

        for idx = 1, #kb_i do
            local kb_i = kb_i[ idx ]
            
            small_fonts2:text(x_pos + 2, y_pos + 10 + idx * 15, kb_i.color, kb_i.text)
            small_fonts2:text(x_pos + 144, y_pos + 10 + idx * 15, kb_i.color, "[on]")
            -- render.circle_filled(x_pos + 158, y_pos + 17 + idx * 15, 3, 13, kb_circle_accent_color:get_color())
        end
    end
end)
local small_fonts = render.create_font( "Small Fonts", 9, 400, font_flags.dropshadow );
local world_hitmarker_dmg = ui.add_checkbox( "Показ попаданий" );

local markers = { }

function on_paint( )
    if not world_hitmarker_dmg:get( ) then
        return
    end

    local step = 255.0 / 1.0 * global_vars.frametime;
    local step_move = 30.0 / 1.5 * global_vars.frametime;
    local multiplicator = 0.3;

    for idx = 1, #markers do
        local marker = markers[ idx ];

        if marker == nil then
            return
        end

        marker.moved = marker.moved - step_move;

        if marker.create_time + 0.5 <= global_vars.curtime then
            marker.alpha = marker.alpha - step;
        end

        if marker.alpha > 0 then
            local screen_position = vector2d.new( 0, 0 );

            if render.world_to_screen( marker.world_position, screen_position ) then
                small_fonts:text( screen_position.x + 8, screen_position.y - 12 + marker.moved, color.new( 163, 146, 255, marker.alpha ), "-" .. marker.dmg );
            end
        else
            table.remove( markers, idx );
        end
    end
end

function on_hitmarker( damage, position )
    table.insert( markers, {
        dmg = damage,
        world_position = vector.new( position.x, position.y, position.z ),
        create_time = global_vars.curtime,
        moved = 0.0,
        alpha = 255.0
    } );
end

callbacks.register( "on_hitmarker", on_hitmarker );
callbacks.register( "paint", on_paint );

local dist_ref = ui.add_slider("Третие лицо", 0, 350)
local get_cam_idealdist = cvar.find_var("cam_idealdist")

callbacks.register("paint", function()
   get_cam_idealdist:set_value_int(dist_ref:get())
end)
local main = {
    killsay = ui.add_checkbox("ТрэшТолк"),
}

local should_killsay = false
local curtime_onkill = global_vars.curtime

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function killsay_func(event)
    if not main.killsay:get() then return end
    
    local attacker = event:get_int("attacker")
    local attacker_to_player = engine.get_player_for_user_id(attacker)
    local local_index = engine.get_local_player()

    if attacker_to_player == local_index then
        should_killsay = true
        curtime_onkill = global_vars.curtime + 1.4
    end
end

local list = {
    "хахахахаха иди плачь",
    "стрелять потом будешь?XD",
    "плачь вам в африке вода нужна (___)",
    "-5 iq момент",
    "ноживка клюнула",
    "иди в цирк работать там клоуны нужны",
    "1",
    "LMAO",
    "иди нахуй.com",
    "хихи-хаха",
    "я как дед мазай, ебланов сношу",
    "Mamak Hvh > all",
    "твой вес > твой iq",
    "pwndora.store owns me and all",
    "тебя убил defensive, хорошо что не нн",
    "что с резикам? видимо у вас с отцом оба порваные",
    "ты любишь драить унитас? Славно чисти свой кряк",
    "хочешь покажу пенис? 8=====)",
    "Твоя кровать не выдержит твой вес",
    "бедний",
    "сейчас я играю с лёгкими ботами",
    "возьми мой пенсал",
    "кодер этой луа - defensive",
    "LMAO",
    "? XD",
    "Я справил нужду под твою дверь",
    "причина твоей смерти - женский алкоголизм",
    "ты умер ради баланса вселенной",
    "Не юзай исусе луа, купи Defensive",
}

local function on_paint_killsay()

    if should_killsay and global_vars.curtime >= curtime_onkill then
        local killsay = "say " .. list[math.random(1, #list)]
        engine.execute_client_cmd(killsay)
        curtime_onkill = 0
        should_killsay = false
    end
end

callbacks.register("paint", function()
    if not engine.in_game() or not engine.is_connected() then
        return
    end
    if client.is_alive() then
        on_paint_killsay()
    end
end)

callbacks.register("player_death", function(event)
    if not engine.in_game() or not engine.is_connected() or not client.is_alive() then
        return
    end

    killsay_func(event)
end)



local enable_antiaim = ui.add_checkbox("тролинг АА")
local roll_disable = ui.add_checkbox("выключить РОЛЛЫ")

local cstrike = {
    cmd = nil,
    roll = 0
}

cstrike.update = function(pdr_cmd)
    cstrike.cmd = pdr_cmd
    cstrike.roll = pdr_cmd.viewangles.z
end

local globals = {
    local_player = nil,
    alive = nil,
    weapon = nil,
    weapon_type = nil,
    view_angles = nil,
    on_ground = nil
}

globals.update = function()
    globals.local_player = entity_list.get_client_entity(engine.get_local_player())
    globals.alive = client.is_alive()
    globals.weapon = entity_list.get_client_entity(globals.local_player:get_prop("DT_BaseCombatCharacter", "m_hActiveWeapon"))
    globals.weapon_type = globals.weapon:get_prop("DT_BaseAttributableItem", "m_iItemDefinitionIndex"):get_int()
    globals.view_angles = engine.get_view_angles()
end

cstrike.weapons = {
    deagle = 1,
    duals = 2,
    fiveseven = 3,
    glock = 4,
    awp = 9,
    g3sg1 = 11,
    tect9 = 30,
    p2000 = 32,
    p250 = 36,
    scar20 = 38,
    ssg08 = 40,
    revolver = 64,
    usp = 262205
}

cstrike.get_health = function(entity)
    if entity then
        local health = entity:get_prop("DT_BasePlayer", "m_iHealth"):get_int()
        return math.round(health)
    end

    return nil
end

cstrike.get_velocity = function(entity)
	if entity then
		local x = entity:get_prop("DT_BasePlayer", "m_vecVelocity[0]"):get_float()
		local y = entity:get_prop("DT_BasePlayer", "m_vecVelocity[1]"):get_float()

		return math.round(math.sqrt(x * x + y * y))
	end
end

cstrike.is_alive = function(entity)
    if entity then
        local health = cstrike.get_health(entity)
        if health > 0 then
            return true
        end
    end

    return false
end

cstrike.is_standing = function(entity)
	if entity then
		local is_moving = cstrike.is_moving(entity)
		if not is_moving then
			return true
		end
	end

	return false
end

cstrike.is_slowwalking = function(entity)
    if entity then
		if ui.get("Misc", "General", "Movement", "Slow motion key"):get_key() then
			return true
		end
    end

    return false
end


cstrike.is_crouching = function(entity)
    if entity then
        if cstrike.cmd:has_flag(4) then
            return true
        end
    end

    return false
end

cstrike.is_fake_ducking = function(entity)
    if entity then
        local duck_speed = entity:get_prop("DT_BasePlayer", "m_flDuckSpeed"):get_float()
        local duck_amount = entity:get_prop("DT_BasePlayer", "m_flDuckAmount"):get_float()

        if duck_speed == 8 and duck_amount > 0 and not cstrike.cmd:has_flag(1) then
            return true
        end
    end

    return false
end

cstrike.is_inair = function(entity)
	if entity then
        local local_player = entity_list.get_client_entity(engine.get_local_player())
		local ground_entity = local_player:get_prop("DT_BasePlayer", "m_hGroundEntity"):get_int()

		if ground_entity == -1 then
			return true
		end
	end

	return false
end

cstrike.is_moving = function(entity)
    local local_player = entity_list.get_client_entity(engine.get_local_player())
	if entity then
        local velocity = cstrike.get_velocity(entity)
		if velocity > 4 and not cstrike.is_inair(local_player)  then
			return true
		end
	end
    return false
end

cstrike.is_scoped = function(entity)
    if entity then
        local scoped = entity:get_prop("DT_CSPlayer", "m_bIsScoped"):get_int()
        if scoped == 1 then
            return true
        end
    end

    return false
end


math.radian_to_degree = function(radian)
    return radian * 180 / math.pi
end

math.degree_to_radian = function(degree)
    return degree * math.pi / 180
end

math.round = function(x)
    return x % 1 >= 0.5 and math.ceil(x) or math.floor(x)
end

math.normalize = function(angle)
    while angle < -180 do
        angle = angle + 360
    end

    while angle > 180 do
        angle = angle - 360
    end

    return angle
end

math.angle_to_vector = function(angle)
    local pitch = angle.x
    local yaw = angle.y

    return vector.new(math.cos(math.pi / 180 * pitch) * math.cos(math.pi / 180 * yaw), math.cos(math.pi / 180 * pitch) * math.sin(math.pi / 180 * yaw), -math.sin(math.pi / 180 * pitch))
end

math.calculate_angles = function(from, to)
	local sub = { 
		x = to.x - from.x, 
		y = to.y - from.y, 
		z = to.z - from.z 
	}

	local hyp = math.sqrt( sub.x * sub.x * 2 + sub.y * sub.y * 2 )

	local yaw = math.radian_to_degree( math.atan2( sub.y, sub.x ) );
	local pitch = math.radian_to_degree( -math.atan2( sub.z, hyp ) )

    return QAngle.new(pitch, yaw, 0)
end

math.calculate_fov = function(from, to, angles)
    local calculated = math.calculate_angles(from, to)

    local yaw_delta = angles.yaw - calculated.yaw;
    local pitch_delta = angles.pitch - calculated.pitch;

    if ( yaw_delta > 180 ) then
      yaw_delta = yaw_delta - 360
    end

    if ( yaw_delta < -180 ) then
      yaw_delta = yaw_delta + 360
    end

    return math.sqrt( yaw_delta * yaw_delta * 2 + pitch_delta * pitch_delta * 2 );
end
local utils = {}

utils.clamp = function(v, min, max)
    local num = v
    num = num < min and min or num
    num = num > max and max or num
    
    return num
end

utils.fluctuate = function(min, max)
    local used = false
    local ret = 0

    if used then
        ret = math.random(min, max)
        used = false
    else
        ret = math.random(min, max)
        used = true
    end

    return ret
end

utils.get_crosshair_target = function()
    if not globals.local_player then
        return
    end

    local data = {
        target = nil,
        fov = 180
    }

    local players = entity_list.get_all("CCSPlayer")
end
local antiaim = {}

antiaim.run = function()
    if not enable_antiaim:get() then
        return
    end

    local fake_yaw_type = ui.get("Rage", "Anti-aim", "General", "Fake yaw type")
    local body_yaw_limit = ui.get("Rage", "Anti-aim", "General", "Body yaw limit")
    local fake_yaw_limit = ui.get("Rage", "Anti-aim", "General", "Fake yaw limit")

    local yaw_jitter = ui.get("Rage", "Anti-aim", "General", "Yaw jitter")
    local yaw_jitter_conditions = ui.get("Rage", "Anti-aim", "General", "Yaw jitter conditions")
    local yaw_jitter_type = ui.get("Rage", "Anti-aim", "General", "Yaw jitter type")
    local yaw_jitter_range = ui.get("Rage", "Anti-aim", "General", "Yaw jitter range")

    local fake_yaw_direction = ui.get("Rage", "Anti-aim", "General", "Fake yaw direction")
    local yaw_additive = ui.get("Rage", "Anti-aim", "General", "Yaw additive")

    local body_roll = ui.get("Rage", "Anti-aim", "General", "Body roll")
    local body_roll_amount = ui.get("Rage", "Anti-aim", "General", "Body roll amount")
    local inverter_state = ui.get("Rage", "Anti-aim", "General", "Anti-aim invert")


    if cstrike.is_standing(globals.local_player) or cstrike.is_slowwalking(globals.local_player) then

        if roll_disable:get() then
            fake_yaw_direction:set(0)
            yaw_jitter:set(true)
            yaw_jitter_conditions:set("Standing", true)
            yaw_jitter_conditions:set("Walking", true)
            yaw_jitter_type:set(2)
            yaw_jitter_range:set(-38)
            body_yaw_limit:set(23)
            fake_yaw_limit:set(24)
            fake_yaw_type:set(1)
        else
            fake_yaw_direction:set(0)
            yaw_jitter:set(false)
            body_yaw_limit:set(60)
            fake_yaw_limit:set(60)
            fake_yaw_type:set(0)
            inverter_state:set_key(false)
        end

        if roll_disable:get() then
            body_roll:set(0)
        else
            body_roll:set(4)
        end
        if roll_disable:get() then
            yaw_additive:set(0)
        else
        if inverter_state:get_key( ) == false then
            body_roll_amount:set( -50 )
        else
            body_roll_amount:set( 50 )
        end
    end
    end

    if (cstrike.is_inair(globals.local_player) and not cstrike.is_moving(globals.local_player)) then 
        yaw_additive:set(0)
        yaw_jitter:set(true)
        yaw_jitter_conditions:set("In air", true)
        yaw_jitter_type:set(2)
        yaw_jitter_range:set(-34)
        fake_yaw_type:set(1)
        body_yaw_limit:set(42)
        fake_yaw_direction:set(0)
        body_roll:set(0)
    end

    if (not cstrike.is_slowwalking(globals.local_player) and cstrike.is_moving(globals.local_player)) then        
        yaw_additive:set(0)
        yaw_jitter:set(true)
        yaw_jitter_conditions:set("Moving", true)
        yaw_jitter_type:set(2)
        yaw_jitter_range:set(-42)
        fake_yaw_type:set(1)
        body_yaw_limit:set(60)
        fake_yaw_direction:set(0)
        body_roll:set(0)
    end

    if  (not cstrike.is_inair(globals.local_player) and cstrike.is_crouching(globals.local_player)) then
        yaw_additive:set(0)
        yaw_jitter:set(true)
        yaw_jitter_conditions:set("Moving", true)
        yaw_jitter_type:set(2)
        yaw_jitter_range:set(-44)
        fake_yaw_type:set(1)
        body_yaw_limit:set(46)
        fake_yaw_direction:set(0)
        body_roll:set(0)

        if roll_disable:get() then
            body_roll:set(0)
        else
            body_roll:set(4)
        end

        if inverter_state:get_key( ) == false then
            body_roll_amount:set( -50 )
        else
            body_roll_amount:set( 50 )
        end
    end
end

antiaim.handle_visibility = function()
    local state = enable_antiaim:get()
    local rol = roll_disable:get()

end
local on_post_move = function(cmd)
    globals.update()
    cstrike.update(cmd)

    antiaim.run()
end

callbacks.register("post_move", on_post_move)

local menu = {
    antiaimp = {
    pitchexploit = ui.add_checkbox("Питч"),
    pitchexploitkey = ui.add_cog("Варианты питчей", false, true),
    pitchdropdown = ui.add_dropdown("Варианты'", {"Up Pitch ", "Zero Pitch ", "Random Pitch ", "Custom Pitch "}),
    pitchcustom = ui.add_slider("Кастомный питч", -89,89),
    pslider = ui.add_slider("Скорость питча", 0, 100),
    }
}
menu.antiaimp.pitchcustom:set(0)
b = ui.get("Rage", "Anti-aim", "General", "Pitch")
c = ui.get("Rage", "Anti-aim", "General", "Custom pitch")
local function DeffensivePitch()
    if not menu.antiaimp.pitchexploit:get() then
     menu.antiaimp.pitchcustom:set_visible(false)
     return
    end
    if menu.antiaimp.pitchexploit:get() then
        if menu.antiaimp.pitchdropdown:get() == 0 and menu.antiaimp.pitchexploitkey:get_key() == true then
            if SimulationDifference() <= -1 or (math.floor(global_vars.curtime * menu.antiaimp.pslider:get()) % 16 == 0 and client.choked_commands() < 2) then
                b:set(2)
            else
                b:set(1)
            end
        else
            b:set(1)
        end
        if menu.antiaimp.pitchdropdown:get() == 1 and menu.antiaimp.pitchexploitkey:get_key() == true then
            if SimulationDifference() <= -1 or (math.floor(global_vars.curtime * menu.antiaimp.pslider:get()) % 16 == 0 and client.choked_commands() < 2) then
                b:set(3)
            else
                b:set(1)
            end
        end
        if menu.antiaimp.pitchdropdown:get() == 2 and menu.antiaimp.pitchexploitkey:get_key() == true then
            if SimulationDifference() <= -1 or (math.floor(global_vars.curtime * menu.antiaimp.pslider:get()) % 16 == 0 and client.choked_commands() < 2) then
                b:set(4)
                c:set(math.random(-89,89))
            else
                b:set(1)
            end
        end
        if menu.antiaimp.pitchdropdown:get() == 3 then
         menu.antiaimp.pitchcustom:set_visible(true)
         if menu.antiaimp.pitchexploitkey:get_key() == true then
            if SimulationDifference() <= -1 or (math.floor(global_vars.curtime * menu.antiaimp.pslider:get()) % 16 == 0 and client.choked_commands() < 2) then
                b:set(4)
                c:set(menu.antiaimp.pitchcustom:get())
            else
                b:set(1)
            end
         end
        else
        menu.antiaimp.pitchcustom:set_visible(false)
        end
    end
end

local sexylabel = ui.add_label("")
callbacks.register("paint", DeffensivePitch);

callbacks.register("paint", function()
if menu.antiaimp.pitchexploit:get() then
 menu.antiaimp.pslider:set_visible(true)
 menu.antiaimp.pitchdropdown:set_visible(true)
 sexylabel:set_visible(true)
else
 menu.antiaimp.pslider:set_visible(false)
 menu.antiaimp.pitchdropdown:set_visible(false)
 sexylabel:set_visible(false)
end
end)

local tag_dropdown = ui.add_dropdown("Клантэг", {"Обычный", "Анимированый", "Кастомный"})
local text_box_clantag = ui.add_textbox("Введите кастомный клантэг")
local signature = client.find_sig("engine.dll", "53 56 57 8B DA 8B F9 FF 15")
local call = ffi.cast("int(__fastcall*)(const char*, const char*)", signature)


local function on_post_move(cmd)
    if not tag:get() then
        return
    end
end

local clan_tag = {
    last_tag =  0,

    set = function(tag)
        if tag == last then
            return
        end

        call(tag, tag)

        last_tag = tag
    end
}

local last_update = 0
callbacks.register("paint", function()
    if not (engine.is_connected() and engine.in_game()) then
        return
    end
   if tag_dropdown:get() == 0 then
    local tag = {
        "GIXTAP.LUA"
    }

    local time = global_vars.curtime
    time = math.floor(time % #tag + 0.5)

    if time ~= last_update then
        clan_tag.set(tag[time])
    end

    last_update = math.floor(time)
   end

   if tag_dropdown:get() == 1 then
    local tag1 = {
        "",
        "G",
        "GI",
        "GIX",
        "GIXT",
        "GIXTA",
        "GIXTAP",
        "GIXTAP.",
        "GIXTAP.L",
        "GIXTAP.LU",
        "GIXTAP.LUA",
        "GIXTAP.LU",
        "GIXTAP.L",
        "GIXTAP.",
        "GIXTAP",
        "GIXTA",
        "GIXT",
        "GIX",
        "GI",
        "G",
        ""
    }

    local time = global_vars.curtime
    time = math.floor(time % #tag1 + 0.5)

    if time ~= last_update then
        clan_tag.set(tag1[time])
    end

    last_update = math.floor(time)
   end

   if tag_dropdown:get() == 2 then
    local tag2 = {
     text_box_clantag:get()
    }

    local time = global_vars.curtime
    time = math.floor(time % #tag2 + 0.5)

    if time ~= last_update then
        clan_tag.set(tag2[time])
    end

    last_update = math.floor(time)
   end

end)
callbacks.register("paint", function()
if tag_dropdown:get() == 2 then
text_box_clantag:set_visible(true)
else
text_box_clantag:set_visible(false)
end
end)

desync_sway = ui.add_checkbox("Десинк свей")
desync_sway_amount = ui.add_slider_float("Desync Sway debug amount", 0, 80)

desync = ui.get("Rage", "Anti-aim", "General", "Body yaw limit")
callbacks.register("paint", function()
   desync_sway_amount:set_visible(false)
   if desync_sway:get() then
    for i = 0, desync_sway_amount:get() do
     desync_sway_amount:set(desync_sway_amount:get() + 0.1)
     desync:set(desync_sway_amount:get() + 1)
     if desync_sway_amount:get() >= 79 then
      desync_sway_amount:set(0)
     end
    end
   end
end)

---@diagnostic disable: undefined-global, need-check-nil
--- @region: Optimization
local ui_add_checkbox, ui_add_cog, ui_add_slider, ui_get, callbacks_register = ui.add_checkbox, ui.add_cog, ui.add_slider, ui.get,
    callbacks.register
--- @endregion

--- @group: Settings
local ui_settings = {
    anti_aim = {
        enable_antiaim = ui_add_checkbox('Вращать АА'),
        enable_antiaim_key = ui_add_cog('Бинд', false, true),
        spin_amount = ui_add_slider('Скорость вращения', 0, 180),
        yaw_normal = ui_add_slider('Поворот', -180,180),
        stop_spin_amount = ui.add_slider("Конец поворота", 0,180),
        start_spin_amount = ui.add_slider("Начало поворота", -180,0),
    }
}
--- @endregion

--- @region: vars
local vars_c = {
    ref = {
        fake_yaw_type = ui_get('Rage', 'Anti-aim', 'General', 'Fake yaw type'),
        body_yaw_limit = ui_get('Rage', 'Anti-aim', 'General', 'Body yaw limit'),
        fake_yaw_limit = ui_get('Rage', 'Anti-aim', 'General', 'Fake yaw limit'),

        yaw_jitter = ui_get('Rage', 'Anti-aim', 'General', 'Yaw jitter'),
        yaw_jitter_conditions = ui_get('Rage', 'Anti-aim', 'General', 'Yaw jitter conditions'),
        yaw_jitter_type = ui_get('Rage', 'Anti-aim', 'General', 'Yaw jitter type'),
        yaw_jitter_range = ui_get('Rage', 'Anti-aim', 'General', 'Yaw jitter range'),

        fake_yaw_direction = ui_get('Rage', 'Anti-aim', 'General', 'Fake yaw direction'),
        yaw_additive = ui_get('Rage', 'Anti-aim', 'General', 'Yaw additive'),
        pitch = ui_get("Rage", "Anti-aim", "General", "Pitch"),

        body_roll = ui_get('Rage', 'Anti-aim', 'General', 'Body roll'),
        body_roll_amount = ui_get('Rage', 'Anti-aim', 'General', 'Body roll amount'),
        inverter_state = ui_get('Rage', 'Anti-aim', 'General', 'Anti-aim invert')
    }
}
--- @endregion

--- @region: anti-aim
local anti_aim_c = {
    anti_aim = {}
}

--- @item: Spin AA
anti_aim_c.anti_aim.handle = function()
 if ui_settings.anti_aim.enable_antiaim:get() then
    if not ui_settings.anti_aim.enable_antiaim_key:get_key() then
       vars_c.ref.yaw_additive:set(ui_settings.anti_aim.yaw_normal:get())
       --vars_c.ref.pitch:set(1)
       return
    end

    if vars_c.ref.yaw_additive:get() >= ui_settings.anti_aim.stop_spin_amount:get() then
     vars_c.ref.yaw_additive:set(ui_settings.anti_aim.start_spin_amount:get())
    end

    --vars_c.ref.pitch:set(3)
    local spin_amount = ui_settings.anti_aim.spin_amount:get()

    for i = 1, spin_amount do
        vars_c.ref.yaw_additive:set(vars_c.ref.yaw_additive:get() + 1)
    end
 end
end
--- @endregion
local sexlabel = ui.add_label("")
--- @region: callbacks
callbacks_register('paint', anti_aim_c.anti_aim.handle)
--- @endregion
callbacks.register("paint", function()
if ui_settings.anti_aim.enable_antiaim:get() then
  ui_settings.anti_aim.spin_amount:set_visible(true)
  ui_settings.anti_aim.yaw_normal:set_visible(true)
  ui_settings.anti_aim.stop_spin_amount:set_visible(true)
  ui_settings.anti_aim.start_spin_amount:set_visible(true)
  sexlabel:set_visible(true)
  else
  ui_settings.anti_aim.spin_amount:set_visible(false)
  ui_settings.anti_aim.yaw_normal:set_visible(false)
    ui_settings.anti_aim.stop_spin_amount:set_visible(false)
  ui_settings.anti_aim.start_spin_amount:set_visible(false)
  sexlabel:set_visible(false)
end
end)

local executecommands = ui.add_button("FPS Commands")
executecommands:add_callback(function()
    engine.execute_client_cmd("r_dynamic 0; r_drawtracers_firstperson 1; cl_disablefreezecam 1; cl_disablehtmlmotd 1; r_3dsky 0; r_shadows 0; cl_csm_static_prop_shadows 0; cl_csm_world_shadows 0; cl_showhelp 0; cl_autohelp 0;")
end)

local Materials = {
    "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",
    "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",
    "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",
    "models/player/custom_player/legacy/tm_leet_variantf.mdl",
    "models/player/custom_player/legacy/tm_leet_varianti.mdl",
    "models/player/custom_player/legacy/tm_leet_varianth.mdl",
    "models/player/custom_player/legacy/tm_leet_variantg.mdl",
    "models/player/custom_player/legacy/ctm_fbi_variantb.mdl",
    "models/player/custom_player/legacy/ctm_fbi_varianth.mdl",
    "models/player/custom_player/legacy/ctm_fbi_variantg.mdl",
    "models/player/custom_player/legacy/ctm_fbi_variantf.mdl",
    "models/player/custom_player/legacy/ctm_st6_variante.mdl",
    "models/player/custom_player/legacy/ctm_st6_variantm.mdl",
    "models/player/custom_player/legacy/ctm_st6_variantg.mdl",
    "models/player/custom_player/legacy/ctm_st6_variantk.mdl",
    "models/player/custom_player/legacy/ctm_st6_varianti.mdl",
    "models/player/custom_player/legacy/ctm_st6_variantj.mdl",
    "models/player/custom_player/legacy/ctm_st6_variantl.mdl",
    "models/player/custom_player/legacy/ctm_swat_variante.mdl",
    "models/player/custom_player/legacy/ctm_swat_variantf.mdl",
    "models/player/custom_player/legacy/ctm_swat_variantg.mdl" ,
    "models/player/custom_player/legacy/ctm_swat_varianth.mdl",
    "models/player/custom_player/legacy/ctm_swat_varianti.mdl",
    "models/player/custom_player/legacy/ctm_swat_variantj.mdl",
    "models/player/custom_player/legacy/tm_balkan_varianti.mdl",
    "models/player/custom_player/legacy/tm_balkan_variantf.mdl",
    "models/player/custom_player/legacy/tm_balkan_varianth.mdl",
    "models/player/custom_player/legacy/tm_balkan_variantg.mdl",
    "models/player/custom_player/legacy/tm_balkan_variantj.mdl",
    "models/player/custom_player/legacy/tm_balkan_variantk.mdl",
    "models/player/custom_player/legacy/tm_balkan_variantl.mdl",
    "models/player/custom_player/legacy/ctm_sas_variantf.mdl",
    "models/player/custom_player/legacy/tm_phoenix_varianth.mdl",
    "models/player/custom_player/legacy/tm_phoenix_variantf.mdl",
    "models/player/custom_player/legacy/tm_phoenix_variantg.mdl",
    "models/player/custom_player/legacy/tm_phoenix_varianti.mdl",
    "models/player/custom_player/legacy/tm_professional_varf.mdl",
    "models/player/custom_player/legacy/tm_professional_varf1.mdl",
    "models/player/custom_player/legacy/tm_professional_varf2.mdl",
    "models/player/custom_player/legacy/tm_professional_varf3.mdl",
    "models/player/custom_player/legacy/tm_professional_varf4.mdl",
    "models/player/custom_player/legacy/tm_professional_varg.mdl",
    "models/player/custom_player/legacy/tm_professional_varh.mdl",
    "models/player/custom_player/legacy/tm_professional_vari.mdl",
    "models/player/custom_player/legacy/tm_professional_varj.mdl",
    "models/player/custom_player/toppiofficial/genshin/barbara.mdl",
    "models/player/custom_player/nuclearsilo/blue_archive/mika/mika_v2.mdl"
}

local mca = ui.add_checkbox("Модель ченджер")
local mca_List = ui.add_dropdown("Модель Лист", Materials)

ffi.cdef[[
       typedef struct
    {
        void*   handle;
        char    name[260];
        int     load_flags;
        int     server_count;
        int     type;
        int     flags;
        float   mins[3];
        float   maxs[3];
        float   radius;
        char    pad[0x1C];
    } model_t;
    typedef struct _class{void** this;}aclass;
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef void(__thiscall* find_or_load_model_fn_t)(void*, const char*);
    typedef const int(__thiscall* get_model_index_fn_t)(void*, const char*);
    typedef const int(__thiscall* add_string_fn_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* full_update_t)();
    typedef int(__thiscall* get_player_idx_t)();
    typedef void*(__thiscall* get_client_networkable_t)(void*, int);
    typedef void(__thiscall* pre_data_update_t)(void*, int);
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
]]

local a = ffi.cast(ffi.typeof("void***"), client.create_interface("client.dll", "VClientEntityList003")) or error("rawientitylist is nil", 2)
local b = ffi.cast("get_client_entity_t", a[0][3]) or error("get_client_entity is nil", 2)
local c = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VModelInfoClient004")) or error("model info is nil", 2)
local d = ffi.cast("get_model_index_fn_t", c[0][2]) or error("Getmodelindex is nil", 2)
local e = ffi.cast("find_or_load_model_fn_t", c[0][43]) or error("findmodel is nil", 2)
local f = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll","VEngineClientStringTable001")) or error("clientstring is nil", 2)
local g = ffi.cast("find_table_t", f[0][3]) or error("find table is nil", 2)

function p(pa)
    local a_p = ffi.cast(ffi.typeof("void***"), g(f, "modelprecache"))
    if a_p~= nil then
        e(c, pa)
        local ac = ffi.cast("add_string_fn_t", a_p[0][8]) or error("ac nil", 2)
        local acs = ac(a_p, false, pa, -1, nil)
        if acs == -1 then print("failed")
            return false
        end
    end
    return true
end

function smi(en, i)
    local rw = b(a, en)
    if rw then
        local gc = ffi.cast(ffi.typeof("void***"), rw)
        local se = ffi.cast("set_model_index_t", gc[0][75])
        if se == nil then
            error("smi is nil")
        end
        se(gc, i)
    end
end

function cm(ent, md)
    if md:len() > 5 then
        if p(md) == false then
            error("invalid model", 2)
        end
        local i = d(c, md)
        if i == -1 then
            return
        end
        smi(ent, i)
    end
end

function cmd1(stage)
    if stage ~= 1 then
        return
    end
    if mca:get() then
        local ip = entity_list.get_client_entity( engine.get_local_player( ))
        if ip == nil then
            return
        end
        if engine.is_connected() and client.is_alive() then

            cm(ip:index(), Materials[mca_List:get() + 1])
        end
    end
end

callbacks.register("pre_frame_stage", cmd1)
-- End: Model Changer
ffi.cdef[[
    struct vec3_t {
        float x;
        float y;
        float z;   
    };

    typedef void( __thiscall* energy_splash_fn )( void*, const struct vec3_t& position, const struct vec3_t& direction, bool explosive );
]]

local native = { }

native.bind_argument = function( fn, arg )
    return function( ... )
        return fn( arg, ... );
    end
end

-- get the effects interface.
native.effects_interface = ffi.cast( ffi.typeof( "uintptr_t**" ), client.create_interface( "client.dll", "IEffects001" ) );

-- get the EnergySplash vfunc.
native.energy_splash = native.bind_argument( ffi.cast( "energy_splash_fn", native.effects_interface[ 0 ][ 7 ] ), native.effects_interface );



local dynamic_antiaim = {
    refs = {
        edge_yaw_label = ui.add_label("анти хэдшот аа"),
        edge_yaw_cog = ui.add_cog("Анти хэдшот", false, true),
        teleport_inair = ui.add_checkbox("аир телепорт"),
        teleport_inair_weapons = ui.add_multi_dropdown("weapons", { "scout", "awp", "deagle", "pistols" }),
        on_use = ui.add_checkbox("allow on use"),
        anti_backstab = ui.add_checkbox("Анти спина"),
        roll_manual = ui.add_checkbox("ролл деректоин")
    },
menu_refs = {
        fake_yaw_on_use = ui.get("Rage", "Anti-aim", "General", "Fake yaw on use"),
        doubletap = ui.get("Rage", "Exploits", "General", "Double tap key"),
        pitch = ui.get("Rage", "Anti-aim", "General", "Pitch"),
        yaw_additive = ui.get("Rage", "Anti-aim", "General", "Yaw additive"),
        manual_left = ui.get("Rage", "Anti-aim", "General", "Manual left key"),
        manual_right = ui.get("Rage", "Anti-aim", "General", "Manual right key"),
        inverter = ui.get("Rage", "Anti-aim", "General", "Anti-aim invert")
    },

    vars = {
        anti_backstab = {
            should_work = false
        },

        edge_yaw = {
            condition = 0,
            edging = false,
            should_work = false
        }
    }
}

dynamic_antiaim.visibility = function()
    local tab = menu.tabs:get() == 2 and true or false

    dynamic_antiaim.refs.edge_yaw_label:set_visible(tab)
    dynamic_antiaim.refs.edge_yaw_cog:set_visible(tab)
    dynamic_antiaim.refs.teleport_inair:set_visible(tab)
    dynamic_antiaim.refs.teleport_inair_weapons:set_visible(tab and dynamic_antiaim.refs.teleport_inair:get())
    dynamic_antiaim.refs.on_use:set_visible(tab)
    dynamic_antiaim.refs.anti_backstab:set_visible(tab)
    dynamic_antiaim.refs.roll_manual:set_visible(tab)
end

dynamic_antiaim.edge_yaw = function()
    if not dynamic_antiaim.refs.edge_yaw_cog:get_key() then
        return
    end

    local local_eye = globals._local.eye_position
    local view_angle = globals._local.view_angles.y

    local freestanding = function()
        local data = {
            distance = 35,
            point = nil
        }

        dynamic_antiaim.vars.edge_yaw.edging = false
        for i = view_angle - 180, view_angle + 90, 180 / 16 do
            if i == view_angle then
                break
            end

            local radians = i * math.pi / 180
            local eye_position = vector.new(
                local_eye.x + 256 * math.cos(radians), 
                local_eye.y + 256 * math.sin(radians), 
                local_eye.z
            )

            local trace = engine_trace.trace_ray(local_eye, eye_position, globals._local.player, 0x4600400B)
            if trace.fraction * 256 < data.distance then
                data.distance = trace.fraction * 256
                data.point = vector.new(
                    local_eye.x + 256 * trace.fraction * math.cos(radians), 
                    local_eye.y + 256 * trace.fraction * math.sin(radians), 
                    local_eye.z
                )

                dynamic_antiaim.vars.edge_yaw.edging = true
            end
        end

        dynamic_antiaim.vars.edge_yaw.point = data.point
    end

    local get_angle = function()
        if not dynamic_antiaim.vars.edge_yaw.point then
            return 0
        end

        local point = vector.new(
            dynamic_antiaim.vars.edge_yaw.point.x - local_eye.x, 
            dynamic_antiaim.vars.edge_yaw.point.y - local_eye.y, 
            dynamic_antiaim.vars.edge_yaw.point.z - local_eye.z
        )

        local point_tangent = math.atan2(point.y, point.x) * 180 / math.pi;
        local normalized_view_angle = math.normalize(view_angle - 180);

        return math.normalize(point_tangent - normalized_view_angle)
    end

    freestanding()

    if dynamic_antiaim.vars.edge_yaw.edging then
        dynamic_antiaim.menu_refs.yaw_additive:set(get_angle())
        dynamic_antiaim.vars.edge_yaw.should_work = true

    else
        dynamic_antiaim.vars.edge_yaw.should_work = false
    end
end

dynamic_antiaim.teleport_inair = function()
    if not dynamic_antiaim.refs.teleport_inair:get() then
        return
    end

    if not dynamic_antiaim.menu_refs.doubletap:get_key() then
        return
    end

    if not (dynamic_antiaim.refs.teleport_inair_weapons:get("scout") and globals._local.weapon:is_scout() or
    dynamic_antiaim.refs.teleport_inair_weapons:get("awp") and globals._local.weapon:is_awp() or
    dynamic_antiaim.refs.teleport_inair_weapons:get("deagle") and globals._local.weapon:is_deagle() or
    dynamic_antiaim.refs.teleport_inair_weapons:get("pistols") and globals._local.weapon:is_pistol()) then

        return
    end

    local target = globals.crosshair_target.entity
    if not target then
        return
    end

    if target:can_hit() and globals._local.player:air() and exploits.ready() then
        exploits.force_uncharge()
    end
end

dynamic_antiaim.on_use = function()
    dynamic_antiaim.menu_refs.fake_yaw_on_use:set(dynamic_antiaim.refs.on_use:get())
end

dynamic_antiaim.anti_backstab = function()
    if not dynamic_antiaim.refs.anti_backstab:get() then
        return
    end

    local target = globals.crosshair_target.entity
    if not target then
        return
    end

    local target_weapon = target:weapon()
    if not target_weapon then
        return
    end

    local target_origin = target:origin()

    local distance = globals._local.origin:dist_to(target_origin)
    local min_distance = 200

    if target_weapon:is_knife(target_weapon) and distance <= min_distance then
        dynamic_antiaim.menu_refs.pitch:set(0)
        dynamic_antiaim.menu_refs.yaw_additive:set(180)
        dynamic_antiaim.vars.anti_backstab.should_work = true

    else
        dynamic_antiaim.menu_refs.pitch:set(1)
        dynamic_antiaim.vars.anti_backstab.should_work = false
    end
end

dynamic_antiaim.roll_manual = function()
    if not dynamic_antiaim.refs.roll_manual:get() then
        return
    end

    if dynamic_antiaim.menu_refs.manual_left:get_key() or dynamic_antiaim.menu_refs.manual_right:get_key() then
        dynamic_antiaim.menu_refs.inverter:set_key(true)
    end
end

ui.add_label("							MISC")
local dt = ui.get("Rage", "Exploits", "General", "Double tap key")
local hs = ui.get("Rage", "Exploits", "General", "Hide shots key")
local yaw = ui.get("Rage", "Anti-aim", "General", "Yaw additive")
local cached_yaw = yaw:get()
function TimeToTicks(a)
    return math.floor((0.5 + a) / 0.0078125)
 end
local PreviousSimulationTime = 0
local DifferenceOfSimulation = 0
function SimulationDifference()
   local LocalPlayer = entity_list.get_client_entity(engine.get_local_player())
   local CurrentSimulationTime = TimeToTicks(LocalPlayer:get_prop("DT_BaseAnimating", "m_flSimulationTime"):get_int())
   local Difference = CurrentSimulationTime - (PreviousSimulationTime + 0.75)
   PreviousSimulationTime = CurrentSimulationTime
   DifferenceOfSimulation = Difference
   return DifferenceOfSimulation
end

local menu = {
    antiaim = {
    pitchexploit = ui.add_checkbox("Дэфэнсив АА"),
    speed = ui.add_slider("Скорость вращения", 1, 30),
    }
}
inair = function(entity)
    if entity then
        local local_player = entity_list.get_client_entity(engine.get_local_player())
        local ground_entity = local_player:get_prop("DT_BasePlayer", "m_hGroundEntity"):get_int()

        if ground_entity == -1 then
            return true
        end
    end

    return false
end
local b = ui.get("Rage", "Anti-aim", "General", "Pitch")
local function DeffensivePitch()
lp = entity_list.get_client_entity(engine.get_local_player())
math.randomseed(global_vars.curtime)
    if menu.antiaim.pitchexploit:get() then
        if  dt:get_key() == false or hs:get_key() == false then    
        b:set(1)
        end
        if inair(lp) then
            if dt:get_key() == true or hs:get_key() == true then
                if SimulationDifference() <= -1 then      
                b:set(math.random(1, 3))
                else
                if math.floor(global_vars.curtime * 26) % 16 == 0 and client.choked_commands() < 2 then
                    b:set(math.random(1, 3))
                else
                    b:set(1)
                end
                end
            end
        end
    end
end
local stage = -180
function on_post_move(cmd)
    if menu.antiaim.pitchexploit:get() and inair(lp) then
    if cmd.tick_count % 4 >= 0 then
        stage = stage + menu.antiaim.speed:get()
        yaw:set(stage)
    end
    if stage == 179 then
        stage = -180
    end
    else
        yaw:set(cached_yaw)
    end
end
callbacks.register("paint", DeffensivePitch);
callbacks.register("predicted_move", on_post_move)


-- pasted & ported from https://yougame.biz/threads/255505
-- @lthon09 (i don't fucking know what i'm doing anymore)

local ffi = require "ffi"
local bit = require "bit"

local __thiscall = function(func, this)
    return function(...) return func(this, ...) end
end

local interface_ptr = ffi.typeof("void***")

local vtable_bind = function(_module, interface, index, typedef)
    local addr = ffi.cast("void***", client.create_interface(_module, interface)) or error(interface .. " was not found")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end
local vtable_entry = function(instance, i, ct)
    return ffi.cast(ct, ffi.cast(interface_ptr, instance)[0][i])
end
local vtable_thunk = function(i, ct)
    local t = ffi.typeof(ct)

    return function(instance, ...)
        return vtable_entry(instance, i, t)(instance, ...)
    end
end

local get_class_name = vtable_thunk(143, "const char*(__thiscall*)(void*)")
local set_model_index = vtable_thunk(75, "void(__thiscall*)(void*,int)")

local get_client_entity_from_handle = vtable_bind("client.dll", "VClientEntityList003", 4, "void*(__thiscall*)(void*,void*)")
local get_model_index = vtable_bind("engine.dll", "VModelInfoClient004", 2, "int(__thiscall*)(void*, const char*)")

local rawientitylist = client.create_interface("client.dll", "VClientEntityList003") or error("VClientEntityList003 was not found", 2)

local ientitylist = ffi.cast(interface_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("void*(__thiscall*)(void*, int)", ientitylist[0][3]) or error("get_client_entity was not found", 2)

local client_string_table_container = ffi.cast(interface_ptr, client.create_interface("engine.dll", "VEngineClientStringTable001")) or error("VEngineClientStringTable001 was not found", 2)
local find_table = vtable_thunk(3, "void*(__thiscall*)(void*, const char*)")

local model_info = ffi.cast(interface_ptr, client.create_interface("engine.dll", "VModelInfoClient004")) or error("VModelInfoClient004 wasnt found", 2)

ffi.cdef [[
    typedef void(__thiscall* find_or_load_model_t)(void*, const char*);
]]

local add_string = vtable_thunk(8, "int*(__thiscall*)(void*, bool, const char*, int length, const void* userdata)")
--local find_or_load_model = ffi.cast("find_or_load_model_t", model_info[0][43]) -- vtable_thunk crashes (?)
local find_or_load_model = vtable_thunk(43, "find_or_load_model_t")

local function get_player_address(lp)
    return get_client_entity(ientitylist, lp:index())
end

local function _precache(szModelName)
    if szModelName == "" then return end -- don't precache empty strings (crash)
    if szModelName == nil then return end

    szModelName = string.gsub(szModelName, [[\]], [[/]])
    local m_pModelPrecacheTable = find_table(client_string_table_container, "modelprecache")

    if m_pModelPrecacheTable ~= nil then
        find_or_load_model(model_info, szModelName)
        add_string(m_pModelPrecacheTable, false, szModelName, -1, nil)
    end
end
local function precache(modelPath)
    if modelPath == "" then return -1 end -- don't crash.

    local local_model_index = get_model_index(modelPath)

    if local_model_index == -1 then
        _precache(modelPath)
    end

    return get_model_index(modelPath)
end

local masks = {
    "без маски",
    "Dallas",
    "Battle Mask",
    "Evil Clown",
    "Anaglyph",
    "Boar",
    "Bunny",
    "Bunny Gold",
    "Chains",
    "Chicken",
    "Devil Plastic",
    "Hoxton",
    "Pumpkin",
    "Samurai",
    "Sheep Bloody",
    "Sheep Gold",
    "Sheep Model",
    "Skull",
    "Template",
    "Wolf",
    "Doll",
}
local models = {
    "",
    "models/player/holiday/facemasks/facemask_dallas.mdl",
    "models/player/holiday/facemasks/facemask_battlemask.mdl",
    "models/player/holiday/facemasks/evil_clown.mdl",
    "models/player/holiday/facemasks/facemask_anaglyph.mdl",
    "models/player/holiday/facemasks/facemask_boar.mdl",
    "models/player/holiday/facemasks/facemask_bunny.mdl",
    "models/player/holiday/facemasks/facemask_bunny_gold.mdl",
    "models/player/holiday/facemasks/facemask_chains.mdl",
    "models/player/holiday/facemasks/facemask_chicken.mdl",
    "models/player/holiday/facemasks/facemask_devil_plastic.mdl",
    "models/player/holiday/facemasks/facemask_hoxton.mdl",
    "models/player/holiday/facemasks/facemask_pumpkin.mdl",
    "models/player/holiday/facemasks/facemask_samurai.mdl",
    "models/player/holiday/facemasks/facemask_sheep_bloody.mdl",
    "models/player/holiday/facemasks/facemask_sheep_gold.mdl",
    "models/player/holiday/facemasks/facemask_sheep_model.mdl",
    "models/player/holiday/facemasks/facemask_skull.mdl",
    "models/player/holiday/facemasks/facemask_template.mdl",
    "models/player/holiday/facemasks/facemask_wolf.mdl",
    "models/player/holiday/facemasks/porcelain_doll.mdl",
}

local list = ui.add_dropdown("Mask Changer", masks)

local last_model = 0
local model_index = -1
local enabled = false

callbacks.register("paint", function()
	if not engine.in_game() then
        last_model = 0
        return
    end
    if last_model ~= list:get() then
        last_model = list:get()
        if last_model == 0 then
            enabled = false
        else
            enabled = true
            model_index = precache(models[last_model + 1])
        end
    end
end)

callbacks.register("predicted_move", function(_) -- what the fuck is "pre_prediction"???
	if model_index == -1 then return precache(models[last_model + 1]) end

    local local_player = entity_list.get_client_entity(engine.get_local_player())

    if enabled then
        local lp_addr = ffi.cast("intptr_t*", get_player_address(local_player))
        local m_AddonModelsHead = ffi.cast("intptr_t*", lp_addr + 0x462F) -- E8 ? ? ? ? A1 ? ? ? ? 8B CE 8B 40 10
        local i, next_model = m_AddonModelsHead[0], -1

        while i ~= -1 do
            next_model = ffi.cast("intptr_t*", lp_addr + 0x462C)[0] + 0x18 * i -- this is the pModel (CAddonModel) afaik
            i = ffi.cast("intptr_t*", next_model + 0x14)[0]

            local m_pEnt = ffi.cast("intptr_t**", next_model)[0] -- CHandle<C_BaseAnimating> m_hEnt -> Get()
            local m_iAddon = ffi.cast("intptr_t*", next_model + 0x4)[0]

            if tonumber(m_iAddon) == 16 then -- face mask addon bits knife = 10
                local entity = get_client_entity_from_handle(m_pEnt)
                set_model_index(entity, model_index)
            end
        end
    end
end)

callbacks.register("pre_frame_stage", function(stage)
	if stage ~= 5 then return end

    local local_player = entity_list.get_client_entity(engine.get_local_player())

    if local_player == nil then return end

    if enabled then
        if bit.band(local_player:get_prop("DT_CSPlayer", "m_iAddonBits"):get_int(), 0x10000) ~= 0x10000 then
			local_player:get_prop("DT_CSPlayer", "m_iAddonBits"):set_int(0x10000 + local_player:get_prop("DT_CSPlayer", "m_iAddonBits"):get_int())
        end
    else
        if bit.band(local_player:get_prop("DT_CSPlayer", "m_iAddonBits"):get_int(), 0x10000) == 0x10000 then
			local_player:get_prop("DT_CSPlayer", "m_iAddonBits"):set_int(local_player:get_prop("DT_CSPlayer", "m_iAddonBits"):get_int() - 0x10000)
        end
    end
end)



local font = render.create_font("Verdana", 12, 400, bit.bor(font_flags.outline))
--Menu
ui.add_label("GIXTAP LUA");
local indicator_checkbox = ui.add_checkbox("индикатор")

-- Var
local g_col_disabled = color.new(153,124,122);
local g_col_enabled  = color.new(153,124,122);
local lag_history = {0, 0, 0, 0, 0, 0}
-- UI GET
local jitter = ui.get("Rage","Anti-Aim","General","Yaw jitter")
local exploit = ui.get("Rage", "Exploits", "General", "Enabled")
local dt = ui.get("Rage", "Exploits", "General", "Double tap key")
local dmg = ui.get_rage("General", "Minimum damage override key")
local fs = ui.get("Rage", "Anti-aim", "General", "Freestanding key")
local fd = ui.get("Rage", "Anti-aim", "Fake-lag", "Fake duck key")
local sw = ui.get("Misc", "General", "Movement", "Slow motion key")


local function drawBase()
if indicator_checkbox:get() == true then
    font:text(30, 450, color.new(153,120,92),"GIXTAP LUA - pandora version$")
    font:text(30, 465, color.new(132,113,145),"> анти аим инфо :")
    font:text(30, 480, color.new(153,124,122),"> рэйдж бот инфо :")
    font:text(30, 495, color.new(154,156,134),"> инфо об игроке - ")
    end 
end
local function drawFl()
        if client.choked_commands() < lag_history[6] then
            lag_history[1] = lag_history[2]
             lag_history[2] = lag_history[3]
             lag_history[3] = lag_history[4]
             lag_history[4] = lag_history[5]
             lag_history[5] = lag_history[6]
        end
        font:text(153,465, color.new(115,109,153), string.format("fl(%i-%i-%i)",lag_history[5],lag_history[4],lag_history[3],lag_history[2],lag_history[1]  ))
        lag_history[6] = client.choked_commands()
end
local function drawSide()
    if anti_aim.inverted() then
        font:text(223, 465, color.new(115,109,153), "направленно : > ")     
    else
        font:text(223, 465, color.new(115,109,153), "направленно : < ")
    end
end
local function drawAA()
    if not fs:get_key() then
        font:text(125, 465, color.new(118,109,153),"джитер")
        return
    elseif jitter:get() == true then
        font:text(125, 465, color.new(118,109,153),"фристенд")
    else
        font:text(125, 465, color.new(118,109,153),"статик")
    end
end

local function getMinimumDamage( var )
    local minimum_damage = var:get();
    if minimum_damage == 0 then
        return "auto";
    elseif minimum_damage > 100 then
        return string.format("hp+%d", minimum_damage - 100);
    else
        return tostring(minimum_damage);
    end
end
local function drawDmg()
    local is_overriding = dmg:get_key();
    local dmg1 = ui.get_rage("General", "Minimum damage")
    local dmg2 = ui.get_rage("General", "Minimum damage override")
    local v = getMinimumDamage(is_overriding and dmg2 or dmg1);
    font:text(123, 480, is_overriding and g_col_enabled or g_col_disabled, string.format("dmg: %s", v));
   
end
local function drawDt()
    if not exploit:get() then
        return
    end
    if not dt:get_key() then
        font:text(175, 480, color.new(153,124,122),"dt")
        return
    end
    local doubletap_value = exploits.process_ticks() / 14;
    font:text( 175, 480, color.new(153,124,122), string.format("dt (%d%s)", math.floor(doubletap_value * 100), "%"));
end 
local function drawPlayer()
   if sw:get_key() then
    font:text(150, 495, color.new(154,156,134),"slow walk")
   end
   if fd:get_key() then
    font:text(150, 495, color.new(154,156,134),"fake duck")
   end
   if not sw:get_key() and not fd:get_key() then
    font:text(150, 495, color.new(154,156,134),"native")
   end  
end
-- end indicator 

local function onPaint()
if indicator_checkbox:get() == true then
    if not client.is_alive() then
        return
    end
   drawBase();
   drawFl();
   drawSide();
   drawAA();
   drawDmg();
   drawDt();
   drawPlayer();
end
end
callbacks.register("paint", onPaint);
