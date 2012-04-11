#NoEnv
SetWorkingDir %A_ScriptDir%

If 0 > 0 ; incoming cmdline parameters
	fileName = %1%
else
	FileSelectFile, fileName

FileRead, file, %fileName%

File := "#Include AU3.ahk`r`n" . File

; Func .. EndFunc -> Func(){ .. }
file := RegExReplace(file, "mi`a)^(\h*)Func\s*(.*)$", "$1$2`r`n$1{")
StringReplace, file, file, EndFunc, }, All

; While .. Wend -> While{ .. }
file := RegExReplace(file, "mi`a)^(\h*)(While.*)$", "$1$2`r`n$1{")
StringReplace, file, file, Wend, }, All

; Switch .. Case .. EndSwitch -> Switch .. SwitchCase .. EndSwitch
file := preparseSelectSwitch(file)

;Switch .. EndSwitch -> some awful If else if crap
file := changeSwitch(file)

;Select .. EndSelect -> more awful If else if crap
;Nested Switch and Selects will cause undefined behavior when translating
file := changeSelect(file)

; Underscore continuation
file := RegExReplace(file, "mi`a)\h_(\s*;.*)[\r\n]*")

; Concatenation
StringReplace, file, file, %A_Space%&%A_Space%, %A_Space%.%A_Space%, All

; For .. = .. to .. [Step ..] .. Next -> for .. in range(.., .. [, ..]){ .. }
file := RegExReplace(file, "mi`a)^(\s*for\s+\$\w+\s*)=\s*([-\d\.]+)\s+to\s+([-\d\.]+\s+)(?:step\s+([-\d\.]+(?:\s*\/\s*[-\d\.]+)?))", "$1in range($2, $3, $4){")
file := RegExReplace(file, "mi`a)^(\s*for\s+\$\w+\s*)=\s*([-\d\.]+)\s+to\s+([-\d\.]+\s*?)(?!step)", "$1in range($2, $3){")
StringReplace, file, file, Next, }, All

; for a in b .. next -> for a in b { .. }
file := RegExReplace(file, "i)(?:^|[\r\n])\s*(for[^`r`n{]*[\r\n]*)", "$1{")
; the NEXT keyword has been handled above

; Do .. Until -> Loop .. Until
file := RegExReplace(file, "mi`a)^(\s*)Do", "$1Loop")

; ContinueLoop -> Continue
StringReplace, file, file, ContinueLoop, Continue, All

; ExitLoop -> Break
StringReplace, file, file, ExitLoop, Break, All

; Exit -> ExitApp
; use RegEx to reduce false positives
file := RegExReplace(file, "mi`a)^(\s*)Exit", "$1ExitApp")

; 'She said "Hi"' -> "She said ""Hi"""
file := changeQuotes(File)

MsgBox % file

FileDelete, %fileName%.ahk
FileAppend, %file%, %fileName%.ahk


changeQuotes(file){
    Loop Parse, file, `n, `r
    {
        if RegExMatch(A_LoopField, "^(\s*)#(?:comments-start|cs)(\s*)$", $)
        {
            out .= $1 . "/*" . $2 . "`r`n"
            comments_start := true
            continue
        }
        else if RegExMatch(A_LoopField, "^(\s*)#(?:comments-end|ce)(\s*)$", $){
            out .= $1 . "*/" . $2 . "`r`n"
            comments_start := false
            continue
        }
        if (comments_start){
            out .= A_LoopField "`r`n"
            continue
        }


        i := 0
        While (LoopField := SubStr(A_LoopField, ++i, 1)) != ""
        {
            ; ignore single-line comments
            if (LoopField = ";") 
                and (i = 1 or RegExMatch(SubStr(A_LoopField, i-1, 1), "\s")){
                    out .= SubStr(A_LoopField, i)
                    i := StrLen(A_LoopField)
                    out .= "`r`n"
                    continue 2
            }
            else if (LoopField = """") or (LoopField = "'") ; begin quote
            {
                out .= """"
                beginQuote := LoopField
                While (LoopField := SubStr(A_LoopField, ++i, 1)) != ""
                {
                    if (LoopField = beginQuote)
                    {
                        if SubStr(A_LoopField, i+1, 1) != beginQuote ; this ends the quote
                        {
                            out .= """"
                            continue 2
                        }
                        else
                        {
                            out .= beginQuote . (beginQuote = """" ? """" : "")
                            i++ ; There was a double-quote for escaping; eat the second one
                        }
                    }
                    else if (LoopField = """")
                    {
                        out .= """"""
                    }
                    else
                    {
                        out .= LoopField
                    }
                }
            }
             
            out .= LoopField
        }
        out .= "`r`n"
    }
    return out
}
changeSwitch(var){
	Switch := 0
	Loop Parse, var, `n, `r
	{
		If RegExMatch(A_LoopField, "mi`a)^(\s*)Switch(\s+.*)$", $)
			out .= $1 "Switch" . ++Switch . " := " $2
		else if RegExMatch(A_LoopField, "mi`a)^(\s*)SwitchCase(.*)$", $) and Switch > 0
		{
			case%Switch%++
			if ( Trim($2) = "else" )
			{
				out .=  $1 "else{`r`n"
				continue
			}
			out .= $1 (Case%Switch% > 1 ? "}else " : "" ) . "if "
			SwitchN := "Switch" Switch
			Loop Parse, $2, `,
			{
				if A_Index > 1
					out .= " or "
				if RegExMatch(A_LoopField, "i)(.*)\s*To\s*(.*)")
					out .= RegExReplace(A_LoopField, "i)(.*)\s*To\s*(.*)"
						, "($1 <= " SwitchN " and " SwitchN " <= $2)")
				else if RegExMatch(A_LoopField, "i)^(?!\sTo\s)(.*)$")
					out .= RegExReplace(A_LoopField, "i)^(?!\sTo\s)(.*)$"
						, "($1 = " SwitchN ")")
			}
			out .= "{"
		}
		else if RegExMatch(A_LoopField, "mi`a)^(\s*)EndSwitch(.*)", $)
		{
			out .= $1 "}" $2
			Switch--
		}
		else
			out .= A_LoopField
		out .= "`r`n"
	}
	StringTrimRight, out, out, 2
	return out
}
changeSelect(var){
	Select := 0
	Loop Parse, var, `n, `r
	{
		if Trim(A_LoopField) = "Select"
			Select++
		else if RegExMatch(A_LoopField, "i)(\s*)SelectCase\s*else(.*)", $) and Select > 0
		{
			Case%Select%++
			out .= $1 (Case%Select% > 1 ? "}" : "") . "else{" . $2
		}
		else if RegExMatch(A_LoopField, "i)(\s*)SelectCase\s*(.*)", $) and Select > 0
		{
			Case%Select%++
			out .= $1 . (Case%Select% > 1 ? "}else " : "") "if (" $2 "){"
		}
		else if RegExMatch(A_LoopField, "i)^(\s*)EndSelect(.*)$", $)
		{
			out .=$1 . "}" . $2
			Select--
		}
		else
			out .= A_LoopField
		out .= "`r`n"
	}
	StringTrimRight, out, out, 2
	return out
}
preparseSelectSwitch(var){
	stack := {push: func("ObjInsert"), pop: func("ObjRemove")}
	Loop Parse, var, `n, `r
	{
		if RegExMatch(A_LoopField,      "i)^\s*(Select|Switch)", $){
			stack.push($1)
			out .= A_LoopField
		}
		else if RegExMatch(A_LoopField, "i)^\s*End(Select|Switch)"){
			stack.pop()
			out .= A_LoopField
		}
		else if RegExMatch(A_LoopField, "i)^(\s*)case(.*)$", $){
			out .= $1 . stack[stack.MaxIndex()] . "case" . $2
		}
		else{
			out .= A_LoopField
		}
		out .= "`r`n"
	}
	return out
}