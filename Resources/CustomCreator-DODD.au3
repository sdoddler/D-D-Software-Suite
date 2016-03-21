#CS ---- To DO In this Space ----

	#CS Initial Planning
		Functions for Creating Each GUI So that main part can continue uninteruptted
		- GUIGetMSg(1)
		- Always use the same $hwnd for GUIs
		- Get Return values from button presses and other Functions
	#CE

	#cs -- Basic GUI
		Create Basic GUI
		- Create new Custom Spell
		- Edit Existing Spell
		- Create new Magic Item
		- Edit Existing Magic Item
	#ce

	#CS - DONE
		Use Function with $hParentGUI to Disable Parent GUI while going through this process
		Depending on ButtonPressed
		- Open Creation Window or List of Existing XXX
		- Delete old Window
	#CE

	#CS - CReation Window ( Edit Window)
		Creation Window Should have all Neccessary fields for said Type (Spell or Magic Item)
		With an "Edit Description" button at the bottom to open up the description editor
		- Parse Type (Spell or Magic Item ) first. Mandatory param
		- Function so that you can parse $currData & $currTitle & $currDescription (Only if edit description is pressed?)
		- Cancel Button - If pressed Go back to first GUI?
	#CE

	#CS - Selection Window (Done)
		List of Existing
		- Cancel Button
		- Only display names for Quick Search
	#CE

	#CS -- DEscription Edit
		Description Edit
		- Up Down to change the order of Items
		- ^ Is a 2 Column List view (See testing.au3 for updown func)

		- Add item (Select from Dropdown?)

		- Double Click to edit an item
		- Preview Button or pane
		- Save
		- Cancel
	#CE



	#CS - Editing Existing Decsription Items
		Add Ability to edit description Items
		- Save Changes \ Cancel Button
		- Use Get Sel then Disable Listview + Buttons + Combo
		- Find the Part Type from the Column 0
		- Icon in ICL (no. 10)
		Done most of this - Just need to add actual save changes Function + Cancel Function
		- Use $descReset as array or var to Hold GUI Items taht need to be GUICtrlSetdata(XXX, "") Done to them
		- use _GUICtrlListView_SetItemText to make changes to Col 0 & 1
	#CE
	#CS
		Do WM_NOTIFY or whatever i need to do to pickup double clicks on all the list views and have relevant actions - DONE
		Rewrite Table IniDecode >.> - WIZARD SKILLED THE FUCK OUT OF THIS.
	#CE

	#CS - DONE
		Fix Settings.ini so that by default it picks Custom-Spells.ini but can be changed in the program.

		For other Programs If file exists Custom.ini (defined in settings.ini) use that if not use @scriptdir\CustomItems.ini if not that then don't load customs.
	#CE

	#CS - Done
		Test From other GUI's

		Selection Add Delete button to spell list.
	#CE

	fix below So that you can parse data through to EditorWindow Directly from other programs
	- Should be able to do this from Right click.
	- Remove CreateFirstWindow() From _CustomCreator()
	- Add $var to parse above (If $var then CreatefirstWindow())

	- Parse Directly to Editor Window then If (FunctionVariable) $firstRun = True then _CustomCreator(FALSE) ;; False is for the CreateFirstWindow Variable
	- Will above work?


	EditorWindow("Spell", _GuiCtrllistview_GetitemText($idlistview,$iitem), INIRead($custini,"Index",ItemText,""), INIReadSection($custIni,ItemText))
#CE


#include-once
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <Array.au3>
#include <ComboConstants.au3>
#include <GuiListView.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GUIEdit.Au3>
#include <GuiComboBoxEx.au3>




#Region Global Program Vars
$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)

Global $iconsIcl = $appDir & "Icons.icl"
Global $sParamsIni = $appDir & "SearchParams.ini"
Global $prefIni = $appDir & "Preferences.ini"

$pMagicItemIni = IniRead($prefIni, "Settings", "Custom Magic Items File", "")
$pSpellIni = IniRead($prefIni, "Settings", "Custom Spells File", "")



If FileExists($pMagicItemIni) Then
	Global $cMagicItemsIni = $pMagicItemIni
Else
	Global $cMagicItemsIni = ""
EndIf

If FileExists($pSpellIni) Then
	Global $cSpellIni = $pSpellIni
Else
	Global $cSpellIni = ""
EndIf

#EndRegion Global Program Vars

#Region Global Vars for First Window
Global $firstWindow = 1, $fwCreateItem, $fwCreateSpell, $fwEditItem, $fwEditSpell, $fwSetMagicSave, $fwSetSpellSave
#EndRegion Global Vars for First Window

#Region Global Vars for Selection Window
Global $selCancel, $selWindow = 1, $selSelect, $selListview, $selData, $selDelete
#EndRegion Global Vars for Selection Window

#Region Global Vars for Editor Window
Global $editorWindow = 1, $ewCancel, $ewEditDescription, $ewSave, $ewSetMagicItem, $ewSetSpell
Global $ewSpellCast, $ewSpellComponents, $ewSpellDuration, $ewSpellLevel, $ewSpellRange, $ewSpellRitual, $ewSpellSchool
Global $ewItemAttunement, $ewItemNotes, $ewItemRarity, $ewItemSource, $ewItemType, $ewTitle, $ewFirstName
Global $ewSaveType
#EndRegion Global Vars for Editor Window

#Region Global Description Vars
Global $editDescWindow = 1
Global $workingDescription
Global $descDesc, $descTableLabel, $descDescTitle, $descDiceRoll
Global $descSubitem, $descListview, $descPartType, $descRoll, $descEffect, $descType
Global $descLabel1, $descLabel2, $descLabel3, $descLabel4, $descTable1, $descTable2, $descTable3, $descTable4
Global $descTableUpDown, $descTableCount, $descTableTitle, $descHeading, $descAdd, $descUp, $descDown, $descDelete, $descEdit
Global $descEditCancel, $descEditSave, $descReset, $descPreview
Global $descTitle, $descSave, $descCancel
Global $itemIndex
Global $edWinTitle = "REALLYRANDOMWINDOWNAMESOTHATNOTHINGEVERACTIVESTHISDOTCOM", $active = False
Global $descCurrEditing = False
#EndRegion Global Description Vars


Func _CustomCreator($hParentGUI = "", $hTitle = "", $type = "Default", $hEditTitle = "", $hCurrData = "", $hCurrDescription = "")

	GUISetState(@SW_DISABLE, $hParentGUI) ; Disables Parent GUI if called from one.

	GUIRegisterMsg($WM_NOTIFY, "CUSTOM_WM_NOTIFY")

	If $type = "Default" Then
		CreateFirstWindow()
	Else
		EditorWindow($type, $hEditTitle, $hCurrData, $hCurrDescription)
	EndIf

	OnAutoItExitRegister("SavePrefs")

	While 1
		If (WinActive($edWinTitle) = 0 And $active = True) Then ;; If window does not have window but it just did
			$active = False
			HotKeySet("{ENTER}")
			;ConsoleWrite("SetHotkeysOff")

			ToolTip('')
			$ToolTipActive = False
			;SetGrid
		ElseIf (WinActive($edWinTitle) And $active = False) Then ;;If Window DOES have focus but just didn't
			$active = True
			HotKeySet("{ENTER}", "SaveDummy")
			;;ConsoleWrite("SetHotkeysON")

		EndIf


		$msg = GUIGetMsg(1)

		Switch $msg[1]
			Case $firstWindow
				Switch $msg[0]
					Case $GUI_EVENT_CLOSE
						_Exit($hParentGUI, $hTitle)
						ExitLoop
					Case $fwSetMagicSave
						If $cMagicItemsIni <> "" Then
							$iniSplit = StringSplit($cMagicItemsIni, "\")
							$iniRep = StringReplace($cMagicItemsIni, $iniSplit[$iniSplit[0]], "", -1)
							$pMagicItemIni = FileOpenDialog("Select the Custom Magic Item Ini Location", $iniRep, "Ini Files (*.ini)", 1, $iniSplit[$iniSplit[0]])
						Else
							$pMagicItemsIni = FileOpenDialog("Select the Custom Magic Item Ini Location", @ScriptDir, "Ini Files (*.ini)", 1)
						EndIf
						If FileExists($pMagicItemIni) Then
							$cMagicItemsIni = $pMagicItemIni
						EndIf
					Case $fwSetSpellSave
						If $cSpellIni <> "" Then
							$iniSplit = StringSplit($cSpellIni, "\")
							$iniRep = StringReplace($cSpellIni, $iniSplit[$iniSplit[0]], "", -1)
							$pSpellIni = FileOpenDialog("Select the Custom Spell Ini Location", $iniRep, "Ini Files (*.ini)", 1, $iniSplit[$iniSplit[0]])
						Else
							$pSpellIni = FileOpenDialog("Select the Custom Spell Ini Location", @ScriptDir, "Ini Files (*.ini)", 1)
						EndIf
						If FileExists($pSpellIni) Then
							$cSpellIni = $pSpellIni
						EndIf
					Case $fwCreateSpell
						ConsoleWrite("Create Spell GUI Function Here" & @LF)
						GUIDelete($firstWindow)
						EditorWindow("Spell")

					Case $fwEditSpell
						GUIDelete($firstWindow)
						$sw = SelectionWindow("Spell")
						$ewSaveType = "Spell"
						If $sw = -1 Then CreateFirstWindow()
						;;-- Selection Window here..
						;EditorWindow("Spell", "Example", "Cantrip\\Conjuration\\-\\1 action\\60 feet\\V, S\\Instantaneous")
					Case $fwCreateItem
						GUIDelete($firstWindow)
						EditorWindow("Magic Item")

					Case $fwEditItem
						GUIDelete($firstWindow)
						;;-- Selection Window here..
						$sw = SelectionWindow("Magic Item")
						If $sw = -1 Then CreateFirstWindow()
						;EditorWindow("Magic Item", "Example Item2", "Wondrous Item\\Uncommon\\-\\-\\Homebrew")
						$ewSaveType = "Magic Item"




				EndSwitch
			Case $selWindow
				Switch $msg[0]
					Case $GUI_EVENT_CLOSE
						GUIDelete($selWindow)
						CreateFirstWindow()
					Case $selCancel
						GUIDelete($selWindow)
						CreateFirstWindow()
					Case $selSelect

						$selItem = _GUICtrlListView_GetSelectedIndices($selListview, True)

						If $selItem[0] > 1 Then
							MsgBox(48, "Too Many Items Selected", "Please Select only one item too continue")
						Else
							$selText = _GUICtrlListView_GetItemText($selListview, $selItem[1])
							For $i = 1 To $selData[0][0]
								If $selData[$i][0] = $selText Then ExitLoop
							Next
							GUIDelete($selWindow)
							If $selData[0][1] = "Spell" Then EditorWindow($selData[0][1], $selText, $selData[$i][1], IniReadSection($cSpellIni, $selData[$i][0]))
							If $selData[0][1] = "Magic Item" Then EditorWindow($selData[0][1], $selText, $selData[$i][1], IniReadSection($cMagicItemsIni, $selData[$i][0]))
						EndIf
					Case $selListview
						_GUICtrlListView_SortItems($selListview, GUICtrlGetState($selListview))
					Case $selDelete
						$selItem = _GUICtrlListView_GetSelectedIndices($selListview, True)

						If $selItem[0] > 1 Then
							MsgBox(48, "Too Many Items Selected", "Please Select only one item too continue")
						Else
							$selText = _GUICtrlListView_GetItemText($selListview, $selItem[1])
							For $i = 1 To $selData[0][0]
								If $selData[$i][0] = $selText Then ExitLoop
							Next
							If $selData[0][1] = "Spell" Then
								$iMsg = MsgBox(52, "Delete Item? ", "Are you sure you want to delete: " & $selText & @LF & "At Location: " & $cSpellIni)
								If $iMsg = 6 Then
									IniDelete($cSpellIni, $selText)
									IniDelete($cSpellIni, "Index", $selText)
									_GUICtrlListView_DeleteItemsSelected($selListview)
								EndIf
							ElseIf $selData[0][1] = "Magic Item" Then
								$iMsg = MsgBox(52, "Delete Item? ", "Are you sure you want to delete: " & $selText & @LF & "At Location: " & $cMagicItemsIni)
								If $iMsg = 6 Then
									IniDelete($cMagicItemsIni, $selText)
									IniDelete($cMagicItemsIni, "Index", $selText)
									_GUICtrlListView_DeleteItemsSelected($selListview)
								EndIf
							EndIf
						EndIf
				EndSwitch

			Case $editorWindow
				Switch $msg[0]
					Case $GUI_EVENT_CLOSE
						If $type = "Default" Then
							GUIDelete($editorWindow)
							CreateFirstWindow()
						Else
							_Exit($hParentGUI, $hTitle)
							ExitLoop
						EndIf
					Case $ewSave
						If $ewSaveType = "Spell" Then
							If $cSpellIni = "" Then $cSpellIni = FileOpenDialog("Select the Custom Spell Ini Location", @ScriptDir, "Ini Files (*.ini)")
							$cSpellName = GUICtrlRead($ewTitle)
							$deleteFirst = False
							if $type <> "Default" Then
							if $cSpellName <> $ewFirstName Then $deleteFirst = True
							EndIf

							$iMsg = MsgBox(52, "Save Changes? ", "Are you sure you want to save changes to: " & $cSpellName & @LF & "At Location: " & $cSpellIni)
							If $iMsg = 6 Then
								$overwriteCheck = IniRead($cSpellIni, "Index", $cSpellName, "DoesNotExist")
								If $overwriteCheck = "DoesNotExist" Then
									IniWrite($cSpellIni, "Index", $cSpellName, GUICtrlRead($ewSpellLevel) & "\\" & GUICtrlRead($ewSpellSchool) & "\\" & GUICtrlRead($ewSpellRitual) _
											 & "\\" & GUICtrlRead($ewSpellCast) & "\\" & GUICtrlRead($ewSpellRange) & "\\" & GUICtrlRead($ewSpellComponents) & "\\" & GUICtrlRead($ewSpellDuration))
									If IsArray($workingDescription) Then
										IniWriteSection($cSpellIni, $cSpellName, $workingDescription)
									Else
										IniWriteSection($cSpellIni, $cSpellName, "Description", "")
									EndIf
									if $deleteFirst Then
										IniDelete($cSpellIni, $ewFirstName)
										IniDelete($cSpellIni, "Index",$ewFirstName)
									EndIf
									If $type = "Default" Then
											GUIDelete($editorWindow)
											CreateFirstWindow()
										Else
											_Exit($hParentGUI, $hTitle)
											ExitLoop
										EndIf
								Else
									$aMsg = MsgBox(52, "Overwrite?", "This Spell already exists at this location." & @LF & "Do you wish to overwrite the Original?")
									If $aMsg = 6 Then
										IniWrite($cSpellIni, "Index", $cSpellName, GUICtrlRead($ewSpellLevel) & "\\" & GUICtrlRead($ewSpellSchool) & "\\" & GUICtrlRead($ewSpellRitual) _
												 & "\\" & GUICtrlRead($ewSpellCast) & "\\" & GUICtrlRead($ewSpellRange) & "\\" & GUICtrlRead($ewSpellComponents) & "\\" & GUICtrlRead($ewSpellDuration))
										If IsArray($workingDescription) Then
											IniWriteSection($cSpellIni, $cSpellName, $workingDescription)
										Else
											IniWriteSection($cSpellIni, $cSpellName, "Description", "")
										EndIf
										If $type = "Default" Then
											GUIDelete($editorWindow)
											CreateFirstWindow()
										Else
											_Exit($hParentGUI, $hTitle)
											ExitLoop
										EndIf
									EndIf
								EndIf
							EndIf
						ElseIf $ewSaveType = "Magic Item" Then
							If $cMagicItemsIni = "" Then $cMagicItemsIni = FileOpenDialog("Select the Custom Magic Item Ini Location", @ScriptDir, "Ini Files (*.ini)")
							$cItemName = GUICtrlRead($ewTitle)
							$deleteFirst = False
							if $type <> "Default" Then
							if $cItemName <> $ewFirstName Then $deleteFirst = True
							EndIf
							$iMsg = MsgBox(52, "Save Changes? ", "Are you sure you want to save changes to: " & $cItemName & @LF & "At Location: " & $cMagicItemsIni)
							If $iMsg = 6 Then
								$overwriteCheck = IniRead($cMagicItemsIni, "Index", $cItemName, "DoesNotExist")
								If $overwriteCheck = "DoesNotExist" Then
									IniWrite($cMagicItemsIni, "Index", $cItemName, GUICtrlRead($ewItemType) & "\\" & GUICtrlRead($ewItemRarity) & "\\" & GUICtrlRead($ewItemAttunement) _
											 & "\\" & GUICtrlRead($ewItemNotes) & "\\" & GUICtrlRead($ewItemSource))
									If IsArray($workingDescription) Then
										IniWriteSection($cMagicItemsIni, $cItemName, $workingDescription)
									Else
										IniWrite($cMagicItemsIni, $cItemName, "Description", "")
									EndIf
									if $deleteFirst Then
										IniDelete($cMagicItemsIni, $ewFirstName)
										IniDelete($cMagicItemsIni, "Index",$ewFirstName)
									EndIf
									If $type = "Default" Then
											GUIDelete($editorWindow)
											CreateFirstWindow()
										Else
											_Exit($hParentGUI, $hTitle)
											ExitLoop
										EndIf
								Else
									$aMsg = MsgBox(52, "Overwrite?", "This Magic Item already exists at this location." & @LF & "Do you wish to overwrite the Original?")
									If $aMsg = 6 Then
										IniWrite($cMagicItemsIni, "Index", $cItemName, GUICtrlRead($ewItemType) & "\\" & GUICtrlRead($ewItemRarity) & "\\" & GUICtrlRead($ewItemAttunement) _
												 & "\\" & GUICtrlRead($ewItemNotes) & "\\" & GUICtrlRead($ewItemSource))
										If IsArray($workingDescription) Then
											IniWriteSection($cMagicItemsIni, $cItemName, $workingDescription)
										Else
											IniWrite($cMagicItemsIni, $cItemName, "Description", "")
										EndIf
										If $type = "Default" Then
											GUIDelete($editorWindow)
											CreateFirstWindow()
										Else
											_Exit($hParentGUI, $hTitle)
											ExitLoop
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf



						;; No need to Delete already existing Spells for the Data dump (Probably easier to do so with description though..)
					Case $ewCancel
						If $type = "Default" Then
							GUIDelete($editorWindow)
							CreateFirstWindow()
						Else
							_Exit($hParentGUI, $hTitle)
							ExitLoop
						EndIf
					Case $ewEditDescription
						;; do an INI read of the example item here for testing
						; Then Create the Listview & the up Down\ Add buttons..
						; Preview pane?
						GUISetState(@SW_DISABLE, $editorWindow)
						If IsArray($workingDescription) Then
							EditDescription(GUICtrlRead($ewTitle), $workingDescription)
						Else
							EditDescription(GUICtrlRead($ewTitle))
						EndIf
					Case $ewSetMagicItem
						If $cMagicItemsIni <> "" Then
							$iniSplit = StringSplit($cMagicItemsIni, "\")
							$iniRep = StringReplace($cMagicItemsIni, $iniSplit[$iniSplit[0]], "", -1)
							$pMagicItemIni = FileOpenDialog("Select the Custom Magic Item Ini Location", $iniRep, "Ini Files (*.ini)", 1, $iniSplit[$iniSplit[0]])
						Else
							$pMagicItemsIni = FileOpenDialog("Select the Custom Magic Item Ini Location", @ScriptDir, "Ini Files (*.ini)", 1)
						EndIf
						If FileExists($pMagicItemIni) Then
							$cMagicItemsIni = $pMagicItemIni
						EndIf
					Case $ewSetSpell
						If $cSpellIni <> "" Then
							$iniSplit = StringSplit($cSpellIni, "\")
							$iniRep = StringReplace($cSpellIni, $iniSplit[$iniSplit[0]], "", -1)
							$pMagicItemIni = FileOpenDialog("Select the Custom Magic Item Ini Location", $iniRep, "Ini Files (*.ini)", 1, $iniSplit[$iniSplit[0]])
						Else
							$pSpellIni = FileOpenDialog("Select the Custom Spell Ini Location", @ScriptDir, "Ini Files (*.ini)", 1)
						EndIf
						If FileExists($pSpellIni) Then
							$cSpellIni = $pSpellIni
						EndIf
				EndSwitch

			Case $editDescWindow
				Switch $msg[0]
					Case $GUI_EVENT_CLOSE
						GUISetState(@SW_ENABLE, $editorWindow)
						GUIDelete($editDescWindow)
						HotKeySet("{ENTER}")
					Case $descCancel
						GUISetState(@SW_ENABLE, $editorWindow)
						GUIDelete($editDescWindow)
						HotKeySet("{ENTER}")
					Case $descSave ;; DO REALLY COOL STUFF HERE MMK
						Local $lItems = _GUICtrlListView_GetItemCount($descListview)

						Local $lArray[$lItems + 1][2]

						$lArray[0][0] = $lItems

						For $i = 1 To $lItems
							$lArray[$i][0] = _GUICtrlListView_GetItemText($descListview, $i - 1)
							$lArray[$i][1] = _GUICtrlListView_GetItemText($descListview, $i - 1, 1)
						Next

						$workingDescription = $lArray

						GUISetState(@SW_ENABLE, $editorWindow)
						GUIDelete($editDescWindow)
						HotKeySet("{ENTER}")
					Case $descPartType
						DescGUISwitch(GUICtrlRead($descPartType))
						;ConsoleWrite(@LF)
					Case $descTableUpDown
						$cols = GUICtrlRead($descTableCount)
						Switch $cols
							Case 1
								GUICtrlSetState($descTable2, $GUI_HIDE)
								GUICtrlSetState($descLabel2, $GUI_HIDE)
							Case 2
								GUICtrlSetState($descTable2, $GUI_SHOW)
								GUICtrlSetState($descTable3, $GUI_HIDE)
								GUICtrlSetState($descLabel2, $GUI_SHOW)
								GUICtrlSetState($descLabel3, $GUI_HIDE)

							Case 3
								GUICtrlSetState($descLabel3, $GUI_SHOW)
								GUICtrlSetState($descTable3, $GUI_SHOW)
								GUICtrlSetState($descTable4, $GUI_HIDE)
								GUICtrlSetState($descLabel4, $GUI_HIDE)
							Case 4
								GUICtrlSetState($descTable4, $GUI_SHOW)
								GUICtrlSetState($descLabel4, $GUI_SHOW)
						EndSwitch
					Case $descAdd
						AddtoDescription(GUICtrlRead($descPartType))
						PreviewUpdate()
					Case $descUp
						_GUICtrlListView_MoveItems($descListview, -1)
						PreviewUpdate()
					Case $descDown
						_GUICtrlListView_MoveItems($descListview, 1)
						PreviewUpdate()
					Case $descDelete
						_GUICtrlListView_DeleteItemsSelected($descListview)
						PreviewUpdate()
					Case $descEdit
						$descCurrEditing = True
						If _GUICtrlListView_GetSelectedCount($descListview) > 1 Then
							MsgBox(48, "Too many Items selected", "Too many items selected for editing" & @LF & "Please select one item and try again")
						ElseIf _GUICtrlListView_GetSelectedCount($descListview) = 0 Then

						Else
							$itemIndex = _GUICtrlListView_GetSelectedIndices($descListview, True)

							$itemType = _GUICtrlListView_GetItemText($descListview, $itemIndex[1], 0)
							$itemText = _GUICtrlListView_GetItemText($descListview, $itemIndex[1], 1)


							For $i = 0 To 9

								$itemType = StringReplace($itemType, String($i), "")
							Next


							GUICtrlSetData($descPartType, $itemType) ;; Sets the Combo Box to the correc item Type
							;Need to tidy up this bit so that it will pass data through too the correct GUI item
							$descReset = DescGUISwitch($itemType, $itemText)

							GUICtrlSetState($descUp, $GUI_DISABLE)
							GUICtrlSetState($descDown, $GUI_DISABLE)
							GUICtrlSetState($descEdit, $GUI_DISABLE)
							GUICtrlSetState($descDelete, $GUI_DISABLE)
							GUICtrlSetState($descListview, $GUI_DISABLE)


						EndIf
					Case $descEditSave
						$descCurrEditing = False
						GUICtrlSetState($descAdd, $GUI_SHOW)
						GUICtrlSetState($descEditCancel, $GUI_HIDE)
						GUICtrlSetState($descEditSave, $GUI_HIDE)

						GUICtrlSetState($descUp, $GUI_ENABLE)
						GUICtrlSetState($descDown, $GUI_ENABLE)
						GUICtrlSetState($descEdit, $GUI_ENABLE)
						GUICtrlSetState($descDelete, $GUI_ENABLE)
						GUICtrlSetState($descListview, $GUI_ENABLE)

						$editData = AddtoDescription(GUICtrlRead($descPartType), True)

						_GUICtrlListView_SetItemText($descListview, $itemIndex[1], $editData, 1)

						For $i = 0 To UBound($descReset) - 1
							GUICtrlSetData($descReset[$i], "")
						Next

						PreviewUpdate()
					Case $descEditCancel
						$descCurrEditing = False
						GUICtrlSetState($descAdd, $GUI_SHOW)
						GUICtrlSetState($descEditCancel, $GUI_HIDE)
						GUICtrlSetState($descEditSave, $GUI_HIDE)

						GUICtrlSetState($descUp, $GUI_ENABLE)
						GUICtrlSetState($descDown, $GUI_ENABLE)
						GUICtrlSetState($descEdit, $GUI_ENABLE)
						GUICtrlSetState($descDelete, $GUI_ENABLE)
						GUICtrlSetState($descListview, $GUI_ENABLE)
						For $i = 0 To UBound($descReset) - 1
							GUICtrlSetData($descReset[$i], "")
						Next
				EndSwitch

		EndSwitch

		Sleep(10)

	WEnd

EndFunc   ;==>_CustomCreator

Func _Exit($eParent, $eTitle)
	GUIDelete($firstWindow)
	GUIDelete($editDescWindow)
	GUIDelete($editorWindow)
	GUIDelete($selWindow)
	GUISetState(@SW_ENABLE, $eParent)
	If $eTitle <> "" Then
		WinActivate($eTitle)
	EndIf
EndFunc   ;==>_Exit

Func SavePrefs()
	IniWrite($prefIni, "Settings", "Custom Spells File", $cSpellIni)
	IniWrite($prefIni, "Settings", "Custom Magic Items File", $cMagicItemsIni)
EndFunc   ;==>SavePrefs

Func SaveDummy()
	If $descCurrEditing Then

		$descCurrEditing = False
		GUICtrlSetState($descAdd, $GUI_SHOW)
		GUICtrlSetState($descEditCancel, $GUI_HIDE)
		GUICtrlSetState($descEditSave, $GUI_HIDE)

		GUICtrlSetState($descUp, $GUI_ENABLE)
		GUICtrlSetState($descDown, $GUI_ENABLE)
		GUICtrlSetState($descEdit, $GUI_ENABLE)
		GUICtrlSetState($descDelete, $GUI_ENABLE)
		GUICtrlSetState($descListview, $GUI_ENABLE)

		$editData = AddtoDescription(GUICtrlRead($descPartType), True)

		_GUICtrlListView_SetItemText($descListview, $itemIndex[1], $editData, 1)

		For $i = 0 To UBound($descReset) - 1
			GUICtrlSetData($descReset[$i], "")
		Next

		PreviewUpdate()

	Else
		AddtoDescription(GUICtrlRead($descPartType))
		PreviewUpdate()
	EndIf

EndFunc   ;==>SaveDummy

Func CreateFirstWindow()
	$firstWindow = GUICreate("Select an item to Edit or Create", 370, 240)

	GUISetFont(14)
	$fwCreateSpell = GUICtrlCreateButton("Create new Custom Spell", 50, 10, 270, -1, $BS_CENTER)
	$fwEditSpell = GUICtrlCreateButton("Edit existing Spell", 50, 50, 270, -1, $BS_CENTER)
	$fwCreateItem = GUICtrlCreateButton("Create new Custom Magic Item", 50, 110, 270, -1, $BS_CENTER)
	$fwEditItem = GUICtrlCreateButton("Edit existing Magic Item", 50, 150, 270, -1, $BS_CENTER)

	GUISetFont(10)
	$fwSetMagicSave = GUICtrlCreateButton("Magic Item Ini Location", 10, 200, 160, -1, $BS_CENTER)
	$fwSetSpellSave = GUICtrlCreateButton("Spell Item Ini Location", 200, 200, 160, -1, $BS_CENTER)

	GUISetState()
EndFunc   ;==>CreateFirstWindow

Func SelectionWindow($sType)
	$selWindow = GUICreate("Select your custom " & $sType & " to edit", 450, 200) ;; MAKE BIGGER

	GUISetFont(14)
	GUICtrlCreateLabel("Select your custom " & $sType, 5, 5)
	GUISetFont(8.5)

	$selListview = GUICtrlCreateListView("", 10, 30, 430, 135, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT), $LVS_EX_FULLROWSELECT)

	GUISetFont(10)
	$selCancel = GUICtrlCreateButton("Cancel", 15, 170, 80, -1, $BS_CENTER)
	$selDelete = GUICtrlCreateButton("Delete", 190, 170, 80, -1, $BS_CENTER)
	$selSelect = GUICtrlCreateButton("Select", 355, 170, 80, -1, $BS_CENTER)
	GUISetFont(8.5)

	If $sType = "Spell" Then
		If $cSpellIni = "" Then $cSpellIni = FileOpenDialog("Select the Custom Spell Ini Location", @ScriptDir, "Ini Files (*.ini)", 1)
		If $cSpellIni = "" Then Return -1
		$selData = IniReadSection($cSpellIni, "Index")

		_GUICtrlListView_AddColumn($selListview, "Name", 110)
		_GUICtrlListView_AddColumn($selListview, "Level", 70)
		_GUICtrlListView_AddColumn($selListview, "School", 90)
		_GUICtrlListView_AddColumn($selListview, "Ritual")
		_GUICtrlListView_AddColumn($selListview, "Cast Time")
		_GUICtrlListView_AddColumn($selListview, "Range")
		_GUICtrlListView_AddColumn($selListview, "Components")
		_GUICtrlListView_AddColumn($selListview, "Duration")

		For $i = 1 To $selData[0][0]
			$selIndex = _GUICtrlListView_AddItem($selListview, $selData[$i][0])
			$selSplit = StringSplit($selData[$i][1], "\\", 1)
			If $selSplit[0] <> 7 Then
				$cSpellIni = ""
				MsgBox(48, "Wrong Data format", "Incorrect Data format in this Ini, Please try again")
				GUIDelete($selWindow)
				Return SelectionWindow($sType)
			EndIf
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[1], 1)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[2], 2)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[3], 3)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[4], 4)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[5], 5)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[6], 6)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[7], 7)
		Next
	ElseIf $sType = "Magic Item" Then
		If $cMagicItemsIni = "" Then $cMagicItemsIni = FileOpenDialog("Select the Custom Magic Item Ini Location", @ScriptDir, "Ini Files (*.ini)", 1)
		If $cMagicItemsIni = "" Then Return -1
		$selData = IniReadSection($cMagicItemsIni, "Index")
		_GUICtrlListView_AddColumn($selListview, "Name", 110)
		_GUICtrlListView_AddColumn($selListview, "Type", 90)
		_GUICtrlListView_AddColumn($selListview, "Rarity", 90)
		_GUICtrlListView_AddColumn($selListview, "Attunement")
		_GUICtrlListView_AddColumn($selListview, "Notes")
		_GUICtrlListView_AddColumn($selListview, "Source")

		For $i = 1 To $selData[0][0]
			$selIndex = _GUICtrlListView_AddItem($selListview, $selData[$i][0])
			$selSplit = StringSplit($selData[$i][1], "\\", 1)
			If $selSplit[0] <> 5 Then
				$cMagicItemsIni = ""
				MsgBox(48, "Wrong Data format", "Incorrect Data format in this Ini, Please try again")
				GUIDelete($selWindow)
				Return SelectionWindow($sType)
			EndIf
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[1], 1)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[2], 2)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[3], 3)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[4], 4)
			_GUICtrlListView_AddSubItem($selListview, $selIndex, $selSplit[5], 5)
		Next


	EndIf
	$selData[0][1] = $sType



	GUISetState()

	_GUICtrlListView_RegisterSortCallBack($selListview)
EndFunc   ;==>SelectionWindow

Func EditorWindow($iType, $currTitle = "", $currData = "", $currDescription = "")
	$workingDescription = $currDescription
	$ewSaveType = $iType

	Local $Create
	If $currTitle = "" Then
		$Create = True
		$editorWindow = GUICreate("Create " & $iType, 350, 350)
		$ewFirstName = $currTitle
	Else
		$Create = False
		$editorWindow = GUICreate("Edit " & $iType, 350, 350)
		$ewFirstName = $currTitle
	EndIf
	GUISetFont(12)
	GUICtrlCreateLabel($iType & " Name: ", 20, 20, 130, -1, $SS_RIGHT)

	$ewTitle = GUICtrlCreateInput($currTitle, 150, 17)

	GUISetFont(10)
	Switch $iType
		Case "Magic Item"
			GUICtrlCreateLabel("Type: ", 20, 70, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Rarity: ", 20, 100, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Attunement: ", 20, 130, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Notes: ", 20, 160, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Source: ", 20, 190, 130, -1, $SS_RIGHT)

			$ewItemType = GUICtrlCreateCombo("", 150, 67)
			$ewItemRarity = GUICtrlCreateCombo('', 150, 97, -1, -1, $CBS_DROPDOWNLIST)
			$ewItemAttunement = GUICtrlCreateCombo("", 150, 127, -1, -1, $CBS_DROPDOWNLIST)
			$ewItemNotes = GUICtrlCreateInput("", 150, 157)
			$ewItemSource = GUICtrlCreateInput("", 150, 187)

			$attunements = "Yes|-"
			$raritys = "Common|Uncommon|Rare|Very Rare|Legendary"
			$types = "Armor|Potion|Ring|Rod|Scroll|Staff|Wand|Weapon|Wondrous Item"

			If $Create Then
				GUICtrlSetData($ewItemAttunement, $attunements, "-")
				GUICtrlSetData($ewItemRarity, $raritys, "Common")
				GUICtrlSetData($ewItemType, $types, "Wondrous Item")
				GUICtrlSetData($ewItemSource, "Homebrew")
			Else
				$dataSplit = StringSplit($currData, "\\", 1)
				If $dataSplit[0] = 5 Then
					GUICtrlSetData($ewItemType, $types )
					ControlSetText($editorWindow,"",$ewItemType, $dataSplit[1])
					GUICtrlSetData($ewItemRarity, $raritys, $dataSplit[2])
					GUICtrlSetData($ewItemAttunement, $attunements, $dataSplit[3])
					GUICtrlSetData($ewItemNotes, $dataSplit[4])
					GUICtrlSetData($ewItemSource, $dataSplit[5])
				Else
					MsgBox(48, "Corrupt Data", "Data format is incorrect and the program is unable to read it" & @LF & "Sorry :(")
					GUICtrlSetData($ewItemAttunement, $attunements, "-")
					GUICtrlSetData($ewItemRarity, $raritys, "Common")
					GUICtrlSetData($ewItemType, $types, "Wondrous Item")
					GUICtrlSetData($ewItemSource, "Homebrew")
				EndIf
			EndIf
		Case "Spell"
			GUICtrlCreateLabel("Level: ", 20, 60, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("School: ", 20, 90, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Ritual: ", 20, 120, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Cast Time: ", 20, 150, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Range: ", 20, 180, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Components: ", 20, 210, 130, -1, $SS_RIGHT)
			GUICtrlCreateLabel("Duration: ", 20, 240, 130, -1, $SS_RIGHT)

			$ewSpellLevel = GUICtrlCreateCombo("", 150, 57, -1, -1, $CBS_DROPDOWNLIST)
			$ewSpellSchool = GUICtrlCreateCombo("", 150, 87, -1, -1, $CBS_DROPDOWNLIST)
			$ewSpellRitual = GUICtrlCreateCombo("", 150, 117, -1, -1, $CBS_DROPDOWNLIST)
			$ewSpellCast = GUICtrlCreateCombo("", 150, 147)
			$ewSpellRange = GUICtrlCreateCombo("", 150, 177)
			$ewSpellComponents = GUICtrlCreateCombo("", 150, 207)
			$ewSpellDuration = GUICtrlCreateCombo("", 150, 237)


			$Schools = "Abjuration|Conjuration|Divination|Enchantment|Evocation|Illusion|Necromancy|Transmutation"
			$Levels = "Cantrip|1st|2nd|3rd|4th|5th|6th|7th|8th|9th"
			$Rituals = "Yes|-"
			$castTimes = "1 minute|10 minutes|1 hour|8 hours|12 hours|24 hours|1 action|1 bonus action|1 reaction"
			$ranges = "5 feet|10 feet|30 feet|60 feet|90 feet|100 feet|120 feet|150 feet|300 feet|500 feet|1 mile|500 miles|Unlimited|Self|Self (radius)|Self (radius sphere)|Self (radius hemisphere)|Self (cone)|Self (line)|Sight|Touch|Special"
			$Components = "V|S|V, S|S, M|V, M|V, S, M"
			$Durations = "Instantaneous|Up to 1 minute|1 minute|10 minutes|Up to 1 hour|1 hour|Up to 8 hours|8 hours|24 hours/1 day|7 days|10 days|30 days|Concentration|Until dispelled or triggered|Until dispelled|1 round|Special"


			If $Create Then
				GUICtrlSetData($ewSpellLevel, $Levels, "Cantrip")
				GUICtrlSetData($ewSpellSchool, $Schools, "Abjuration")
				GUICtrlSetData($ewSpellRitual, $Rituals, "-")
				GUICtrlSetData($ewSpellCast, $castTimes, "1 Action")
				GUICtrlSetData($ewSpellRange, $Ranges, "Touch")
				GUICtrlSetData($ewSpellComponents, $Components, "V")
				GUICtrlSetData($ewSpellDuration, $Durations, "Instantaneous")
			Else
				$dataSplit = StringSplit($currData, "\\", 1)
				If $dataSplit[0] = 7 Then
					GUICtrlSetData($ewSpellLevel, $Levels, $dataSplit[1])
					GUICtrlSetData($ewSpellSchool, $Schools, $dataSplit[2])
					GUICtrlSetData($ewSpellRitual, $Rituals, $dataSplit[3])
					GUICtrlSetData($ewSpellCast, $castTimes)
					ControlSetText($editorWindow,"",$ewSpellCast, $dataSplit[4])
					GUICtrlSetData($ewSpellRange, $Ranges)
					ControlSetText($editorWindow,"",$ewSpellRange, $dataSplit[5])
					GUICtrlSetData($ewSpellComponents, $Components)
					ControlSetText($editorWindow,"",$ewSpellComponents, $dataSplit[6])
					GUICtrlSetData($ewSpellDuration, $Durations)
					ControlSetText($editorWindow,"",$ewSpellDuration, $dataSplit[7])
				Else
					MsgBox(48, "Corrupt Data", "Data format is incorrect and the program is unable to read it" & @LF & "Sorry :(")
					GUICtrlSetData($ewSpellLevel, $Levels, "Cantrip")
					GUICtrlSetData($ewSpellSchool, $Schools, "Abjuration")
					GUICtrlSetData($ewSpellRitual, $Rituals, "-")
					GUICtrlSetData($ewSpellCast, $castTimes, "1 Action")
					GUICtrlSetData($ewSpellRange, $Ranges, "Touch")
					GUICtrlSetData($ewSpellComponents, $Components, "V")
					GUICtrlSetData($ewSpellDuration, $Durations, "Instantaneous")
				EndIf
			EndIf

	EndSwitch



	GUISetFont(12)
	$ewEditDescription = GUICtrlCreateButton("Edit Description", 115, 270, 125, -1, $BS_CENTER)

	GUISetFont(9)
	$ewSetMagicItem = GUICtrlCreateButton("Set Magic Item Ini", 130, 305, 105, 20, $BS_CENTER)
	$ewSetSpell = GUICtrlCreateButton("Set Spell Ini", 130, 325, 105, 20, $BS_CENTER)

	GUISetFont(14)
	$ewCancel = GUICtrlCreateButton("Cancel", 15, 310, 70, -1, $BS_CENTER)
	$ewSave = GUICtrlCreateButton("Save", 265, 310, 70, -1, $BS_CENTER)

	GUISetState(@SW_SHOW, $editorWindow)
EndFunc   ;==>EditorWindow

Func EditDescription($iTitle = "", $iDescription = "")
	$descTitle = $iTitle

	$edWinTitle = "Edit " & $iTitle & " Description"

	$editDescWindow = GUICreate($edWinTitle, 500, 420);420 JST BLZ FGT( was 370,380)

	#Region Left Hand Side GUI

	Local $iStylesEx = ($LVS_EX_FULLROWSELECT)
	$descListview = GUICtrlCreateListView("", 10, 180, 220, 200, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT))
	_GUICtrlListView_SetExtendedListViewStyle($descListview, $iStylesEx)

	_GUICtrlListView_AddColumn($descListview, "Part Name", 70)
	_GUICtrlListView_AddColumn($descListview, "Part", 85)

	GUISetFont(14)
	GUICtrlCreateLabel("Add new Part", 5, 5, 220, -1)

	GUISetFont(8.5)
	GUICtrlCreateLabel("Part Type:", 10, 30)

	$descPartType = GUICtrlCreateCombo("", 10, 45, 220, -1, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "Description|DescriptionTitle|Heading|EndHeading|Subitem|TableTitle|TableColumns|TableRow|Type|DiceRoll|Roll|Effect", "Description")

	$descDesc = GUICtrlCreateInput("", 10, 70, 220, 80, BitOR($ES_MULTILINE, $WS_VSCROLL))
	;GUICtrlsetstate(-1,$GUI_HIDE)

	$descDescTitle = GUICtrlCreateInput("", 10, 70, 220, 22)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descType = GUICtrlCreateInput("", 10, 70, 220, 22)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descHeading = GUICtrlCreateInput("", 10, 70, 220)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descSubitem = GUICtrlCreateInput("", 10, 70, 220, 80, BitOR($ES_MULTILINE, $WS_VSCROLL))
	GUICtrlSetState(-1, $GUI_HIDE)

	$descTableTitle = GUICtrlCreateInput("", 10, 70, 220, 22)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descTableLabel = GUICtrlCreateLabel("Table Columns", 10, 72)
	GUICtrlSetState(-1, $GUI_HIDE)
	$descTableCount = GUICtrlCreateInput(1, 90, 70, 110, 22, $ES_READONLY)
	GUICtrlSetState(-1, $GUI_HIDE)
	$descTableUpDown = GUICtrlCreateUpdown(-1)
	GUICtrlSetLimit(-1, 4, 1)
	GUICtrlSetState(-1, $GUI_HIDE)

	#Region Table Columns Gui

	$descLabel1 = GUICtrlCreateLabel("1:", 10, 97)
	GUICtrlSetState(-1, $GUI_HIDE)
	$descTable1 = GUICtrlCreateInput("", 20, 95, 90)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descLabel2 = GUICtrlCreateLabel("2:", 120, 97)
	GUICtrlSetState(-1, $GUI_HIDE)
	$descTable2 = GUICtrlCreateInput("", 130, 95, 90)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descLabel3 = GUICtrlCreateLabel("3:", 10, 127)
	GUICtrlSetState(-1, $GUI_HIDE)
	$descTable3 = GUICtrlCreateInput("", 20, 125, 90)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descLabel4 = GUICtrlCreateLabel("4:", 120, 127)
	GUICtrlSetState(-1, $GUI_HIDE)
	$descTable4 = GUICtrlCreateInput("", 130, 125, 90)
	GUICtrlSetState(-1, $GUI_HIDE)
	#EndRegion Table Columns Gui

	$descDiceRoll = GUICtrlCreateInput("", 10, 70, 220)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descRoll = GUICtrlCreateInput("", 10, 70, 220)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descEffect = GUICtrlCreateInput("", 10, 70, 220, 80, BitOR($ES_MULTILINE, $WS_VSCROLL))
	GUICtrlSetState(-1, $GUI_HIDE)

	$descEditCancel = GUICtrlCreateButton("Cancel", 10, 152, 70, -1, $BS_CENTER)
	GUICtrlSetState(-1, $GUI_HIDE)

	$descEditSave = GUICtrlCreateButton("Save", 155, 152, 70, -1, $BS_CENTER)
	GUICtrlSetState(-1, $GUI_HIDE)
	#EndRegion Left Hand Side GUI

	#Region Buttons

	GUISetFont(9.5)
	$descAdd = GUICtrlCreateButton("Add to Description", 10, 152, 220, -1, $BS_CENTER)



	$descUp = GUICtrlCreateIcon($iconsIcl, 5, 230, 210)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Move Selected Item Up")
	$descDown = GUICtrlCreateIcon($iconsIcl, 7, 230, 250)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Move Selected Item Down")
	$descEdit = GUICtrlCreateIcon($iconsIcl, 10, 230, 305)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Edit Selected Item")
	$descDelete = GUICtrlCreateIcon($iconsIcl, 9, 230, 340)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Delete Selected Item")

	GUISetFont(14)
	$descCancel = GUICtrlCreateButton("Cancel", 15, 385, 70, -1, $BS_CENTER)
	$descSave = GUICtrlCreateButton("Save", 395, 385, 70, -1, $BS_CENTER)

	#EndRegion Buttons

	#Region Preview Pane

	GUISetFont(14)
	GUICtrlCreateLabel("Preview Pane", 260, 5, 220, -1)

	GUISetFont(8.5)

	$descPreview = GUICtrlCreateInput("", 265, 30, 225, 350, BitOR($ES_MULTILINE, $WS_VSCROLL, $WS_HSCROLL, $ES_WANTRETURN))
	GUICtrlSetFont(-1, 9, 400, -1, "Consolas")
	_GUICtrlEdit_SetReadOnly(-1, True)
	#EndRegion Preview Pane

	#Region Put Current Description (if editing an existing Item\Spell) into Listivew & Preview Pane
	If IsArray($workingDescription) Then
		For $i = 1 To $workingDescription[0][0]
			$descIndex = _GUICtrlListView_AddItem($descListview, $workingDescription[$i][0])
			_GUICtrlListView_AddSubItem($descListview, $descIndex, $workingDescription[$i][1], 1)
		Next
		PreviewUpdate()
	EndIf
	#EndRegion Put Current Description (if editing an existing Item\Spell) into Listivew & Preview Pane

	GUISetState()


EndFunc   ;==>EditDescription

Func DescGUISwitch($partType, $pData = -1000000)
	Local $retArray[100], $retAmount = 1
	;"Description|DescriptionTitle|Heading|EndHeading|Subitem|TableTitle|TableColumns|TableRow|DiceRoll|Roll|Effect"
	GUICtrlSetState($descDesc, $GUI_HIDE)
	GUICtrlSetState($descDescTitle, $GUI_HIDE)
	GUICtrlSetState($descDiceRoll, $GUI_HIDE)
	GUICtrlSetState($descEffect, $GUI_HIDE)
	GUICtrlSetState($descHeading, $GUI_HIDE)
	GUICtrlSetState($descLabel1, $GUI_HIDE)
	GUICtrlSetState($descLabel2, $GUI_HIDE)
	GUICtrlSetState($descLabel3, $GUI_HIDE)
	GUICtrlSetState($descLabel4, $GUI_HIDE)
	GUICtrlSetState($descRoll, $GUI_HIDE)
	GUICtrlSetState($descSubitem, $GUI_HIDE)
	GUICtrlSetState($descTableTitle, $GUI_HIDE)
	GUICtrlSetState($descType, $GUI_HIDE)
	GUICtrlSetState($descTable1, $GUI_HIDE)
	GUICtrlSetState($descTable2, $GUI_HIDE)
	GUICtrlSetState($descTable3, $GUI_HIDE)
	GUICtrlSetState($descTable4, $GUI_HIDE)
	GUICtrlSetState($descTableLabel, $GUI_HIDE)
	GUICtrlSetState($descTableCount, $GUI_HIDE)
	GUICtrlSetState($descTableUpDown, $GUI_HIDE)
	If $pData <> -1000000 Then
		GUICtrlSetState($descAdd, $GUI_HIDE)
		GUICtrlSetState($descEditCancel, $GUI_SHOW)
		GUICtrlSetState($descEditSave, $GUI_SHOW)
	EndIf

	Switch $partType
		Case "Description"
			GUICtrlSetState($descDesc, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descDesc, $pData)
			$retArray[0] = $descDesc
		Case "DescriptionTitle"
			GUICtrlSetState($descDescTitle, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descDescTitle, $pData)
			$retArray[0] = $descDescTitle
		Case "Heading"
			GUICtrlSetState($descHeading, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descHeading, $pData)
			$retArray[0] = $descHeading
		Case "EndHeading"
		Case "Subitem"
			GUICtrlSetState($descSubitem, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descSubitem, $pData)
			$retArray[0] = $descSubitem
		Case "Type"
			GUICtrlSetState($descType, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descType, $pData)
			$retArray[0] = $descType
		Case "TableTitle"
			GUICtrlSetState($descTableTitle, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descTableTitle, $pData)
			$retArray[0] = $descTableTitle
		Case "TableColumns"
			If $pData <> -1000000 Then $split = StringSplit($pData, "\\", 1)
			If $pData <> -1000000 Then GUICtrlSetData($descTableCount, $split[0])
			$cols = GUICtrlRead($descTableCount)
			GUICtrlSetState($descLabel1, $GUI_SHOW)
			If $cols >= 2 Then GUICtrlSetState($descLabel2, $GUI_SHOW)
			If $cols >= 3 Then GUICtrlSetState($descLabel3, $GUI_SHOW)
			If $cols >= 4 Then GUICtrlSetState($descLabel4, $GUI_SHOW)
			GUICtrlSetState($descTable1, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descTable1, $split[1])
			If $cols >= 2 Then
				GUICtrlSetState($descTable2, $GUI_SHOW)
				If $pData <> -1000000 Then GUICtrlSetData($descTable2, $split[2])
			EndIf
			If $cols >= 3 Then
				GUICtrlSetState($descTable3, $GUI_SHOW)
				If $pData <> -1000000 Then GUICtrlSetData($descTable2, $split[3])
			EndIf
			If $cols >= 4 Then
				GUICtrlSetState($descTable4, $GUI_SHOW)
				If $pData <> -1000000 Then GUICtrlSetData($descTable2, $split[4])
			EndIf
			GUICtrlSetState($descTableCount, $GUI_SHOW)
			GUICtrlSetState($descTableLabel, $GUI_SHOW)
			GUICtrlSetState($descTableCount, $GUI_SHOW)
			GUICtrlSetState($descTableUpDown, $GUI_SHOW)
			$retArray[0] = $descTable1
			$retArray[1] = $descTable2
			$retArray[2] = $descTable3
			$retArray[3] = $descTable4
			$retAmount = 4
		Case "TableRow"
			If $pData <> -1000000 Then $split = StringSplit($pData, "\\", 1)
			If $pData <> -1000000 Then GUICtrlSetData($descTableCount, $split[0])
			$cols = GUICtrlRead($descTableCount)
			GUICtrlSetState($descLabel1, $GUI_SHOW)
			If $cols >= 2 Then GUICtrlSetState($descLabel2, $GUI_SHOW)
			If $cols >= 3 Then GUICtrlSetState($descLabel3, $GUI_SHOW)
			If $cols >= 4 Then GUICtrlSetState($descLabel4, $GUI_SHOW)
			GUICtrlSetState($descTable1, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descTable1, $split[1])
			If $cols >= 2 Then
				GUICtrlSetState($descTable2, $GUI_SHOW)
				If $pData <> -1000000 Then GUICtrlSetData($descTable2, $split[2])
			EndIf
			If $cols >= 3 Then
				GUICtrlSetState($descTable3, $GUI_SHOW)
				If $pData <> -1000000 Then GUICtrlSetData($descTable2, $split[3])
			EndIf
			If $cols >= 4 Then
				GUICtrlSetState($descTable4, $GUI_SHOW)
				If $pData <> -1000000 Then GUICtrlSetData($descTable2, $split[4])
			EndIf
			GUICtrlSetState($descTableCount, $GUI_SHOW)
			GUICtrlSetState($descTableLabel, $GUI_SHOW)
			GUICtrlSetState($descTableCount, $GUI_SHOW)
			GUICtrlSetState($descTableUpDown, $GUI_SHOW)
			$retArray[0] = $descTable1
			$retArray[1] = $descTable2
			$retArray[2] = $descTable3
			$retArray[3] = $descTable4
			$retAmount = 4
		Case "DiceRoll"
			GUICtrlSetState($descDiceRoll, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descDiceRoll, $pData)
			$retArray[0] = $descDiceRoll
		Case "Roll"
			GUICtrlSetState($descRoll, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descRoll, $pData)
			$retArray[0] = $descRoll
		Case "Effect"
			GUICtrlSetState($descEffect, $GUI_SHOW)
			If $pData <> -1000000 Then GUICtrlSetData($descEffect, $pData)
			$retArray[0] = $descEffect
	EndSwitch

	ReDim $retArray[$retAmount]
	Return $retArray
EndFunc   ;==>DescGUISwitch

Func AddtoDescription($partType, $editSave = False)
	Local $iData
	Switch $partType
		Case "Description"
			$iData = GUICtrlRead($descDesc)
			GUICtrlSetData($descDesc, "")
		Case "DescriptionTitle"
			$iData = GUICtrlRead($descDescTitle)
			GUICtrlSetData($descDescTitle, "")
		Case "Heading"
			$iData = GUICtrlRead($descHeading)
			GUICtrlSetData($descHeading, "")
		Case "EndHeading"
		Case "Type"
			$iData = GUICtrlRead($descType)
			GUICtrlSetData($descType, "")
		Case "Subitem"
			$iData = GUICtrlRead($descSubitem)
			GUICtrlSetData($descSubitem, "")
		Case "TableTitle"
			$iData = GUICtrlRead($descTableTitle)
			GUICtrlSetData($descTableTitle, "")
		Case "TableColumns"
			$cols = GUICtrlRead($descTableCount)
			$iData = GUICtrlRead($descTable1)
			GUICtrlSetData($descTable1, "")
			If $cols >= 2 Then $iData &= "\\" & GUICtrlRead($descTable2)
			GUICtrlSetData($descTable2, "")
			If $cols >= 3 Then $iData &= "\\" & GUICtrlRead($descTable3)
			GUICtrlSetData($descTable3, "")
			If $cols >= 4 Then $iData &= "\\" & GUICtrlRead($descTable4)
			GUICtrlSetData($descTable4, "")

		Case "TableRow"
			$cols = GUICtrlRead($descTableCount)
			$iData = GUICtrlRead($descTable1)
			GUICtrlSetData($descTable1, "")
			If $cols >= 2 Then $iData &= "\\" & GUICtrlRead($descTable2)
			GUICtrlSetData($descTable2, "")
			If $cols >= 3 Then $iData &= "\\" & GUICtrlRead($descTable3)
			GUICtrlSetData($descTable3, "")
			If $cols >= 4 Then $iData &= "\\" & GUICtrlRead($descTable4)
			GUICtrlSetData($descTable4, "")
		Case "DiceRoll"
			$iData = GUICtrlRead($descDiceRoll)
			GUICtrlSetData($descDiceRoll, "")
		Case "Roll"
			$iData = GUICtrlRead($descRoll)
			GUICtrlSetData($descRoll, "")
		Case "Effect"
			$iData = GUICtrlRead($descEffect)
			GUICtrlSetData($descEffect, "")
	EndSwitch

	If $editSave = False Then
		#Region - Always choose the Lowest INT to add to $PartType
		$listItems = _GUICtrlListView_GetItemCount($descListview)
		Dim $partArray[$listItems]
		$partCount = 0
		For $i = 0 To $listItems
			$itemText = _GUICtrlListView_GetItemText($descListview, $i)
			If StringInStr($itemText, $partType) Then
				$quickSplit = StringReplace($itemText, $partType, "")
				If StringIsInt($quickSplit) Then
					$partArray[$partCount] = $itemText
					$partCount += 1
				EndIf
			EndIf
		Next
		If $partCount = 0 Then
			$partType &= "1"
		Else
			ReDim $partArray[$partCount]
			$x = 1
			$found = False
			While 1

				For $i = 0 To $partCount - 1

					If StringReplace($partArray[$i], $partType, "") = $x Then

						ExitLoop
					EndIf
					If $i = $partCount - 1 Then $found = True
				Next
				If $found = True Then
					$partType &= $x
					ExitLoop
				Else
					$x += 1
				EndIf
			WEnd
		EndIf
		#EndRegion - Always choose the Lowest INT to add to $PartType

		$index = _GUICtrlListView_AddItem($descListview, $partType)
		_GUICtrlListView_AddSubItem($descListview, $index, $iData, 1)
	Else
		Return $iData
	EndIf
EndFunc   ;==>AddtoDescription

;===============================================================================
; Function Name:    _GUICtrlListView_MoveItems()
; Description:    Moves Up or Down selected item(s) in ListView.
;
; Parameter(s):  $hListView       - ControlID or Handle of ListView control.
;                  $iDirection       - Define in what direction item(s) will move:
;                                          -1 - Move Up.
;                                           1 - Move Down.
;
; Requirement(s):   AutoIt 3.3.0.0
;
; Return Value(s):  On seccess - Move selected item(s) Up/Down and return 1.
;                  On failure - Return "" (empty string) and set @error as following:
;                                                                 1 - No selected item(s).
;                                                                 2 - $iDirection is wrong value (not 1 and not -1).
;                                                                 3 - Item(s) can not be moved, reached last/first item.
;
; Note(s):        * If you select like 15-20 (or more) items, moving them can take a while  (second or two).
;
; Author(s):        G.Sandler a.k.a CreatoR
;===============================================================================
Func _GUICtrlListView_MoveItems($hListView, $iDirection)
	Local $aSelected_Indices = _GUICtrlListView_GetSelectedIndices($hListView, 1)

	If UBound($aSelected_Indices) < 2 Then Return SetError(1, 0, "")
	If $iDirection <> 1 And $iDirection <> -1 Then Return SetError(2, 0, "")

	Local $iTotal_Items = _GUICtrlListView_GetItemCount($hListView)
	Local $iTotal_Columns = _GUICtrlListView_GetColumnCount($hListView)

	Local $iUbound = UBound($aSelected_Indices) - 1, $iNum = 1, $iStep = 1

	Local $iCurrent_Index, $iUpDown_Index, $sCurrent_ItemText, $sUpDown_ItemText
	Local $iCurrent_Index, $iCurrent_CheckedState, $iUpDown_CheckedState
	Local $iImage_Current_Index, $iImage_UpDown_Index

	If ($iDirection = -1 And $aSelected_Indices[1] = 0) Or _
			($iDirection = 1 And $aSelected_Indices[$iUbound] = $iTotal_Items - 1) Then Return SetError(3, 0, "")

	ControlListView($hListView, "", "", "SelectClear")

	If $iDirection = 1 Then
		$iNum = $iUbound
		$iUbound = 1
		$iStep = -1
	EndIf

	For $i = $iNum To $iUbound Step $iStep
		$iCurrent_Index = $aSelected_Indices[$i]
		$iUpDown_Index = $aSelected_Indices[$i] + 1
		If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i] - 1

		$iCurrent_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iCurrent_Index)
		$iUpDown_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iUpDown_Index)

		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)

		For $j = 0 To $iTotal_Columns - 1
			$sCurrent_ItemText = _GUICtrlListView_GetItemText($hListView, $iCurrent_Index, $j)
			$sUpDown_ItemText = _GUICtrlListView_GetItemText($hListView, $iUpDown_Index, $j)

			If _GUICtrlListView_GetImageList($hListView, 1) <> 0 Then
				$iImage_Current_Index = _GUICtrlListView_GetItemImage($hListView, $iCurrent_Index, $j)
				$iImage_UpDown_Index = _GUICtrlListView_GetItemImage($hListView, $iUpDown_Index, $j)

				_GUICtrlListView_SetItemImage($hListView, $iCurrent_Index, $iImage_UpDown_Index, $j)
				_GUICtrlListView_SetItemImage($hListView, $iUpDown_Index, $iImage_Current_Index, $j)
			EndIf

			_GUICtrlListView_SetItemText($hListView, $iUpDown_Index, $sCurrent_ItemText, $j)
			_GUICtrlListView_SetItemText($hListView, $iCurrent_Index, $sUpDown_ItemText, $j)
		Next

		_GUICtrlListView_SetItemChecked($hListView, $iUpDown_Index, $iCurrent_CheckedState)
		_GUICtrlListView_SetItemChecked($hListView, $iCurrent_Index, $iUpDown_CheckedState)

		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index, 0)
	Next

	For $i = 1 To UBound($aSelected_Indices) - 1
		$iUpDown_Index = $aSelected_Indices[$i] + 1
		If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i] - 1
		_GUICtrlListView_SetItemSelected($hListView, -1, False)
		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)
	Next

	Return 1
EndFunc   ;==>_GUICtrlListView_MoveItems

Func PreviewUpdate()
	Local $lItems = _GUICtrlListView_GetItemCount($descListview)

	Local $lArray[$lItems + 1][2]

	$lArray[0][0] = $lItems

	For $i = 1 To $lItems
		$lArray[$i][0] = _GUICtrlListView_GetItemText($descListview, $i - 1)
		$lArray[$i][1] = _GUICtrlListView_GetItemText($descListview, $i - 1, 1)
	Next

	$lDecode = _Custom_IniDecode($descTitle, "Listview", $lArray)

	GUICtrlSetData($descPreview, $lDecode)
EndFunc   ;==>PreviewUpdate

Func _Custom_IniDecode($iSection, $iniType = "MagicItem", $listviewData = "") ;;; FIx the ini read so that it is CustomSpells or Custom Magic items ini
	;ConsoleWrite("Initype = " & $iniType & @LF)
	Local $retString = "", $longestStr = 0

	$titleLen = StringLen($iSection)
	;ConsoleWrite($titleLen & @LF)

	$retString = "+"
	For $i = 0 To $titleLen + 1
		$retString &= "~"
	Next
	$retString &= "+" & @CRLF
	$retString &= "| " & $iSection & " |" & @CRLF
	$retString &= "+"
	For $i = 0 To $titleLen + 1
		$retString &= "~"
	Next
	$retString &= "+" & @CRLF

	If $iniType = "MagicItem" Then
		$iniData = IniReadSection($cMagicItemsIni, $iSection)
	ElseIf $iniType = "Spell" Then
		$iniData = IniReadSection($cSpellIni, $iSection)
	ElseIf $iniType = "Listview" Then
		$iniData = $listviewData
	Else
		Return 0
	EndIf

	For $i = 1 To $iniData[0][0]
		Select
			Case StringInStr($iniData[$i][0], "Type")
				$retString &= $iniData[$i][1] & @CRLF & @CRLF
			Case StringInStr($iniData[$i][0], "Description")
				If StringInStr($iniData[$i][0], "DescriptionTitle") Then
					$strLen = StringLen($iniData[$i][1])

					$retString &= "|"
					For $j = 0 To $strLen + 1
						$retString &= "~"
					Next
					$retString &= "|" & @CRLF
					$retString &= "| " & $iniData[$i][1] & " |" & @CRLF
					$retString &= "|"
					For $j = 0 To $strLen + 1
						$retString &= "~"
					Next
					$retString &= "|" & @CRLF
				Else
					$retString &= "  " & $iniData[$i][1] & @CRLF
				EndIf
			Case StringInStr($iniData[$i][0], "Subitem")
				$retString &= "- " & $iniData[$i][1] & @CRLF
			Case StringInStr($iniData[$i][0], "TableTitle") Or StringInStr($iniData[$i][0], "TableColumns") Or StringInStr($iniData[$i][0], "TableRow")
				$j = $i
				$longestStr = 0
				$colInt = 0
				$tabInt = 0
				$tableArray = 0
				$tableItems = 0
				$colLengths = 0
				$colSplit = 0
				$columns = 1
				$boolTitle = False
				$boolCol = False
				$boolRow = False
				$tableTitle = ""
				Dim $tableArray[200][10]

				Do
					If StringInStr($iniData[$j][0], "Table") Then
						If StringInStr($iniData[$j][0], "TableTitle") Then
							If $boolTitle = True Then ExitLoop
							If $boolRow = True Then ExitLoop
							$longestStr = StringLen($iniData[$j][1]) + 2
							$tableTitle = $iniData[$j][1]
							$boolTitle = True
							;ConsoleWrite($tableArray[0][1] & @LF)
						ElseIf StringInStr($iniData[$j][0], "TableColumns") Then
							If $boolCol = True Then ExitLoop
							If $boolRow = True Then ExitLoop
							$colSplit = StringSplit($iniData[$j][1], "\\", 1)

							Dim $colLengths[$colSplit[0]]
							For $a = 1 To $colSplit[0]
								$tableArray[1][$a - 1] = $colSplit[$a]
								;ConsoleWrite("Column " & $a & " is " & $tableArray[1][$a - 1] & @LF)

								$colLengths[$a - 1] = StringLen($tableArray[1][$a - 1])

							Next
							$boolCol = True

						Else


							$tabItemSplit = StringSplit($iniData[$j][1], "\\", 1)
							$tableItems += 1

							If $boolRow = True Then
								If UBound($colLengths) < $tabItemSplit[0] Then
									ConsoleWrite("Wrong Number of Columns" & @LF)
									ExitLoop

								EndIf

							EndIf

							$columns = $tabItemSplit[0]
							ConsoleWrite($columns & @LF)

							If $longestStr = 0 Then
								$longestStr += 1
								For $b = 1 To $tabItemSplit[0]
									$longestStr += StringLen($tabItemSplit[$b])
									If Not ($b = $tabItemSplit[0]) Then $longestStr += 3
								Next
								$longestStr += 1
							Else
								$rowStr = 1
								ConsoleWrite($tabItemSplit & @LF)
								$n = 1
								If $boolCol Then $n = 2
								For $b = $n To $tabItemSplit[0]
									$rowStr += StringLen($tabItemSplit[$b])
									If Not ($b = $tabItemSplit[0]) Then $rowStr += 3
								Next
								$rowStr += 1
								If $rowStr > $longestStr Then $longestStr = $rowStr
							EndIf

							If Not (IsArray($colLengths)) Then
								Dim $colLengths[$tabItemSplit[0]]

							EndIf

							For $a = 1 To $tabItemSplit[0]
								If $boolCol Then
									$tableArray[$tableItems + 1][$a - 1] = $tabItemSplit[$a]
								Else
									$tableArray[$tableItems][$a - 1] = $tabItemSplit[$a]
								EndIf
								;ConsoleWrite("Item " & $tableItems & " column " & $a & " is " & $tableArray[$tableItems + 1][$a - 1] & @LF)

								If StringLen($tableArray[$tableItems + 1][$a - 1]) > $colLengths[$a - 1] Then $colLengths[$a - 1] = StringLen($tableArray[$tableItems + 1][$a - 1])

							Next
							$boolRow = True

						EndIf
						;ConsoleWrite($iniData[$j][0] &@LF)
					EndIf
					;Add to Array in here maybe instead? Can't tell at the moment if its better to do Longest Str first or not?
					; You would probably need array because Columns\Items need +3 inbetween each column where as a Title only needs +2 on either side
					$j += 1
				Until ($j > $iniData[0][0] Or StringInStr($iniData[$j][0], "Table") = 0)
				If Not ($j > $iniData[0][0]) Then
					$i = $j - 1
				Else
					$i = $j
				EndIf
				$colInt = 1
				For $j = 0 To UBound($colLengths) - 1
					$colInt += $colLengths[$j]
					If $j = UBound($colLengths) - 1 Then
						$colInt += 1
					Else
						$colInt += 3
					EndIf
				Next

				If $colInt > $longestStr Then
					$longestStr = $colInt
				Else
					$j = $colInt
					$z = 0
					Do
						If $z > UBound($colLengths) - 1 Then $z = 0
						If $colLengths <> 0 Then $colLengths[$z] += 1
						$j += 1
						$z += 1

					Until $j > $longestStr - 1
				EndIf
				If IsArray($colSplit) Then
					If $colSplit[0] > $columns Then $columns = $colSplit[0]
					ReDim $tableArray[$tableItems + 2][$columns]
				Else
					ReDim $tableArray[$tableItems + 1][$columns]
				EndIf

				$tableArray[0][0] = $tableItems
				If $tableTitle <> "" Then
					$retString &= "+"
					For $j = 1 To $longestStr
						$retString &= "-"
					Next
					$retString &= "+" & @CRLF & "+"
					$titleSpace = ($longestStr - StringLen($tableTitle)) / 2
					For $j = 1 To Ceiling($titleSpace)
						$retString &= " "
					Next
					$retString &= $tableTitle
					For $j = 1 To Floor($titleSpace)
						$retString &= " "
					Next
					$retString &= "+" & @CRLF
				EndIf
				$retString &= "+"
				For $j = 1 To $longestStr
					$retString &= "-"
				Next
				$retString &= "+" & @CRLF
				$n = 0
				If IsArray($colSplit) Then $n = 1
				For $j = 1 To $tableItems + $n
					$retString &= "|"
					If $tableItems > 0 Or IsArray($colSplit) Then

						For $a = 0 To UBound($tableArray, 2) - 1
							$itemSpace = ($colLengths[$a] - StringLen($tableArray[$j][$a])) / 2
							For $z = 0 To Floor($itemSpace)
								$retString &= " "
							Next
							$retString &= $tableArray[$j][$a]
							For $z = 0 To Ceiling($itemSpace)
								$retString &= " "
							Next

							If Not ($a >= UBound($tableArray, 2) - 1) Then $retString &= "|"
						Next
					EndIf
					$retString &= "|" & @CRLF
					If $j = 1 And $boolCol Then
						$retString &= "+"
						For $x = 1 To $longestStr
							$retString &= "-"
						Next
						$retString &= "+" & @CRLF
					EndIf
				Next
				$retString &= "+"
				For $j = 1 To $longestStr
					$retString &= "-"
				Next
				$retString &= "+" & @CRLF & @CRLF

			Case StringInStr($iniData[$i][0], "Roll")

				$strLen = StringLen($iniData[$i][1])
				If StringInStr($iniData[$i][0], "DiceRoll") Then $strLen += 11

				$retString &= "+"
				For $j = 0 To $strLen + 1
					$retString &= "-"
				Next
				$retString &= "+" & @CRLF & "+ "
				If StringInStr($iniData[$i][0], "DiceRoll") Then $retString &= "Dice Roll: "
				$retString &= $iniData[$i][1] & " +" & @CRLF
				$retString &= "+"
				For $j = 0 To $strLen + 1
					$retString &= "-"
				Next
				$retString &= "+" & @CRLF
			Case StringInStr($iniData[$i][0], "Effect")
				$retString &= $iniData[$i][1] & @CRLF & @CRLF
			Case StringInStr($iniData[$i][0], "Heading")
				If StringInStr($iniData[$i][0], "EndHeading") Then
					$retString &= "+----------------+" & @CRLF
				Else
					$strLen = StringLen($iniData[$i][1])

					$retString &= "+"
					For $j = 0 To $strLen + 1
						$retString &= "-"
					Next
					$retString &= "+" & @CRLF & "+ "
					$retString &= $iniData[$i][1] & " +" & @CRLF
					$retString &= "+"
					For $j = 0 To $strLen + 1
						$retString &= "-"
					Next
					$retString &= "+" & @CRLF
				EndIf
		EndSelect
	Next
	If $longestStr > $titleLen Then $titleLen = $longestStr
	Dim $retArray[2] = [$retString, $titleLen]
	Return $retString
EndFunc   ;==>_Custom_IniDecode

Func CUSTOM_WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

	; structure to map $ilParam ($tNMHDR - see Help file)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam);, $tagNMLISTVIEW

	Switch $tNMHDR.IDFrom
		Case $descListview
			Switch $tNMHDR.Code
				Case $NM_DBLCLK
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					If $tInfo.Item > -1 Then
						$iItem = $tInfo.Item
						$descCurrEditing = True
						Dim $itemIndex[2]
						$itemIndex[0] = 1
						$itemIndex[1] = $iItem

						$itemType = _GUICtrlListView_GetItemText($descListview, $iItem, 0)
						$itemText = _GUICtrlListView_GetItemText($descListview, $iItem, 1)


						For $i = 0 To 9

							$itemType = StringReplace($itemType, String($i), "")
						Next


						GUICtrlSetData($descPartType, $itemType) ;; Sets the Combo Box to the correc item Type
						;Need to tidy up this bit so that it will pass data through too the correct GUI item
						$descReset = DescGUISwitch($itemType, $itemText)

						GUICtrlSetState($descUp, $GUI_DISABLE)
						GUICtrlSetState($descDown, $GUI_DISABLE)
						GUICtrlSetState($descEdit, $GUI_DISABLE)
						GUICtrlSetState($descDelete, $GUI_DISABLE)
						GUICtrlSetState($descListview, $GUI_DISABLE)

					EndIf
			EndSwitch
		Case $selListview
			Switch $tNMHDR.Code
				Case $NM_DBLCLK
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					If $tInfo.Item > -1 Then
						$iItem = $tInfo.Item

						$selText = _GUICtrlListView_GetItemText($selListview, $iItem)
						For $i = 1 To $selData[0][0]
							If $selData[$i][0] = $selText Then ExitLoop
						Next
						GUIDelete($selWindow)
						If $selData[0][1] = "Spell" Then EditorWindow($selData[0][1], $selText, $selData[$i][1], IniReadSection($cSpellIni, $selData[$i][0]))
						If $selData[0][1] = "Magic Item" Then EditorWindow($selData[0][1], $selText, $selData[$i][1], IniReadSection($cMagicItemsIni, $selData[$i][0]))
					EndIf
			EndSwitch
	EndSwitch
EndFunc   ;==>CUSTOM_WM_NOTIFY
