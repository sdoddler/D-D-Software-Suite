#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ItemSort_icon.ico
#AutoIt3Wrapper_Outfile=..\Item Sort.exe
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Editconstants.au3>
#include <GuiListView.au3>
#include <IniEx.au3>
#include <Array.au3>
#include <GuiMenu.au3>
#include <ComboConstants.au3>
#include <File.au3>

$winWidth = 765
$winHeight = 400


$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)

$weapIni = $appDir & "Weapons.txt"
$AdvGearIni = $appDir & "Adventuring Gear.txt"
$ArmourIni = $appDir & "Armour.txt"
$mountIni = $appDir & "Mounts.txt"
$toolIni = $appDir & "Tools.txt"

FileInstall(".\Weapons.txt", $weapIni, 0)
FileInstall(".\Adventuring Gear.txt", $AdvGearIni, 0)
FileInstall(".\Armour.txt", $ArmourIni, 0)
FileInstall(".\Mounts.txt", $mountIni, 0)
FileInstall(".\Tools.txt", $toolIni, 0)

FileInstall(".\Steam_Icon.ico", $appDir & "Steam_Icon.ico", 0)
FileInstall(".\Twitter_Icon.ico", $appDir & "Twitter_Icon.ico", 0)
FileInstall(".\Youtube_icon.ico", $appDir & "Youtube_icon.ico", 0)
FileInstall(".\Github_icon.ico", $appDir & "Github_icon.ico", 0)



Global $debug = 0, $searchArray = 0, $ToolTipActive = False, $descWindows = 0, $hDescripts[0], $active = False

Global Enum $idproc1 = 1000, $winTitle = "DnD Item Sort"

$hGUI = GUICreate($winTitle, $winWidth, $winHeight, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)




$Costs = "Any|Less than 1 gp|1 Gp to 25 gp|Greater than 25 gp"
$Damages = "Any|Bludgeoning|Piercing|Slashing"
$Weights = "Any|Light (5 lb. or less)|Medium (6 to 25 lb.)|Heavy (Greater than 25 lb.)"
$Properties = "Any|Ammunition|Finesse|Heavy|Light|Loading|Reach|Special|Thrown|Two-Handed|Versatile"
$types = "Any|" & _ArrayToString(IniReadSectionNames($weapIni), "|", 1, 0, "|", 1)


GUICtrlCreateGroup("", 5, 1, 510, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Item Name", 10, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$ihSearch = GUICtrlCreateInput("", 10, 15, 100, -1, $ES_AUTOHSCROLL)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Cost", 125, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cCost = GUICtrlCreateCombo("", 130, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Costs, "Any")

GUICtrlCreateLabel("Damage", 245, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cDam = GUICtrlCreateCombo("", 250, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Damages, "Any")

GUICtrlCreateLabel("Weight", 365, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cWeight = GUICtrlCreateCombo("", 370, 15, 140) ; Yes/no
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Weights, "Any")

GUICtrlCreateGroup("", 5, 40, 645, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Properties", 10, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cProp = GUICtrlCreateCombo("", 10, 54, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Properties, "Any")

GUICtrlCreateLabel("Types", 130, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$gWeap = GUICtrlCreateCheckbox("Weapons", 130, 54)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$gGear = GUICtrlCreateCheckbox("Adv. Gear", 200, 54)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$gArmour = GUICtrlCreateCheckbox("Armour", 270, 54)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$gMounts = GUICtrlCreateCheckbox("Mounts", 330, 54)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$gTools = GUICtrlCreateCheckbox("Tools", 390, 54)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$bUpdate = GUICtrlCreateButton("Update", 440, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$bClear = GUICtrlCreateButton("Clear", 545, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)


Local $iStylesEx = BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT)
$idListview = GUICtrlCreateListView("", 10, 90, $winWidth - 20, 280, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT))
_GUICtrlListView_SetExtendedListViewStyle($idListview, $iStylesEx)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

_GUICtrlListView_AddColumn($idListview, "Item Name", 120)
_GUICtrlListView_AddColumn($idListview, "Cost", 60)
_GUICtrlListView_AddColumn($idListview, "Damage", 100)
_GUICtrlListView_AddColumn($idListview, "Weight", 45)
_GUICtrlListView_AddColumn($idListview, "Speed", 100)
_GUICtrlListView_AddColumn($idListview, "Carrying Capacity", 100)
_GUICtrlListView_AddColumn($idListview, "Properties", 150)


$gSteamIcon = GUICtrlCreateIcon($appDir & "Steam_Icon.Ico", -1, 600, 5, 32, 32)
GUICtrlSetTip($gSteamIcon, " ", "sDoddler's Steam Profile")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gTwitterIcon = GUICtrlCreateIcon($appDir & "Twitter_Icon.Ico", -1, 640, 5, 32, 32)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip($gTwitterIcon, " ", "sDoddler's Twitter Page")
$gYoutubeIcon = GUICtrlCreateIcon($appDir & "Youtube_Icon.Ico", -1, 680, 5, 32, 32)
GUICtrlSetTip($gYoutubeIcon, " ", "sDoddler's YouTube Channel")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gGithubIcon = GUICtrlCreateIcon($appDir & "Github_icon.Ico", -1, 720, 5, 32, 32)
GUICtrlSetTip($gGithubIcon, " ", "DnD Sort Github Page")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)


#CS Columns
	[0] Item Name	[1]Cost		[2]Damage	[3]Weight	[4]Speed	[5]Carry Capacity	[6]Properties
#CE



#Region Creating SearchOptions.ini (Commented Out.)
#CS
	$schoolArray = _ReadAttribute($weapIni, "School")
	_ArrayQuickWrite($schoolArray,"Schools")

	$levelArray = _ReadAttribute($weapIni, "Level")
	_ArrayQuickWrite($levelArray,"Levels")

	$RitualArray = _ReadAttribute($weapIni, "Ritual")
	_ArrayQuickWrite($RitualArray,"Rituals")

	$ctArray = _ReadAttribute($weapIni, "Casting Time")
	_ArrayQuickWrite($ctArray,"Cast Times")

	$RangeArray = _ReadAttribute($weapIni, "Range")
	_ArrayQuickWrite($RangeArray,"Ranges")

	$ComponentsArray = _ReadAttribute($weapIni, "Components")
	_ArrayQuickWrite($ComponentsArray,"Components")

	$DurationArray = _ReadAttribute($weapIni, "Duration")
	_ArrayQuickWrite($DurationArray,"Durations")
#CE
#EndRegion Creating SearchOptions.ini (Commented Out.)

GUISetState()
Dim $txtArray[5] = [$weapIni, $AdvGearIni, $ArmourIni, $mountIni, $toolIni]

_GUICtrlSetState($GUI_DISABLE)
$itemArray = _SearchItems($txtArray)
_GUICtrlSetState($GUI_ENABLE)
$winSize = WinGetClientSize ($winTitle)
$lastWinSize = $winSize[0]
If WinActive($winTitle) Then HotKeySet("{ENTER}", "Update")


_GUICtrlListView_RegisterSortCallBack($idListview)

While 1
	If (WinActive($winTitle) = 0 And $active = True) Then ;; If window does not have window but it just did
		$active = False
		HotKeySet("{ENTER}")
		ConsoleWrite("SetHotkeysOff")
		;SetGrid
	ElseIf (WinActive($winTitle) And $active = False) Then ;;If Window DOES have focus but just didn't
		$active = True
		HotKeySet("{ENTER}", "Update")
		ConsoleWrite("SetHotkeysON")

	EndIf

	$winSize = WinGetClientSize ($winTitle)
	if NOT($winSize[0] = $lastWinSize) Then
		$lastWinSize = $winSize[0]
	Switch $winSize[0]
		Case 760 to 3000
			GUICtrlSetState($gSteamIcon,$GUI_SHOW)
			GUICtrlSetState($gTwitterIcon,$GUI_SHOW)
			GUICtrlSetState($gYoutubeIcon,$GUI_SHOW)
			GUICtrlSetState($gGithubIcon,$GUI_SHOW)
		Case 720 to 760
			GUICtrlSetState($gSteamIcon,$GUI_HIDE)
			GUICtrlSetState($gTwitterIcon,$GUI_SHOW)
			GUICtrlSetState($gYoutubeIcon,$GUI_SHOW)
			GUICtrlSetState($gGithubIcon,$GUI_SHOW)
		Case 680 to 720
			GUICtrlSetState($gSteamIcon,$GUI_HIDE)
			GUICtrlSetState($gTwitterIcon,$GUI_HIDE)
			GUICtrlSetState($gYoutubeIcon,$GUI_SHOW)
			GUICtrlSetState($gGithubIcon,$GUI_SHOW)
		Case 640 to 680
			GUICtrlSetState($gSteamIcon,$GUI_HIDE)
			GUICtrlSetState($gTwitterIcon,$GUI_HIDE)
			GUICtrlSetState($gYoutubeIcon,$GUI_HIDE)
			GUICtrlSetState($gGithubIcon,$GUI_SHOW)
		Case 0 to 640
			GUICtrlSetState($gSteamIcon,$GUI_HIDE)
			GUICtrlSetState($gTwitterIcon,$GUI_HIDE)
			GUICtrlSetState($gYoutubeIcon,$GUI_HIDE)
			GUICtrlSetState($gGithubIcon,$GUI_HIDE)
	EndSwitch
	EndIf

	$msg = GUIGetMsg(1)
	Switch $msg[1]

		Case $hGUI

			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $idListview
					_GUICtrlListView_SortItems($idListview, GUICtrlGetState($idListview))
				Case $bUpdate
					Update()
				Case $bClear
					;GUICtrlSetData($cSpeed, "")
					GUICtrlSetData($cCost, "")
					GUICtrlSetData($cProp, "")
					GUICtrlSetData($cWeight, "")
					GUICtrlSetData($cDam, "")
					;GUICtrlSetData($cSpeed, $castTimes, "Any")
					GUICtrlSetData($cCost, $Costs, "Any")
					GUICtrlSetData($cProp, $Properties, "Any")
					GUICtrlSetData($cWeight, $Weights, "Any")
					GUICtrlSetData($cDam, $Damages, "Any")
					GUICtrlSetData($ihSearch, "")
				Case $gSteamIcon
					ShellExecute('https://steamcommunity.com/id/sdoddler')
				Case $gTwitterIcon
					ShellExecute('https://twitter.com/sdoddler')
				Case $gYoutubeIcon
					ShellExecute('https://youtube.com/user/doddddy')
				Case $gGithubIcon
					ShellExecute('https://github.com/sdoddler/D-D-Software-Suite')
			EndSwitch
	EndSwitch



WEnd

Func _SearchItems($iFiles = "", $iSearch = 0)
	Local $listCount = 0, $iType = "Weapons", $lineCount

	_GUICtrlListView_DeleteAllItems($idListview)

	#CS Columns
		[0] Item Name	[1]Cost		[2]Damage	[3]Weight	[4]Speed	[5]Carry Capacity	[6]Properties
	#CE


	If @NumParams = 1 Then
		For $i = 0 To UBound($iFiles) - 1
			$lineCount += _FileCountLines($iFiles[$i]) - 1
		Next


		Local $itArray[$lineCount + 1][8]
		$itArray[0][0] = $lineCount
		For $a = 0 To UBound($iFiles) - 1
			$rSec = IniReadSectionNames($iFiles[$a])
			$iType = StringSplit($iFiles[$a], "\")
			$iType = StringReplace($iType[UBound($iType) - 1], ".txt", "")
			For $i = 1 To $rSec[0]
				$secT = IniReadSection($iFiles[$a], $rSec[$i])
				For $j = 1 To $secT[0][0]
					$listCount += 1
					$itArray[$listCount][0] = $secT[$j][0]
					_GUICtrlListView_AddItem($idListview, $itArray[$listCount][0])
					Switch $iType
						Case "Weapons"
							$iSplit = StringSplit($secT[$j][1], "\\", 1)
							;_ArrayDisplay($iSplit)
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = $iSplit[2]
							$itArray[$listCount][3] = $iSplit[3]
							$itArray[$listCount][4] = "-"
							$itArray[$listCount][5] = "-"
							$itArray[$listCount][6] = $iSplit[4]
							$itArray[$listCount][7] = $iType
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[1], 1)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[2], 2)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[3], 3)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 4)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 5)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[4], 6)
						Case "Adventuring Gear"
							$iSplit = StringSplit($secT[$j][1], "\\", 1)
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[2]
							$itArray[$listCount][4] = "-"
							$itArray[$listCount][5] = "-"
							$itArray[$listCount][6] = "-"
							$itArray[$listCount][7] = $iType
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[1], 1)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 2)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[2], 3)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 4)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 5)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 6)
						Case "Armour"
							$iSplit = StringSplit($secT[$j][1], "\\", 1)
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[5]
							$itArray[$listCount][4] = "-"
							$itArray[$listCount][5] = "-"
							$itArray[$listCount][6] = "AC: " & $iSplit[2] & ", Str:" & $iSplit[3] & ", Stealth: " & $iSplit[4]
							$itArray[$listCount][7] = $iType
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[1], 1)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 2)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[5], 3)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 4)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 5)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $itArray[$listCount][6], 6)
						Case "Mounts" ; Cost Speed Weight Carry Capactiy
							$iSplit = StringSplit($secT[$j][1], "\\", 1)
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[3]
							$itArray[$listCount][4] = $iSplit[2]
							$itArray[$listCount][5] = $iSplit[4]
							$itArray[$listCount][6] = "-"
							$itArray[$listCount][7] = $iType
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[1], 1)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 2)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[3], 3)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[2], 4)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[4], 5)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $itArray[$listCount][6], 6)
						Case "Tools" ; Cost Weight
							$iSplit = StringSplit($secT[$j][1], "\\", 1)
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[2]
							$itArray[$listCount][4] = "-"
							$itArray[$listCount][5] = "-"
							$itArray[$listCount][6] = "-"
							$itArray[$listCount][7] = $iType
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[1], 1)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 2)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, $iSplit[2], 3)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 4)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 5)
							_GUICtrlListView_AddSubItem($idListview, $listCount - 1, "-", 6)


					EndSwitch
				Next
			Next
		Next
		ConsoleWrite("ListCount = " & $listCount & @LF)
		;_ArrayDisplay($itArray)
		Return $itArray
	Else

		For $i = 1 To $itemArray[0][0] - 1
			Local $include = True
			For $j = 0 To UBound($iSearch) - 1
				Switch $iSearch[$j][1]
					Case "Item Name"
						If Not (StringInStr($itemArray[$i][0], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Cost"
						;"Any|Less than 1 gp|1 Gp to 25 gp|Greater than 25 gp"
						Switch $iSearch[$j][0]
							Case "Less than 1 gp"
								If StringInStr($itemArray[$i][1], "gp") Or StringInStr($itemArray[$i][1], "pp") Then
									$include = False
									ExitLoop
								EndIf

							Case "1 Gp to 25 gp"
								If StringInStr($itemArray[$i][1], "sp") Or StringInStr($itemArray[$i][1], "cp") Then
									$include = False
									ExitLoop
								Else
									$gpSplit = StringSplit($itemArray[$i][1], " ")
									If $gpSplit[1] > 25 And $gpSplit[2] = "gp" Then
										$include = False
										ExitLoop
									EndIf
									If $gpSplit[1] > 2 And $gpSplit[2] = "pp" Then
										$include = False
										ExitLoop
									EndIf
								EndIf

							Case "Greater than 25 gp"
								If StringInStr($itemArray[$i][1], "sp") Or StringInStr($itemArray[$i][1], "cp") Or StringInStr Then
									$include = False
									ExitLoop
								Else
									$gpSplit = StringSplit($itemArray[$i][1], " ")
									If $gpSplit[0] > 1 Then
										If $gpSplit[1] < 26 And $gpSplit[2] = "gp" Then
											$include = False
											ExitLoop
										EndIf
										If $gpSplit[1] < 3 And $gpSplit[2] = "pp" Then
											$include = False
											ExitLoop
										EndIf
									EndIf
								EndIf


							Case Else
								If Not (StringInStr($itemArray[$i][1], $iSearch[$j][0])) Then
									$include = False
									ExitLoop
								EndIf
						EndSwitch
;~
					Case "Damage"
						If Not (StringInStr($itemArray[$i][2], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Weight"
						$SearchWeight = StringSplit($iSearch[$j][0], " ");
						$iWeight = StringSplit($itemArray[$i][3], " ")
						Switch $SearchWeight[1]
							Case "Light"
								If $iWeight[1] > 5 Then
									$include = False
									ExitLoop
								EndIf
							Case "Medium"
								If $iWeight[1] <= 5 Or $iWeight[1] > 25 Then
									$include = False
									ExitLoop
								EndIf
							Case "Heavy"
								If $iWeight[1] < 26 Then
									$include = False
									ExitLoop
								EndIf

						EndSwitch
					Case "Properties"
						If Not (StringInStr($itemArray[$i][6], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Types"
						If Not (StringInStr($iSearch[$j][0],$itemArray[$i][7])) Then

							$include = False
							ExitLoop
						EndIf
				EndSwitch
			Next
			If $include Then
				_GUICtrlListView_AddItem($idListview, $itemArray[$i][0])
				_GUICtrlListView_AddSubItem($idListview, $listCount, $itemArray[$i][1], 1)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $itemArray[$i][2], 2)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $itemArray[$i][3], 3)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $itemArray[$i][4], 4)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $itemArray[$i][5], 5)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $itemArray[$i][6], 6)
				$listCount += 1
			EndIf
		Next
	EndIf


EndFunc   ;==>_SearchItems
;#CE
Func _GUICtrlSetState($state)
	GUICtrlSetState($idListview, $state)
	;GUICtrlSetState($cSpeed, $state)
	GUICtrlSetState($cCost, $state)
	GUICtrlSetState($cProp, $state)
	GUICtrlSetState($cWeight, $state)
	GUICtrlSetState($cDam, $state)
	GUICtrlSetState($ihSearch, $state)
	GUICtrlSetState($bUpdate, $state)
	GUICtrlSetState($bClear, $state)
	GUICtrlSetState($gGear, $state)
	GUICtrlSetState($gWeap, $state)
	GUICtrlSetState($gArmour, $state)
	GUICtrlSetState($gMounts, $state)
	GUICtrlSetState($gTools, $state)
	Switch $state
		Case $GUI_ENABLE
			HotKeySet("{ENTER}", "Update")
		Case $GUI_DISABLE
			HotKeySet("{ENTER}")
	EndSwitch

EndFunc   ;==>_GUICtrlSetState

Func Update()
	$searchArray = 0
	Dim $searchArray[9][2], $typeArray[5]
	#CS List View Columns
		[0] Spell Name	[1]Level	[2]School	[3]Ritual	[4]Cast Time	[5]Range	[6]Components	[7]Duration	[8]Description
	#CE
	$qCount = 0
	$qTypes = 0

	If GUICtrlRead($ihSearch) <> "" Then
		$searchArray[$qCount][1] = "Item Name"
		$searchArray[$qCount][0] = GUICtrlRead($ihSearch)
		$qCount += 1
	EndIf
	If GUICtrlRead($cCost) <> "Any" Then
		$searchArray[$qCount][1] = "Cost"
		$searchArray[$qCount][0] = GUICtrlRead($cCost)
		$qCount += 1
	EndIf
	If GUICtrlRead($cDam) <> "Any" Then
		$searchArray[$qCount][1] = "Damage"
		$searchArray[$qCount][0] = GUICtrlRead($cDam)
		$qCount += 1
	EndIf
	If GUICtrlRead($cWeight) <> "Any" Then
		$searchArray[$qCount][1] = "Weight"
		$searchArray[$qCount][0] = GUICtrlRead($cWeight)
		$qCount += 1
	EndIf
	If GUICtrlRead($cProp) <> "Any" Then
		$searchArray[$qCount][1] = "Properties"
		$searchArray[$qCount][0] = GUICtrlRead($cProp)
		$qCount += 1
	EndIf
	If GUICtrlRead($gWeap) = $GUI_CHECKED Then
		$typeArray[$qTypes] = "Weapons"
		$qTypes += 1

	EndIf
	If GUICtrlRead($gGear) = $GUI_CHECKED Then
		$typeArray[$qTypes] = "Adventuring Gear"
		$qTypes += 1
	EndIf
	If GUICtrlRead($gArmour) = $GUI_CHECKED Then
		$typeArray[$qTypes] = "Armour"
		$qTypes += 1
	EndIf
	If GUICtrlRead($gMounts) = $GUI_CHECKED Then
		$typeArray[$qTypes] = "Mounts"
		$qTypes += 1
	EndIf

	If GUICtrlRead($gTools) = $GUI_CHECKED Then
		$typeArray[$qTypes] = "Tools"
		$qTypes += 1
	EndIf
	If $qTypes = 0 Then
		HotKeySet("{ENTER}")
		MsgBox(48, "No Gear Types Selected", "No Item Types selected, please tick a checkbox and try again")
		HotKeySet("{ENTER}", "Update")
		Return 0
	Else
		$searchArray[$qCount][1] = "Types"
		For $i = 0 To $qTypes-1
			$searchArray[$qCount][0] &= $typeArray[$i]

		Next
		ConsoleWrite($searchArray[$qCount][0] &@LF)
		$qCount += 1
	EndIf
	If $qCount > 0 Then
		ReDim $searchArray[$qCount][2]
		_GUICtrlSetState($GUI_DISABLE)
		_SearchItems(-1, $searchArray)
		_GUICtrlSetState($GUI_ENABLE)
	Else
		_GUICtrlSetState($GUI_DISABLE)
		$itemArray = _SearchItems($txtArray)
		_GUICtrlSetState($GUI_ENABLE)
	EndIf
EndFunc   ;==>Update
