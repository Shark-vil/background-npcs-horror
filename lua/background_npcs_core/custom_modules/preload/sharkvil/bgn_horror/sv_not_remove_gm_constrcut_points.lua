hook.Add('BGN_Map_GmConstruct_Remove_DarkRoom_Points', 'BGN_HorrorDontRemove', function()
	return tobool( string.find( game.GetMap(), 'gm_construct' ) )
end)