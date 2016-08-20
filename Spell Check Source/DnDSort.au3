#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Resources\Spell Sort\dnd_icon.ico
#AutoIt3Wrapper_Outfile=..\Spell Check.exe
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****



#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Editconstants.au3>
#include <GuiListView.au3>
#include <IniEx.au3>
#include <Array.au3>
#include <GuiMenu.au3>
#include <ComboConstants.au3>;; Include in source
#include "..\Resources\CustomCreator.au3"
#include "..\Resources\_RefreshCache.au3"

_RefreshCache()

$winWidth = 765
$winHeight = 420 ;; LELEL JST BLZ


$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)
DirCreate($appDir & "\Spell Sort Resources\")

#Region File Installs
FileInstall("..\Resources\Spell Sort\SearchParams.ini", $appDir & "Spell Sort Resources\SearchParams.ini", 0)
FileInstall("..\Resources\Spell Sort\Spells-Basic.ini", $appDir & "Spell Sort Resources\Spells-Basic.ini", 0)
FileInstall("..\Resources\Spell Sort\Spells-Complete.ini", $appDir & "Spell Sort Resources\Spells-Complete.ini", 0)
FileInstall("..\Resources\Spell Sort\Classes.txt", $appDir & "Spell Sort Resources\Classes.txt", 0)

FileInstall("..\Resources\Icons.icl", $appDir & "Icons.icl", 1)

#EndRegion File Installs

;~ FileInstall("..\Resources\Icons.icl", $appDir & "Icons.icl", 0)

$sParamsIni = $appDir & "Spell Sort Resources\SearchParams.ini"
$classesTxt = $appDir & "Spell Sort Resources\Classes.txt"
$iconsIcl = $appDir & "Icons.icl"
$prefIni = $appDir & "Preferences.ini"

$compIni = $appDir & "Spell Sort Resources\Spells-Complete.ini"
$basicIni = $appDir & "Spell Sort Resources\Spells-Basic.ini"

$start = TimerInit()


$pSpellIni = IniRead($prefIni, "Settings", "Custom Spells File", "")
If FileExists($pSpellIni) Then
	Global $custIni = $pSpellIni
ElseIf FileExists(@ScriptDir & "\Spells-Custom.ini") Then
	Global $custIni = @ScriptDir & "\Spells-Custom.ini"
Else
	Global $custIni = ""
EndIf
ConsoleWrite("CustINi = " & $custIni&@LF)

;$custIni = "C:\Work\Projects\Scripts\DND\Spells-Custom.ini"

Global $debug = 0, $searchArray = 0, $ToolTipActive = False, $descWindows = 0, $hDescripts[0], $active = False, $subWindows = 0, $hSubs[0], $DefaultSpells = 0

Global Enum $idproc1 = 1000, $idproc2 = 2000, $winTitle = "D&D Spell Check"

$hGUI = GUICreate($winTitle, $winWidth, $winHeight, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

$fileMenu = GUICtrlCreateMenu("File")
$fCustomCreator = GUICtrlCreateMenuItem("Create or Edit Custom Spells", $fileMenu)
GUICtrlCreateMenuItem("", $fileMenu)
$fSetSpells = GUICtrlCreateMenuItem("Set Custom Spells File",$fileMenu)
$fRestart = GUICtrlCreateMenuItem("Restart", $fileMenu)

$tempArray = IniReadSection($sParamsIni, "Schools")
$Schools = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)
$tempArray = IniReadSection($sParamsIni, "Levels")
$Levels = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)
$tempArray = IniReadSection($sParamsIni, "Rituals")
$Rituals = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)
$tempArray = IniReadSection($sParamsIni, "Cast Times")
$castTimes = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)
$tempArray = IniReadSection($sParamsIni, "Ranges")
$Ranges = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)
$tempArray = IniReadSection($sParamsIni, "Components")
$Components = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)
$tempArray = IniReadSection($sParamsIni, "Durations")
$Durations = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)
$tempArray = IniReadSectionNames($classesTxt)
$Classes = "Any|" & _ArrayToString($tempArray,"|", 1,UBound($tempArray)-1,"|",1,1)


$levelArray = IniReadSection($sParamsIni, "Levels")
$levelArray[0][1] = "Any"

#Region Search GUI

GUICtrlCreateGroup("", 5, 1, 590, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Spell Name", 10, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$ihSearch = GUICtrlCreateInput("", 10, 15, 100, -1, $ES_AUTOHSCROLL)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Level", 125, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cLevel = GUICtrlCreateCombo("", 130, 15, 50)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Levels, "Any")

$cLevel2 = GUICtrlCreateCombo("", 190, 15, 50)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Levels, "Any")

GUICtrlCreateLabel("School", 245, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cSch = GUICtrlCreateCombo("", 250, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Schools, "Any")

GUICtrlCreateLabel("Range", 365, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cRange = GUICtrlCreateCombo("", 370, 15, 100) ; Yes/no
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Ranges, "Any")

GUICtrlCreateLabel("Cast Time", 485, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cCast = GUICtrlCreateCombo("", 490, 15, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $castTimes, "Any")

GUICtrlCreateGroup("", 5, 40, 695, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Duration", 10, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cDur = GUICtrlCreateCombo("", 10, 54, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Durations, "Any")

GUICtrlCreateLabel("Class", 125, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cClass = GUICtrlCreateCombo("", 130, 54, 90, -1, $CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Classes, "Any")

GUICtrlCreateLabel("Ritual", 245, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cRit = GUICtrlCreateCombo("", 250, 54, 50, -1, $CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Rituals, "Any")

GUICtrlCreateLabel("Components", 310, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cComp = GUICtrlCreateCombo("", 315, 54, 60, -1, $CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $Components, "Any")

GUICtrlCreateLabel("Custom Spells", 385, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cCustom = GUICtrlCreateCombo("", 390, 54, 80, -1, $CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, "Any|Only|No", "Any")

$bUpdate = GUICtrlCreateButton("Update", 490, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$bClear = GUICtrlCreateButton("Clear", 595, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

#EndRegion Search GUI

Local $iItem = 0

Local $dummy_proc1 = GUICtrlCreateDummy()
Local $dummy_proc2 = GUICtrlCreateDummy()
Local $dummy_proc3 = GUICtrlCreateDummy()
Local $dummy_proc4 = GUICtrlCreateDummy()

Local Enum $idproc3 = 3000, $idproc4 = 4000

Local $hMenu = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hMenu, 0, "View Full Components\Description", $idproc1)
_GUICtrlMenu_InsertMenuItem($hMenu, 1, "Add new Custom Spell", $idproc4)

Local $hMenu2 = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hMenu2, 0, "View Full Components\Description", $idproc1)
_GUICtrlMenu_InsertMenuItem($hMenu2, 1, "Add new Custom Spell", $idproc4)
_GUICtrlMenu_InsertMenuItem($hMenu2, 1, "Delete Custom Spell", $idproc2)
_GUICtrlMenu_InsertMenuItem($hMenu2, 3, "Edit Custom Spell", $idproc3)

#Region List View Setup

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

#EndRegion List View Setup

#Region Social Media Icons
$gDiscordIcon = GUICtrlCreateIcon($iconsIcl, 27, 600, 5, 32, 32);$appDir & "Steam_Icon.Ico", -1, 360, 45, 32, 32)
GUICtrlSetTip($gDiscordIcon, " ", "sDoddler's Discord Server")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gTwitterIcon = GUICtrlCreateIcon($iconsIcl, 13, 640, 5, 32, 32)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip($gTwitterIcon, " ", "sDoddler's Twitter Page")
$gYoutubeIcon = GUICtrlCreateIcon($iconsIcl, 14, 680, 5, 32, 32)
GUICtrlSetTip($gYoutubeIcon, " ", "sDoddler's YouTube Channel")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gGithubIcon = GUICtrlCreateIcon($iconsIcl, 11, 720, 5, 32, 32)
GUICtrlSetTip($gGithubIcon, " ", "D&D Software Suite Github Page")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
#EndRegion Social Media Icons


#CS Columns
	[0] Spell Name	[1]Level	[2]School	[3]Ritual	[4]Cast Time	[5]Range	[6]Components	[7]Duration
#CE


GUISetState()
_GUICtrlSetState($GUI_DISABLE)
$SpellArray = CreateSpellArray()

_GUICtrlSetState($GUI_ENABLE)
If WinActive($winTitle) Then HotKeySet("{ENTER}", "Update")
;_ArrayDisplay($SpellArray)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

_GUICtrlListView_RegisterSortCallBack($idListview)
OnAutoItExitRegister("SavePreferences")

While 1
	If (WinActive($winTitle) = 0 And $active = True) Then ;; If window does not have window but it just did
		$active = False
		HotKeySet("{ENTER}")
		ConsoleWrite("SetHotkeysOff")

		ToolTip('')
		$ToolTipActive = False
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
				Case $dummy_proc2
					$delItem = _GUICtrlListView_GetItemText($idListview,$iItem)
					$iMsg = MsgBox(52, "Delete Item? ", "Are you sure you want to delete: " & $delItem & @LF & "At Location: " & $custIni)
							if $iMsg = 6 Then
								IniDelete($custIni,$delItem)
								IniDelete($custIni,"Index",$delItem)
								_GUICtrlListView_DeleteItem($idListview,$iItem)
								_GUICtrlSetState($GUI_DISABLE)
								$SpellArray = CreateSpellArray(False)
								_GUICtrlSetState($GUI_ENABLE)
							EndIf
				Case $dummy_proc3 ; Edit Custom Item
					$itemName = _GUICtrlListView_GetItemText($idListview, $iItem)
					For $i = 1 To $SpellArray[0][0]
						If $itemName = $spellArray[0][$i] Then ExitLoop
					Next
					ConsoleWrite($itemName & @LF)
					;_ArrayDisplay(IniRead($custIni, "Index", $itemName, ""))

					_CustomCreator($hGUI, $winTitle, "Spell", $itemName, IniRead($custIni, "Index", $itemName, ""), IniReadSection($custIni, $itemName))
$pSpellIni = IniRead($prefIni, "Settings", "Custom Spells File", "")
If FileExists($pSpellIni) Then
	Global $custIni = $pSpellIni
	EndIf
					_GUICtrlSetState($GUI_DISABLE)
					GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
					$SpellArray = CreateSpellArray(False)
					Update()
					_GUICtrlSetState($GUI_ENABLE)
				Case $dummy_proc4
					_CustomCreator($hGUI, $winTitle, "Spell")
					$pSpellIni = IniRead($prefIni, "Settings", "Custom Spells File", "")
If FileExists($pSpellIni) Then
	Global $custIni = $pSpellIni
	EndIf
					_GUICtrlSetState($GUI_DISABLE)
					GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
					$spellArray = CreateSpellArray(False)
					Update()
					_GUICtrlSetState($GUI_ENABLE)
				Case $bUpdate
					Update()
				Case $bClear
					_GUICtrlSetState($GUI_DISABLE)

					GUICtrlSetData($cCast, "")
					GUICtrlSetData($cComp, "")
					GUICtrlSetData($cDur, "")
					GUICtrlSetData($cLevel, "")
					GUICtrlSetData($cLevel2, "")
					GUICtrlSetData($cRange, "")
					GUICtrlSetData($cRit, "")
					GUICtrlSetData($cSch, "")
					GUICtrlSetData($cClass, "")
					GUICtrlSetData($cCustom,"")
					GUICtrlSetData($cCustom, "Any|Only|No", "Any")
					GUICtrlSetData($cCast, $castTimes, "Any")
					GUICtrlSetData($cComp, $Components, "Any")
					GUICtrlSetData($cDur, $Durations, "Any")
					GUICtrlSetData($cLevel, $Levels, "Any")
					GUICtrlSetData($cLevel2, $Levels, "Any")
					GUICtrlSetData($cRange, $Ranges, "Any")
					GUICtrlSetData($cRit, $Rituals, "Any")
					GUICtrlSetData($cSch, $Schools, "Any")
					GUICtrlSetData($cClass, $Classes, "Any")
					GUICtrlSetData($ihSearch, "")
					_GUICtrlSetState($GUI_ENABLE)
				Case $cLevel
					GUICtrlSetData($cLevel2, GUICtrlRead($cLevel))

				Case $gDiscordIcon
					ShellExecute('https://discord.gg/qkEGawD')
				Case $gTwitterIcon
					ShellExecute('https://twitter.com/sdoddler')
				Case $gYoutubeIcon
					ShellExecute('https://youtube.com/user/doddddy')
				Case $gGithubIcon
					ShellExecute('https://github.com/sdoddler/D-D-Software-Suite')
				Case $fRestart
					Restart()
				Case $fSetSpells
					if $custIni <> "" Then
						$iniSplit = StringSplit($custIni,"\")
						$iniRep = StringReplace($custIni,$iniSplit[$iniSplit[0]],"",-1)
						$pMagicItemIni = FileOpenDialog("Select the Custom Magic Item Ini Location", $iniRep,"Ini Files (*.ini)",1, $iniSplit[$iniSplit[0]])
					Else
					$pSpellIni = FileOpenDialog("Select the Custom Spell Ini Location", @ScriptDir, "Ini Files (*.ini)",1)
					EndIf
					if FileExists($pSpellIni) Then
						$custIni = $pSpellIni
						_GUICtrlSetState($GUI_DISABLE)

					$SpellArray = CreateSpellArray(False)
					Update()
					_GUICtrlSetState($GUI_ENABLE)
					EndIf

				Case $fCustomCreator
					if $ToolTipActive Then
						$ToolTipActive = False
					_Toolcheck()
					EndIf
					_CustomCreator($hGUI, $winTitle)
					$pSpellIni = IniRead($prefIni, "Settings", "Custom Spells File", "")
If FileExists($pSpellIni) Then
	Global $custIni = $pSpellIni
	EndIf
					_GUICtrlSetState($GUI_DISABLE)
					GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
					$SpellArray = CreateSpellArray(False)
					Update()
					_GUICtrlSetState($GUI_ENABLE)

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

Func SavePreferences()
	IniWrite($prefIni, "Settings", "Custom Spells File", $custIni)
EndFunc

Func Restart()
	If @Compiled Then
        Run(FileGetShortName(@ScriptFullPath))
    Else
        Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
	Exit
EndFunc

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

	$iData = _Titilise($iTitle)

	For $i = 1 To $SpellArray[0][0]
		If $SpellArray[0][$i] = $iTitle Then
			$iData &= "Components: " & $SpellArray[6][$i] & @CRLF & @CRLF & $SpellArray[8][$i]
			ExitLoop
		EndIf
	Next


	;$iData = "Components: " & $iComp & @CRLF & @CRLF & "Description: " & $iDesc

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

Func CreateSpellArray($redoList = True)

	Local $listCount = 0
	;ConsoleWrite(@NumParams&@LF)

	If $redoList Then _GUICtrlListView_DeleteAllItems($idListview)

		$LEL = TimerInit()
		$rSec = _IniReadSectionEx($basicIni, "Spells");_IniReadSectionNamesEx($rIni)
		Local $spArray[10][$rSec[0][0] + 1]
		$spArray[0][0] = $rSec[0][0]
		$DefaultSpells = $rSec[0][0]

		For $i = 1 To $rSec[0][0]
			$split = StringSplit($rSec[$i][1], "\\", 1)
			$spArray[0][$i] = $rSec[$i][0]

;~ 			ConsoleWrite($spArray[0][$i]&@LF)

			$spArray[1][$i] = $split[1]
			$spArray[2][$i] = $split[2]
			$spArray[3][$i] = $split[3]
			$spArray[4][$i] = $split[4]
			$spArray[5][$i] = $split[5]
			$spArray[6][$i] = $split[6]
			$spArray[7][$i] = $split[7]

			$quickDecode = _IniDecode($spArray[0][$i])

			$spArray[8][$i] = $quickDecode[0];StringReplace($secArray[$j][1], "@CRLF", @CRLF)

			;_ArrayDisplay($spArray)

			If $redoList Then
			_GUICtrlListView_AddItem($idListview, $spArray[0][$i])
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[1][$i], 1)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[2][$i], 2)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[3][$i], 3)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[4][$i], 4)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[5][$i], 5)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[6][$i], 6)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[7][$i], 7)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[8][$i], 8)
			EndIf
			$listCount += 1


		Next

		If FileExists($custIni) Then

			ConsoleWrite("BOOYAH")
			$UB = $spArray[0][0] + 1
			$secT = IniReadSection($custIni, "Index")

			If IsArray($secT) Then

				ReDim $spArray[10][$UB + $secT[0][0]]
				$spArray[0][0] = $UB + $secT[0][0] - 1
				;_ArrayDisplay($spArray)
				For $j = 1 To $secT[0][0]

					$spArray[0][$listCount + 1] = $secT[$j][0]
					$iSplit = StringSplit($secT[$j][1], "\\", 1)
					if $isplit[0] <> 7 Then ContinueLoop




					$spArray[1][$listCount + 1] = $iSplit[1]
					$spArray[2][$listCount + 1] = $iSplit[2]
					$spArray[3][$listCount + 1] = $iSplit[3]
					$spArray[4][$listCount + 1] = $iSplit[4]
					$spArray[5][$listCount + 1] = $iSplit[5]
					$spArray[6][$listCount + 1] = $iSplit[6]
					$spArray[7][$listCount + 1] = $iSplit[7]
					$quickDecode = _IniDecode($spArray[0][$i], "Custom")

					$spArray[8][$listCount + 1] = $quickDecode[0]
					;$spArray[9][$listCount+1] = $spArray[8][$listCount+1]



					if $redoList Then
					_GUICtrlListView_AddItem($idListview, $spArray[0][$listCount + 1])
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[1], 1)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[2], 2)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[3], 3)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[4], 4)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[5], 5)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[6], 6)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[7], 7)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $spArray[8][$listCount + 1], 8)
					EndIf
					$listCount += 1

				Next
			EndIf
		EndIf
		;ConsoleWrite(TimerDiff($LEL) &@LF)
		ConsoleWrite("Total Search Time - " & TimerDiff($LEL) & @LF)
		Return $spArray
EndFunc

Func _SearchSpells($iSearch = 0)

	_GUICtrlListView_DeleteAllItems($idListview)

	Local $listCount = 0
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
						Local $levelCheck = False
						$levelSplit = StringSplit($iSearch[$j][0], "\\", 1)
						If $levelSplit[1] = $levelSplit[2] Then
							If Not ($levelSplit[1] = $SpellArray[1][$i]) Then
								$include = False
								ExitLoop
							EndIf
						Else
							For $lev = 0 To UBound($levelArray) - 1
								If $levelSplit[1] = $levelArray[$lev][1] Then $levelCheck = Not ($levelCheck)

								If $levelCheck = False And $SpellArray[1][$i] = $levelArray[$lev][1] Then
									ConsoleWrite("ExitHittest" & @LF)
									$include = False
									ExitLoop

								EndIf

								If $levelSplit[2] = $levelArray[$lev][1] Then $levelCheck = Not ($levelCheck)
							Next
							If $include = False Then
								ExitLoop
							EndIf
						EndIf
;~ 						If Not (StringInStr($SpellArray[1][$i], $iSearch[$j][0])) Then
;~ 							$include = False
;~ 							ExitLoop
;~ 						EndIf
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
						Else
							$quicksplit = StringSplit($SpellArray[6][$i], " (", 1)
							If Not ($quicksplit[1] = $iSearch[$j][0]) Then
								$include = False
								ExitLoop
							EndIf
						EndIf
					Case "Duration"
						If Not (StringInStr($SpellArray[7][$i], $iSearch[$j][0])) Then
							$include = False
							ExitLoop
						EndIf
					Case "Class"
						$classCorrect = False
						$classSpells = IniReadSection($classesTxt, $iSearch[$j][0])
						For $a = 1 To UBound($classSpells) - 1
							If $classSpells[$a][0] = $SpellArray[0][$i] Then
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
					Case "Custom"

						If $iSearch[$j][0] = "Only" Then
							If $i <= $DefaultSpells Then
								$include = False
								ExitLoop
							EndIf
						ElseIf $iSearch[$j][0] = "No" Then
							If $i > $DefaultSpells Then
								$include = False
								ExitLoop
							EndIf
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

EndFunc   ;==>_SearchSpells

Func _GUICtrlSetState($state)
	if $state = $GUI_DISABLE Then
		GUISetState($hGUI,@SW_LOCK)
	EndIf
	GUICtrlSetState($idListview, $state)
	GUICtrlSetState($cCast, $state)
	GUICtrlSetState($cComp, $state)
	GUICtrlSetState($cDur, $state)
	GUICtrlSetState($cLevel, $state)
	GUICtrlSetState($cLevel2, $state)
	GUICtrlSetState($cRange, $state)
	GUICtrlSetState($cRit, $state)
	GUICtrlSetState($cSch, $state)
	GUICtrlSetState($ihSearch, $state)
	GUICtrlSetState($bUpdate, $state)
	GUICtrlSetState($bClear, $state)
	GUICtrlSetState($cClass, $state)
	GUICtrlSetState($cCustom, $state)
	GUICtrlSetState($fileMenu, $state)
	if $state = $GUI_ENABLE Then
		GUISetState($hGUI,@SW_UNLOCK)
	EndIf

EndFunc   ;==>_GUICtrlSetState

Func Update()
	$searchArray = 0
	Dim $searchArray[10][2]
	#CS List View Columns
		[0] Spell Name	[1]Level	[2]School	[3]Ritual	[4]Cast Time	[5]Range	[6]Components	[7]Duration	[8]Description
	#CE
	$qCount = 0
	If GUICtrlRead($ihSearch) <> "" Then
		$searchArray[$qCount][1] = "Spell Name"
		$searchArray[$qCount][0] = GUICtrlRead($ihSearch)
		$qCount += 1
	EndIf
	If GUICtrlRead($cLevel) <> "Any" And GUICtrlRead($cLevel2) <> "Any" Then
		$searchArray[$qCount][1] = "Level"
		$searchArray[$qCount][0] = GUICtrlRead($cLevel) & "\\" & GUICtrlRead($cLevel2)
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
	If GUICtrlRead($cCustom) <> "Any" Then
		$searchArray[$qCount][1] = "Custom"
		$searchArray[$qCount][0] = GUICtrlRead($cCustom)
		$qCount += 1
	EndIf
	If $qCount > 0 Then
		ReDim $searchArray[$qCount][2]
		_GUICtrlSetState($GUI_DISABLE)
		_SearchSpells($searchArray)
		_GUICtrlSetState($GUI_ENABLE)
	Else
		_GUICtrlSetState($GUI_DISABLE)
		$SpellArray = CreateSpellArray()
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
						For $i = 1 to $SpellArray[0][0]
							if $SpellArray[0][$i] = _GUICtrlListView_GetItemText($idListview,$iItem) Then
								ExitLoop
							EndIf
						Next
						If $i <= $DefaultSpells Then
						_GUICtrlMenu_TrackPopupMenu($hMenu, $hGUI)
						Else
						_GUICtrlMenu_TrackPopupMenu($hMenu2, $hGUI)
						EndIf
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
		Case $idproc2
			GUICtrlSendToDummy($dummy_proc2)
			Case $idproc3
			GUICtrlSendToDummy($dummy_proc3)
		Case $idproc4
			GUICtrlSendToDummy($dummy_proc4)
	EndSwitch
EndFunc   ;==>WM_COMMAND

Func ListView_HOTTRACK()
	Local $HotItem = _GUICtrlListView_GetHotItem($idListview)
	If $HotItem <> -1 And WinActive($winTitle) Then
		$hotItemText = _GUICtrlListView_GetItemText($idListview, $HotItem)
		For $i = 1 To $SpellArray[0][0]
			If $hotItemText = $SpellArray[0][$i] Then
				$hotItemNumber = $i
				ExitLoop
			EndIf
		Next
		If $SpellArray[9][$hotItemNumber] = "" Then
			#Region - Using Description to make tooltip
			$TEXT = $SpellArray[8][$hotItemNumber]
			If StringLen($TEXT) > 500 Then $TEXT = StringLeft($TEXT, 500) & "...." & @CRLF & "Double Click for more Info"
			$a = 0
			$count = 0
			Do

				$a += 1;; Need to fix this for the Manual CRLFs (Add an Additive somewhere so that u can check each character?)
				If StringMid($TEXT, $a, 1) = @CRLF Or StringMid($TEXT, $a, 1) = @LF Or StringMid($TEXT, $a, 1) = @CR Then;  = @CRLF Then
					$count = $a
				EndIf

				If $a > $count + 110 Then

					If Not (StringMid($TEXT, $a, 1) = " ") Then
						$j = 0
						Do
							$j += 1
						Until StringMid($TEXT, $a + $j, 1) = " " Or $a + $j > StringLen($TEXT)
						$TEXT = StringLeft($TEXT, $a + $j) & @CRLF & StringRight($TEXT, StringLen($TEXT) - $a - $j)
						$count = $a + $j
					Else
						$TEXT = StringLeft($TEXT, $a) & @CRLF & StringRight($TEXT, StringLen($TEXT) - $a)
						$count = $a
					EndIf

				EndIf
			Until $a > StringLen($TEXT) Or $a > 500
			$SpellArray[9][$hotItemNumber] = $TEXT

			#EndRegion - Using Description to make tooltip

		EndIf
		_ToolTipMouseExit($HotItem, $SpellArray[9][$hotItemNumber], 12000, -1, -1, $hotItemText)
	EndIf
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
	If WinActive($winTitle) = 0 Then
		ToolTip('')
		$ToolTipActive = False
	EndIf
EndFunc   ;==>_ToolCheck

Func _Titilise($iString)
	$titleLen = StringLen($iString)

	$retString = "+"
	For $i = 0 To $titleLen + 1
		$retString &= "~"
	Next
	$retString &= "+" & @CRLF
	$retString &= "| " & $iString & " |" & @CRLF
	$retString &= "+"
	For $i = 0 To $titleLen + 1
		$retString &= "~"
	Next
	$retString &= "+" & @CRLF

	Return $retString
EndFunc   ;==>_Titilise

Func _IniDecode($iSection, $iniType = "Complete")
	;ConsoleWrite("Initype = " & $iniType & @LF)
	Local $retString = "", $longestStr = 0

	$titleLen = StringLen($iSection)
	;ConsoleWrite($titleLen & @LF)



	If $iniType = "Complete" Then
		$iniData = IniReadSection($compIni, $iSection)
	ElseIf $iniType = "Custom" Then
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
	If $longestStr > $titleLen Then $titleLen = $longestStr
	Dim $retArray[2] = [$retString, $titleLen]
	Return $retArray
EndFunc   ;==>_IniDecode
