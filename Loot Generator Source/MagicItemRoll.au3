#include-once
#include <Array.au3>
#include <IniEx.au3>
#include "DiceRoll.au3"

;~ _ArrayDisplay(MagicItemRoll("MAGIC ITEM TABLE I", 10))

Func MagicItemRoll($table, $amount = 1, $debug = 0, $dice = "")
	$iCount = 1
	$skip = False

	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\Loot Generator Resources\"

	$section = IniReadSection($appdir & $table & ".txt", "d100")
	if $debug Then ConsoleWrite("Selecting Magic Item(s) x" & $amount & " - From " & $table & "..." & @LF)
	Dim $diceRoll = DiceRoll("d100", $amount, $debug);[76, 76, 76, 13, 13];

	If $dice = "1d100" Then
		$dice = "1d1 (Roll Once on Table)"
	EndIf


	If $amount > 1 Then
		Dim $magicItems[$section[0][0] + 1][3]
		$magicItems[0][1] = $table
		$magicItems[0][0] = $amount
		$magicItems[0][2] = $dice
		For $i = 0 To UBound($diceRoll) - 2
			For $a = 0 To $section[0][0]
				If StringInStr($section[$a][0], "-") > 0 Then
					$split = StringSplit($section[$a][0], "-")
					If $diceRoll[$i] >= $split[1] And $diceRoll[$i] <= $split[2] Then
						$temp = $section[$a][1]
						ExitLoop
					EndIf

				Else
					If $diceRoll[$i] = $section[$a][0] Then
						$temp = $section[$a][1]
						ExitLoop
					EndIf
				EndIf
			Next
			If StringInStr($temp, "Magic Armor") > 0 Or StringInStr($temp, "Figurine of Wondrous Power") > 0 Then
				$tempSub = SubMagicRoll($temp)
				;	ConsoleWrite("$temp = " & $temp & @LF & $tempSub[0] & @LF)
			EndIf
			For $j = 0 To UBound($magicItems) - 1
				$skip = False
				If $temp = $magicItems[$j][1] Then
					$magicItems[$j][0] += 1
					$magicItems[$j][2] &= " - " & $diceRoll[$i]

					If $debug Then ConsoleWrite(@TAB & "Individual Dice Roll Debug(Magic Item):" & @LF _
							 & @TAB & @TAB & "----Dice Roll = " & $diceRoll[$i] & @LF _
							 & @TAB & @TAB & "----Magic Item Chosen = " & $magicItems[$j][1] & @LF _
							 & @TAB & @TAB & "----Total of Item so Far = " & $magicItems[$j][0] & @LF)
					$skip = True
					ExitLoop

				EndIf
				If StringInStr($temp, "Magic Armor") > 0 Or StringInStr($temp, "Figurine of Wondrous Power") > 0 Then

					If $tempSub[0] = $magicItems[$j][1] Then
						;ConsoleWrite("TempSub = " & $tempSub[0] & @LF & "$magicItems[$j][1] = " & $magicItems[$j][1] & @LF)
						$magicItems[$j][0] += 1
						$magicItems[$j][2] &= " - " & $diceRoll[$i] & " - " & $tempSub[1]
						If $debug Then ConsoleWrite(@TAB & "Individual Dice Roll Debug(Magic Item):" & @LF _
								 & @TAB & @TAB & "----Dice Roll = " & $diceRoll[$i] & @LF _
								 & @TAB & @TAB & "----Magic Item Chosen = " & $magicItems[$j][1] & @LF _
								 & @TAB & @TAB & "----Total of Item so Far = " & $magicItems[$j][0] & @LF)
						$skip = True
						ExitLoop
					EndIf
				EndIf
			Next
			If Not ($skip) Then
				For $a = 0 To $section[0][0]
					If StringInStr($section[$a][0], "-") > 0 Then
						$split = StringSplit($section[$a][0], "-")
						If $diceRoll[$i] >= $split[1] And $diceRoll[$i] <= $split[2] Then
							$magicItems[$iCount][1] = $section[$a][1]
							$magicItems[$iCount][2] = $diceRoll[$i]
							If StringInStr($magicItems[$iCount][1], "Magic Armor") > 0 Or StringInStr($magicItems[$iCount][1], "Figurine of Wondrous Power") > 0 Then
								$magicItems[$iCount][1] = $tempSub[0]
								$magicItems[$iCount][2] &= " - " & $tempSub[1]
							EndIf
							If StringInStr($magicItems[$iCount][1], "Spell Scroll") > 0 Then
								$magicItems[$iCount][1] = ScrollRoll($magicItems[$iCount][1])
							EndIf
						EndIf

					Else
						If $diceRoll[$i] = $section[$a][0] Then
							$magicItems[$iCount][1] = $section[$a][1]
							$magicItems[$iCount][2] = $diceRoll[$i]
							If StringInStr($magicItems[$iCount][1], "Magic Armor") > 0 Or StringInStr($magicItems[$iCount][1], "Figurine of Wondrous Power") > 0 Then
								$magicItems[$iCount][1] = $tempSub[0]
								$magicItems[$iCount][2] &= " - " & $tempSub[1]
							EndIf
							If StringInStr($magicItems[$iCount][1], "Spell Scroll") > 0 Then
								$magicItems[$iCount][1] = ScrollRoll($magicItems[$iCount][1])
							EndIf
						EndIf
					EndIf
				Next
				;$magicItems[$iCount][1] = $section[$diceRoll[$i]][1]
				$magicItems[$iCount][0] += 1
				If $debug Then ConsoleWrite(@TAB & "Individual Dice Roll Debug(Magic Item):" & @LF _
						 & @TAB & @TAB & "----Dice Roll = " & $diceRoll[$i] & @LF _
						 & @TAB & @TAB & "----Magic Item Chosen = " & $magicItems[$iCount][1] & @LF & @LF)
				$iCount += 1
			EndIf
		Next
		ReDim $magicItems[$iCount][3]
		Return $magicItems
	Else
		Dim $magicItems[2][3]
		$magicItems[0][1] = $table
		$magicItems[0][0] = $amount
		$magicItems[0][2] = $dice


		$magicItems[1][0] = 1

		For $i = 1 To $section[0][0]
			If StringInStr($section[$i][0], "-") > 0 Then
				$split = StringSplit($section[$i][0], "-")
				If $diceRoll[0] >= $split[1] And $diceRoll[0] <= $split[2] Then
					$magicItems[1][1] = $section[$i][1]
					$magicItems[1][2] = $diceRoll[0]
					If StringInStr($magicItems[1][1], "Magic Armour") > 0 Or StringInStr($magicItems[1][1], "Figurine of Wondrous Power") > 0 Then
						$tempSub = SubMagicRoll($magicItems[1][1])
						$magicItems[1][1] = $tempSub[0]
						$magicItems[1][2] &= " - " & $tempSub[1]

					EndIf
					If StringInStr($magicItems[1][1], "Spell Scroll") > 0 Then
						$magicItems[1][1] = ScrollRoll($magicItems[1][1])
					EndIf
				EndIf
			Else
				If $diceRoll[0] = $section[$i][0] Then
					$magicItems[1][1] = $section[$i][1]
					$magicItems[1][2] = $diceRoll[0]
					If StringInStr($magicItems[0][1], "Magic Armor") > 0 Or StringInStr($magicItems[0][1], "Figurine of wondrous power") > 0 Then
						$tempSub = SubMagicRoll($magicItems[1][1])
						$magicItems[1][1] = $tempSub[0]
						$magicItems[1][2] &= " - " & $tempSub[1]
					EndIf
					If StringInStr($magicItems[1][1], "Spell Scroll") > 0 Then
						$magicItems[1][1] = ScrollRoll($magicItems[1][1])
					EndIf
				EndIf
			EndIf

		Next


		Return $magicItems
	EndIf

EndFunc   ;==>MagicItemRoll


Func MinorPropertyRoll($debug = 0)
	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"

	$section = IniReadSection($appDir & "Magic Item Minor Property.txt", "d20")
	ConsoleWrite("Selecting MinorProperty(s)..." & @LF)
	Dim $diceRoll = DiceRoll("d20", 1, $debug)

	If $diceRoll[0] < 20 Then
		Dim $retMinorPropertys[1][3]
		$int = StringInStr($section[$diceRoll[0]][1], ".")
		$retMinorPropertys[0][0] = StringLeft($section[$diceRoll[0]][1], $int)
		$retMinorPropertys[0][1] = StringRight($section[$diceRoll[0]][1], StringLen($section[$diceRoll[0]][1]) - $int - 1)
		$retMinorPropertys[0][2] = $diceRoll[0]

		Return $retMinorPropertys
	Else
		Dim $retMinorPropertys[2][3]
		While $diceRoll[0] = 20
			$diceRoll = DiceRoll("d20", 1, $debug)
		WEnd
		$int = StringInStr($section[$diceRoll[0]][1], ".")
		$retMinorPropertys[0][0] = StringLeft($section[$diceRoll[0]][1], $int)
		$retMinorPropertys[0][1] = StringRight($section[$diceRoll[0]][1], StringLen($section[$diceRoll[0]][1]) - $int - 1)
		$retMinorPropertys[0][2] = $diceRoll[0]
		$diceRoll = DiceRoll("d20", 1, $debug)
		While $diceRoll[0] = 20
			$diceRoll = DiceRoll("d20", 1, $debug)

		WEnd
		$int = StringInStr($section[$diceRoll[0]][1], ".")
		$retMinorPropertys[1][0] = StringLeft($section[$diceRoll[0]][1], $int)
		$retMinorPropertys[1][1] = StringRight($section[$diceRoll[0]][1], StringLen($section[$diceRoll[0]][1]) - $int - 1)
		$retMinorPropertys[1][2] = $diceRoll[0]
		Return $retMinorPropertys
	EndIf


EndFunc   ;==>MinorPropertyRoll

Func HistoryAndQuirksRoll($history = True, $quirks = True, $creator = True, $debug = 0)
	Local $histCount = 0

	Local $array[3][4], $appDir = EnvGet("APPDATA") & "\Doddler's D&D\"

	If $history Then
		$histSect = IniReadSection($appDir & "Magic Item History.txt", "d8")
		$diceRoll = DiceRoll("d8", 1, $debug)
		$int = StringInStr($histSect[$diceRoll[0]][1], ".")
		$array[$histCount][0] = StringLeft($histSect[$diceRoll[0]][1], $int)
		$array[$histCount][1] = StringRight($histSect[$diceRoll[0]][1], StringLen($histSect[$diceRoll[0]][1]) - $int - 1)
		$array[$histCount][2] = $diceRoll[0]
		$array[$histCount][3] = "History"
		$histCount += 1
	EndIf
	If $quirks Then
		$quirkSect = IniReadSection($appDir & "Magic Item Quirks.txt", "d12")
		$diceRoll = DiceRoll("d12", 1, $debug)
		$int = StringInStr($quirkSect[$diceRoll[0]][1], ".")
		$array[$histCount][0] = StringLeft($quirkSect[$diceRoll[0]][1], $int)
		$array[$histCount][1] = StringRight($quirkSect[$diceRoll[0]][1], StringLen($quirkSect[$diceRoll[0]][1]) - $int - 1)
		$array[$histCount][2] = $diceRoll[0]
		$array[$histCount][3] = "Quirk"
		$histCount += 1
	EndIf
	If $creator Then
		$creaSect = IniReadSection($appDir & "Magic Item Who Created it.txt", "d20")
		$diceRoll = DiceRoll("d20", 1, $debug)
		For $i = 1 To $creaSect[0][0]
			If StringInStr($creaSect[$i][0], "-") Then
				$split = StringSplit($creaSect[$i][0], "-")
				If $diceRoll[0] >= $split[1] And $diceRoll[0] <= $split[2] Then
					$int = StringInStr($creaSect[$i][1], ".")
					$array[$histCount][0] = StringLeft($creaSect[$i][1], $int)
					$array[$histCount][1] = StringRight($creaSect[$i][1], StringLen($creaSect[$i][1]) - $int - 1)
					$array[$histCount][2] = $diceRoll[0]
					$array[$histCount][3] = "Creator"
					$histCount += 1
					ExitLoop
				EndIf

			Else
				If $diceRoll[0] = $creaSect[$i][0] Then
					$int = StringInStr($creaSect[$i][1], ".")
					$array[$histCount][0] = StringLeft($creaSect[$i][1], $int)
					$array[$histCount][1] = StringRight($creaSect[$i][1], StringLen($creaSect[$i][1]) - $int - 1)
					$array[$histCount][2] = $diceRoll[0]
					$array[$histCount][3] = "Creator"
					$histCount += 1
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	ReDim $array[$histCount][4]

	Return $array
EndFunc   ;==>HistoryAndQuirksRoll

Func SubMagicRoll($initialString)
	$subSplit = StringSplit($initialString, "\\", 1)
	$splitAgain = StringSplit($subSplit[1], " (roll ", 1)
	$splitAgain[2] = StringReplace($splitAgain[2], ")", "")

	$quickRoll = SplitAndRoll($splitAgain[2])
	Dim $subMagicItems[$subSplit[0] - 1][2]
	For $i = 2 To $subSplit[0]

		$equalSplit = StringSplit($subSplit[$i], "=")
		$subMagicItems[$i - 2][0] = $equalSplit[1]
		$subMagicItems[$i - 2][1] = $equalSplit[2]
	Next

	Dim $subArray[2]
	For $i = 0 To UBound($subMagicItems) - 1
		If StringInStr($subMagicItems[$i][0], "-") > 0 Then
			$split = StringSplit($subMagicItems[$i][0], "-")
			If $quickRoll[0] >= $split[1] And $quickRoll[0] <= $split[2] Then
				$subArray[0] = $splitAgain[1] & ": " & $subMagicItems[$i][1]
				$subArray[1] = $quickRoll[0]
				Return $subArray
				;$magicItems[0][1] = $submagicItems[$i][1]
			EndIf
		Else
			If $quickRoll[0] = $subMagicItems[$i][0] Then
				$subArray[0] = $splitAgain[1] & ": " & $subMagicItems[$i][1]
				$subArray[1] = $quickRoll[0]
				Return $subArray
				;$magicItems[0][1] = $submagicItems[$i][1]
			EndIf
		EndIf

	Next
EndFunc   ;==>SubMagicRoll

Func ScrollRoll($strScroll)
	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"

	Local $rIni = $appDir & "Spell Levels.txt"
	Local $bracket = StringInStr($strScroll, "("), $rSec = IniReadSectionNames($rIni);,$spCount = 0

	If StringInStr($strScroll, "Cantrip") = 0 Then
		Local $level = StringMid($strScroll, $bracket + 1, 3)
	Else
		Local $level = "Cantrip"
	EndIf
	For $i = 1 To $rSec[0]


		If $level = $rSec[$i] Then

			$secArray = IniReadSection($rIni, $rSec[$i])
			$rand = Random(1, $secArray[0][0], 1)
			$spell = $secArray[$rand][1]
			Return $strScroll & " - Random Spell: " & $spell
		EndIf
	Next
EndFunc   ;==>ScrollRoll
