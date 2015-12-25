#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Func _IniDeleteEx($s_file, $s_section, $s_key = "")

    If Not FileExists($s_file) Then Return SetError(-1, 0, 0)

    Local $i_size = FileGetSize($s_file)

    Local $i_delete = 0
    If $i_size < 31 Then
        $i_delete = IniDelete($s_file, $s_section, $s_key)
        Return SetError(@error, 0, $i_delete)
    EndIf

    ; is file read only
    If StringInStr(FileGetAttrib($s_file), "R") Then
        Return SetError(-2, 0, 0)
    EndIf

    Local $s_fread = FileRead($s_file)

    ; find out if section exist, if so get data
    Local $s_secpatt = "(?si)(?:^|\v)(\h*\[\h*\Q"
    $s_secpatt &= $s_section
    $s_secpatt &= "\E\h*\].*?)(?:\z|\v\v?\[)"
    Local $a_data = StringRegExp($s_fread, $s_secpatt, 1)
    Local $f_dataexists = Not @error

    If Not $f_dataexists Then Return 1

    Local $h_open, $i_write = 0
    If $s_key = "" Then
        If $s_fread = $a_data[0] Then
            $h_open = FileOpen($s_file, 2)
            If $h_open = -1 Then Return SetError(-3, 0, 0)
            FileClose($h_open)
            Return 1
        EndIf
        $s_fread = StringReplace($s_fread, $a_data[0], "", 1, 1)
        $h_open = FileOpen($s_file, 2)
        If $h_open = -1 Then Return SetError(-3, 0, 0)
        $i_write = FileWrite($h_open, $s_fread)
        FileClose($h_open)
        If Not $i_write Then Return SetError(-4, 0, 0)
        Return 1
    EndIf

    ; since we stop at cr/lf then lets just split
    Local $a_lines
    If StringInStr($a_data[0], @CRLF, 1, 1) Then
        $a_lines = StringSplit(StringStripCR($a_data[0]), @LF)
    ElseIf StringInStr($a_data[0], @LF, 1, 1) Then
        $a_lines = StringSplit($a_data[0], @LF)
    Else
        $a_lines = StringSplit($a_data[0], @CR)
    EndIf

    Local $a_key, $f_found = False, $s_write
    Local $s_keypatt = "\h*(?!;|#)(.*?)\h*="

    For $iline = 1 To $a_lines[0]

        If $a_lines[$iline] = "" Then ContinueLoop

        $a_key = StringRegExp($a_lines[$iline], $s_keypatt, 1)
        If @error Or $s_key <> $a_key[0] Then
            $s_write &= $a_lines[$iline] & @CRLF
            ContinueLoop
        EndIf

        $f_found = True
    Next

    If Not $f_found Then Return 1

    $s_fread = StringReplace($s_fread, $a_data[0], $s_write)

    Local $h_open = FileOpen($s_file, 2)
    $i_write = FileWrite($h_open, $s_fread)
    FileClose($h_open)

    Return $i_write
EndFunc

; change added - SmOke_N - 2011/05/18
Func _IniWriteEx($s_file, $s_section, $s_key, $s_value)

    If Not $s_file Then Return SetError(-1, 0, 0)

    Local $f_exists = FileExists($s_file)
    If Not $f_exists Then
        FileClose(FileOpen($s_file, 2))
    EndIf

    Local $i_write = 0
    Local $i_size = FileGetSize($s_file) / 1024

    ; if the file is smaller than 32kb, no need for regex
    If $i_size <= 31 Then
        $i_write = IniWrite($s_file, $s_section, $s_key, $s_value)
        Return SetError(@error, 0, $i_write)
    EndIf

    ; is file read only
    If $f_exists Then
        If StringInStr(FileGetAttrib($s_file), "R") Then
            Return SetError(-2, 0, 0)
        EndIf
    EndIf

    Local $s_fread = FileRead($s_file)
    Local $s_write = ""

    ; find out if section exist, if so get data
    Local $s_secpatt = "(?si)(?:^|\v)(\h*\[\h*\Q"
    $s_secpatt &= $s_section
    $s_secpatt &= "\E\h*\].*?)(?:\z|\v\v?\[)"
    Local $a_data = StringRegExp($s_fread, $s_secpatt, 1)
    Local $f_dataexists = Not @error

    Local $s_write = ""

    ; if section doesn't exist; append
    If Not $f_dataexists Then
        If $s_fread Then
            If StringRight($s_fread, 2) <> @CRLF Then
                $s_write &= @CRLF
            EndIf
        EndIf

        $s_write &= "[" & $s_section & "]" & @CRLF
        $s_write &= $s_key & "=" & $s_value & @CRLF

        Return FileWrite($s_file, $s_write)
    EndIf

    ; since we stop at cr/lf then lets just split
    Local $a_lines
    If StringInStr($a_data[0], @CRLF, 1, 1) Then
        $a_lines = StringSplit(StringStripCR($a_data[0]), @LF)
    ElseIf StringInStr($a_data[0], @LF, 1, 1) Then
        $a_lines = StringSplit($a_data[0], @LF)
    Else
        $a_lines = StringSplit($a_data[0], @CR)
    EndIf

    Local $a_key, $f_changed = False
    Local $s_keypatt = "\h*(?!;|#)(.*?)\h*="

    For $iline = 1 To $a_lines[0]

        If $a_lines[$iline] = "" Then ContinueLoop

        $a_key = StringRegExp($a_lines[$iline], $s_keypatt, 1)
        If @error Or $s_key <> $a_key[0] Then
            $s_write &= $a_lines[$iline] & @CRLF
            ContinueLoop
        EndIf

        $f_changed = True
        $s_write &= $s_key & "=" & $s_value & @CRLF

    Next

    If Not $f_changed Then
        If StringRight($s_fread, 2) <> @CRLF Then
            $s_write &= @CRLF
        EndIf
        $s_write &= $s_key & "=" & $s_value & @CRLF
    EndIf

    $s_fread = StringReplace($s_fread, $a_data[0], $s_write)

    Local $h_open = FileOpen($s_file, 2)
    $i_write = FileWrite($h_open, $s_fread)
    FileClose($h_open)

    Return $i_write
EndFunc

; change added - SmOke_N - 2011/05/18
Func _IniReadSectionNamesEx($v_file)

    If Not $v_file Then Return SetError(-1, 0, 0)

    Local $f_exists = FileExists($v_file)

    Local $i_size, $a_secs

    If $f_exists Then
        $i_size = FileGetSize($v_file) / 1024

        ; if the file is smaller than 32kb, no need for regex
        If $i_size <= 31 Then
            $a_secs = IniReadSectionNames($v_file)
            If @error Then Return SetError(@error, 0, 0)
            If Not IsArray($a_secs) Then Return SetError(-2, 0, 0)
            Return $a_secs
        EndIf
    EndIf

    Local $s_fread
    If Not $f_exists Then
        ; string of data was passed
        $s_fread = $v_file
    Else
        $s_fread = FileRead($v_file)
    EndIf

    Local $s_secpatt = "(?m)(?:^|\v)\h*\[\h*(.*?)\h*\]"
    Local $a_secsre = StringRegExp($s_fread, $s_secpatt, 3)
    If @error Then Return SetError(-3, 0, 0)

    Local $i_ub = UBound($a_secsre)
    Local $a_secret[$i_ub + 1] = [$i_ub]

    For $isec = 0 To $i_ub - 1
        $a_secret[$isec + 1] = $a_secsre[$isec]
    Next

    Return $a_secret
EndFunc

; change added - SmOke_N - 2011/05/17
Func _IniReadSectionEx($v_file, $s_section)

    If Not $v_file Then Return SetError(-1, 0, 0)

    Local $f_exists = FileExists($v_file)

    Local $i_size, $a_secread

    If $f_exists Then
        $i_size = FileGetSize($v_file) / 1024

        ; if the file is smaller than 32kb, no need for regex
        If $i_size <= 31 Then
            $a_secread = IniReadSection($v_file, $s_section)
            If @error Then Return SetError(@error, 0, 0)
            If Not IsArray($a_secread) Then Return SetError(-2, 0, 0)
            Return $a_secread
        EndIf
    EndIf

    Local $s_fread
    If Not $f_exists Then
        ; string of data was passed
        $s_fread = $v_file
    Else
        $s_fread = FileRead($v_file)
    EndIf

    ; data between sections or till end of file
    Local $s_datapatt = "(?is)(?:^|\v)(?!;|#)\h*\[\h*\Q"
    $s_datapatt &= $s_section
    $s_datapatt &= "\E\h*\]\h*\v+(.*?)(?:\z|\v\h*\[)"
    Local $a_data = StringRegExp($s_fread, $s_datapatt, 1)
    If @error Then Return SetError(-3, 0, 0)

    ; sanity check for inf people
    If Not StringInStr($a_data[0], "=", 1, 1) Then
        Return SetError(-4, 0, 0)
    EndIf

    ; since we stop at cr/lf then lets just split
    Local $a_lines
    If StringInStr($a_data[0], @CRLF, 1, 1) Then
        $a_lines = StringSplit(StringStripCR($a_data[0]), @LF)
    ElseIf StringInStr($a_data[0], @LF, 1, 1) Then
        $a_lines = StringSplit($a_data[0], @LF)
    Else
        $a_lines = StringSplit($a_data[0], @CR)
    EndIf

    ; prevent capturing commented keys
    Local $a_key, $a_value
    Local $s_keypatt = "\h*(?!;|#)(.*?)\h*="
    Local $s_valpatt = "\h*=\h*(.*)"
    Local $a_secs[$a_lines[0] + 1][2], $i_add = 0

    For $iline = 1 To $a_lines[0]

        $a_key = StringRegExp($a_lines[$iline], $s_keypatt, 1)
        If @error Then ContinueLoop

        $s_valpatt = "\h*=\h*(.*)"

        $a_value = StringRegExp($a_lines[$iline], $s_valpatt, 1)
        If @error Then ContinueLoop

        If StringLeft($a_key[0], 1) = '"' And StringRight($a_key[0], 1) = '"' Then
            $a_key[0] = StringTrimLeft(StringTrimRight($a_key[0], 1), 1)
        EndIf
        If StringLeft($a_value[0], 1) = '"' And StringRight($a_value[0], 1) = '"' Then
            $a_value[0] = StringTrimLeft(StringTrimRight($a_value[0], 1), 1)
        EndIf

        $i_add += 1
        $a_secs[$i_add][0] = $a_key[0]
        $a_secs[$i_add][1] = $a_value[0]
    Next

    If Not $i_add Then Return SetError(-5, 0, 0)

    ; cleanup return array
    ReDim $a_secs[$i_add + 1][2]
    $a_secs[0][0] = $i_add

    Return $a_secs
EndFunc

; change added - SmOke_N - 2011/05/18
Func _IniReadEx($v_file, $s_section, $s_key, $v_default = -1)

    If Not $v_file Then Return SetError(-1, 0, 0)

    If $v_default = -1 Or $v_default = Default Then
        $v_default = ""
    EndIf

    Local $f_exists = FileExists($v_file)

    Local $i_size, $s_read

    If $f_exists Then
        $i_size = FileGetSize($v_file) / 1024

        ; if the file is smaller than 32kb, no need for regex
        If $i_size <= 31 Then
            $s_read = IniRead($v_file, $s_section, $s_key, $v_default)
            Return $s_read
        EndIf
    EndIf

    Local $s_fread
    If Not $f_exists Then
        ; string of data was passed
        $s_fread = $v_file
    Else
        $s_fread = FileRead($v_file)
    EndIf

    ; data between sections or till end of file
    Local $s_datapatt = "(?is)(?:^|\v)(?!;|#)\h*\[\h*\Q"
    $s_datapatt &= $s_section
    $s_datapatt &= "\E\h*\]\h*\v+(.*?)(?:\z|\v\h*\[)"
    Local $a_data = StringRegExp($s_fread, $s_datapatt, 1)
    If @error Then Return SetError(-2, 0, 0)

    ; sanity check for inf people
    If Not StringInStr($a_data[0], "=", 1, 1) Then
        Return SetError(-3, 0, 0)
    EndIf

    ; since we stop at cr/lf then lets just split
    Local $a_lines
    If StringInStr($a_data[0], @CRLF, 1, 1) Then
        $a_lines = StringSplit(StringStripCR($a_data[0]), @LF)
    ElseIf StringInStr($a_data[0], @LF, 1, 1) Then
        $a_lines = StringSplit($a_data[0], @LF)
    Else
        $a_lines = StringSplit($a_data[0], @CR)
    EndIf

    ; prevent capturing commented keys
    Local $a_key, $a_value, $s_ret
    Local $s_keypatt = "\h*(?!;|#)(.*?)\h*="
    Local $s_valpatt = "\h*=\h*(.*)"

    For $iline = 1 To $a_lines[0]

        $a_key = StringRegExp($a_lines[$iline], $s_keypatt, 1)
        If @error Then ContinueLoop

        If StringLeft($a_key[0], 1) = '"' And StringRight($a_key[0], 1) = '"' Then
            $a_key[0] = StringTrimLeft(StringTrimRight($a_key[0], 1), 1)
        EndIf

        If $a_key[0] <> $s_key Then ContinueLoop

        $s_valpatt = "\h*=\h*(.*)"

        $a_value = StringRegExp($a_lines[$iline], $s_valpatt, 1)
        If @error Then ContinueLoop

        If StringLeft($a_value[0], 1) = '"' And StringRight($a_value[0], 1) = '"' Then
            $a_value[0] = StringTrimLeft(StringTrimRight($a_value[0], 1), 1)
        EndIf

        $s_ret = $a_value[0]
        ExitLoop
    Next

    If Not $s_ret Then Return $v_default

    Return $s_ret
EndFunc