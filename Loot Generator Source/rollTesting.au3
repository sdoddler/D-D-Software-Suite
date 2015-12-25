#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include "DiceRoll.au3"
#include "GemRoll.au3"
#include "ArtRoll.au3"
#include "TreasureRoll.au3"
#include "MagicItemRoll.au3"
#include "MiscItemRoll.au3"

#include <array.au3>

$minorProp = MinorPropertyRoll(1)
$history = HistoryAndQuirksRoll(True, True,True,0)


_ArrayDisplay($minorProp)
;_ArrayDisplay($history)

#CS
$treasure = TreasureRoll("Challenge 11-16",False,"Hoards")

$miscItems = ItemRoll("d8",2,"","1 GP")

;~ _ArrayDisplay($miscItems)

;; TO DO NEXT - - - - -
; GUI THE FUCK OUT OF THIS SHIT
;;Think the Ticker\Feed is working as it should.
;--Alex has suggested Random Scroll picking as well. - DONE PIECE OF PISS GIVE ME SOMETHING HARDER CUNT

$TreasureInfo = $treasure[0]
$LOLCOINS = $treasure[1]
$NOOWAYART = $treasure[2]
$COOLGEMS = $treasure[3]
$OMGMAGICITEMS = $treasure[4]
$2MAGICITEMSOMG = $treasure[5]

;~ _ArrayDisplay($TreasureInfo)
;~ _ArrayDisplay($LOLCOINS)
;~ _ArrayDisplay($NOOWAYART)
;~ _ArrayDisplay($COOLGEMS)
;~ _ArrayDisplay($OMGMAGICITEMS)
;~ _ArrayDisplay($2MAGICITEMSOMG)


ConsoleWrite(@LF & "-------------------------Treasure Roll-------------------------" & @LF)
;--- Basic Treasure Info
if $TreasureInfo[3] Then ConsoleWrite("-Debug: ENABLED"&@LF)
ConsoleWrite("-Treasure Type: " & $TreasureInfo[2] &@LF _
& "-Challenge Level: " & $TreasureInfo[0] &@LF)
if $TreasureInfo[1] Then ConsoleWrite("-Take Default Dice Rolls: ENABLED" &@LF)
ConsoleWrite("-d100 Roll to Determine Treasure: " & $TreasureInfo[5] &@LF);;if Show Dice Rolls Then Show this line
if $TreasureInfo[3] Then ConsoleWrite("-Raw Treasure Data from .txt: " & $TreasureInfo[4] &@LF)
if ($TreasureInfo[3] AND $TreasureInfo[6]) Then ConsoleWrite("-Raw Coin Data from .txt: " & $TreasureInfo[6] &@LF)
;--- Show Coins gained from Loot
if IsArray($LOLCOINS) Then
	ConsoleWrite("---Coins Gained from Loot: " &@LF)
	For $i = 0 to UBound($LOLCOINS)-1
		if $LOLCOINS[$i][1] Then
			ConsoleWrite($LOLCOINS[$i][1] & " " & $LOLCOINS[$i][0]& @LF)
			if $TreasureInfo[3] Then
				ConsoleWrite("--Dice Rolled: " & $LOLCOINS[$i][3] &@LF _
				& "--Dice Result: " & $LOLCOINS[$i][4])
				if $TreasureInfo[1] Then ConsoleWrite(" (Default roll Taken)")
				ConsoleWrite(@LF & "--Multiplier: " & $LOLCOINS[$i][2] &@LF)
			EndIf
		EndIf
	Next
EndIf
;;--Show Art Gained from Loot
if IsArray($NOOWAYART) Then
	ConsoleWrite("---"&$NOOWAYART[0][0]&" x "&$NOOWAYART[0][1]&" Art Objects Gained from Loot: " &@LF)
	if $TreasureInfo[3] Then
				ConsoleWrite("--Dice Rolled: " & $NOOWAYART[0][2] &@LF _
				& "--Dice Result: " & $NOOWAYART[0][0])
				if $TreasureInfo[1] Then ConsoleWrite(" (Default roll Taken)")
				ConsoleWrite(@LF)
		EndIf
	For $i = 1 to UBound($NOOWAYART)-1
			ConsoleWrite($NOOWAYART[$i][0] & "x " & $NOOWAYART[$i][1])
			if $TreasureInfo[3] Then ConsoleWrite(" (Individual Dice Rolls: " & $NOOWAYART[$i][2] & ")")
			ConsoleWrite(@LF)
	Next
EndIf
;;--Show Gems Gained from Loot
if IsArray($COOLGEMS) Then
	ConsoleWrite("---"&$COOLGEMS[0][0]&" x "&$COOLGEMS[0][1]&" Gems Gained from Loot: " &@LF)
	if $TreasureInfo[3] Then
				ConsoleWrite("--Dice Rolled: " & $COOLGEMS[0][2] &@LF _
				& "--Dice Result: " & $COOLGEMS[0][0])
				if $TreasureInfo[1] Then ConsoleWrite(" (Default roll Taken)")
				ConsoleWrite(@LF)
		EndIf
	For $i = 1 to UBound($COOLGEMS)-1
			ConsoleWrite($COOLGEMS[$i][0] & "x " & $COOLGEMS[$i][1])
			if $TreasureInfo[3] Then ConsoleWrite(" (Individual Dice Rolls: " & $COOLGEMS[$i][2] & ")")
			ConsoleWrite(@LF)
	Next
EndIf
;;--Show First set of Magic Items Gained from loot
if IsArray($OMGMAGICITEMS) Then
	ConsoleWrite("---"&$OMGMAGICITEMS[0][0]&" x Item(s) from "&$OMGMAGICITEMS[0][1]&" Gained from Loot: " &@LF)
	if $TreasureInfo[3] Then
				ConsoleWrite("--Dice Rolled: " & $OMGMAGICITEMS[0][2] &@LF _
				& "--Dice Result: " & $OMGMAGICITEMS[0][0])
				if $TreasureInfo[1] Then ConsoleWrite(" (Default roll Taken)")
				ConsoleWrite(@LF)
		EndIf
	For $i = 1 to UBound($OMGMAGICITEMS)-1
			ConsoleWrite($OMGMAGICITEMS[$i][0] & "x " & $OMGMAGICITEMS[$i][1])
			if $TreasureInfo[3] Then ConsoleWrite(" (Individual Dice Rolls: " & $OMGMAGICITEMS[$i][2] & ")")
			ConsoleWrite(@LF)
	Next
EndIf
;;--Show Second set of Magic Items Gained from loot
if IsArray($2MAGICITEMSOMG) Then
	ConsoleWrite("---"&$2MAGICITEMSOMG[0][0]&" x Item(s) from "&$2MAGICITEMSOMG[0][1]&" Gained from Loot: " &@LF)
	if $TreasureInfo[3] Then
				ConsoleWrite("--Dice Rolled: " & $2MAGICITEMSOMG[0][2] &@LF _
				& "--Dice Result: " & $2MAGICITEMSOMG[0][0])
				if $TreasureInfo[1] Then ConsoleWrite(" (Default roll Taken)")
				ConsoleWrite(@LF)
		EndIf
	For $i = 1 to UBound($2MAGICITEMSOMG)-1
			ConsoleWrite($2MAGICITEMSOMG[$i][0] & "x " & $2MAGICITEMSOMG[$i][1])
			if $TreasureInfo[3] Then ConsoleWrite(" (Individual Dice Rolls: " & $2MAGICITEMSOMG[$i][2] & ")")
			ConsoleWrite(@LF)
	Next
EndIf

If IsArray($miscItems) Then
	ConsoleWrite("---" & $miscItems[0][0] & " x Misc Items Gained from Loot: " &@LF)
	if $TreasureInfo[3] Then;;; USing this for now for lack of a better debug thingy.
		ConsoleWrite("--Dice Rolled: " & $miscItems[0][1] &@LF _
		& "--Dice Result: " & $miscItems[0][0] & " (Individual Dice Rolls: " & $miscItems[0][2] & ")" &@LF)

	EndIf
	ConsoleWrite("--Types Chosen From: " & $miscItems[0][3] &@LF _
	& "--Max Price\Value: " & $miscItems[0][4] &@LF)
	For $i = 1 to UBound($miscItems)-1
		ConsoleWrite($miscItems[$i][0] & "x " & $miscItems[$i][1] & @LF)
	Next

EndIf

#CE

;$gemRoll = GemRoll("10 GP",12)

;_ArrayDisplay($gemRoll)

;;--- Generic Increasing Roll Test of d100
;~ For $i = 0 to 20

;~ 	_ArrayDisplay(DiceRoll($i,"d100"))
;~ Next