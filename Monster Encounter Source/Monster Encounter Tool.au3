#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Resources\Monster Encounter\Combat_Icon.ico
#AutoIt3Wrapper_Outfile=..\Monster & Combat Tool.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.12.0
	Author:         sDoddler

	Script Function:
	List Monsters of D&D 5e and allow users to see core Stats for easier encounters and DM handling.


	Allow for Homebrew. - Done? -- Add a "Creator" to quickly add NPCs and Monsters..
	- With this allow background windows to be used
	- Have a Save and Add another  Button
	- Have a "ListChanged = False" variable - When True refresh list (after Save or Cancel Clicked)

	Main Window Listview of Monsters
	- Listview with -- Unsure about Check Boxes
	- Sortable by columns and Combo's
	- Listbox or Listview with Current Monsters in encounter (if there are monsters there make Generate Encounter button available)
	- Preferences Menu with Random HP as option
	- Right Click "Edit Global Notes" (local Ini file with Global notes so that people can include vital information for each monster).
	- Right Click "Delete Global Notes"
	- Right Click "View Base Notes" -- This is just the Stats that are default global notes
	- Right Click "Add to encounter Queue"
	-


	Encounter Window
	- Use an Index to identify Monsters\PCs\NPCs so that if there is a name change it is still easy to identify.
	^^^Important^^^

	- SubGUI so that you can expand + have Scroll window when large amount of monsters are present.
	- SubGUI Hwnd to SubWindow Array
	- SubGUI Gui Ctrls in Array to SubWindow Array
	- Add new Monster(s) button (or Add to existing encounter button when Hsubs array > 1 - Selecting via Window Titles)
	- Disabled Label with Monster name (Cannot be edited). - Input so User can change, also Changes the Name in Initiative winodw
	- Rolls for Initiative, STR, DEX etc & Saving Throws.. (Buttons?)
	- HP Counter (When creating Encounter ask if Random Health or Default) - Updown + Input (Limit of MAX HP?)
	- Link this to initiative somehow
	- Dead \ Unconcious Graphic or Tickbox of some sort.. (to determine the difference between alive & dead monsters)
	- Show XP + Challenge Rating
	- Party Members Somewhere.


	Local notes for each Creature, possible to save Encounter & Load encounter. Would just have to do a quick read of all teh GUI and Save to ini file
	& read it back in.

	Initiative Window
	- Ability to add everything Manually
	- With the ability to "Title" X d Y + Z & Disadvantage\Adv.
	- Seperate "Title" and "Rolled Amount" for when player has rolled
	- Double Click list to edit
	- Grey\Red out Unconcious\Dead players and NPCs

	- Auto Add #2 #3 etc if name already exists
	- Manual Input Roll of 15 goes before AutoRoll

	- HP Area, Linked to Encounter roll, can be changed in either.


	Alex's Format Suggestion
	#1 Abraven 			|| 20
	#2 Goblin Swordsmen || 18
	etc.
	My THoughts
	#1 Abraven			|| 20 (19+1)
	Or
	#2 Goblin Swordsman || 18	|| (17+1) ? (Roll + Dex Modifier)

	- Add initative Function would have to support later input, I.e Sorting.
	- Maybe Array with "Roll" & Name, and the #1 is just added per List Item etc..


	Players Window
	- Launched from File or Windows Menu up the top
	- Add Player
	- Space for Each Skill Points (calc Modifiers)
	- HP (Max and Current)
	- AC
	- Iniative Space + add button
	- File > Load Players Option
	- Del Player Button


	Possible Array Logic:
	- $openEncounters[$x][4] = [[index (0)],["Encounter of the 3rd kind"],[$hwnd],[$encounterArray]
	- Name and Index of Encounter & $windowHandle
	- This should allow for renaming of the Encounter without issue, match the $hwnd & rename teh Title
	- $encounterArray = the Data of the $encounter in the window..

	- Maybe add an option for the amount of groups (for later easier sorting etc?)

	- $encounterArray[$x][] = [[index (0)],["Title\Name"],[Monster Type\Ini Reference],[HP(left)],[HP(max)],[Status(alive\uncon\dead)],[Ungrouped(Group?)],[Local Notes],[Initiative Modifier]]
	- No need for Global notes as you would need the Monster Type\Ini Reference for multi purpose and can pull Global notes via that.
	- When renaming characters, check ther are no conflicts and add (1) if there is
	- I may not need to do the above, since MonsterType\Ini Reference and Index are the reference points, it would not matter if two were named the same.

	- $playersArray[$x][13]= [[Index (0)],["name"],[Str],[dex],[con],[int],[wis],[cha],[speed?],[AC],[MaxHP],[Class?],[level?]]
	- Some of these may not be necessary..

	- $windowsArray[$x][2] = [[Index (0)],["Name"],[Type (Player\Encounter)],[File Location]] - Maybe add HWND? or Marker to say if it's active?
	- Use something like this so you can have multiple Windows launched,
	- Use Function to check "If file exists then add to array", otherwise delete from Ini Load so that it doesnt reload
	- Then have Windows Menu as Players - FileName & Encounter - Filename

	- $initiativeArray[$x][6] [[Index (0)],["Name"],[Type (Player\NPC or Monster\Manual)],[Relevant Index],[Current Initiative],[Dex mod]]
	- Unsure if Intiative Index is Required
	- Relevant Index to be used mostly for if a rename is parsed (from Player\NPC or Mosnter).


	To Do \ Fix
	- Sorting the Source column, is there a way to remove the mm and sort this via numbers and make sure 20 is sorted before 200
	- Sorting the CR column 1/2 comes before 1/8 *shrug* may not be able to resolve this issue..

	- Player stats tooltips are bugging out.
	- Add HP to initiative window.

	JUNE
	- Fix up Save so that you can choose where to save to. Add seperate save option to Players Window.
	- add seperate save window so you can select what to save (Players, Initiative and/or Encounter)

	- When Saving Check for "Manual Entry" or "Autoroll" if there and saving Initiative Delete these
	- If Type = Player and saving Player then delete these. Same for Encounter if Type = Encounter then delete these.

	- When doing the Encounter window Have "Stats & Local Notes" together, two seperate input boxes. As neither should need to be referenced that often
	- Also have stats as a hover item for each character.
	- Also add the HP rolled into Local Notes if the Randomise health option was ticked.
	- I think there was a tooltip bug somewhere in the initiative or players window (ask alex if he has noticed anything)
	- Create Encoutner window
	- Add "Players to initiative windows" button, that moves all of them over regardless of if their initiative has changed.


	--!! Add Save last Window\ Column Sizes option so that people can change things how they like etc.
	- Should be able to do this via WinGetPos and I assume _GUIListview_something


	-- JULY
	Working on Encounter window
	- Have the option for rolls to be "Message Box"
	- Also create a log window with all the recent messages
	- E.g. Goblin Rolled a Dex Saving throw (D20+5) and Rolled a 15 (10+5)


	- Stats \ Notes All in the same window, use a little table with a drop down for dice to do saving throws.
	Have seperate notes for Local and Global but leave them in the same window.

	Discord Link: https://discord.gg/qkEGawD

#ce ----------------------------------------------------------------------------


#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Editconstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <ColorConstants.au3>
#include <GuiMenu.au3>
#include <ComboConstants.au3>
#include <File.au3>
#include <StaticConstants.au3>
#include <GUIScrollbars.au3>
#include <GUIScrollbars_Ex.au3>
#include <WinAPISys.au3>
#include <GUIInputSetOnlyNumbers.au3>
#include "..\Resources\_RefreshCache.au3"
#include "..\Resources\DiceRoll.au3"

_RefreshCache()

#Region Global Vars & File Install
$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)
DirCreate($appDir & "Monster Encounter Resources")

$prefIni = $appDir & "Encounter Preferences.ini"
$iconsIcl = $appDir & "Icons.icl"

$globalNotesIni = $appDir & "GlobalNotes-Monsters.ini"

$pMonstersIni = IniRead($prefIni, "Settings", "Custom Encounter File", "")

If FileExists($pMonstersIni) Then
	Global $custIni = $pMonstersIni
ElseIf FileExists(@ScriptDir & "\Monsters-Custom.ini") Then
	Global $custIni = @ScriptDir & "\Monsters-Custom.ini"
Else
	Global $custIni = ""
EndIf

FileInstall("..\Resources\Icons.icl", $appDir & "Icons.icl", 1)

FileInstall("..\Resources\Monster Encounter\Monsters-Basic.txt", $appDir & "Monster Encounter Resources\Monsters-Basic.txt", 0)
FileInstall("..\Resources\Monster Encounter\Monsters-Complete.txt", $appDir & "Monster Encounter Resources\Monsters-Complete.txt", 0)

$monBasicIni = $appDir & "Monster Encounter Resources\Monsters-Basic.txt"
$monCompIni = $appDir & "Monster Encounter Resources\Monsters-Complete.txt"

Global $monGlobalNotes = "", $cLastFocus

Global $winTitle = "D&D Monster & Combat Tool"

Global $subWindows = 0
Global $hSubs[0]

Global $notesWindows = 0
Global $hNotes[0]

#Region Search Options
Global $types = "Any|Aberration|Beast|Celestial|Construct|Dragon|Elemental|Fey|Fiend|Giant|Humanoid|Monstrosity|Ooze|Plant|Undead"
Global $sizes = "Any|Tiny|Small|Medium|Large|Huge|Gargantuan"
Global $alignments = "Any|CE|CG|CN|LE|LG|LN|N|NE|NG|Unaligned"
Global $CRs = "Any|0|1/8|1/4|1/2|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|>17"
#EndRegion Search Options

#Region Working Encounter Array Variables
Dim $workingEncounter[0][3]
#EndRegion Working Encounter Array Variables



#Region INITIATIVE Window Variables
Global $initiativeActive = False, $hInitiative = -1239801, $hInitChild = -12839813, $initCurrHP, $hInitTurnDummy, $initSave, $initLoad
Global $initDexMod, $initDexModUD, $initManualInput, $initName, $initRolled, $initRolledUD, $initRollFor, $initAdd, $initList, $idLabel, $scrollState = False, $initiativeTitle = "Combat Window"
Global $hInitDummy, $aSize, $initChildTitle = "Combat Child Window", $initChildStyles, $initChildStyleEx, $initRefresh, $aStartSize[4], $initNextTurn, $initTurnIndex = -1, $initTurnValue = -1
Dim $initiativeArray[0][6], $initArr[0][0]
#EndRegion INITIATIVE Window Variables

#Region PLAYERS Window Variables
Global $enablePlayerRolling = False, $pSize, $playStartSize[4], $playChildStyles, $playChildStyleEx, $autoAddToInitiative = True, $playEditInt
Global $playersActive = False, $hPlayers = -12313, $hPlayersChild = -18392, $playersTitle = "Players Window", $playersChildTitle = "Players Child Window", $playCurrentlyEditing = False
Dim $playersArray[0][15], $playArr[0][0]
;GUI Globals Below
Global $poPlayerRoll, $poAutoAdd, $playChildSizeLabel, $playAdd, $playRefresh, $playEditSave, $playEditCancel, $hPlayDummy, $playSave, $playLoad
Global $playName, $playStr, $playDex, $playCon, $playInt, $playWis, $playCha, $playLevel, $playSpeed, $playMaxHP, $playAC, $playClasses, $playAddtoInitB
#EndRegion PLAYERS Window Variables

#Region ENCOUNTER Winodw Varialbes
Global $encoAddtoInitB, $encoActive = False, $encoArr, $encoChildSizeLabel, $encoChildStyleEx, $encoChildStyles, $encoChildTitle = "NPC Child Window"
Global $encoLoad, $encoSave, $encoStartSize, $encoTitle = "NPC Window", $encClearSelection
Global $hEncoDummy, $hEncounter = -182391, $hEncounterChild = -12397193
Global $encXPSplitTotal, $encXPParty, $encXPNewTotal, $encXPAddSub, $encXPMod, $encXPFromEnc, $encXPUP1, $encXPUP2
Dim $encounterArray[0][15], $encoArr[0][0]
#EndRegion ENCOUNTER Winodw Varialbes


#Region Save Window Variables
Global $saveWindow = -8848181, $currentSaveLocation, $currentLoadLocation
Global $cbSaveEncounter, $cbSaveInitiative, $cbSavePlayers, $bSaveChange, $bSaveCancel, $bSaveSAVE, $lSaveLocation
If IniRead($prefIni, "Settings", "LastSaveLocation", "") <> "" Then
	$currentSaveLocation = IniRead($prefIni, "Settings", "LastSaveLocation", 0)
	$currentLoadLocation = $currentSaveLocation
EndIf
;; Load Window Variables
Global $hLoadWindow = -1828101
Global $cbLoadEncounter, $cbLoadInitiative, $cbLoadPlayers, $bLoadCancel, $bLoadLoad, $bLoadChange, $lLoadLocation
#EndRegion Save Window Variables
#EndRegion Global Vars & File Install

#Region Read Ini Options
;~ Local $listviewWidth = IniRead($prefIni, "Window Size", "ListWidth", "n/a")
;~ Local $listviewHeight = IniRead($prefIni, "Window Size", "ListHeight","n/a")

Local $winWidth = IniRead($prefIni, "Window Size", "Width", "n/a")
Local $winHeight = IniRead($prefIni, "Window Size", "Height", "n/a")

Local $winLeft = IniRead($prefIni,"Window Size", "Left", -1)
Local $winTop = IniRead($prefIni,"Window Size", "Top", -1)

Local $listColWidth[10]
For $i = 0 To 9
	$listColWidth[$i] = IniRead($prefIni, "Window Size", $i, "n/a")
Next
#EndRegion Read Ini Options

#Region Main GUI and Menus
;~ Width=392
;~ Height=333 Min Size
;Window Width = 723
;~ Window Height = 462

ConsoleWrite(@DesktopHeight & @LF & @DesktopWidth & @LF)

if $winLeft > -1 Then
	if $winLeft > @DesktopWidth Then $winLeft = -1
EndIf
if $winTop > -1 Then
	if $winTop > @DesktopHeight OR $winTop < -1 Then $winLeft = -1
EndIf

If $winWidth = "n/a" Then $winWidth = 723
If $winHeight = "n/a" Then $winHeight = 462

If $winWidth < 392 Then $winWidth = 392
If $winHeight < 345 Then $winHeight = 345
$hMainGUI = GUICreate($winTitle, $winWidth, $winHeight, $winLeft, $winTop, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

$fileMenu = GUICtrlCreateMenu("File")
$fResetWindow = GUICtrlCreateMenuItem("Reset Window and Column Size", $fileMenu)
$fRestart = GUICtrlCreateMenuItem("Restart", $fileMenu)

;~ $windowsMenu = GUICtrlCreateMenu("Windows")
$wInitiative = GUICtrlCreateMenuItem("Combat Window", -1);, $windowsMenu)
$wPlayers = GUICtrlCreateMenuItem("Players Window", -1);, $windowsMenu)
$wEncounter = GUICtrlCreateMenuItem("NPC Window", -1);, $windowsMenu)
$wLaunchAll = GUICtrlCreateMenuItem("Launch All", -1)
#EndRegion Main GUI and Menus

#Region Right Click Menu

Global $defaultItems = 0
Global Enum $idproc1 = 1000, $idproc2 = 2000, $idproc3 = 3000, $idproc4 = 4000

Local $iItem = 0

Local $dummy_proc1 = GUICtrlCreateDummy()
Local $dummy_proc2 = GUICtrlCreateDummy()
Local $dummy_proc3 = GUICtrlCreateDummy()
Local $dummy_proc4 = GUICtrlCreateDummy()

Local $hMenu = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hMenu, 0, "View Full Components\Description", $idproc1)
_GUICtrlMenu_InsertMenuItem($hMenu, 1, "Add new Custom Item", $idproc4)

Local $hMenu2 = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hMenu2, 0, "View Full Components\Description", $idproc1)
_GUICtrlMenu_InsertMenuItem($hMenu2, 1, "Add new Custom Item", $idproc4)
_GUICtrlMenu_InsertMenuItem($hMenu2, 2, "Delete Custom Item", $idproc2)
_GUICtrlMenu_InsertMenuItem($hMenu2, 3, "Edit Custom Item", $idproc3)

#EndRegion Right Click Menu

#Region Search Gui

GUICtrlCreateGroup("", 5, 1, 510, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Monster Name", 10, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$ihSearch = GUICtrlCreateInput("", 10, 15, 100, -1, $ES_AUTOHSCROLL)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Size", 125, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cSize = GUICtrlCreateCombo("", 130, 15, 100, -1, $CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $sizes, "Any")

GUICtrlCreateLabel("Type", 245, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cType = GUICtrlCreateCombo("", 250, 15, 78)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $types, "Any")

GUICtrlCreateLabel("Alignment", 340, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cAlign = GUICtrlCreateCombo("", 345, 15, 60, -1, $CBS_DROPDOWNLIST) ; Yes/no
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $alignments, "Any")

GUICtrlCreateLabel("Custom Items", 420, 1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cCustom = GUICtrlCreateCombo("", 425, 15, 70, -1, $CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, "Any|Only|No", "Any")

GUICtrlCreateGroup("", 5, 40, 345, 39)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateLabel("Challenge Rating", 10, 40)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$cCR = GUICtrlCreateCombo("", 10, 54, 100, -1, $CBS_DROPDOWNLIST)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetData(-1, $CRs, "Any")

$bUpdate = GUICtrlCreateButton("Update", 125, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$bClear = GUICtrlCreateButton("Clear", 245, 50, 100)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

#EndRegion Search Gui

#Region Listview Creation
; $winWidth - 20, 280
Local $iStylesEx = BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT)
$idListview = GUICtrlCreateListView("", 10, 90, $winWidth - 20, $winHeight - 250, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT))
_GUICtrlListView_SetExtendedListViewStyle($idListview, $iStylesEx)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)
;;Sect[ITEM][0] = Monster Name - Text Search
;[ITME][1] = Size - Drop Down
;[ITME][2] = Type - Drop Down
;[ITME][3] = Tags
;[ITME][4] = Alignment - Drop Down
;[ITME][5] = CR - Drop Down
;[ITME][6] = XP
;[ITME][7] = HP
;[ITME][8] = Source

If $listColWidth[0] = "n/a" Then $listColWidth[0] = 120
If $listColWidth[1] = "n/a" Then $listColWidth[1] = 60
If $listColWidth[2] = "n/a" Then $listColWidth[2] = 75
If $listColWidth[3] = "n/a" Then $listColWidth[3] = 45
If $listColWidth[4] = "n/a" Then $listColWidth[4] = 50
If $listColWidth[5] = "n/a" Then $listColWidth[5] = 30
If $listColWidth[6] = "n/a" Then $listColWidth[6] = 45
If $listColWidth[7] = "n/a" Then $listColWidth[7] = 80
If $listColWidth[8] = "n/a" Then $listColWidth[8] = 50
If $listColWidth[9] = "n/a" Then $listColWidth[9] = 50
_GUICtrlListView_AddColumn($idListview, "Monster Name", $listColWidth[0]);120)
_GUICtrlListView_AddColumn($idListview, "Size", $listColWidth[1]);60)
_GUICtrlListView_AddColumn($idListview, "Type", $listColWidth[2]);75)
_GUICtrlListView_AddColumn($idListview, "Tags", $listColWidth[3]);45)
_GUICtrlListView_AddColumn($idListview, "Alignment", $listColWidth[4]);50)
_GUICtrlListView_AddColumn($idListview, "CR", $listColWidth[5]);30)
_GUICtrlListView_AddColumn($idListview, "XP", $listColWidth[6]);45)
_GUICtrlListView_AddColumn($idListview, "HP", $listColWidth[7]);80)
_GUICtrlListView_AddColumn($idListview, "Dex", $listColWidth[8]);50)
_GUICtrlListView_AddColumn($idListview, "Source", $listColWidth[9]);50)
#EndRegion Listview Creation

#Region Enc Listview Creation + Buttons
GUICtrlCreateGroup("Encounter Generation", 5, $winHeight - 160, 550, 100)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

$encListview = GUICtrlCreateListView("", 12, $winHeight - 140, 250, 73, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT, $LVS_NOCOLUMNHEADER), $LVS_EX_FULLROWSELECT)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

_GUICtrlListView_AddColumn($encListview, "Monster\Npc", 150)
_GUICtrlListView_AddColumn($encListview, "Amount", 50)

;~ _GUICtrlListView_AddItem($encListview, "LEL")
;~ _GUICtrlListView_AddSubItem($encListview,0,0,1)

$encMinus = GUICtrlCreateButton("", 265, $winHeight - 105, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 19)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

$encAdd = GUICtrlCreateButton("", 265, $winHeight - 150, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 18)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

$encDel = GUICtrlCreateButton("", 310, $winHeight - 90, 24, 24, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 10, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

GUICtrlCreateGroup("", 340, $winHeight - 150, 1, 85)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

$encRandomHealth = GUICtrlCreateCheckbox("Randomize health", 350, $winHeight - 150)
GUICtrlSetTip(-1, "Keep ticked to do an automatic dice roll (behind the scenes) for HP as seen in the original list." & @LF _
		 & "Untick to manually roll\put in HP")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlSetState(-1, $GUI_CHECKED)

$encAutoInit = GUICtrlCreateCheckbox("Automatically roll Initiative", 350, $winHeight - 130)
GUICtrlSetTip(-1, "This will automatically roll for initiative based off the Dex Mod found in the Stats." & @LF _
		 & "It will also automatically add the NPC to the Initiative Window" & @LF _
		 & "If no Dex mod is found a flat D20 will be rolled if this option is ticked.")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlSetState(-1, $GUI_CHECKED)

$encClearSelection = GUICtrlCreateCheckbox("Clear after Adding", 350, $winHeight - 110)
GUICtrlSetTip(-1, "This will clear the selected Monsters\NPCs from Encounter Generation" & @LF & "after they are added to the Encounter Window")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlSetState(-1, $GUI_CHECKED)

$AddtoEnc = GUICtrlCreateButton("Add to Encounter", 450, $winHeight - 90)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
#EndRegion Enc Listview Creation + Buttons

#Region Create Icons
$gDiscordIcon = GUICtrlCreateIcon($iconsIcl, 27, 360, 45, 32, 32);$appDir & "Steam_Icon.Ico", -1, 360, 45, 32, 32)
GUICtrlSetTip($gDiscordIcon, " ", "sDoddler's Discord Server")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gTwitterIcon = GUICtrlCreateIcon($iconsIcl, 13, 400, 45, 32, 32)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip($gTwitterIcon, " ", "sDoddler's Twitter Page")
$gYoutubeIcon = GUICtrlCreateIcon($iconsIcl, 14, 440, 45, 32, 32)
GUICtrlSetTip($gYoutubeIcon, " ", "sDoddler's YouTube Channel")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
$gGithubIcon = GUICtrlCreateIcon($iconsIcl, 11, 480, 45, 32, 32)
GUICtrlSetTip($gGithubIcon, " ", "D&D Software Suite Github Page")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKSIZE)
GUICtrlSetCursor(-1, 0)
#EndRegion Create Icons

#Region GUI Set State & RegisterMsgs()
$Enter_KEY = GUICtrlCreateDummy()

Dim $Arr[5][2] = [["{ENTER}", $Enter_KEY], ["{NUMPADADD}", $encAdd], ["{+}", $encAdd], ["{NUMPADSUB}", $encMinus], ["{-}", $encMinus]]

GUISetAccelerators($Arr, $hMainGUI)

GUISetState()

_GUICtrlSetState($GUI_DISABLE)
$monsterArray = CreateMonsterArray()
_GUICtrlSetState($GUI_ENABLE)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
;~ GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
;~ InitiativeWindow()

GUIRegisterMsg($WM_SIZE, "_WM_SIZE")
GUIRegisterMsg($WM_NCHITTEST, "_WM_NCHITTEST") ;; This is to prevent dragging on $WS_EX_CONTROLPARENT ( Tabbing in Child Forms)

_GUICtrlListView_RegisterSortCallBack($idListview)
OnAutoItExitRegister("SavePreferences")

#EndRegion GUI Set State & RegisterMsgs()



While 1

	$msg = GUIGetMsg(1)
	Switch $msg[1]

		Case $hMainGUI

			Switch $msg[0]
				Case $GUI_EVENT_CLOSE ; Esc or X window button is pressed
					Exit
				Case $Enter_KEY ;; FIx this area - Need to think of how to include the In Lair while letting them have independant global notes..
;~ 					; How i have it is probably fine, i just need to say if Global notes for XXX does not exist then open What is generated below, else iniread Global notes($monster)
;~ 					$focus = ControlGetFocus("")
;~ 					$mainFocus = ControlGetHandle($winTitle, "", $focus)

					If ControlGetHandle($winTitle, "", ControlGetFocus($winTitle)) = GUICtrlGetHandle($idListview) Then
						$indicies = _GUICtrlListView_GetSelectedIndices($idListview, True)

						For $i = 1 To $indicies[0]
							$monster = StringReplace(_GUICtrlListView_GetItemText($idListview, $indicies[$i]), " (in lair)", "")
							For $j = 0 To UBound($monsterArray) - 1
								If $monsterArray[$j][0] = $monster Then
									If $monsterArray[$j][9] = "CUSTOMITEM" Then
										$monsterRead = IniRead($custIni, "Index", $monster, "")

									Else
										$monsterRead = IniRead($monCompIni, "Monsters", $monster, "")

									EndIf
									ExitLoop
								EndIf
							Next
							$split = StringSplit($monsterRead, "\\", 1)
							If $monsterArray[$j][9] <> "CUSTOMMONSTER" Then ;; If NOT Custom Monster Then

								$quick = _ArrayToString(IniReadSection($monCompIni, $monster), " = ", 1)
								CreateSubWindow($monsterArray[$j][9], $quick, 200 + (StringLen($monster) * 5))
								;ConsoleWrite(200 + (StringLen($split[6]) * 4) & @LF)
							Else
								;ConsoleWrite($item & @LF)
								$quick = _ArrayToString(IniReadSection($custIni, $monster), " = ", 1)
								CreateSubWindow($monster, $quick, 200 + (StringLen($monster) * 5))
								;ConsoleWrite(200 + (StringLen($item) * 4) & @LF)
							EndIf

						Next
					Else
						Update()
					EndIf
				Case $bUpdate
					Update()
				Case $bClear
					GUICtrlSetData($ihSearch, "")
					GUICtrlSetData($cCR, "")
					GUICtrlSetData($cCustom, "")
					GUICtrlSetData($cAlign, "")
					GUICtrlSetData($cType, "")
					GUICtrlSetData($cSize, "")

					GUICtrlSetData($cCR, $CRs, "Any")
					GUICtrlSetData($cCustom, "Any|Only|No", "Any")
					GUICtrlSetData($cAlign, $alignments, "Any")
					GUICtrlSetData($cType, $types, "Any")
					GUICtrlSetData($cSize, $sizes, "Any")
				Case $idListview ; List View Sort call
					_GUICtrlListView_SortItems($idListview, GUICtrlGetState($idListview))
				Case $encAdd
					EncModify()
				Case $encMinus
					EncModify(-1)
				Case $encDel
					EncDelete()
				Case $AddtoEnc
					EncounterUpdate(1, 0)
					EncounterAdd()
					if $initTurnIndex > -1 Then InitNextturn(False)
				Case $fRestart ; FileMenu Restart Program (Calls Restart Func)
					Restart()
				Case $fResetWindow
					Local $x = (@DesktopWidth / 2) - 300
					Local $y = (@DesktopHeight / 2) - 210

					WinMove($winTitle, "", $x, $y, 600, 420)

					$listColWidth[0] = 120
					$listColWidth[1] = 60
					$listColWidth[2] = 75
					$listColWidth[3] = 45
					$listColWidth[4] = 50
					$listColWidth[5] = 30
					$listColWidth[6] = 45
					$listColWidth[7] = 80
					$listColWidth[8] = 50
					$listColWidth[9] = 50

					For $i = 0 To 9
						_GUICtrlListView_SetColumnWidth($idListview, $i, $listColWidth[$i])
					Next
				Case $wInitiative
					InitiativeWindow()
				Case $wPlayers
					PlayersWindow()
				Case $wEncounter
					EncounterWindow()
				Case $wLaunchAll
					LaunchAll()
				Case $gDiscordIcon
					ShellExecute('https://discord.gg/qkEGawD')
				Case $gTwitterIcon
					ShellExecute('https://twitter.com/sdoddler')
				Case $gYoutubeIcon
					ShellExecute('https://youtube.com/user/doddddy')
				Case $gGithubIcon
					ShellExecute('https://github.com/sdoddler/D-D-Software-Suite')
			EndSwitch

		Case $hInitiative
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					GUIDelete($hInitiative)
					$initiativeActive = False
;~ 					$initiativeArray = 0
;~ 					Dim $initiativeArray[0][6]
;~ 				CASE $GUI_EVENT_MAXIMIZE
;~ 					$aPos = ControlGetPos($hInitiative, "", $idLabel)
;~ 					WinMove($hInitChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
;~ 					$initUB = UBound($initiativeArray)
;~ 					_GUIScrollbars_Scroll_Page($hInitChild, 1, 1)
;~ 					_GUIScrollbars_Generate($hInitChild, 250, 30 + $initUB * 25, 1, 1, False)
;~
				Case $initSave
					CreateSaveWindow()
				Case $initLoad
					LoadClicked()
					;InitLoad()
				Case $initManualInput
					GUICtrlSetState($initRolled, $GUI_ENABLE)
					GUICtrlSetState($initDexMod, $GUI_DISABLE)
				Case $initRollFor
					GUICtrlSetState($initRolled, $GUI_DISABLE)
					GUICtrlSetState($initDexMod, $GUI_ENABLE)
				Case $initAdd
					If GUICtrlRead($initManualInput) = $GUI_CHECKED Then
						InitiativeAdd(GUICtrlRead($initName), "Manual Entry", -1, False, GUICtrlRead($initDexMod), GUICtrlRead($initRolled), GUICtrlRead($initCurrHP))
					Else
						InitiativeAdd(GUICtrlRead($initName), "Autoroll", -1, True, GUICtrlRead($initDexMod), 0, GUICtrlRead($initCurrHP))
					EndIf
					If $initTurnIndex > -1 Then InitNextTurn(False)
				Case $initRefresh
					InitiativeUpdate()
					InitNextTurn(False)
				Case $initNextTurn
					InitNextTurn()
				Case $hInitTurnDummy
					InitNextTurn()
				Case $hInitDummy

					$focus = ControlGetFocus("")
					$initFocus = ControlGetHandle($initiativeTitle, "", $focus);ControlGetFocus($initiativeTitle)

					If $initFocus = GUICtrlGetHandle($initName) Or $initFocus = GUICtrlGetHandle($initRollFor) Or $initFocus = GUICtrlGetHandle($initManualInput) _
							Or $initFocus = GUICtrlGetHandle($initAdd) Or $initFocus = GUICtrlGetHandle($initDexMod) Or $initFocus = GUICtrlGetHandle($initRolled) Then
						If GUICtrlRead($initManualInput) = $GUI_CHECKED Then
							InitiativeAdd(GUICtrlRead($initName), "Manual Entry", -1, False, GUICtrlRead($initDexMod), GUICtrlRead($initRolled), GUICtrlRead($initCurrHP))
							InitNextTurn(False)
						Else
							InitiativeAdd(GUICtrlRead($initName), "Autoroll", -1, True, GUICtrlRead($initDexMod), 0, GUICtrlRead($initCurrHP))
							InitNextTurn(False)
						EndIf
					Else
						InitiativeUpdate()
						InitNextTurn(False)
					EndIf
			EndSwitch
		Case $hInitChild
			For $i = 0 To UBound($initiativeArray) - 1
				Local $hChildGUIArray = $initiativeArray[$i][6]

				If IsArray($hChildGUIArray) Then
					Switch $msg[0]
						Case $hChildGUIArray[0]
;~ 					_ArrayDisplay($initiativeArray) - Reuse these if the Index is not behaving
;~ 					ConsoleWrite("Delete button Hit: " & @LF & @TAB & $initiativeArray[$i][1] & " - " &  $initiativeArray[$i][2]&@LF)
;~
;~

							_ArrayDelete($initiativeArray, $i)

							If $i < $initTurnValue Then $initTurnValue -= 1
							If $initTurnIndex > UBound($initiativeArray) - 1 Then $initTurnIndex -= 1
							If $initTurnValue = -1 Then $initTurnValue = 0

							InitiativeUpdate()
							InitNextTurn(False)
							ExitLoop
						Case $hChildGUIArray[3]
							If GUICtrlRead($hChildGUIArray[3]) = $GUI_CHECKED Then
								GUICtrlSetBkColor($hChildGUIArray[1], $COLOR_RED)
								$initiativeArray[$i][7] = True
								If $i = $initTurnValue Then InitNextTurn()
							Else
								GUICtrlSetBkColor($hChildGUIArray[1], $COLOR_WHITE)
								If $initiativeArray[$i][2] = "Player" Or $initiativeArray[$i][2] = "NPC" Then GUICtrlSetBkColor($hChildGUIArray[1], 0xF0F0F0)
								$initiativeArray[$i][7] = False
							EndIf
							If $initiativeArray[$i][2] = "Player" Then
								$playersArray[$initiativeArray[$i][3]][15] = $initiativeArray[$i][7]

								PlayersUpdate(0, 0)
							EndIf
							If $initiativeArray[$i][2] = "NPC" Then
								$encounterArray[$initiativeArray[$i][3]][15] = $initiativeArray[$i][7]
								EncounterUpdate(0, 0)
							EndIf
						Case $hChildGUIArray[5]
;Func CreateNotesWindow($iTitle, $iStatsData, $iParent = $hMainGUI, $iType = "NPC", $iIndex = -1, $iStatArray = 0, $iLocal = False, $iMonRef = "", $iWidth = 250)
;~ 	$initiativeArray[$initUB][0] = $localIndex
;~ 	$initiativeArray[$initUB][1] = $iName
;~ 	;if $nameFound then $initiativeArray[$initUB][1]
;~ 	$initiativeArray[$initUB][2] = $iType
;~ 	$initiativeArray[$initUB][3] = $iRelIndex
;~ 	$initiativeArray[$initUB][7] = $iSkip
;~ 8 = #number
;~ 	$initiativeArray[$initUB][9] = $iHP
;~ 	;10 = LocalNotes
							Switch $initiativeArray[$i][2]
								Case "NPC"
									$z =  $initiativeArray[$i][3]
										CreateNotesWindow($encounterArray[$z][2] & " #" & $encounterArray[$z][13] _
										, $encounterArray[$z][4], $hInitiative, "NPC", $encounterArray[$z][0], $encounterArray[$z][3], True, $encounterArray[$z][7])
								Case "Player"
									$z = $initiativeArray[$i][3]
									Local $pStatArray = PlayerNotesPrep($z)

									CreateNotesWindow($playersArray[$z][2], $pStatArray[1], $hInitiative, "Player", $playersArray[$z][0], $pStatArray[0], True)
								Case Else
									CreateNotesWindow($initiativeArray[$i][1] & " #" & $initiativeArray[$i][8], "Manual Initiative Addition", $hInitiative, "Initiative",$initiativeArray[$i][0],0,True)

							EndSwitch
						Case Else
							InitCheckChildGUI()
						EndSwitch

				EndIf
			Next

		Case $hPlayers
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					GUIDelete($hPlayers)
					$playersActive = False
;~ 					$initiativeArray = 0
;~ 					Dim $initiativeArray[0][6]
				Case $poPlayerRoll
					$enablePlayerRolling = Not ($enablePlayerRolling)
					If $enablePlayerRolling Then
						GUICtrlSetState($poPlayerRoll, $GUI_CHECKED)
						GUICtrlSetState($poAutoAdd, $GUI_DISABLE)
					Else
						GUICtrlSetState($poPlayerRoll, $GUI_UNCHECKED)
						GUICtrlSetState($poAutoAdd, $GUI_ENABLE)
					EndIf
					ConsoleWrite("$hplayers gui handling" & @LF)
					PlayersUpdate()
				Case $poAutoAdd
					$autoAddToInitiative = Not ($autoAddToInitiative)
					If $autoAddToInitiative Then
						GUICtrlSetState($poAutoAdd, $GUI_CHECKED)
					Else
						GUICtrlSetState($poAutoAdd, $GUI_UNCHECKED)
					EndIf
				Case $playSave
					CreateSaveWindow()
				Case $playLoad
					LoadClicked()
				Case $playAdd
					PlayerAdd()
				Case $playAddtoInitB
					PlayersAddtoInitiative()
				Case $hPlayDummy
					$focus = ControlGetFocus("")

					$playFocus = ControlGetHandle($playersTitle, "", $focus)

					Switch $playFocus
						Case GUICtrlGetHandle($playAC), GUICtrlGetHandle($playAdd), GUICtrlGetHandle($playCha), _
								GUICtrlGetHandle($playClasses), GUICtrlGetHandle($playCon), GUICtrlGetHandle($playDex), _
								GUICtrlGetHandle($playLevel), GUICtrlGetHandle($playMaxHP), GUICtrlGetHandle($playName), _
								GUICtrlGetHandle($playSpeed), GUICtrlGetHandle($playStr), GUICtrlGetHandle($playWis), GUICtrlGetHandle($playInt)
							If $playCurrentlyEditing Then
								$playCurrentlyEditing = False
								$playersArray[$playEditInt][2] = GUICtrlRead($playName)
								$playersArray[$playEditInt][3] = GUICtrlRead($playStr)
								$playersArray[$playEditInt][4] = GUICtrlRead($playDex)
								$playersArray[$playEditInt][5] = GUICtrlRead($playCon)
								$playersArray[$playEditInt][6] = GUICtrlRead($playInt)
								$playersArray[$playEditInt][7] = GUICtrlRead($playWis)
								$playersArray[$playEditInt][8] = GUICtrlRead($playCha)
								$playersArray[$playEditInt][9] = GUICtrlRead($playSpeed)
								$playersArray[$playEditInt][10] = GUICtrlRead($playAC)
;~ 	Current HP on 11
								;$playersArray[$playEditInt][11] = GUICtrlRead($playMaxHP)
								$playersArray[$playEditInt][12] = GUICtrlRead($playMaxHP)
								$playersArray[$playEditInt][13] = GUICtrlRead($playClasses)
								$playersArray[$playEditInt][14] = GUICtrlRead($playLevel)

								GUICtrlSetData($playName, "")
								GUICtrlSetData($playStr, "")
								GUICtrlSetData($playDex, "")
								GUICtrlSetData($playCon, "")
								GUICtrlSetData($playInt, "")
								GUICtrlSetData($playWis, "")
								GUICtrlSetData($playCha, "")
								GUICtrlSetData($playSpeed, "")
								GUICtrlSetData($playAC, "")
								GUICtrlSetData($playMaxHP, "")
								GUICtrlSetData($playClasses, "")
								GUICtrlSetData($playLevel, "")

								GUICtrlSetState($playEditCancel, $GUI_HIDE)
								GUICtrlSetState($playEditSave, $GUI_HIDE)
								GUICtrlSetState($playAdd, $GUI_SHOW)

								GUISetState(@SW_ENABLE, $hPlayersChild)
								PlayersUpdate(0, 0)
							Else
;~ 							ConsoleWrite("WinHIt " & @LF & $playFocus & " - Name: " & GUICtrlGetHandle($playName) & @LF)
								PlayerAdd()
							EndIf
						Case Else

							PlayersCheckChildGUI()
					EndSwitch
;~ 					if WinActive($playersTitle) AND Not(WinActive($playersChildTitle)) Then
;~ 					PlayerAdd()
;~ 					EndIf
				Case $playEditCancel
					$playCurrentlyEditing = False
					GUICtrlSetData($playName, "")
					GUICtrlSetData($playStr, "")
					GUICtrlSetData($playDex, "")
					GUICtrlSetData($playCon, "")
					GUICtrlSetData($playInt, "")
					GUICtrlSetData($playWis, "")
					GUICtrlSetData($playCha, "")
					GUICtrlSetData($playSpeed, "")
					GUICtrlSetData($playAC, "")
;~ 	Current HP on 11
					GUICtrlSetData($playMaxHP, "")
					GUICtrlSetData($playClasses, "")
					GUICtrlSetData($playLevel, "")

					GUICtrlSetState($playEditCancel, $GUI_HIDE)
					GUICtrlSetState($playEditSave, $GUI_HIDE)
					GUICtrlSetState($playAdd, $GUI_SHOW)

					GUISetState(@SW_ENABLE, $hPlayersChild)

				Case $playEditSave
;~ 					ConsoleWrite($playEditInt&@LF)
					$playCurrentlyEditing = False
					$playersArray[$playEditInt][2] = GUICtrlRead($playName)
					$playersArray[$playEditInt][3] = GUICtrlRead($playStr)
					$playersArray[$playEditInt][4] = GUICtrlRead($playDex)
					$playersArray[$playEditInt][5] = GUICtrlRead($playCon)
					$playersArray[$playEditInt][6] = GUICtrlRead($playInt)
					$playersArray[$playEditInt][7] = GUICtrlRead($playWis)
					$playersArray[$playEditInt][8] = GUICtrlRead($playCha)
					$playersArray[$playEditInt][9] = GUICtrlRead($playSpeed)
					$playersArray[$playEditInt][10] = GUICtrlRead($playAC)
;~ 	Current HP on 11
					;$playersArray[$playEditInt][11] = GUICtrlRead($playMaxHP)
					$playersArray[$playEditInt][12] = GUICtrlRead($playMaxHP)
					$playersArray[$playEditInt][13] = GUICtrlRead($playClasses)
					$playersArray[$playEditInt][14] = GUICtrlRead($playLevel)

					GUICtrlSetData($playName, "")
					GUICtrlSetData($playStr, "")
					GUICtrlSetData($playDex, "")
					GUICtrlSetData($playCon, "")
					GUICtrlSetData($playInt, "")
					GUICtrlSetData($playWis, "")
					GUICtrlSetData($playCha, "")
					GUICtrlSetData($playSpeed, "")
					GUICtrlSetData($playAC, "")
					GUICtrlSetData($playMaxHP, "")
					GUICtrlSetData($playClasses, "")
					GUICtrlSetData($playLevel, "")

					GUICtrlSetState($playEditCancel, $GUI_HIDE)
					GUICtrlSetState($playEditSave, $GUI_HIDE)
					GUICtrlSetState($playAdd, $GUI_SHOW)

					GUISetState(@SW_ENABLE, $hPlayersChild)
					PlayersUpdate(0, 0)
			EndSwitch
		Case $hPlayersChild
			For $i = 0 To UBound($playersArray) - 1
				Local $pGUIArray = $playersArray[$i][1], $pRoll = 0

				If IsArray($pGUIArray) Then
					Switch $msg[0]
						Case $pGUIArray[0]
							$tResponse = MsgBox(52, "Are you Sure?", "Are you sure you want to delete this player?" & @LF _
									 & "This will also remove the player from the Initiative Window, and you will lose all Stats unless saved elsewhere.")
							If $tResponse = 6 Then
								For $j = 0 To UBound($initiativeArray) - 1
									If $initiativeArray[$j][2] = "Player" And $initiativeArray[$j][3] = $playersArray[$i][0] Then
										_ArrayDelete($initiativeArray, $j)
										If $initiativeActive Then InitiativeUpdate()
										ExitLoop
									EndIf
								Next

								_ArrayDelete($playersArray, $i)
;~ 					_ArrayDisplay($initiativeArray)

								PlayersUpdate()
							EndIf
							ExitLoop
						Case $pGUIArray[10]
							If GUICtrlRead($pGUIArray[10]) = $GUI_CHECKED Then
								GUICtrlSetBkColor($pGUIArray[1], $COLOR_RED)
								$playersArray[$i][15] = True
							Else
								GUICtrlSetBkColor($pGUIArray[1], $COLOR_WHITE)
								$playersArray[$i][15] = False
							EndIf
							For $j = 0 To UBound($initiativeArray) - 1
								If $initiativeArray[$j][2] = "Player" And $initiativeArray[$j][3] = $playersArray[$i][0] Then
									$initiativeArray[$j][7] = $playersArray[$i][15]
									If $initiativeActive Then InitiativeUpdate(0, 0)
									InitNextTurn(False)
									ExitLoop
								EndIf
							Next
						Case $pGUIArray[8]
							$pDexMod = ($playersArray[$i][4] - 10) / 2
							Select
								Case $playersArray[$i][4] = ""
									$pDexMod = "n/a"
								Case $pDexMod > 0
									$pDexMod = Floor($pDexMod)
								Case $pDexMod < 0
									$pDexMod = Ceiling($pDexMod)
							EndSelect

							If $pDexMod <> "n/a" Then
								$pRoll = DiceRoll(20, 1, 0, $pDexMod)
							Else
								$pRoll = DiceRoll(20)
							EndIf
							$playersArray[$i][16] = $pRoll[1]
							GUICtrlSetData($pGUIArray[6], $playersArray[$i][16])
						Case $pGUIArray[9]

;CreateNotesWindow($iTitle, $iStatsData, $iParent = $hMainGUI, $iType = "NPC", $iIndex = -1, $iStatArray = 0, $iLocal = False, $iMonRef = "", $iWidth = 250)
;~ $playersArray[$playUB][3] = GUICtrlRead($playStr)
;~ 		$playersArray[$playUB][4] = GUICtrlRead($playDex)
;~ 		$playersArray[$playUB][5] = GUICtrlRead($playCon)
;~ 		$playersArray[$playUB][6] = GUICtrlRead($playInt)
;~ 		$playersArray[$playUB][7] = GUICtrlRead($playWis)
;~ 		$playersArray[$playUB][8] = GUICtrlRead($playCha)
;~ 		$playersArray[$playUB][9] = GUICtrlRead($playSpeed)
;~ 		$playersArray[$playUB][10] = GUICtrlRead($playAC)
;~ 	Current HP on 11
;~ 		$playersArray[$playUB][11] = GUICtrlRead($playMaxHP)
;~ 		$playersArray[$playUB][12] = GUICtrlRead($playMaxHP)
;~ 		$playersArray[$playUB][13] = GUICtrlRead($playClasses)
;~ 		$playersArray[$playUB][14] = GUICtrlRead($playLevel)


							$z = $playersArray[$i][0]
									Local $pStatArray = PlayerNotesPrep($z)

							CreateNotesWindow($playersArray[$z][2], $pStatArray[1], $hPlayers, "Player", $playersArray[$z][0], $pStatArray[0], True)
						Case $pGUIArray[11]

							GUISetState(@SW_DISABLE, $hPlayersChild)
							$playEditInt = $i
							$playCurrentlyEditing = True
							$pGUIArray = $playersArray[$i][1]

							GUICtrlSetState($playEditCancel, $GUI_SHOW)
							GUICtrlSetState($playEditSave, $GUI_SHOW)
							GUICtrlSetState($playAdd, $GUI_HIDE)


							GUICtrlSetData($playName, GUICtrlRead($pGUIArray[1]))
							GUICtrlSetData($playStr, $playersArray[$i][3])
							GUICtrlSetData($playDex, $playersArray[$i][4])
							GUICtrlSetData($playCon, $playersArray[$i][5])
							GUICtrlSetData($playInt, $playersArray[$i][6])
							GUICtrlSetData($playWis, $playersArray[$i][7])
							GUICtrlSetData($playCha, $playersArray[$i][8])
							GUICtrlSetData($playSpeed, $playersArray[$i][9])
							GUICtrlSetData($playAC, $playersArray[$i][10])
;~ 	Current HP on 11
							GUICtrlSetData($playMaxHP, $playersArray[$i][12])
							GUICtrlSetData($playClasses, $playersArray[$i][13])
							GUICtrlSetData($playLevel, $playersArray[$i][14])
							$playersArray[$i][16] = GUICtrlRead($pGUIArray[6])

						Case Else

							PlayersCheckChildGUI()
					EndSwitch
				EndIf

			Next
		Case $hEncounter
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					GUIDelete($hEncounter)
					$encoActive = False
				Case $encXPAddSub, $encXPMod, $encXPUP1, $encXPUP2
					EncounterXPCalc(GUICtrlRead($encXPFromEnc))
				Case $encoAddtoInitB
					NPCsAddtoInitiative()
				Case $hEncoDummy
					NPCsCheckChildGUI()
				Case $encoSave
					CreateSaveWindow()
				Case $encoLoad
					LoadClicked()
			EndSwitch
		Case $hEncounterChild
			For $i = 0 To UBound($encounterArray) - 1
				Local $eGUIArray = $encounterArray[$i][1], $eRoll = 0

				If IsArray($eGUIArray) Then
					Switch $msg[0]
						Case $eGUIArray[0]
							$tResponse = MsgBox(52, "Are you Sure?", "Are you sure you want to delete this NPC?" & @LF _
									 & "This will also remove the NPC from the Initiative Window, and you will lose all Local Notes unless saved elsewhere.")
							If $tResponse = 6 Then
								For $j = 0 To UBound($initiativeArray) - 1
									If $initiativeArray[$j][2] = "NPC" And $initiativeArray[$j][3] = $encounterArray[$i][0] Then
										_ArrayDelete($initiativeArray, $j)
										If $initiativeActive Then InitiativeUpdate()
										ExitLoop
									EndIf
								Next

								_ArrayDelete($encounterArray, $i)
;~ 					_ArrayDisplay($initiativeArray)

								EncounterUpdate()
								if $initTurnIndex > -1 Then InitNextturn(False)
							EndIf
							ExitLoop
						Case $eGUIArray[9]
							CreateNotesWindow($encounterArray[$i][2] & " #" & $encounterArray[$i][13] _
									, $encounterArray[$i][4], $hEncounter, "NPC", $encounterArray[$i][0], $encounterArray[$i][3], True, $encounterArray[$i][7])
						Case $eGUIArray[10]




							If GUICtrlRead($eGUIArray[10]) = $GUI_CHECKED Then
								GUICtrlSetBkColor($eGUIArray[1], $COLOR_RED)
								$encounterArray[$i][15] = True
							Else
								GUICtrlSetBkColor($eGUIArray[1], $COLOR_WHITE)
								$encounterArray[$i][15] = False
							EndIf
							For $j = 0 To UBound($initiativeArray) - 1
								If $initiativeArray[$j][2] = "NPC" And $initiativeArray[$j][3] = $encounterArray[$i][0] Then
									$initiativeArray[$j][7] = $encounterArray[$i][15]
									If $initiativeActive Then InitiativeUpdate(0, 0)
									InitNextTurn(False)
									ExitLoop
								EndIf
							Next
						Case Else
							NPCsCheckChildGUI()
					EndSwitch
				EndIf
			Next
		Case $saveWindow
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE, $bSaveCancel
					If $playersActive Then GUISetState(@SW_ENABLE, $hPlayers)
					If $initiativeActive Then GUISetState(@SW_ENABLE, $hInitiative)
					If $encoActive Then GUISetState(@SW_ENABLE, $hEncounter)
					GUISetState(@SW_ENABLE, $hMainGUI)
					_GUICtrlSetState($GUI_ENABLE)
					GUIDelete($saveWindow)
				Case $bSaveChange
					$firstSlash = StringInStr($currentSaveLocation, "\", 0, -1)
					ConsoleWrite(StringLeft($currentSaveLocation, $firstSlash) & @LF & $currentSaveLocation & @LF)
					$saveTempFile = FileSaveDialog("Encounter Save Location..", StringLeft($currentSaveLocation, $firstSlash), "Ini Files (*.ini)", 0, StringRight($currentSaveLocation, StringLen($currentSaveLocation) - $firstSlash))
					If $saveTempFile <> "" Then $currentSaveLocation = $saveTempFile
					GUICtrlSetData($lSaveLocation, $currentSaveLocation)
				Case $bSaveSAVE
					Local $iSave = False, $saveEncounter = False, $savePlayers = False, $saveInitiative = False, $initDataExists = False, $playDataExists = False, $encDataExists = False
					If GUICtrlRead($cbSaveEncounter) = $GUI_CHECKED Then $saveEncounter = True
					If GUICtrlRead($cbSavePlayers) = $GUI_CHECKED Then $savePlayers = True
					If GUICtrlRead($cbSaveInitiative) = $GUI_CHECKED Then $saveInitiative = True

					If FileExists($currentSaveLocation) Then
						$secName = IniReadSectionNames($currentSaveLocation)
						if IsArray($secName) Then
						For $i = 1 To $secName[0]
							$secRead = IniReadSection($currentSaveLocation, $secName[$i])
							For $j = 1 To $secRead[0][0]
								If $secRead[$j][0] = "Type" Then
									Switch $secRead[$j][1]
										Case "Manual Entry", "Autoroll"
											If $saveInitiative Then $initDataExists = True
										Case "Player"
											If $savePlayers Then $playDataExists = True
										Case "NPC"
											If $saveEncounter Then $encDataExists = True
									EndSwitch
									ExitLoop
								EndIf
							Next
						Next
						If $initDataExists Or $playDataExists Or $encDataExists Then
							$dataExists = ""
							$iResponse = ""
							If $initDataExists Then $dataExists &= " - Initiative Data" & @LF
							If $playDataExists Then $dataExists &= " - Players Data" & @LF
							If $encDataExists Then $dataExists &= " - NPC Data" & @LF
							$iResponse = MsgBox(36, "Data Already Exists", "Data of the following formats already exists in this file:" & @LF & $dataExists & "Do you wish to overwrite this data?")

							If $iResponse = 6 Then
								$iSave = True
;~ 								;;; 03/08 USE BELOW FOR OVERWRITING DATA - JUST do IF $saveXX then IniDeleteSection
								For $i = 1 To $secName[0]
									$secRead = IniReadSection($currentSaveLocation, $secName[$i])
									For $j = 1 To $secRead[0][0]
										If $secRead[$j][0] = "Type" Then
											Switch $secRead[$j][1]
												Case "Manual Entry", "Autoroll"
													If $saveInitiative Then IniDelete($currentSaveLocation, $secName[$i])
												Case "Player"
													If $savePlayers Then IniDelete($currentSaveLocation, $secName[$i])
												Case "NPC"
													If $saveEncounter Then IniDelete($currentSaveLocation, $secName[$i])
											EndSwitch
											ExitLoop
										EndIf
									Next
								Next
								ConsoleWrite("overwrite Data here" & @LF)
							EndIf
						Else
							$iSave = True
						EndIf
						Else
						$iSave = True
						EndIf
					Else
						$iSave = True
					EndIf

					If $iSave Then
						If $saveInitiative Then InitSave()
						If $savePlayers Then PlayersSave()
						If $saveEncounter Then EncounterSave() ;ConsoleWrite("Encounter Save Function Here" & @LF)
						$currentLoadLocation = $currentSaveLocation
					EndIf

					If $playersActive Then GUISetState(@SW_ENABLE, $hPlayers)
					If $initiativeActive Then GUISetState(@SW_ENABLE, $hInitiative)
					If $encoActive Then GUISetState(@SW_ENABLE, $hEncounter)
					GUISetState(@SW_ENABLE, $hMainGUI)
					_GUICtrlSetState($GUI_ENABLE)
					GUIDelete($saveWindow)
			EndSwitch
		Case $hLoadWindow
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE, $bLoadCancel
					If $playersActive Then GUISetState(@SW_ENABLE, $hPlayers)
					If $encoActive Then GUISetState(@SW_ENABLE, $hEncounter)
					If $initiativeActive Then GUISetState(@SW_ENABLE, $hInitiative)
					_GUICtrlSetState($GUI_ENABLE)
					GUISetState(@SW_ENABLE, $hMainGUI)
					GUIDelete($hLoadWindow)
				Case $bLoadChange
					$firstSlash = StringInStr($currentLoadLocation, "\", 0, -1)
					ConsoleWrite(StringLeft($currentLoadLocation, $firstSlash) & @LF & $currentLoadLocation & @LF)
					$loadTempFile = FileOpenDialog("Encounter Save Location..", StringLeft($currentLoadLocation, $firstSlash), "Ini Files (*.ini)", 0, StringRight($currentLoadLocation, StringLen($currentLoadLocation) - $firstSlash))


					If FileExists($loadTempFile) Then
						Local $initDataExists = False, $playDataExists = False, $encDataExists = False
						$currentLoadLocation = $loadTempFile
						$secName = IniReadSectionNames($currentLoadLocation)
						if IsArray($secName) Then
						For $i = 1 To $secName[0]
							ConsoleWrite($secName[$i] & @LF)
							$secRead = IniReadSection($currentLoadLocation, $secName[$i])
							For $j = 1 To $secRead[0][0]
								If $secRead[$j][0] = "Type" Then
									Switch $secRead[$j][1]
										Case "Manual Entry", "Autoroll"
											$initDataExists = True
										Case "Player"
											$playDataExists = True
										Case "NPC"
											$encDataExists = True
									EndSwitch
									ExitLoop
								EndIf
							Next
						Next
						EndIf
						If $playDataExists Then
							GUICtrlSetState($cbLoadPlayers, $GUI_CHECKED)
							GUICtrlSetState($cbLoadPlayers, $GUI_ENABLE)
						Else
							GUICtrlSetState($cbLoadPlayers, $GUI_UNCHECKED)
							GUICtrlSetState($cbLoadPlayers, $GUI_DISABLE)
						EndIf
						If $initDataExists Then
							GUICtrlSetState($cbLoadInitiative, $GUI_CHECKED)
							GUICtrlSetState($cbLoadInitiative, $GUI_ENABLE)
						Else
							GUICtrlSetState($cbLoadInitiative, $GUI_UNCHECKED)
							GUICtrlSetState($cbLoadInitiative, $GUI_DISABLE)
						EndIf
						If $encDataExists Then
							GUICtrlSetState($cbLoadEncounter, $GUI_CHECKED)
							GUICtrlSetState($cbLoadEncounter, $GUI_ENABLE)
						Else
							GUICtrlSetState($cbLoadEncounter, $GUI_UNCHECKED)
							GUICtrlSetState($cbLoadEncounter, $GUI_DISABLE)
						EndIf
						GUICtrlSetData($lLoadLocation, $currentLoadLocation)
					Else
						MsgBox(48, "File Does not Exist", "File Does not Exist")
					EndIf


				Case $bLoadLoad
					$tResponse = 6
					Local $overwrite = False, $initDataInArray = False
					If GUICtrlRead($cbLoadInitiative) = $GUI_CHECKED Then
						For $i = 0 To UBound($initiativeArray) - 1
							If $initiativeArray[$i][2] = "Manual Entry" Or $initiativeArray[$i][2] = "Autoroll" Then
								$initDataInArray = True
								ExitLoop
							EndIf
						Next
					EndIf
					If $initDataInArray Or (GUICtrlRead($cbLoadPlayers) = $GUI_CHECKED And UBound($playersArray) > 0) _
							Or (GUICtrlRead($cbLoadEncounter) = $GUI_CHECKED And UBound($encounterArray) > 0) Then $tResponse = MsgBox(51, "Do you wish to Overwrite?", _
							"Do you wish to overwrite the current data?" & @LF & "(If you select No it will keep the current and add the new data as well)")


					Switch $tResponse
						Case 6
							$overwrite = True
							If $playersActive Then GUISetState(@SW_ENABLE, $hPlayers)
							If $initiativeActive Then GUISetState(@SW_ENABLE, $hInitiative)
							If $encoActive Then GUISetState(@SW_ENABLE, $hEncounter)
							GUISetState(@SW_ENABLE, $hMainGUI)
							_GUICtrlSetState($GUI_ENABLE)
							If GUICtrlRead($cbLoadInitiative) = $GUI_CHECKED Then InitLoad($overwrite)
							If GUICtrlRead($cbLoadPlayers) = $GUI_CHECKED Then PlayersLoad($overwrite)
							If GUICtrlRead($cbLoadEncounter) = $GUI_CHECKED Then EncounterLoad($overwrite)
							$currentSaveLocation = $currentLoadLocation

							GUIDelete($hLoadWindow)
						Case 7
							$overwrite = False
							If $playersActive Then GUISetState(@SW_ENABLE, $hPlayers)
							If $initiativeActive Then GUISetState(@SW_ENABLE, $hInitiative)
							If $encoActive Then GUISetState(@SW_ENABLE, $hEncounter)
							GUISetState(@SW_ENABLE, $hMainGUI)
							_GUICtrlSetState($GUI_ENABLE)
							If GUICtrlRead($cbLoadInitiative) = $GUI_CHECKED Then InitLoad($overwrite)
							If GUICtrlRead($cbLoadPlayers) = $GUI_CHECKED Then PlayersLoad($overwrite)
							If GUICtrlRead($cbLoadEncounter) = $GUI_CHECKED Then EncounterLoad($overwrite)
							$currentSaveLocation = $currentLoadLocation

							GUIDelete($hLoadWindow)

					EndSwitch

			EndSwitch

	EndSwitch


	#Region Resizing for Initiative Child Area

	If WinExists($initiativeTitle) Then
;~ 		ConsoleWrite("Hittest" & @LF)
		$aSize = ControlGetPos($hInitiative, "", $idLabel)

		If IsArray($aSize) Then
			If $aSize[2] <> $aStartSize[2] Or $aSize[3] <> $aStartSize[3] Then
				$aStartSize[2] = $aSize[2]
				$aStartSize[3] = $aSize[3]
				$aPos = ControlGetPos($hInitiative, "", $idLabel)
				WinMove($hInitChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
;~ 				ConsoleWrite($aPos[2] & @LF)
				$initUB = UBound($initiativeArray)
				_GUIScrollbars_Scroll_Page($hInitChild, 1, 1)
				_GUIScrollbars_Generate($hInitChild, 280, 30 + $initUB * 25, 1, 1, False)
			EndIf
		EndIf
	EndIf
	#EndRegion Resizing for Initiative Child Area

	#Region Resizing for Players Child Area
	If WinExists($playersTitle) Then
;~ 		ConsoleWrite("Hittest" & @LF)
		$pSize = ControlGetPos($hPlayers, "", $playChildSizeLabel)

		If IsArray($pSize) Then
			If $pSize[2] <> $playStartSize[2] Or $pSize[3] <> $playStartSize[3] Then
				$playStartSize[2] = $pSize[2]
				$playStartSize[3] = $pSize[3]
				$aPos = ControlGetPos($hPlayers, "", $playChildSizeLabel)
				WinMove($hPlayersChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
;~ 				ConsoleWrite($aPos[2] & @LF)
				$playUB = UBound($playersArray)
				_GUIScrollbars_Scroll_Page($hPlayersChild, 1, 1)
				_GUIScrollbars_Generate($hPlayersChild, 400, 30 + $playUB * 25, 1, 1, False)
			EndIf
		EndIf
	EndIf
	#EndRegion Resizing for Players Child Area

	#Region Resizing for Encounter Child Area
	If WinExists($encoTitle) Then
;~ 		ConsoleWrite("Hittest" & @LF)
		$eSize = ControlGetPos($hEncounter, "", $encoChildSizeLabel)

		If IsArray($eSize) Then
			If $eSize[2] <> $encoStartSize[2] Or $eSize[3] <> $encoStartSize[3] Then
				$encoStartSize[2] = $eSize[2]
				$encoStartSize[3] = $eSize[3]
				$aPos = ControlGetPos($hEncounter, "", $encoChildSizeLabel)
				WinMove($hEncounterChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
;~ 				ConsoleWrite($aPos[2] & @LF)
				$encoUB = UBound($encounterArray)
				_GUIScrollbars_Scroll_Page($hEncounterChild, 1, 1)
				_GUIScrollbars_Generate($hEncounterChild, 400, 30 + $encoUB * 25, 1, 1, False)
			EndIf
		EndIf
	EndIf
	#EndRegion Resizing for Encounter Child Area

	#Region Gui Handling for Generated Sub Windows ---- REQUIRES WORK (currently allows Duplicate Player windows & Monster Windows? Maybe just monsters)
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
	#EndRegion Gui Handling for Generated Sub Windows ---- REQUIRES WORK (currently allows Duplicate Player windows & Monster Windows? Maybe just monsters)

	For $i = 1 To UBound($hNotes) - 1

;~ 		Array Values
;~ 		$hNotes[$notesWindows][0] = GUICreate($iTitle, $iWidth, $height, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)
;~ 		$hNotes[$notesWindows][1] = $iStatsData
;~ 		$hNotes[$notesWindows][2] = $iType
;~ 		$hNotes[$notesWindows][3] = $iIndex
;~ 		$hNotes[$notesWindows][4] = $iTitle
;~ 		;5 = Global Notes
;~ 		;6 = Local Notes
;~ 		$hNotes[$notesWindows][7] = $iStatArray
;~ 		;8 = Dice Roll Amount
;~ 		;9 = Dice Roll Sides
;~ 		;10 = Stat Type Combo
;~ 		;11 = Addition Input
;~ 		;12 = Modifier Radio
;~ 		;13 = Saving Throw Radio
;~ 		;14 = None Radio
;~ 		;15 = Adv. Radio
;~ 		;16 = DisAdv. Radio
;~ 		;17 = Roll Button
;~ 		;18 = Save Button
;~ 		$hNotes[$notesWindows][19] = $iMonRef
		;20 = Original Global Notes
		;21 = Original Local Notes


		If $msg[1] = $hNotes[$i][0] Then
			;ConsoleWrite("Message hit on: " & $hDescripts[$i]&@LF)
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					Local $nResponse = 0
					if GUICtrlRead($hNotes[$i][5]) <> $hNotes[$i][20] OR GUICtrlRead($hNotes[$i][6]) <> $hNotes[$i][21] Then
						$nResponse = MsgBox(51	,"Would you like to Save Changes?","Changes have been made to the Local or Global Notes" &@LF& "Would you like to save changes?")
						Switch $nResponse
							Case 6;Yes Save Changes
								SaveGlobalNotes($hNotes[$i][19],$i)
								SaveLocalNotes($hNotes[$i][2], $hNotes[$i][3],GUICtrlRead($hNotes[$i][6]),$i)
								GUIDelete($hNotes[$i][0])
								_ArrayDelete($hNotes, $i)
								$notesWindows -= 1
								ExitLoop
							Case 7 ; No Exit without saving
								GUIDelete($hNotes[$i][0])
								_ArrayDelete($hNotes, $i)
								$notesWindows -= 1
								ExitLoop
							Case 2 ;Cancel (Do nothing)

						EndSwitch
					Else
						GUIDelete($hNotes[$i][0])
						_ArrayDelete($hNotes, $i)
						$notesWindows -= 1
						ExitLoop
					EndIf

				Case $hNotes[$i][18]
					SaveGlobalNotes($hNotes[$i][19],$i)
					SaveLocalNotes($hNotes[$i][2], $hNotes[$i][3],GUICtrlRead($hNotes[$i][6]),$i)
				Case $hNotes[$i][15],$hNotes[$i][16]
					GUICtrlSetData($hNotes[$i][8],2)
					GUICtrlSetState($hNotes[$i][8],$GUI_DISABLE)
				Case $hNotes[$i][14]
					GUICtrlSetState($hNotes[$i][8],$GUI_ENABLE)
				Case $hNotes[$i][12]
					if GUICtrlRead($hNotes[$i][10]) <> "Other" Then GUICtrlSetData($hNotes[$i][11],SkillMatrix(GUICtrlRead($hNotes[$i][10]), "NotNeeded", "Mod", "Int", $hNotes[$i][7]))
				Case $hNotes[$i][13]
					if GUICtrlRead($hNotes[$i][10]) <> "Other" Then
						Local $statType = GUICtrlRead($hNotes[$i][10])
						if SkillMatrix($statType, "NotNeeded", "Saving Throw", "Int", $hNotes[$i][7]) = 0 Then
										GUICtrlSetData($hNotes[$i][11],SkillMatrix($statType, "NotNeeded", "Mod", "Int", $hNotes[$i][7]))
										Else
									GUICtrlSetData($hNotes[$i][11],SkillMatrix($statType, "NotNeeded", "Saving Throw", "Int", $hNotes[$i][7]))
										EndIf
									EndIf
				Case $hNotes[$i][10]
					if IsArray($hNotes[$i][7]) Then
						Local $statType = GUICtrlRead($hNotes[$i][10])
						Switch $statType
							Case "Other"
								GUICtrlSetData($hNotes[$i][11],0)
							Case Else
								if GUICtrlRead($hNotes[$i][12]) = $GUI_CHECKED Then
									GUICtrlSetData($hNotes[$i][11],SkillMatrix($statType, "NotNeeded", "Mod", "Int", $hNotes[$i][7]))
								Else
									if SkillMatrix($statType, "NotNeeded", "Saving Throw", "Int", $hNotes[$i][7]) = 0 Then
										GUICtrlSetData($hNotes[$i][11],SkillMatrix($statType, "NotNeeded", "Mod", "Int", $hNotes[$i][7]))
										Else
									GUICtrlSetData($hNotes[$i][11],SkillMatrix($statType, "NotNeeded", "Saving Throw", "Int", $hNotes[$i][7]))
									EndIf
								EndIf
						EndSwitch
					EndIf
				Case $hNotes[$i][17]
					Local $advType = ""
					If GUICtrlread($hNotes[$i][14]) = $GUI_CHECKED THen $advType = "None"
					If GUICtrlread($hNotes[$i][15]) = $GUI_CHECKED THen $advType = "Adv"
					If GUICtrlread($hNotes[$i][16]) = $GUI_CHECKED THen $advType = "Disadv"
					Switch $advType
						Case "None"
						Local $notesRoll = DiceRoll(GUICtrlRead($hNotes[$i][9]), GUICtrlRead($hNotes[$i][8]))
						Local $notesAdd = Int(GUICtrlRead($hNotes[$i][11]))
						Local $notesMod = ""
						Local $notesIndivRolls = ""
						if $notesAdd >= 0 Then $notesMod = "+"
						For $j = 0 to UBound($notesRoll)-2
							$notesIndivRolls &= "(" & $notesRoll[$j] & ") "
						Next
						MsgBox(64,$hNotes[$i][4] & " Dice Roll", "You Rolled a " & GUICtrlRead($hNotes[$i][8]) &"d"& GUICtrlRead($hNotes[$i][9]) & $notesMod & $notesAdd & @LF _
						& "The Results were: " & $notesIndivRolls & $notesMod &$notesAdd & " Total: " & ($notesRoll[UBound($notesRoll)-1]+$notesAdd))
						Case "Adv"
							Local $notesRoll = DiceRoll(GUICtrlRead($hNotes[$i][9]), GUICtrlRead($hNotes[$i][8]))
							Local $notesAdd = Int(GUICtrlRead($hNotes[$i][11]))
							Local $notesIndivRolls = ""
							Local $advRoll = 0
							if $notesAdd >= 0 Then $notesMod = "+"
							For $j = 0 to UBound($notesRoll)-2
								if $notesRoll[$j] > $advRoll Then $advRoll = $notesRoll[$j]
								$notesIndivRolls &= "(" & $notesRoll[$j] & ") "
							Next
							MsgBox(64,$hNotes[$i][4] & " Dice Roll", "You Rolled a " &"d"& GUICtrlRead($hNotes[$i][9])  & $notesMod & $notesAdd & " with Advantage" &@LF _
							& "The Results were: " & $notesIndivRolls & " the highest roll being: " & $advRoll &@LF _
							& "Total: " & $advRoll+$notesAdd)
						Case "Disadv"
							Local $notesRoll = DiceRoll(GUICtrlRead($hNotes[$i][9]), GUICtrlRead($hNotes[$i][8]))
							Local $notesAdd = Int(GUICtrlRead($hNotes[$i][11]))
							Local $notesIndivRolls = ""
							Local $disadvRoll = 100
							if $notesAdd >= 0 Then $notesMod = "+"
							For $j = 0 to UBound($notesRoll)-2
								if $notesRoll[$j] < $disadvRoll Then $disadvRoll = $notesRoll[$j]
								$notesIndivRolls &= "(" & $notesRoll[$j] & ") "
							Next
							MsgBox(64,$hNotes[$i][4] & " Dice Roll", "You Rolled a " &"d"& GUICtrlRead($hNotes[$i][9])  & $notesMod & $notesAdd & " with Disdvantage" &@LF _
							& "The Results were: " & $notesIndivRolls & " the lowest roll being: " & $disadvRoll &@LF _
							& "Total: " & $disadvRoll+$notesAdd)
					EndSwitch
				Case $hNotes[$i][22];Change Image
					$currImage = GUICtrlRead($hNotes[$i][23])
					if FileExists($currImage) Then

						$firstSlash = StringInStr($currImage, "\", 0, -1)
						$loadTempImage = FileOpenDialog("Change Monster image", StringLeft($currImage, $firstSlash), "Image Files (*.jpg;*.png;*.gif;*.jpeg;*.bmp)|All Files (*.*)", 0, StringRight($currImage, StringLen($currImage) - $firstSlash))
					Else
						$loadTempImage = FileOpenDialog("Change Monster image", @ScriptDir, "Image Files (*.jpg;*.png;*.gif;*.jpeg;*.bmp)|All Files (*.*)", 0)
					EndIf
					if FileExists($loadTempImage) Then
						GUICtrlSetData($hNotes[$i][23],$loadTempImage,"")
						IniWrite($globalNotesIni,$hNotes[$i][19],"Image",$loadTempImage)
					EndIf
				Case $hNotes[$i][24]
					$currImage = GUICtrlRead($hNotes[$i][23])
					if FileExists($currImage) Then ShellExecute($currImage)
			EndSwitch

		EndIf
	Next

	Sleep(10)

WEnd

#Region Encounter (Main GUI) Funcs
Func ListviewFocus()
	Local $focus = ControlGetFocus(""), $boolHit = False, $fromListview = 0
	$encFocus = ControlGetHandle($winTitle, "", $focus)


	Switch $encFocus
		Case GUICtrlGetHandle($encListview)
;~ 			ConsoleWrite("Enc Listview Logic"&@LF)
			$fromListview = "Encounter"
			$boolHit = True
		Case GUICtrlGetHandle($idListview)
;~ 			ConsoleWrite("idListview Logic "&@LF)
			$fromListview = "Search"
			$boolHit = True
	EndSwitch

	If $boolHit = False Then
		Switch $cLastFocus
			Case $encListview
;~ 			ConsoleWrite("Enc Listview Logic"&@LF)
				$fromListview = "Encounter"
				$boolHit = True
			Case $idListview
;~ 			ConsoleWrite("idListview Logic "&@LF)
				$fromListview = "Search"
				$boolHit = True
		EndSwitch
	EndIf

	Return $fromListview
EndFunc   ;==>ListviewFocus

Func EncDelete()
	$listviewFocus = ListviewFocus()

	Switch $listviewFocus
		Case "Encounter"
			Local $selArray = _GUICtrlListView_GetSelectedIndices($encListview, True)
		Case "Search"
			Local $selArray = _GUICtrlListView_GetSelectedIndices($idListview, True)
	EndSwitch


	For $i = 1 To $selArray[0]
		Switch $listviewFocus
			Case "Encounter"
				Local $tempName = _GUICtrlListView_GetItemText($encListview, $selArray[$i])
			Case "Search"
				Local $tempName = _GUICtrlListView_GetItemText($idListview, $selArray[$i])
		EndSwitch
;~ 						$tempName = _GUICtrlListView_GetItemText($encListview,$selArray[$i])

		For $j = 0 To UBound($workingEncounter) - 1
			If $tempName = $workingEncounter[$j][1] Then
				_GUICtrlListView_DeleteItem($encListview, $workingEncounter[$j][0])
;~ 								_ArrayDisplay($workingEncounter)
				_ArrayDelete($workingEncounter, $j)
				For $l = 0 To UBound($workingEncounter) - 1
					If $workingEncounter[$l][0] > $j Then $workingEncounter[$l][0] -= 1
				Next
;~ 								_ArrayDisplay($workingEncounter)
				ExitLoop
			EndIf

		Next
	Next
EndFunc   ;==>EncDelete

Func EncModify($iMod = 1)
	Local $boolDuplicate = False, $fromListview = "", $selArray, $workingEncUB = 0, $selArray


	;ConsoleWrite($focus &@LF & @TAB & $encFocus & @LF & $cLastFocus & @LF)
	$fromListview = ListviewFocus()

	Switch $fromListview
		Case "Encounter"
			$selArray = _GUICtrlListView_GetSelectedIndices($encListview, True)

			For $i = 1 To $selArray[0]
				;ConsoleWrite(_GUICtrlListView_GetItemText($idListview,$selArray[$i])&@LF)
				$tempName = _GUICtrlListView_GetItemText($encListview, $selArray[$i])
				$workingEncUB = UBound($workingEncounter)
				For $j = 0 To $workingEncUB - 1
					If $tempName = $workingEncounter[$j][1] Then
						$workingEncounter[$j][2] += $iMod
						If $workingEncounter[$j][2] < 0 Then $workingEncounter[$j][2] = 0
						_GUICtrlListView_SetItemText($encListview, $workingEncounter[$j][0], $workingEncounter[$j][2], 1)
						ExitLoop
					EndIf
				Next
			Next

		Case "Search"
			$selArray = _GUICtrlListView_GetSelectedIndices($idListview, True)

			For $i = 1 To $selArray[0]
				$boolDuplicate = False
				$tempName = _GUICtrlListView_GetItemText($idListview, $selArray[$i])
				$workingEncUB = UBound($workingEncounter)
;~ 				ConsoleWrite($workingEncUB & " - " & $tempName & @LF)
				For $j = 0 To $workingEncUB - 1
;~ 					ConsoleWrite(@TAB & "- " & $workingEncounter[$j][1] &@LF)
					If $tempName = $workingEncounter[$j][1] Then
						$workingEncounter[$j][2] += $iMod
						If $workingEncounter[$j][2] < 0 Then $workingEncounter[$j][2] = 0
						_GUICtrlListView_SetItemText($encListview, $workingEncounter[$j][0], $workingEncounter[$j][2], 1)
						$boolDuplicate = True
						ExitLoop
					EndIf
				Next
				If $boolDuplicate = False Then
;~ 					if $workingEncUB = 0 Then
					$workingEncUB += 1
					ReDim $workingEncounter[$workingEncUB][3]
;~ 					Else
;~ 					Dim $workingEncounter[$workingEncUB+1][3]
;~ 					EndIf

					$workingEncounter[$workingEncUB - 1][1] = $tempName
					If $iMod > 0 Then
						$workingEncounter[$workingEncUB - 1][2] = $iMod
					Else
						$workingEncounter[$workingEncUB - 1][2] = 0
					EndIf
					$workingEncounter[$workingEncUB - 1][0] = _GUICtrlListView_AddItem($encListview, $tempName)
					_GUICtrlListView_AddSubItem($encListview, $workingEncounter[$workingEncUB - 1][0], $workingEncounter[$workingEncUB - 1][2], 1)
				EndIf

;~ 				$workingEncounter
			Next
	EndSwitch
EndFunc   ;==>EncModify
#EndRegion Encounter (Main GUI) Funcs

#Region Utility Funcs -- Restart, Save Prefs, GUICtrlSetState, Titilise
Func Restart()
	If @Compiled Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>Restart

Func SavePreferences()
	IniWrite($prefIni, "Settings", "Custom Encounter File", $custIni)
	Local $windowSize = WinGetPos($winTitle)
	Local $winApiWidth = _WinAPI_GetWindowWidth($hMainGUI)
	Local $winApiHeight = _WinAPI_GetWindowHeight($hMainGUI)
	Local $winApiInfo = _WinAPI_GetWindowInfo($hMainGUI)
	Local $winApiLeft = DllStructGetData($winApiInfo, 'rWindow', 1)
	Local $winApiTop = DllStructGetData($winApiInfo, 'rWindow', 2)

	ConsoleWrite("Window Width = "& $winApiWidth & @LF & "Window Height = " & $winApiHeight &@LF _
	& "Window Left = "& $winApiLeft & @LF & "Window Top = " & $winApiTop &@LF)

	IniWrite($prefIni, "Window Size", "Width", $winApiWidth-14);$windowSize[2])
	IniWrite($prefIni, "Window Size", "Height", $winApiHeight-14);$windowSize[3])

	if $winApiLeft > -1 Then IniWrite($prefIni, "Window Size", "Left", $winApiLeft);$windowSize[3])
	if $winApiTop > -1 Then IniWrite($prefIni, "Window Size", "Top", $winApiTop);$windowSize[3])

	Local $listviewColOrder = _GUICtrlListView_GetColumnOrderArray($idListview)

	For $i = 1 To $listviewColOrder[0]
		IniWrite($prefIni, "Window Size", $listviewColOrder[$i], _GUICtrlListView_GetColumnWidth($idListview, $i - 1))
	Next

	IniWrite($prefIni, "Settings", "LastSaveLocation", $currentSaveLocation)



;~ Local $tWINDOWINFO = _WinAPI_GetWindowInfo(_WinAPI_GetDesktopWindow())

;~ ConsoleWrite('Left:   ' & DllStructGetData($tWINDOWINFO, 'rWindow', 1) & @CRLF)
;~ ConsoleWrite('Top:    ' & DllStructGetData($tWINDOWINFO, 'rWindow', 2) & @CRLF)
;~ ConsoleWrite('Right:  ' & DllStructGetData($tWINDOWINFO, 'rWindow', 3) & @CRLF)
;~ ConsoleWrite('Bottom: ' & DllStructGetData($tWINDOWINFO, 'rWindow', 4) & @CRLF)

EndFunc   ;==>SavePreferences

Func _GUICtrlSetState($state)
	If $state = $GUI_DISABLE Then
		GUISetState($hMainGUI, @SW_LOCK)
		GUISetState($hInitiative, @SW_LOCK)
		GUISetState($hEncounter, @SW_LOCK)
		GUISetState($hPlayers, @SW_LOCK)
	EndIf
	If $state = $GUI_ENABLE Then
		GUISetState($hMainGUI, @SW_UNLOCK)
		GUISetState($hInitiative, @SW_UNLOCK)
		GUISetState($hEncounter, @SW_UNLOCK)
		GUISetState($hPlayers, @SW_UNLOCK)
	EndIf

	GUICtrlSetState($idListview, $state)
	GUICtrlSetState($cCustom, $state)
	GUICtrlSetState($cSize, $state)
	GUICtrlSetState($cCR, $state)
	GUICtrlSetState($cType, $state)
	GUICtrlSetState($cAlign, $state)
	GUICtrlSetState($ihSearch, $state)
	GUICtrlSetState($bUpdate, $state)
	GUICtrlSetState($bClear, $state)
	GUICtrlSetState($fileMenu, $state)
	GUICtrlSetState($wInitiative, $state)
	GUICtrlSetState($wPlayers, $state)
	GUICtrlSetState($wEncounter, $state)
	GUICtrlSetState($wLaunchAll, $state)
;~ 	GUICtrlSetState($windowsMenu, $state)

	Switch $state
		Case $GUI_ENABLE
			GUISetAccelerators($Arr, $hMainGUI)
			GUISetAccelerators($initArr, $hInitiative)
			GUISetAccelerators($playArr, $hPlayers)
			GUISetAccelerators($encoArr, $hEncounter)
		Case $GUI_DISABLE
			GUISetAccelerators(0, $hMainGUI)
			GUISetAccelerators(0, $hInitiative)
			GUISetAccelerators(0, $hPlayers)
			GUISetAccelerators(0, $hEncounter)
	EndSwitch


EndFunc   ;==>_GUICtrlSetState

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

Func AlignmentSwitch($shortForm)
	Switch $shortForm
		Case "N"
			Return "Neutral"
		Case "LN"
			Return "Lawful Neutral"
		Case "LG"
			Return "Lawful Good"
		Case "LE"
			Return "Lawful Evil"
		Case "NG"
			Return "Neutral Good"
		Case "NE"
			Return "Neutral Evil"
		Case "CN"
			Return "Chaotic Neutral"
		Case "CG"
			Return "Chaotic Good"
		Case "CE"
			Return "Chaotic Evil"
		Case "Unaligned"
			Return "Unaligned"
		Case Else
			Return "ERROR With Alignment Syntax"
	EndSwitch
EndFunc   ;==>AlignmentSwitch

Func SkillMatrix($iSkill, $iIndex, $iType = "Mod", $iOutput = "Int", $ArrayType = "Enc")
	if $ArrayType = "Enc" Then
		Local $skillMatrix = $encounterArray[$iIndex][3]
	Else
		Local $skillMatrix = $ArrayType
	EndIf
	Local $iResult
	For $i = 0 To UBound($skillMatrix) - 1
		If $skillMatrix[$i][0] = $iSkill Then
			Switch $iType
				Case "Base"
					$iResult = $skillMatrix[$i][1]
				Case "Mod"
					$iResult = $skillMatrix[$i][2]
				Case "Saving Throw"
					If $skillMatrix[$i][1] <> "" Then
						$iResult = $skillMatrix[$i][3]
					Else
						$iResult = $skillMatrix[$i][2]
					EndIf
			EndSwitch
			If $iOutput = "Int" Then $iResult = Int(StringReplace($iResult, "+", ""))
			Return $iResult
		EndIf
	Next
EndFunc   ;==>SkillMatrix

Func LaunchAll()
	;WinActivate($hMainGUI)
	If $playersActive Then
		WinActivate($hPlayers)
	Else
		PlayersWindow()
	EndIf
	If $encoActive Then
		WinActivate($hEncounter)
	Else
		EncounterWindow()
	EndIf
	If $initiativeActive Then
		WinActivate($hInitiative)
	Else
		InitiativeWindow()
	EndIf
EndFunc   ;==>LaunchAll
#EndRegion Utility Funcs -- Restart, Save Prefs, GUICtrlSetState, Titilise

#Region Search and Listview Funcs
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
		$searchArray[$qCount][1] = "Monster Name"
		$searchArray[$qCount][0] = GUICtrlRead($ihSearch)
		$qCount += 1
	EndIf
	If GUICtrlRead($cType) <> "Any" Then
		$searchArray[$qCount][1] = "Type"
		$searchArray[$qCount][0] = GUICtrlRead($cType)
		$qCount += 1
	EndIf
	If GUICtrlRead($cSize) <> "Any" Then
		$searchArray[$qCount][1] = "Size"
		$searchArray[$qCount][0] = GUICtrlRead($cSize)
		$qCount += 1
	EndIf
	If GUICtrlRead($cAlign) <> "Any" Then
		$searchArray[$qCount][1] = "Alignment"
		$searchArray[$qCount][0] = GUICtrlRead($cAlign)
		$qCount += 1
	EndIf
	If GUICtrlRead($cCustom) <> "Any" Then
		$searchArray[$qCount][1] = "Custom Monsters"
		$searchArray[$qCount][0] = GUICtrlRead($cCustom)
		$qCount += 1
	EndIf
	If GUICtrlRead($cCR) <> "Any" Then
		$searchArray[$qCount][1] = "CR"
		$searchArray[$qCount][0] = GUICtrlRead($cCR)
		$qCount += 1
	EndIf

	;_ArrayDisplay($searchArray)
	If $qCount > 0 Then
		ConsoleWrite("Qcount > 0" & @LF)
		ReDim $searchArray[$qCount][2]
		_GUICtrlSetState($GUI_DISABLE)
		SearchMonsters($searchArray)
		_GUICtrlSetState($GUI_ENABLE)
	Else
		ConsoleWrite("Qcount = 0" & @LF)
		_GUICtrlSetState($GUI_DISABLE)
		$monsterArray = CreateMonsterArray()
		_GUICtrlSetState($GUI_ENABLE)
	EndIf
EndFunc   ;==>Update

Func SearchMonsters($iSearch = 0)
	Local $listCount = 0

	_GUICtrlListView_DeleteAllItems($idListview)

	;;Sect[ITEM][0] = Monster Name
	;[ITME][1] = Size
	;[ITME][2] = Type
	;[ITME][3] = Tags
	;[ITME][4] = Alignment
	;[ITME][5] = CR
	;[ITME][6] = XP
	;[ITME][7] = HP
	For $i = 0 To UBound($monsterArray) - 1
		Local $include = True
		For $j = 0 To UBound($iSearch) - 1
			Switch $iSearch[$j][1]
				Case "Monster Name"
					If Not (StringInStr($monsterArray[$i][0], $iSearch[$j][0])) Then
						$include = False
						ExitLoop
					EndIf
				Case "Type"
					If Not (StringInStr($monsterArray[$i][2], $iSearch[$j][0])) Then
						$include = False
						ExitLoop
					EndIf
				Case "Size"
					If Not ($monsterArray[$i][1] = $iSearch[$j][0]) Then
						$include = False
						ExitLoop
					EndIf
				Case "Alignment"

					If $iSearch[$j][0] = "N" Then ;; -- Possible issues? Test with Custom Monsters
						For $a = 1 To StringLen($monsterArray[$i][4])
							If StringMid($monsterArray[$i][4], $a, 1) = "N" Then
								If $a = 1 Then
									If StringMid($monsterArray[$i][4], $a + 1, 1) <> " " And Not (StringMid($monsterArray[$i][4], $a + 1, 1) = "") Then
										$include = False
									Else
										$include = True
										ExitLoop
									EndIf
								EndIf
								If $a > 1 Then
									If StringMid($monsterArray[$i][4], $a - 1, 1) <> " " Then
										$include = False
									Else
										If StringMid($monsterArray[$i][4], $a + 1, 1) <> "" Then
											;ConsoleWrite(Stringmid($monsterArray[$i][4],$a+1,1) &@LF)
											$include = False
										Else
											$include = True
											ExitLoop
										EndIf
									EndIf
								EndIf
							EndIf
						Next
						If $include = False Then ExitLoop
					EndIf
					If Not (StringInStr($monsterArray[$i][4], $iSearch[$j][0])) Then
						$include = False
						ExitLoop
					EndIf
					If $monsterArray[$i][4] = "Unaligned" And $iSearch[$j][0] <> "Unaligned" Then
						$include = False
						ExitLoop
					EndIf



				Case "Custom Monsters"
					If $monsterArray[$i][9] = "CUSTOMMONSTER" Then
						If $iSearch[$j][0] = "No" Then
							$include = False
							ExitLoop
						EndIf
					Else
						If $iSearch[$j][0] = "Only" Then
							$include = False
							ExitLoop
						EndIf
					EndIf
				Case "CR"
					If Not ($monsterArray[$i][5] = $iSearch[$j][0]) Then
						$include = False
						ExitLoop
					EndIf
			EndSwitch
		Next
		If $include Then
			_GUICtrlListView_AddItem($idListview, $monsterArray[$i][0])
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][1], 1)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][2], 2)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][3], 3)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][4], 4)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][5], 5)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][6], 6)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][7], 7)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monsterArray[$i][8], 8)
			$listCount += 1
		EndIf
	Next

EndFunc   ;==>SearchMonsters

Func CreateMonsterArray($redoList = True)
	;;Sect[ITEM][0] = Monster Name
	;[ITME][1] = Size
	;[ITME][2] = Type
	;[ITME][3] = Tags
	;[ITME][4] = Alignment
	;[ITME][5] = CR
	;[ITME][6] = XP
	;[ITME][7] = HP
	;[ITME][8] = Source
	;[ITEM][9] = IniReadName (StringReplace " (in lair)"
	;[Item][10] = Dex Stat
	If $redoList Then _GUICtrlListView_DeleteAllItems($idListview)

	Local $listCount = 0

	$secT = IniReadSection($monBasicIni, "Monsters")
	Dim $monArray[$secT[0][0]][11]
	$defaultItems = $secT[0][0]

	;_ArrayDisplay($secT)
	For $j = 1 To $secT[0][0]

		$monArray[$listCount][0] = $secT[$j][0]


		$iSplit = StringSplit($secT[$j][1], "\\", 1)
		$monArray[$listCount][1] = $iSplit[1]
		$monArray[$listCount][2] = $iSplit[2]
		$monArray[$listCount][3] = $iSplit[3]
		$monArray[$listCount][4] = $iSplit[4]
		$monArray[$listCount][5] = $iSplit[5]
		$monArray[$listCount][6] = $iSplit[6]
		$monArray[$listCount][7] = $iSplit[7]
		$monArray[$listCount][8] = $iSplit[8]
		$monArray[$listCount][9] = StringReplace($secT[$j][0], " (in lair)", "")

		$monArray[$listCount][10] = IniRead($monCompIni, $monArray[$listCount][0], "Dex", "N/A")
		;$monArray[$listCount][6] = $monArray[$listCount][0]

		If $redoList Then
			_GUICtrlListView_AddItem($idListview, $monArray[$listCount][0])
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[1], 1)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[2], 2)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[3], 3)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[4], 4)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[5], 5)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[6], 6)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[7], 7)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[8], 9)
			_GUICtrlListView_AddSubItem($idListview, $listCount, $monArray[$listCount][10], 8)
		EndIf
		$listCount += 1

	Next

	#Region CUSTOM Monsters Below
	ConsoleWrite("Custom Ini = " & $custIni & @LF)
	If FileExists($custIni) Then

		$UB = UBound($monArray)
		$secT = IniReadSection($custIni, "Index")

		If IsArray($secT) Then
			ReDim $monArray[$UB + $secT[0][0]][11]
			;_ArrayDisplay($monArray)
			For $j = 1 To $secT[0][0]

				$monArray[$listCount][0] = $secT[$j][0]
				$iSplit = StringSplit($secT[$j][1], "\\", 1)
				If $iSplit[0] <> 8 Then ContinueLoop



				$monArray[$listCount][1] = $iSplit[1]
				$monArray[$listCount][2] = $iSplit[2]
				$monArray[$listCount][3] = $iSplit[3]
				$monArray[$listCount][4] = $iSplit[4]
				$monArray[$listCount][5] = $iSplit[5]
				$monArray[$listCount][6] = $iSplit[6]
				$monArray[$listCount][7] = $iSplit[7]
				$monArray[$listCount][8] = $iSplit[8]
				$monArray[$listCount][9] = "CUSTOMMONSTER"
				$monArray[$listCount][10] = IniRead($custIni, $monArray[$listCount][0] = $secT[$j][0], "Dex", "N/A")


				If $redoList Then
					_GUICtrlListView_AddItem($idListview, $monArray[$listCount][0])
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[1], 1)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[2], 2)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[3], 3)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[4], 4)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[5], 5)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[6], 6)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[7], 7)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $iSplit[8], 9)
					_GUICtrlListView_AddSubItem($idListview, $listCount, $monArray[$listCount][10], 8)
				EndIf
				$listCount += 1

			Next
		EndIf
	EndIf
	#EndRegion CUSTOM Monsters Below

	Return $monArray
EndFunc   ;==>CreateMonsterArray
#EndRegion Search and Listview Funcs

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
	GUISetState(@SW_DISABLE, $hMainGUI)

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

	$hSubs[$subWindows][5] = GUICtrlCreateEdit(_Titilise($iTitle) & $iData, 5, 5, $iWidth - 10, 210, $styles)
	GUICtrlSetFont(-1, 9, 400, -1, "Consolas")


	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

	GUISetState()

	GUISetState(@SW_ENABLE, $hMainGUI)
EndFunc   ;==>CreateSubWindow


#Region Notes Window and related Funcs
Func CreateNotesWindow($iTitle, $iStatsData, $iParent = $hMainGUI, $iType = "NPC", $iIndex = -1, $iStatArray = 0, $iLocal = False, $iMonRef = "");, $iImage = "");, $iWidth = 250); (if required)
;~ 	Use $iType to determine if It's NPC\Player
;~ 		--  Should I Allow the Initiative Manual Adds to have Notes?

;~ 	Use $iStatArray to carryItems over from NPCs (in encounter Array) and Players for use in rolls when implemented

;~ 	Use $statsData for the "Stats" part that is uneditable

;~ 	Use $iIndex to give focus if Window already active
Local $iWidth = 250

	For $i = 0 To UBound($hNotes) - 1
		If $hNotes[$i][2] = $iType And $hNotes[$i][3] = $iIndex Then
			ConsoleWrite("Type - " & $iType &@LF& "Index - " &$iIndex &@LF& "Title - " &$iTitle &@LF& "Title to Match - " & $hNotes[$i][4]&@LF)
			WinActivate($hNotes[$i][4],$hNotes[$i][4] & " - Stats:")
			ConsoleWrite(@extended &@LF)
			Return 0
		EndIf
	Next


	Local $height = 400
	If $iType = "NPC" And $iMonRef <> "" And $iLocal = True Then $height = 520
	GUISetState(@SW_DISABLE, $iParent) ;; Disable Parent GUI so that double clicks don't screw with us

	$notesWindows += 1

	ReDim $hNotes[$notesWindows + 1][25]

	$hNotes[$notesWindows][0] = GUICreate($iTitle, $iWidth, $height, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

	$hNotes[$notesWindows][1] = $iStatsData

	$hNotes[$notesWindows][2] = $iType
	$hNotes[$notesWindows][3] = $iIndex
	$hNotes[$notesWindows][4] = $iTitle
	;5 = Global Notes
	;6 = Local Notes
	$hNotes[$notesWindows][7] = $iStatArray
	;8 = Dice Roll Amount
	;9 = Dice Roll Sides
	;10 = Stat Type Combo
	;11 = Addition Input
	;12 = Modifier Radio
	;13 = Saving Throw Radio
	;14 = None Radio
	;15 = Adv. Radio
	;16 = DisAdv. Radio
	;17 = Roll Button
	;18 = Save Button
	$hNotes[$notesWindows][19] = $iMonRef
	;20 = Original Global Notes
	;21 = Original Local Notes
;~ 		- Initiative[$XX][10] = Local Notes
;~ 		- Encounter[$XX][17] = Local Notes
;~ 		- Players[$XX][17] = Local Notes
;	22 = Change Image
;	23 = Image Edit (Disabled) For Filename
;	24 = View Image

	GUICtrlCreateLabel($iTitle & " - Stats:", 5, 5)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	$styles = BitOR($ES_READONLY, $ES_MULTILINE, $WS_VSCROLL, $ES_WANTRETURN)
	GUICtrlCreateEdit(_Titilise($iTitle) & $iStatsData, 5, 22, $iWidth - 10, 105, $styles)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
	GUICtrlSetFont(-1, 9, 400, -1, "Consolas")

	$styles = BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_WANTRETURN)

	If ($iType = "NPC" OR $iType = "Monster") And $iMonRef <> "" Then
		GUICtrlCreateLabel($iMonRef & " - Global Notes", 5, 130)
		GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
		$hNotes[$notesWindows][20] = StringReplace(IniRead($globalNotesIni,$iMonRef,"Notes",""),"#CRLF#",@CRLF)
		$hNotes[$notesWindows][5] = GUICtrlCreateEdit($hNotes[$notesWindows][20], 5, 145, $iWidth - 10, 105, $styles) ;;; GLOBAL NOTES --- ADD Logic here to load in Global Notes if required
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKBOTTOM)
		GUICtrlSetFont(-1, 9, 400, -1, "Consolas")

		If $iLocal Then
			GUICtrlCreateLabel($iTitle & " - Local Notes", 5, 255)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			if $iType = "NPC" Then $hNotes[$notesWindows][21] = $encounterArray[$iIndex][17]
			$hNotes[$notesWindows][6] = GUICtrlCreateEdit($hNotes[$notesWindows][21], 5, 270, $iWidth - 10, 105, $styles) ;;; Local Notes
			GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKBOTTOM)
			GUICtrlSetFont(-1, 9, 400, -1, "Consolas")

			$hNotes[$notesWindows][22] = GUICtrlCreateButton("", 45, 380, 24, 24, $BS_ICON)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			GUICtrlSetImage(-1, $iconsIcl, 29, 0)
			GUICtrlSetTip(-1, "Edit Image")

			$hNotes[$notesWindows][23] = GUICtrlCreateInput(IniRead($globalNotesIni,$iMonRef,"Image",""), 75, 382, 105,20,$ES_READONLY + $ES_AUTOHSCROLL)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

			$hNotes[$notesWindows][24] = GUICtrlCreateButton("", 190, 380, 24, 24, $BS_ICON)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			GUICtrlSetImage(-1, $iconsIcl, 30, 0)
			GUICtrlSetTip(-1, "View Image")


			$hNotes[$notesWindows][18] = GUICtrlCreateButton("", 220, 380, 24, 24, $BS_ICON)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			GUICtrlSetImage(-1, $iconsIcl, 2, 0)
		Else
			$hNotes[$notesWindows][22] = GUICtrlCreateButton("", 45, 255, 24, 24, $BS_ICON)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			GUICtrlSetImage(-1, $iconsIcl, 29, 0)
			GUICtrlSetTip(-1, "Edit Image")

			$hNotes[$notesWindows][23] = GUICtrlCreateInput(IniRead($globalNotesIni,$iMonRef,"Image",""), 75, 257, 105,20,$ES_READONLY + $ES_AUTOHSCROLL)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

			$hNotes[$notesWindows][24] = GUICtrlCreateButton("", 190, 255, 24, 24, $BS_ICON)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			GUICtrlSetImage(-1, $iconsIcl, 30, 0)
			GUICtrlSetTip(-1, "View Image")

			$hNotes[$notesWindows][18] = GUICtrlCreateButton("", 220, 255, 24, 24, $BS_ICON)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			GUICtrlSetImage(-1, $iconsIcl, 2, 0)
		EndIf
	Else
		If $iLocal Then
			GUICtrlCreateLabel($iTitle & " - Local Notes", 5, 130)
			Switch $iType
				Case "NPC"
					$hNotes[$notesWindows][21] = $encounterArray[$iIndex][17]
				Case "Player"
					$hNotes[$notesWindows][21] = $playersArray[$iIndex][17]
				Case "Initiative", "Manual", "Autoroll"
					$hNotes[$notesWindows][21] = $initiativeArray[$iIndex][10]
			EndSwitch
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			$hNotes[$notesWindows][6] = GUICtrlCreateEdit($hNotes[$notesWindows][21], 5, 145, $iWidth - 10, 105, $styles) ;;; Local Notes
			GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKBOTTOM)
			GUICtrlSetFont(-1, 9, 400, -1, "Consolas")

			$hNotes[$notesWindows][18] = GUICtrlCreateButton("", 220, 255, 24, 24, $BS_ICON)
			GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
			GUICtrlSetImage(-1, $iconsIcl, 2, 0)
		EndIf
	EndIf



	GUICtrlCreateGroup("Roll:", 5, $height - 120, 240, 90)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

	$hNotes[$notesWindows][8] = GUICtrlCreateInput(1, 10, $height - 100, 20, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	_GuiInputSetOnlyNumbers($hNotes[$notesWindows][8], False)


	GUICtrlCreateLabel("d", 32, $height - 100, 10, 20)
	GUICtrlSetFont(-1, 14)

	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

	$hNotes[$notesWindows][9] = GUICtrlCreateCombo("4", 45, $height - 100, 45)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	_GuiInputSetOnlyNumbers($hNotes[$notesWindows][9], False)
	GUICtrlSetData($hNotes[$notesWindows][9], "6|8|10|12|20", "20")

	GUICtrlCreateLabel("+", 90, $height - 100, 10, 20)
	GUICtrlSetFont(-1, 14)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

	$hNotes[$notesWindows][10] = GUICtrlCreateCombo("Other", 103, $height - 100, 60,-1,$CBS_DROPDOWNLIST)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	_GuiInputSetOnlyNumbers($hNotes[$notesWindows][9], False)
	If IsArray($hNotes[$notesWindows][7]) Then GUICtrlSetData($hNotes[$notesWindows][10], "STR|DEX|CON|WIS|INT|CHA", "Other")

	$hNotes[$notesWindows][11] = GUICtrlCreateInput(0, 170, $height - 100, 40)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	_GuiInputSetOnlyNumbers($hNotes[$notesWindows][11], False)

	GUIStartGroup()
	$hNotes[$notesWindows][12] = GUICtrlCreateRadio("Modifier", 15, $height - 75)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$hNotes[$notesWindows][13] = GUICtrlCreateRadio("Saving Throw", 75, $height - 75)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

	GUIStartGroup()
	$hNotes[$notesWindows][14] = GUICtrlCreateRadio("None", 15, $height - 55)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$hNotes[$notesWindows][15] = GUICtrlCreateRadio("Adv.", 65, $height - 55)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	$hNotes[$notesWindows][16] = GUICtrlCreateRadio("Disadv.", 110, $height - 55)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

	$hNotes[$notesWindows][17] = GUICtrlCreateButton("", 190, $height - 75, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, $iconsIcl, 22, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)


	GUISetState()

	GUISetState(@SW_ENABLE, $iParent)
EndFunc   ;==>CreateNotesWindow

Func SaveGlobalNotes($iMonRef, $iNotesRef)
;~ 	20 = Original Global Notes
	$hNotes[$iNotesRef][20] = GUIctrlread($hNotes[$iNotesRef][5])
	IniWrite($globalNotesIni,$iMonRef,"Notes",StringReplace($hNotes[$iNotesRef][20],@CRLF,"#CRLF#"))
EndFunc

Func SaveLocalNotes($iType, $iIndex, $iData, $iNotesRef)
	Switch $iType
		Case "NPC"
			$encounterArray[$iIndex][17] = $iData
		Case "Player"
			$playersArray[$iIndex][17] = $iData
		Case "Initiative", "Manual", "Autoroll"
			$initiativeArray[$iIndex][10] = $iData
	EndSwitch
	$hNotes[$iNotesRef][21] = $iData
EndFunc
#EndRegion

#Region Initiative Window and Related Funcs
Func InitiativeWindow()

	;;-- Todo
	; Add advantage\Disadvantage for Rolls



	If $initiativeActive Then ; If window already active, give Initiative Window Focus
		WinActivate($initiativeTitle)
	Else ; Create Initiative Window
		$initiativeActive = True

		;$initiativeTitle = "New Initiative Window"

		$hInitiative = GUICreate($initiativeTitle, 400, 330, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

		GUISetFont(12, 700)
		GUICtrlCreateLabel("Manual Entry", 5, 200)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		GUISetFont(8.5, 400)

		GUICtrlCreateLabel("Name", 10, 220)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$initName = GUICtrlCreateInput("", 10, 235, 60)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		GUICtrlCreateLabel("Initiative Rolled", 80, 220)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$initRolled = GUICtrlCreateInput(0, 80, 235, 60, -1)
		_GuiInputSetOnlyNumbers($initRolled)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$initRolledUD = GUICtrlCreateUpdown(-1)
		GUICtrlSetLimit(-1, 50, -20)

		GUICtrlCreateLabel("Dex Modifier", 155, 220)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$initDexMod = GUICtrlCreateInput(0, 155, 235, 60, -1)
		_GuiInputSetOnlyNumbers($initDexMod)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$initDexModUD = GUICtrlCreateUpdown(-1)
		GUICtrlSetLimit(-1, 30, -10)

		GUICtrlCreateLabel("Current HP", 220, 220)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$initCurrHP = GUICtrlCreateInput(0, 223, 235, 60, -1)
		_GuiInputSetOnlyNumbers($initDexMod)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$initRollFor = GUICtrlCreateRadio("Roll initiative", 300, 220)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$initManualInput = GUICtrlCreateRadio("Manual Input", 300, 240)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)


		GUICtrlSetState($initRolled, $GUI_DISABLE)
;~ 		GUICtrlSetState($initDexModUD, $GUI_DISABLE)

		GUISetFont(14, 700)
		$initLoad = GUICtrlCreateButton("", 213, 193, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 24, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$initSave = GUICtrlCreateButton("", 238, 193, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 2, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$initNextTurn = GUICtrlCreateButton("", 298, 193, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 9, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$initAdd = GUICtrlCreateButton("", 323, 193, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 18, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		GUISetFont(8.5, 400)

		$initRefresh = GUICtrlCreateButton("", 348, 193, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 5, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$idLabel = GUICtrlCreateLabel("", 10, 10, 360, 180)
		GUICtrlSetBkColor(-1, 0xFFFFCC)

		$aStartSize = ControlGetPos($hInitiative, "", $idLabel)

		GUICtrlSetState($idLabel, $GUI_HIDE)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)

		$hInitDummy = GUICtrlCreateDummy()
		$hInitTurnDummy = GUICtrlCreateDummy()

		Dim $initArr[2][2] = [["{ENTER}", $hInitDummy], ["{NUMPADADD}", $hInitTurnDummy]]

		GUISetAccelerators($initArr, $hInitiative)




		$initChildStyles = $WS_CHILD + $WS_BORDER + $WS_TABSTOP
		$initChildStyleEx = $WS_EX_CONTROLPARENT
		$hInitChild = GUICreate($initChildTitle, 290, 180, 10, 10, $initChildStyles, $initChildStyleEx, $hInitiative)
		_GUIScrollbars_Generate($hInitChild, 280, 30, 1, 1, True)
		GUICtrlCreateLabel("Order", 3, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Name", 33, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("HP", 120, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Initiative", 145, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Notes", 188, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Skip", 260, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)


		GUISetState(@SW_SHOW, $hInitiative)
		GUISetState(@SW_SHOW, $hInitChild)

		If UBound($initiativeArray) > 0 Then InitiativeUpdate(0)


	EndIf
EndFunc   ;==>InitiativeWindow

Func InitiativeAdd($iName, $iType, $iRelIndex, $iRolledFor = True, $iDexMod = "n/a", $iInitiative = 0, $iHP = 0, $iSkip = False, $iUpdate = True)
;~ 	- $initiativeArray[$x][6] [[Index (0)],["Name"],[Type (Player\NPC or Monster\Manual)],[Relevant Index],[Current Initiative],[Dex mod],[GUI Parts],[Skip],[Name #Number],[HP]]
;~ 		- Unsure if Intiative Index is Required
;~ 		- Relevant Index to be used mostly for if a rename is parsed (from Player\NPC or Mosnter).


	$initUB = UBound($initiativeArray)
	ReDim $initiativeArray[$initUB + 1][11]

	Local $indexFound = False, $localIndex = -1, $nameFound = False, $nameIndex = -1, $nameIndexFound = False
	For $i = 0 To $initUB - 1
		$indexFound = False
		If $initiativeArray[$i][1] = $iName Then $nameFound = True
		For $j = 0 To $initUB - 1
			If $initiativeArray[$j][0] = $i Then
				$indexFound = True
				ExitLoop
			EndIf
		Next
		If $indexFound = False Then
			$localIndex = $i
			ExitLoop
		EndIf
	Next
	If $localIndex = -1 Then $localIndex = $initUB


	If $nameFound Then
		For $i = 1 To $initUB
			$nameIndexFound = False
			For $j = 0 To $initUB - 1
				If $initiativeArray[$j][1] = $iName Then
					If $initiativeArray[$j][8] = "" Then $initiativeArray[$j][8] = 1

					If $initiativeArray[$j][8] = $i Then
						$nameIndexFound = True
						ExitLoop
					EndIf
				EndIf
			Next
			If $nameIndexFound = False Then
				$initiativeArray[$initUB][8] = $i
				ExitLoop
			EndIf

		Next
	EndIf
	If $initiativeArray[$initUB][8] = "" And $nameFound Then $initiativeArray[$initUB][8] = $initUB + 1


	$initiativeArray[$initUB][0] = $localIndex
	$initiativeArray[$initUB][1] = $iName
	;if $nameFound then $initiativeArray[$initUB][1]
	$initiativeArray[$initUB][2] = $iType
	$initiativeArray[$initUB][3] = $iRelIndex
	$initiativeArray[$initUB][7] = $iSkip
	$initiativeArray[$initUB][9] = $iHP
	;10 = LocalNotes

	If $iRolledFor Then
		If $iDexMod = "n/a" Then $iDexMod = 0
		$roll = DiceRoll(20, 1, 0, $iDexMod)
		$initiativeArray[$initUB][4] = Int($roll[0] + $iDexMod)
		$initiativeArray[$initUB][5] = $iDexMod
	Else
		$initiativeArray[$initUB][4] = Int($iInitiative)
		$initiativeArray[$initUB][5] = $iDexMod
	EndIf


;~ 	_ArrayDisplay($initiativeArray)
	If $initiativeActive And $iUpdate Then InitiativeUpdate()
	Return $initUB
EndFunc   ;==>InitiativeAdd

Func InitiativeUpdate($readFromChild = 1, $destroyGUI = 1, $debug = 0) ;; FIX SO THAT THIS CHECKS IF THE NAME HAS CHANGED (still keeps #2 at the moment)
	Local $initSort, $initUB = UBound($initiativeArray), $initChildPos = WinGetPos($initiativeTitle)
	Dim $initSort[$initUB]

;~ 	_GUICtrlListView_DeleteAllItems($initList)
	If $readFromChild Then
		For $i = 0 To $initUB - 1 ;; Update changes made in GUI to array (reflected when new GUI items are created)
			Local $initGUIArray = $initiativeArray[$i][6]
			If IsArray($initGUIArray) Then
				If $initiativeArray[$i][2] = "Manual Entry" Or $initiativeArray[$i][2] = "Autoroll" Then
					$split = StringSplit(GUICtrlRead($initGUIArray[1]), " #", 1)
					If $split[0] = 1 Then $split = StringSplit(GUICtrlRead($initGUIArray[1]), "#", 1)
					$initiativeArray[$i][1] = StringStripWS($split[1],2)
				EndIf

				$initiativeArray[$i][4] = Int(GUICtrlRead($initGUIArray[2]))

				If GUICtrlRead($initGUIArray[3]) = $GUI_CHECKED Then
					$initiativeArray[$i][7] = True
				Else
					$initiativeArray[$i][7] = False
				EndIf
				$initiativeArray[$i][9] = GUICtrlRead($initGUIArray[4])
			EndIf
		Next
;~ 		If $playersActive Then ;; This works but need to fix so that it pulls it immediately like it does for Initiative from the Players window.
;~ 			For $i = 0 To $initUB - 1
;~ 				If $initiativeArray[$i][2] = "Player" Then
;~ 					If $initiativeArray[$i][4] <> $playersArray[$initiativeArray[$i][3]][16] Then $playersArray[$initiativeArray[$i][3]][16] = $initiativeArray[$i][4]
;~ 					If $initiativeArray[$i][9] <> $playersArray[$initiativeArray[$i][3]][11] Then $playersArray[$initiativeArray[$i][3]][11] = $initiativeArray[$i][9]
;~ 				EndIf
;~ 			Next
;~ 			PlayersUpdate(0, 0)
;~ 		EndIf
	EndIf

	#Region Initiative Sort Logic
	; Based off other players\npcs that have MORE initiative than Current selected
	For $i = 0 To $initUB - 1 ; For each item in Initiative Array
		$currAbove = 0
		For $j = 0 To $initUB - 1 ; As above
			If $initiativeArray[$i][0] = $initiativeArray[$j][0] Then ;if index is the same (same item)

			Else
				If $initiativeArray[$j][4] > $initiativeArray[$i][4] Then ;if Initiative is greater
;~ 					ConsoleWrite($initiativeArray[$j][1] & " > " & $initiativeArray[$i][4] & @LF)
					$currAbove += 1 ; Its initiative roll is higher than the $i item, there fore it is above $i in the order
				EndIf
				If $initiativeArray[$j][4] = $initiativeArray[$i][4] Then ; if the two have th same initiative
					Switch $initiativeArray[$j][2]; Check type
						Case "Manual Entry", "Player" ; If its a manual entry or a Player
							If $initiativeArray[$i][2] = "Autoroll" Then $currAbove += 1;if current is an Autoroll add one (put below players and manual entries)
							;;___ DO STUFF FOR NPCS Here LATER
;~ 					Case "Autoroll"
;~ 						if $initiativeArray[$i][2] = "Manual Entry" Then $currAbove -= 1
					EndSwitch
				EndIf
			EndIf


		Next

		If $initSort[$currAbove] <> "" Then ; this area checks for duplicates
			While $currAbove < $initUB - 1 And $initSort[$currAbove] <> ""

				$currAbove += 1
			WEnd
;~ 		ConsoleWrite($initiativeArray[$i][1] & " - CurrAbove - " & $currAbove &@LF)
;~ 		ConsoleWrite(_ArrayToString(
		EndIf
		If $i > 0 Then ;; Ads teh INITIATIVE ARRAY index to initSort Array
			$initSort[$currAbove] = Int($i)
		Else
			$initSort[$currAbove] = $i
		EndIf
	Next
	#EndRegion Initiative Sort Logic

	;_ArrayDisplay($initSort)

	If $initiativeActive Then
		If $destroyGUI Then
			GUIDelete($hInitChild)

			$hInitChild = GUICreate($initChildTitle, 290, 180, $initChildPos[0] + 10, $initChildPos[1] + 10, $initChildStyles, $initChildStyleEx, $hInitiative)
			$aPos = ControlGetPos($hInitiative, "", $idLabel)
			WinMove($hInitChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
			_GUIScrollbars_Generate($hInitChild, 280, 30 + $initUB * 25, 1, 1, True)

			GUICtrlCreateLabel("Order", 3, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Name", 33, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("HP", 150, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Initiative", 175, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Notes", 218, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Skip", 260, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)


;~ 	If $debug Then
;~ 		_ArrayDisplay($initSort)




			#Region Creating GUIs that require later Reference and adding to InitiativeArray
			For $i = 0 To $initUB - 1
				Local $initGUIArray = 0, $iQuickDexMod = ""


				Dim $initGUIArray[6]

				GUICtrlCreateLabel("#" & $i + 1, 5, 25 + $i * 25)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)

				If $initiativeArray[$initSort[$i]][8] > 1 Then
					$initGUIArray[1] = GUICtrlCreateInput($initiativeArray[$initSort[$i]][1] & " #" & $initiativeArray[$initSort[$i]][8], 25, 23 + $i * 25, 120)
				Else
					$initGUIArray[1] = GUICtrlCreateInput($initiativeArray[$initSort[$i]][1], 25, 23 + $i * 25, 120)
				EndIf
				If $initiativeArray[$initSort[$i]][2] = "Player" Then
					GUICtrlSetTip($initGUIArray[1], "Change name from Players Window")
					GUICtrlSetStyle($initGUIArray[1], $ES_READONLY)
				ElseIf $initiativeArray[$initSort[$i]][2] = "NPC" Then
					GUICtrlSetTip($initGUIArray[1], "Change name from NPC\Encounter Window")
					GUICtrlSetStyle($initGUIArray[1], $ES_READONLY)
				Else
					GUICtrlSetStyle($initGUIArray[1], $GUI_SS_DEFAULT_INPUT)
				EndIf
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				If $initiativeArray[$initSort[$i]][7] = True Then GUICtrlSetBkColor(-1, $COLOR_RED)

				$initGUIArray[4] = GUICtrlCreateInput($initiativeArray[$initSort[$i]][9], 150, 23 + $i * 25, 30)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)


				$initGUIArray[2] = GUICtrlCreateInput($initiativeArray[$initSort[$i]][4], 185, 23 + $i * 25, 30)
;~ 		_GuiInputSetOnlyNumbers($initGUIArray[2],False)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)


				$initGUIArray[5] = GUICtrlCreateButton("", 220, 22 + $i * 25, 23, 23, $BS_ICON)
				GUICtrlSetImage(-1, $iconsIcl, 23, 0)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)


;~ 				If $initiativeArray[$initSort[$i]][5] <> "n/a" Then

;~ 					If $initiativeArray[$initSort[$i]][5] > -1 Then $iQuickDexMod = "+"
;~ 					If $initiativeArray[$initSort[$i]][5] < 0 Then $iQuickDexMod = ""
;~ 					GUICtrlCreateLabel(($initiativeArray[$initSort[$i]][4] - $initiativeArray[$initSort[$i]][5]) & " (" & $iQuickDexMod & $initiativeArray[$initSort[$i]][5] & ")", 190, 25 + $i * 25, 60, 23, $SS_RIGHT)
;~ 				Else
;~ 					GUICtrlCreateLabel($initiativeArray[$initSort[$i]][4] & " (" & $initiativeArray[$initSort[$i]][5] & ")", 190, 25 + $i * 25, 60, 23, $SS_RIGHT)
;~ 				EndIf
;~ 				GUICtrlSetResizing(-1, $GUI_DOCKALL)

				$initGUIArray[3] = GUICtrlCreateCheckbox("", 260, 23 + $i * 25, 24, 24)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				If $initiativeArray[$initSort[$i]][7] = True Then GUICtrlSetState(-1, $GUI_CHECKED)

				$initGUIArray[0] = GUICtrlCreateButton("", 285, 22 + $i * 25, 24, 24, $BS_ICON)
				GUICtrlSetImage(-1, $iconsIcl, 10, 0)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)

				$initiativeArray[$initSort[$i]][6] = $initGUIArray


			Next
			#EndRegion Creating GUIs that require later Reference and adding to InitiativeArray

			GUISetState()
		Else
			For $i = 0 To $initUB - 1
				Local $initGUIArray = $initiativeArray[$i][6]



				If $initiativeArray[$i][8] > 1 Then
					GUICtrlSetData($initGUIArray[1], $initiativeArray[$i][1] & " #" & $initiativeArray[$i][8])
				Else
					GUICtrlSetData($initGUIArray[1], $initiativeArray[$i][1])
				EndIf

				If $initiativeArray[$i][7] = True Then
					GUICtrlSetState($initGUIArray[3], $GUI_CHECKED)
					GUICtrlSetBkColor($initGUIArray[1], $COLOR_RED)
				Else
					GUICtrlSetState($initGUIArray[3], $GUI_UNCHECKED)
;~ 				GUICtrlSetBkColor($initGUIArray[1], $COLOR_WHITE)
					If $initiativeArray[$i][2] = "Player" Or $initiativeArray[$i][2] = "NPC" Then
						GUICtrlSetBkColor($initGUIArray[1], 0xF0F0F0)
					Else
						GUICtrlSetBkColor($initGUIArray[1], $COLOR_WHITE)
					EndIf
				EndIf

				GUICtrlSetData($initGUIArray[4], $initiativeArray[$i][9])

;~ 			If $initiativeArray[$i][2] = "Player" Then
;~ 				GUICtrlSetTip($initGUIArray[1], "Change name frasdasdom Players Window")
;~ 				;GUICtrlSetStyle($initGUIArray[1], $EM_SETREADONLY)

;~ 				GUICtrlSetStyle($initGUIArray[1], $ES_READONLY)


;~ 			EndIf


			Next
		EndIf
	EndIf

	Return $initSort
EndFunc   ;==>InitiativeUpdate

Func InitNextTurn($increment = True)

	Local $initTurnSort = InitiativeUpdate(1, 0), $initUB = UBound($initTurnSort), $initValFound = False

	If $increment = True Then

		If UBound($initTurnSort) > 0 Then
			$initTurnIndex += 1
			If $initTurnIndex > ($initUB - 1) Then $initTurnIndex = 0
;~ 		ConsoleWrite("InitNextturn = " & $initTurnIndex &@LF)
			;for $i = 0 to $initUB - 1

			If $initiativeArray[$initTurnSort[$initTurnIndex]][7] Then ; If Skip = On
				ConsoleWrite($initTurnIndex & " - Skipping Current Turn" & @LF)
				For $i = 0 To $initUB
					$initTurnIndex += 1
					If $initTurnIndex > ($initUB - 1) Then $initTurnIndex = 0
					If $initiativeArray[$initTurnSort[$initTurnIndex]][7] Then
						ContinueLoop
					Else
						Local $initGUIArray = $initiativeArray[$initTurnSort[$initTurnIndex]][6]
						If $initiativeActive Then GUICtrlSetBkColor($initGUIArray[1], $COLOR_GREEN)
						$initTurnValue = $initTurnSort[$initTurnIndex]
						ExitLoop
					EndIf
				Next
			Else
				ConsoleWrite("Next Turn Index = " & $initTurnIndex & @LF & "Next Turn Value = " & $initTurnValue & @LF)
				Local $initGUIArray = $initiativeArray[$initTurnSort[$initTurnIndex]][6]
				If $initiativeActive Then GUICtrlSetBkColor($initGUIArray[1], $COLOR_GREEN)
				$initTurnValue = $initTurnSort[$initTurnIndex]
			EndIf
		EndIf
	Else
		If $initUB - 1 >= $initTurnIndex And $initTurnIndex > -1 Then
			If $initTurnSort[$initTurnIndex] = $initTurnValue Then
				Local $initGUIArray = $initiativeArray[$initTurnSort[$initTurnIndex]][6]


				If $initiativeArray[$initTurnSort[$initTurnIndex]][7] Then Return InitNextTurn()

				If $initiativeActive Then GUICtrlSetBkColor($initGUIArray[1], $COLOR_GREEN)
			Else

				For $i = 0 To $initUB - 1
					If $initTurnSort[$i] = $initTurnValue Then
						$initTurnIndex = $i
						If $initiativeArray[$initTurnSort[$initTurnIndex]][7] Then Return InitNextTurn()
						Local $initGUIArray = $initiativeArray[$initTurnSort[$initTurnIndex]][6]
						If $initiativeActive Then GUICtrlSetBkColor($initGUIArray[1], $COLOR_GREEN)
						$initValFound = True
						ExitLoop
					EndIf
				Next
				If Not ($initValFound) Then;; If it was the one with Turn Focus but has been deelted.;
					If $initUB - 1 >= $initTurnIndex Then
						If $initiativeArray[$initTurnSort[$initTurnIndex]][7] Then Return InitNextTurn()
						Local $initGUIArray = $initiativeArray[$initTurnSort[$initTurnIndex]][6]
						If $initiativeActive Then GUICtrlSetBkColor($initGUIArray[1], $COLOR_GREEN)
						$initTurnValue = $initTurnSort[$initTurnIndex]
					Else
						$initTurnIndex = 0
						If $initiativeArray[$initTurnSort[$initTurnIndex]][7] Then Return InitNextTurn()
						Local $initGUIArray = $initiativeArray[$initTurnSort[$initTurnIndex]][6]
						If $initiativeActive Then GUICtrlSetBkColor($initGUIArray[1], $COLOR_GREEN)
						$initTurnValue = $initTurnSort[$initTurnIndex]
					EndIf

					;; Manage this in the Delete area?
				EndIf
			EndIf
		EndIf
	EndIf

;~ 		if $initTurnIndex
EndFunc   ;==>InitNextTurn

Func InitCheckChildGUI($manualRefresh = 0)

	For $i = 0 To UBound($initiativeArray) - 1
		Local $playerFound = False, $npcFound = False
		$iGUIArray = $initiativeArray[$i][6] ; Child GUI for current Player
		$iReadInit = GUICtrlRead($iGUIArray[2]) ; Read initiative
		$iReadHP = GUICtrlRead($iGUIArray[4])
		If $iReadInit <> "" Then
			$iReadInit = Int($iReadInit)
		EndIf
		If $iReadHP <> "" Then
			$iReadHP = Int($iReadHP)
		EndIf

		If $initiativeArray[$i][2] = "Player" Then
			If $iReadInit <> $initiativeArray[$i][4] Or $iReadHP <> $initiativeArray[$i][9] Then
				If $iReadInit <> $initiativeArray[$i][4] Then
					InitiativeUpdate(1, 1) ;  Read from child but dont destroy.
				Else
					InitiativeUpdate(1, 0)
				EndIf
				If $initTurnIndex > -1 Then InitNextTurn(False)
				If IsArray($playersArray) Then
					For $j = 0 To UBound($playersArray) - 1
						If $playersArray[$j][0] = $initiativeArray[$i][3] Then
							ConsoleWrite("Player Type Found, Index: " & $playersArray[$j][0] & @LF)
							$playerFound = True
							$playerInt = $j
						EndIf
					Next
				EndIf
				If $playerFound Then
					$playersArray[$playerInt][16] = $initiativeArray[$i][4]
					$playersArray[$playerInt][11] = $initiativeArray[$i][9]

					If $playersActive Then PlayersUpdate(0, 0)
				EndIf
			EndIf
		ElseIf $initiativeArray[$i][2] = "NPC" Then
			If $iReadInit <> $initiativeArray[$i][4] Or $iReadHP <> $initiativeArray[$i][9] Then
				If $iReadInit <> $initiativeArray[$i][4] Then
					InitiativeUpdate(1, 1) ;  Read from child but dont destroy. ___ Erm no?
				Else
					InitiativeUpdate(1, 0)
				EndIf
				If $initTurnIndex > -1 Then InitNextTurn(False)
				If IsArray($encounterArray) Then
					For $j = 0 To UBound($encounterArray) - 1
						If $encounterArray[$j][0] = $initiativeArray[$i][3] Then
							ConsoleWrite("NPC Type Found, Index: " & $encounterArray[$j][0] & @LF)
							$npcFound = True
							$npcInt = $j
						EndIf
					Next
				EndIf
				If $npcFound Then
					$encounterArray[$npcInt][16] = $initiativeArray[$i][4]
					$encounterArray[$npcInt][11] = $initiativeArray[$i][9]
					If $encoActive Then
						EncounterUpdate(0, 0)
						ConsoleWrite("True" & @LF)
					EndIf
				EndIf
			EndIf
		Else

			If $iReadHP <> $initiativeArray[$i][9] Then
				InitiativeUpdate(1, 0)

				EndIf
			If $iReadInit <> $initiativeArray[$i][4] Then
				InitiativeUpdate(1, 1)
				If $initTurnIndex > -1 Then InitNextTurn(False)
			EndIf
;~ 			if GUICtrlRead($iGUIArray[1]) <> $initiativeArray[$i][1] & " #" & $initiativeArray[$i][8] Then
;~ 				InitiativeUpdate(1, 0)

;~ 			EndIf


		EndIf


	Next
;~ 	Return $playerFound
EndFunc   ;==>InitCheckChildGUI

Func InitSave()
;~ $initiativeArray[$x][6] [[Index (0)],["Name"],[Type (Player\NPC or Monster\Manual)],[Relevant Index],[Curr Init],[Dex mod],[GUI Parts],[Skip],[Name #Number],[HP]]
	Local $playerTypeFound = False, $initUB = UBound($initiativeArray)
	Local $savePlayersAlso = False, $secName = ""

	Local $initSaveLocation = $currentSaveLocation;"Init Test Save.ini"

;~ 	For $i = 0 To $initUB - 1;; Check if there are players in the initiative array and ask if they are to be saved to the same file
;~ 		If $initiativeArray[$i][2] = "Player" Then
;~ 			$playerTypeFound = True
;~ 			$savePlayersInt = MsgBox(48 + 4, "Players Found", "Players Found in the Initiative Window. " & @LF & "Also save players to this file? [FILE]") ;; FIX TO INCLUDE CHOSEN FILE LATER
;~ 			If $savePlayersInt = 6 Then $savePlayersAlso = True
;~ 			ExitLoop
;~ 		EndIf
;~ 	Next


;~ 	FileDelete($initSaveLocation)
	For $i = 0 To $initUB - 1
		If $initiativeArray[$i][2] = "Player" Or $initiativeArray[$i][2] = "NPC" Then ContinueLoop
		$secName = $initiativeArray[$i][1]
		If $initiativeArray[$i][8] > 1 Then $secName &= " #" & $initiativeArray[$i][8]
		$secName &= "_" & $initiativeArray[$i][0]
		IniWrite($initSaveLocation, $secName, "Type", $initiativeArray[$i][2])
		IniWrite($initSaveLocation, $secName, "Initiative", $initiativeArray[$i][4])
		IniWrite($initSaveLocation, $secName, "Dex Mod", $initiativeArray[$i][5])
		IniWrite($initSaveLocation, $secName, "Skip", $initiativeArray[$i][7])
		IniWrite($initSaveLocation, $secName, "HP", $initiativeArray[$i][9])
		If $initTurnValue = $i Then ;; Player save will have to check in with initiative Array to check if it has "Turn Focus"
			IniWrite($initSaveLocation, $secName, "MyTurn", "True")
		Else
			IniWrite($initSaveLocation, $secName, "MyTurn", "False")
		EndIf
		IniWrite($initSaveLocation,$secName, "LocalNotes",$initiativeArray[$i][10])
	Next
;~ 	if $savePlayersAlso Then PlayersSave()
EndFunc   ;==>InitSave

Func InitLoad($iOverwrite = False) ;; If you have #2, #3, #4 and you delete #3 then #4 will become #3 - Fix this somehow.
	Local $initLoadLocation = $currentLoadLocation;"Init Test Save.ini"
	Local $initLoadSecs, $initLoadSection, $initAlsoLoadPlayers = False, $loadPlayersChecked


	;; IF Overwrite then -----
	If $iOverwrite Then
		$initUB = UBound($initiativeArray) - 1
		For $i = 0 To $initUB
			If $initiativeArray[$i][2] = "Manual" Or $initiativeArray[$i][2] = "Autoroll" Then
				_ArrayDelete($initiativeArray, $i)
				$i -= 1
				$initUB -= 1
			EndIf
			If $i >= $initUB Then ExitLoop
		Next

	EndIf
	;; ENDIF

	$initLoadSecs = IniReadSectionNames($initLoadLocation)

	If IsArray($initLoadSecs) Then
		For $i = 1 To $initLoadSecs[0]
			$initLoadSection = IniReadSection($initLoadLocation, $initLoadSecs[$i])
			If $initLoadSection[1][1] = "Player" Then ContinueLoop
			;; On first "Load Player Data too? If yes LoadPlayersAlso = True
			If StringInStr($initLoadSecs[$i], "#") Then
				$split = StringSplit($initLoadSecs[$i], " #", 1)
				If StringInStr($split[1], "#") Then
					$split = StringSplit($initLoadSecs[$i], "#", 1)
					$initCurrSecName = $split[1]
				Else
					$initCurrSecName = $split[1]
				EndIf
			Else
				$split = StringSplit($initLoadSecs[$i], "_", 1)
				$initCurrSecName = $split[1]
			EndIf
			If $initLoadSection[4][1] = "False" Then $initLoadSection[4][1] = False
			If $initLoadSection[4][1] = "True" Then $initLoadSection[4][1] = True
			$initLoadIndex = InitiativeAdd($initCurrSecName, $initLoadSection[1][1], -1, False, $initLoadSection[3][1], _
			$initLoadSection[2][1], $initLoadSection[5][1], $initLoadSection[4][1], False)
			If $initLoadSection[6][1] = "True" Then
				$initTurnValue = $initLoadIndex
				$initTurnIndex = 0

			EndIf
			if $initLoadSection[0][0] >= 7 Then $initiativeArray[$initLoadIndex][10] = $initLoadSection[7][1]

		Next
		InitiativeUpdate()
		InitNextTurn(False)
	EndIf
EndFunc   ;==>InitLoad
#EndRegion Initiative Window and Related Funcs

#Region Player Window and Related Funcs
Func PlayersWindow()

;~ 	- $playersArray[$x][13]= [[Index (0)],["name"],[Str],[dex],[con],[int],[wis],[cha],[speed?],[AC],[MaxHP],[Class?],[level?]]
;~ 	- Some of these may not be necessary..

	;; Show Stats option?
	; - To cut down on shit on the screen just have this unticked with the Initiative Input (Tickbox and Roll Button), Health & Dead\Alive?
	;; Stats Button? Opens Window Etc..


	If $playersActive Then ; If window already active, give Initiative Window Focus
		WinActivate($playersTitle)
	Else ; Create Initiative Window
		Dim $playGUIArray[13]

		$playersActive = True

		$hPlayers = GUICreate($playersTitle, 430, 350, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

		$playFileMenu = GUICtrlCreateMenu("File")
;~ 		$pfSave = GUICtrlCreateMenuItem("Save Players", $playFileMenu)
;~ 		$pfLoad = GUICtrlCreateMenuItem("Load Players", $playFileMenu)

		$playOptionsMenu = GUICtrlCreateMenu("Options")
		$poPlayerRoll = GUICtrlCreateMenuItem("Enable DM Initiative Rolls", $playOptionsMenu, -1)
		;$poAutoAdd = GUICtrlCreateMenuItem("Auto Update Manual Initiative", $playOptionsMenu, -1)

		GUISetFont(12, 700)
		GUICtrlCreateLabel("Add Player", 5, 200)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		GUISetFont(8.5, 700)

		$playGUIArray[0] = GUICtrlCreateLabel("Name", 10, 220)
		$playGUIArray[1] = GUICtrlCreateLabel("STR", 85, 220)
		$playGUIArray[2] = GUICtrlCreateLabel("DEX", 120, 220)
		$playGUIArray[3] = GUICtrlCreateLabel("CON", 155, 220)
		$playGUIArray[4] = GUICtrlCreateLabel("INT", 190, 220)
		$playGUIArray[5] = GUICtrlCreateLabel("WIS", 225, 220)
		$playGUIArray[6] = GUICtrlCreateLabel("CHA", 260, 220)


		$playGUIArray[7] = GUICtrlCreateLabel("Level", 10, 260)
		$playGUIArray[8] = GUICtrlCreateLabel("Speed", 50, 260)

		$playGUIArray[9] = GUICtrlCreateLabel("MaxHP", 100, 260)
		$playGUIArray[10] = GUICtrlCreateLabel("AC", 145, 260)
		$playGUIArray[11] = GUICtrlCreateLabel("Class(es)", 180, 260)


		GUISetFont(8.5, 400)

		$playName = GUICtrlCreateInput("", 7, 235, 70)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playStr = GUICtrlCreateInput("", 85, 235, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playDex = GUICtrlCreateInput("", 120, 235, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playCon = GUICtrlCreateInput("", 155, 235, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playInt = GUICtrlCreateInput("", 190, 235, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playWis = GUICtrlCreateInput("", 225, 235, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playCha = GUICtrlCreateInput("", 260, 235, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$playLevel = GUICtrlCreateInput("", 10, 275, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playSpeed = GUICtrlCreateInput("", 50, 275, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playGUIArray[12] = GUICtrlCreateLabel("ft.", 80, 280)
		$playMaxHP = GUICtrlCreateInput("", 100, 275, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playAC = GUICtrlCreateInput("", 145, 275, 27, -1, $ES_NUMBER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playClasses = GUICtrlCreateInput("", 180, 275, 70)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)


		For $i = 0 To UBound($playGUIArray) - 1
			GUICtrlSetResizing($playGUIArray[$i], $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		Next

		$playLoad = GUICtrlCreateButton("", 300, 193, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 24, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$playSave = GUICtrlCreateButton("", 325, 193, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 2, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$playAdd = GUICtrlCreateButton("", 300, 230, 48, 48, $BS_ICON)
		GUICtrlSetTip(-1, "Add new player to the List")
		GUICtrlSetImage(-1, $iconsIcl, 18)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$playAddtoInitB = GUICtrlCreateButton("", 360, 230, 48, 48, $BS_ICON)
		GUICtrlSetTip(-1, "Add all existing players to the Initiative Window")
		GUICtrlSetImage(-1, $iconsIcl, 17)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		GUISetFont(12, 700)
		$playEditSave = GUICtrlCreateButton("Save", 300, 230, 60, -1, $BS_CENTER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		GUICtrlSetState(-1, $GUI_HIDE)

		$playEditCancel = GUICtrlCreateButton("Cancel", 300, 270, 60, -1, $BS_CENTER)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		GUICtrlSetState(-1, $GUI_HIDE)

		GUISetFont(8.5, 400)
;~ 		$playRefresh = GUICtrlCreateButton("", 278, 193, 24, 24, $BS_ICON)
;~ 		GUICtrlSetImage(-1, $iconsIcl, 5, 0)
;~ 		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$playChildSizeLabel = GUICtrlCreateLabel("", 10, 10, 410, 180)
		GUICtrlSetBkColor(-1, 0xFFFFCC)

		$playStartSize = ControlGetPos($hPlayers, "", $playChildSizeLabel)

		GUICtrlSetState($playChildSizeLabel, $GUI_HIDE)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)

		$hPlayDummy = GUICtrlCreateDummy()

		Dim $playArr[1][2] = [["{ENTER}", $hPlayDummy]]

		GUISetAccelerators($playArr, $hPlayers)




		$playChildStyles = $WS_CHILD + $WS_BORDER + $WS_TABSTOP
		$playChildStyleEx = $WS_EX_CONTROLPARENT
		$playChildStyleEx = $WS_EX_CONTROLPARENT
;~ 		$initChildStyleEx = -1
		$hPlayersChild = GUICreate($playersChildTitle, 420, 180, 10, 10, $playChildStyles, $playChildStyleEx, $hPlayers)
		_GUIScrollbars_Generate($hPlayersChild, 400, 30, 1, 1, True)
		GUICtrlCreateLabel("Name", 3, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("HP", 80, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("MaxHP", 115, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Dex  (Mod)", 158, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Initiative", 220, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		;if $enablePlayerRolling = True Then GUICtrlsetstate of inputs $ES_READONLY
		; Initiative  & Enable Initiative Rolling? Maybe Enable Initiative Rolling from File Menu?
		GUICtrlCreateLabel("Notes", 270, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Skip", 310, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Edit   Delete", 335, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)


		GUISetState(@SW_SHOW, $hPlayers)
		GUISetState(@SW_SHOW, $hPlayersChild)

		ConsoleWrite("hiiiiiiitest" & @LF)
		If UBound($playersArray) > 0 Then PlayersUpdate(1, 0)
		If $autoAddToInitiative Then GUICtrlSetState($poAutoAdd, $GUI_CHECKED)
		If $enablePlayerRolling Then GUICtrlSetState($poPlayerRoll, $GUI_CHECKED)


	EndIf
EndFunc   ;==>PlayersWindow

Func PlayerAdd($pAddByArray = "", $iUpdate = True)
;~ 	- $playersArray[$x][13]= [[Index (0)],["name"],
	$playUB = UBound($playersArray)

	ReDim $playersArray[$playUB + 1][18]

	Local $indexFound = False, $localIndex = -1
	For $i = 0 To $playUB - 1
		$indexFound = False
		For $j = 0 To $playUB - 1
			If $playersArray[$j][0] = $i Then
				$indexFound = True
				ExitLoop
			EndIf
		Next
		If $indexFound = False Then
			$localIndex = $i
			ExitLoop
		EndIf
	Next
	If $localIndex = -1 Then $localIndex = $playUB


	;$playName, $playStr, $playDex, $playCon, $playInt, $playWis, $playCha, $playLevel, $playSpeed, $playMaxHP,$playAC, $playClasses
;~ 	[Str],[dex],[con],[int],[wis],[cha],[speed?],[AC],[MaxHP],[Class?],[level?]]
	$playersArray[$playUB][0] = $localIndex
	If $pAddByArray = "" Then
;~ 	$playersArray[$playUB][1] -- GUI Array here.
		$playersArray[$playUB][2] = GUICtrlRead($playName)
		$playersArray[$playUB][3] = GUICtrlRead($playStr)
		$playersArray[$playUB][4] = GUICtrlRead($playDex)
		$playersArray[$playUB][5] = GUICtrlRead($playCon)
		$playersArray[$playUB][6] = GUICtrlRead($playInt)
		$playersArray[$playUB][7] = GUICtrlRead($playWis)
		$playersArray[$playUB][8] = GUICtrlRead($playCha)
		$playersArray[$playUB][9] = GUICtrlRead($playSpeed)
		$playersArray[$playUB][10] = GUICtrlRead($playAC)
;~ 	Current HP on 11
		$playersArray[$playUB][11] = GUICtrlRead($playMaxHP)
		$playersArray[$playUB][12] = GUICtrlRead($playMaxHP)
		$playersArray[$playUB][13] = GUICtrlRead($playClasses)
		$playersArray[$playUB][14] = GUICtrlRead($playLevel)
;~  Skip Boolean on 15
;~ 	Initiative on 16
;~ 	Local notes on 17


		GUICtrlSetData($playName, "")
		GUICtrlSetData($playStr, "")
		GUICtrlSetData($playDex, "")
		GUICtrlSetData($playCon, "")
		GUICtrlSetData($playInt, "")
		GUICtrlSetData($playWis, "")
		GUICtrlSetData($playCha, "")
		GUICtrlSetData($playSpeed, "")
		GUICtrlSetData($playAC, "")
		GUICtrlSetData($playMaxHP, "")
		GUICtrlSetData($playClasses, "")
		GUICtrlSetData($playLevel, "")
		PlayersUpdate()
	Else
		If IsArray($pAddByArray) Then
			$playersArray[$playUB][2] = $pAddByArray[2]
			$playersArray[$playUB][3] = $pAddByArray[3]
			$playersArray[$playUB][4] = $pAddByArray[4]
			$playersArray[$playUB][5] = $pAddByArray[5]
			$playersArray[$playUB][6] = $pAddByArray[6]
			$playersArray[$playUB][7] = $pAddByArray[7]
			$playersArray[$playUB][8] = $pAddByArray[8]
			$playersArray[$playUB][9] = $pAddByArray[9]
			$playersArray[$playUB][10] = $pAddByArray[10]
			$playersArray[$playUB][11] = $pAddByArray[11]
			$playersArray[$playUB][12] = $pAddByArray[12]
			$playersArray[$playUB][13] = $pAddByArray[13]
			$playersArray[$playUB][14] = $pAddByArray[14]
			$playersArray[$playUB][15] = $pAddByArray[15]
			$playersArray[$playUB][16] = $pAddByArray[16]
			$playersArray[$playUB][17] = $pAddByArray[18]

		EndIf

		If $playersActive And $iUpdate Then PlayersUpdate()
	EndIf

;~ 	_ArrayDisplay($playersArray)

	Return $playUB
EndFunc   ;==>PlayerAdd

Func PlayersUpdate($destroyGUI = 1, $readFromChild = 1) ;, $excludeInt = -1)  Use this to include current item being edited if required?

	Local $playUB = UBound($playersArray), $playTooltip
	Local $playChildPos = WinGetPos($playersTitle)
	; Put update from GUI LOGIC HERE
	If $readFromChild Then
		For $i = 0 To $playUB - 1 ;; Update changes made in GUI to array (reflected when new GUI items are created)
			Local $pGUIArray = $playersArray[$i][1]
			If IsArray($pGUIArray) Then
				$playersArray[$i][2] = GUICtrlRead($pGUIArray[1])
				$playersArray[$i][11] = GUICtrlRead($pGUIArray[2])
				$playersArray[$i][16] = Int(GUICtrlRead($pGUIArray[6]))
				If GUICtrlRead($pGUIArray[10]) = $GUI_CHECKED Then
					$playersArray[$i][15] = True
				Else
					$playersArray[$i][15] = False
				EndIf
			EndIf
		Next
	EndIf

	; Put update from GUI LOGIC HERE
	If $playersActive Then
		If $destroyGUI Then
			GUIDelete($hPlayersChild)

			$hPlayersChild = GUICreate($playersChildTitle, 420, 180, $playChildPos[0] + 10, $playChildPos[1] + 10, $playChildStyles, $playChildStyleEx, $hPlayers)
			$aPos = ControlGetPos($hPlayers, "", $playChildSizeLabel)
			WinMove($hPlayersChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
			_GUIScrollbars_Generate($hPlayersChild, 400, 30 + $playUB * 25, 1, 1, True)

			GUICtrlCreateLabel("Name", 3, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("HP", 80, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("MaxHP", 115, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Dex  (Mod)", 158, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Initiative", 220, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			;if $enablePlayerRolling = True Then GUICtrlsetstate of inputs $ES_READONLY
			; Initiative  & Enable Initiative Rolling? Maybe Enable Initiative Rolling from File Menu?
			GUICtrlCreateLabel("Notes", 270, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Skip", 310, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("Edit   Delete", 340, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)

			For $i = 0 To $playUB - 1
				Local $pGUIArray = 0, $pDexMod = 0

				Dim $pGUIArray[15]

				$playTooltip = PlayersTip($i)

				$pGUIArray[1] = GUICtrlCreateInput($playersArray[$i][2], 5, 23 + $i * 25, 70, 20)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				GUICtrlSetTip(-1, $playTooltip)
				If $playersArray[$i][15] = True Then GUICtrlSetBkColor(-1, $COLOR_RED)

				$pGUIArray[2] = GUICtrlCreateInput($playersArray[$i][11], 80, 23 + $i * 25, 30, 20)
				_GuiInputSetOnlyNumbers($pGUIArray[2], False)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)

				$pGUIArray[3] = GUICtrlCreateLabel($playersArray[$i][12], 115, 26 + $i * 25, 30, 23)
;~ 			_GuiInputSetOnlyNumbers($pGUIArray[2],False)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				GUICtrlSetTip(-1, $playTooltip)

				$pDexMod = CalcStatMod($playersArray[$i][4])
				$pGUIArray[4] = GUICtrlCreateLabel($playersArray[$i][4], 160, 26 + $i * 25, 18, 23)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				GUICtrlSetTip(-1, $playTooltip)

				$pGUIArray[5] = GUICtrlCreateLabel($pDexMod, 180, 26 + $i * 25)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)


				$pGUIArray[6] = GUICtrlCreateInput($playersArray[$i][16], 220, 23 + $i * 25, 20)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				_GuiInputSetOnlyNumbers($pGUIArray[6], False)
				If $enablePlayerRolling Then GUICtrlSetState(-1, $GUI_DISABLE)
				If $autoAddToInitiative Then GUICtrlSetPos(-1, 220, 23 + $i * 25, 40)

				If $enablePlayerRolling Then
					$pGUIArray[8] = GUICtrlCreateButton("", 241, 22 + $i * 25, 23, 23, $BS_ICON)
					GUICtrlSetImage(-1, $iconsIcl, 22, 0)
					GUICtrlSetResizing(-1, $GUI_DOCKALL)
				Else

					If Not ($autoAddToInitiative) Then
						$pGUIArray[7] = GUICtrlCreateButton("", 241, 22 + $i * 25, 23, 23, $BS_ICON)
						GUICtrlSetImage(-1, $iconsIcl, 17, 0)
						GUICtrlSetResizing(-1, $GUI_DOCKALL)
					EndIf
				EndIf

				$pGUIArray[9] = GUICtrlCreateButton("", 272, 22 + $i * 25, 23, 23, $BS_ICON)
				GUICtrlSetImage(-1, $iconsIcl, 23, 0)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				GUICtrlSetTip(-1, $playTooltip) ;;; Possibly change this tip - May need to explain notes quickly

				$pGUIArray[10] = GUICtrlCreateCheckbox("", 315, 23 + $i * 25, 24, 24)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				If $playersArray[$i][15] = True Then GUICtrlSetState(-1, $GUI_CHECKED)

				$pGUIArray[11] = GUICtrlCreateButton("", 340, 22 + $i * 25, 23, 23, $BS_ICON)
				GUICtrlSetImage(-1, $iconsIcl, 11, 0)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)
				GUICtrlSetTip(-1, $playTooltip)

				$pGUIArray[0] = GUICtrlCreateButton("", 375, 21 + $i * 25, 24, 24, $BS_ICON) ;; Delete?
				GUICtrlSetImage(-1, $iconsIcl, 10, 0)
				GUICtrlSetResizing(-1, $GUI_DOCKALL)

				$playersArray[$i][1] = $pGUIArray

			Next

			GUISetState()
		Else ; if just refreshing GUI elements with new info ( no deleted or added characters)


			For $i = 0 To $playUB - 1 ;; Update changes made in GUI to array (reflected when new GUI items are created)

				$playTooltip = PlayersTip($i)

				Local $pGUIArray = $playersArray[$i][1]
				If IsArray($pGUIArray) Then
					GUICtrlSetData($pGUIArray[1], $playersArray[$i][2])
					GUICtrlSetData($pGUIArray[2], $playersArray[$i][11])
					GUICtrlSetData($pGUIArray[3], $playersArray[$i][12])
					GUICtrlSetData($pGUIArray[6], $playersArray[$i][16])
					GUICtrlSetData($pGUIArray[4], $playersArray[$i][4])

					GUICtrlSetTip($pGUIArray[1], $playTooltip)
					GUICtrlSetTip($pGUIArray[3], $playTooltip)
					GUICtrlSetTip($pGUIArray[4], $playTooltip)
					GUICtrlSetTip($pGUIArray[9], $playTooltip)
					GUICtrlSetTip($pGUIArray[11], $playTooltip)

					If $playersArray[$i][15] Then

						GUICtrlSetState($pGUIArray[10], $GUI_CHECKED)
						GUICtrlSetBkColor($pGUIArray[1], $COLOR_RED)
					Else
						GUICtrlSetState($pGUIArray[10], $GUI_UNCHECKED)
						GUICtrlSetBkColor($pGUIArray[1], $COLOR_WHITE)
					EndIf

					GUICtrlSetData($pGUIArray[5], CalcStatMod($playersArray[$i][4]))
				EndIf
			Next
		EndIf
	EndIf
EndFunc   ;==>PlayersUpdate

Func PlayersCheckChildGUI($manualRefresh = 0)

	For $i = 0 To UBound($playersArray) - 1
		Local $playerFound = False
		$pGUIArray = $playersArray[$i][1] ; Child GUI for current Player
		$pReadInit = GUICtrlRead($pGUIArray[6]) ; Read initiative
		$pReadHP = GUICtrlRead($pGUIArray[2])

		If $pReadInit <> "" Then $pReadInit = Int($pReadInit)
		If $pReadHP <> "" Then $pReadHP = Int($pReadHP)


		If $pReadInit <> $playersArray[$i][16] Then
			;ConsoleWrite(@SEC & " hittest &@LF" & @LF)
			PlayersUpdate(0) ; Read from child but don't destroy
			If IsArray($initiativeArray) Then
				For $j = 0 To UBound($initiativeArray) - 1
					If $initiativeArray[$j][2] = "Player" And $initiativeArray[$j][3] = $playersArray[$i][0] Then
						ConsoleWrite("Player Type Found, Index: " & $playersArray[$i][0] & @LF)
						$playerFound = True
						$playerInt = $j
					EndIf
				Next
			EndIf
			If Not ($playerFound) And $autoAddToInitiative Then
				ConsoleWrite("Player Not Found - AutoAddtoInitiative Enabled" & @LF & "HP: " & $playersArray[$i][11] & @LF)
				InitiativeAdd($playersArray[$i][2], "Player", $playersArray[$i][0], False, CalcStatMod($playersArray[$i][4], 0, 0), $playersArray[$i][16], $playersArray[$i][11])
				If $initTurnIndex > -1 Then InitNextTurn(False)
			EndIf
			If $playerFound Then
				$initiativeArray[$playerInt][4] = $playersArray[$i][16]
				$initiativeArray[$playerInt][9] = $playersArray[$i][11]
				$initiativeArray[$playerInt][1] = $playersArray[$i][2]
				If $initiativeActive Then
					InitiativeUpdate(0)
					If $initTurnIndex > -1 Then InitNextTurn(False)
				EndIf
			EndIf
			;EndIf
		ElseIf GUICtrlRead($pGUIArray[1]) <> $playersArray[$i][2] Or $pReadHP <> $playersArray[$i][11] Then ;; IF name or HP Changed.. Then update in initiative window.
			ConsoleWrite("Hit || " & $pReadHP & " <> " & $playersArray[$i][11] & @LF)
			PlayersUpdate(0)
			ConsoleWrite("After Update - " & $pReadHP & " <> " & $playersArray[$i][11] & @LF)
			For $j = 0 To UBound($initiativeArray) - 1
				If $initiativeArray[$j][2] = "Player" And $initiativeArray[$j][3] = $playersArray[$i][0] Then
					$initiativeArray[$j][1] = $playersArray[$i][2]
					$initiativeArray[$j][9] = $playersArray[$i][11]
					InitiativeUpdate(0, 0)
					If $initTurnIndex > -1 Then InitNextTurn(False)
					ExitLoop
				EndIf
			Next

		EndIf
	Next
	;Return $playerFound
EndFunc   ;==>PlayersCheckChildGUI

Func PlayersTip($i)
	Local $playTooltip = ""
	$playTooltip = $playersArray[$i][2] & "'s Stats: " & @CRLF
	If $playersArray[$i][14] <> "" Then $playTooltip &= "Level - " & $playersArray[$i][14] & @CRLF
	If $playersArray[$i][3] <> "" Then $playTooltip &= "STR - " & $playersArray[$i][3] & " " & CalcStatMod($playersArray[$i][3]) & @CRLF
	If $playersArray[$i][4] <> "" Then $playTooltip &= "DEX - " & $playersArray[$i][4] & " " & CalcStatMod($playersArray[$i][4]) & @CRLF
	If $playersArray[$i][5] <> "" Then $playTooltip &= "CON - " & $playersArray[$i][5] & " " & CalcStatMod($playersArray[$i][5]) & @CRLF
	If $playersArray[$i][6] <> "" Then $playTooltip &= "INT - " & $playersArray[$i][6] & " " & CalcStatMod($playersArray[$i][6]) & @CRLF
	If $playersArray[$i][7] <> "" Then $playTooltip &= "WIS - " & $playersArray[$i][7] & " " & CalcStatMod($playersArray[$i][7]) & @CRLF
	If $playersArray[$i][8] <> "" Then $playTooltip &= "CHA - " & $playersArray[$i][8] & " " & CalcStatMod($playersArray[$i][8]) & @CRLF
	If $playersArray[$i][9] <> "" Then $playTooltip &= "Speed - " & $playersArray[$i][9] & @CRLF
	If $playersArray[$i][10] <> "" Then $playTooltip &= "AC - " & $playersArray[$i][10] & @CRLF
	If $playersArray[$i][12] <> "" Then $playTooltip &= "MaxHP - " & $playersArray[$i][12] & @CRLF
	If $playersArray[$i][13] <> "" Then $playTooltip &= "Classes - " & $playersArray[$i][13]

	Return $playTooltip
EndFunc   ;==>PlayersTip

Func PlayersSave()

	;$playName, $playStr, $playDex, $playCon, $playInt, $playWis, $playCha, $playLevel, $playSpeed, $playMaxHP,$playAC, $playClasses
;~ 	[Str],[dex],[con],[int],[wis],[cha],[speed?],[AC],[MaxHP],[Class?],[level?]]
;~ 	$playersArray[$playUB][0] = $localIndex
;~ 	$playersArray[$playUB][1] -- GUI Array here.
;~ 	$playersArray[$playUB][2] = GUICtrlRead($playName)
;~ 	$playersArray[$playUB][3] = GUICtrlRead($playStr)
;~ 	$playersArray[$playUB][4] = GUICtrlRead($playDex)
;~ 	$playersArray[$playUB][5] = GUICtrlRead($playCon)
;~ 	$playersArray[$playUB][6] = GUICtrlRead($playInt)
;~ 	$playersArray[$playUB][7] = GUICtrlRead($playWis)
;~ 	$playersArray[$playUB][8] = GUICtrlRead($playCha)
;~ 	$playersArray[$playUB][9] = GUICtrlRead($playSpeed)
;~ 	$playersArray[$playUB][10] = GUICtrlRead($playAC)
;~ 	Current HP on 11
;~ 	$playersArray[$playUB][11] = GUICtrlRead($playMaxHP)
;~ 	$playersArray[$playUB][12] = GUICtrlRead($playMaxHP)
;~ 	$playersArray[$playUB][13] = GUICtrlRead($playClasses)
;~ 	$playersArray[$playUB][14] = GUICtrlRead($playLevel)
;~  Skip Boolean on 15
;~ 	Initiative on 16

	Local $playSaveLocation = $currentSaveLocation


	For $i = 0 To UBound($playersArray) - 1
		$secName = $playersArray[$i][2]
		$secName &= "_" & $playersArray[$i][0]
		IniWrite($playSaveLocation, $secName, "Type", "Player")
		IniWrite($playSaveLocation, $secName, "PartOfInitiativeArray", "False")
		IniWrite($playSaveLocation, $secName, "STR", $playersArray[$i][3])
		IniWrite($playSaveLocation, $secName, "DEX", $playersArray[$i][4])
		IniWrite($playSaveLocation, $secName, "CON", $playersArray[$i][5])
		IniWrite($playSaveLocation, $secName, "INT", $playersArray[$i][6])
		IniWrite($playSaveLocation, $secName, "WIS", $playersArray[$i][7])
		IniWrite($playSaveLocation, $secName, "CHA", $playersArray[$i][8])
		IniWrite($playSaveLocation, $secName, "Speed", $playersArray[$i][9])
		IniWrite($playSaveLocation, $secName, "AC", $playersArray[$i][10])
		IniWrite($playSaveLocation, $secName, "CurrHP", $playersArray[$i][11])
		IniWrite($playSaveLocation, $secName, "MaxHP", $playersArray[$i][12])
		IniWrite($playSaveLocation, $secName, "Classes", $playersArray[$i][13])
		IniWrite($playSaveLocation, $secName, "Level", $playersArray[$i][14])
		If $playersArray[$i][15] Then IniWrite($playSaveLocation, $secName, "Skip", $playersArray[$i][15])
		If Not ($playersArray[$i][15]) Then IniWrite($playSaveLocation, $secName, "Skip", False)
		IniWrite($playSaveLocation, $secName, "Initiative", $playersArray[$i][16])

		IniWrite($playSaveLocation, $secName, "MyTurn", "False")
		If IsArray($initiativeArray) Then
			For $j = 0 To UBound($initiativeArray) - 1
				If $initiativeArray[$j][2] = "Player" And $initiativeArray[$j][3] = $playersArray[$i][0] Then
					IniWrite($playSaveLocation, $secName, "PartOfInitiativeArray", "True")
					If $initTurnValue = $j Then ;; Player save will have to check in with initiative Array to check if it has "Turn Focus"
						IniWrite($playSaveLocation, $secName, "MyTurn", "True")

					EndIf
				EndIf
			Next
		EndIf
		IniWrite($playSaveLocation, $secName, "LocalNotes", StringReplace($playersArray[$i][17],@CRLF,"#CRLF#"))
	Next
EndFunc   ;==>PlayersSave

Func PlayersLoad($iOverwrite = False)

	Local $playLoadLocation = $currentLoadLocation;"Init Test Save.ini"
	Local $playLoadSecs, $playLoadSection, $initUpdated


	;; IF Overwrite then -----
	If $iOverwrite Then
		$playUB = UBound($initiativeArray) - 1
		For $i = 0 To $playUB
			If $initiativeArray[$i][2] = "Player" Then
				_ArrayDelete($initiativeArray, $i)
				$i -= 1
				$playUB -= 1
			EndIf
			If $i >= $playUB Then ExitLoop
		Next
		$playersArray = 0
		Dim $playersArray[0][0]
	EndIf
	;; ENDIF

	$playLoadSecs = IniReadSectionNames($playLoadLocation)
	If IsArray($playLoadSecs) Then
		For $i = 1 To $playLoadSecs[0]
			$playLoadSection = IniReadSection($playLoadLocation, $playLoadSecs[$i])
			If $playLoadSection[1][1] <> "Player" Then ContinueLoop ;; Skip anything that isnt a player ;)


;~ 		[test_0]
;~ Type=Player
;~ PartOfInitiativeArray=True
;~ STR=
;~ DEX=
;~ CON=
;~ INT=
;~ WIS=
;~ CHA=
;~ Speed=
;~ AC=
;~ CurrHP=
;~ MaxHP=
;~ Classes=
;~ Level=
;~ Skip=False
;~ Initiative=1313
;~ MyTurn=False

			$split = StringSplit($playLoadSecs[$i], "_", 1)
			Dim $playAddArray[19]

			$playAddArray[1] = $playLoadSection[2][1]
			$playAddArray[2] = $split[1]
			$playAddArray[3] = $playLoadSection[3][1]
			$playAddArray[4] = $playLoadSection[4][1]
			$playAddArray[5] = $playLoadSection[5][1]
			$playAddArray[6] = $playLoadSection[6][1]
			$playAddArray[7] = $playLoadSection[7][1]
			$playAddArray[8] = $playLoadSection[8][1]
			$playAddArray[9] = $playLoadSection[9][1]
			$playAddArray[10] = $playLoadSection[10][1]
			$playAddArray[11] = $playLoadSection[11][1]
			$playAddArray[12] = $playLoadSection[12][1]
			$playAddArray[13] = $playLoadSection[13][1]
			$playAddArray[14] = $playLoadSection[14][1]
			$playAddArray[15] = $playLoadSection[15][1]
			If $playAddArray[15] = "True" Then
				$playAddArray[15] = True
			Else
				$playAddArray[15] = False
			EndIf
			$playAddArray[16] = $playLoadSection[16][1]
			$playAddArray[17] = $playLoadSection[17][1]
			if $playLoadSection[0][0] >= 18 Then $playAddArray[18] = $playLoadSection[18][1]


			$playLoadIndex = PlayerAdd($playAddArray, False)
			If $playAddArray[1] = "True" Then
				ConsoleWrite("Loading " & $playAddArray[2] & " into initiative Window" & @LF)
				$playAddtoInitIndex = InitiativeAdd($playAddArray[2], "Player", $playLoadIndex, False, CalcStatMod($playAddArray[4], 0, 0), $playAddArray[16], $playAddArray[11], $playAddArray[15])
				If $playAddArray[17] = "True" Then
					$initTurnValue = $playAddtoInitIndex
					$initTurnIndex = 0
				EndIf
			EndIf

		Next

		InitNextTurn(False)
	EndIf
	PlayersUpdate()
EndFunc   ;==>PlayersLoad

Func PlayersAddtoInitiative()

	For $i = 0 To UBound($playersArray) - 1
		Local $playerFound = False
		For $j = 0 To UBound($initiativeArray) - 1
			If $initiativeArray[$j][2] = "Player" Then
				If $playersArray[$i][0] = $initiativeArray[$j][3] Then
					$playerFound = True
				EndIf
			EndIf
		Next
		If $playerFound = False Then
			;InitAdd($iName, $iType, $iRelIndex, $iRolledFor = True, $iDexMod = 0, $iInitiative = 0, $iHP = 0, $iSkip = False, $iUpdate = True
			InitiativeAdd($playersArray[$i][2], "Player", $playersArray[$i][0], False, CalcStatMod($playersArray[$i][4], 0, 0), $playersArray[$i][16], $playersArray[$i][11], $playersArray[$i][15], False)
		EndIf
	Next
	InitiativeUpdate(0)
	InitNextTurn(False)
EndFunc   ;==>PlayersAddtoInitiative

Func PlayerNotesPrep($i)
	Local $pStatArray[6][4]
	$pStatArray[0][0] = "STR"
	$pStatArray[1][0] = "DEX"
	$pStatArray[2][0] = "CON"
	$pStatArray[3][0] = "INT"
	$pStatArray[4][0] = "WIS"
	$pStatArray[5][0] = "CHA"
	Local $pStatData = "Level " & $playersArray[$i][14] & " - " & $playersArray[$i][13] & @CRLF _
	& "AC = " & $playersArray[$i][10] & @CRLF & "Max HP = " & $playersArray[$i][12] & @CRLF _
	& "Speed = " & $playersArray[$i][9] & @CRLF
	For $j = 0 To UBound($pStatArray)-1
		$pStatArray[$j][1] = $playersArray[$i][$j+3]
		$pStatArray[$j][2] = CalcStatMod($pStatArray[$j][1],0,0)
		$pStatData &= $pStatArray[$j][0] & " = " & $pStatArray[$j][1] & " " & CalcStatMod($pStatArray[$j][1]) &@CRLF
	Next
	Local $array[2]
	$array[0] = $pStatArray
	$array[1] = $pStatData
	Return $array
EndFunc
#EndRegion Player Window and Related Funcs

#Region Encounter Window and Related Funcs
Func EncounterWindow()
	If $encoActive Then ; If window already active, give Initiative Window Focus
		WinActivate($encoTitle)
	Else ; Create Initiative Window
		Dim $encoGUIArray[13]

		$encoActive = True

		$hEncounter = GUICreate($encoTitle, 430, 350, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)





;~ 		For $i = 0 To UBound($playGUIArray) - 1 Handy for setting resize for all..
;~ 			GUICtrlSetResizing($playGUIArray[$i], $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
;~ 		Next
		GUICtrlCreateGroup("XP", 5, 230, 320, 90)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		GUICtrlCreateLabel("Total from Encounter: ", 10, 248)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encXPFromEnc = GUICtrlCreateInput(0, 115, 246, 50, -1, $ES_READONLY)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		GUICtrlCreateLabel("Modifer (%)", 10, 273)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encXPMod = GUICtrlCreateInput(100, 115, 271, 50, -1, $ES_READONLY)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		GUICtrlCreateUpdown(-1)
		GUICtrlSetLimit(-1, 9999)

		GUICtrlCreateLabel("Add/Subtract", 10, 298)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encXPAddSub = GUICtrlCreateInput(0, 115, 296, 50)
		_GuiInputSetOnlyNumbers($encXPAddSub, False)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$encXPUP1 = GUICtrlCreateUpdown(-1)

		GUICtrlCreateGroup("", 170, 240, 1, 75)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		GUICtrlCreateLabel("New Total: ", 175, 248)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encXPNewTotal = GUICtrlCreateInput(0, 250, 246, 50, -1, $ES_READONLY)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		GUICtrlCreateLabel("Party Members:", 175, 273)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encXPParty = GUICtrlCreateInput(1, 250, 271, 50, -1, $ES_READONLY)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$encXPUP2 = GUICtrlCreateUpdown(-1)
		GUICtrlSetLimit(-1, 12, 1)

		GUICtrlCreateLabel("Split Total:", 175, 298)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encXPSplitTotal = GUICtrlCreateInput(0, 250, 296, 50, -1, $ES_READONLY)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)


		$encoLoad = GUICtrlCreateButton("", 346, 240, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 24, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)
		$encoSave = GUICtrlCreateButton("", 370, 240, 24, 24, $BS_ICON)
		GUICtrlSetImage(-1, $iconsIcl, 2, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encoAddtoInitB = GUICtrlCreateButton("", 346, 270, 48, 48, $BS_ICON)
		GUICtrlSetTip(-1, "Add all NPCs to the Initiative Window")
		GUICtrlSetImage(-1, $iconsIcl, 17)
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		GUISetFont(8.5, 400)
;~ 		$playRefresh = GUICtrlCreateButton("", 278, 193, 24, 24, $BS_ICON)
;~ 		GUICtrlSetImage(-1, $iconsIcl, 5, 0)
;~ 		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT)

		$encoChildSizeLabel = GUICtrlCreateLabel("", 10, 10, 410, 215)
		GUICtrlSetBkColor(-1, 0xFFFFCC)

		$encoStartSize = ControlGetPos($hEncounter, "", $encoChildSizeLabel)

		GUICtrlSetState($encoChildSizeLabel, $GUI_HIDE)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)

		$hEncoDummy = GUICtrlCreateDummy()

		Dim $encoArr[1][2] = [["{ENTER}", $hEncoDummy]]

		GUISetAccelerators($encoArr, $hEncounter)




		$encoChildStyles = $WS_CHILD + $WS_BORDER + $WS_TABSTOP
		$encoChildStyleEx = $WS_EX_CONTROLPARENT
;~ 		$initChildStyleEx = -1
		$hEncounterChild = GUICreate($encoChildTitle, 420, 215, 10, 10, $encoChildStyles, $encoChildStyleEx, $hEncounter)
		_GUIScrollbars_Generate($hEncounterChild, 400, 30, 1, 1, True)
		GUICtrlCreateLabel("Name", 3, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("HP", 80, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("MaxHP", 115, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Dex  (Mod)", 158, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Initiative", 220, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		;if $enablePlayerRolling = True Then GUICtrlsetstate of inputs $ES_READONLY
		; Initiative  & Enable Initiative Rolling? Maybe Enable Initiative Rolling from File Menu?
		GUICtrlCreateLabel("Notes", 270, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Skip", 310, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlCreateLabel("Delete", 335, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)


		GUISetState(@SW_SHOW, $hEncounter)
		GUISetState(@SW_SHOW, $hEncounterChild)

		If UBound($encounterArray) > 0 Then EncounterUpdate(0, 1)


	EndIf
EndFunc   ;==>EncounterWindow

Func EncounterAdd() ;; This is when the add to encounter button is clicked in the main GUI - It references the Main GUI as well as the Encounter Window
	Local $randomHealth = False, $autoInit = False, $clearList = False

	If GUICtrlRead($encRandomHealth) = $GUI_CHECKED Then $randomHealth = True
	If GUICtrlRead($encAutoInit) = $GUI_CHECKED Then $autoInit = True
	If GUICtrlRead($encClearSelection) = $GUI_CHECKED Then $clearList = True

	If $clearList Then _GUICtrlListView_DeleteAllItems($encListview)

;~ _ArrayDisplay($workingEncounter)
;~ Working Encounter is used for keeping track of whats to be added.
;~ 	[$i][0] = Index
;~ 	[$i][1] = Name of NPCS
;~ 	[$i][2] = Amount to be added


	For $e = 0 To UBound($workingEncounter) - 1 ;; For each set of monsters in the Encounter
		If $workingEncounter[$e][2] = 0 Then ContinueLoop
		Local $monsterIndex = -1, $qRead = "" ;; This is so that i can refernce the monster array later..
		Local $monster = StringReplace($workingEncounter[$e][1], " (in lair)", "")
		ConsoleWrite("Monster: " & $monster & @LF)
		For $j = 0 To UBound($monsterArray) - 1
			If $monsterArray[$j][0] = $monster Then
				$monsterIndex = $j
				If $monsterArray[$j][9] = "CUSTOMMONSTER" Then
					$monsterRead = IniReadSection($custIni, $monster)
					$monsterBasic = IniRead($custIni, "Index", $monster, "")
;~ 				ConsoleWrite("Hittest in Encounter Ini Read" &@LF)
				Else
					$monsterRead = IniReadSection($monCompIni, $monster)
					$monsterBasic = IniRead($monBasicIni, "Monsters", $monster, "")
;~ 				ConsoleWrite("Hittest in Encounter Ini Read" &@LF)

				EndIf
				ExitLoop
			EndIf
		Next

		For $m = 1 To $workingEncounter[$e][2] ;; For Each monster in set --- Go On to create data for that monster.
			$encoUB = UBound($encounterArray)

			ReDim $encounterArray[$encoUB + 1][18]

			Local $indexFound = False, $localIndex = -1, $nameFound = False, $nameIndex = -1, $nameIndexFound = False ;; Find a Unique Index
			For $i = 0 To $encoUB - 1
				$indexFound = False
				If $encounterArray[$i][2] = $workingEncounter[$e][1] Then $nameFound = True
				For $j = 0 To $encoUB - 1
					If $encounterArray[$j][0] = $i Then
						$indexFound = True
						ExitLoop
					EndIf
				Next
				If $indexFound = False Then
					$localIndex = $i
					ExitLoop
				EndIf
			Next
			If $localIndex = -1 Then $localIndex = $encoUB

			If $nameFound Then
				For $i = 1 To $encoUB
					$nameIndexFound = False
					For $j = 0 To $encoUB - 1
						If $encounterArray[$j][2] = $workingEncounter[$e][1] Then
							If $encounterArray[$j][13] = "" Then $encounterArray[$j][13] = 1

							If $encounterArray[$j][13] = $i Then
								$nameIndexFound = True
								ExitLoop
							EndIf
						EndIf
					Next
					If $nameIndexFound = False Then
						$encounterArray[$encoUB][13] = $i
						ExitLoop
					EndIf

				Next
			Else
				$encounterArray[$encoUB][13] = 1
			EndIf
			If $encounterArray[$encoUB][13] = "" And $nameFound Then $encounterArray[$encoUB][13] = $encoUB + 1


			;; If renaming gets picked up Change [13] to "" and re run the above with new name.
			; I think it does this?



			$monsterBasic = StringSplit($monsterBasic, "\\", 1)
;~ Aarakocra=Medium\\Humanoid\\aarakocra\\NG\\1/4\\50\\13 (3d8)\\mm 12
;~ 			Size	Type		Tags	Align CR	XP	HP		Source

			Local $statArray[6][4]
			Local $statCount = 0
			For $i = 1 To $monsterRead[0][0]
				Switch $monsterRead[$i][0]
					Case "STR", "DEX", "CON", "INT", "WIS", "CHA" ;; Stats as 14 (+2)
						$statSplit = StringSplit($monsterRead[$i][1], " (", 1)
						If IsArray($statSplit) Then
							$statSplit[2] = StringReplace($statSplit[2], ")", "")
							$statArray[$statCount][0] = $monsterRead[$i][0]
							$statArray[$statCount][1] = $statSplit[1]
							$statArray[$statCount][2] = $statSplit[2]
							$statCount += 1
						EndIf
					Case "AC"
						$encounterArray[$encoUB][10] = $monsterRead[$i][1] ;AC)
					Case "Speed"
						$encounterArray[$encoUB][9] = $monsterRead[$i][1] ; Speed
					Case "Saving Throws"
						$saveSplit = StringSplit($monsterRead[$i][1], ",")
						For $j = 1 To $saveSplit[0]
							$saveSplit[$j] = StringReplace($saveSplit[$j], " ", "")
							Select
								Case StringInStr($saveSplit[$j], "STR")
									$eSaveType = "STR"
								Case StringInStr($saveSplit[$j], "DEX")
									$eSaveType = "DEX"
								Case StringInStr($saveSplit[$j], "CON")
									$eSaveType = "CON"
								Case StringInStr($saveSplit[$j], "INT")
									$eSaveType = "INT"
								Case StringInStr($saveSplit[$j], "WIS")
									$eSaveType = "WIS"
								Case StringInStr($saveSplit[$j], "CHA")
									$eSaveType = "CHA"
							EndSelect

							$saveSplit[$j] = StringReplace($saveSplit[$j], $eSaveType, "")
							For $f = 0 To 5
								If $statArray[$f][0] = $eSaveType Then
									$statArray[$f][3] = $saveSplit[$j]
								EndIf
							Next

						Next
				EndSwitch
			Next


			;_ArrayDisplay($monsterRead)
;~ 	_ArrayDisplay($statArray) ;; THIS IS FOR DEBUGGING STATS \\ SAVING THROWS


			$encounterArray[$encoUB][0] = $localIndex ; Unique ID
;~ 	$encounterArray[$encoUB][1] -- GUI Array here.


			$encounterArray[$encoUB][2] = $workingEncounter[$e][1] ;Name
			$encounterArray[$encoUB][3] = $statArray ;Stat Array Here.
			;;	[0]		[1]		[2]		[3]
			;	STR		14		+2		+6 (Proficient \ Extra )
			;	Dex		8		-1


			;Stat String Here (same as for main window).. for ToolTips & Notes
			;; Include CR XP Alignment and Size/ Type
			$encounterArray[$encoUB][14] = _Titilise($encounterArray[$encoUB][2] & " #" & $encounterArray[$encoUB][13]) ;; Titilised name for Notes.
			$encounterArray[$encoUB][4] = $monsterArray[$monsterIndex][1] & " " & $monsterArray[$monsterIndex][2] _
					 & ", " & AlignmentSwitch($monsterArray[$monsterIndex][4]) & @CRLF & "HP = " & $monsterArray[$monsterIndex][7] & @CRLF & "CR = " _
					 & $monsterArray[$monsterIndex][5] & " (XP: " & $monsterArray[$monsterIndex][6] & ")" & @CRLF & @LF


			If $monsterArray[$monsterIndex][9] <> "CUSTOMMONSTER" Then ;; If NOT Custom Monster Then
				$qRead = _ArrayToString(IniReadSection($monCompIni, $monster), " = ", 1)
			Else

				$qRead = _ArrayToString(IniReadSection($custIni, $monster), " = ", 1)
			EndIf
			$encounterArray[$encoUB][4] &= $qRead


			;; MonsterArray Variables to use with $monsterIndex
			;[ITME][5] = CR
			;[ITME][6] = XP

			$encounterArray[$encoUB][5] = $monsterArray[$monsterIndex][5] ;; CR
			$encounterArray[$encoUB][6] = $monsterArray[$monsterIndex][6] ;; XP
;~ 	$encounterArray[$encoUB][XX] = $monsterArray[$monsterIndex][7] ;; HP (Text Full)
			; Theoretically shouldnt need this.

			$tempHP = StringSplit($monsterArray[$monsterIndex][7], "(")
			$tempHP[2] = StringReplace($tempHP[2], ")", "")
			If $randomHealth Then
				Local $healthAddition = 0, $healthSplit
				Select
					Case StringInStr($tempHP[2], "+")
						$healthSplit = StringSplit($tempHP[2], "+")
						$healthAddition = $healthSplit[2]
					Case StringInStr($tempHP[2], "-")
						$healthSplit = StringSplit($tempHP[2], "-")
						$healthAddition = 0 - $healthSplit[2]
				EndSelect
				If $healthAddition = 0 Then
					$healthRoll = SplitandRoll($tempHP[2])
				Else
					$healthRoll = SplitandRoll($healthSplit[1])
				EndIf
				$encounterArray[$encoUB][7] = $monster ;;HP Dice roll Array
				$encounterArray[$encoUB][8] = $healthAddition ;;HP Addition

				$encounterArray[$encoUB][11] = $healthRoll[UBound($healthRoll) - 1] + $healthAddition ;CurrentHP
				$encounterArray[$encoUB][12] = $encounterArray[$encoUB][11] ;MaxHP
			Else
				$encounterArray[$encoUB][11] = $tempHP[1] ;CurrentHP
				$encounterArray[$encoUB][12] = $tempHP[1] ;MaxHP
			EndIf

;~ 	$encounterArray[$encoUB][13] =  ;;														;UID for Names
;~ 	$encounterArray[$encoUB][14] = ;		 		  										; Titilised name.
			$encounterArray[$encoUB][15] = False ;Skip Boolean on 15

			If $autoInit Then
				Local $encInitRoll = DiceRoll(20)
				$encounterArray[$encoUB][16] = $encInitRoll[1] + SkillMatrix("Dex", $encoUB)
				InitiativeAdd($encounterArray[$encoUB][2] & " #" & $encounterArray[$encoUB][13], "NPC", $encounterArray[$encoUB][0], False, SkillMatrix("Dex", $encoUB, "Mod", "Int"), $encounterArray[$encoUB][16], $encounterArray[$encoUB][11], False, False)
				;Func InitiativeAdd($iName, $iType, $iRelIndex, $iRolledFor = True, $iDexMod = 0, $iInitiative = 0, $iHP = 0, $iSkip = False, $iUpdate = True)
;~ 	Initiative on 16
			EndIf
			; Local notes on 17
		Next

	Next
	If $clearList Then ReDim $workingEncounter[0][3]
	If $encAutoInit Then InitiativeUpdate()
;~ _ArrayDisplay($encounterArray) ;; Put above if there are issues with looping between Different monsters.
	EncounterUpdate()

EndFunc   ;==>EncounterAdd

Func EncounterUpdate($readFromChild = 1, $destroyGUI = 1, $updateXP = 1)

	Local $encoUB = UBound($encounterArray), $encoTooltip
	Local $encoChildPos = WinGetPos($encoTitle)

	If $readFromChild And $encoActive Then
		For $i = 0 To $encoUB - 1 ;; Update changes made in GUI to array (reflected when new GUI items are created)
			Local $eGUIArray = $encounterArray[$i][1], $nameFound = False
			If IsArray($eGUIArray) Then
				$encTempName = StringSplit(GUICtrlRead($eGUIArray[1]), "#") ;; Start of Name
				$encTempName = StringStripWS($encTempName[1], 2)
				If $encTempName <> $encounterArray[$i][2] Then

					$encounterArray[$i][2] = $encTempName ; Name Change
					#Region Redo #Number if required.
					For $e = 0 To $encoUB - 1
						If $e = $i Then ContinueLoop
						If $encounterArray[$e][2] = $encounterArray[$i][2] Then
							$nameFound = True
							ExitLoop
						EndIf
					Next

					If $nameFound Then
						For $b = 1 To $encoUB
							Local $nameIndexFound = False
							For $j = 0 To $encoUB - 1
								If $encounterArray[$j][2] = $encounterArray[$i][2] Then
									If $encounterArray[$j][13] = "" Then $encounterArray[$j][13] = 1

									If $encounterArray[$j][13] = $b Then
										$nameIndexFound = True
										ExitLoop
									EndIf
								EndIf
							Next
							If $nameIndexFound = False Then
								$encounterArray[$i][13] = $b
								ExitLoop
							EndIf

						Next
					Else
						$encounterArray[$i][13] = 1
					EndIf
					If $encounterArray[$i][13] = "" And $nameFound Then $encounterArray[$i][13] = $encoUB + 1

					$encounterArray[$i][14] = _Titilise($encounterArray[$i][2] & " #" & $encounterArray[$i][13])

					#EndRegion Redo #Number if required.
				EndIf
				$encounterArray[$i][11] = GUICtrlRead($eGUIArray[2]) ; Current HP
				$encounterArray[$i][16] = Int(GUICtrlRead($eGUIArray[6])) ; Initiative
				If GUICtrlRead($eGUIArray[10]) = $GUI_CHECKED Then ; If Skip Ticked
					$encounterArray[$i][15] = True
				Else
					$encounterArray[$i][15] = False
				EndIf
			EndIf
		Next
	EndIf

	If $encoActive Then
		If $destroyGUI Then
			GUIDelete($hEncounterChild)

			$hEncounterChild = GUICreate($encoChildTitle, 420, 180, $encoChildPos[0] + 10, $encoChildPos[1] + 10, $encoChildStyles, $encoChildStyleEx, $hEncounter)
			$aPos = ControlGetPos($hEncounter, "", $encoChildSizeLabel)
			WinMove($hEncounterChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
			_GUIScrollbars_Generate($hEncounterChild, 400, 30 + $encoUB * 25, 1, 1, True)

			GUICtrlCreateLabel("Name", 3, 5)
			GUICtrlSetResizing(-1, $GUI_DOCKALL)
			GUICtrlCreateLabel("HP", 110, 5)
			GUICtrlSetResizing(-1, 804)
			GUICtrlCreateLabel("MaxHP", 145, 5)
			GUICtrlSetResizing(-1, 804)
			GUICtrlCreateLabel("Dex  (Mod)", 188, 5)
			GUICtrlSetResizing(-1, 804)
			GUICtrlCreateLabel("Initiative", 250, 5)
			GUICtrlSetResizing(-1, 804)
			GUICtrlCreateLabel("Notes", 300, 5)
			GUICtrlSetResizing(-1, 804)
			GUICtrlCreateLabel("Skip", 340, 5)
			GUICtrlSetResizing(-1, 804)
			GUICtrlCreateLabel("Delete", 370, 5)
			GUICtrlSetResizing(-1, 804)

			For $i = 0 To $encoUB - 1
				Local $eGUIArray = 0, $pDexMod = 0

				Dim $eGUIArray[15]

				$encoTooltip = $encounterArray[$i][4]
				$encoTipTitle = $encounterArray[$i][2] & " #" & $encounterArray[$i][13] & " Stats"

				$eGUIArray[1] = GUICtrlCreateInput($encounterArray[$i][2] & " #" & $encounterArray[$i][13], 5, 23 + $i * 25, 100, 20)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT); $GUI_DOCKALL)
				GUICtrlSetTip(-1, $encoTooltip, $encoTipTitle)
				If $encounterArray[$i][15] = True Then GUICtrlSetBkColor(-1, $COLOR_RED)

				$eGUIArray[2] = GUICtrlCreateInput($encounterArray[$i][11], 110, 23 + $i * 25, 30, 20)
				_GuiInputSetOnlyNumbers($eGUIArray[2], False)
				GUICtrlSetResizing(-1, 804);)$GUI_DOCKALL)

				$eGUIArray[3] = GUICtrlCreateLabel($encounterArray[$i][12], 145, 26 + $i * 25, 30, 23)
;~ 			_GuiInputSetOnlyNumbers($pGUIArray[2],False)
				GUICtrlSetResizing(-1, 804)
				GUICtrlSetTip(-1, $encoTooltip, $encoTipTitle)

				$eDexMod = SkillMatrix("DEX", $i, "Mod", "String")
				$eGUIArray[4] = GUICtrlCreateLabel(SkillMatrix("DEX", $i, "Base") & " (" & $eDexMod & ")", 190, 26 + $i * 25, 50, 23)
				GUICtrlSetResizing(-1, 804)
				GUICtrlSetTip(-1, $encoTooltip, $encoTipTitle)

;~ 			$eGUIArray[5] = GUICtrlCreateLabel($eDexMod, 180, 26 + $i * 25)
;~ 			GUICtrlSetResizing(-1, $GUI_DOCKALL)


				$eGUIArray[6] = GUICtrlCreateInput($encounterArray[$i][16], 250, 23 + $i * 25, 40)
				GUICtrlSetResizing(-1, 804)
				_GuiInputSetOnlyNumbers($eGUIArray[6], False)

				$eGUIArray[9] = GUICtrlCreateButton("", 302, 22 + $i * 25, 23, 23, $BS_ICON)
				GUICtrlSetImage(-1, $iconsIcl, 23, 0)
				GUICtrlSetResizing(-1, 804)
				GUICtrlSetTip(-1, $encoTooltip, $encoTipTitle) ;;; Possibly change this tip - May need to explain notes quickly

				$eGUIArray[10] = GUICtrlCreateCheckbox("", 345, 23 + $i * 25, 24, 24)
				GUICtrlSetResizing(-1, 804)
				If $encounterArray[$i][15] = True Then GUICtrlSetState(-1, $GUI_CHECKED)


				$eGUIArray[0] = GUICtrlCreateButton("", 370, 21 + $i * 25, 24, 24, $BS_ICON) ;; Delete?
				GUICtrlSetImage(-1, $iconsIcl, 10, 0)
				GUICtrlSetResizing(-1, 804)

				$encounterArray[$i][1] = $eGUIArray

			Next

			GUISetState()
		Else ; if just refreshing GUI elements with new info ( no deleted or added characters)


			For $i = 0 To $encoUB - 1 ;; Update changes made in GUI to array (reflected when new GUI items are created)

				$encoTooltip = $encounterArray[$i][4]
				$encoTipTitle = $encounterArray[$i][2] & " #" & $encounterArray[$i][13] & " Stats"

				Local $eGUIArray = $encounterArray[$i][1]
				If IsArray($eGUIArray) Then
					GUICtrlSetData($eGUIArray[1], $encounterArray[$i][2] & " #" & $encounterArray[$i][13])
					GUICtrlSetData($eGUIArray[2], $encounterArray[$i][11])
					GUICtrlSetData($eGUIArray[3], $encounterArray[$i][12])
					GUICtrlSetData($eGUIArray[6], $encounterArray[$i][16])
					GUICtrlSetData($eGUIArray[4], SkillMatrix("DEX", $i, "Base") & " (" & SkillMatrix("DEX", $i, "Mod", "String") & ")")

					GUICtrlSetTip($eGUIArray[1], $encoTooltip, $encoTipTitle)
					GUICtrlSetTip($eGUIArray[3], $encoTooltip, $encoTipTitle)
					GUICtrlSetTip($eGUIArray[4], $encoTooltip, $encoTipTitle)
					GUICtrlSetTip($eGUIArray[9], $encoTooltip, $encoTipTitle)
					GUICtrlSetTip($eGUIArray[11], $encoTooltip, $encoTipTitle)

					If $encounterArray[$i][15] Then

						GUICtrlSetState($eGUIArray[10], $GUI_CHECKED)
						GUICtrlSetBkColor($eGUIArray[1], $COLOR_RED)
					Else
						GUICtrlSetState($eGUIArray[10], $GUI_UNCHECKED)
						GUICtrlSetBkColor($eGUIArray[1], $COLOR_WHITE)
					EndIf

;~ 				GUICtrlSetData($eGUIArray[5], CalcStatMod($playersArray[$i][4]))
				EndIf
			Next
		EndIf
	EndIf

	If $updateXP Then
		Local $runningXP = 0
		For $i = 0 To $encoUB - 1
			$runningXP += $encounterArray[$i][6]
		Next
		GUICtrlSetData($encXPFromEnc, $runningXP)
		EncounterXPCalc($runningXP)
	EndIf
EndFunc   ;==>EncounterUpdate

Func NPCsAddtoInitiative()

	For $i = 0 To UBound($encounterArray) - 1
		Local $npcFound = False
		For $j = 0 To UBound($initiativeArray) - 1
			If $initiativeArray[$j][2] = "NPC" Then
				If $encounterArray[$i][0] = $initiativeArray[$j][3] Then
					$npcFound = True
				EndIf
			EndIf
		Next
		If $npcFound = False Then
			;InitAdd($iName, $iType, $iRelIndex, $iRolledFor = True, $iDexMod = 0, $iInitiative = 0, $iHP = 0, $iSkip = False, $iUpdate = True
			InitiativeAdd($encounterArray[$i][2] & " #" & $encounterArray[$i][13], "NPC", $encounterArray[$i][0], False, SkillMatrix("Dex", $i, "Mod", "Int"), $encounterArray[$i][16], $encounterArray[$i][11], $encounterArray[$i][15], False)
		EndIf
	Next
	InitiativeUpdate(0)
	InitNextTurn(False)
EndFunc   ;==>NPCsAddtoInitiative

Func NPCsCheckChildGUI($manualRefresh = 0)

	For $i = 0 To UBound($encounterArray) - 1
		Local $npcFound = False
		$eGUIArray = $encounterArray[$i][1] ; Child GUI for current Player
		$eReadInit = GUICtrlRead($eGUIArray[6]) ; Read initiative
		$eReadHP = GUICtrlRead($eGUIArray[2])

		If $eReadInit <> "" Then $eReadInit = Int($eReadInit)
		If $eReadHP <> "" Then $eReadHP = Int($eReadHP)


		If $eReadInit <> $encounterArray[$i][16] Then
			;ConsoleWrite(@SEC & " hittest &@LF" & @LF)
			EncounterUpdate(1, 0) ; Read from child but don't destroy
			If IsArray($initiativeArray) Then
				For $j = 0 To UBound($initiativeArray) - 1
					If $initiativeArray[$j][2] = "NPC" And $initiativeArray[$j][3] = $encounterArray[$i][0] Then
						ConsoleWrite("NPC Type Found, Index: " & $encounterArray[$i][0] & @LF)
						$npcFound = True
						$npcInt = $j
					EndIf
				Next
			EndIf
			If Not ($npcFound) And $autoAddToInitiative Then
				ConsoleWrite("NPC Not Found - AutoAddtoInitiative Enabled" & @LF & "HP: " & $encounterArray[$i][11] & @LF)
				InitiativeAdd($encounterArray[$i][2] & " #" & $encounterArray[$i][13], "NPC", $encounterArray[$i][0], False, SkillMatrix("Dex", $i, "Mod", "String"), $encounterArray[$i][16], $encounterArray[$i][11])
				If $initTurnIndex > -1 Then InitNextTurn(False)
			EndIf
			If $npcFound Then
				$initiativeArray[$npcInt][4] = $encounterArray[$i][16]
				$initiativeArray[$npcInt][9] = $encounterArray[$i][11]
				$initiativeArray[$npcInt][1] = $encounterArray[$i][2] & " #" & $encounterArray[$i][13]
				If $initiativeActive Then
					InitiativeUpdate(0)
					If $initTurnIndex > -1 Then InitNextTurn(False)
				EndIf
			EndIf
			;EndIf
		ElseIf GUICtrlRead($eGUIArray[1]) <> $encounterArray[$i][2] & " #" & $encounterArray[$i][13] Or $eReadHP <> $encounterArray[$i][11] Then ;; IF name or HP Changed.. Then update in initiative window.
			ConsoleWrite("Hit || " & $eReadHP & " <> " & $encounterArray[$i][11] & @LF)
			EncounterUpdate(1, 0)
			ConsoleWrite("After Update - " & $eReadHP & " <> " & $encounterArray[$i][11] & @LF)
			For $j = 0 To UBound($initiativeArray) - 1
				If $initiativeArray[$j][2] = "NPC" And $initiativeArray[$j][3] = $encounterArray[$i][0] Then
					$initiativeArray[$j][1] = $encounterArray[$i][2] & " #" & $encounterArray[$i][13]
					$initiativeArray[$j][9] = $encounterArray[$i][11]
					InitiativeUpdate(0, 0)
					If $initTurnIndex > -1 Then InitNextTurn(False)
					ExitLoop
				EndIf
			Next

		EndIf
	Next
	;Return $npcFound
EndFunc   ;==>NPCsCheckChildGUI

Func EncounterXPCalc($eInitialTotal, $debug = 1)
	Local $eModifier = GUICtrlRead($encXPMod) / 100
	Local $eAddition = Int(GUICtrlRead($encXPAddSub))

	Local $eNewTotal = Floor($eInitialTotal * $eModifier) + $eAddition
	If $debug Then ConsoleWrite("Initial Total: " & $eInitialTotal & " times modifier: " & $eModifier & " = " & $eNewTotal & @LF)
	GUICtrlSetData($encXPNewTotal, $eNewTotal)
	Local $ePartyMembers = GUICtrlRead($encXPParty)
	Local $eSplit = Floor($eNewTotal / $ePartyMembers)
	If $debug Then ConsoleWrite("New Total: " & $eNewTotal & " divided by party members: " & $ePartyMembers & " = " & $eSplit & @LF)
	GUICtrlSetData($encXPSplitTotal, $eSplit)

EndFunc   ;==>EncounterXPCalc

Func EncounterSave()
;~ 	$encounterArray[$encoUB][0] = ; Unique ID
;~ 	$encounterArray[$encoUB][1] -- GUI Array here.
;~ 	$encounterArray[$encoUB][2] = ; Name

	;---  Can Read from Monster.ini To save load\Save Space.
;~ 	$encounterArray[$encoUB][3] = ;Stat Array Here.
;~ 	$encounterArray[$encoUB][4] = ;Stats in Note form
;~ 	$encounterArray[$encoUB][5] = ;; CR
;~ 	$encounterArray[$encoUB][6] = ;; XP
;~ 	$encounterArray[$encoUB][9] = ; Speed
;~ 	$encounterArray[$encoUB][10] = ;AC)
	;---

;~ 	$encounterArray[$encoUB][7] = ; $monster (Refrence Monster for Stats)
;~ 	$encounterArray[$encoUB][8] = ;;HP Addition
;~ 	$encounterArray[$encoUB][11] = ;CurrentHP
;~ 	$encounterArray[$encoUB][12] = ;MaxHP
;~ 	$encounterArray[$encoUB][13] =  ;;	;UID for Names -- Should redo this part When Loading
;~ 	$encounterArray[$encoUB][14] = ;;; Titilised name for Notes. -- Can Redo While Loading
;~ 	$encounterArray[$encoUB][15] =;Skip Boolean on 15
;~ 	$encounterArray[$encoUB][16] = ;Initiative
;17 = Local Notes

	Local $encSaveLocation = $currentSaveLocation


	For $i = 0 To UBound($encounterArray) - 1
		$secName = $encounterArray[$i][2]
		$secName &= "_" & $encounterArray[$i][0]
		IniWrite($encSaveLocation, $secName, "Type", "NPC")
		IniWrite($encSaveLocation, $secName, "PartOfInitiativeArray", "False")

		IniWrite($encSaveLocation, $secName, "Monster Reference", $encounterArray[$i][7])

		IniWrite($encSaveLocation, $secName, "HP Addition", $encounterArray[$i][8])

		IniWrite($encSaveLocation, $secName, "CurrHP", $encounterArray[$i][11])
		IniWrite($encSaveLocation, $secName, "MaxHP", $encounterArray[$i][12])
;~ 		IniWrite($encSaveLocation, $secName, "Classes", $encounterArray[$i][13])
;~ 		IniWrite($encSaveLocation, $secName, "Level", $encounterArray[$i][14])
		If $encounterArray[$i][15] Then IniWrite($encSaveLocation, $secName, "Skip", $encounterArray[$i][15])
		If Not ($encounterArray[$i][15]) Then IniWrite($encSaveLocation, $secName, "Skip", False)
		IniWrite($encSaveLocation, $secName, "Initiative", $encounterArray[$i][16])

		IniWrite($encSaveLocation, $secName, "MyTurn", "False")
		If IsArray($initiativeArray) Then
			For $j = 0 To UBound($initiativeArray) - 1
				If $initiativeArray[$j][2] = "NPC" And $initiativeArray[$j][3] = $encounterArray[$i][0] Then
					IniWrite($encSaveLocation, $secName, "PartOfInitiativeArray", "True")
					If $initTurnValue = $j Then ;; NPC save will have to check in with initiative Array to check if it has "Turn Focus"
						IniWrite($encSaveLocation, $secName, "MyTurn", "True")

					EndIf
				EndIf
			Next
		EndIf
		IniWrite($encSaveLocation, $secName, "LocalNotes", StringReplace($encounterArray[$i][17],@CRLF,"#CRLF#"))
	Next
EndFunc   ;==>EncounterSave

Func EncounterLoad($iOverwrite = False)
	Local $encoLoadLocation = $currentLoadLocation;"Init Test Save.ini"
	Local $encoLoadSecs, $encoLoadSection, $initUpdated = False


	;; IF Overwrite then -----
	If $iOverwrite Then
		$encoUB = UBound($initiativeArray) - 1
		For $i = 0 To $encoUB
			If $initiativeArray[$i][2] = "NPC" Then
				_ArrayDelete($initiativeArray, $i)
				$i -= 1
				$encoUB -= 1

			EndIf
			If $i >= $encoUB Then ExitLoop
		Next

		$encounterArray = 0
		Dim $encounterArray[0][0]
	EndIf

;~ 	[Deva_0]
;~ Type=NPC
;~ PartOfInitiativeArray=True
;~ Monster Reference=Deva
;~ HP Addition= 64
;~ CurrHP=126
;~ MaxHP=126
;~ Skip=False
;~ Initiative=16
;~ MyTurn=False

	$encoLoadSecs = IniReadSectionNames($encoLoadLocation)
	If IsArray($encoLoadSecs) Then
		For $e = 1 To $encoLoadSecs[0]
			$encoLoadSection = IniReadSection($encoLoadLocation, $encoLoadSecs[$e])
			If $encoLoadSection[1][1] <> "NPC" Then ContinueLoop ;; Skip anything that isnt a NPC ;)

			$encoUB = UBound($encounterArray)

			ReDim $encounterArray[$encoUB + 1][18]

			$nameSplit = StringSplit($encoLoadSecs[$e], "_")
			$encounterArray[$encoUB][2] = $nameSplit[1] ;Name
			$encounterArray[$encoUB][7] = $encoLoadSection[3][1]

			$monster = $encounterArray[$encoUB][7]

			For $j = 0 To UBound($monsterArray) - 1
				If $monsterArray[$j][0] = $encounterArray[$encoUB][7] Then
					$monsterIndex = $j
					If $monsterArray[$j][9] = "CUSTOMMONSTER" Then
						$monsterRead = IniReadSection($custIni, $monster)
						$monsterBasic = IniRead($custIni, "Index", $monster, "")
;~ 				ConsoleWrite("Hittest in Encounter Ini Read" &@LF)
					Else
						$monsterRead = IniReadSection($monCompIni, $monster)
						$monsterBasic = IniRead($monBasicIni, "Monsters", $monster, "")
;~ 				ConsoleWrite("Hittest in Encounter Ini Read" &@LF)

					EndIf
					ExitLoop
				EndIf
			Next



			Local $indexFound = False, $localIndex = -1, $nameFound = False, $nameIndex = -1, $nameIndexFound = False ;; Find a Unique Index
			For $i = 0 To $encoUB - 1
				$indexFound = False
				If $encounterArray[$i][2] = $encounterArray[$encoUB][2] Then $nameFound = True
				For $j = 0 To $encoUB - 1
					If $encounterArray[$j][0] = $i Then
						$indexFound = True
						ExitLoop
					EndIf
				Next
				If $indexFound = False Then
					$localIndex = $i
					ExitLoop
				EndIf
			Next
			If $localIndex = -1 Then $localIndex = $encoUB

			If $nameFound Then
				For $i = 1 To $encoUB
					$nameIndexFound = False
					For $j = 0 To $encoUB - 1
						If $encounterArray[$j][2] = $encounterArray[$encoUB][2] Then
							If $encounterArray[$j][13] = "" Then $encounterArray[$j][13] = 1

							If $encounterArray[$j][13] = $i Then
								$nameIndexFound = True
								ExitLoop
							EndIf
						EndIf
					Next
					If $nameIndexFound = False Then
						$encounterArray[$encoUB][13] = $i
						ExitLoop
					EndIf

				Next
			Else
				$encounterArray[$encoUB][13] = 1
			EndIf
			If $encounterArray[$encoUB][13] = "" And $nameFound Then $encounterArray[$encoUB][13] = $encoUB + 1


			;; If renaming gets picked up Change [13] to "" and re run the above with new name.
			; I think it does this?



			$monsterBasic = StringSplit($monsterBasic, "\\", 1)
;~ Aarakocra=Medium\\Humanoid\\aarakocra\\NG\\1/4\\50\\13 (3d8)\\mm 12
;~ 			Size	Type		Tags	Align CR	XP	HP		Source

			Local $statArray[6][4]
			Local $statCount = 0
			For $i = 1 To $monsterRead[0][0]
				Switch $monsterRead[$i][0]
					Case "STR", "DEX", "CON", "INT", "WIS", "CHA" ;; Stats as 14 (+2)
						$statSplit = StringSplit($monsterRead[$i][1], " (", 1)
						If IsArray($statSplit) Then
							$statSplit[2] = StringReplace($statSplit[2], ")", "")
							$statArray[$statCount][0] = $monsterRead[$i][0]
							$statArray[$statCount][1] = $statSplit[1]
							$statArray[$statCount][2] = $statSplit[2]
							$statCount += 1
						EndIf
					Case "AC"
						$encounterArray[$encoUB][10] = $monsterRead[$i][1] ;AC)
					Case "Speed"
						$encounterArray[$encoUB][9] = $monsterRead[$i][1] ; Speed
					Case "Saving Throws"
						$saveSplit = StringSplit($monsterRead[$i][1], ",")
						For $j = 1 To $saveSplit[0]
							$saveSplit[$j] = StringReplace($saveSplit[$j], " ", "")
							Select
								Case StringInStr($saveSplit[$j], "STR")
									$eSaveType = "STR"
								Case StringInStr($saveSplit[$j], "DEX")
									$eSaveType = "DEX"
								Case StringInStr($saveSplit[$j], "CON")
									$eSaveType = "CON"
								Case StringInStr($saveSplit[$j], "INT")
									$eSaveType = "INT"
								Case StringInStr($saveSplit[$j], "WIS")
									$eSaveType = "WIS"
								Case StringInStr($saveSplit[$j], "CHA")
									$eSaveType = "CHA"
							EndSelect

							$saveSplit[$j] = StringReplace($saveSplit[$j], $eSaveType, "")
							For $f = 0 To 5
								If $statArray[$f][0] = $eSaveType Then
									$statArray[$f][3] = $saveSplit[$j]
								EndIf
							Next

						Next
				EndSwitch
			Next

			$encounterArray[$encoUB][0] = $localIndex ; Unique ID
;~ 	$encounterArray[$encoUB][1] -- GUI Array here.
			$encounterArray[$encoUB][3] = $statArray
			$encounterArray[$encoUB][14] = _Titilise($encounterArray[$encoUB][2] & " #" & $encounterArray[$encoUB][13]) ;; Titilised name for Notes.
			$encounterArray[$encoUB][4] = $monsterArray[$monsterIndex][1] & " " & $monsterArray[$monsterIndex][2] _
					 & ", " & AlignmentSwitch($monsterArray[$monsterIndex][4]) & @CRLF & "HP = " & $monsterArray[$monsterIndex][7] & @CRLF & "CR = " _
					 & $monsterArray[$monsterIndex][5] & " (XP: " & $monsterArray[$monsterIndex][6] & ")" & @CRLF & @LF

			If $monsterArray[$monsterIndex][9] <> "CUSTOMMONSTER" Then ;; If NOT Custom Monster Then
				$qRead = _ArrayToString(IniReadSection($monCompIni, $monster), " = ", 1)
			Else

				$qRead = _ArrayToString(IniReadSection($custIni, $monster), " = ", 1)
			EndIf

			$encounterArray[$encoUB][4] &= $qRead
			$encounterArray[$encoUB][5] = $monsterArray[$monsterIndex][5] ;; CR
			$encounterArray[$encoUB][6] = $monsterArray[$monsterIndex][6] ;; XP

			$encounterArray[$encoUB][11] = $encoLoadSection[5][1] ;CurrentHP
			$encounterArray[$encoUB][12] = $encoLoadSection[6][1]
			If $encoLoadSection[7][1] = "True" Then
				$encounterArray[$encoUB][15] = True
			Else
				$encounterArray[$encoUB][15] = False
			EndIf
			$encounterArray[$encoUB][16] = $encoLoadSection[8][1]
			If $encoLoadSection[2][1] = "True" Then
				$initUpdated = True
				$encoAddtoInitIndex = InitiativeAdd($encounterArray[$encoUB][2] & " #" & $encounterArray[$encoUB][13], "NPC", $encounterArray[$encoUB][0], False, SkillMatrix("Dex", $encoUB, "Mod", "Int"), $encounterArray[$encoUB][16], $encounterArray[$encoUB][11], $encounterArray[$encoUB][15], False)
				If $encoLoadSection[9][1] = "True" Then
					$initTurnValue = $encoAddtoInitIndex
					$initTurnIndex = 0
				EndIf
			EndIf
			if $encoLoadSection[0][0] >= 10 Then $encounterArray[$encoUB][17] = StringReplace($encoLoadSection[10][1],"#CRLF#",@CRLF)
		Next

	EndIf
	EncounterUpdate()
	If $initUpdated Then InitiativeUpdate()
	If $initTurnIndex > -1 And IsArray($initiativeArray) Then InitNextTurn(False)
;~ 	[Deva_0]
;~ Type=NPC
;~ PartOfInitiativeArray=True
;~ Monster Reference=Deva
;~ HP Addition= 64
;~ CurrHP=126
;~ MaxHP=126
;~ Skip=False
;~ Initiative=16
;~ MyTurn=False
EndFunc   ;==>EncounterLoad
#EndRegion Encounter Window and Related Funcs

#Region Save\Load Window And Funcs
Func CreateSaveWindow()

	_GUICtrlSetState($GUI_DISABLE)
	If $playersActive Then GUISetState(@SW_DISABLE, $hPlayers)
	If $initiativeActive Then GUISetState(@SW_DISABLE, $hInitiative)
	If $encoActive Then GUISetState(@SW_DISABLE, $hEncounter)
	GUISetState(@SW_DISABLE, $hMainGUI)
;~ Disable Main Window



	$saveWindow = GUICreate("Saving Encounter Information...", 280, 100)

	GUICtrlCreateGroup("Save:", 5, 5, 265, 64)
	$cbSavePlayers = GUICtrlCreateCheckbox("Players", 10, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$cbSaveInitiative = GUICtrlCreateCheckbox("Initiative", 65, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$cbSaveEncounter = GUICtrlCreateCheckbox("Encounter", 125, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)

	GUICtrlCreateLabel("Location:", 10, 45)
	If $currentSaveLocation = "" Then $currentSaveLocation = @ScriptDir & "\Encounter Save - " & @MDAY & "-" & @MON & ".ini"
	$lSaveLocation = GUICtrlCreateLabel($currentSaveLocation, 65, 45, 150, 23, $SS_LEFTNOWORDWRAP)
	$bSaveChange = GUICtrlCreateButton("Change", 220, 38)

	$bSaveCancel = GUICtrlCreateButton("Cancel", 5, 73)
	$bSaveSAVE = GUICtrlCreateButton("Save", 240, 73)

	GUISetState()

EndFunc   ;==>CreateSaveWindow

Func LoadClicked()
	_GUICtrlSetState($GUI_DISABLE)
	If $playersActive Then GUISetState(@SW_DISABLE, $hPlayers)
	If $initiativeActive Then GUISetState(@SW_DISABLE, $hInitiative)
	If $encoActive Then GUISetState(@SW_DISABLE, $hEncounter)
	GUISetState(@SW_DISABLE, $hMainGUI)

	Local $initDataExists = False, $playDataExists = False, $encDataExists = False
	If $currentLoadLocation = "" Then
		If $currentSaveLocation <> "" Then
			Local $firstSlash = StringInStr($currentSaveLocation, "\", 0, -1)
			Local $tempLoad = FileOpenDialog("Load Encounter File..", StringLeft($currentSaveLocation, $firstSlash), "Ini Files (*.ini)", 0, StringRight($currentSaveLocation, StringLen($currentSaveLocation) - $firstSlash))
		Else
			Local $tempLoad = FileOpenDialog("Load Encounter File..", @ScriptDir, "Ini Files (*.ini)")
		EndIf
	Else
		Local $firstSlash = StringInStr($currentLoadLocation, "\", 0, -1)
		Local $tempLoad = $currentLoadLocation;FileOpenDialog("Load Encounter File..",StringLeft($currentLoadLocation,$firstSlash),"Ini Files (*.ini)",0,StringRight($currentLoadLocation,StringLen($currentSaveLocation)-$firstSlash))
	EndIf

	If FileExists($tempLoad) Then
		$currentLoadLocation = $tempLoad
		$secName = IniReadSectionNames($currentLoadLocation)
		if IsArray($secName) Then
		For $i = 1 To $secName[0]
			ConsoleWrite($secName[$i] & @LF)
			$secRead = IniReadSection($currentLoadLocation, $secName[$i])
			For $j = 1 To $secRead[0][0]
				If $secRead[$j][0] = "Type" Then
					Switch $secRead[$j][1]
						Case "Manual Entry", "Autoroll"
							$initDataExists = True
						Case "Player"
							$playDataExists = True
						Case "NPC"
							$encDataExists = True
					EndSwitch
					ExitLoop
				EndIf
			Next
		Next
		EndIf
		CreateLoadWindow($initDataExists, $playDataExists, $encDataExists)

	Else
		If $tempLoad <> "" Then MsgBox(48, "File Does not Exist", "File Does not Exist")
		If $playersActive Then GUISetState(@SW_ENABLE, $hPlayers)
		If $initiativeActive Then GUISetState(@SW_ENABLE, $hInitiative)
		If $encoActive Then GUISetState(@SW_ENABLE, $hEncounter)
		GUISetState(@SW_ENABLE, $hMainGUI)
		_GUICtrlSetState($GUI_ENABLE)
	EndIf

EndFunc   ;==>LoadClicked

Func CreateLoadWindow($lInit = True, $lPlay = True, $lEnc = True)

	_GUICtrlSetState($GUI_DISABLE)
	If $playersActive Then GUISetState(@SW_DISABLE, $hPlayers)
	If $initiativeActive Then GUISetState(@SW_DISABLE, $hInitiative)
	If $encoActive Then GUISetState(@SW_DISABLE, $hEncounter)
	GUISetState(@SW_DISABLE, $hMainGUI)

;~ Disable Main Window

	$hLoadWindow = GUICreate("Loading Encounter Information...", 280, 100)

	GUICtrlCreateGroup("Load:", 5, 5, 265, 64)
	$cbLoadPlayers = GUICtrlCreateCheckbox("Players", 10, 20)
	If Not ($lPlay) Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	Else
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$cbLoadInitiative = GUICtrlCreateCheckbox("Initiative", 65, 20)
	If Not ($lInit) Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	Else
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$cbLoadEncounter = GUICtrlCreateCheckbox("Encounter", 125, 20)
	If Not ($lEnc) Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	Else
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf

	GUICtrlCreateLabel("Location:", 10, 45)
	$lLoadLocation = GUICtrlCreateLabel($currentLoadLocation, 65, 45, 170, 23, $SS_LEFTNOWORDWRAP)

	$bLoadChange = GUICtrlCreateButton("Change", 220, 38)

	$bLoadCancel = GUICtrlCreateButton("Cancel", 5, 73)
	$bLoadLoad = GUICtrlCreateButton("Load", 240, 73)

	GUISetState()

EndFunc   ;==>CreateLoadWindow

#EndRegion Save\Load Window And Funcs

Func CalcStatMod($iInt, $iAddModifier = 1, $iAddBrackets = 1)
	;; iAddModifier is to add the Text "+" (minus doesnt need it as its part of the int)
	; So if you call with (15,0,0) then it will only return the INT)
	$statMod = ($iInt - 10) / 2
	;ConsoleWrite("StatMod - 10
	Select
		Case $iInt = ""
			$statMod = "n/a"
		Case $statMod > 0
			$statMod = Floor($statMod)
			If $iAddModifier Then $statMod = "+" & $statMod
		Case $statMod < 0
			$statMod = Floor($statMod)
	EndSelect
	If $iAddBrackets Then $statMod = "(" & $statMod & ")"
	Return $statMod
EndFunc   ;==>CalcStatMod

Func _WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
;~ 	ConsoleWrite(WinGetHandle($hwnd & " - " & $iMsg & @LF)

	; Get label posiition and size and adjust child GUI to fit
	Switch $hWnd
		Case $hInitiative
			$aPos = ControlGetPos($hInitiative, "", $idLabel)
			WinMove($hInitChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
			$initUB = UBound($initiativeArray)
			_GUIScrollbars_Scroll_Page($hInitChild, 1, 1)
			_GUIScrollbars_Generate($hInitChild, 280, 30 + $initUB * 25, 1, 1, False)
		Case $hPlayers
			$aPos = ControlGetPos($hPlayers, "", $playChildSizeLabel)
			WinMove($hPlayersChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
			$playUB = UBound($playersArray)
			_GUIScrollbars_Scroll_Page($hPlayersChild, 1, 1)
			_GUIScrollbars_Generate($hPlayersChild, 400, 30 + $playUB * 25, 1, 1, False)
		Case $hEncounter
			$aPos = ControlGetPos($hEncounter, "", $encoChildSizeLabel)
			WinMove($hEncounterChild, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
			$encoUB = UBound($encounterArray)
			_GUIScrollbars_Scroll_Page($hEncounterChild, 1, 1)
			_GUIScrollbars_Generate($hEncounterChild, 400, 30 + $encoUB * 25, 1, 1, False)
	EndSwitch

EndFunc   ;==>_WM_SIZE

Func _WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $iMsg, $iwParam, $ilParam
	Switch Number($hWnd) ;;; THIS STOPS YOU FROM BEING ABLE TO DRAG the CHILD GUIS
		Case Number($hInitChild);, Number($Frm_Child_2) - WINDOW HANDLE?
			Local $iCode = _WinAPI_DefWindowProc($hWnd, $iMsg, $iwParam, $ilParam)
			If $iCode = 2 Then Return 1
			Return $iCode
;~             Return 1  ;; Leave commented.
		Case Number($hPlayersChild);, Number($Frm_Child_2) - WINDOW HANDLE?
			Local $iCode = _WinAPI_DefWindowProc($hWnd, $iMsg, $iwParam, $ilParam)
			If $iCode = 2 Then Return 1
			Return $iCode
;~             Return 1
		Case Number($hEncounterChild);, Number($Frm_Child_2) - WINDOW HANDLE?
			Local $iCode = _WinAPI_DefWindowProc($hWnd, $iMsg, $iwParam, $ilParam)
			If $iCode = 2 Then Return 1
			Return $iCode
;~             Return 1
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NCHITTEST

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

	; structure to map $ilParam ($tNMHDR - see Help file)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam);, $tagNMLISTVIEW

	Switch $tNMHDR.IDFrom
		Case $encListview
			Switch $tNMHDR.Code
				Case $NM_KILLFOCUS
					$cLastFocus = $tNMHDR.IDFrom
					;ConsoleWrite("enclistview Kill focus" &@LF)
			EndSwitch
		Case $idListview
			Switch $tNMHDR.Code
				Case $NM_KILLFOCUS
					$cLastFocus = $tNMHDR.IDFrom
					;ConsoleWrite("Idlistview Kill focus" &@LF)
				Case $NM_DBLCLK
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					If $tInfo.Item > -1 Then
						$iItem = $tInfo.Item
						$monster = StringReplace(_GUICtrlListView_GetItemText($idListview, $iItem), " (in lair)", "")
						For $j = 0 To UBound($monsterArray) - 1
							If $monsterArray[$j][0] = $monster Then
								If $monsterArray[$j][9] = "CUSTOMMONSTER" Then
									$monsterBasic = IniRead($custIni, "Index", $monster, "")
									$monsterRead = IniReadSection($custIni, $monster)
								Else
									$monsterBasic = IniRead($monBasicIni, "Monsters", $monster, "")
									$monsterRead = IniReadSection($monCompIni, $monster)
								EndIf
								ExitLoop
							EndIf
						Next
						Local $monIndex = $j
						Local $statArray[6][4]
							Local $statCount = 0
							For $i = 1 To $monsterRead[0][0]
								Switch $monsterRead[$i][0]
									Case "STR", "DEX", "CON", "INT", "WIS", "CHA" ;; Stats as 14 (+2)
										$statSplit = StringSplit($monsterRead[$i][1], " (", 1)
										If IsArray($statSplit) Then
											$statSplit[2] = StringReplace($statSplit[2], ")", "")
											$statArray[$statCount][0] = $monsterRead[$i][0]
											$statArray[$statCount][1] = $statSplit[1]
											$statArray[$statCount][2] = $statSplit[2]
											$statCount += 1
										EndIf
;~ 									Case "AC"
;~ 										$encounterArray[$encoUB][10] = $monsterRead[$i][1] ;AC)
;~ 									Case "Speed"
;~ 										$encounterArray[$encoUB][9] = $monsterRead[$i][1] ; Speed
									Case "Saving Throws"
										$saveSplit = StringSplit($monsterRead[$i][1], ",")
										For $j = 1 To $saveSplit[0]
											$saveSplit[$j] = StringReplace($saveSplit[$j], " ", "")
											Select
												Case StringInStr($saveSplit[$j], "STR")
													$eSaveType = "STR"
												Case StringInStr($saveSplit[$j], "DEX")
													$eSaveType = "DEX"
												Case StringInStr($saveSplit[$j], "CON")
													$eSaveType = "CON"
												Case StringInStr($saveSplit[$j], "INT")
													$eSaveType = "INT"
												Case StringInStr($saveSplit[$j], "WIS")
													$eSaveType = "WIS"
												Case StringInStr($saveSplit[$j], "CHA")
													$eSaveType = "CHA"
											EndSelect

											$saveSplit[$j] = StringReplace($saveSplit[$j], $eSaveType, "")
											For $f = 0 To 5
												If $statArray[$f][0] = $eSaveType Then
													$statArray[$f][3] = $saveSplit[$j]
												EndIf
											Next

										Next
								EndSwitch
							Next
						$split = StringSplit($monsterBasic, "\\", 1)
						If $monsterArray[$monIndex][9] <> "CUSTOMMONSTER" Then ;; If NOT Custom Monster Then

							$quick = $monsterArray[$monIndex][1] & " " & $monsterArray[$monIndex][2] _
									 & ", " & AlignmentSwitch($monsterArray[$monIndex][4]) & @CRLF & "HP = " & $monsterArray[$monIndex][7] & @CRLF & "CR = " _
									 & $monsterArray[$monIndex][5] & " (XP: " & $monsterArray[$monIndex][6] & ")" & @CRLF & @LF & _ArrayToString(IniReadSection($monCompIni, $monster), " = ", 1)
;~ 							CreateSubWindow($monsterArray[$monIndex][9], $quick, 200 + (StringLen($monster) * 5))
							CreateNotesWindow($monsterArray[$monIndex][9], $quick, $hMainGUI, "Monster", $monIndex, $statArray, False, $monster)
							;ConsoleWrite(200 + (StringLen($split[6]) * 4) & @LF)
						Else
							;ConsoleWrite($item & @LF)
							$quick = $monsterArray[$monIndex][1] & " " & $monsterArray[$monIndex][2] _
									 & ", " & AlignmentSwitch($monsterArray[$monIndex][4]) & @CRLF & "HP = " & $monsterArray[$monIndex][7] & @CRLF & "CR = " _
									 & $monsterArray[$monIndex][5] & " (XP: " & $monsterArray[$monIndex][6] & ")" & @CRLF & @LF & _ArrayToString(IniReadSection($custIni, $monster), " = ", 1)
							CreateNotesWindow($monster, $quick, $hMainGUI, "Monster", $monIndex, $statArray, False, $monster)
							;ConsoleWrite(200 + (StringLen($item) * 4) & @LF) $monIndex
						EndIf
					EndIf
			EndSwitch
	EndSwitch
EndFunc   ;==>WM_NOTIFY
