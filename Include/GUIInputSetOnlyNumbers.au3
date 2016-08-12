#include-once
#include <GuiConstants.au3>

;~ If Not IsDeclared("WM_COMMAND") 		Then Global Const $WM_COMMAND		= 0x0111
;~ If Not IsDeclared("WM_MOVE")			Then Global Const $WM_MOVE 			= 0x0003
;~ If Not IsDeclared("WM_LBUTTONDOWN") 	Then Global Const $WM_LBUTTONDOWN 	= 0x0201
;~ If Not IsDeclared("WM_RBUTTONDOWN") 	Then Global Const $WM_RBUTTONDOWN 	= 0x0204

Global $sToolTip_Text[2] = ["You can only type a number here", "Unacceptable Character:"]
Global $sInputs_Array[1]
Global $tInputs_Array[1]

GUIRegisterMsg($WM_COMMAND, 	"MY_WM_COMMAND")
GUIRegisterMsg($WM_MOVE, 		"WM_CLEAR_TOOLTIP")
GUIRegisterMsg($WM_LBUTTONDOWN, "WM_CLEAR_TOOLTIP")
GUIRegisterMsg($WM_RBUTTONDOWN, "WM_CLEAR_TOOLTIP")

; $CtrlId must be an ID value, -1 can not be used!
Func _GuiInputSetOnlyNumbers($CtrlId, $tTip = True)
	Local $iUbound = UBound($sInputs_Array)
	ReDim $sInputs_Array[$iUbound+1]
	ReDim $tInputs_Array[$iUbound+1]
	$sInputs_Array[$iUbound] = $CtrlId
	$tInputs_Array[$iUbound] = $tTip
EndFunc

Func _Input_Changed($hWnd, $CtrlId)
	For $i = 1 To UBound($sInputs_Array)-1
		if $CtrlId = $sInputs_Array[$i] Then
			$boolTip = $tInputs_Array[$i]
			ExitLoop
		EndIf
		Next

    if $boolTip Then ToolTip("")
    Local $Read_Input = GUICtrlRead($CtrlId)
    If StringRegExp($Read_Input, '[^\d-]|[{0-9,1}^\A-][^\d]') Then
        $Read_Input = StringRegExpReplace($Read_Input, '[^\d-]|([{0-9,1}^\A-])[^\d]', '\1')
        GUICtrlSetData($CtrlId, $Read_Input)
        Local $Gui_Get_Pos = WinGetPos($hWnd)
        Local $Ctrl_Get_Pos = ControlGetPos($hWnd, "", $CtrlId)
        Local Const $SM_CYCAPTION = 4       ; Titlebar height
        Local Const $SM_CXFIXEDFRAME = 7    ; Window border size
        Local $X_Pos = $Gui_Get_Pos[0] + $Ctrl_Get_Pos[0] + $Ctrl_Get_Pos[2] + GetSystemMetrics($SM_CXFIXEDFRAME)
        Local $Y_Pos = $Gui_Get_Pos[1] + $Ctrl_Get_Pos[1] + $Ctrl_Get_Pos[3] + GetSystemMetrics($SM_CYCAPTION)
       if $boolTip Then ToolTip($sToolTip_Text[0], $X_Pos, $Y_Pos, $sToolTip_Text[1], 3, 1+4)
       if $booltip Then DllCall("user32.dll", "int", "MessageBeep", "int", 0x0)
    EndIf
EndFunc

;~ Func _Input_Changed($hWnd, $CtrlId)
;~ 	ToolTip("")
;~ 	Local $Read_Input = GUICtrlRead($CtrlId)
;~ 	If StringRegExp($Read_Input, '[^0-9]') Then
;~ 		GUICtrlSetData($CtrlId, StringRegExpReplace($Read_Input, '[^0-9]', ''))

;~ 		Local $Gui_Get_Pos = WinGetPos($hWnd)
;~ 		Local $Ctrl_Get_Pos = ControlGetPos($hWnd, "", $CtrlId)

;~ 		Local Const $SM_CYCAPTION = 4 ;Titelbar heigth
;~ 		Local Const $SM_CXFIXEDFRAME = 7 ;Window border size

;~ 		Local $X_Pos = $Gui_Get_Pos[0] + $Ctrl_Get_Pos[0] + $Ctrl_Get_Pos[2] + GetSystemMetrics($SM_CXFIXEDFRAME)
;~ 		Local $Y_Pos = $Gui_Get_Pos[1] + $Ctrl_Get_Pos[1] + $Ctrl_Get_Pos[3] + GetSystemMetrics($SM_CYCAPTION)

;~ 		ToolTip($sToolTip_Text[0], $X_Pos, $Y_Pos, $sToolTip_Text[1], 3, 1+4)
;~ 		DllCall("user32.dll", "int", "MessageBeep", "int", 0x0)
;~ 	EndIf
;~ EndFunc

Func WM_CLEAR_TOOLTIP($hWnd, $iMsg, $wParam, $lParam)
	ToolTip("")
	Return $GUI_RUNDEFMSG
EndFunc

Func MY_WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	If $hWnd = 0 Or Not WinExists($hWnd) Then Return $GUI_RUNDEFMSG

	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0xFFFF)
	Local Const $EN_CHANGE = 0x300
	Local Const $EN_UPDATE = 0x400
	Local Const $EN_SETFOCUS = 0x100
	Local Const $EN_KILLFOCUS = 0x200

	For $i = 1 To UBound($sInputs_Array)-1
		If $nID = $sInputs_Array[$i] Then
			Switch $nNotifyCode
				Case $EN_UPDATE ;$EN_CHANGE
					_Input_Changed($hWnd, $sInputs_Array[$i])
				Case $EN_SETFOCUS, $EN_KILLFOCUS
					ToolTip("")
			EndSwitch
			ExitLoop
		EndIf
	Next

	Return $GUI_RUNDEFMSG
EndFunc

Func GetSystemMetrics($Flag)
	Local $iRet = DllCall('user32.dll', 'int', 'GetSystemMetrics', 'int', $Flag)
	Return $iRet[0]
EndFunc
