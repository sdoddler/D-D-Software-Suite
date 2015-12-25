#include-once
#include <Array.au3>
#include "DiceRoll.au3"
#include "CurrencyConverter.au3"
#include <File.au3>

;---------
;; Need to define these parts in the main Script
; So that individual Options can be selected (weapons etc).
;--------

;~ $appDir = EnvGet("APPDATA") & "\DnD Loot\"
;~ DirCreate($appDir)

;~ $weapIni = $appDir & "Weapons.txt"
;~ $AdvGearIni = $appDir & "Adventuring Gear.txt"
;~ $ArmourIni = $appDir & "Armour.txt"
;~ $mountIni = $appDir & "Mounts.txt"
;~ $toolIni = $appDir & "Tools.txt"

;~ FileInstall("C:\Work\Projects\Scripts\DND\ItemSort\Weapons.txt", $weapIni, 1)
;~ FileInstall("C:\Work\Projects\Scripts\DND\ItemSort\Adventuring Gear.txt", $AdvGearIni, 1)
;~ FileInstall("C:\Work\Projects\Scripts\DND\ItemSort\Armour.txt", $ArmourIni, 1)
;~ FileInstall("C:\Work\Projects\Scripts\DND\ItemSort\Mounts.txt", $mountIni, 1)
;~ FileInstall("C:\Work\Projects\Scripts\DND\ItemSort\Tools.txt", $toolIni, 1)



;~ $CC = CurrencyConverter("1SP")
;~ _ArrayDisplay($cc)
;_ArrayDisplay(_SearchItems($txtArray,True, $cc[0]))


;_ArrayDisplay(ItemRoll("d12",2,"","1 GP")); Testing


Func ItemRoll($dice, $rolls, $iFiles = "", $maxPrice = "", $debug = 0)

	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"

	$weapIni = $appDir & "Weapons.txt"
	$AdvGearIni = $appDir & "Adventuring Gear.txt"
	$ArmourIni = $appDir & "Armour.txt"
	$mountIni = $appDir & "Mounts.txt"
	$toolIni = $appDir & "Tools.txt"

	If $iFiles = "" Then
		Dim $txtArray[5] = [$weapIni, $AdvGearIni, $ArmourIni, $mountIni, $toolIni]
	Else
		$txtArray = $iFiles
	EndIf

	$diceRoll = DiceRoll($dice, $rolls, $debug)
	If $maxPrice <> "" Then
		$CC = CurrencyConverter($maxPrice)

		$searchItems = _SearchItems($txtArray, True, $CC[0],$debug)
	Else
		$searchItems = _SearchItems($txtArray,False,0,$debug)
	EndIf
	if $debug Then ConsoleWrite("Selecting Misc Items x" & $diceRoll[UBound($diceRoll) - 1] & " to the value of " & $maxPrice & @LF)
	Dim $returnItems[$diceRoll[UBound($diceRoll) - 1] + 1][9]
	$returnItems[0][0] = $diceRoll[UBound($diceRoll) - 1] ;Amount of Items
	$returnItems[0][1] = $rolls & $dice ;Dice Rolled to get Items

	$returnItems[0][2] = $diceRoll[0] ;Individual Dice Rolls
	For $i = 1 To UBound($diceRoll) - 2
		$returnItems[0][2] &= " - " & $diceRoll[$i]
	Next

	For $i = 0 To UBound($txtArray) - 1
		$iType = StringSplit($txtArray[$i], "\")
		If $i = 0 Then
			$returnItems[0][3] = StringReplace($iType[UBound($iType) - 1], ".txt", "")
		Else
			$returnItems[0][3] &= ", " & StringReplace($iType[UBound($iType) - 1], ".txt", "")
		EndIf
	Next

	$returnItems[0][4] = $maxPrice

	$iCount = 1
	For $i = 1 To $diceRoll[UBound($diceRoll) - 1]
		$rand = Random(1, $searchItems[0][0], 1)
		$qCheck = 0
		$qCheck = _QuickCheck($returnItems, $searchItems[$rand][0])
		If $qCheck <> 0 Then
			$returnItems[$qCheck][0] += 1
		Else
			For $j = 0 To 7
				$returnItems[$iCount][$j + 1] = $searchItems[$rand][$j]
			Next
			$returnItems[$iCount][0] = 1
			$iCount += 1
		EndIf
	Next
	ReDim $returnItems[$iCount][9]

	Return $returnItems
EndFunc   ;==>ItemRoll

Func _SearchItems($iFiles = "", $iSearch = False, $search = 0,$debug = 0)


	Local $listCount = 0, $iType = "Weapons", $lineCount



	#CS Columns
		[0] Item Name	[1]Cost		[2]Damage	[3]Weight	[4]Speed	[5]Carry Capacity	[6]Properties
	#CE



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


				Switch $iType
					Case "Weapons"
						If $secT[$j][0] <> "Unarmed Strike" Then
							$iSplit = StringSplit($secT[$j][1], "\\", 1)
							;_ArrayDisplay($iSplit)
							$cost = CurrencyConverter($iSplit[1])
							If (($iSearch = False) Or ($iSearch = True And $search >= $cost[0])) Then
								$listCount += 1
								$itArray[$listCount][0] = $secT[$j][0]
								$itArray[$listCount][1] = $iSplit[1]
								$itArray[$listCount][2] = $iSplit[2]
								$itArray[$listCount][3] = $iSplit[3]
								$itArray[$listCount][4] = "-"
								$itArray[$listCount][5] = "-"
								$itArray[$listCount][6] = $iSplit[4]
								$itArray[$listCount][7] = $iType
							EndIf
						EndIf
					Case "Adventuring Gear"
						$iSplit = StringSplit($secT[$j][1], "\\", 1)
						$cost = CurrencyConverter($iSplit[1])
						If (($iSearch = False) Or ($iSearch = True And $search >= $cost[0])) Then
							$listCount += 1
							$itArray[$listCount][0] = $secT[$j][0]
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[2]
							$itArray[$listCount][4] = "-"
							$itArray[$listCount][5] = "-"
							$itArray[$listCount][6] = "-"
							$itArray[$listCount][7] = $iType
						EndIf
					Case "Armour"
						$iSplit = StringSplit($secT[$j][1], "\\", 1)
						$cost = CurrencyConverter($iSplit[1])
						If (($iSearch = False) Or ($iSearch = True And $search >= $cost[0])) Then
							$listCount += 1
							$itArray[$listCount][0] = $secT[$j][0]
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[5]
							$itArray[$listCount][4] = "-"
							$itArray[$listCount][5] = "-"
							$itArray[$listCount][6] = "AC: " & $iSplit[2] & ", Str:" & $iSplit[3] & ", Stealth: " & $iSplit[4]
							$itArray[$listCount][7] = $iType
						EndIf
					Case "Mounts" ; Cost Speed Weight Carry Capactiy
						$iSplit = StringSplit($secT[$j][1], "\\", 1)
						$cost = CurrencyConverter($iSplit[1])
						If (($iSearch = False) Or ($iSearch = True And $search >= $cost[0])) Then
							$listCount += 1
							$itArray[$listCount][0] = $secT[$j][0]
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[3]
							$itArray[$listCount][4] = $iSplit[2]
							$itArray[$listCount][5] = $iSplit[4]
							$itArray[$listCount][6] = "-"
							$itArray[$listCount][7] = $iType
						EndIf
					Case "Tools" ; Cost Weight
						$iSplit = StringSplit($secT[$j][1], "\\", 1)
						$cost = CurrencyConverter($iSplit[1])
						If (($iSearch = False) Or ($iSearch = True And $search >= $cost[0])) Then
							$listCount += 1
							$itArray[$listCount][0] = $secT[$j][0]
							$itArray[$listCount][1] = $iSplit[1]
							$itArray[$listCount][2] = "-"
							$itArray[$listCount][3] = $iSplit[2]
							$itArray[$listCount][4] = "-"
							$itArray[$listCount][5] = "-"
							$itArray[$listCount][6] = "-"
							$itArray[$listCount][7] = $iType
						EndIf
				EndSwitch
			Next
		Next
	Next
	if $debug Then ConsoleWrite("ListCount = " & $listCount & @LF)
	;_ArrayDisplay($itArray)
	$itArray[0][0] = $listCount
	ReDim $itArray[$listCount + 1][9]
	Return $itArray

EndFunc   ;==>_SearchItems

Func _QuickCheck($array, $itemName)
	Local $ret = 0
	For $i = 1 To $array[0][0]
		If $array[$i][1] = $itemName Then
			$ret = $i
			Return $ret
		EndIf
	Next
	Return $ret
EndFunc   ;==>_QuickCheck
