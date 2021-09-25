local function TOOL_MENU(Panel)
	Panel:AddControl('CheckBox', {
		Label = 'Enable horror mode',
		Command = 'bgn_horror_mode_enable'
	});
end

hook.Add('PopulateToolMenu', 'BGN_TOOL_CreateMenu_HorrorModeGeneralSettings', function()
	spawnmenu.AddToolMenuOption('Options', 'Horror Background NPCs', 'BGN_HorrorMode_General_Settings',
		'General Settings', '', '', TOOL_MENU)
end)