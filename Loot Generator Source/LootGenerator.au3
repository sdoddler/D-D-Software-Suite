#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Resources\Loot Generator\Loot_Generator.ico
#AutoIt3Wrapper_Outfile=..\Loot Generator.exe
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include-once
#include "DiceRoll.au3"
#include "GemRoll.au3"
#include "ArtRoll.au3"
#include "TreasureRoll.au3"
#include "MagicItemRoll.au3"
#include "MiscItemRoll.au3"

#include <array.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>
#include <GuiListView.au3>
#include "..\Resources\_RefreshCache.au3"

_RefreshCache()

;; TO DO
;
; Create Custom Treasure Table - -
;		- Add option of dice rolls (results)
;		- Be able to search from Items & Magic Items (& Custom)
;;;---------------------


AutoItSetOption("GUIResizeMode", 802)

Global $version = "v.02"

Global $hMain = "", $mainTitle = "D&D Loot Generator"

Global $subWindows = 0
Global $hSubs[0]

$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)
DirCreate($appDir & "Loot Generator Resources\")

$prefIni = $appDir & "Preferences.ini"

$iconsIcl = $appDir & "Icons.icl"

;;BoolCheck fixes the issue that IniRead Returns a string
Global $smallFormFactor = BoolCheck(IniRead($prefIni, "Settings", "Small Form Factor", False))
Global $hTreasureTables = ""

#Region Global Variables -- These are the ones required to Set the GUI Initially Etc
Global $debugMode = BoolCheck(IniRead($prefIni, "Settings", "Debug Mode", False))
Global $subWindowRO = BoolCheck(IniRead($prefIni, "Settings", "Sub Windows Read Only", True))
Global $viewDiceRolls = BoolCheck(IniRead($prefIni, "Settings", "View Dice Rolls", False))

Global $treasureChallengeLevel = IniRead($prefIni, "Settings", "Challenge Level", "Challenge 0-4")
Global $treasureType = IniRead($prefIni, "Settings", "Treasure Type", "Individual")
Global $treasureTakeDefault = BoolCheck(IniRead($prefIni, "Settings", "Take Default Dice Rolls", False))
Global $treasureConvertGems = BoolCheck(IniRead($prefIni, "Settings", "Convert Gems\Art to Coins", False))

Global $miscWeapons = BoolCheck(IniRead($prefIni, "Settings", "Include Weapons", True))
Global $miscAdvGear = BoolCheck(IniRead($prefIni, "Settings", "Include Adv Gear", True))
Global $miscMounts = BoolCheck(IniRead($prefIni, "Settings", "Include Mounts", True))
Global $miscTools = BoolCheck(IniRead($prefIni, "Settings", "Include Tools", True))
Global $miscArmour = BoolCheck(IniRead($prefIni, "Settings", "Include Armour", True))

Global $miscMax = IniRead($prefIni, "Settings", "Max Value", "1 GP")
Global $miscAmount = IniRead($prefIni, "Settings", "Misc Dice Rolls", "2")
Global $miscDice = IniRead($prefIni, "Settings", "Misc Dice", "d8")

Global $magicCreator = BoolCheck(IniRead($prefIni, "Settings", "Include Creator", True))
Global $magicHistory = BoolCheck(IniRead($prefIni, "Settings", "Include History", True))
Global $magicMinor = BoolCheck(IniRead($prefIni, "Settings", "Include Minor Property(s)", True))
Global $magicQuirks = BoolCheck(IniRead($prefIni, "Settings", "Include Quirks", True))

Global $diceAmount = IniRead($prefIni, "Settings", "Dice Rolls", 1)
Global $diceType = IniRead($prefIni, "Settings", "Dice Type", "4")
#EndRegion Global Variables -- These are the ones required to Set the GUI Initially Etc

#Region Global Gui Variables -- Due to the Small Form Factor Option I need to declare empty Variables (Globally) So Autoit Doesn't Error\Warn
Global $bSmallFormFactor

Global $vCoTreasureHeaders, $vListview, $vTreasureHoards, $vTreasureIndiv

Global $arrQueue[0]

Global $gFile, $gDebug, $gReadOnly, $gViewRolls, $gViewTreasureTables
Global $coChallenge, $coTreasureType, $gTreasureTitle, $gTakeDefault, $bTreasureGenerate, $gConvertGems
Global $cbWeapons, $cbAdvGear, $cbArmour, $cbMounts, $cbTools, $gMiscTitle, $gMiscMaxValue, $bMiscGenerate
Global $gMagicTitle, $cbMinorProps, $cbQuirks, $cbCreator, $cbHistory, $bHistoryGenerate
Global $gDiceTitle, $coDice, $gRolls, $bRoll, $gAdd
Global $bQueue, $bRollQueue
Global $gDiscordIcon, $gTwitterIcon, $gYoutubeIcon, $gGithubIcon

Global $mTreasure, $mCL04, $mCL510, $mCL1116, $mCL17, $mHoard, $mIndividual, $mTakeDefault, $mConvertGems
Global $mMiscMenu, $mMiscWeapons, $mMiscAdv, $mMiscArmour, $mMiscMounts, $mMiscTools, $gMiscAmount, $coMiscDice
Global $mMagicItem, $mCreator, $mHistory, $mMinorProperty, $mQuirks
#EndRegion Global Gui Variables -- Due to the Small Form Factor Option I need to declare empty Variables (Globally) So Autoit Doesn't Error\Warn

#Region Misc Item Variables and Install
$weapIni = $appDir & "Loot Generator Resources\Weapons.txt"
$AdvGearIni = $appDir & "Loot Generator Resources\Adventuring Gear.txt"
$ArmourIni = $appDir & "Loot Generator Resources\Armour.txt"
$mountIni = $appDir & "Loot Generator Resources\Mounts.txt"
$toolIni = $appDir & "Loot Generator Resources\Tools.txt"

FileInstall("..\Resources\Loot Generator\Weapons.txt", $weapIni, 0)
FileInstall("..\Resources\Loot Generator\Adventuring Gear.txt", $AdvGearIni, 0)
FileInstall("..\Resources\Loot Generator\Armour.txt", $ArmourIni, 0)
FileInstall("..\Resources\Loot Generator\Mounts.txt", $mountIni, 0)
FileInstall("..\Resources\Loot Generator\Tools.txt", $toolIni, 0)
#EndRegion Misc Item Variables and Install

#Region Treasure and Gem\Art Install
FileInstall("..\Resources\Loot Generator\Gemstones.txt", $appDir & "Loot Generator Resources\Gemstones.txt", 0)
FileInstall("..\Resources\Loot Generator\Art Objects.txt", $appDir & "Loot Generator Resources\Art Objects.txt", 0)
FileInstall("..\Resources\Loot Generator\Treasure-Hoards.txt", $appDir & "Loot Generator Resources\Treasure-Hoards.txt", 0)
FileInstall("..\Resources\Loot Generator\Treasure-Individual.txt", $appDir & "Loot Generator Resources\Treasure-Individual.txt", 0)
#EndRegion Treasure and Gem\Art Install

#Region Magic Item Table Install
FileInstall("..\Resources\Loot Generator\Magic Item Table A.txt", $appDir & "Loot Generator Resources\Magic Item Table A.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table B.txt", $appDir & "Loot Generator Resources\Magic Item Table B.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table C.txt", $appDir & "Loot Generator Resources\Magic Item Table C.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table D.txt", $appDir & "Loot Generator Resources\Magic Item Table D.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table E.txt", $appDir & "Loot Generator Resources\Magic Item Table E.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table F.txt", $appDir & "Loot Generator Resources\Magic Item Table F.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table G.txt", $appDir & "Loot Generator Resources\Magic Item Table G.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table H.txt", $appDir & "Loot Generator Resources\Magic Item Table H.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Table I.txt", $appDir & "Loot Generator Resources\Magic Item Table I.txt", 0)

FileInstall("..\Resources\Loot Generator\Spell Levels.txt", $appDir & "Loot Generator Resources\Spell Levels.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Who Created it.txt", $appDir & "Loot Generator Resources\Magic Item Who Created it.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Quirks.txt", $appDir & "Loot Generator Resources\Magic Item Quirks.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item History.txt", $appDir & "Loot Generator Resources\Magic Item History.txt", 0)
FileInstall("..\Resources\Loot Generator\Magic Item Minor Property.txt", $appDir & "Loot Generator Resources\Magic Item Minor Property.txt", 0)
#EndRegion Magic Item Table Install

#Region Icon File Install

FileInstall("..\Resources\Icons.icl", $appDir & "Icons.icl", 1)
#EndRegion Icon File Install


If Not ($smallFormFactor) Then
	FullSizeGui()
Else
	SmallFormGui()
EndIf


GUISetState()

$Enter_KEY = GUICtrlCreateDummy()

Dim $Arr[1][2] = [["{ENTER}", $Enter_KEY]]

GUISetAccelerators($Arr, $hMain)

;; For additional windows have an Array structured as per below
;$windows[X][0] = WindowHandle
;$windows[X][1] = Full Data (Returned from whatever Generator was used)
;$windows[X][2] = Allow Edit (Button with Toggle)
;$windows[X][3] = Reset Data (Button to reset Input to [x][1])
;$windows[X][4] = Input Handle
;$windows[X][5] = Allow Edit Value (True/False) ??
;$windows[X][6] = Save Button? (Save current to .txt)

OnAutoItExitRegister("SavePreferences")


While 1

	$msg = GUIGetMsg(1)

	Switch $msg[1]
		Case $hMain

			#Region GUI Handling for Form Factor Agnostic Handles\Buttons
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $bSmallFormFactor
					GUIDelete($hMain)
					If $smallFormFactor Then
						$smallFormFactor = False
						FullSizeGui()
						GUISetAccelerators("")
						GUISetAccelerators($Arr, $hMain)
					Else
						$smallFormFactor = True
						SmallFormGui()
						GUISetAccelerators("")
						GUISetAccelerators($Arr, $hMain)
					EndIf
				Case $gDebug
					If $debugMode Then
						$debugMode = False
						GUICtrlSetState($gDebug, $GUI_UNCHECKED)
					Else
						$debugMode = True
						GUICtrlSetState($gDebug, $GUI_CHECKED)
					EndIf
				Case $gReadOnly
					If $subWindowRO Then
						$subWindowRO = False
						GUICtrlSetState($gReadOnly, $GUI_UNCHECKED)
					Else
						$subWindowRO = True
						GUICtrlSetState($gReadOnly, $GUI_CHECKED)
					EndIf
				Case $gViewRolls
					If $viewDiceRolls Then
						$viewDiceRolls = False
						GUICtrlSetState($gViewRolls, $GUI_UNCHECKED)
					Else
						$viewDiceRolls = True
						GUICtrlSetState($gViewRolls, $GUI_CHECKED)
					EndIf
				Case $gViewTreasureTables
					ViewTreasureTables()
				Case $coDice
					$diceType = GUICtrlRead($coDice)
					ConsoleWrite($diceType & @LF)
				Case $gRolls
					$diceAmount = GUICtrlRead($gRolls)
				Case $coMiscDice
					$miscDice = GUICtrlRead($coMiscDice)
				Case $gMiscAmount
					$miscAmount = GUICtrlRead($gMiscAmount)
				Case $bTreasureGenerate
					$treasure = TreasureRoll($treasureChallengeLevel, $treasureTakeDefault, $treasureType, $debugMode)
					$tempTitle = ""

					#Region Creating the info that goes into the Sub Window
					$TreasureInfo = $treasure[0]
					$Coins = $treasure[1]
					$Art = $treasure[2]
					$Gems = $treasure[3]
					$MagicItems = $treasure[4]
					$2ndMagicItems = $treasure[5]

					$treasureData = ""

					$treasureData &= ("---------------Treasure Roll---------------" & @CRLF)
					;--- Basic Treasure Info
					If $TreasureInfo[3] Then $treasureData &= ("-Debug: ENABLED" & @CRLF)
					$treasureData &= ("-Treasure Type: " & $TreasureInfo[2] & @CRLF _
							 & "-Challenge Level: " & $TreasureInfo[0] & @CRLF)
					If $TreasureInfo[1] Then $treasureData &= ("-Take Default Dice Rolls: ENABLED" & @CRLF)
					$treasureData &= ("-d100 Roll to Determine Treasure: " & $TreasureInfo[5] & @CRLF);;if Show Dice Rolls Then Show this line
					If $TreasureInfo[3] Then $treasureData &= ("-Raw Treasure Data from .txt: " & $TreasureInfo[4] & @CRLF)
					If ($TreasureInfo[3] And $TreasureInfo[6]) Then $treasureData &= ("-Raw Coin Data from .txt: " & $TreasureInfo[6] & @CRLF)
					;--- Show Coins gained from Loot
					If IsArray($Coins) Then
						$treasureData &= ("---Coins Gained from Loot: " & @CRLF)
						For $i = 0 To UBound($Coins) - 1
							If $Coins[$i][1] Then
								$treasureData &= ($Coins[$i][1] & " " & $Coins[$i][0] & @CRLF)
								If $viewDiceRolls Then
									$treasureData &= ("--Dice Rolled: " & $Coins[$i][3] & @CRLF _
											 & "--Dice Result: " & $Coins[$i][4])
									If $TreasureInfo[1] Then $treasureData &= (" (Default roll Taken)")
									If $viewDiceRolls And Not ($TreasureInfo[1]) Then $treasureData &= " (Individual Rolls: " & $Coins[$i][5] & ")"
									$treasureData &= (@CRLF & "--Multiplier: " & $Coins[$i][2] & @CRLF)
								EndIf
							EndIf
						Next
					EndIf
					;;--Show Art Gained from Loot
					If IsArray($Art) Then
						If $treasureConvertGems Then
							$treasureData &= ("---Converting " & $Art[0][0] & " x " & $Art[0][1] & " Art Objects to Coins:" & @CRLF)
							$treasureData &= (($Art[0][0] * StringReplace($Art[0][1], "GP", "")) & " GP" & @CRLF)
						Else
							$treasureData &= ("---" & $Art[0][0] & " x " & $Art[0][1] & " Art Objects Gained from Loot: " & @CRLF)
							If $viewDiceRolls Then
								$treasureData &= ("--Dice Rolled: " & $Art[0][2] & @CRLF _
										 & "--Dice Result: " & $Art[0][0])
								If $TreasureInfo[1] Then $treasureData &= (" (Default roll Taken)")
								$treasureData &= (@CRLF)
							EndIf
							For $i = 1 To UBound($Art) - 1
								$treasureData &= ($Art[$i][0] & "x " & $Art[$i][1])
								If $viewDiceRolls Then $treasureData &= (" (Individual Dice Rolls: " & $Art[$i][2] & ")")
								$treasureData &= (@CRLF)
							Next
						EndIf
					EndIf
					;;--Show Gems Gained from Loot
					If IsArray($Gems) Then

						If $treasureConvertGems Then
							$treasureData &= ("---Converting " & $Gems[0][0] & " x " & $Gems[0][1] & " Gems to Coins:" & @CRLF)
							$treasureData &= (($Gems[0][0] * StringReplace($Gems[0][1], "GP", "")) & " GP" & @CRLF)
						Else
							$treasureData &= ("---" & $Gems[0][0] & " x " & $Gems[0][1] & " Gems Gained from Loot: " & @CRLF)
							If $viewDiceRolls Then
								$treasureData &= ("--Dice Rolled: " & $Gems[0][2] & @CRLF _
										 & "--Dice Result: " & $Gems[0][0])
								If $TreasureInfo[1] Then $treasureData &= (" (Default roll Taken)")
								$treasureData &= (@CRLF)
							EndIf
							For $i = 1 To UBound($Gems) - 1
								$treasureData &= ($Gems[$i][0] & "x " & $Gems[$i][1])
								If $viewDiceRolls Then $treasureData &= (" (Individual Dice Rolls: " & $Gems[$i][2] & ")")
								$treasureData &= (@CRLF)
							Next
						EndIf
					EndIf
					;;--Show First set of Magic Items Gained from loot
					If IsArray($MagicItems) Then
						$treasureData &= ("---" & $MagicItems[0][0] & " x Item(s) from " & $MagicItems[0][1] & " Gained from Loot: " & @CRLF)
						If $viewDiceRolls Then
							$treasureData &= ("--Dice Rolled: " & $MagicItems[0][2] & @CRLF _
									 & "--Dice Result: " & $MagicItems[0][0])
							If $TreasureInfo[1] Then $treasureData &= (" (Default roll Taken)")
							$treasureData &= (@CRLF)
						EndIf
						For $i = 1 To UBound($MagicItems) - 1
							$treasureData &= ($MagicItems[$i][0] & "x " & $MagicItems[$i][1])
							If $viewDiceRolls Then $treasureData &= (" (Individual Dice Rolls: " & $MagicItems[$i][2] & ")")
							$treasureData &= (@CRLF)
						Next
					EndIf
					;;--Show Second set of Magic Items Gained from loot
					If IsArray($2ndMagicItems) Then
						$treasureData &= ("---" & $2ndMagicItems[0][0] & " x Item(s) from " & $2ndMagicItems[0][1] & " Gained from Loot: " & @CRLF)
						If $viewDiceRolls Then
							$treasureData &= ("--Dice Rolled: " & $2ndMagicItems[0][2] & @CRLF _
									 & "--Dice Result: " & $2ndMagicItems[0][0])
							If $TreasureInfo[1] Then $treasureData &= (" (Default roll Taken)")
							$treasureData &= (@CRLF)
						EndIf
						For $i = 1 To UBound($2ndMagicItems) - 1
							$treasureData &= ($2ndMagicItems[$i][0] & "x " & $2ndMagicItems[$i][1])
							If $viewDiceRolls Then $treasureData &= (" (Individual Dice Rolls: " & $2ndMagicItems[$i][2] & ")")
							$treasureData &= (@CRLF)
						Next
					EndIf

					#EndRegion Creating the info that goes into the Sub Window

					ConsoleWrite($treasureData)
					#Region Creating Sub Window With Treasure Info
					If Not ($smallFormFactor) Then $tempTitle = GUICtrlRead($gTreasureTitle)
					If $tempTitle = "" Then
						$tempTitle = "Treasure Generator"
					EndIf
					If WinExists($tempTitle) Then
						$i = 1
						While $i > 0
							If Not (WinExists($tempTitle & " - " & $i)) Then
								CreateSubWindow($tempTitle & " - " & $i, $treasureData, $subWindowRO)
								$i = 0
							Else
								$i += 1
							EndIf
						WEnd
					Else
						CreateSubWindow($tempTitle, $treasureData, $subWindowRO)
					EndIf
					#EndRegion Creating Sub Window With Treasure Info
				Case $bMiscGenerate
					$miscArray = 0
					$miscCount = 0
					Dim $miscArray[5]
					#Region Sort out what is being Included in the Misc Item Roll
					If $miscWeapons Then
						$miscArray[$miscCount] = $weapIni
						$miscCount += 1
					EndIf
					If $miscAdvGear Then
						$miscArray[$miscCount] = $AdvGearIni
						$miscCount += 1
					EndIf
					If $miscMounts Then
						$miscArray[$miscCount] = $mountIni
						$miscCount += 1
					EndIf
					If $miscArmour Then
						$miscArray[$miscCount] = $ArmourIni
						$miscCount += 1
					EndIf
					If $miscTools Then
						$miscArray[$miscCount] = $toolIni
						$miscCount += 1
					EndIf
					ReDim $miscArray[$miscCount]
					#EndRegion Sort out what is being Included in the Misc Item Roll

					$miscItems = ItemRoll(GUICtrlRead($coMiscDice), GUICtrlRead($gMiscAmount), $miscArray, GUICtrlRead($gMiscMaxValue))
					$tempTitle = ""
					$miscData = ""


					If IsArray($miscItems) Then
						$miscData &= ("-------------Misc Item Roll-------------" & @CRLF)
						;--- Basic Misc Info
						;If $debugMode Then $miscData &= ("-Debug: ENABLED" & @CRLF)
						$miscData &= ("---" & $miscItems[0][0] & " x Misc Items Gained from Loot: " & @CRLF)
						If $viewDiceRolls Then;;; USing this for now for lack of a better debug thingy.
							$miscData &= ("--Dice Rolled: " & $miscItems[0][1] & @CRLF _
									 & "--Dice Result: " & $miscItems[0][0] & " (Individual Dice Rolls: " & $miscItems[0][2] & ")" & @CRLF)

						EndIf
						$miscData &= ("--Types Chosen From: " & $miscItems[0][3] & @CRLF _
								 & "--Max Price\Value: " & $miscItems[0][4] & @CRLF)
						For $i = 1 To UBound($miscItems) - 1
							$miscData &= ($miscItems[$i][0] & "x " & $miscItems[$i][1] & @CRLF)
						Next

						If Not ($smallFormFactor) Then $tempTitle = GUICtrlRead($gMiscTitle)
						If $tempTitle = "" Then
							$tempTitle = "Misc Item Generator"
						EndIf
						If WinExists($tempTitle) Then
							$i = 1
							While $i > 0
								If Not (WinExists($tempTitle & " - " & $i)) Then
									CreateSubWindow($tempTitle & " - " & $i, $miscData, $subWindowRO)
									$i = 0
								Else
									$i += 1
								EndIf
							WEnd
						Else
							CreateSubWindow($tempTitle, $miscData, $subWindowRO)
						EndIf

					EndIf
				Case $bRoll
					$diceData = ""
					$tempTitle = ""
					$dice = GUICtrlRead($coDice)
					$amount = GUICtrlRead($gRolls)
					$additive = GUICtrlRead($gAdd)

					$diceRoll = DiceRoll($dice, $amount, $debugMode, $additive)

					If Not ($smallFormFactor) Then $tempTitle = GUICtrlRead($gDiceTitle)
					If $tempTitle = "" Then
						$tempTitle = "Misc Item Generator"
					EndIf
					$diceData = "-------Dice Roll-------" & @CRLF
					If $debugMode Then $diceData &= "Dice = " & $dice & @CRLF & "Amount = " & $amount & @CRLF & "--------------" & @CRLF
					For $i = 0 To UBound($diceRoll) - 2
						$diceData &= "Rolling a " & $dice & "..." & @CRLF & "--Result = " & $diceRoll[$i] & @CRLF & "--------------" & @CRLF
					Next
					If $additive <> 0 Then $diceData &= "Adding " & $additive & " to Total" & @CRLF & "--------------" & @CRLF
					$diceData &= @CRLF & "Total = " & $diceRoll[UBound($diceRoll) - 1]
					If WinExists($tempTitle) Then
						$i = 1
						While $i > 0
							If Not (WinExists($tempTitle & " - " & $i)) Then
								CreateSubWindow($tempTitle & " - " & $i, $diceData, $subWindowRO)
								$i = 0
							Else
								$i += 1
							EndIf
						WEnd
					Else
						CreateSubWindow($tempTitle, $diceData, $subWindowRO)
					EndIf
				Case $bQueue
					$currQ = UBound($arrQueue)
					ReDim $arrQueue[$currQ + 1][4]
					;Title(FullSize only) || Rolls || Dice || Addition

					If Not ($smallFormFactor) Then $arrQueue[$currQ][0] = GUICtrlRead($gDiceTitle)
					$arrQueue[$currQ][1] = GUICtrlRead($gRolls)
					$arrQueue[$currQ][2] = GUICtrlRead($coDice)
					$arrQueue[$currQ][3] = GUICtrlRead($gAdd)

					GUICtrlSetData($bRollQueue, "Roll" & @LF & "Queue(" & UBound($arrQueue) & ")")
				Case $bRollQueue

					if UBound($arrQueue) - 1 > -1 Then
					For $a = 0 To UBound($arrQueue) - 1
						$dice = $arrQueue[$a][2]
						$amount = $arrQueue[$a][1]
						$additive = $arrQueue[$a][3]

						$diceRoll = DiceRoll($dice, $amount, $debugMode, $additive)

						$tempTitle = "Dice Roll Queue"


						if $a = 0 then $diceData = ""
						$diceData &= "-------Dice Roll-------" & @CRLF
						if $arrQueue[$a][0] <> "" Then $diceData &= "---" & $arrQueue[$a][0] & @CRLF
						if $additive >= 0 Then
							$diceData &= "Rolling " & $amount & "d" & $dice & " + "& $additive & @CRLF & "--------------" & @CRLF
						Else
							$diceData &= "Rolling " & $amount & "d" & $dice & " - "& $additive & @CRLF & "--------------" & @CRLF
						EndIf
						;If $debugMode Then $diceData &= "Dice = " & $dice & @CRLF & "Amount = " & $amount & @CRLF & "--------------" & @CRLF
						if $viewDiceRolls Then
						For $i = 0 To UBound($diceRoll) - 2
							$diceData &= "Rolling a " & $dice & "..." & @CRLF & "--Result = " & $diceRoll[$i] & @CRLF & "--------------" & @CRLF
						Next
						EndIf
						;If $additive <> 0 Then $diceData &= "Adding " & $additive & " to Total" & @CRLF & "--------------" & @CRLF
						$diceData &=  "Total = " & $diceRoll[UBound($diceRoll) - 1] & @CRLF &@CRLF

					Next
					If WinExists($tempTitle) Then
							$i = 1
							While $i > 0
								If Not (WinExists($tempTitle & " - " & $i)) Then
									CreateSubWindow($tempTitle & " - " & $i, $diceData, $subWindowRO)
									$i = 0
								Else
									$i += 1
								EndIf
							WEnd
						Else
							CreateSubWindow($tempTitle, $diceData, $subWindowRO)
						EndIf
					Redim $arrQueue[0]
					GUICtrlSetData($bRollQueue, "Roll" & @LF & "Queue(" & UBound($arrQueue) & ")")
					EndIf
				Case $bHistoryGenerate
					$historyData = "------ History Roll ------" & @CRLF
					;if $debugMode Then $historyData &= "DebugMode: ENABLED" &@CRLF
					$tempTitle = ""
					$minorProperties = 0
					$magicHistArray = 0

					If $magicMinor Then
						$minorProperties = MinorPropertyRoll($debugMode)
					EndIf
					If ($magicCreator Or $magicHistory Or $magicQuirks Or $magicMinor) Then
						If IsArray($minorProperties) Then
							$historyData &= "---Minor Property(s)---" & @CRLF
							For $i = 0 To UBound($minorProperties) - 1
								If Not ($i = 0) Then $historyData &= @CRLF
								$historyData &= $minorProperties[$i][0] & "." & @CRLF & $minorProperties[$i][1] & @CRLF
								If $viewDiceRolls Then $historyData &= "Individual Dice Roll: " & $minorProperties[$i][2] & @CRLF
							Next
							$historyData &= "---------------------" & @CRLF
						EndIf
						$magicHistArray = HistoryAndQuirksRoll($magicHistory, $magicQuirks, $magicCreator, $debugMode)
						If IsArray($magicHistArray) Then
							For $i = 0 To UBound($magicHistArray) - 1
								$historyData &= "---" & $magicHistArray[$i][3] & "---" & @CRLF
								$historyData &= $magicHistArray[$i][0] & "." & @CRLF & $magicHistArray[$i][1] & @CRLF
								If $viewDiceRolls Then $historyData &= "Individual Dice Roll: " & $magicHistArray[$i][2] & @CRLF
								$historyData &= "---------------------" & @CRLF
							Next
						EndIf


					Else
						$historyData = "No History Types Selected"
					EndIf
					If Not ($smallFormFactor) Then $tempTitle = GUICtrlRead($gDiceTitle)
					If $tempTitle = "" Then
						$tempTitle = "Misc Item Generator"
					EndIf
					If WinExists($tempTitle) Then
						$i = 1
						While $i > 0
							If Not (WinExists($tempTitle & " - " & $i)) Then
								CreateSubWindow($tempTitle & " - " & $i, $historyData, $subWindowRO)
								$i = 0
							Else
								$i += 1
							EndIf
						WEnd
					Else
						CreateSubWindow($tempTitle, $historyData, $subWindowRO)
					EndIf
				Case $gDiscordIcon
					ShellExecute('https://discord.gg/qkEGawD')
				Case $gTwitterIcon
					ShellExecute('https://twitter.com/sdoddler')
				Case $gYoutubeIcon
					ShellExecute('https://youtube.com/user/doddddy')
				Case $gGithubIcon
					ShellExecute('https://github.com/sdoddler/D-D-Software-Suite')
			EndSwitch
			#EndRegion GUI Handling for Form Factor Agnostic Handles\Buttons
			If $smallFormFactor Then
				#Region GUI Handling for Small Form Factor
				Switch $msg[0]
					Case $mCL17
						$treasureChallengeLevel = "Challenge 17+"
					Case $mCL1116
						$treasureChallengeLevel = "Challenge 11-16"
					Case $mCL510
						$treasureChallengeLevel = "Challenge 5-10"
					Case $mCL04
						$treasureChallengeLevel = "Challenge 0-4"
					Case $mHoard
						$treasureType = "Hoards"
					Case $mIndividual
						$treasureType = "Individual"
					Case $mTakeDefault
						If $treasureTakeDefault Then
							$treasureTakeDefault = False
							GUICtrlSetState($mTakeDefault, $GUI_UNCHECKED)
						Else
							$treasureTakeDefault = True
							GUICtrlSetState($mTakeDefault, $GUI_CHECKED)
						EndIf
					Case $mConvertGems
						If $treasureConvertGems Then
							$treasureConvertGems = False
							GUICtrlSetState($mConvertGems, $GUI_UNCHECKED)
						Else
							$treasureConvertGems = True
							GUICtrlSetState($mConvertGems, $GUI_CHECKED)
						EndIf
					Case $mMiscWeapons
						If $miscWeapons Then
							$miscWeapons = False
							GUICtrlSetState($mMiscWeapons, $GUI_UNCHECKED)
						Else
							$miscWeapons = True
							GUICtrlSetState($mMiscWeapons, $GUI_CHECKED)
						EndIf
					Case $mMiscAdv
						If $miscAdvGear Then
							$miscAdvGear = False
							GUICtrlSetState($mMiscAdv, $GUI_UNCHECKED)
						Else
							$miscAdvGear = True
							GUICtrlSetState($miscAdvGear, $GUI_CHECKED)
						EndIf
					Case $mMiscArmour
						If $miscArmour Then
							$miscArmour = False
							GUICtrlSetState($mMiscArmour, $GUI_UNCHECKED)
						Else
							$miscArmour = True
							GUICtrlSetState($mMiscArmour, $GUI_CHECKED)
						EndIf
					Case $mMiscTools
						If $miscTools Then
							$miscTools = False
							GUICtrlSetState($mMiscTools, $GUI_UNCHECKED)
						Else
							$miscTools = True
							GUICtrlSetState($mMiscTools, $GUI_CHECKED)
						EndIf
					Case $mMiscMounts
						If $miscMounts Then
							$miscMounts = False
							GUICtrlSetState($mMiscMounts, $GUI_UNCHECKED)
						Else
							$miscMounts = True
							GUICtrlSetState($mMiscMounts, $GUI_CHECKED)
						EndIf
					Case $mCreator
						If $magicCreator Then
							$magicCreator = False
							GUICtrlSetState($mCreator, $GUI_UNCHECKED)
						Else
							$magicCreator = True
							GUICtrlSetState($mCreator, $GUI_CHECKED)
						EndIf
					Case $mHistory
						If $magicHistory Then
							$magicHistory = False
							GUICtrlSetState($mHistory, $GUI_UNCHECKED)
						Else
							$magicHistory = True
							GUICtrlSetState($mHistory, $GUI_CHECKED)
						EndIf
					Case $mMinorProperty
						If $magicMinor Then
							$magicMinor = False
							GUICtrlSetState($mMinorProperty, $GUI_UNCHECKED)
						Else
							$magicMinor = True
							GUICtrlSetState($mMinorProperty, $GUI_CHECKED)
						EndIf
					Case $mQuirks
						If $magicQuirks Then
							$magicQuirks = False
							GUICtrlSetState($mQuirks, $GUI_UNCHECKED)
						Else
							$magicQuirks = True
							GUICtrlSetState($mQuirks, $GUI_CHECKED)
						EndIf
					Case $Enter_KEY
						$CurrCtrl = ControlGetFocus($hMain)
						If $debugMode Then ConsoleWrite($CurrCtrl & @LF)
						If $CurrCtrl = "Edit1" Or $CurrCtrl = "Edit2" Then
							_GUICtrlButton_Click($bMiscGenerate)
						ElseIf $CurrCtrl = "Edit3" Then
							_GUICtrlButton_Click($bRoll)
						EndIf
				EndSwitch
				#EndRegion GUI Handling for Small Form Factor
			Else
				#Region GUI Handling for Full Form Factor
				Switch $msg[0]

					Case $coChallenge
						$treasureChallengeLevel = GUICtrlRead($coChallenge)
					Case $coTreasureType
						$treasureType = GUICtrlRead($coTreasureType)
					Case $gTakeDefault
						If $treasureTakeDefault Then
							$treasureTakeDefault = False
						Else
							$treasureTakeDefault = True
						EndIf
					Case $gConvertGems
						If $treasureConvertGems Then
							$treasureConvertGems = False
						Else
							$treasureConvertGems = True
						EndIf
					Case $cbWeapons
						$miscWeapons = Not ($miscWeapons)
					Case $cbAdvGear
						$miscAdvGear = Not ($miscAdvGear)
					Case $cbArmour
						$miscArmour = Not ($miscArmour)
					Case $cbTools
						$miscTools = Not ($miscTools)
					Case $cbMounts
						$miscMounts = Not ($miscMounts)
					Case $cbCreator
						$magicCreator = Not ($magicCreator)
					Case $cbHistory
						$magicHistory = Not ($magicHistory)
					Case $cbMinorProps
						$magicMinor = Not ($magicMinor)
					Case $cbQuirks
						$magicQuirks = Not ($magicQuirks)
					Case $Enter_KEY
						$CurrCtrl = ControlGetFocus($hMain)
						If $debugMode Then ConsoleWrite($CurrCtrl & @LF)
						If $CurrCtrl = "Edit1" Then
							_GUICtrlButton_Click($bTreasureGenerate)
						ElseIf $CurrCtrl = "Edit2" Or $CurrCtrl = "Edit3" Or $CurrCtrl = "Edit4" Then
							_GUICtrlButton_Click($bMiscGenerate)
						ElseIf $CurrCtrl = "Edit5" Then
							_GUICtrlButton_Click($bHistoryGenerate)
						ElseIf $CurrCtrl = "Edit6" Or $CurrCtrl = "Edit7" Then
							_GUICtrlButton_Click($bRoll)
						EndIf
				EndSwitch
				#EndRegion GUI Handling for Full Form Factor
			EndIf
		Case $hTreasureTables
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					GUIDelete($hTreasureTables)
				Case $vCoTreasureHeaders
					TreasureTableGenerate(GUICtrlRead($vCoTreasureHeaders))
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

Func CreateSubWindow($iTitle, $iData, $iReadOnly)
	;; For additional windows have an Array structured as per below
	;$windows[X][0] = WindowHandle
	;$windows[X][1] = Full Data (Returned from whatever Generator was used)
	;$windows[X][2] = Allow Edit (Button with Toggle)
	;$windows[X][3] = Reset Data (Button to reset Input to [x][1])
	;$windows[X][5] = Input Handle
	;$windows[X][4] = Save Button? (Save current to .txt)
	;$windows[X][6] = Allow Edit Value (True/False) ??
	Local $height, $width
	GUISetState(@SW_DISABLE, $hMain)

	$subWindows += 1


	ReDim $hSubs[$subWindows + 1][8]

	$hSubs[$subWindows][0] = GUICreate($iTitle, 250, 300, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

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

	$hSubs[$subWindows][5] = GUICtrlCreateEdit($iData, 5, 5, 240, 210, $styles)


	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)

	GUISetState()

	GUISetState(@SW_ENABLE, $hMain)
EndFunc   ;==>CreateSubWindow

Func SmallFormGui()

	$hMain = GUICreate($mainTitle & " " & $version, 300, 300, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

	#Region Options Menu
	$gFile = GUICtrlCreateMenu("File")
	$gDebug = GUICtrlCreateMenuItem("Debug Mode", $gFile)
	If $debugMode Then GUICtrlSetState(-1, $GUI_CHECKED)
	$gReadOnly = GUICtrlCreateMenuItem("Sub-Windows Initially Read-only", $gFile)
	If $subWindowRO Then GUICtrlSetState(-1, $GUI_CHECKED)
	$gViewRolls = GUICtrlCreateMenuItem("View Dice Rolls", $gFile)
	If $viewDiceRolls Then GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateMenuItem("", $gFile)
	$gViewTreasureTables = GUICtrlCreateMenuItem("View Treasure Tables", $gFile)
	#EndRegion Options Menu

	#Region Small Form Factor Treasure Gen Menu
	$mTreasure = GUICtrlCreateMenu("Treasure")
	$mCL04 = GUICtrlCreateMenuItem("Challenge 0-4", $mTreasure, -1, 1)
	If $treasureChallengeLevel = "Challenge 0-4" Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mCL510 = GUICtrlCreateMenuItem("Challenge 5-10", $mTreasure, -1, 1)
	If $treasureChallengeLevel = "Challenge 5-10" Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mCL1116 = GUICtrlCreateMenuItem("Challenge 11-16", $mTreasure, -1, 1)
	If $treasureChallengeLevel = "Challenge 11-16" Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mCL17 = GUICtrlCreateMenuItem("Challenge 17+", $mTreasure, -1, 1)
	If $treasureChallengeLevel = "Challenge 17+" Then GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateMenuItem("", $mTreasure)
	$mHoard = GUICtrlCreateMenuItem("Hoards", $mTreasure, -1, 1)
	If $treasureType = "Hoards" Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mIndividual = GUICtrlCreateMenuItem("Individual", $mTreasure, -1, 1)
	If $treasureType = "Individuals" Then GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateMenuItem("", $mTreasure)
	$mTakeDefault = GUICtrlCreateMenuItem("Take Default Dice Rolls", $mTreasure)
	If $treasureTakeDefault Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mConvertGems = GUICtrlCreateMenuItem("Convert Gems\Art to Coins", $mTreasure)
	If $treasureConvertGems Then GUICtrlSetState(-1, $GUI_CHECKED)
	#EndRegion Small Form Factor Treasure Gen Menu

	#Region Misc Item Gen Menu (Small Form Factor)
	$mMiscMenu = GUICtrlCreateMenu("Misc Items")
	$mMiscWeapons = GUICtrlCreateMenuItem("Weapons", $mMiscMenu)
	If $miscWeapons Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mMiscAdv = GUICtrlCreateMenuItem("Adventuring Gear", $mMiscMenu)
	If $miscAdvGear Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mMiscArmour = GUICtrlCreateMenuItem("Armour", $mMiscMenu)
	If $miscArmour Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mMiscMounts = GUICtrlCreateMenuItem("Mounts", $mMiscMenu)
	If $miscMounts Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mMiscTools = GUICtrlCreateMenuItem("Tools", $mMiscMenu)
	If $miscTools Then GUICtrlSetState(-1, $GUI_CHECKED)
	#EndRegion Misc Item Gen Menu (Small Form Factor)

	#Region Magic Item History Menu
	$mMagicItem = GUICtrlCreateMenu("Magic Item Info")
	$mCreator = GUICtrlCreateMenuItem("Creator", $mMagicItem)
	If $magicCreator Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mHistory = GUICtrlCreateMenuItem("History", $mMagicItem)
	If $magicHistory Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mMinorProperty = GUICtrlCreateMenuItem("Minor Property(s)", $mMagicItem)
	If $magicMinor Then GUICtrlSetState(-1, $GUI_CHECKED)
	$mQuirks = GUICtrlCreateMenuItem("Quirks", $mMagicItem)
	If $magicQuirks Then GUICtrlSetState(-1, $GUI_CHECKED)
	#EndRegion Magic Item History Menu

	#Region Small Form Factor Main Window
	GUICtrlCreateGroup("Treasure Generator", 5, 5, 180, 55)
	GUISetFont(14)
	$bTreasureGenerate = GUICtrlCreateButton("Generate Treasure", 10, 20)
	GUISetFont(8.5)

	GUICtrlCreateGroup("Misc Item Generator", 5, 65, 250, 65)
	$gMiscMaxValue = GUICtrlCreateInput($miscMax, 25, 80, 65, 18)

	GUICtrlCreateIcon($iconsIcl, 2, 230, 60, 32, 32)
	GUICtrlSetTip(-1, "This feature was requested by a friend, " & @LF & "it is not D&D Offical and therefore requires balancing by the DM." & @LF _
			 & "Also if you choose an invalid price for specific items you will get no results" & @LF & "(E.g. 1SP for Tools will give you nothing)", "Misc Item Generator", 1)

	GUICtrlCreateLabel(" X ", 10, 105)

	$gMiscAmount = GUICtrlCreateInput($miscAmount, 25, 100)

	$coMiscDice = GUICtrlCreateCombo("", 50, 100, 45, -1, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "d4|d6|d8|d10|d12|d20|d100", $miscDice)

	GUISetFont(14)
	$bMiscGenerate = GUICtrlCreateButton("Generate Items", 110, 90)
	GUISetFont(8.5)

	GUICtrlCreateGroup("Magic Item History", 5, 140, 180, 55)

	GUISetFont(14)
	$bHistoryGenerate = GUICtrlCreateButton("Generate History", 10, 155)

	GUISetFont(8.5)
	GUICtrlCreateGroup("Dice Roller", 5, 200, 290, 52)

	$gRolls = GUICtrlCreateInput($diceAmount, 10, 225, 27, 20, $ES_NUMBER)
	GUICtrlSetLimit(-1, 4)

	GUICtrlCreateLabel(" X ", 37, 229)

	$coDice = GUICtrlCreateCombo("", 50, 225, 40, $ES_NUMBER) ;, -1, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "4|6|8|10|12|20|100", $diceType)

	GUISetFont(12)
	GUICtrlCreateLabel("+ ", 90, 225)
	GUISetFont(8.5)

	$gAdd = GUICtrlCreateInput(0, 99, 225, 34, 20, $ES_NUMBER)
	GUICtrlCreateUpdown(-1)
	GUICtrlSetLimit(-1, 10, -10)

	GUISetFont(14)

	$bRoll = GUICtrlCreateButton("Roll!", 135, 215)
	GUISetFont(8.5)

	$bQueue = GUICtrlCreateButton("Queue", 190, 220)

	$bRollQueue = GUICtrlCreateButton("Roll" & @LF & "Queue(" & UBound($arrQueue) & ")", 233, 215, -1, 35, $BS_MULTILINE)

	;; Add a queueing system for the Rolls (seperate button with "Roll Queue (0)") ?




	#EndRegion Small Form Factor Main Window

	#Region Icons\Buttons

	$bSmallFormFactor = GUICtrlCreateIcon("C:\Windows\System32\shell32.dll", 268, 244, 10, 48, 48)
	GUICtrlSetTip(-1, "Change to the Larger version of the GUI", "Switch to Large Form Factor")

	$gDiscordIcon = GUICtrlCreateIcon($iconsIcl,27, 220, 134, 32, 32)
	GUICtrlSetTip($gDiscordIcon, " ", "sDoddler's Discord Server")
	GUICtrlSetCursor(-1, 0)
	$gTwitterIcon = GUICtrlCreateIcon($iconsIcl,13, 260, 134, 32, 32)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip($gTwitterIcon, " ", "sDoddler's Twitter Page")
	$gYoutubeIcon = GUICtrlCreateIcon($iconsIcl,14, 220, 168, 32, 32)
	GUICtrlSetTip($gYoutubeIcon, " ", "sDoddler's YouTube Channel")
	GUICtrlSetCursor(-1, 0)
	$gGithubIcon = GUICtrlCreateIcon($iconsIcl,11, 260, 168, 32, 32)
	GUICtrlSetTip($gGithubIcon, " ", "D&D Software Suite Github Page")
	GUICtrlSetCursor(-1, 0)

	#EndRegion Icons\Buttons

	GUISetState()

EndFunc   ;==>SmallFormGui

Func FullSizeGui()

	$hMain = GUICreate($mainTitle & " " & $version, 505, 460, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

	#Region Options Menu
	$gFile = GUICtrlCreateMenu("File")
	$gDebug = GUICtrlCreateMenuItem("Debug Mode", $gFile)
	If $debugMode Then GUICtrlSetState(-1, $GUI_CHECKED)
	$gReadOnly = GUICtrlCreateMenuItem("Sub-Windows Initially Read-only", $gFile)
	If $subWindowRO Then GUICtrlSetState(-1, $GUI_CHECKED)
	$gViewRolls = GUICtrlCreateMenuItem("View Dice Rolls", $gFile)
	If $viewDiceRolls Then GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateMenuItem("", $gFile)
	$gViewTreasureTables = GUICtrlCreateMenuItem("View Treasure Tables", $gFile)
	#EndRegion Options Menu

	#Region Treasure Generator Gui
	GUISetFont(14)
	GUICtrlCreateGroup("Treasure Generator", 10, 10, 480, 100)
	GUISetFont(8.5)

	GUICtrlCreateLabel("Challenge Level:", 20, 40)

	$coChallenge = GUICtrlCreateCombo("", 100, 35, 110, 35, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "Challenge 0-4|Challenge 5-10|Challenge 11-16|Challenge 17+", $treasureChallengeLevel)

	GUICtrlCreateLabel("Treasure Type:", 220, 40)
	$coTreasureType = GUICtrlCreateCombo("", 295, 35, 110, 35, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "Individual|Hoards", $treasureType)

	GUICtrlCreateLabel("Title (Optional):", 20, 70)
	$gTreasureTitle = GUICtrlCreateInput("", 95, 68, 70)

	$gTakeDefault = GUICtrlCreateCheckbox("Take Default Dice Rolls", 170, 60)
	If $treasureTakeDefault Then GUICtrlSetState(-1, $GUI_CHECKED)

	$gConvertGems = GUICtrlCreateCheckbox("Convert Gems\Art to Coins", 170, 80)
	If $treasureConvertGems Then GUICtrlSetState(-1, $GUI_CHECKED)

	GUISetFont(14)
	$bTreasureGenerate = GUICtrlCreateButton("Generate Treasure", 315, 60)
	#EndRegion Treasure Generator Gui

	#Region Misc Item Generator Gui
	GUICtrlCreateGroup("Misc Item Generator", 10, 110, 480, 100)
	GUISetFont(8.5)

	GUICtrlCreateLabel("Include in Generator:", 20, 140)

	$cbWeapons = GUICtrlCreateCheckbox("Weapons", 125, 135)
	If $miscWeapons Then GUICtrlSetState(-1, $GUI_CHECKED)

	$cbAdvGear = GUICtrlCreateCheckbox("Adv. Gear", 195, 135)
	If $miscAdvGear Then GUICtrlSetState(-1, $GUI_CHECKED)

	$cbArmour = GUICtrlCreateCheckbox("Armour", 265, 135)
	If $miscArmour Then GUICtrlSetState(-1, $GUI_CHECKED)

	$cbMounts = GUICtrlCreateCheckbox("Mounts", 325, 135)
	If $miscMounts Then GUICtrlSetState(-1, $GUI_CHECKED)

	$cbTools = GUICtrlCreateCheckbox("Tools", 385, 135)
	If $miscTools Then GUICtrlSetState(-1, $GUI_CHECKED)

	GUICtrlCreateLabel("Title (Opt.):", 20, 170)
	$gMiscTitle = GUICtrlCreateInput("", 70, 168, 70)

	GUICtrlCreateLabel("Max Value (p/item):", 150, 160)
	$gMiscMaxValue = GUICtrlCreateInput($miscMax, 150, 178, 65)

	GUICtrlCreateLabel(" X ", 235, 183)

	$gMiscAmount = GUICtrlCreateInput($miscAmount, 250, 178)

	$coMiscDice = GUICtrlCreateCombo("", 275, 178, 45, -1, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "d4|d6|d8|d10|d12|d20|d100", $miscDice)

	GUICtrlCreateIcon($iconsIcl, 2, 435, 125, 32, 32)
	GUICtrlSetTip(-1, "This feature was requested by a friend, " & @LF & "it is not D&D Offical and therefore requires balancing by the DM." & @LF _
			 & "Also if you choose an invalid price for specific items you will get no results" & @LF & "(E.g. 1SP for Tools will give you nothing)", "Misc Item Generator", 1)

	GUISetFont(14)
	$bMiscGenerate = GUICtrlCreateButton("Generate Items", 330, 160)
	#EndRegion Misc Item Generator Gui

	#Region Magic Item History
	GUICtrlCreateGroup("Magic Item History", 10, 210, 480, 85)
	GUISetFont(8.5)

	GUICtrlCreateLabel("Title\Name (Optional):", 20, 240)
	$gMagicTitle = GUICtrlCreateInput("", 125, 237, 100)

	GUICtrlCreateLabel("Magic Item Info:", 20, 270)

	$cbMinorProps = GUICtrlCreateCheckbox("Minor Property(s)", 105, 265)
	If $magicMinor Then GUICtrlSetState(-1, $GUI_CHECKED)

	$cbQuirks = GUICtrlCreateCheckbox("Quirks", 205, 265)
	If $magicQuirks Then GUICtrlSetState(-1, $GUI_CHECKED)

	$cbCreator = GUICtrlCreateCheckbox("Creator(s)", 255, 265)
	If $magicCreator Then GUICtrlSetState(-1, $GUI_CHECKED)

	$cbHistory = GUICtrlCreateCheckbox("History", 320, 265)
	If $magicHistory Then GUICtrlSetState(-1, $GUI_CHECKED)

	GUISetFont(14)

	$bHistoryGenerate = GUICtrlCreateButton("Generate History", 325, 230)
	#EndRegion Magic Item History

	#Region Dice Roller
	GUICtrlCreateGroup("Dice Roller", 10, 300, 480, 65)
	GUISetFont(8.5)

	GUICtrlCreateLabel("Title (Opt.):", 20, 330)
	$gDiceTitle = GUICtrlCreateInput("", 75, 328, 60)

	GUICtrlCreateLabel("Rolls:", 137, 330)
	$gRolls = GUICtrlCreateInput($diceAmount, 168, 328, 30, -1, $ES_NUMBER)

	GUICtrlCreateLabel("Sides:", 205, 330)
	$coDice = GUICtrlCreateCombo("", 235, 328, 40);;, -1, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "4|6|8|10|12|20|100", $diceType)

	GUICtrlCreateLabel("Add:", 280, 330)
	$gAdd = GUICtrlCreateInput(0, 305, 327, 39, 20, $ES_NUMBER)
	GUICtrlCreateUpdown(-1)
	GUICtrlSetLimit(-1, 10, -10)

	GUISetFont(14)

	$bRoll = GUICtrlCreateButton("Roll!", 345, 320)
	GUISetFont(8.5)

	$bQueue = GUICtrlCreateButton("Queue", 395, 325)

	$bRollQueue = GUICtrlCreateButton("Roll" & @LF & "Queue(" & UBound($arrQueue) & ")", 435, 320, -1, 35, $BS_MULTILINE)

	#EndRegion Dice Roller

	#Region Icons\Small Form Factor Button
	$bSmallFormFactor = GUICtrlCreateIcon("C:\Windows\System32\shell32.dll", 268, 10, 370, 32, 32)
	GUICtrlSetTip(-1, "Change to the Smaller version of the GUI", "Switch to Small Form Factor")

	$gDiscordIcon = GUICtrlCreateIcon($iconsIcl,27, 340, 370, 32, 32)
	GUICtrlSetTip($gDiscordIcon, " ", "sDoddler's Discord Server")
	GUICtrlSetCursor(-1, 0)
	$gTwitterIcon = GUICtrlCreateIcon($iconsIcl,13, 380, 370, 32, 32)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip($gTwitterIcon, " ", "sDoddler's Twitter Page")
	$gYoutubeIcon = GUICtrlCreateIcon($iconsIcl,14, 420, 370, 32, 32)
	GUICtrlSetTip($gYoutubeIcon, " ", "sDoddler's YouTube Channel")
	GUICtrlSetCursor(-1, 0)
	$gGithubIcon = GUICtrlCreateIcon($iconsIcl,11, 460, 370, 32, 32)
	GUICtrlSetTip($gGithubIcon, " ", "D&D Loot Generator Github Page")
	GUICtrlSetCursor(-1, 0)
	#EndRegion Icons\Small Form Factor Button

	GUISetState()
EndFunc   ;==>FullSizeGui

Func SavePreferences() ;; Saves Global Vars to Preferences.ini in AppData
	IniWrite($prefIni, "Settings", "Small Form Factor", $smallFormFactor)

	IniWrite($prefIni, "Settings", "Debug Mode", $debugMode)
	IniWrite($prefIni, "Settings", "Sub Windows Read Only", $subWindowRO)
	IniWrite($prefIni, "Settings", "View Dice Rolls", $viewDiceRolls)

	IniWrite($prefIni, "Settings", "Challenge Level", $treasureChallengeLevel)
	IniWrite($prefIni, "Settings", "Treasure Type", $treasureType)
	IniWrite($prefIni, "Settings", "Take Default Dice Rolls", $treasureTakeDefault)
	IniWrite($prefIni, "Settings", "Convert Gems\Art to Coins", $treasureConvertGems)

	IniWrite($prefIni, "Settings", "Include Weapons", $miscWeapons)
	IniWrite($prefIni, "Settings", "Include Adv Gear", $miscAdvGear)
	IniWrite($prefIni, "Settings", "Include Mounts", $miscMounts)
	IniWrite($prefIni, "Settings", "Include Tools", $miscTools)
	IniWrite($prefIni, "Settings", "Include Armour", $miscArmour)

	IniWrite($prefIni, "Settings", "Max Value", $miscMax)
	IniWrite($prefIni, "Settings", "Misc Dice Rolls", $miscAmount)
	IniWrite($prefIni, "Settings", "Max Dice", $miscDice)

	IniWrite($prefIni, "Settings", "Include Creator", $magicCreator)
	IniWrite($prefIni, "Settings", "Include History", $magicHistory)
	IniWrite($prefIni, "Settings", "Include Minor Property(s)", $magicMinor)
	IniWrite($prefIni, "Settings", "Include Quirks", $magicQuirks)

	IniWrite($prefIni, "Settings", "Dice Rolls", $diceAmount)
	IniWrite($prefIni, "Settings", "Dice Type", $diceType)
EndFunc   ;==>SavePreferences

Func BoolCheck($Bool) ;; Switches String True\False to Bool True\False (for IniRead)
	If $Bool = "True" Then
		$Bool = True
	ElseIf $Bool = "False" Then
		$Bool = False
	EndIf
	Return $Bool
EndFunc   ;==>BoolCheck

Func ViewTreasureTables()
	If WinExists("D&D - Treasure Tables") Then
		WinActivate("D&D - Treasure Tables")
		Return 0
	EndIf

	$rSec = IniReadSectionNames($appDir & "Loot Generator Resources\Treasure-" & "Hoards" & ".txt")
;~ 	ConsoleWrite($rSec&@LF)

	Global $vTreasureHoards[$rSec[0] + 1][2]
	$vDefault = "Hoard - " & $rSec[1]

	For $i = 1 To $rSec[0]
		If Not ($i = 1) Then $vTreasureHoards[0][0] &= "|"
		$vTreasureHoards[0][0] &= "Hoard - " & $rSec[$i]
		$vTreasureHoards[$i][0] = "Hoard - " & $rSec[$i]
		$vTreasureHoards[$i][1] = IniReadSection($appDir & "Loot Generator Resources\Treasure-" & "Hoards" & ".txt", $rSec[$i])
	Next

	$rSec = IniReadSectionNames($appDir & "Loot Generator Resources\Treasure-" & "Individual" & ".txt")

	Global $vTreasureIndiv[$rSec[0] + 1][2]

	For $i = 1 To $rSec[0]
		$vTreasureIndiv[0][0] &= "|"
		$vTreasureIndiv[0][0] &= "Indivdual - " & $rSec[$i]
		$vTreasureIndiv[$i][0] = "Indivdual - " & $rSec[$i]
		$vTreasureIndiv[$i][1] = IniReadSection($appDir & "Loot Generator Resources\Treasure-" & "Individual" & ".txt", $rSec[$i])
	Next

;~ 	_ArrayDisplay($vTreasureHoards[1][1])
;~ 	_ArrayDisplay($vTreasureIndiv[1][1])

	ConsoleWrite($vTreasureHoards[0][0] & $vTreasureIndiv[0][0] & @LF)

	$hTreasureTables = GUICreate("D&D - Treasure Tables", 400, 400, -1, -1, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX)

	Global $vCoTreasureHeaders = GUICtrlCreateCombo("", 10, 10, -1, -1, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, $vTreasureHoards[0][0] & $vTreasureIndiv[0][0], $vDefault)

	GUICtrlCreateLabel("Coins:", 10, 40)
	Global $vCoins = GUICtrlCreateLabel("", 60, 40, 200, 60)


	Global $vListview = GUICtrlCreateListView("", 10, 100, 380, 270)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT)
	_GUICtrlListView_AddColumn($vListview, "Roll")
	_GUICtrlListView_AddColumn($vListview, "Reward 1", 100)
	_GUICtrlListView_AddColumn($vListview, "Reward 2", 100)
	_GUICtrlListView_AddColumn($vListview, "Reward 3", 100)

	TreasureTableGenerate()

	GUISetState()
EndFunc   ;==>ViewTreasureTables

Func CoinSplit($CoinValue, $Coins = True)
	$tempArray = $CoinValue
	If $Coins Then $quickSplit = StringSplit($tempArray[1][1], "++", 1)
	If Not ($Coins) Then $quickSplit = StringSplit($tempArray, "++", 1)
	$tempString = ""
	For $i = 1 To $quickSplit[0]
		$tempSplit = StringSplit($quickSplit[$i], "\\", 1)
		If UBound($tempSplit) > 2 Then $tempString &= $tempSplit[1] & " x " & $tempSplit[2] & " " & $tempSplit[4] & " (Default: " & $tempSplit[3] & ")" & @LF
	Next
	Return $tempString
EndFunc   ;==>CoinSplit

Func TreasureTableGenerate($vTable = "Hoard - Challenge 0-4")
	_GUICtrlListView_DeleteAllItems($vListview)
	$vListCount = 0

	If StringInStr($vTable, "Hoard") Then

		For $i = 1 To UBound($vTreasureHoards) - 1
			If $vTreasureHoards[$i][0] = $vTable Then

				$vTempArray = $vTreasureHoards[$i][1]
				$vData = CoinSplit($vTreasureHoards[$i][1])
				GUICtrlSetData($vCoins, $vData)
				For $j = 3 To UBound($vTempArray) - 1
					_GUICtrlListView_AddItem($vListview, $vTempArray[$j][0])

					$vSplit = StringSplit(CoinSplit($vTempArray[$j][1], False), @LF, 1)
					For $v = 1 To $vSplit[0]
						_GUICtrlListView_AddSubItem($vListview, $vListCount, $vSplit[$v], $v)
					Next
					$vListCount += 1
				Next
			EndIf
		Next
	Else
		For $i = 1 To UBound($vTreasureIndiv) - 1
			If $vTreasureIndiv[$i][0] = $vTable Then

				$vTempArray = $vTreasureIndiv[$i][1]
				GUICtrlSetData($vCoins, "")
				For $j = 2 To UBound($vTempArray) - 1
					_GUICtrlListView_AddItem($vListview, $vTempArray[$j][0])

					$vSplit = StringSplit(CoinSplit($vTempArray[$j][1], False), @LF, 1)
					For $v = 1 To $vSplit[0]
						_GUICtrlListView_AddSubItem($vListview, $vListCount, $vSplit[$v], $v)
					Next
					$vListCount += 1
				Next
			EndIf
		Next
	EndIf
EndFunc   ;==>TreasureTableGenerate
