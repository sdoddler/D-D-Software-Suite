#include-once
#include <Array.au3>

Func SplitAndRoll($diceStr, $debug = 0)
	$dice = SplitDice($diceStr, $debug)

	$diceRoll = DiceRoll($dice[1], $dice[0], $debug)

	Return $diceRoll
EndFunc   ;==>SplitAndRoll

Func SplitDice($diceStr, $debug = 0)
	$dInt = StringInStr($diceStr, "d")

	Dim $dice[2]

	$dice[0] = StringLeft($diceStr, $dInt - 1)
	$dice[1] = StringRight($diceStr, StringLen($diceStr) - $dInt + 1)

	If $debug Then ConsoleWrite("Splitting Dice Returns: " & $dice[0] & " - " & $dice[1] & @LF)
	Return $dice
EndFunc   ;==>SplitDice

Func DiceRoll($dice, $times = 1, $debug = 0, $addition = 0)

	Dim $iRoll[$times + 1]
	Local $iCount = 0

	Switch $dice
		Case "d4"
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, 4, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition
;~ 			if $debug AND $times > 1 Then $ar2String = @TAB & "-- Individual Dice Rolls: (" & _ArrayToString($iRoll,")(",0,$times-1) & ")"
;~ 			ConsoleWrite("DiceRoll Called:" &@LF _
;~ 			& @TAB & "-- $times = " & $times &@LF _
;~ 			&@TAB& "-- $dice = " &$dice&@LF _
;~ 			& @TAB & "-- Total roll Result = " &$iCount &@LF)
;~ 			If $debug AND $times > 1 Then ConsoleWrite($ar2String &@LF)
;~ 			ConsoleWrite(@LF)
;~ 			Return $iRoll
		Case "d6"
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, 6, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition
;~ 			if $debug AND $times > 1 Then $ar2String = @TAB & "-- Individual Dice Rolls: (" & _ArrayToString($iRoll,")(",0,$times-1) & ")"
;~ 			ConsoleWrite("DiceRoll Called:" &@LF _
;~ 			& @TAB & "-- $times = " & $times &@LF _
;~ 			&@TAB& "-- $dice = " &$dice&@LF _
;~ 			& @TAB & "-- Total roll Result = " &$iCount &@LF)
;~ 			If $debug AND $times > 1 Then ConsoleWrite($ar2String &@LF)
;~ 			ConsoleWrite(@LF)
;~ 			Return $iRoll
		Case "d8"
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, 8, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition
;~ 			if $debug AND $times > 1 Then $ar2String = @TAB & "-- Individual Dice Rolls: (" & _ArrayToString($iRoll,")(",0,$times-1) & ")"
;~ 			ConsoleWrite("DiceRoll Called:" &@LF _
;~ 			& @TAB & "-- $times = " & $times &@LF _
;~ 			&@TAB& "-- $dice = " &$dice&@LF _
;~ 			& @TAB & "-- Total roll Result = " &$iCount &@LF)
;~ 			If $debug AND $times > 1 Then ConsoleWrite($ar2String &@LF)
;~ 			ConsoleWrite(@LF)
;~ 			Return $iRoll
		Case "d10"
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, 10, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition
;~ 			if $debug AND $times > 1 Then $ar2String = @TAB & "-- Individual Dice Rolls: (" & _ArrayToString($iRoll,")(",0,$times-1) & ")"
;~ 			ConsoleWrite("DiceRoll Called:" &@LF _
;~ 			& @TAB & "-- $times = " & $times &@LF _
;~ 			&@TAB& "-- $dice = " &$dice&@LF _
;~ 			& @TAB & "-- Total roll Result = " &$iCount &@LF)
;~ 			If $debug AND $times > 1 Then ConsoleWrite($ar2String &@LF)
;~ 			ConsoleWrite(@LF)
;~ 			Return $iRoll
		Case "d12"
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, 12, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition
;~ 			if $debug AND $times > 1 Then $ar2String = @TAB & "-- Individual Dice Rolls: (" & _ArrayToString($iRoll,")(",0,$times-1) & ")"
;~ 			ConsoleWrite("DiceRoll Called:" &@LF _
;~ 			& @TAB & "-- $times = " & $times &@LF _
;~ 			&@TAB& "-- $dice = " &$dice&@LF _
;~ 			& @TAB & "-- Total roll Result = " &$iCount &@LF)
;~ 			If $debug AND $times > 1 Then ConsoleWrite($ar2String &@LF)
;~ 			ConsoleWrite(@LF)
;~ 			Return $iRoll
		Case "d20"
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, 20, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition
;~ 			if $debug AND $times > 1 Then $ar2String = @TAB & "-- Individual Dice Rolls: (" & _ArrayToString($iRoll,")(",0,$times-1) & ")"
;~ 			ConsoleWrite("DiceRoll Called:" &@LF _
;~ 			& @TAB & "-- $times = " & $times &@LF _
;~ 			&@TAB& "-- $dice = " &$dice&@LF _
;~ 			& @TAB & "-- Total roll Result = " &$iCount &@LF)
;~ 			If $debug AND $times > 1 Then ConsoleWrite($ar2String &@LF)
;~ 			ConsoleWrite(@LF)
;~ 			Return $iRoll
		Case "d100"
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, 100, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition
		Case Else
			$dice = StringReplace($dice,"d","")
			For $i = 0 To $times - 1
				$iRoll[$i] = Random(1, $dice, 1)
				$iCount += $iRoll[$i]
			Next
			$iRoll[$times] = $iCount + $addition

	EndSwitch

	If $debug And $times > 1 Then $ar2String = @TAB & "-- Individual Dice Rolls: (" & _ArrayToString($iRoll, ")(", 0, $times - 1) & ")"
	if $debug Then ConsoleWrite("DiceRoll Called:" & @LF _
			 & @TAB & "-- $times = " & $times & @LF _
			 & @TAB & "-- $dice = " & $dice & @LF _
			 & @TAB & "-- $addition = " & $addition &@LF _
			 & @TAB & "-- Total roll Result = " & $iCount  & @LF)
	If $debug And $times > 1 Then ConsoleWrite($ar2String & @LF)
	ConsoleWrite(@LF)

	Return $iRoll

EndFunc   ;==>DiceRoll
