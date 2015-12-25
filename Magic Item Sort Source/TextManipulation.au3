#include <array.au3>
#include <iniex.au3>


$lel = IniReadSection("SomethingSomething.txt","MagicItems")

Dim $abcd[$lel[0][0]][2]
$a = 0



For $i = 1 to $lel[0][0]
	$included = False
	For $j = 0 to UBound($abcd)-1
		if $lel[$i][0] = $abcd[$j][0] Then
			$included = True
			ExitLoop
		EndIf
	Next
	If $included = False Then
		$abcd[$a][0] = $lel[$i][0]
		$abcd[$a][1] = $lel[$i][1]
		$a +=1
	EndIf
Next

_ArraySort($abcd)


_ArrayDisplay($abcd)


IniWriteSection("FUCK.TXT","MagicItems",$abcd)

#cs
REQUIRES MONOSPACED FONT SUCH AS CONSOLAS (GUICtrlSetFont(blah,blah,blah,blah,Consolas)




#CS Hmmm what to do if Table has large amounts of Text?? Maybe the Following?
+---+
Dice Roll: d100
+---+
Roll: 1
+-----+
Effect THE SUCH AND SUCH DOES ALL THIS BULLSHIT
CRLF IN HERE LOL CAUSE THEN YOU CAN JUST GO
+----+
Rolled a: 2
+-----+

Something like this should work?

#CE        1x
123456789890123456789
+-------------------+
+    Table Idea     +
+-----+-------------+
| d10 | Damage Type |
|  1  | Bludgeoning |
|

Easy enough to code i believe.
Currently in the .txt i have TableColumns =  and TableRow1 =
Check through all these and split with \\
Put into one large array.
eg for above
[0][0] = d10		[0][1] = Damage Type
[1][0] = 1			[1][1] = Bludegeoning
And so on.
Then for Each item in column (for each [0]) Check StringLen ---- Use a Do Until Loop (Until StrinStr(Table) = 0 OR $X > Ubound($Array)-1
if StringLen > $longestStr  Then $longestr = StringLen
This way you can determine the Column Length (Maybe start at [1][1] for the table and use [0][1] for \\ Delimited column lengths?

Switch Section[$i][0]
	Case ---- Can't do StringInStr with Swtich? Maybe Select?

#CE
;~ ConsoleWrite(IniRead("Working Complete List.txt","APPARATUS OF KWALISH","Description9","Incorrect Return From .TXT"))
;~ _ArrayDisplay(IniReadSection("Working Complete List.txt","APPARATUS OF KWALISH"))

;~ $CompleteArray = IniReadSectionNames("Working Complete List.Txt")
;~ $basicArray = IniReadSection("MagicItems-BasicInfo.txt","MagicItems")

;~ Dim $LOLArray[1000][2]

;~ $arrayCount = 0

;~ $higherArray = Ubound($CompleteArray)-1
;~ if Ubound($basicArray) > $higherArray Then $higherArray = Ubound($basicArray)


;~ For $i = 1 to $CompleteArray[0]
;~ 	$LOLArray[$arrayCount][0] = $CompleteArray[$i]
;~ 	for $j = 1 to $basicArray[0][0]
;~ 		if $CompleteArray[$i] = $basicArray[$j][0] Then
;~ 			$LOLArray[$arrayCount][1] = $basicArray[$j][0]
;~ 			ExitLoop
;~ 		EndIf
;~ 	Next
;~ 	$arrayCount +=1
;~ Next

;~ For $i = 1 to $basicArray[0][0]
;~ 	$included = False
;~ 	For $j = 0 to $arrayCount
;~ 		if $basicArray[$i][0] = $LOLArray[$j][1] Then
;~ 			$included = True
;~ 			ExitLoop
;~ 		EndIf
;~ 	Next
;~ 	If $included = False Then
;~ 		$LOLArray[$arrayCount][1] = $basicArray[$i][0]
;~ 		$basicArray[$i][1] &= "\\"
;~ 		$arrayCount+=1
;~ 	EndIf

;~ Next

;~ _ArrayDisplay($LOLArray)

;~ IniWriteSection("SomethingSomething.txt","MagicItems",$basicArray)

#REgion Used to Quickly get [ ] around As many headings as possible
#CS
$rawText = "All Magic Items From PDF.txt"

$rawOpen = FileOpen($rawText)

$rawArray = FileReadToArray($rawOpen)

$magicItems = IniReadSection("MagicItems-BasicInfo.txt","MagicItems")


For $i = 0 to UBound($rawArray)-1
	For $j = 1 to $magicItems[0][0]
		If $rawArray[$i] = $magicItems[$j][0] Then
			$rawArray[$i] = "[" & $rawArray[$i] & "]"
			ExitLoop
		EndIf

	Next
Next

FileWrite("SomethingSomething.txt",_ArrayToString($rawArray,@CRLF))

;_ArrayDisplay($rawArray)

;ConsoleWrite(FileReadLine($rawText))
#CE
#EndRegion


#region Below Worked - For Basic Manipulation and Info
;~ $fOpen = FileOpen("MagicItems 1.txt")

;~ $fileArray = FileReadToArray($fOpen)

;~ FileClose($fOpen)

;~ For $i = 0 to UBound($fileArray)-1
;~ 	$quickSplit = StringSplit($fileArray[$i],@TAB)
;~ 	$fileArray[$i] = $quickSplit[1] & "="
;~ 	;_ArrayDisplay($quickSplit)
;~ 	For $j = 2 to $quickSplit[0]
;~ 		if NOT($j = 2) Then $fileArray[$i] &= "\\"
;~ 		if $quickSplit[$j] = "" Then
;~ 			$fileArray[$i] &= "-"
;~ 		Else
;~ 		$fileArray[$i] &= $quickSplit[$j]
;~ 		EndIf
;~ 	Next
;~ Next

;~ FileWrite("SomethingSomething.txt",_ArrayToString($fileArray,@CRLF))
#EndRegion