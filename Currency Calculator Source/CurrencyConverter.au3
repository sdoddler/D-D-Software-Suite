#include-once
#include <Array.au3>
;#include "DiceRoll.au3"

;~ Standard 	Exchange 	Rates
;~ Coin 			cp 		sp 		ep 		gp 		pp
;~ Copper (cp)		1 		1/10 	1/50 	1/100 	1/1,000
;~ Silver (sp) 		10 		1 		1/5 	1/10 	1/100
;~ Electrum (ep) 	50 		5 		1 		1/2 	1/20
;~ Gold (gp) 		100 	10 		2 		1 		1/10
;~ Platinum (pp) 	1,000 	100 	20 		10 		1


Func CurrencyConverter($toConvert, $toDecimal = True, $fromDecimal = False, $debug = 0)

	If $fromDecimal = False Then
		Local $decimalGP = 0
		If IsArray($toConvert) = 0 Then
			Select
				Case StringInStr($toConvert, "CP")
					$copperPre = StringReplace($toConvert, "CP", "")
					$copperPost = $copperPre / 100
					If $debug Then ConsoleWrite($copperPre & " Copper Pieces to GP Decimal = " & $copperPost & @LF)
					$decimalGP += $copperPost
				Case StringInStr($toConvert, "SP")
					$silverPre = StringReplace($toConvert, "SP", "")
					$silverPost = $silverPre / 10
					If $debug Then ConsoleWrite($silverPre & " Silver Pieces to GP Decimal = " & $silverPost & @LF)
					$decimalGP += $silverPost
				Case StringInStr($toConvert, "EP")
					$electrumPre = StringReplace($toConvert, "EP", "")
					$electrumPost = $electrumPre / 2
					If $debug Then ConsoleWrite($electrumPre & " Electrum Pieces to GP Decimal = " & $electrumPost & @LF)
					$decimalGP += $electrumPost
				Case StringInStr($toConvert, "GP")
					$goldPre = StringReplace($toConvert, "GP", "")
					$goldPost = $goldPre
					If $debug Then ConsoleWrite($goldPre & " Gold Pieces to GP Decimal = " & $goldPost & @LF)
					$decimalGP += $goldPost
				Case StringInStr($toConvert, "PP")
					$platinumPre = StringReplace($toConvert, "PP", "")
					$platinumPost = $platinumPre * 10
					If $debug Then ConsoleWrite($platinumPre & " Platinum Pieces to GP Decimal = " & $platinumPost & @LF)
					$decimalGP += $platinumPost
				Case Else
					ConsoleWrite("No Currency Detected" & @LF)
			EndSelect
		Else
			For $i = 0 To UBound($toConvert) - 1
				Select
					Case StringInStr($toConvert[$i], "CP")
						$copperPre = StringReplace($toConvert[$i], "CP", "")
						$copperPost = $copperPre / 100
						If $debug Then ConsoleWrite($copperPre & " Copper Pieces to GP Decimal = " & $copperPost & @LF)
						$decimalGP += $copperPost
					Case StringInStr($toConvert[$i], "SP")
						$silverPre = StringReplace($toConvert[$i], "SP", "")
						$silverPost = $silverPre / 10
						If $debug Then ConsoleWrite($silverPre & " Silver Pieces to GP Decimal = " & $silverPost & @LF)
						$decimalGP += $silverPost
					Case StringInStr($toConvert[$i], "EP")
						$electrumPre = StringReplace($toConvert[$i], "EP", "")
						$electrumPost = $electrumPre / 2
						If $debug Then ConsoleWrite($electrumPre & " Electrum Pieces to GP Decimal = " & $electrumPost & @LF)
						$decimalGP += $electrumPost
					Case StringInStr($toConvert[$i], "GP")
						$goldPre = StringReplace($toConvert[$i], "GP", "")
						$goldPost = $goldPre
						If $debug Then ConsoleWrite($goldPre & " Gold Pieces to GP Decimal = " & $goldPost & @LF)
						$decimalGP += $goldPost
					Case StringInStr($toConvert[$i], "PP")
						$platinumPre = StringReplace($toConvert[$i], "PP", "")
						$platinumPost = $platinumPre * 10
						If $debug Then ConsoleWrite($platinumPre & " Platinum Pieces to GP Decimal = " & $platinumPost & @LF)
						$decimalGP += $platinumPost
					Case Else
						ConsoleWrite($toConvert[$i] & " - No Currency Detected" & @LF)
				EndSelect
			Next
		EndIf
		If $toDecimal Then
			Dim $toConvert[1] = [$decimalGP]
			Return $toConvert
		Else

			$count = 0
			$gp = 0
			$sp = 0
			$cp = 0
			if $debug Then ConsoleWrite("Decimal GP = " & $decimalGP &@LF)
			If $decimalGP >= 1 Then
				$gp = Int($decimalGP)
				$decimalGP = $decimalGP - $gp
				$count += 1
				if $debug Then ConsoleWrite("Decimal GP (After Gold Calc) = " & $decimalGP &@LF)
			EndIf

			If $decimalGP >= .1 Then
				$decimalGP = Round($decimalGP * 10,1)
				$SP = Int($decimalGP)
				$decimalGP = $decimalGP - $SP
				$count += 1
				if $debug Then ConsoleWrite("Decimal GP (After Silver Calc) = " & $decimalGP &@LF)
			EndIf
			If $decimalGP > 0 Then
				if $sp <> 0 Then
				$decimalGP = Round($decimalGP * 10,0)
				Else
				$decimalGP = Round($decimalGP * 100,0)
				EndIf

				$CP = Int($decimalGP)
				$count += 1
				if $debug Then ConsoleWrite("Decimal GP (After Copper Calc) = " & $decimalGP &@LF)
			EndIf

			Dim $toConvert[$count]
			For $i = 0 To $count - 1
				If $gp <> 0 Then
					$toConvert[$i] = Round($gp,2) & " GP"
					$gp = 0
					ContinueLoop
				EndIf
				If $SP <> 0 Then
					$toConvert[$i] = Round($SP,2) & " SP"
					$sp = 0
					ContinueLoop
				EndIf

				If $CP <> 0 Then
					$toConvert[$i] = Round($CP,2) & " CP"
					$cp = 0
					ContinueLoop
				EndIf
			Next
;~ 					Then[$gp & " GP",$sp & " SP", $cp & " CP"]
;~ 				Else
;~ 				Dim $toConvert[2] = [$gp & " GP", Round($dec * 100, 0) & " CP"]
;~ 				EndIf
;~ 			Else
;~ 				Dim $toConvert[1] = [Round($decimalGP * 100, 0) & " CP"]
;~ 			EndIf
			Return $toConvert
		EndIf
	Else
		If $toDecimal Then
			;;This should never happen - Decimal to Decimal (Returns same number)
			If IsArray($toConvert) Then
				$decimalGP = 0
				For $i = 0 to UBound($toConvert)-1
					$decimalGP += $toConvert[$i]
				Next
				Dim $toConvert[1] = [$decimalGP]
			Else
			Dim $toConvert[1] = [$toConvert]
			EndIf
			Return $toConvert
		Else
			If IsArray($toConvert) Then
				$decimalGP = 0
				For $i = 0 to UBound($toConvert)-1
					$decimalGP += $toConvert[$i]
				Next
			Else
			$decimalGP = $toConvert
			EndIf
			$count = 0
			$gp = 0
			$sp = 0
			$cp = 0
			$negative = False


			if $decimalGP < 0 Then
				$decimalGP = Abs($decimalGP)
				$negative = True
			EndIf


			if $debug Then ConsoleWrite("Decimal GP = " & $decimalGP &@LF)
			If $decimalGP >= 1 Then
				$gp = Int($decimalGP)
				if $debug Then ConsoleWrite("GP = " &$gp&@LF)
				$decimalGP = Round($decimalGP - $gp,2)
				if $debug Then ConsoleWrite("Decimal GP (After Gold Calc) = " & $decimalGP &@LF)
				$count += 1
			EndIf
			If $decimalGP >= .1 Then
				$decimalGP = $decimalGP * 10
				$SP = Int($decimalGP)
				$decimalGP = Round($decimalGP - $SP,2)
				if $debug Then ConsoleWrite("Decimal GP (After Silver Calc) = " & $decimalGP &@LF)
				$count += 1
			EndIf
			If $decimalGP > 0 Then
				if $sp <> 0 Then
				$decimalGP = $decimalGP * 10
				Else
				$decimalGP = $decimalGP * 100
				EndIf
				$CP = Int($decimalGP)
				$count += 1
				if $debug Then ConsoleWrite("Decimal GP (After Copper Calc) = " & $decimalGP &@LF)
			EndIf

			Dim $toConvert[$count]
			For $i = 0 To $count - 1
				If $gp <> 0 Then
					$toConvert[$i] = Round($gp,2) & " GP"
					$gp = 0
					ContinueLoop
				EndIf
				If $SP <> 0 Then
					$toConvert[$i] = Round($SP,2) & " SP"
					$sp = 0
					ContinueLoop
				EndIf

				If $CP <> 0 Then
					$toConvert[$i] = Round($CP,2) & " CP"
					$cp = 0
					ContinueLoop
				EndIf
			Next
			Return $toConvert
		EndIf
	EndIf
EndFunc   ;==>CurrencyConverter
