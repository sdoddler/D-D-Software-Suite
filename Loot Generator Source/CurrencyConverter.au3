#include-once
#include <Array.au3>
#include "DiceRoll.au3"

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
					$platinumPre = StringReplace($toConvert, "EP", "")
					$platinumPost = $platinumPre * 10
					If $debug Then ConsoleWrite($platinumPre & " Electrum Pieces to GP Decimal = " & $platinumPost & @LF)
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
						$platinumPre = StringReplace($toConvert[$i], "EP", "")
						$platinumPost = $platinumPre * 10
						If $debug Then ConsoleWrite($platinumPre & " Electrum Pieces to GP Decimal = " & $platinumPost & @LF)
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
			If $decimalGP >= 1 Then
				$floor = Floor($decimalGP)
				$dec = $decimalGP - $floor
				Dim $toConvert[2] = [$floor & " GP", Round($dec * 100, 0) & " CP"]
			Else
				Dim $toConvert[1] = [Round($decimalGP * 100, 0) & " CP"]
			EndIf
			Return $toConvert
		EndIf
	Else
		If $toDecimal Then
			;;This should never happen - Decimal to Decimal (Returns same number)
			Dim $toConvert[1] = [$toConvert]
			Return $toConvert
		Else
			If $toConvert >= 1 Then
				$floor = Floor($toConvert)
				$dec = $toConvert - $floor
				Dim $toConvert[2] = [$floor & " GP", Round($dec * 100, 0) & " CP"]
			Else
				Dim $toConvert[1] = [Round($toConvert * 100, 0) & " CP"]
			EndIf
			Return $toConvert
		EndIf
	EndIf
EndFunc   ;==>CurrencyConverter
