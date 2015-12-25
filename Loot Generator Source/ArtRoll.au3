#include-once
#include <Array.au3>
#include "DiceRoll.au3"


Func ArtRoll($value, $amount = 1, $debug = 0, $dice = "")
	$iCount = 1
	$skip = False

	$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"

	$section = IniReadSection($appDir & "Art Objects.txt", $value)
	if $debug Then ConsoleWrite("Selecting Artwork(s) x" & $amount & "..." & @LF)
	$diceRoll = DiceRoll($section[1][1], $amount, $debug)

	Dim $Arts[$section[0][0]][3]
	$Arts[0][1] = $value
	$Arts[0][0] = $amount
	if $dice <> "" Then
	$Arts[0][2] = $dice
	Else
	$Arts[0][2] = $section[1][1]
	EndIf
	If UBound($diceRoll) > 2 Then
		For $i = 0 To UBound($diceRoll) - 2
			For $j = 1 To UBound($Arts) - 1
				$skip = False
				If $section[$diceRoll[$i] + 1][1] = $Arts[$j][1] Then
					$Arts[$j][0] += 1
					$Arts[$j][2] &= " - " & $diceRoll[$i]
					If $debug Then ConsoleWrite(@TAB & "Individual Dice Roll Debug(Art):" & @LF _
							 & @TAB & @TAB & "----Dice Roll = " & $diceRoll[$i] & @LF _
							 & @TAB & @TAB & "----Art Chosen = " & $Arts[$j][1] & @LF _
							 & @TAB & @TAB & "----Total of Art so Far = " & $Arts[$j][0] & @LF)
					$skip = True
					ExitLoop

				EndIf
			Next
			If Not ($skip) Then
				$Arts[$iCount][1] = $section[$diceRoll[$i] + 1][1]
				$Arts[$iCount][0] += 1
				$Arts[$iCount][2] = $diceRoll[$i]
				If $debug Then ConsoleWrite(@TAB & "Individual Dice Roll Debug(Art):" & @LF _
						 & @TAB & @TAB & "----Dice Roll = " & $diceRoll[$i] & @LF _
						 & @TAB & @TAB & "----Art Chosen = " & $Arts[$iCount][1] & @LF & @LF)
				$iCount += 1
			EndIf
		Next
		ReDim $Arts[$iCount][3]
		Return $Arts
	Else
		$Arts[1][1] = $section[$diceRoll[0] + 1][1]
		$Arts[1][0] = 1
		$Arts[1][2] = $diceRoll[0]
		ReDim $Arts[2][3]
		Return $Arts
	EndIf

EndFunc   ;==>ArtRoll
