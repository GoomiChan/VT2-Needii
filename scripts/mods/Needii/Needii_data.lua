local mod = get_mod("Needii")

return {
	name            = "Needii",
	description     = mod:localize("mod_description"),
	is_togglable    = true,
	options_widgets = {                             
		{
			["setting_name"]  = "useCareerIcons",
			["widget_type"]   = "checkbox",
			["text"]          = mod:localize("useCareerIcons_CB_Name"),
			["tooltip"]       = mod:localize("useCareerIcons_CB_TT"),
			["default_value"] = true
		},
		{
			["setting_name"]  = "countBots",
			["widget_type"]   = "checkbox",
			["text"]          = mod:localize("countBots_CB_Name"),
			["tooltip"]       = mod:localize("countBots_CB_TT"),
			["default_value"] = true
		}
	}
}