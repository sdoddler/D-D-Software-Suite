#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.12.0
	Author:         sDoddler

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------


#cs TO DO _----_---___----____---_____-
	Create Custom items via GUI
		- Add Type
		- Add Description (Paragraph)
		- Add DescriptionTitle
		- Add Sub Item (Bullet Point)
		- Add TableTitle
		- Add Table Columns
		- Add Table Row
		- Add Dice Roll
		- Add Roll
		- Add Effect

	Add Custom item Search (Any|Only|No)
#CE

#AutoIt3Wrapper_Icon=MagicItems_icon.ico
#AutoIt3Wrapper_Outfile=..\Magic Item Sort.exe

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Editconstants.au3>
#include <GuiListView.au3>
#include <IniEx.au3>
#include <Array.au3>
#include <GuiMenu.au3>
#include <ComboConstants.au3>
#include <File.au3>

$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)



$basicIni = $appDir & "MagicItems-BasicInfo.TXT"
$completeIni = $appDir & "MagicItems-CompleteInfo.TXT"
$custIni = @ScriptDir & "\Custom Magic Items.ini"
ConsoleWrite($custIni &@LF)
$iconsIcl = $appDir & "Icons.icl"

#Region File and Icon Installs
FileInstall(".\MagicItems-BasicInfo.TXT", $basicIni, 0)
FileInstall(".\MagicItems-CompleteInfo.TXT", $completeIni, 1)

FileInstall(".\Steam_Icon.ico", $appDir & "Steam_Icon.ico",0)
FileInstall(".\Twitter_Icon.ico", $appDir & "Twitter_Icon.ico", 0)
FileInstall(".\Youtube_icon.ico", $appDir & "Youtube_icon.ico", 0)
FileInstall(".\Github_icon.ico", $appDir & "Github_icon.ico", 0)
FileInstall(".\Icons.icl", $appDir & "Icons.icl", 0)
#EndRegion File and Icon Installs


Global $winTitle = "D&D Magic Item Sort"

Global $subWindows = 0
Global $hSubs[0]

$winWidth = 600
$winHeight = 400

#Region Main Gui

$hGUI = GUICreate($winTitle, $winWidth, $winHeight, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)


$Enter_KEY = GUICtrlCreateDummy()

Dim $Arr[1][2] = [["{ENTER}", $Enter_KEY]]

GUISetAccelerators($Arr, $hGUI)

GUICtrlCreateGroup("", 5, 1, 510, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Item Name", 10, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$ihSearch = GUICtrlCreateInput("", 10, 15, 100, -1, $ES_AUTOHSCROLL)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Type", 125, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cType = GUICtrlCreateCombo("", 130, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, "Any|Armor|Potion|Ring|Rod|Scroll|Staff|Wand|Weapon|Wondrous Item", "Any")

GUICtrlCreateLabel("Rarity", 245, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cRarity = GUICtrlCreateCombo("", 250, 15, 78)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, "Any|Common|Uncommon|Rare|Very Rare|Legendary", "Any")

GUICtrlCreateLabel("Attunement", 340, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cAttune = GUICtrlCreateCombo("", 345, 15, 60,-1,$CBS_DROPDOWNLIST) ; Yes/no
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, "Any|Yes|-", "Any")

GUICtrlCreateLabel("Custom Items", 420,1)
GUICtrlSetResizing(-1,$GUI_DOCKALL)
$cCustom = GUICtrlCreateCombo("",425,15,70,-1,$CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1,"Any|Only|No","Any")

GUICtrlCreateGroup("", 5, 40, 345, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Notes", 10, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$iNotes = GUICtrlCreateInput("", 10, 54, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$bUpdate = GUICtrlCreateButton("Update", 125, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$bClear = GUICtrlCreateButton("Clear", 245, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

#EndRegion Main Gui

#Region Listview Creation

Local $iStylesEx = BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT)
$idListview = GUICtrlCreateListView("", 10, 90, $winWidth - 20, 280, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT))
_GUICtrlListView_SetExtendedListViewStyle($idListview, $iStylesEx)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

;;Sect[ITEM][0] = Magic Item Name
;[ITME][1] = Type
;[ITME][2] = Rarity
;[ITME][3] = Attunement
;[ITME][4] = Notes
;[ITME][5] = Source

_GUICtrlListView_AddColumn($idListview, "Magic Item Name", 120)
_GUICtrlListView_AddColumn($idListview, "Type", 60)
_GUICtrlListView_AddColumn($idListview, "Rarity", 100)
_GUICtrlListView_AddColumn($idListview, "Attunement", 45)
_GUICtrlListView_AddColumn($idListview, "Notes", 100)
_GUICtrlListView_AddColumn($idListview, "Source", 100)

#EndRegion Listview Creation

#Region Display ICons
$gSteamIcon = GUICtrlCreateIcon($appDir & "Steam_Icon.Ico", -1, 360, 45, 32, 32)
GUICtrlSetTip($gSteamIcon, " ", "sDoddler's Steam Profile")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gTwitterIcon = GUICtrlCreateIcon($appDir & "Twitter_Icon.Ico", -1, 400, 45, 32, 32)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip($gTwitterIcon, " ", "sDoddler's Twitter Page")
$gYoutubeIcon = GUICtrlCreateIcon($appDir & "Youtube_Icon.Ico", -1, 440, 45, 32, 32)
GUICtrlSetTip($gYoutubeIcon, " ", "sDoddler's YouTube Channel")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gGithubIcon = GUICtrlCreateIcon($appDir & "Github_icon.Ico", -1, 480, 45, 32, 32)
GUICtrlSetTip($gGithubIcon, " ", "DnD Sort Github Page")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)

#EndRegion Display ICons

GUISetState()

_GUICtrlSetState($GUI_DISABLE)
$itemArray = SearchMagicItems("Yes")
_GUICtrlSetState($GUI_ENABLE)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

$winSize = WinGetClientSize($winTitle)
$lastWinSize = $winSize[0]

_GUICtrlListView_RegisterSortCallBack($idListview)

While 1


	$msg = GUIGetMsg(1)
	Switch $msg[1]

		Case $hGUI

			Switch $msg[0]
				Case $GUI_EVENT_CLOSE ; Esc or X window button is pressed
					Exit
				Case $idListview ; List View Sort call
					_GUICtrlListView_SortItems($idListview, GUICtrlGetState($idListview))
				Case $bUpdate ; Upadte Button is pressed
					Update()
				Case $Enter_KEY ; GUI Accelerator {ENTER} is pressed
					if ControlGetHandle($winTitle,"",ControlGetFocus($winTitle)) = GUICtrlGetHandle($idListview) Then
						$indicies = _GUICtrlListView_GetSelectedIndices($idListview,True)

						For $i = 1 to $indicies[0]
							$item = _GUICtrlListView_GetItemText($idListview, $indicies[$i])
						$itemRead = IniRead($basicIni, "MagicItems", $item, "")
						$split = StringSplit($itemRead, "\\", 1)
						If $split[0] = 6 Then
							;ConsoleWrite($split[6] & @LF)
							$quick = _IniDecode($split[6])
							CreateSubWindow($split[6],$quick[0] , 200 + ($quick[1] * 5))
							;ConsoleWrite(200 + (StringLen($split[6]) * 4) & @LF)
						Else
							;ConsoleWrite($item & @LF)
							$quick = _IniDecode($item)
							CreateSubWindow($item, $quick[0], 200 + ($quick[1] * 5))
							;ConsoleWrite(200 + (StringLen($item) * 4) & @LF)
						EndIf
						Next
					Else
						Update()
					EndIf
				Case $bClear ; Clear Button is Pressed
					GUICtrlSetData($cRarity, "")
					GUICtrlSetData($cType, "")
					GUICtrlSetData($cAttune, "")
					GUICtrlSetData($cCustom, "")
					GUICtrlSetData($cRarity, "Any|Common|Uncommon|Rare|Very Rare|Legendary", "Any")
					GUICtrlSetData($cType, "Any|Armor|Potion|Ring|Rod|Scroll|Staff|Wand|Weapon|Wondrous Item", "Any")
					GUICtrlSetData($cAttune, "Any|Yes|-", "Any")
					GUICtrlSetData($cCustom, "Any|Only|No","Any")
					GUICtrlSetData($iNotes, "")
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

	For $i = 1 To UBound($hSubs) - 1
		If $msg[1] = $hSubs[$i][0] Then
			;ConsoleWrite("Message hit on: " & $hDescripts[$i]&@LF)
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					GUIDelete($hSubs[$i][0])
					_ArrayDelete($hSubs, $i)
					$subWindows -= 1
					ExitLoop
				Case $hSubs[$i][2]
					$hSubs[$i][6] = Not ($hSubs[$i][6])

					If $hSubs[$i][6] Then
						$styles = BitOR($ES_READONLY, $ES_MULTILINE, $WS_VSCROLL)
					Else
						$styles = BitOR($ES_MULTILINE, $WS_VSCROLL)
					EndIf
					GUICtrlSetStyle($hSubs[$i][5], $styles)
				Case $hSubs[$i][3]
					GUICtrlSetData($hSubs[$i][5], $hSubs[$i][1])
				Case $hSubs[$i][4]
					$quickSave = FileSaveDialog($hSubs[$i][7], @ScriptDir, "Text files (*.txt)")
					If Not (@error) Then
						FileWrite($quickSave, GUICtrlRead($hSubs[$i][5]))
					EndIf

			EndSwitch
		EndIf
	Next
	Sleep(10)
WEnd

Func _GUICtrlSetState($state)
	GUICtrlSetState($idListview, $state)
	GUICtrlSetState($cCustom, $state)
	GUICtrlSetState($cType, $state)
	GUICtrlSetState($iNotes, $state)
	GUICtrlSetState($cRarity, $state)
	GUICtrlSetState($cAttune, $state)
	GUICtrlSetState($ihSearch, $state)
	GUICtrlSetState($bUpdate, $state)
	GUICtrlSetState($bClear, $state)
	Switch $state
		Case $GUI_ENABLE
			GUISetAccelerators($Arr, $hGUI)
		Case $GUI_DISABLE
			GUISetAccelerators(0, $hGUI)
	EndSwitch

EndFunc   ;==>_GUICtrlSetState


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

	; structure to map $ilParam ($tNMHDR - see Help file)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam);, $tagNMLISTVIEW

	Switch $tNMHDR.IDFrom
		Case $idListview
			Switch $tNMHDR.Code
				Case $NM_DBLCLK
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					If $tInfo.Item > -1 Then
						$iItem = $tInfo.Item
						$item = _GUICtrlListView_GetItemText($idListview, $iItem)
						For $i = 0 to UBound($itemArray)-1
							if $item = $itemArray[$i][0] Then
								if $itemArray[$i][6] = "CUSTOMITEM" Then
									$quick = _IniDecode($itemArray[$i][0],"Custom")
								Else
								$quick = _IniDecode($itemArray[$i][6])
								EndIf
								CreateSubWindow($itemArray[$i][6], $quick[0], 200 + ($quick[1] * 5))
								ExitLoop
							EndIf

						Next
;~ 						$itemRead = IniRead($basicIni, "MagicItems", $item, "")
;~ 						$split = StringSplit($itemRead, "\\", 1)
;~ 						If $split[0] = 6 Then
;~ 							;ConsoleWrite($split[6] & @LF)
;~ 							$quick = _IniDecode($split[6])
;~ 							CreateSubWindow($split[6],$quick[0] , 200 + ($quick[1] * 5))
;~ 							;ConsoleWrite(200 + (StringLen($split[6]) * 4) & @LF)
;~ 						Else
;~ 							;ConsoleWrite($item & @LF)
;~ 							$quick = _IniDecode($item)
;~ 							CreateSubWindow($item, $quick[0], 200 + ($quick[1] * 5))
;~ 							;ConsoleWrite(200 + (StringLen($item) * 4) & @LF)
;~ 						EndIf
					EndIf
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func SearchMagicItems($customs = "Default", $iSearch = 0)
	;;Sect[ITEM][0] = Magic Item Name
	;[ITME][1] = Type
	;[ITME][2] = Rarity
	;[ITME][3] = Attunement
	;[ITME][4] = Notes
	;[ITME][5] = Source
	_GUICtrlListView_DeleteAllItems($idListview)

	Local $listCount = 0

	$secT = IniReadSection($basicIni, "MagicItems")
	Dim $itArray[$secT[0][0]][7]
	;_ArrayDisplay($secT)
	If @NumParams < 2 Then
		ConsoleWrite("Customs = " & $customs &@LF)
		For $j = 1 To $secT[0][0]

			$itArray[$listCount][0] = $secT[$j][0]
			_GUICtrlListView_AddItem($idListview, $itArray[$listCount][0])

			$iSplit = StringSplit($secT[$j][1], "\\", 1)
			$itArray[$listCount][1] = $iSplit[1]
			$itArray[$listCount][2] = $iSplit[2]
			$itArray[$listCount][3] = $iSplit[3]
			$itArray[$listCount][4] = $iSplit[4]
			$itArray[$listCount][5] = $iSplit[5]
			If $iSplit[0] = 6 Then
				$itArray[$listCount][6] = $iSplit[6]
			Else
				$itArray[$listCount][6] = $itArray[$listCount][0]
			EndIf
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[1], 1)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[2], 2)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[3], 3)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[4], 4)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[5], 5)
			$listCount += 1

		Next
		if $customs <> "Default" Then

			if FileExists($custIni) Then

				ConsoleWrite("BOOYAH")
				$UB = UBound($itArray)
				$secT = IniReadSection($custIni,"Index")

				ReDim $itArray[$UB+$secT[0][0]][7]
				;_ArrayDisplay($itArray)
				For $j = 1 To $secT[0][0]

					$itArray[$listCount][0] = $secT[$j][0]
					_GUICtrlListView_AddItem($idListview, $itArray[$listCount][0])

					$iSplit = StringSplit($secT[$j][1], "\\", 1)
					$itArray[$listCount][1] = $iSplit[1]
					$itArray[$listCount][2] = $iSplit[2]
					$itArray[$listCount][3] = $iSplit[3]
					$itArray[$listCount][4] = $iSplit[4]
					$itArray[$listCount][5] = $iSplit[5]

						$itArray[$listCount][6] = "CUSTOMITEM"

					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[1], 1)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[2], 2)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[3], 3)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[4], 4)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[5], 5)
					$listCount += 1

				Next
			EndIf

		EndIf
		Return $itArray
	Else

		;;Sect[ITEM][0] = Magic Item Name
		;[ITME][1] = Type
		;[ITME][2] = Rarity
		;[ITME][3] = Attunement
		;[ITME][4] = Notes
		;[ITME][5] = Source
		For $i = 0 To UBound($itemArray) - 1
			Local $include = True
			For $j = 0 To UBound($iSearch) - 1
				Switch $iSearch[$j][1]
					Case "Magic Item Name"
						If Not (StringInStr($itemArray[$i][0], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Type"
						If Not (StringInStr($itemArray[$i][1], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Rarity"
						If Not ($itemArray[$i][2] = $iSearch[$j][0]) Then
							$include = False
							ExitLoop
						EndIf
					Case "Attunement"
						If Not (StringInStr($itemArray[$i][3], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Custom Items"
						if $itemArray[$i][6] = "CUSTOMITEM" Then
							if $iSearch[$j][0] = "No" Then
								$include = False
								ExitLoop
							EndIf
							Else
							if $iSearch[$j][0] = "Only" Then
								$include = False
								ExitLoop
								EndIf
						EndIf
					Case "Notes"
						If Not (StringInStr($itemArray[$i][4], $iSearch[$j][0])) Then
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
				$listCount += 1
			EndIf
		Next
	EndIf

EndFunc   ;==>SearchMagicItems

Func Update()
	$searchArray = 0
	Dim $searchArray[5][2]
	;;Sect[ITEM][0] = Magic Item Name
	;[ITME][1] = Type
	;[ITME][2] = Rarity
	;[ITME][3] = Attunement
	;[ITME][4] = Notes
	;[ITME][5] = Source
	$qCount = 0

	If GUICtrlRead($ihSearch) <> "" Then
		$searchArray[$qCount][1] = "Magic Item Name"
		$searchArray[$qCount][0] = GUICtrlRead($ihSearch)
		$qCount += 1
	EndIf
	If GUICtrlRead($cType) <> "Any" Then
		$searchArray[$qCount][1] = "Type"
		$searchArray[$qCount][0] = GUICtrlRead($cType)
		$qCount += 1
	EndIf
	If GUICtrlRead($cRarity) <> "Any" Then
		$searchArray[$qCount][1] = "Rarity"
		$searchArray[$qCount][0] = GUICtrlRead($cRarity)
		$qCount += 1
	EndIf
	If GUICtrlRead($cAttune) <> "Any" Then
		$searchArray[$qCount][1] = "Attunement"
		$searchArray[$qCount][0] = GUICtrlRead($cAttune)
		$qCount += 1
	EndIf
	If GUICtrlRead($cCustom) <> "Any" Then
		$searchArray[$qCount][1] = "Custom Items"
		$searchArray[$qCount][0] = GUICtrlRead($cCustom)
		$qCount += 1
	EndIf
	If GUICtrlRead($iNotes) <> "" Then
		$searchArray[$qCount][1] = "Notes"
		$searchArray[$qCount][0] = GUICtrlRead($iNotes)
		$qCount += 1
	EndIf

	;_ArrayDisplay($searchArray)
	If $qCount > 0 Then
		ConsoleWrite("Qcount > 0" & @LF)
		ReDim $searchArray[$qCount][2]
		_GUICtrlSetState($GUI_DISABLE)
		SearchMagicItems("Yes", $searchArray)
		_GUICtrlSetState($GUI_ENABLE)
	Else
		ConsoleWrite("Qcount = 0" & @LF)
		_GUICtrlSetState($GUI_DISABLE)
		$itemArray = SearchMagicItems("Yes")
		_GUICtrlSetState($GUI_ENABLE)
	EndIf
EndFunc   ;==>Update

Func _IniDecode($iSection, $iniType = "Complete")
	ConsoleWrite("Initype = " & $iniType &@LF)
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

	if $iniType = "Complete" Then
		$iniData = IniReadSection($completeIni, $iSection)
	Elseif $iniType = "Custom" Then
		$iniData = IniReadSection($custIni, $iSection)
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
			Case StringInStr($iniData[$i][0], "TableTitle") Or StringInStr($iniData[$i][0], "TableColumns")
				$j = $i
				$longestStr = 0
				$colInt = 0
				$tabInt = 0
				$tableArray = 0
				$tableItems = 0
				$colLengths = 0
				Dim $tableArray[200][10]

				Do
					If StringInStr($iniData[$j][0], "Table") Then
						If StringInStr($iniData[$j][0], "TableTitle") Then
							$longestStr = StringLen($iniData[$j][1]) + 2
							$tableArray[0][1] = $iniData[$j][1]
							;ConsoleWrite($tableArray[0][1] & @LF)
						ElseIf StringInStr($iniData[$j][0], "TableColumns") Then

							$colSplit = StringSplit($iniData[$j][1], "\\", 1)

							Dim $colLengths[$colSplit[0]]
							For $a = 1 To $colSplit[0]
								$tableArray[1][$a - 1] = $colSplit[$a]
								;ConsoleWrite("Column " & $a & " is " & $tableArray[1][$a - 1] & @LF)

								$colLengths[$a - 1] = StringLen($tableArray[1][$a - 1])

							Next

						Else
							$tabItemSplit = StringSplit($iniData[$j][1], "\\", 1)
							$tableItems += 1

							For $a = 1 To $tabItemSplit[0]
								$tableArray[$tableItems + 1][$a - 1] = $tabItemSplit[$a]
								;ConsoleWrite("Item " & $tableItems & " column " & $a & " is " & $tableArray[$tableItems + 1][$a - 1] & @LF)

								If StringLen($tableArray[$tableItems + 1][$a - 1]) > $colLengths[$a - 1] Then $colLengths[$a - 1] = StringLen($tableArray[$tableItems + 1][$a - 1])

							Next

						EndIf
						;ConsoleWrite($iniData[$j][0] &@LF)
					EndIf
					;Add to Array in here maybe instead? Can't tell at the moment if its better to do Longest Str first or not?
					; You would probably need array because Columns\Items need +3 inbetween each column where as a Title only needs +2 on either side
					$j += 1
				Until ($j > $iniData[0][0] Or StringInStr($iniData[$j][0], "Table") = 0)
				if NOT ($j > $iniData[0][0]) Then
					$i = $j-1
				Else
					$i = $j
				EndIf
				$colInt = 1
				For $j = 0 To UBound($colLengths) - 1
					$colint += $colLengths[$j]
					If $j = UBound($colLengths) - 1 Then
						$colInt += 1
					Else
						$colInt += 3
					EndIf
				Next

				If $colInt > $longestStr Then
					$longestStr = $colInt
				Else
					$j = $colint
					$z = 0
					Do
						if $z > UBound($colLengths) - 1 Then $z = 0
							$colLengths[$z] += 1
							$j +=1
							$z +=1

					Until $j > $longestStr-1
				EndIf

				ReDim $tableArray[$tableItems + 2][$colSplit[0]]
				$tableArray[0][0] = $tableItems
				If $tableArray[0][1] <> "" Then
					$retString &= "+"
					For $j = 1 To $longestStr
						$retString &= "-"
					Next
					$retString &= "+" & @CRLF & "+"
					$titleSpace = ($longestStr - StringLen($tableArray[0][1])) / 2
					For $j = 1 To Ceiling($titleSpace)
						$retString &= " "
					Next
					$retString &= $tableArray[0][1]
					For $j = 1 To Floor($titleSpace)
						$retString &= " "
					Next
					$retString &= "+" & @CRLF
				EndIf
				$retString&= "+"
					For $j = 1 To $longestStr
						$retString &= "-"
					Next
					$retString &= "+" & @CRLF
				For $j = 1 To $tableItems + 1
					$retString &= "|"

					For $a = 0 To UBound($tableArray, 2) - 1
						$itemSpace = ($colLengths[$a] - StringLen($tableArray[$j][$a])) / 2
						For $z = 0 To Floor($itemSpace)
							$retString &= " "
						Next
						$retString &= $tableArray[$j][$a]
						For $z = 0 To Ceiling($itemSpace)
							$retString &= " "
						Next

						If Not ($a = UBound($tableArray, 2) - 1) Then $retString &= "|"
					Next
					$retString &= "|" & @CRLF
					if $j =1 Then
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
					$retString &= "+--------------+" & @CRLF
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
	if $longestStr > $titleLen Then $titleLen = $longestStr
	Dim $retArray[2] = [$retString,$titleLen]
	Return $retArray
EndFunc   ;==>_IniDecode

Func CreateSubWindow($iTitle, $iData, $iWidth = 250, $iReadOnly = True)
	;; For additional windows have an Array structured as per below
	;$windows[X][0] = WindowHandle
	;$windows[X][1] = Full Data (Returned from whatever Generator was used)
	;$windows[X][2] = Allow Edit (Button with Toggle)
	;$windows[X][3] = Reset Data (Button to reset Input to [x][1])
	;$windows[X][5] = Input Handle
	;$windows[X][4] = Save Button? (Save current to .txt)
	;$windows[X][6] = Allow Edit Value (True/False) ??
	Local $height, $width
	GUISetState(@SW_DISABLE, $hGUI)

	$subWindows += 1


	ReDim $hSubs[$subWindows + 1][8]

	$hSubs[$subWindows][0] = GUICreate($iTitle, $iWidth, 300, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

	$hSubs[$subWindows][1] = $iData

	$hSubs[$subWindows][2] = GUICtrlCreateIcon($iconsIcl, 3, 10, 230);;Lock\Unlock
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Unlock the workspace for editing" & @LF & "Useful for Picking and choosing loot or releasing over time", "Unlock\Lock Workspace")

	$hSubs[$subWindows][3] = GUICtrlCreateIcon($iconsIcl, 4, 40, 230);Reset WorkSpace
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Reset the text to it's default state" & @LF _
			 & "(How it was generated)", "Reset Workspace")

	$hSubs[$subWindows][4] = GUICtrlCreateIcon($iconsIcl, 1, 70, 230);Save
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Save current text to a text file for later viewing", "Save")

	$hSubs[$subWindows][6] = $iReadOnly

	$hSubs[$subWindows][7] = $iTitle

	If $iReadOnly Then
		$styles = BitOR($ES_READONLY, $ES_MULTILINE, $WS_VSCROLL)
	Else
		$styles = BitOR($ES_MULTILINE, $WS_VSCROLL)
	EndIf

	$hSubs[$subWindows][5] = GUICtrlCreateEdit($iData, 5, 5, $iWidth - 10, 210, $styles)
	GUICtrlSetFont(-1, 9, 400, -1, "Consolas")


	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

	GUISetState()

	GUISetState(@SW_ENABLE, $hGUI)
EndFunc   ;==>CreateSubWindow
