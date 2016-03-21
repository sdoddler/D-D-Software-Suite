#include-once
#include <Array.au3>
#include "DiceRoll.au3"


Func GemRoll($value, $amount = 1, $debug = 0, $dice = "")
	$iCount = 1
	$skip = False

	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\Loot Generator Resources\"

	$section = IniReadSection($appdir & "Gemstones.txt", $value)
	if $debug Then ConsoleWrite("Selecting Gem(s) x" & $amount & "..." & @LF)
	$diceRoll = DiceRoll($section[1][1], $amount, $debug) ;; Selecting the Gem


	For $i = 2 To $section[0][0]
		$int = StringInStr($section[$i][1], "(") - 1
		$section[$i][1] = StringLeft($section[$i][1], $int)
	Next

	Dim $gems[$section[0][0]][3]
	$gems[0][1] = $value
	$gems[0][0] = $amount
	If $dice <> "" Then
		$gems[0][2] = $dice
	Else
		$gems[0][2] = $section[1][1]
	EndIf
	If UBound($diceRoll) > 2 Then
		For $i = 0 To UBound($diceRoll) - 2
			For $j = 1 To UBound($gems) - 1
				$skip = False
				If $section[$diceRoll[$i] + 1][1] = $gems[$j][1] Then
					$gems[$j][0] += 1
					$gems[$j][2] &= " - " & $diceRoll[$i]
					If $debug Then ConsoleWrite(@TAB & "Individual Dice Roll Debug(gem):" & @LF _
							 & @TAB & @TAB & "----Dice Roll = " & $diceRoll[$i] & @LF _
							 & @TAB & @TAB & "----Gem Chosen = " & $gems[$j][1] & @LF _
							 & @TAB & @TAB & "----Total of Gem so Far = " & $gems[$j][0] & @LF)
					$skip = True
					ExitLoop

				EndIf
			Next
			If Not ($skip) Then
				$gems[$iCount][1] = $section[$diceRoll[$i] + 1][1]
				$gems[$iCount][0] += 1
				$gems[$iCount][2] = $diceRoll[$i]
				If $debug Then ConsoleWrite(@TAB & "Individual Dice Roll Debug(gem):" & @LF _
						 & @TAB & @TAB & "----Dice Roll = " & $diceRoll[$i] & @LF _
						 & @TAB & @TAB & "----Gem Chosen = " & $gems[$iCount][1] & @LF & @LF)
				$iCount += 1
			EndIf
		Next
		ReDim $gems[$iCount][3]
		Return $gems
	Else
		$gems[1][1] = $section[$diceRoll[0] + 1][1]
		$gems[1][0] = 1
		$gems[1][2] = $diceRoll[0]
		ReDim $gems[2][3]
		Return $gems
	EndIf

EndFunc   ;==>GemRoll
