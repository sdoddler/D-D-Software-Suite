#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=dnd_icon.ico
#AutoIt3Wrapper_Outfile=..\Spell Sort.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Editconstants.au3>
#include <GuiListView.au3>
#include <IniEx.au3>
#include <Array.au3>
#include <GuiMenu.au3>
#include <ComboConstants.au3>;; Include in source



$winWidth = 765
$winHeight = 400


$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)

FileInstall(".\SearchParams.ini", $appDir & "SearchParams.ini", 0)
FileInstall(".\DnD Spell List.txt", $appDir & "DnD Spell List.txt", 0)
FileInstall(".\Classes.txt", $appDir & "Classes.txt", 0)

FileInstall(".\Steam_Icon.ico", $appDir & "Steam_Icon.ico", 0)
FileInstall(".\Twitter_Icon.ico", $appDir & "Twitter_Icon.ico", 0)
FileInstall(".\Youtube_icon.ico", $appDir & "Youtube_icon.ico", 0)
FileInstall(".\Github_icon.ico", $appDir & "Github_icon.ico", 0)

FileInstall(".\Icons.icl", $appDir & "Icons.icl", 0)

$sParamsIni = $appDir & "SearchParams.ini"
$rIni = $appDir & "DnD Spell List.txt"
$classesTxt = $appDir & "Classes.txt"
$iconsIcl = $appDir & "Icons.icl"

Global $debug = 0, $searchArray = 0, $ToolTipActive = False, $descWindows = 0, $hDescripts[0], $active = False, $subWindows = 0, $hSubs[0]

Global Enum $idproc1 = 1000, $winTitle = "D&D Spell Sort"

$hGUI = GUICreate($winTitle, $winWidth, $winHeight, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)



;$tempArray = IniReadSection("SearchParams.ini","Schools")
$Schools = "Any" & _ArrayToString(IniReadSection($sParamsIni, "Schools"), "|", 0, 0, "|", 1)
$Levels = "Any" & _ArrayToString(IniReadSection($sParamsIni, "Levels"), "|", 0, 0, "|", 1)
$Rituals = "Any" & _ArrayToString(IniReadSection($sParamsIni, "Rituals"), "|", 0, 0, "|", 1)
$castTimes = "Any" & _ArrayToString(IniReadSection($sParamsIni, "Cast Times"), "|", 0, 0, "|", 1)
$Ranges = "Any" & _ArrayToString(IniReadSection($sParamsIni, "Ranges"), "|", 0, 0, "|", 1)
$Components = "Any" & _ArrayToString(IniReadSection($sParamsIni, "Components"), "|", 0, 0, "|", 1)
$Durations = "Any" & _ArrayToString(IniReadSection($sParamsIni, "Durations"), "|", 0, 0, "|", 1)
$Classes = "Any|" & _ArrayToString(IniReadSectionNames($classesTxt), "|", 1, 0, "|", 1)

GUICtrlCreateGroup("", 5, 1, 590, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Spell Name", 10, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$ihSearch = GUICtrlCreateInput("", 10, 15, 100, -1, $ES_AUTOHSCROLL)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Level", 125, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cLevel = GUICtrlCreateCombo("", 130, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Levels, "Any")

GUICtrlCreateLabel("School", 245, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cSch = GUICtrlCreateCombo("", 250, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Schools, "Any")

GUICtrlCreateLabel("Ritual", 365, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cRit = GUICtrlCreateCombo("", 370, 15, 100) ; Yes/no
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Rituals, "Any")

GUICtrlCreateLabel("Cast Time", 485, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cCast = GUICtrlCreateCombo("", 490, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $castTimes, "Any")

GUICtrlCreateGroup("", 5, 40, 695, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Range", 10, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cRange = GUICtrlCreateCombo("", 10, 54, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Ranges, "Any")

GUICtrlCreateLabel("Components", 130, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cComp = GUICtrlCreateCombo("", 130, 54, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Components, "Any")

GUICtrlCreateLabel("Duration", 250, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cDur = GUICtrlCreateCombo("", 250, 54, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Durations, "Any")

GUICtrlCreateLabel("Class", 370, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cClass = GUICtrlCreateCombo("", 370, 54, 100,-1,$CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Classes, "Any")

$bUpdate = GUICtrlCreateButton("Update", 490, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$bClear = GUICtrlCreateButton("Clear", 595, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

Local $iItem = 0

Local $dummy_proc1 = GUICtrlCreateDummy()

Local $hMenu = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hMenu, 0, "View Full Components\Description", $idproc1)

Local $iStylesEx = BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT)
$idListview = GUICtrlCreateListView("", 10, 90, $winWidth - 20, 280, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT))
_GUICtrlListView_SetExtendedListViewStyle($idListview, $iStylesEx)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

_GUICtrlListView_AddColumn($idListview, "Spell Name", 120)
_GUICtrlListView_AddColumn($idListview, "Level", 60)
_GUICtrlListView_AddColumn($idListview, "School", 100)
_GUICtrlListView_AddColumn($idListview, "Ritual", 45)
_GUICtrlListView_AddColumn($idListview, "Cast Time", 100)
_GUICtrlListView_AddColumn($idListview, "Range", 100)
_GUICtrlListView_AddColumn($idListview, "Components", 60)
_GUICtrlListView_AddColumn($idListview, "Duration", 80)
_GUICtrlListView_AddColumn($idListview, "Description", 100)


$gSteamIcon = GUICtrlCreateIcon($appDir & "Steam_Icon.Ico", -1, 600, 5, 32, 32)
GUICtrlSetTip($gSteamIcon, " ", "sDoddler's Steam Profile")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1,0)
$gTwitterIcon = GUICtrlCreateIcon($appDir & "Twitter_Icon.Ico", -1, 640, 5, 32, 32)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1,0)
GUICtrlSetTip($gTwitterIcon, " ", "sDoddler's Twitter Page")
$gYoutubeIcon = GUICtrlCreateIcon($appDir & "Youtube_Icon.Ico", -1, 680, 5, 32, 32)
GUICtrlSetTip($gYoutubeIcon, " ", "sDoddler's YouTube Channel")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1,0)
$gGithubIcon = GUICtrlCreateIcon($appDir & "github_icon.Ico", -1, 720, 5, 32, 32)
GUICtrlSetTip($gGithubIcon, " ", "DnD Sort Github Page")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1,0)


#CS Columns
	[0] Spell Name	[1]Level	[2]School	[3]Ritual	[4]Cast Time	[5]Range	[6]Components	[7]Duration
#CE



#Region Creating SearchOptions.ini (Commented Out.)
#CS
	$schoolArray = _ReadAttribute($rIni, "School")
	_ArrayQuickWrite($schoolArray,"Schools")

	$levelArray = _ReadAttribute($rIni, "Level")
	_ArrayQuickWrite($levelArray,"Levels")

	$RitualArray = _ReadAttribute($rIni, "Ritual")
	_ArrayQuickWrite($RitualArray,"Rituals")

	$ctArray = _ReadAttribute($rIni, "Casting Time")
	_ArrayQuickWrite($ctArray,"Cast Times")

	$RangeArray = _ReadAttribute($rIni, "Range")
	_ArrayQuickWrite($RangeArray,"Ranges")

	$ComponentsArray = _ReadAttribute($rIni, "Components")
	_ArrayQuickWrite($ComponentsArray,"Components")

	$DurationArray = _ReadAttribute($rIni, "Duration")
	_ArrayQuickWrite($DurationArray,"Durations")
#CE
#EndRegion Creating SearchOptions.ini (Commented Out.)

GUISetState()
_GUICtrlSetState($GUI_DISABLE)
$SpellArray = _SearchSpells()
_GUICtrlSetState($GUI_ENABLE)
If WinActive($winTitle) Then HotKeySet("{ENTER}", "Update")
;_ArrayDisplay($SpellArray)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

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

	$msg = GUIGetMsg(1)
	Switch $msg[1]

		Case $hGUI

			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $idListview
					_GUICtrlListView_SortItems($idListview, GUICtrlGetState($idListview))
				Case $dummy_proc1
					CreateSubWindow(_GUICtrlListView_GetItemText($idListview, $iItem));,_GUICtrlListView_GetItemText($idListview, $iItem,6),_GUICtrlListView_GetItemText($idListview, $iItem,8))
					;MsgBox(64,_GUICtrlListView_GetItemText($idListview, $iItem),"Components: " &_GUICtrlListView_GetItemText($idListview, $iItem,6) & @LF & @LF & "Description: " & _GUICtrlListView_GetItemText($idListview, $iItem,8))
				Case $bUpdate
					Update()
				Case $bClear
					GUICtrlSetData($cCast, "")
					GUICtrlSetData($cComp, "")
					GUICtrlSetData($cDur, "")
					GUICtrlSetData($cLevel, "")
					GUICtrlSetData($cRange, "")
					GUICtrlSetData($cRit, "")
					GUICtrlSetData($cSch, "")
					GUICtrlSetData($cClass, "")
					GUICtrlSetData($cCast, $castTimes, "Any")
					GUICtrlSetData($cComp, $Components, "Any")
					GUICtrlSetData($cDur, $Durations, "Any")
					GUICtrlSetData($cLevel, $Levels, "Any")
					GUICtrlSetData($cRange, $Ranges, "Any")
					GUICtrlSetData($cRit, $Rituals, "Any")
					GUICtrlSetData($cSch, $Schools, "Any")
					GUICtrlSetData($cClass, $Classes, "Any")
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
	If $ToolTipActive Then
		_ToolCheck()
	EndIf
WEnd



Func CreateSubWindow($iTitle, $iData = "", $iWidth = 250, $iReadOnly = True)
	;; For additional windows have an Array structured as per below
	;$windows[X][0] = WindowHandle
	;$windows[X][1] = Full Data (Returned from whatever Generator was used)
	;$windows[X][2] = Allow Edit (Button with Toggle)
	;$windows[X][3] = Reset Data (Button to reset Input to [x][1])
	;$windows[X][5] = Input Handle
	;$windows[X][4] = Save Button? (Save current to .txt)
	;$windows[X][6] = Allow Edit Value (True/False) ??
	Local $height, $width, $iComp, $iDesc
	GUISetState(@SW_DISABLE, $hGUI)

	$subWindows += 1


	ReDim $hSubs[$subWindows + 1][8]

	$hSubs[$subWindows][0] = GUICreate($iTitle, $iWidth, 300, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

	$iComp = IniRead($rIni, $iTitle, "Components", "")
	$iDesc = IniRead($rIni, $iTitle, "Description", "")

	$iComp = StringReplace($iComp, ".@CRLF", "." & @CRLF)
	$iComp = StringReplace($iComp, "@CRLF", " ")

	$iDesc = StringReplace($iDesc, ".@CRLF", "." & @CRLF)
	$iDesc = StringReplace($iDesc, "@CRLF", " ")

	$iData = "Components: " & $iComp & @CRLF & @CRLF & "Description: " & $iDesc

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
	;GUICtrlSetFont(-1, 9, 400, -1, "Consolas")


	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

	GUISetState()

	GUISetState(@SW_ENABLE, $hGUI)
EndFunc   ;==>CreateSubWindow

Func _SearchSpells($iSearch = 0)


	Local $listCount = 0
	;ConsoleWrite(@NumParams&@LF)

	_GUICtrlListView_DeleteAllItems($idListview)

	If @NumParams = 0 Then
		$rSec = _IniReadSectionNamesEx($rIni)
		Local $spArray[9][$rSec[0] + 1]
		$spArray[0][0] = $rSec[0]
		$LEL = TimerInit()
		For $i = 1 To $rSec[0]
			$spArray[0][$i] = $rSec[$i]
			_GUICtrlListView_AddItem($idListview, $spArray[0][$i])
			If $debug = 1 Then ConsoleWrite("$i = " & $i & @TAB & "- $rSec[$i] = " & $rSec[$i] & @TAB & @LF)
			$secArray = _IniReadSectionEx($rIni, $rSec[$i])

			If $secArray = 0 Then
				$secArray = IniReadSection($rIni, $rSec[$i])
			EndIf
			;If $i < 5 Then 	_ArrayDisplay($secArray)
			#CS List View Columns
				[0] Spell Name	[1]Level	[2]School	[3]Ritual	[4]Cast Time	[5]Range	[6]Components	[7]Duration	[8]Description
			#CE

			For $j = 1 To $secArray[0][0]
				Switch $secArray[$j][0]
					Case "Level"
						_GUICtrlListView_AddSubItem($idListview, $listCount, $secArray[$j][1], 1)
						$spArray[1][$i] = $secArray[$j][1]
					Case "School"
						_GUICtrlListView_AddSubItem($idListview, $listCount, $secArray[$j][1], 2)
						$spArray[2][$i] = $secArray[$j][1]
					Case "Ritual"
						_GUICtrlListView_AddSubItem($idListview, $listCount, $secArray[$j][1], 3)
						$spArray[3][$i] = $secArray[$j][1]
					Case "Casting Time"
						_GUICtrlListView_AddSubItem($idListview, $listCount, $secArray[$j][1], 4)
						$spArray[4][$i] = $secArray[$j][1]
					Case "Range"
						_GUICtrlListView_AddSubItem($idListview, $listCount, $secArray[$j][1], 5)
						$spArray[5][$i] = $secArray[$j][1]
					Case "Components"
						_GUICtrlListView_AddSubItem($idListview, $listCount, $secArray[$j][1], 6)
						$spArray[6][$i] = $secArray[$j][1]
					Case "Duration"
						_GUICtrlListView_AddSubItem($idListview, $listCount, $secArray[$j][1], 7)
						$spArray[7][$i] = $secArray[$j][1]
					Case "Description"
						$spArray[8][$i] = StringReplace($secArray[$j][1], "@CRLF", @CRLF)
						_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[8][$i], 8)

				EndSwitch
			Next

			$listCount += 1
		Next
		ConsoleWrite(TimerDiff($LEL))
		Return $spArray
	Else

		For $i = 1 To $SpellArray[0][0]
			Local $include = True
			For $j = 0 To UBound($iSearch) - 1
				Switch $iSearch[$j][1]
					Case "Spell Name"
						If Not (StringInStr($SpellArray[0][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Level"
						If Not (StringInStr($SpellArray[1][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "School"
						If Not (StringInStr($SpellArray[2][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Ritual"
						If Not (StringInStr($SpellArray[3][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Cast Time"
						If Not (StringInStr($SpellArray[4][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Range"
						If Not (StringInStr($SpellArray[5][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Components"
						If Not (StringInStr($SpellArray[6][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Duration"
						If Not (StringInStr($SpellArray[7][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Class"
						$classCorrect = False
						$classSpells = IniReadSection($classesTxt,$iSearch[$j][0])
						For $a = 1 to UBound($classSpells)-1
							if $classSpells[$a][0] = $SpellArray[0][$i] Then
								$classCorrect = True
								ExitLoop
							EndIf
						Next
						If $classCorrect Then
							ExitLoop
						Else
							$include = False
							ExitLoop
						EndIf
				EndSwitch
			Next
			If $include Then
				_GUICtrlListView_AddItem($idListview, $SpellArray[0][$i])
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[1][$i], 1)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[2][$i], 2)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[3][$i], 3)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[4][$i], 4)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[5][$i], 5)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[6][$i], 6)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[7][$i], 7)
				_GUICtrlListView_AddSubItem($idListview, $listCount, $SpellArray[8][$i], 8)
				$listCount += 1
			EndIf
		Next

	EndIf
EndFunc   ;==>_SearchSpells

Func _GUICtrlSetState($state)
	GUICtrlSetState($idListview, $state)
	GUICtrlSetState($cCast, $state)
	GUICtrlSetState($cComp, $state)
	GUICtrlSetState($cDur, $state)
	GUICtrlSetState($cLevel, $state)
	GUICtrlSetState($cRange, $state)
	GUICtrlSetState($cRit, $state)
	GUICtrlSetState($cSch, $state)
	GUICtrlSetState($ihSearch, $state)
	GUICtrlSetState($bUpdate, $state)
	GUICtrlSetState($bClear, $state)
	GUICtrlSetState($cClass, $state)
EndFunc   ;==>_GUICtrlSetState

Func Update()
	$searchArray = 0
	Dim $searchArray[9][2]
	#CS List View Columns
		[0] Spell Name	[1]Level	[2]School	[3]Ritual	[4]Cast Time	[5]Range	[6]Components	[7]Duration	[8]Description
	#CE
	$qCount = 0
	If GUICtrlRead($ihSearch) <> "" Then
		$searchArray[$qCount][1] = "Spell Name"
		$searchArray[$qCount][0] = GUICtrlRead($ihSearch)
		$qCount += 1
	EndIf
	If GUICtrlRead($cLevel) <> "Any" Then
		$searchArray[$qCount][1] = "Level"
		$searchArray[$qCount][0] = GUICtrlRead($cLevel)
		$qCount += 1
	EndIf
	If GUICtrlRead($cSch) <> "Any" Then
		$searchArray[$qCount][1] = "School"
		$searchArray[$qCount][0] = GUICtrlRead($cSch)
		$qCount += 1
	EndIf
	If GUICtrlRead($cRit) <> "Any" Then
		$searchArray[$qCount][1] = "Ritual"
		$searchArray[$qCount][0] = GUICtrlRead($cRit)
		$qCount += 1
	EndIf
	If GUICtrlRead($cCast) <> "Any" Then
		$searchArray[$qCount][1] = "Cast Time"
		$searchArray[$qCount][0] = GUICtrlRead($cCast)
		$qCount += 1
	EndIf
	If GUICtrlRead($cRange) <> "Any" Then
		$searchArray[$qCount][1] = "Range"
		$searchArray[$qCount][0] = GUICtrlRead($cRange)
		$qCount += 1
	EndIf
	If GUICtrlRead($cComp) <> "Any" Then
		$searchArray[$qCount][1] = "Components"
		$searchArray[$qCount][0] = GUICtrlRead($cComp)
		$qCount += 1
	EndIf
	If GUICtrlRead($cDur) <> "Any" Then
		$searchArray[$qCount][1] = "Duration"
		$searchArray[$qCount][0] = GUICtrlRead($cDur)
		$qCount += 1
	EndIf
	If GUICtrlRead($cClass) <> "Any" Then
		$searchArray[$qCount][1] = "Class"
		$searchArray[$qCount][0] = GUICtrlRead($cClass)
		$qCount += 1
	EndIf
	If $qCount > 0 Then
		ReDim $searchArray[$qCount][2]
		_GUICtrlSetState($GUI_DISABLE)
		_SearchSpells($searchArray)
		_GUICtrlSetState($GUI_ENABLE)
	Else
		_GUICtrlSetState($GUI_DISABLE)
		$SpellArray = _SearchSpells()
		_GUICtrlSetState($GUI_ENABLE)
	EndIf
EndFunc   ;==>Update

#Region OLD FUNCS FOR SEARCH OPTION GENERATION
;~ Func _ReadAttribute($localIni, $localAttribute)
;~ 	$rSec = _IniReadSectionNamesEx($localIni)

;~ 	Local $AttrArray[$rSec[0]], $localCount = -1
;~ 	If $debug = 1 Then
;~ 		_ArrayDisplay($rSec)
;~ 	EndIf
;~ 	For $i = 1 To $rSec[0]
;~ 		$tempRead = IniRead($localIni, $rSec[$i], $localAttribute, "")

;~ 		If $tempRead = "" Then
;~ 			$tempRead = _IniReadEx($localIni, $rSec[$i], $localAttribute, "")
;~ 			If $tempRead = "" Then

;~ 				ConsoleWrite("Attribute = " & $localAttribute & @LF & $rSec[$i] & "=" & $tempRead & @LF)
;~ 			Else
;~ 				If not(_ArrayCheck($AttrArray,$tempRead)) Then
;~ 				$localCount += 1
;~ 				$AttrArray[$localCount] = $tempRead
;~ 				EndIf
;~ 			EndIf
;~ 			Else
;~ 		If not(_ArrayCheck($AttrArray,$tempRead)) Then
;~ 		$localCount += 1
;~ 		$AttrArray[$localCount] = $tempRead
;~ 		Endif
;~ 	EndIf
;~ 	Next
;~ 	Redim $AttrArray[$localCount+1]
;~ 	Return $AttrArray
;~ EndFunc   ;==>_ReadAttribute

;~ Func _ArrayCheck($iArray,$iValue)
;~ 	For $i = 0 to UBound($iArray)-1
;~ 		if $iArray[$i] = $iValue Then Return True
;~ 	Next
;~ 	Return False
;~ EndFunc

;~ Func _ArrayQuickWrite($iArray,$iSection)
;~ 	For $i = 0 to UBound($iArray)-1
;~ 		IniWrite("SearchOptions.ini",$iSection,$i,$iArray[$i])
;~ 	Next
;~ EndFunc

;~ Func _DescGui($itemName = "", $iComp = "", $iDesc = "")
;~ 	GUISetState(@SW_DISABLE, $hGUI)

;~ 	$descWindows += 1


;~ 	ReDim $hDescripts[$descWindows + 1]
;~ 	;$dGUI
;~ 	$hDescripts[$descWindows] = GUICreate($itemName, 250, 400, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)
;~ 	ConsoleWrite("Windows = " & $descWindows & @LF & "Current Handle = " & $hDescripts[$descWindows] & @LF)
;~ 	$iComp = IniRead($rIni, $itemName, "Components", "")
;~ 	$iDesc = IniRead($rIni, $itemName, "Description", "")

;~ 	$iComp = StringReplace($iComp, ".@CRLF", "." & @CRLF)
;~ 	$iComp = StringReplace($iComp, "@CRLF", " ")

;~ 	$iDesc = StringReplace($iDesc, ".@CRLF", "." & @CRLF)
;~ 	$iDesc = StringReplace($iDesc, "@CRLF", " ")

;~ 	GUICtrlCreateEdit("Components: " & $iComp & @CRLF & @CRLF & "Description: " & $iDesc, 5, 5, 240, 365, BitOR($ES_READONLY, $ES_MULTILINE, $WS_VSCROLL))
;~ 	;GUICtrlSetState(-1,$GUI_DISABLE) ;Shouldn't need this as READONLY does the same..
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

;~ 	GUISetState()

;~ 	GUISetState(@SW_ENABLE, $hGUI)
;~ EndFunc   ;==>_DescGui
#EndRegion OLD FUNCS FOR SEARCH OPTION GENERATION

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

	; structure to map $ilParam ($tNMHDR - see Help file)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam);, $tagNMLISTVIEW

	Switch $tNMHDR.IDFrom
		Case $idListview
			Switch $tNMHDR.Code
				Case $LVN_HOTTRACK
					ListView_HOTTRACK()
					Return 0
				Case $NM_DBLCLK
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					If $tInfo.Item > -1 Then
						$iItem = $tInfo.Item
						CreateSubWindow(_GUICtrlListView_GetItemText($idListview, $iItem))
					EndIf
					;MSGBOX(0,"","LOL")
				Case $NM_RCLICK
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					If $tInfo.Item > -1 Then
						$iItem = $tInfo.Item
						_GUICtrlMenu_TrackPopupMenu($hMenu, $hGUI)
					EndIf
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	; $iwParam contains the application messages that we defined earlier
	Switch $iwParam
		Case $idproc1
			GUICtrlSendToDummy($dummy_proc1)
	EndSwitch
EndFunc   ;==>WM_COMMAND

Func ListView_HOTTRACK()
	Local $HotItem = _GUICtrlListView_GetHotItem($idListview)
	If $HotItem <> -1 Then _ToolTipMouseExit($HotItem, _GUICtrlListView_GetItemText($idListview, $HotItem, 8), 12000, -1, -1, _GUICtrlListView_GetItemText($idListview, $HotItem))
EndFunc   ;==>ListView_HOTTRACK

Func _ToolTipMouseExit($ITEM, $TEXT, $TIME = -1, $x = -1, $y = -1, $TITLE = '', $ICON = 0, $OPT = '')
	If $TIME = -1 Then $TIME = 3000
	Global $start = TimerInit(), $pos0 = MouseGetPos(), $toolTime = $TIME, $toolITEM = $ITEM
	$ToolTipActive = True
	If ($x = -1) Or ($y = -1) Then
		ToolTip($TEXT, $pos0[0] + 1, $pos0[1] + 1, $TITLE, $ICON, $OPT)
	Else
		ToolTip($TEXT, $x + 1, $y + 1, $TITLE, $ICON, $OPT)
	EndIf

EndFunc   ;==>_ToolTipMouseExit

Func _ToolCheck()
	Sleep(100)
	$pos = MouseGetPos()

	If (TimerDiff($start) > $toolTime) Or _
			($toolITEM <> _GUICtrlListView_GetHotItem($idListview) Or _;; Add below back in if User wants the tooltip to follow closer.
			(Abs($pos[0] - $pos0[0]) > 30 Or _
			Abs($pos[1] - $pos0[1]) > 30)) Then

		ToolTip('')
		$ToolTipActive = False
	EndIf
EndFunc   ;==>_ToolCheck
