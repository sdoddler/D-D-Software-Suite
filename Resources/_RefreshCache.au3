Func _RefreshCache()

	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
	$currRefresh = IniRead($appDir & "Preferences.ini","Settings","RefreshCache","True")

	If $currRefresh = "True" Then
		DirRemove($appDir,1)
		DirCreate($appDir)
		IniWrite($appDir & "Preferences.ini","Settings","RefreshCache","Refresh1")
	EndIf
EndFunc