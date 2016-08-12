Func _RefreshCache()

	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
	$currRefresh = IniRead($appDir & "Preferences.ini","Settings","RefreshCache","True")

	If $currRefresh = "True" Then
		DirRemove($appDir&"Item Sort Resources",1)
		DirRemove($appDir&"Loot Generator Resources",1)
		DirRemove($appDir&"Magic Item Sort Resources",1)
		DirRemove($appDir&"Monster Encounter Resources",1)
		DirRemove($appDir&"Spell Sort Resources",1)
		DirCreate($appDir)
		IniWrite($appDir & "Preferences.ini","Settings","RefreshCache","Refresh2")
	EndIf
EndFunc