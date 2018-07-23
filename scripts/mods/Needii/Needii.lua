local mod = get_mod("Needii")

-- Data
------------------------------
mod.data = {
	iconLookUp = {
		["wood_elf"] = {
			texture = "hero_icon_medium_way_watcher_yellow"
		},
		["bright_wizard"] = {
			texture = "hero_icon_medium_bright_wizard_yellow"
		},
		["dwarf_ranger"] = {
			texture = "hero_icon_medium_dwarf_ranger_yellow"
		},
		["empire_soldier"] = {
			texture = "hero_icon_medium_empire_soldier_yellow"
		},
		["witch_hunter"] = {
			texture = "hero_icon_medium_witch_hunter_yellow"
		},

		-- Careers
		["we_waywatcher"] = {
			texture = "small_unit_frame_portrait_kerillian_waywatcher"
		},
		["we_shade"] = {
			texture = "small_unit_frame_portrait_kerillian_shade"
		},
		["we_maidenguard"] = {
			texture = "small_unit_frame_portrait_kerillian_maidenguard"
		},

		["bw_scholar"] = {
			texture = "small_unit_frame_portrait_sienna_scholar"
		},
		["bw_unchained"] = {
			texture = "small_unit_frame_portrait_sienna_unchained"
		},
		["bw_adept"] = {
			texture = "small_unit_frame_portrait_sienna_adept"
		},

		["dr_slayer"] = {
			texture = "small_unit_frame_portrait_bardin_slayer"
		},
		["dr_ironbreaker"] = {
			texture = "small_unit_frame_portrait_bardin_ironbreaker"
		},
		["dr_ranger"] = {
			texture = "small_unit_frame_portrait_bardin_ranger"
		},

		["es_mercenary"] = {
			texture = "small_unit_frame_portrait_kruber_mercenary"
		},
		["es_huntsman"] = {
			texture = "small_unit_frame_portrait_kruber_huntsman"
		},
		["es_knight"] = {
			texture = "small_unit_frame_portrait_kruber_knight"
		},

		["wh_zealot"] = {
			texture = "small_unit_frame_portrait_victor_zealot"
		},
		["wh_bountyhunter"] = {
			texture = "small_unit_frame_portrait_victor_bountyhunter"
		},
		["wh_captain"] = {
			texture = "small_unit_frame_portrait_victor_captain"
		},

	},
	RPCS = {
		-- TODO: later add rpcs for talents and other info that isn't already avable normaly to clients
	}
}

-- Config settings exposed to the ui, well mostly
mod.conf = {
	useCareerIcons      = mod:get("useCareerIcons"),
	updateOrderInterval = 0.5,
	countBots           = mod:get("countBots"),
	useDebugPartyInfo   = false,
	debugLogging        = 0, -- 0 off, 1 logs only, 2 echo
	enableDebugCommands = false
}

mod.vars = {
	iconRenderList = {},
	lastOrderTime  = 0,
	lastItemName   = "",
	isServer       = false,
	serverHasMod   = false,
	isLoaded       = false
}

mod.debug = {
	data = {} -- filed in from other file called by doFile
}


-- Functions
------------------------------

mod.DebugLog = function(msg)
	if mod.conf.debugLogging == 2 then
		mod:echo(msg)
	elseif mod.conf.debugLogging == 1 then
		print(msg)
	end
end

mod.GetBasePlayerNeed = function(player) 
	local weight = 0

	if not mod.conf.countBots and player.isBot then
		weight = -10000000 -- rule out any bots
	else
		if not player.isBot 		then weight = weight + 1 end
		if not player.isDead 		then weight = weight + 1 end
		if not player.isDowned	then weight = weight + 1 end
	end

	return weight
end

mod.itemHandlers = {
	["grenade_frag"] = function(player) 
		local weight = mod.GetBasePlayerNeed(player)
		
		if player.inv.slot_grenade == nil then
			weight = weight + 1
		else
			return 0 -- no slot no have
		end

		return weight
	end,
	["potion_damage_boost_01"] = function(player) 
		local weight = mod.GetBasePlayerNeed(player)
		
		if player.inv.slot_potion == nil then
			weight = weight + 1
		else
			return 0 -- no slot no have
		end

		return weight
	end,
	["interaction_ammunition"] = function(player) 
		local weight = mod.GetBasePlayerNeed(player)

		if player.ammo < 1 then
			local missingAmount = 1 - player.ammo
			local weightedAmmoMissing = math.ceil(missingAmount * 100)

			weight = weight + weightedAmmoMissing
		else
			weight = 0 
		end

		return weight
	end,
	["potion_healing_draught_01"] = function(player) 
		local weight = mod.GetBasePlayerNeed(player)

		if player.hp < 1 and player.inv.slot_healthkit == nil then
			local missingAmount = 1 - player.hp
			local weightedHpMissing = math.ceil(missingAmount * 100)

			weight = weight + weightedHpMissing
		else
			weight = 0 
		end

		return weight
	end,
	["tome"] = function(player) 
		local weight = mod.GetBasePlayerNeed(player)

		if player.inv.slot_healthkit == nil then
			weight = weight + 1
		else
			return 0 -- no slot no have
		end

		return weight
	end,
	["grimoire"] = function(player) 
		local weight = mod.GetBasePlayerNeed(player)

		if player.inv.slot_potion == nil then
			weight = weight + 1
		else
			return 0 -- no slot no have
		end

		return weight
	end
}

-- other items that use the same weighting
mod.itemHandlers["grenade_fire"]                  = mod.itemHandlers["grenade_frag"]
mod.itemHandlers["potion_speed_boost_01"]         = mod.itemHandlers["potion_damage_boost_01"]
mod.itemHandlers["potion_cooldown_reduction_01"]  = mod.itemHandlers["potion_damage_boost_01"]
mod.itemHandlers["interaction_ranger_ammunition"] = mod.itemHandlers["interaction_ammunition"]
mod.itemHandlers["healthkit_first_aid_kit_01"]    = mod.itemHandlers["potion_healing_draught_01"]

mod.OnLoad = function()	
	dofile("scripts/mods/Needii/NeediiDebug")
	mod.vars.isLoaded = true

	-- TODO: Rework settings loading
end

mod.DrawPlayerIcons = function(render)
	local iconSizeLookUp = mod.conf.useCareerIcons and { w = 60, h = 70 } or { w = 46, h = 46 } -- Yea this is sorta nasty, will redo later, maybe

	local scale               = RESOLUTION_LOOKUP.scale
	local position            = Vector3(RESOLUTION_LOOKUP.res_w / 2, RESOLUTION_LOOKUP.res_h / 2, 0)
	local size                = Vector2(iconSizeLookUp.w * scale, iconSizeLookUp.h * scale)
	local spacing             = 4 * scale

	-- Offset to match the interaction widget
	position.x = position.x + (64 * scale)
	position.y = position.y + (38 * scale)

	if (mod.vars.sortedPartyInfo ~= nil) then
		for i,info in pairs(mod.vars.sortedPartyInfo) do
			local iconName  = mod.conf.useCareerIcons and info.career or info.name
			local lookUpObj = mod.data.iconLookUp[iconName]

			if lookUpObj ~= nil then
				local tex       = lookUpObj.texture
				local arrowSize = Vector2(31 * scale, 15 * scale)
				local arrowPos  = Vector3(position.x + (size.x/2 - arrowSize.x/2), position.y + size.y -5, position.y)

				--UIRenderer.script_draw_bitmap(render.gui, render.render_settings, "drop_down_menu_arrow", arrowPos, arrowSize)
				UIRenderer.script_draw_bitmap(render.gui, render.render_settings, tex, position, size)

				position.x = position.x + size.x + spacing
			end
		end
	end
	
end

mod.GetPartyInfos = function()

	-- Wrap in a pcall just to be extra safe incase there is some more weirdness with some weapon swaping leading to a crash
	-- pcall overhead should be negitable esp since this function isn't called per frame
	local ok, result = pcall(function()
		local player_manager = Managers.player
		local players        = player_manager:human_and_bot_players()
		local playerInfos    = {}

		for _, player in pairs(players) do
			local profile   = SPProfiles[player:profile_index()]
			local career    = profile.careers[player:career_index()]

			if profile ~= nil and career ~= nil and
						ScriptUnit.has_extension(player.player_unit, "health_system") and
						ScriptUnit.has_extension(player.player_unit, "inventory_system") and
						ScriptUnit.has_extension(player.player_unit, "status_system") then
					
				local health    = ScriptUnit.extension(player.player_unit, "health_system")
				local inventory = ScriptUnit.extension(player.player_unit, "inventory_system")
				local status    = ScriptUnit.extension(player.player_unit, "status_system")
				local eslots    = inventory:equipment().slots

				-- items
				local slots = {}
				for i,slotName in ipairs({"slot_healthkit", "slot_potion", "slot_grenade"}) do
					if eslots[slotName] ~= nil then
						local slot = eslots[slotName]
						slots[slotName] = {
							name = slot.master_item and slot.master_item.name or slot.item_data.name
						}
					end
				end

				-- ammo
				local ammo = mod.GetPlayerAmmo(player, eslots["slot_ranged"])

				-- talents
				--local talents = mod.GetPlayersTalents(player)

				table.insert(playerInfos, {
					name     = profile.display_name,
					career   = career.name,
					talents  = nil,
					inv      = slots,
					hp       = health:current_health_percent(),
					ammo     = ammo,
					isDowned = status:is_wounded(),
					isDead   = status:is_dead(),
					isBot    = not player:is_player_controlled()
				})
			end
		end

		return playerInfos
	end)

	if ok then
		return result
	else
		print("Needii: Error in GetPartyInfos, bad stuff happend :<")
		print("Error: " .. result)

		return nil
	end
end

mod.GetIconOrder = function(itemName, partyInfos)
	local itemHandler = mod.itemHandlers[itemName]

	if (itemHandler ~= nil and partyInfos ~= nil) then
		local weightedList = {}
		mod.DebugLog("----[Debug weights for ".. itemName .."]----")

		-- Weighting
		for _,info in ipairs(partyInfos) do
			local weight = itemHandler(info)

			if weight > 0 then
				info.weight = weight
				table.insert(weightedList, info)

				mod.DebugLog(info.name .. ": ".. weight)
			end
		end

		-- Sorting
		table.sort(weightedList, function(left, right)
			return left.weight > right.weight
		end)

		return weightedList
	end

	return nil
end

mod.GetPlayerAmmo = function(player, rangedSlot)
	if rangedSlot ~= nil then
		local itemData = rangedSlot.item_data
		local game     = Managers.state.network:game()
		local go_id    = Managers.state.unit_storage:go_id(player.player_unit)

		if itemData ~= nil then
			local item_template = BackendUtils.get_item_template(itemData)
			if game and go_id then
				return GameSession.game_object_field(game, go_id, "ammo_percentage")
			end
		end
	else
		return 0
	end

end

-- TODO: Find if it is replicated some where (doesn't seem it) or replicate it myself
mod.GetPlayersTalents = function(player)
	local talentsExtension = ScriptUnit.extension(player.player_unit, "talent_system")
	local profile          = SPProfiles[player:profile_index()]
	local talentTree       = TalentTrees[profile.display_name][profile.careers[player:career_index()].talent_tree_index]
	local talentids        = talentsExtension:_get_talent_ids()

	mod:dtf(talentids, "talentids_"..profile.display_name, 4)

	local talentNames = {}
	--[[for _,id in pairs(talentids) do
		local row, col = math.ceil(id/3), id % 3
		mod:echo("row: "..row.." col: "..col)
		--table.insert(talentNames, talentTree[col][row])
	end]]

	return talentNames
end

-- inv slots
-- slot_ranged, slot_melee, slot_packmaster_claw, slot_healthkit, slot_potion, slot_level_event (a barrel eg), slot_grenade

-- Hooks
------------------------------
mod:hook(InteractionUI, "update", function (func, self, dt, t, my_player)
	local result = func(self, dt, t, my_player)

	local ui_renderer   = self.ui_renderer
	local player_unit   = my_player.player_unit

	if self.draw_interaction_tooltip == true and player_unit ~= nil then
		local timeNow = os.clock()
		local title_text, action_text, interact_action, failed_reason = self:_get_interaction_text(player_unit, false)

		if timeNow > mod.vars.lastOrderTime + mod.conf.updateOrderInterval or mod.vars.lastItemName ~= title_text then
			local partyInfos              = mod.conf.useDebugPartyInfo and mod.debug.data.playerInfos1 or mod.GetPartyInfos()
			mod.vars.sortedPartyInfo 			= mod.GetIconOrder(title_text, partyInfos)
			mod.vars.lastOrderTime   			= timeNow
			mod.vars.lastItemName    			= title_text
		end

		if mod.itemHandlers[title_text] ~= nil then
			mod.DrawPlayerIcons(ui_renderer)
		end
	end

	return result
end)

-- Events
------------------------------
mod.update = function(dt)
	if not mod.vars.isLoaded then
		mod.OnLoad()
	end
end

mod.on_unload = function(exit_game)
	mod.vars.isLoaded = false
end

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_name)
	local setting = mod.conf[setting_name]

	-- this will only work for checkboxes atm
	if setting ~= nil then
		mod.conf[setting_name] = mod:get(setting_name)
	end
end

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(is_first_call)
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(is_first_call)
	mod:enable_all_hooks()
end

-- Tests
------------------------------

-- test, the tests :p
mod.RunTests = function()
	local testResults = {}
	local numRan, numPassed, numFailed = 0, 0, 0
	local confOld = mod.conf

	mod.conf.countBots = true

	if mod.debug.data.tests then
		mod:echo("Running tests...")

		--mod:dump(mod.debug.data.tests, "mod.debug.data.tests", 4)

		for _,test in ipairs(mod.debug.data.tests) do
			local passed = true
			local result = mod.GetIconOrder(test.itemName, test.partyInfo)
			local got    = {}

			numRan = numRan + 1

			for i,info in ipairs(result) do
				if info.name ~= test.expected[i] then
					passed = false
				end

				table.insert(got, info.name)
			end

			if passed then numPassed = numPassed + 1 else numFailed = numFailed + 1 end

			table.insert(testResults, {
				result   = passed and "Passed" or "Failed",
				name     = test.name,
				expected = test.expected,
				got      = got
			})
		end

		-- Print the results
		mod:echo(string.format("Ran %i tests, %i passed, %i failed", numRan, numPassed, numFailed))
		for _,testResult in ipairs(testResults) do
			mod:echo("----[ ".. testResult.name .." ]----")
			mod:echo("Result: ".. testResult.result)

			if testResult.result == "Failed" then
				mod:echo("Expected: ".. mod.JoinToString(testResult.expected))
				mod:echo("Got:      ".. mod.JoinToString(testResult.got))
			end
		end

		-- Dump to a nice file too :>
		mod:dtf(testResults, "NeediiTestResults", 10)

	else
		mod:echo("No tests to run") -- why am I printing this, surely I'd know i made no tests, right!?
	end
	
	mod.conf = confOld
	
end

if mod.conf.enableDebugCommands then
	mod:command("neediitest", "Runs item sorting tests", function() mod.RunTests() end)
end

mod.JoinToString = function(items)
	local str = ""
	for i,item in ipairs(items) do
		str = str .. item .. (i == #items and "" or ", ")
	end

	return str
end
