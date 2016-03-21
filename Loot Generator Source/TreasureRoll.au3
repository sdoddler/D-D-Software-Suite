#include-once
#include <Array.au3>
#include "DiceRoll.au3"
#include "ArtRoll.au3"
#include "GemRoll.au3"
#include "MagicItemRoll.au3"

Func TreasureRoll($iChallenge, $takeDefault = False, $treasureType = "Individual", $debug = 0)

	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\Loot Generator Resources\"

	$section = IniReadSection($appDir & "Treasure-" & $treasureType & ".txt", $iChallenge)
	Local $art = "", $gems = "", $magicItems = "", $magicItems2, $rawCoin = 0

	If $treasureType = "Individual" Then
		$start = 2
		if $debug Then ConsoleWrite("Selecting Treasure..." & @LF)
		$diceRoll = DiceRoll($section[1][1], 1, $debug)
	Else
		$start = 3
		if $debug Then ConsoleWrite("Selecting Treasure..." & @LF)
		$diceRoll = DiceRoll($section[2][1], 1, $debug)
	EndIf

	For $i = $start To $section[0][0]
		If StringInStr($section[$i][0], "-") > 0 Then
			$split = StringSplit($section[$i][0], "-")
			If $diceRoll[0] >= $split[1] And $diceRoll[0] <= $split[2] Then
				$rawTreasure = $section[$i][1]
				$rawDice = $diceRoll[0]
			EndIf
		Else
			If $diceRoll[0] = $section[$i][0] Then
				$rawTreasure = $section[$i][1]
				$rawDice = $diceRoll[0]
			EndIf
		EndIf

	Next
;~ 	If $rawTreasure = "YOU GET NOTHING" Then
;~ 		MsgBox(48, "Oh no!", "YOU GET NOTHING!" & @LF & "NOTHIIIINNNNGGG" & @LF & "(only coins)")
;~ 	EndIf

	$splitTreasure = StringSplit($rawTreasure, "++", 1)
	;PP		|1200	|100		|5d6	|12		|
	;Coin	Amount	Multiplier	Dice	Result	Individual Rolls

	Dim $coins[5][6] = [["CP", 0, "", "", "",""], ["SP", 0, "", "", "",""], ["EP", 0, "", "", "",""], ["GP", 0, "", "", "",""], ["PP", 0, "", "", "",""]]

	If $treasureType = "Individual" Then

		For $i = 1 To $splitTreasure[0]
			$splitIndiv = StringSplit($splitTreasure[$i], "\\", 1)
			If $takeDefault Then
				Switch $splitIndiv[4]
					Case "CP"
						$coins[0][1] += $splitIndiv[3]
						$coins[0][2] = $splitIndiv[2]
						$coins[0][3] = $splitIndiv[1]
						$coins[0][4] = $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "SP"
						$coins[1][1] += $splitIndiv[3]
						$coins[1][2] = $splitIndiv[2]
						$coins[1][3] = $splitIndiv[1]
						$coins[1][4] = $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "EP"
						$coins[2][1] += $splitIndiv[3]
						$coins[2][2] = $splitIndiv[2]
						$coins[2][3] = $splitIndiv[1]
						$coins[2][4] = $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "GP"
						$coins[3][1] += $splitIndiv[3]
						$coins[3][2] = $splitIndiv[2]
						$coins[3][3] = $splitIndiv[1]
						$coins[3][4] = $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "PP"
						$coins[4][1] += $splitIndiv[3]
						$coins[4][2] = $splitIndiv[2]
						$coins[4][3] = $splitIndiv[1]
						$coins[4][4] = $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
				EndSwitch
			Else
				if $debug Then ConsoleWrite("Selecting " & $splitIndiv[4] & "..." & @LF)
				$diceRoll = SplitAndRoll($splitIndiv[1], $debug)
				Switch $splitIndiv[4]
					Case "CP"
						$coins[0][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[0][2] = $splitIndiv[2]
						$coins[0][3] = $splitIndiv[1]
						$coins[0][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[0][5] = $diceRoll[$j]
							Else
								$coins[0][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "SP"
						$coins[1][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[1][2] = $splitIndiv[2]
						$coins[1][3] = $splitIndiv[1]
						$coins[1][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[1][5] = $diceRoll[$j]
							Else
								$coins[1][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "EP"
						$coins[2][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[2][2] = $splitIndiv[2]
						$coins[2][3] = $splitIndiv[1]
						$coins[2][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[2][5] = $diceRoll[$j]
							Else
								$coins[2][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "GP"
						$coins[3][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[3][2] = $splitIndiv[2]
						$coins[3][3] = $splitIndiv[1]
						$coins[3][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[3][5] = $diceRoll[$j]
							Else
								$coins[3][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "PP"
						$coins[4][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[4][2] = $splitIndiv[2]
						$coins[4][3] = $splitIndiv[1]
						$coins[4][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[4][5] = $diceRoll[$j]
							Else
								$coins[4][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
				EndSwitch
			EndIf
		Next

	Else
		$quickSplit = StringSplit($section[1][1], "++", 1)
		$rawCoin = $section[1][1]
		For $i = 1 To $quickSplit[0]
			$splitIndiv = StringSplit($quickSplit[$i], "\\", 1)
			If $takeDefault Then
				Switch $splitIndiv[4]
					Case "CP"
						$coins[0][1] += $splitIndiv[3]
						$coins[0][2] = $splitIndiv[2]
						$coins[0][3] = $splitIndiv[1]
						$coins[0][4] += $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "SP"
						$coins[1][1] += $splitIndiv[3]
						$coins[1][2] = $splitIndiv[2]
						$coins[1][3] = $splitIndiv[1]
						$coins[1][4] += $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "EP"
						$coins[2][1] += $splitIndiv[3]
						$coins[2][2] = $splitIndiv[2]
						$coins[2][3] = $splitIndiv[1]
						$coins[2][4] += $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "GP"
						$coins[3][1] += $splitIndiv[3]
						$coins[3][2] = $splitIndiv[2]
						$coins[3][3] = $splitIndiv[1]
						$coins[3][4] += $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
					Case "PP"
						$coins[4][1] += $splitIndiv[3]
						$coins[4][2] = $splitIndiv[2]
						$coins[4][3] = $splitIndiv[1]
						$coins[4][4] += $splitIndiv[3]/$splitIndiv[2]
						ContinueLoop
				EndSwitch
			Else
				if $debug Then ConsoleWrite("Selecting " & $splitIndiv[4] & "..." & @LF)
				$diceRoll = SplitAndRoll($splitIndiv[1], $debug)
				Switch $splitIndiv[4]
					Case "CP"
						$coins[0][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[0][2] = $splitIndiv[2]
						$coins[0][3] = $splitIndiv[1]
						$coins[0][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[0][5] = $diceRoll[$j]
							Else
								$coins[0][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "SP"
						$coins[1][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[1][2] = $splitIndiv[2]
						$coins[1][3] = $splitIndiv[1]
						$coins[1][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[1][5] = $diceRoll[$j]
							Else
								$coins[1][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "EP"
						$coins[2][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[2][2] = $splitIndiv[2]
						$coins[2][3] = $splitIndiv[1]
						$coins[2][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[2][5] = $diceRoll[$j]
							Else
								$coins[2][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "GP"
						$coins[3][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[3][2] = $splitIndiv[2]
						$coins[3][3] = $splitIndiv[1]
						$coins[3][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[3][5] = $diceRoll[$j]
							Else
								$coins[3][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
					Case "PP"
						$coins[4][1] += $diceRoll[UBound($diceRoll) - 1] * $splitIndiv[2]
						$coins[4][2] = $splitIndiv[2]
						$coins[4][3] = $splitIndiv[1]
						$coins[4][4] = $diceRoll[UBound($diceRoll) - 1]
						For $j = 0 to UBound($diceRoll)-2
							if $j = 0 Then
								$coins[4][5] = $diceRoll[$j]
							Else
								$coins[4][5] &= " - " & $diceRoll[$j]
							EndIf
						Next
						ContinueLoop
				EndSwitch
			EndIf
		Next

		For $i = 1 To $splitTreasure[0]
			If StringInStr($splitTreasure[$i], "\\") Then
				$splitIndiv = StringSplit($splitTreasure[$i], "\\", 1)
				If StringInStr($splitIndiv[4], "GEMS") > 0 Then

					$gValue = StringLeft($splitIndiv[4], StringLen($splitIndiv[4]) - 5)
					If $takeDefault Then
						$gems = GemRoll($gValue, 1, $debug)
						;Dim $gems[2][3] = [[$gValue,1,0],[$splitIndiv[3], $quickRoll[1][1], $quickRoll[1][2]]]
						$gems[1][0] = $splitIndiv[3]
						$gems[0][0] = $splitIndiv[3]
						ContinueLoop
					Else
						if $debug Then ConsoleWrite("Selecting Amount of Gems..." & @LF)
						$quickRoll = SplitAndRoll($splitIndiv[1], $debug)
						$gems = GemRoll($gValue, $quickRoll[UBound($quickRoll) - 1], $debug,$splitIndiv[1])
						ContinueLoop
					EndIf
				EndIf

				If StringInStr($splitIndiv[4], "ART") > 0 Then

					$gValue = StringLeft($splitIndiv[4], StringLen($splitIndiv[4]) - 4)
					If $takeDefault Then
						$art = ArtRoll($gValue)
						;Dim $art[2][3] = [[$splitIndiv[3], $quickRoll[0][1], $quickRoll[0][2]]]
						$art[1][0] = $splitIndiv[3]
						$art[0][0] = $splitIndiv[3]
						ContinueLoop
					Else
						if $debug Then ConsoleWrite("Selecting Amount of ARTS LEL..." & @LF)
						$quickRoll = SplitAndRoll($splitIndiv[1], $debug)
						$art = ArtRoll($gValue, $quickRoll[UBound($quickRoll) - 1], $debug,$splitIndiv[1])
						ContinueLoop
					EndIf
				EndIf

				If StringInStr($splitIndiv[4], "MAGIC ITEM TABLE") > 0 Then
					If IsArray($magicItems) Then
						If $takeDefault Then
							$magicItems2 = MagicItemRoll($splitIndiv[4], $splitIndiv[3], $debug, $splitIndiv[1])
						Else
							If $splitIndiv[1] = "1d100" Then
								$magicItems2 = MagicItemRoll($splitIndiv[4], 1, $debug, $splitIndiv[1]);$debug)
							Else
								$quickRoll = SplitAndRoll($splitIndiv[1], $debug)
								$magicItems2 = MagicItemRoll($splitIndiv[4], $quickRoll[UBound($quickRoll) - 1], $debug, $splitIndiv[1])
							EndIf
						EndIf
					Else
						If $takeDefault Then
							$magicItems = MagicItemRoll($splitIndiv[4], $splitIndiv[3], $debug, $splitIndiv[1])
						Else
							If $splitIndiv[1] = "1d100" Then
								$magicItems = MagicItemRoll($splitIndiv[4], 1, $debug, $splitIndiv[1]);$debug)
							Else
								$quickRoll = SplitAndRoll($splitIndiv[1], $debug)
								$magicItems = MagicItemRoll($splitIndiv[4], $quickRoll[UBound($quickRoll) - 1], $debug, $splitIndiv[1])
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	Dim $treasureArray[7] = [$iChallenge,$takeDefault,$treasureType,$debug,$rawTreasure,$rawDice,$rawCoin]
	Dim $retArray[6] = [$treasureArray,$coins, $art, $gems, $magicItems, $magicItems2]

;~ 	If $debug Then
;~ 		If IsArray($magicItems) Then _ArrayDisplay($magicItems)
;~ 		If IsArray($magicItems) Then _ArrayDisplay($magicItems2)
;~ 		_ArrayDisplay($coins)
;~ 		If IsArray($art) Then _ArrayDisplay($art)
;~ 		If IsArray($gems) Then _ArrayDisplay($gems)
;~ 	EndIf
	Return $retArray
EndFunc   ;==>TreasureRoll
