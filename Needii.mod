return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Needii must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Needii", {
			mod_script       = "scripts/mods/Needii/Needii",
			mod_data         = "scripts/mods/Needii/Needii_data",
			mod_localization = "scripts/mods/Needii/Needii_localization"
		})
	end,
	packages = {
		"resource_packages/Needii/Needii"
	}
}
