#include-once

; #INDEX# ============================================================================================================
; Title .........: _GUIScrollBars_Size
; AutoIt Version : v3.3.6.0
; Language ......: English
; Description ...: Calculates scrollbar page and max values with proportional thumb sizes
; Remarks .......:
; Note ..........:
; Author(s) .....: Melba23 - with some code from WinAPI, GUIScrollBars and StructureConstants includes
;                  and contributions from rover and czardas
; ====================================================================================================================

;#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #INCLUDES# =========================================================================================================
#include <GuiScrollBars.au3>
#include <ScrollBarConstants.au3>

; #CURRENT# ==========================================================================================================
; _GUIScrollbars_Size:    Calculates scrollbar page and max values with proportional thumb sizes
; _GUIScrollbars_Restore: Resets scrollbar positions after a minimize/restore cycle
; ====================================================================================================================

; #INTERNAL_USE_ONLY#=================================================================================================
; _GSB_Size_Text: Sizes GUI text to set scroll units
; _GSB_Size_SB:   Sizes scrollbars to fit required GUI size
;=====================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _GUIScrollbars_Size
; Description ...: Calculates scrollbar page and max values with proportional thumb sizes
; Syntax.........: _GUIScrollbars_Size ($iH_Scroll, $iV_Scroll, $hAperture, [$iH_Aperture = 0])
; Parameters ....: $iH_Scroll   -> Width in pixels of area to be scrolled, must be >= aperture width
;                  $iV_Scroll   -> Height in pixels of area to be scrolled, must be >= aperture height
;                  $hAperture   -> GUI handle / Width of aperture GUI to contain scrollbars
;                  $iH_Aperture -> Height of aperture GUI to contain scrollbars - only needed if $hAperture is width
; Requirement(s).: v3.3.6.0 or higher
; Return values .: Success - Returns a 6-element array:
;                            [0] = Horizontal page size ; [1] = Horizontal max size
;                            [2] = Vertical page size   ; [3] = Vertical max size
;                            [4] = Horizontal position correction factor ; [5] = Vertical position correction factor
;                  Failure - Returns 0 and sets @error as follows:
;                            1 - Scroll area smaller than aperture GUI
;                            Returns negative integer indicating API error:
;                            -1 - GetDC failure
;                            -2 - GetTextMetricsW failure
;                            -3 - GetClientRect failure
;                            with @error and @extended as set by API return
; Remarks .......; If controls have been created BEFORE the scrollbars are displayed, the correction factors must be
;                  applied to the coordinates of any subsequent controls to get positional alignment.  The factors
;                  need not be applied if the control use the $GUI_DOCKALL resizing parameter.
; Author ........: Melba23 - with some code from WinAPI, GUIScrollBars and StructureConstants includes
; Example........; Yes
;=====================================================================================================================
Func _GUIScrollbars_Size($iH_Scroll = 0, $iV_Scroll = 0, $hAperture = 0, $iV_Aperture = 0)

	; Declare variables
	Local $fH_Scroll = True, $fV_Scroll = True
	Local $iX_Client, $iY_Client, $iX_Client_Bar, $iY_Client_Bar, $iX_Char, $iY_Char
	Local $aRet, $iError, $iExtended
	Local $tRect = DllStructCreate("long Left;long Top;long Right;long Bottom")

	; If passed GUI handle
	If IsHWnd($hAperture) Then
		; Determine GUI client area
		DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hAperture, "ptr", DllStructGetPtr($tRect))
		If @error Then Return SetError(@error, @extended, -3)
		Local $iX_Client_GUI = DllStructGetData($tRect, "Right") - DllStructGetData($tRect, "Left")
		Local $iY_Client_GUI = DllStructGetData($tRect, "Bottom") - DllStructGetData($tRect, "Top")
		; Check valid scroll size parameters
		If $iH_Scroll < $iX_Client_GUI And $iH_Scroll <> 0 Then Return SetError(1, 0, 0)
		If $iV_Scroll < $iY_Client_GUI And $iV_Scroll <> 0 Then Return SetError(1, 0, 0)

		; Determine horizontal scrollbar state and set GUI sizes
		Local $aH_SB = _GSB_Size_SB($hAperture, 0xFFFFFFFA) ; $OBJID_HSCROLL
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aH_SB) Then
			Return SetError($iError, $iExtended, -4)
		Else
			If Abs($aH_SB[0]) > @DesktopWidth Then
				; No H scrollbar so unset scrollbar flag
				$fH_Scroll = False
				; Set GUI sizes
				$iY_Client = $iY_Client_GUI
				$iY_Client_Bar = $iY_Client_GUI
			Else
				; Set GUI sizes
				$iY_Client = $iY_Client_GUI + ($aH_SB[3] - $aH_SB[1])
				$iY_Client_Bar = $iY_Client_GUI
			EndIf
		EndIf

		; Determine vertical scrollbar state and set GUI sizes
		Local $aV_SB = _GSB_Size_SB($hAperture, 0xFFFFFFFB) ; $OBJID_VSCROLL
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aH_SB) Then
			Return SetError($iError, $iExtended, -4)
		Else
			If Abs($aV_SB[0]) > @DesktopWidth Then
				; No V scrollbar so unset scrollbar flags
				$fV_Scroll = False
				; Set GUI sizes
				$iX_Client = $iX_Client_GUI
				$iX_Client_Bar = $iX_Client_GUI
			Else
				; Set GUI sizes
				$iX_Client = $iX_Client_GUI + ($aV_SB[2] - $aV_SB[0])
				$iX_Client_Bar = $iX_Client_GUI
			EndIf
		EndIf

		; Determine GUI text size
		$aRet = _GSB_Size_Text($hAperture)
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aRet) Then
			Return SetError($iError, $iExtended, $aRet)
		Else
			$iX_Char = $aRet[0]
			$iY_Char = $aRet[1]
		EndIf

		; If passed GUI size
	Else

		; Check valid scroll size parameters
		If $iH_Scroll < $hAperture And $iH_Scroll <> 0 Then Return SetError(1, 0, 0)
		If $iV_Scroll < $iV_Aperture And $iV_Scroll <> 0 Then Return SetError(1, 0, 0)

		Local $hWnd = GUICreate("", $hAperture, $iV_Aperture, @DesktopWidth + 10, 0)
		GUISetState()

		; Set client size without bars
		$iX_Client = $hAperture
		$iY_Client = $iV_Aperture

		; Ensure both scrollbars hidden
		DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hWnd, "int", 3, "bool", False)
		If @error Then Return SetError(@error, @extended, -4)
		; Show scrollbars if required
		If $iH_Scroll Then DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hWnd, "int", 0, "bool", True)
		If @error Then Return SetError(@error, @extended, -4)
		If $iV_Scroll Then DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hWnd, "int", 1, "bool", True)
		If @error Then Return SetError(@error, @extended, -4)

		; Get client size with scrollbars
		DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "ptr", DllStructGetPtr($tRect))
		If @error Then Return SetError(@error, @extended, -3)
		$iX_Client_Bar = DllStructGetData($tRect, "Right") - DllStructGetData($tRect, "Left")
		$iY_Client_Bar = DllStructGetData($tRect, "Bottom") - DllStructGetData($tRect, "Top")

		; Determine GUI text size
		$aRet = _GSB_Size_Text($hWnd)
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aRet) Then
			Return SetError($iError, $iExtended, $aRet)
		Else
			$iX_Char = $aRet[0]
			$iY_Char = $aRet[1]
		EndIf

		; Delete test GUI
		GUIDelete($hWnd)

		; Increase scroll limit values to match resized client area
		$iH_Scroll /= $iX_Client_Bar / $iX_Client
		$iV_Scroll /= $iY_Client_Bar / $iY_Client

		; Unset scrollbar flags if required
		If Not $iH_Scroll Then $fH_Scroll = False
		If Not $iV_Scroll Then $fV_Scroll = False

	EndIf

	; If horizontal scrollbar is required
	Local $iH_Page, $iH_Max
	If $fH_Scroll Then
		; Use reduced aperture width if other scrollbar exists
		If $fV_Scroll Then
			; Determine page size (aperture width / text width)
			$iH_Page = Floor($iX_Client_Bar / $iX_Char)
			; Determine max size (scroll width / text width * correction factor for vertical scrollbar)
			$iH_Max = Floor($iH_Scroll / $iX_Char * $iX_Client_Bar / $iX_Client)
		Else
			; Determine page size (aperture width / text width)
			$iH_Page = Floor($iX_Client / $iX_Char)
			; Determine max size (scroll width / text width)
			$iH_Max = Floor($iH_Scroll / $iX_Char)
		EndIf
	Else
		$iH_Page = 0
		$iH_Max = 0
	EndIf

	; If vertical scrollbar required
	Local $iV_Page, $iV_Max
	If $fV_Scroll Then
		; Use reduced aperture width if other scrollbar exists
		If $fH_Scroll Then
			; Determine page size (aperture width / text width)
			$iV_Page = Floor($iY_Client_Bar / $iY_Char)
			; Determine max size (scroll width / text width * correction factor for horizontal scrollbar)
			$iV_Max = Floor($iV_Scroll / $iY_Char * $iY_Client_Bar / $iY_Client)
		Else
			; Determine page size (aperture width / text width)
			$iV_Page = Floor($iY_Client / $iY_Char)
			; Determine max size (scroll width / text width)
			$iV_Max = Floor($iV_Scroll / $iY_Char)
		EndIf
	Else
		$iV_Page = 0
		$iV_Max = 0
	EndIf

	; Create return array
	Local $aRet[6] = [$iH_Page, $iH_Max, $iV_Page, $iV_Max, $iX_Client_Bar / $iX_Client, $iY_Client_Bar / $iY_Client]

	Return $aRet

EndFunc   ;==>_GUIScrollbars_Size

; #FUNCTION# =========================================================================================================
; Name...........: _GUIScrollbars_Restore
; Description ...: Resets scrollbar positions after a minimize/restore cycle
; Syntax.........: _GUIScrollbars_Restore($hWnd[, $fVert = True[, $fHorz = True]])
; Parameters ....: $hWnd  -> GUI containing scrollbars
;                  $fVert -> True (default) = vertical scrollbar visible; False = vertical scrollbar not visible
;                  $fHorz -> True (default) = horizontal scrollbar visible; False = horzontal scrollbar not visible
; Requirement(s).: v3.3.6.0 or higher
; Return values .: None
; Remarks .......;
; Author ........: Melba23 - based on code from rover and czardas
; Example........; Yes
;=====================================================================================================================
Func _GUIScrollbars_Restore($hWnd, $fVert = True, $fHorz = True)

	Local $nV_Pos, $nH_Pos

	_GUIScrollBars_ShowScrollBar($hWnd, $SB_BOTH, True)
	$nV_Pos = _GUIScrollBars_GetScrollPos($hWnd, $SB_VERT) ; Get current position
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, 0) ; Set the scroll to zero
	$nH_Pos = _GUIScrollBars_GetScrollPos($hWnd, $SB_HORZ) ; Get current position
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, 0) ; Set the scroll to zero
	If Not $fVert Then
		_GUIScrollBars_ShowScrollBar($hWnd, $SB_VERT, False)
	EndIf
	If Not $fHorz Then
		_GUIScrollBars_ShowScrollBar($hWnd, $SB_HORZ, False)
	EndIf
	If $fVert Then
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, $nV_Pos)
	EndIf
	If $fHorz Then
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, $nH_Pos)
	EndIf

EndFunc   ;==>_GUIScrollbars_Restore

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GSB_Size_Text
; Description ...: Sizes GUI text to set scroll units
; Syntax ........: _GSB_Size_Text($hWnd)
; Return values .: Array holding average text width and absolute text height
; Author ........: Melba23
; Remarks .......: This function is used internally by _Scrollbars_Size
; ===============================================================================================================================
Func _GSB_Size_Text($hWnd)

	Local $tagTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & _
			"long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & _
			"wchar tmFirstChar;wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & _
			"byte tmPitchAndFamily;byte tmCharSet"
	Local $tTEXTMETRIC = DllStructCreate($tagTEXTMETRIC)

	Local $hDC = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If Not @error Then
		$hDC = $hDC[0]
		DllCall("gdi32.dll", "bool", "GetTextMetricsW", "handle", $hDC, "ptr", DllStructGetPtr($tTEXTMETRIC))
		If @error Then
			Local $iError = @error
			Local $iExtended = @extended
			DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
			Return SetError($iError, $iExtended, -2)
		EndIf
		DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	Else
		Return SetError(@error, @extended, -1)
	EndIf

	Local $aRet[2] = [ _
			DllStructGetData($tTEXTMETRIC, "tmAveCharWidth"), _
			DllStructGetData($tTEXTMETRIC, "tmHeight") + DllStructGetData($tTEXTMETRIC, "tmExternalLeading")]
	Return $aRet

EndFunc   ;==>_GSB_Size_Text

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GSB_Size_SB
; Description ...: Sizes scrollbars to fit required GUI size
; Syntax ........: _GSB_Size_SB($hWnd, $idObj)
; Return values .: Array holding size of scrollable GUI
; Author ........: Melba23
; Remarks .......: This function is used internally by _Scrollbars_Size
; ===============================================================================================================================
Func _GSB_Size_SB($hWnd, $idObj)

	Local $tagSCROLLBARINFO = "dword cbSize;long Left;long Top;long Right;long Bottom;int dxyLineButton;int xyThumbTop;" & _
			"int xyThumbBottom;int reserved;dword rgstate[6]"
	Local $tSCROLLBARINFO = DllStructCreate($tagSCROLLBARINFO)
	DllStructSetData($tSCROLLBARINFO, "cbSize", DllStructGetSize($tSCROLLBARINFO))

	DllCall("user32.dll", "bool", "GetScrollBarInfo", "hwnd", $hWnd, "long", $idObj, "ptr", DllStructGetPtr($tSCROLLBARINFO))
	If @error Then Return SetError(@error, @extended, -4)

	Local $aRect[4] = [ _
			DllStructGetData($tSCROLLBARINFO, "Left"), _
			DllStructGetData($tSCROLLBARINFO, "Top"), _
			DllStructGetData($tSCROLLBARINFO, "Right"), _
			DllStructGetData($tSCROLLBARINFO, "Bottom")]
	Return $aRect

EndFunc   ;==>_GSB_Size_SB