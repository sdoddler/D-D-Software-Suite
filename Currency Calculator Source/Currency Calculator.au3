#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Resources\Currency Calculator\CurrencyCalculator_Icon.ico
#AutoIt3Wrapper_Outfile=..\Currency Calculator.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;; To do
;~ -- Fix up negative calculations from Currency Converter.. (minus)- XX CP on each? Doesnt seem efficient..
;~  --- No idea what above means lol >.>

;~  Do maths for Party split - Use Mod () Use on PP as well, but keep PP seperate from other calculations - Tickbox?


; --- Currency Calculator ---
; 2 Modes, Calculator and converter.
; Basic Calculator to go X*X = XX
; Continuation so you can go XX - A = BB (After you've done a sum already)
; Use Working Numbers
;	- "First Number" = As soon as a number button is hit the mode = First number
;	- "Modifier" = -+x/ 	When a modifier is clicked Mode is set to Second Number if another modifier is clicked it replaces the first
;	- "Second Number" = Any number pressed after modifier, if another modifier or "=" is pressed then Total is generated and Second number becomes First
;	- "Total" if = Is pressed Then Mode is reset to First number & First Number = Total
;
;	- Clear button to clear current working numbers and reset mode to First Number
;~ 			- CE (Clear Entry) to Clear second or first number..
;	- Backspace to remove misclick (go one character back) -- Figure out modifier logic for this too?
;~ 					- Windows Calculator goes to 0 if All characters are backspaced ( goes to 0 for second number if modifier already selected.)
;~ 																						-(windows calc will not allow you to change modifier here)

;~ 	- CP,SP,EP,GP,PP Buttons on the right, to add this to the total area
;~ 		- This resets workspace to 0 and adds the total to relevant inputbox
;~ 		- Maybe Grey these out until First Number Mode
;~ 	- Running Total Area Section for each type of Currency.
;~ 	- Tick box with "Exchange to GP\SP Where possible"
;~ 			- refresh Symbol to do above with current values (Greyed out if above unticked)

;~ 	- Party Split Area -
;~ 	- accessible for both Calculator and Converter modes
;~ 	- Party Members up down (max 10?)
;~ 	- Split button

;~ 	- Converter Mode - -- No need for this. You can just click the Exchange Currency up button on Calculator..
;~ 	Simple Number only text boxes for each currency
;~ 		- Updown Multipliers for each
;~ 	- Tick box for "Exchange currency up where possible"

#include-once
#include <Array.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <ScrollBarsConstants.au3>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "CurrencyConverter.au3"




;~ Dim $array[2] = ["12 PP","123 CP"]
;$toConvert, $toDecimal = True, $fromDecimal = False, $debug = 0
;_ArrayDisplay(CurrencyConverter($array,False,False,True))

#Region Global Variables
$appDir = EnvGet("APPDATA") & "\Doddler's D&D\"
DirCreate($appDir)
$iconsIcl = $appDir & "Icons.icl"

Global $firstHistory = True
Global $calcMode = "First Number", $calcLastMode = "First Number"
Global $numArray[10]
Global $calcOnZero = True, $calcFirstNumber = 0, $calcSecondNumber, $calcModifier
Global $exchangeMode = False, $convertMode = False
#EndRegion Global Variables

#Region File Installs
FileInstall("..\Resources\Icons.icl", $appDir & "Icons.icl", 1)
#EndRegion File Installs

#Region Main Window Options
$winTitle = "Currency Calculator"
$hGui = GUICreate($winTitle, 370, 230)

AutoItSetOption("GUIResizeMode", $GUI_DOCKALL)
;~ $background = GUICtrlCreatePic("Back.jpg",-10,-10,320,250)
#EndRegion Main Window Options

#Region Main Gui Ctrls
$calcHistory = GUICtrlCreateEdit("", 10, 5, 135, 40, $ES_READONLY + $ES_RIGHT + $ES_MULTILINE + $ES_WANTRETURN + $ES_AutoVScroll + $WS_VSCROLL);BitOR($ES_READONLY, $ES_RIGHT, $ES_MULTILINE,$ES_WANTRETURN))
$calcDisplay = GUICtrlCreateInput(0, 10, 45, 135, 20, BitOR($ES_READONLY, $ES_RIGHT))

$calcBackspace = GUICtrlCreateButton("<--", 10, 70, 30)
$calcClearEntry = GUICtrlCreateButton("CE", 45, 70, 30)
$calcClear = GUICtrlCreateButton("C", 80, 70, 30)
$calcDivide = GUICtrlCreateButton("/", 115, 70, 30)
GUICtrlSetFont(-1, 12)

$numArray[7] = GUICtrlCreateButton("7", 10, 100, 30)
$numArray[8] = GUICtrlCreateButton("8", 45, 100, 30)
$numArray[9] = GUICtrlCreateButton("9", 80, 100, 30)
$calcMultiply = GUICtrlCreateButton("*", 115, 100, 30)
GUICtrlSetFont(-1, 12)

$numArray[4] = GUICtrlCreateButton("4", 10, 130, 30)
$numArray[5] = GUICtrlCreateButton("5", 45, 130, 30)
$numArray[6] = GUICtrlCreateButton("6", 80, 130, 30)
$calcMinus = GUICtrlCreateButton("-", 115, 130, 30)
GUICtrlSetFont(-1, 12)

$numArray[1] = GUICtrlCreateButton("1", 10, 160, 30)
$numArray[2] = GUICtrlCreateButton("2", 45, 160, 30)
$numArray[3] = GUICtrlCreateButton("3", 80, 160, 30)
$calcAdd = GUICtrlCreateButton("+", 115, 160, 30)
GUICtrlSetFont(-1, 12)

$numArray[0] = GUICtrlCreateButton("0", 10, 190, 65)
;~ GUICtrlCreateButton(".",45,190,30)
$calcDecimal = GUICtrlCreateButton(".", 80, 190, 30)
GUICtrlSetFont(-1, 16)
$calcEquals = GUICtrlCreateButton("=", 115, 190, 30)
GUICtrlSetFont(-1, 12)


$calcCP = GUICtrlCreateButton("CP", 150, 70, 30)
$calcSP = GUICtrlCreateButton("SP", 150, 100, 30)
$calcEP = GUICtrlCreateButton("EP", 150, 130, 30)
$calcGP = GUICtrlCreateButton("GP", 150, 160, 30)
$calcPP = GUICtrlCreateButton("PP", 150, 190, 30)

GUICtrlCreateIcon($iconsIcl, 2, 150, 15, 32, 32)
GUICtrlSetTip(-1, "Make your calculations via the calculator" & @LF & "When a number is ready it can be added to a currency via the buttons below")

#Region --- Vertical Seperator Line ---
$hGraphic = GUICtrlCreateGraphic(180, 0, 20, 230)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5, 5)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5, 225)

#EndRegion --- Vertical Seperator Line ---


$checkExchange = GUICtrlCreateCheckbox("Exchange currency (up to GP)", 195, 1)
GUICtrlSetTip(-1, "Where possible Exchange Currency upwards" & @LF & "E.g. 111 CP = 1 GP & 1 SP & 1 CP")

$checkConvert = GUICtrlCreateCheckbox("Convert input to other Currencies", 195, 20)
GUICtrlSetTip(-1, "This will convert whole numbers to other currencies" & @LF & "Remainders will be lost if you change to a different currency" & @LF _
		 & "If there is already more than one currency in the below boxes" & @LF & "it will be converted to GP & CP and Converted to other currencies")
;~ $bCurrRefresh = GUICtrlCreateButton("", 340, 2, 24, 24, $BS_ICON)
;~ GUICtrlSetImage(-1, $iconsIcl, 5, 0)

;~ GUICtrlSetGraphic($hGraphic, $GUI_GR_MOVE, 15, 33)
;~ GUICtrlSetGraphic($hGraphic, $GUI_GR_LINE, 215, 33)

$gRemainder = GUICtrlCreateLabel("Remainder", 280, 40)
GUICtrlSetFont(-1, 7.5)
GUICtrlSetState(-1, $GUI_HIDE)

$gSplit = GUICtrlCreateLabel("Split", 340, 40)
GUICtrlSetFont(-1, 7.5)
GUICtrlSetState(-1, $GUI_HIDE)


GUICtrlCreateLabel("CP:", 190, 60, 20, -1, $ES_RIGHT)
$hCP = GUICtrlCreateInput(0, 220, 57, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
$hCPRemainder = GUICtrlCreateInput(0, 280, 57, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_HIDE)
$hCheckCP = GUICtrlCreateCheckbox("", 345, 55, 24, 24)
GUICtrlSetState(-1, $GUI_HIDE)
$hResetCP = GUICtrlCreateButton("", 340, 55, 24, 24, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 10, 0)

GUICtrlCreateLabel("SP:", 190, 90, 20, -1, $ES_RIGHT)
$hSP = GUICtrlCreateInput(0, 220, 87, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
$hSPRemainder = GUICtrlCreateInput(0, 280, 87, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_HIDE)
$hCheckSP = GUICtrlCreateCheckbox("", 345, 85, 24, 24)
GUICtrlSetState(-1, $GUI_HIDE)
$hResetSP = GUICtrlCreateButton("", 340, 85, 24, 24, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 10, 0)

GUICtrlCreateLabel("EP:", 190, 120, 20, -1, $ES_RIGHT)
$hEP = GUICtrlCreateInput(0, 220, 117, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
$hEPRemainder = GUICtrlCreateInput(0, 280, 117, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_HIDE)
$hCheckEP = GUICtrlCreateCheckbox("", 345, 115, 24, 24)
GUICtrlSetState(-1, $GUI_HIDE)
$hResetEP = GUICtrlCreateButton("", 340, 115, 24, 24, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 10, 0)

GUICtrlCreateLabel("GP:", 190, 150, 20, -1, $ES_RIGHT)
$hGP = GUICtrlCreateInput(0, 220, 147, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
$hGPRemainder = GUICtrlCreateInput(0, 280, 147, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_HIDE)
$hCheckGP = GUICtrlCreateCheckbox("", 345, 145, 24, 24)
GUICtrlSetState(-1, $GUI_HIDE)
$hResetGP = GUICtrlCreateButton("", 340, 145, 24, 24, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 10, 0)

GUICtrlCreateLabel("PP:", 190, 180, 20, -1, $ES_RIGHT)
$hPP = GUICtrlCreateInput(0, 220, 177, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
$hPPRemainder = GUICtrlCreateInput(0, 280, 177, 50, -1, BitOR($ES_READONLY, $ES_RIGHT, $ES_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_HIDE)
$hCheckPP = GUICtrlCreateCheckbox("", 345, 175, 24, 24)
GUICtrlSetState(-1, $GUI_HIDE)
$hResetPP = GUICtrlCreateButton("", 340, 175, 24, 24, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 10, 0)

;~ $hLeftLabel = GUICtrlCreateLabel("Left Over:", 190,193,80,-1,$ES_RIGHT)
;~ GUICtrlSetState(-1, $GUI_HIDE)
;~ $hCurrLeftover = GUICtrlCreateInput(0, 280, 190, 50, -1, BitOR($ES_READONLY, $ES_RIGHT))
;~ GUICtrlSetState(-1, $GUI_HIDE)

$hResetAll = GUICtrlCreateButton("Clear All", 195, 209, 80, 18)

;;Arrow for extending Split Calulations
$bExtend = GUICtrlCreateButton("", 340, 206, 24, 24, $BS_ICON)
GUICtrlSetImage(-1, $iconsIcl, 17, 0)

GUICtrlSetGraphic($hGraphic, $GUI_GR_MOVE, 190, 5)
GUICtrlSetGraphic($hGraphic, $GUI_GR_LINE, 190, 225)

GUICtrlCreateLabel("Group Split", 380, 5, 150)
GUICtrlSetFont(-1, 12, 700)


;~ GUICtrlCreateLabel("Current Total: ", 380, 40, 70, -1, $ES_RIGHT)
;~ GUICtrlCreateInput("", 455, 37, 80, 60, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))

GUICtrlCreateLabel("Party Members:", 375, 30, 75, -1, $ES_RIGHT)
$hPartyMembers = GUICtrlCreateInput(2, 455, 27, 60, -1, BitOR($ES_NUMBER, $ES_READONLY, $ES_RIGHT))
$hPartyUpDown = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 10, 2)

GUICtrlCreateLabel("Individual Cut:", 375, 55, 75, -1, $ES_RIGHT)
$hIndivdualCut = GUICtrlCreateEdit("", 455, 52, 80, 80, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_READONLY, $WS_VSCROLL));$WS_VSCROLL, $WS_VSCROLL,

GUICtrlCreateLabel("Left over:", 375, 140, 75, -1, $ES_RIGHT)
$hLeftOver = GUICtrlCreateEdit("", 455, 137, 80, 80, $ES_MULTILINE + $ES_WANTRETURN + $ES_READONLY + $WS_VSCROLL)
#EndRegion Main Gui Ctrls

;~ GUICtrlSetState($background,$GUI_Disable)
$GuiPos = WinGetClientSize($hGui)

GUISetState()


$GuiBorder = WinGetPos($hGui)
$GuiBorder[2] -= $GuiPos[0]
$GuiBorder[3] -= $GuiPos[1]

Local $accelKeys[33][2] = [["{NUMPADDOT}", $calcDecimal], ["{NUMPADMULT}", $calcMultiply], ["{NUMPADSUB}", $calcMinus], ["{NUMPADADD}", $calcAdd], ["{NUMPADDIV}", $calcDivide], ["{NUMPAD0}", $numArray[0]], ["{NUMPAD1}", $numArray[1]], ["{NUMPAD2}", $numArray[2]], ["{NUMPAD3}", $numArray[3]], ["{NUMPAD4}", $numArray[4]], ["{NUMPAD5}", $numArray[5]], ["{NUMPAD6}", $numArray[6]], ["{NUMPAD7}", $numArray[7]], ["{NUMPAD8}", $numArray[8]], ["{NUMPAD9}", $numArray[9]], ["{ENTER}", $calcEquals], ["{BACKSPACE}", $calcBackspace], ["{DELETE}", $calcClear], ["{c}", $calcCP], ["{s}", $calcSP], ["{e}", $calcEP], ["{g}", $calcGP], ["{p}", $calcPP], ["{1}", $numArray[1]], ["{2}", $numArray[2]], ["{3}", $numArray[3]], ["{4}", $numArray[4]], ["{5}", $numArray[5]], ["{6}", $numArray[6]], ["{7}", $numArray[7]], ["{8}", $numArray[8]], ["{9}", $numArray[9]], ["{0}", $numArray[0]]]
;~ Local $numpadAccel[15][2] = [;;Above is required to be in the same Array for some reason?
;~ Local $variousAccel[8][2] = []
;~ Local $numModifiers[4][2] = []

;~ GUISetAccelerators($numModifiers)

GUISetAccelerators($accelKeys)



While 1
	$msg = GUIGetMsg(1)
	Switch $msg[1]
		Case $hGui
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					ExitLoop
				Case $bExtend
					$GuiPos = WinGetClientSize($hGui)
					If $GuiPos[0] = 560 Then ;If Large form factor change to small
						WinMove($winTitle, "", Default, Default, 370 + $GuiBorder[2], 230 + $GuiBorder[3])
					Else ; Else if small form factor change to large..
						WinMove($winTitle, "", Default, Default, 560 + $GuiBorder[2], 230 + $GuiBorder[3])
					EndIf
					;ConsoleWrite($GuiPos[0] &@LF & $GuiPos[1] &@LF)

				Case $calcAdd
					ModifierPressed("+")
				Case $calcMultiply
					ModifierPressed("*")
				Case $calcMinus
					ModifierPressed("-")
				Case $calcDivide
					ModifierPressed("/")
				Case $calcEquals
					Calculate()
				Case $calcCP
					If $calcMode = "Second Number" Then Calculate()
					If $convertMode Then
						ConsoleWrite("Test &@LF" & @LF)
						GUICtrlSetData($hCP, GUICtrlRead($hCP) + $calcFirstNumber)
						SplitUpdate(False, $calcCP, $calcFirstNumber)
						_Convert($calcCP)
					Else
						CurrencyAdd($msg[0], $calcFirstNumber)
					EndIf
					$calcOnZero = True
					$calcFirstNumber = 0
					GUICtrlSetData($calcDisplay, $calcFirstNumber)
				Case $calcSP
					If $calcMode = "Second Number" Then Calculate()
					If $convertMode Then
						GUICtrlSetData($hSP, GUICtrlRead($hSP) + $calcFirstNumber)
						SplitUpdate(False, $calcSP, $calcFirstNumber)
						_Convert($calcSP)
					Else
						CurrencyAdd($msg[0], $calcFirstNumber)
					EndIf
					$calcOnZero = True
					$calcFirstNumber = 0
					GUICtrlSetData($calcDisplay, $calcFirstNumber)

				Case $calcEP
					If $calcMode = "Second Number" Then Calculate()
					If $convertMode Then
						GUICtrlSetData($hEP, GUICtrlRead($hEP) + $calcFirstNumber)
						SplitUpdate(False, $calcEP, $calcFirstNumber)
						_Convert($calcEP)
					Else
						CurrencyAdd($msg[0], $calcFirstNumber)
					EndIf
					$calcOnZero = True
					$calcFirstNumber = 0
					GUICtrlSetData($calcDisplay, $calcFirstNumber)
				Case $calcGP
					If $calcMode = "Second Number" Then Calculate()
					If $convertMode Then
						GUICtrlSetData($hGP, GUICtrlRead($hGP) + $calcFirstNumber)
						SplitUpdate(False, $calcGP, $calcFirstNumber)
						_Convert($calcGP)
					Else
						CurrencyAdd($msg[0], $calcFirstNumber)
					EndIf
					$calcOnZero = True
					$calcFirstNumber = 0
					GUICtrlSetData($calcDisplay, $calcFirstNumber)
				Case $calcPP
					If $calcMode = "Second Number" Then Calculate()
					If $convertMode Then
						GUICtrlSetData($hPP, GUICtrlRead($hPP) + $calcFirstNumber)
						SplitUpdate(False, $calcPP, $calcFirstNumber)
						_Convert($calcPP)
					Else
						CurrencyAdd($msg[0], $calcFirstNumber)
					EndIf
					$calcOnZero = True
					$calcFirstNumber = 0
					GUICtrlSetData($calcDisplay, $calcFirstNumber)
				Case $hResetAll
					GUICtrlSetData($hCP, 0)
					GUICtrlSetData($hSP, 0)
					GUICtrlSetData($hEP, 0)
					GUICtrlSetData($hGP, 0)
					GUICtrlSetData($hPP, 0)

					GUICtrlSetData($hCPRemainder, 0)
					GUICtrlSetData($hSPRemainder, 0)
					GUICtrlSetData($hEPRemainder, 0)
					GUICtrlSetData($hGPRemainder, 0)
					GUICtrlSetData($hPPRemainder, 0)
					SplitUpdate()
				Case $hResetCP
					GUICtrlSetData($hCP, 0)
					SplitUpdate()
				Case $hResetSP
					GUICtrlSetData($hSP, 0)
					SplitUpdate()
				Case $hResetEP
					GUICtrlSetData($hEP, 0)
					SplitUpdate()
				Case $hResetGP
					GUICtrlSetData($hGP, 0)
					SplitUpdate()
				Case $hResetPP
					GUICtrlSetData($hPP, 0)
					SplitUpdate()
				Case $checkExchange
						if GUICtrlread($checkConvert) = $GUI_CHECKED Then
							CurrencyAdd($calcCP,0,1)
							SplitUpdate()
						Else
							CurrencyAdd($calcCP)
						EndIf
							_GUI_ExchangeConvert($msg[0])



				Case $checkConvert ;;;; -- Allow this to check wahts already in the field and convert it at Gold\Copper rates (So its always divisible..)
					_GUI_ExchangeConvert($msg[0])
					If $convertMode Then
						Select
							Case GUICtrlRead($hCheckCP) = $GUI_CHECKED
								SplitUpdate(False, $calcCP)
							Case GUICtrlRead($hCheckSP) = $GUI_CHECKED
								SplitUpdate(False, $calcSP)
							Case GUICtrlRead($hCheckEP) = $GUI_CHECKED
								SplitUpdate(False, $calcEP)
							Case GUICtrlRead($hCheckGP) = $GUI_CHECKED
								SplitUpdate(False, $calcGP)
							Case GUICtrlRead($hCheckPP) = $GUI_CHECKED
								SplitUpdate(False, $calcPP)
						EndSelect
					EndIf
				Case $hCheckCP
					_ConvertCheckboxes($calcCP)
					SplitUpdate(False, $calcCP)
				Case $hCheckSP
					_ConvertCheckboxes($calcSP)
					SplitUpdate(False, $calcSP)
				Case $hCheckEP
					_ConvertCheckboxes($calcEP)
					SplitUpdate(False, $calcEP)
				Case $hCheckGP
					_ConvertCheckboxes($calcGP)
					SplitUpdate(False, $calcGP)
				Case $hCheckPP
					_ConvertCheckboxes($calcPP)
					SplitUpdate(False, $calcPP)
				Case $hPartyUpDown
					If $convertMode Then
						Select
							Case GUICtrlRead($hCheckCP) = $GUI_CHECKED
								SplitUpdate(False, $calcCP)
							Case GUICtrlRead($hCheckSP) = $GUI_CHECKED
								SplitUpdate(False, $calcSP)
							Case GUICtrlRead($hCheckEP) = $GUI_CHECKED
								SplitUpdate(False, $calcEP)
							Case GUICtrlRead($hCheckGP) = $GUI_CHECKED
								SplitUpdate(False, $calcGP)
							Case GUICtrlRead($hCheckPP) = $GUI_CHECKED
								SplitUpdate(False, $calcPP)
						EndSelect
						Else
						SplitUpdate(False)
					EndIf

				Case $calcClearEntry
					Switch $calcMode
						Case "First Number"
							$calcFirstNumber = 0
							$calcOnZero = True
							GUICtrlSetData($calcDisplay, $calcFirstNumber)
						Case "Modifier"
							$calcMode = "First Number"
							GUICtrlSetData($calcDisplay, $calcFirstNumber)
						Case "Second Number"
							$calcMode = "Modifier"
							$calcSecondNumber = ""
							GUICtrlSetData($calcDisplay, $calcFirstNumber & $calcModifier)

					EndSwitch
				Case $calcClear
					$calcFirstNumber = 0
					$calcOnZero = True
					$calcMode = "First Number"
					$calcModifier = ""
					$calcSecondNumber = ""
					GUICtrlSetData($calcHistory, "")
					$firstHistory = True
					GUICtrlSetData($calcDisplay, $calcFirstNumber)
				Case $calcBackspace
					Switch $calcMode
						Case "First Number"
							If $calcOnZero Then
								If $calcFirstNumber <> 0 Then
									$calcFirstNumber = StringLeft($calcFirstNumber, StringLen($calcFirstNumber) - 1)
									$calcOnZero = False
								EndIf
							Else
								$calcFirstNumber = StringLeft($calcFirstNumber, StringLen($calcFirstNumber) - 1)
							EndIf
							If $calcFirstNumber = "" Then
								$calcFirstNumber = 0
								$calcOnZero = True
							EndIf

							GUICtrlSetData($calcDisplay, $calcFirstNumber)

						Case "Modifier"
							$calcMode = "First Number"
							GUICtrlSetData($calcDisplay, $calcFirstNumber)
						Case "Second Number"
							$calcSecondNumber = StringLeft($calcSecondNumber, StringLen($calcSecondNumber) - 1)
							If $calcSecondNumber = "" Then
								$calcMode = "Modifier"
								GUICtrlSetData($calcDisplay, $calcFirstNumber & $calcModifier)
							Else
								GUICtrlSetData($calcDisplay, $calcFirstNumber & $calcModifier & $calcSecondNumber)
							EndIf
					EndSwitch
				Case $calcDecimal
					Switch $calcMode
						Case "First Number"
							If $calcOnZero Then
								GUICtrlSetData($calcDisplay, ".")
								$calcOnZero = False
								$calcFirstNumber = "."
								$calcSecondNumber = ""
								$calcModifier = ""
							Else
								$calcFirstNumber &= "."
								GUICtrlSetData($calcDisplay, GUICtrlRead($calcDisplay) & ".")
							EndIf
						Case "Modifier"
							$calcMode = "Second Number"
							$calcSecondNumber = "."
							GUICtrlSetData($calcDisplay, GUICtrlRead($calcDisplay) & ".")
						Case "Second Number"
							$calcSecondNumber &= "."
							GUICtrlSetData($calcDisplay, GUICtrlRead($calcDisplay) & ".")
					EndSwitch
			EndSwitch
			For $a = 0 To 9
				If $msg[0] = $numArray[$a] Then
;~ 					if $calcOnZero Then
;~ 						GUICtrlSetData($calcDisplay, $a)
;~ 						$calcOnZero = False
;~ 					Else
;~ 						GUICtrlSetData($calcDisplay, GUICtrlRead($calcDisplay) & $a)
;~ 					EndIf
					Switch $calcMode
						Case "First Number"
							If $calcOnZero Then
								GUICtrlSetData($calcDisplay, $a)
								$calcOnZero = False
								$calcFirstNumber = $a
								$calcSecondNumber = ""
								$calcModifier = ""
							Else
								$calcFirstNumber &= $a
								GUICtrlSetData($calcDisplay, GUICtrlRead($calcDisplay) & $a)
							EndIf
						Case "Modifier"
							$calcMode = "Second Number"
							$calcSecondNumber = $a
							GUICtrlSetData($calcDisplay, GUICtrlRead($calcDisplay) & $a)
						Case "Second Number"
							$calcSecondNumber &= $a
							GUICtrlSetData($calcDisplay, GUICtrlRead($calcDisplay) & $a)
					EndSwitch
				EndIf

			Next

	EndSwitch

	If $calcMode <> $calcLastMode Then CheckMode()

	Sleep(10)
WEnd

Func ReturnCurrency($iString)
	Select
		Case StringInStr($iString, "CP")
			Dim $iArray[2] = ["CP", 100]
			Return $iArray
		Case StringInStr($iString, "SP")
			Dim $iArray[2] = ["SP", 10]
			Return $iArray
		Case StringInStr($iString, "EP")
			Dim $iArray[2] = ["EP", 2]
			Return $iArray
		Case StringInStr($iString, "GP")
			Dim $iArray[2] = ["GP", 1]
			Return $iArray
		Case StringInStr($iString, "PP")
			Dim $iArray[2] = ["PP", .1]
			Return $iArray
	EndSelect
EndFunc   ;==>ReturnCurrency

Func _Convert($iCurr)
	GUICtrlSetData($hCPRemainder, 0)
	GUICtrlSetData($hSPRemainder, 0)
	GUICtrlSetData($hEPRemainder, 0)
	GUICtrlSetData($hGPRemainder, 0)
	GUICtrlSetData($hPPRemainder, 0)
	Switch $iCurr
		Case $calcCP

			$iDecimal = CurrencyConverter(GUICtrlRead($hCP) & " CP")
			$iDecimal = $iDecimal[0] * 100

			GUICtrlSetData($hSP, Int($iDecimal / 10))
			If Mod($iDecimal, 10) <> 0 Then GUICtrlSetData($hSPRemainder, Mod($iDecimal, 10) & " CP")

			GUICtrlSetData($hEP, Int($iDecimal / 50))
			If Mod($iDecimal, 50) <> 0 Then GUICtrlSetData($hEPRemainder, Mod($iDecimal, 50) & " CP")

			GUICtrlSetData($hGP, Int($iDecimal / 100))
			If Mod($iDecimal, 100) <> 0 Then GUICtrlSetData($hGPRemainder, Mod($iDecimal, 100) & " CP")

			GUICtrlSetData($hPP, Int($iDecimal / 1000))
			If Mod($iDecimal, 1000) <> 0 Then GUICtrlSetData($hPPRemainder, Mod($iDecimal, 1000) & " CP")
		Case $calcSP

			$iDecimal = CurrencyConverter(GUICtrlRead($hSP) & " SP")

			$iDecimal = $iDecimal[0] * 10

			GUICtrlSetData($hCP, Int($iDecimal * 10))
			;GUICtrlSetData($hCPRemainder,Mod($iDecimal,10)& " CP")

			GUICtrlSetData($hEP, Int($iDecimal / 5))
			If Mod($iDecimal, 5) <> 0 Then GUICtrlSetData($hEPRemainder, Mod($iDecimal, 5) & " SP")

			GUICtrlSetData($hGP, Int($iDecimal / 10))
			If Mod($iDecimal, 100) <> 0 Then GUICtrlSetData($hGPRemainder, Mod($iDecimal, 10) & " SP")

			GUICtrlSetData($hPP, Int($iDecimal / 100))
			If Mod($iDecimal, 100) <> 0 Then GUICtrlSetData($hPPRemainder, Mod($iDecimal, 100) & " SP")
		Case $calcEP


			$iDecimal = CurrencyConverter(GUICtrlRead($hEP) & " EP")

			$iDecimal = $iDecimal[0] * 2

			GUICtrlSetData($hCP, Int($iDecimal * 50))

			GUICtrlSetData($hSP, Int($iDecimal * 5))

			GUICtrlSetData($hGP, Int($iDecimal / 2))
			If Mod($iDecimal, 2) <> 0 Then GUICtrlSetData($hGPRemainder, Mod($iDecimal, 2) & " EP")

			GUICtrlSetData($hPP, Int($iDecimal / 20))
			If Mod($iDecimal, 20) <> 0 Then GUICtrlSetData($hPPRemainder, Mod($iDecimal, 20) & " EP")
		Case $calcGP

			$iDecimal = CurrencyConverter(GUICtrlRead($hGP) & " GP")

			$iDecimal = $iDecimal[0]

			GUICtrlSetData($hCP, Int($iDecimal * 100))

			GUICtrlSetData($hSP, Int($iDecimal * 10))

			GUICtrlSetData($hEP, Int($iDecimal * 2))

			GUICtrlSetData($hPP, Int($iDecimal / 10))
			If Mod($iDecimal, 10) <> 0 Then GUICtrlSetData($hPPRemainder, Mod($iDecimal, 10) & " GP")
		Case $calcPP

			$iDecimal = CurrencyConverter(GUICtrlRead($hPP) & " PP", True, False, 1)

			$iDecimal = $iDecimal[0]

			GUICtrlSetData($hCP, Int($iDecimal * 100))

			GUICtrlSetData($hSP, Int($iDecimal * 10))

			GUICtrlSetData($hEP, Int($iDecimal * 2))

			GUICtrlSetData($hGP, Int($iDecimal))

	EndSwitch
	_ConvertCheckboxes($iCurr)
EndFunc   ;==>_Convert

Func _GUI_ExchangeConvert($iMsg)
	$clear = False
	Switch $iMsg
		Case $checkExchange
			If GUICtrlRead($checkExchange) = $GUI_CHECKED Then
				if GUICtrlread($checkConvert) = $GUI_CHECKED Then $clear = True
				GUICtrlSetState($checkConvert, $GUI_UNCHECKED)
				$exchangeMode = True
				$convertMode = False
			Else
				$exchangeMode = False
			EndIf
		Case $checkConvert
			If GUICtrlRead($checkConvert) = $GUI_CHECKED Then
				GUICtrlSetState($checkExchange, $GUI_UNCHECKED)
				$exchangeMode = False
				$convertMode = True
			Else
				GUICtrlSetData($hSP,0)
				GUICtrlSetData($hEP,0)
				GUICtrlSetData($hGP,0)
				GUICtrlSetData($hPP,0)
				$convertMode = False
				$clear = True
			EndIf
	EndSwitch

	Switch $convertMode
		Case True
			GUICtrlSetState($hCPRemainder, $GUI_SHOW)
			GUICtrlSetState($hSPRemainder, $GUI_SHOW)
			GUICtrlSetState($hEPRemainder, $GUI_SHOW)
			GUICtrlSetState($hGPRemainder, $GUI_SHOW)
			GUICtrlSetState($hPPRemainder, $GUI_SHOW)

			GUICtrlSetState($hCheckCP, $GUI_SHOW)
			GUICtrlSetState($hCheckSP, $GUI_SHOW)
			GUICtrlSetState($hCheckEP, $GUI_SHOW)
			GUICtrlSetState($hCheckGP, $GUI_SHOW)
			GUICtrlSetState($hCheckPP, $GUI_SHOW)

			GUICtrlSetState($gRemainder, $GUI_SHOW)
			GUICtrlSetState($gSplit, $GUI_SHOW)

			GUICtrlSetState($hResetCP, $GUI_HIDE)
			GUICtrlSetState($hResetSP, $GUI_HIDE)
			GUICtrlSetState($hResetEP, $GUI_HIDE)
			GUICtrlSetState($hResetGP, $GUI_HIDE)
			GUICtrlSetState($hResetPP, $GUI_HIDE)

			Dim $conversion[5][2]
			$icount = 0
			If GUICtrlRead($hCP) <> 0 Then
				$conversion[$icount][0] = GUICtrlRead($hCP) & " CP"
				$conversion[$icount][1] = $calcCP
				$icount += 1
			EndIf
			If GUICtrlRead($hSP) <> 0 Then
				$conversion[$icount][0] = GUICtrlRead($hSP) & " SP"
				$conversion[$icount][1] = $calcSP
				$icount += 1
			EndIf
			If GUICtrlRead($hEP) <> 0 Then
				$conversion[$icount][0] = GUICtrlRead($hEP) & " EP"
				$conversion[$icount][1] = $calcEP
				$icount += 1
			EndIf
			If GUICtrlRead($hGP) <> 0 Then
				$conversion[$icount][0] = GUICtrlRead($hGP) & " GP"
				$conversion[$icount][1] = $calcGP
				$icount += 1
			EndIf
			If GUICtrlRead($hPP) <> 0 Then
				$conversion[$icount][0] = GUICtrlRead($hPP) & " PP"
				$conversion[$icount][1] = $calcPP
				$icount += 1
			EndIf

			Switch $icount
				Case 1
					_Convert($conversion[0][1])
				Case 2 To 5

					Dim $convArray[$icount]
					For $i = 0 To $icount - 1
						$convArray[$i] = $conversion[$i][0]
					Next
					$iDecimal = CurrencyConverter($convArray)

					$iDecimal = $iDecimal[0] * 100

					GUICtrlSetData($hCP, Int($iDecimal))

					GUICtrlSetData($hSP, Int($iDecimal / 10))
					If Mod($iDecimal, 10) <> 0 Then GUICtrlSetData($hSPRemainder, Round(Mod($iDecimal, 10),2) & " CP")

					GUICtrlSetData($hEP, Int($iDecimal / 50))
					If Mod($iDecimal, 50) <> 0 Then GUICtrlSetData($hEPRemainder, Round(Mod($iDecimal, 50),2) & " CP")

					GUICtrlSetData($hGP, Int($iDecimal / 100))
					If Mod($iDecimal, 100) <> 0 Then GUICtrlSetData($hGPRemainder, Round(Mod($iDecimal, 100),2) & " CP")

					GUICtrlSetData($hPP, Int($iDecimal / 1000))
					If Mod($iDecimal, 100) <> 0 Then GUICtrlSetData($hPPRemainder, Round(Mod($iDecimal, 100),2) & " CP")
			EndSwitch



		Case False
			GUICtrlSetState($hCPRemainder, $GUI_HIDE)
			GUICtrlSetState($hSPRemainder, $GUI_HIDE)
			GUICtrlSetState($hEPRemainder, $GUI_HIDE)
			GUICtrlSetState($hGPRemainder, $GUI_HIDE)
			GUICtrlSetState($hPPRemainder, $GUI_HIDE)

			GUICtrlSetState($hCheckCP, $GUI_HIDE)
			GUICtrlSetState($hCheckSP, $GUI_HIDE)
			GUICtrlSetState($hCheckEP, $GUI_HIDE)
			GUICtrlSetState($hCheckGP, $GUI_HIDE)
			GUICtrlSetState($hCheckPP, $GUI_HIDE)

			GUICtrlSetState($gRemainder, $GUI_HIDE)
			GUICtrlSetState($gSplit, $GUI_HIDE)

			GUICtrlSetState($hResetCP, $GUI_SHOW)
			GUICtrlSetState($hResetSP, $GUI_SHOW)
			GUICtrlSetState($hResetEP, $GUI_SHOW)
			GUICtrlSetState($hResetGP, $GUI_SHOW)
			GUICtrlSetState($hResetPP, $GUI_SHOW)
	EndSwitch

EndFunc   ;==>_GUI_ExchangeConvert

Func _ConvertCheckboxes($iMsg)
	Switch $iMsg
		Case $calcCP
			GUICtrlSetState($hCheckCP, $GUI_CHECKED)
			GUICtrlSetState($hCheckSP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckEP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckGP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckPP, $GUI_UNCHECKED)
		Case $calcSP
			GUICtrlSetState($hCheckCP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckSP, $GUI_CHECKED)
			GUICtrlSetState($hCheckEP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckGP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckPP, $GUI_UNCHECKED)
		Case $calcEP
			GUICtrlSetState($hCheckCP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckSP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckEP, $GUI_CHECKED)
			GUICtrlSetState($hCheckGP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckPP, $GUI_UNCHECKED)
		Case $calcGP
			GUICtrlSetState($hCheckCP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckSP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckEP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckGP, $GUI_CHECKED)
			GUICtrlSetState($hCheckPP, $GUI_UNCHECKED)
		Case $calcPP
			GUICtrlSetState($hCheckCP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckSP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckEP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckGP, $GUI_UNCHECKED)
			GUICtrlSetState($hCheckPP, $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>_ConvertCheckboxes

Func CurrencyAdd($iCurrency, $addition = 0, $convertCopper = 0)
	ConsoleWrite("$convertCopper = " & $convertCopper & @LF)
	Local $iExchange = GUICtrlRead($checkExchange)

	if $convertCopper Then
		$toBeConverted = SplitUpdate(True, $iCurrency, $addition,True)
Else

	$toBeConverted = SplitUpdate(True, $iCurrency, $addition)
EndIf
	If $iExchange = $GUI_UNCHECKED Then
		Switch $iCurrency
			Case $calcCP
				GUICtrlSetData($hCP, Round(GUICtrlRead($hCP) + $addition,2))
			Case $calcSP
				GUICtrlSetData($hSP, Round(GUICtrlRead($hSP) + $addition,2))
			Case $calcEP
				GUICtrlSetData($hEP, Round(GUICtrlRead($hEP) + $addition,2))
			Case $calcGP
				GUICtrlSetData($hGP, Round(GUICtrlRead($hGP) + $addition,2))
			Case $calcPP
				GUICtrlSetData($hPP, Round(GUICtrlRead($hPP) + $addition,2))
		EndSwitch
	Else
		ConsoleWrite("Checked " & @LF)
		If $iCurrency = $calcPP Then
			GUICtrlSetData($hPP, GUICtrlRead($hPP) + $addition)
		Else
			$Converted = CurrencyConverter($toBeConverted, False)

			GUICtrlSetData($hCP, 0)
			GUICtrlSetData($hSP, 0)
			GUICtrlSetData($hEP, 0)
			GUICtrlSetData($hGP, 0)
			if $convertCopper Then GUICtrlSetData($hPP, 0)
;~
			For $i = 0 To UBound($Converted) - 1
				Select
					Case StringInStr($Converted[$i], "CP")
						$totalCP = GUICtrlRead($hCP) + StringReplace($Converted[$i], " CP", "")
						GUICtrlSetData($hCP, Round($totalCP,2));GUICtrlRead($hCP) + StringReplace($Converted[$i], " CP", ""))
					Case StringInStr($Converted[$i], "SP")
						GUICtrlSetData($hSP, Round(GUICtrlRead($hSP),2) + StringReplace($Converted[$i], " SP", ""))
					Case StringInStr($Converted[$i], "EP")
						GUICtrlSetData($hEP, Round(GUICtrlRead($hEP),2) + StringReplace($Converted[$i], " EP", ""))
					Case StringInStr($Converted[$i], "GP")
						GUICtrlSetData($hGP, Round(GUICtrlRead($hGP),2) + StringReplace($Converted[$i], " GP", ""))
				EndSelect
			Next
		EndIf

	EndIf
EndFunc   ;==>CurrencyAdd

Func SplitUpdate($addFirst = False, $aCurrency = "", $addition = 0, $convertCopper = False)
Dim $toBeConverted[4]
	if Not($convertCopper) Then

	$toBeConverted[0] = GUICtrlRead($hCP) & " CP"
	$toBeConverted[1] = GUICtrlRead($hSP) & " SP"
	$toBeConverted[2] = GUICtrlRead($hEP) & " EP"
	$toBeConverted[3] = GUICtrlRead($hGP) & " GP"
	Else

	$toBeConverted[0] = GUICtrlRead($hCP) & " CP"
	EndIf

	$partyMembers = GUICtrlRead($hPartyMembers)
	$ppSplit = 0
	$ppExtra = 0
	$GpSplit = 0
	$GpExtra = 0
	$EpSplit = 0
	$EpExtra = 0
	$SpSplit = 0
	$SpExtra = 0
	$cpSplit = 0
	$cpExtra = 0
	$currPP = 0
	$currGP = 0
	$currEP = 0
	$currSP = 0
	$currCP = 0

	GUICtrlSetData($hIndivdualCut, "")
	GUICtrlSetData($hLeftOver, "")


	Local $iExchange = GUICtrlRead($checkExchange)

	If $iExchange = $GUI_CHECKED Then
		If $addFirst Then
			Switch $aCurrency
				Case $calcCP
					$curr = "CP"
					$toBeConverted[0] = (GUICtrlRead($hCP) + $addition) & " CP"
				Case $calcSP
					$curr = "SP"
					$toBeConverted[1] = (GUICtrlRead($hSP) + $addition) & " SP"
				Case $calcEP
					$curr = "EP"
					$toBeConverted[2] = (GUICtrlRead($hEP) + $addition) & " EP"
				Case $calcGP
					$curr = "GP"
					$toBeConverted[3] = (GUICtrlRead($hGP) + $addition) & " GP"
				Case $calcPP
					$curr = "PP"
					$ppSplit = Int((GUICtrlRead($hPP) + $addition) / $partyMembers)
					$ppExtra = Mod(GUICtrlRead($hPP) + $addition, $partyMembers)
			EndSwitch

		EndIf
		If GUICtrlRead($hPP) <> 0 And ($ppExtra = 0 And $ppSplit = 0) Then
			$ppSplit = Int((GUICtrlRead($hPP)) / $partyMembers)
			$ppExtra = Mod(GUICtrlRead($hPP), $partyMembers)
		EndIf


		If $ppSplit <> 0 Then GUICtrlSetData($hIndivdualCut, Round($ppSplit,2) & " PP" & @CRLF)
		If $ppExtra <> 0 Then GUICtrlSetData($hLeftOver, Round($ppExtra,2) & " PP" & @CRLF)

		ConsoleWrite("PPSplit: " & $ppSplit & @LF & "PPEXTRA " & $ppExtra & @LF)



		$decConverted = CurrencyConverter($toBeConverted, True)
		$decConverted = $decConverted[0] * 100



		$decMod = Mod($decConverted, $partyMembers) / 100
		$decSplit = Int($decConverted / $partyMembers) / 100

		$currSplit = CurrencyConverter($decSplit, False, True, 1)
		$currExtra = CurrencyConverter($decMod, False, True)

		ConsoleWrite("-------------" & @LF _
				 & "Dec Converted = " & $decConverted & @LF _
				 & "Party Members = " & $partyMembers & @LF _
				 & "Individual Split in dec form = " & $decSplit & @LF _
				 & "Individual Split in text form = " & _ArrayToString($currSplit, @CRLF) & @LF _
				 & "Left over in GP Decimal = " & $decMod & @LF)



		If $decSplit <> 0 Then

			If ($ppExtra = 0 And $ppSplit = 0) Then GUICtrlSetData($hIndivdualCut, "")
			For $i = 0 To UBound($currSplit) - 1
				If $i = 0 And ($ppExtra = 0 And $ppSplit = 0) Then
					GUICtrlSetData($hIndivdualCut, $currSplit[$i] & @CRLF)
				Else
					GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & $currSplit[$i] & @CRLF)
				EndIf
			Next
		ElseIf ($ppExtra = 0 And $ppSplit = 0) Then
			GUICtrlSetData($hIndivdualCut, "")
		EndIf
		If $decMod <> 0 Then
			If ($ppExtra = 0 And $ppSplit = 0) Then GUICtrlSetData($hLeftOver, "")
			For $i = 0 To UBound($currExtra) - 1
				If $i = 0 And ($ppExtra = 0 And $ppSplit = 0) Then
					GUICtrlSetData($hLeftOver, $currExtra[$i] & @CRLF)
				Else
					GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & $currExtra[$i] & @CRLF)
				EndIf

			Next
		ElseIf ($ppExtra = 0 And $ppSplit = 0) Then
			GUICtrlSetData($hLeftOver, "")
		EndIf
	Else
		$currCP = GUICtrlRead($hCP)
		$currSP = GUICtrlRead($hSP)
		$currEP = GUICtrlRead($hEP)
		$currGP = GUICtrlRead($hGP)
		$currPP = GUICtrlRead($hPP)
		If $addFirst Then
			Switch $aCurrency
				Case $calcCP
					$curr = "CP"
					$currCP = (GUICtrlRead($hCP) + $addition)
				Case $calcSP
					$curr = "SP"
					$currSP = (GUICtrlRead($hSP) + $addition)
				Case $calcEP
					$curr = "EP"
					$currEP = (GUICtrlRead($hEP) + $addition)
				Case $calcGP
					$curr = "GP"
					$currGP = (GUICtrlRead($hGP) + $addition)
				Case $calcPP
					$curr = "PP"
					$currPP = GUICtrlRead($hPP) + $addition
			EndSwitch
		Else

		EndIf
		If $convertMode = False Then
			If $currPP <> 0 Then
				$ppSplit = Int($currPP / $partyMembers)
				$ppExtra = Mod($currPP, $partyMembers)
			EndIf
			If $ppSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($ppSplit,2) & " PP" & @CRLF)
			If $ppExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($ppExtra,2) & " PP" & @CRLF)

			If $currGP <> 0 Then
				$GpSplit = Int($currGP / $partyMembers)
				$GpExtra = Mod($currGP, $partyMembers)
			EndIf
			If $GpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($GpSplit,2) & " GP" & @CRLF)
			If $GpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($GpExtra,2) & " GP" & @CRLF)

			If $currEP <> 0 Then
				$EpSplit = Int($currEP / $partyMembers)
				$EpExtra = Mod($currEP, $partyMembers)
			EndIf
			If $EpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($EpSplit,2) & " EP" & @CRLF)
			If $EpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($EpExtra,2) & " EP" & @CRLF)

			If $currSP <> 0 Then
				$SpSplit = Int($currSP / $partyMembers)
				$SpExtra = Mod($currSP, $partyMembers)
			EndIf
			If $SpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($SpSplit,2) & " SP" & @CRLF)
			If $SpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($SpExtra,2) & " SP" & @CRLF)

			If $currCP <> 0 Then
				$cpSplit = Int($currCP / $partyMembers)
				$cpExtra = Mod($currCP, $partyMembers)
			EndIf
			If $cpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($cpSplit,2) & " CP")
			If $cpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($cpExtra,2) & " CP")
		Else
			$remainderSplit = 0
			$remainderCurr = ""
			$remainderExtra = 0

			$currCPRemainder = GUICtrlRead($hCPRemainder)
			$currSPRemainder = GUICtrlRead($hSPRemainder)
			$currEPRemainder = GUICtrlRead($hEPRemainder)
			$currGPRemainder = GUICtrlRead($hGPRemainder)
			$currPPRemainder = GUICtrlRead($hPPRemainder)

			Switch $aCurrency
				Case $calcCP

					If $currCP <> 0 Then
						$cpSplit = Int($currCP / $partyMembers)
						$cpExtra = Mod($currCP, $partyMembers)
						If GUICtrlRead($hCPRemainder) <> 0 Then
							$remainderDec = CurrencyConverter(GUICtrlRead($hCPRemainder))
							$remainderCurr = ReturnCurrency(GUICtrlRead($hCPRemainder))
							$remainderDec[0] *= $remainderCurr[1]
							$remainderSplit = Int($remainderDec[0] / $partyMembers)
							$remainderExtra = Mod($remainderDec[0], $partyMembers)
						EndIf
					EndIf
					If $cpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($cpSplit,2) & " CP")
					If $cpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($cpExtra,2) & " CP")

					If $remainderSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($remainderSplit,2) & " " & $remainderCurr[0])
					If $remainderExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($remainderExtra,2) & " " & $remainderCurr[0])
				Case $calcSP
					If $currSP <> 0 Or $currSPRemainder <> 0 Then
						$SpSplit = Int($currSP / $partyMembers)
						$SpExtra = Mod($currSP, $partyMembers)
						If GUICtrlRead($hSPRemainder) <> 0 Then
							$remainderDec = CurrencyConverter(GUICtrlRead($hSPRemainder))
							$remainderCurr = ReturnCurrency(GUICtrlRead($hSPRemainder))
							$remainderDec[0] *= $remainderCurr[1]
							$remainderSplit = Int($remainderDec[0] / $partyMembers)
							$remainderExtra = Mod($remainderDec[0], $partyMembers)
						EndIf
					EndIf
					If $SpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($SpSplit,2) & " SP" & @CRLF)
					If $SpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($SpExtra,2) & " SP" & @CRLF)

					If $remainderSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($remainderSplit,2) & " " & $remainderCurr[0])
					If $remainderExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($remainderExtra,2) & " " & $remainderCurr[0])
				Case $calcEP
					If $currEP <> 0 Or $currEPRemainder <> 0 Then
						$EpSplit = Int($currEP / $partyMembers)
						$EpExtra = Mod($currEP, $partyMembers)
						If GUICtrlRead($hEPRemainder) <> 0 Then
							$remainderDec = CurrencyConverter(GUICtrlRead($hEPRemainder))
							$remainderCurr = ReturnCurrency(GUICtrlRead($hEPRemainder))
							$remainderDec[0] *= $remainderCurr[1]
							$remainderSplit = Int($remainderDec[0] / $partyMembers)
							$remainderExtra = Mod($remainderDec[0], $partyMembers)
						EndIf
					EndIf
					If $EpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($EpSplit,2) & " EP" & @CRLF)
					If $EpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($EpExtra,2) & " EP" & @CRLF)

					If $remainderSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($remainderSplit,2) & " " & $remainderCurr[0])
					If $remainderExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($remainderExtra,2) & " " & $remainderCurr[0])
				Case $calcGP
					If $currGP <> 0 Or $currGPRemainder <> 0 Then
						$GpSplit = Int($currGP / $partyMembers)
						$GpExtra = Mod($currGP, $partyMembers)
						If GUICtrlRead($hGPRemainder) <> 0 Then
							$remainderDec = CurrencyConverter(GUICtrlRead($hGPRemainder),true,false,1)
							$remainderCurr = ReturnCurrency(GUICtrlRead($hGPRemainder))
							$remainderDec[0] *= $remainderCurr[1]
							$remainderSplit = Int($remainderDec[0] / $partyMembers)
							$remainderExtra = Mod($remainderDec[0], $partyMembers)
						EndIf
					EndIf
					If $GpSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($GpSplit,2) & " GP" & @CRLF)
					If $GpExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($GpExtra,2) & " GP" & @CRLF)

					If $remainderSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($remainderSplit,2) & " " & $remainderCurr[0])
					If $remainderExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($remainderExtra,2) & " " & $remainderCurr[0])
				Case $calcPP
					If $currPP <> 0 Or $currPPRemainder <> 0 Then
						$ppSplit = Int($currPP / $partyMembers)
						$ppExtra = Mod($currPP, $partyMembers)
						If GUICtrlRead($hPPRemainder) <> 0 Then
							$remainderDec = CurrencyConverter(GUICtrlRead($hPPRemainder))
							$remainderCurr = ReturnCurrency(GUICtrlRead($hPPRemainder))
							$remainderDec[0] *= $remainderCurr[1]
							$remainderSplit = Int($remainderDec[0] / $partyMembers)
							$remainderExtra = Mod($remainderDec[0], $partyMembers)
						EndIf
					EndIf
					If $ppSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($ppSplit,2) & " PP" & @CRLF)
					If $ppExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($ppExtra,2) & " PP" & @CRLF)

					If $remainderSplit <> 0 Then GUICtrlSetData($hIndivdualCut, GUICtrlRead($hIndivdualCut) & Round($remainderSplit,2) & " " & $remainderCurr[0])
					If $remainderExtra <> 0 Then GUICtrlSetData($hLeftOver, GUICtrlRead($hLeftOver) & Round($remainderExtra,2) & " " & $remainderCurr[0])
			EndSwitch
		EndIf

	EndIf


	Return $toBeConverted
EndFunc   ;==>SplitUpdate

Func CheckMode()

	Switch $calcMode
		Case "First Number"
			GUICtrlSetState($calcCP, $GUI_ENABLE)
			GUICtrlSetState($calcSP, $GUI_ENABLE)
			GUICtrlSetState($calcEP, $GUI_ENABLE)
			GUICtrlSetState($calcGP, $GUI_ENABLE)
			GUICtrlSetState($calcPP, $GUI_ENABLE)
		Case "Second Number"
			If $calcSecondNumber <> "" Then
				GUICtrlSetState($calcCP, $GUI_ENABLE)
				GUICtrlSetState($calcSP, $GUI_ENABLE)
				GUICtrlSetState($calcEP, $GUI_ENABLE)
				GUICtrlSetState($calcGP, $GUI_ENABLE)
				GUICtrlSetState($calcPP, $GUI_ENABLE)
			Else
				GUICtrlSetState($calcCP, $GUI_DISABLE)
				GUICtrlSetState($calcSP, $GUI_DISABLE)
				GUICtrlSetState($calcEP, $GUI_DISABLE)
				GUICtrlSetState($calcGP, $GUI_DISABLE)
				GUICtrlSetState($calcPP, $GUI_DISABLE)
			EndIf
		Case Else
			GUICtrlSetState($calcCP, $GUI_DISABLE)
			GUICtrlSetState($calcSP, $GUI_DISABLE)
			GUICtrlSetState($calcEP, $GUI_DISABLE)
			GUICtrlSetState($calcGP, $GUI_DISABLE)
			GUICtrlSetState($calcPP, $GUI_DISABLE)
	EndSwitch
	$calcLastMode = $calcMode
EndFunc   ;==>CheckMode

Func ModifierPressed($modifier)
	Switch $calcMode
		Case "First Number"
			If $calcOnZero And $calcFirstNumber = 0 Then
				If $modifier = "-" Then
					$calcFirstNumber = "-"
					$calcOnZero = False
					GUICtrlSetData($calcDisplay, $calcFirstNumber)
				EndIf
			Else
				$calcModifier = $modifier
				GUICtrlSetData($calcDisplay, $calcFirstNumber & $calcModifier)
				$calcMode = "Modifier"
			EndIf
		Case "Modifier"
			GUICtrlSetData($calcDisplay, StringReplace(GUICtrlRead($calcDisplay), $calcModifier, $modifier))
			$calcModifier = $modifier
		Case "Second Number"
			Calculate()

	EndSwitch
EndFunc   ;==>ModifierPressed

Func Calculate()
	Local $iTotal

	Switch $calcModifier
		Case "+"
			$iTotal = $calcFirstNumber + $calcSecondNumber
		Case "-"
			$iTotal = $calcFirstNumber - $calcSecondNumber
		Case "*"
			$iTotal = $calcFirstNumber * $calcSecondNumber
		Case "/"
			$iTotal = $calcFirstNumber / $calcSecondNumber
		Case Else
			$iTotal = $calcFirstNumber
	EndSwitch

	If $firstHistory Then
		GUICtrlSetData($calcHistory, $calcFirstNumber & $calcModifier & $calcSecondNumber & " = " & $iTotal)
		$firstHistory = False
	Else
		GUICtrlSetData($calcHistory, GUICtrlRead($calcHistory) & @CRLF & $calcFirstNumber & $calcModifier & $calcSecondNumber & " = " & $iTotal)
	EndIf
	_GUICtrlEdit_LineScroll($calcHistory, 0, 10)
	$calcFirstNumber = $iTotal
	$calcOnZero = True
	GUICtrlSetData($calcDisplay, $calcFirstNumber)
	$calcMode = "First Number"
EndFunc   ;==>Calculate
