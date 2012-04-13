; macros: AutoIt's version of built-in variables
; @Hour and stuff
#Include macros2.ahk


Assign(varname, data, flag=0){
	global
	if flag=4 and not varExist(%varname%)
		return 0
	try %varname% := data
	catch
		return 0
	return 1
}
varExist(ByRef v) { ; Requires 1.0.46+
   return &v = &n ? 0 : v = "" ? 2 : 1 
}
AutoItSetOption(option, param=""){
	return Opt(option, param)
}
Opt(Option,Param=""){
    static CaretCoordMode := 0
    static MouseCoordMode := 0
    static PixelCoordMode := 0
    static GuiDelimiter   := "|"
    If (Option = "CaretCoordMode")
    {
        If Param = 0
            CoordMode, Caret, Relative
        Else If Param = 1
            CoordMode, Caret, Screen
        Else If Param = 2
            CoordMode, Caret, Client
        Else
            @error := 1
        Temp1 := CaretCoordMode, CaretCoordMode := Param
        Return, Temp1
    }
    If (Option = "GUIDataSeparatorChar")
    {
        WinGet, List, List, ahk_class AutoHotkeyGUI
        Loop Parse, List, `n
        {
            Gui, %A_LoopField%: +Delimiter%param%
        }
        temp := GuiDelimiter, GuiDelimiter := param
        return temp
    }
    If (Option = "MouseClickDelay")
    {
        Temp1 := A_MouseDelay
        If Param Is Integer
            SetMouseDelay, Param
        Else
            @error := 1
        Return, Temp1
    }
    If (Option = "MouseCoordMode")
    {
        If Param = 0
            CoordMode, Mouse, Relative
        Else If Param = 1
            CoordMode, Mouse, Screen
        Else If Param = 2
            CoordMode, Mouse, Client
        Else
            @error := 1
        Temp1 := MouseCoordMode, MouseCoordMode := Param
        Return, Temp1
    }
    If (Option = "PixelCoordMode")
    {
        If Param = 0
            CoordMode, Pixel, Relative
        Else If Param = 1
            CoordMode, Pixel, Screen
        Else If Param = 2
            CoordMode, Pixel, Client
        Else
            @error := 1
        Temp1 := PixelCoordMode, PixelCoordMode := Param
        Return, Temp1
    }
    If (Option = "SendKeyDelay")
    {
        Temp1 := A_KeyDelay
        If Param Is Integer
            SetKeyDelay, Param
        Else
            @error := 1
        Return, Temp1
    }
    If (Option = "WinDetectHiddenText")
    {
        Temp1 := A_DetectHiddenText
        If Param = 0
            DetectHiddenText, Off
        Else If Param = 1
            DetectHiddenText, On
        Else
            @error := 1
        Return, Temp1
    }
    If (Option = "WinTextMatchMode")
    {
        Temp1 := A_TitleMatchMode
        If Param = 1
            SetTitleMatchMode, 1
        Else If Param = 2
            SetTitleMatchMode, 2
        Else If Param = 3
            SetTitleMatchMode, 3
        Else
            @error := 1
        Return, Temp1
    }
    If (Option = "WinWaitDelay")
    {
        Temp1 := A_WinDelay
        If Param Is Integer
            SetWinDelay, %Temp1%
        Else
            @error := 1
        Return, Temp1
    }
}
Beep(Frequency, Duration=1000){
	SoundBeep, Frequency, Duration
	return 1 ; regardless of success, according to docs
}
Binary( expression ){ ; shaky implementation
	varSetCapacity(out, 16)
	NumPut(expression, out)
	varSetCapacity(out, -1)
	return out
}
BitAND(values*){
	if (values.MaxIndex() < 2)
		throw Exception("too few parameters passed to BitAND function", -1)
	out := values.1 & values.2
	Loop % values.MaxIndex() - 2
		out &= values[A_Index+2]
	return out
}
BitNOT( value ){ ; will have different results than in AU3
	return ~value
}
BitOR( values* ){
	if (values.MaxIndex() < 2)
		throw Exception("too few parameters passed to BitOR function", -1)
	out := values.1 | values.2
	Loop % values.MaxIndex() - 2
		out |= values[A_Index+2]
	return out
}
BitShift( value, shift ){
	return value >> shift
}
BitXOR( values* ){
	if (values.MaxIndex() < 2)
		throw Exception("too few parameters passed to BitXOR function", -1)
	out := values.1 ^ values.2
	Loop % values.MaxIndex() - 2
		out ^= values[A_Index+2]
	return out
}
BlockInput( flag ){ ; how to check Success/failure?
	BlockInput % flag ? "on" : "off"
	return 1 ; no idea if failure, so return success
}
Break( mode ){ ; unimplemented
	/*
	1 = Break is enabled (user can quit) (default)
	0 = Break is disabled (user cannot quit)
	*/
}
Call(function, params*){
	global @extended
	try returnvalue := %function%(params*)
	catch
		@error := 0xDEAD, @extended := 0xBEEF ; yes, really :/
	return returnvalue
}
CDTray( drive, status ){
	Drive, Eject, %drive%, % Status = "open" ? "" : 1
	return !ErrorLevel ; Success = 1
}
Ceiling( expression ){
	return Ceil(expression)
}
ClipGet( ){ ; not all @errors are returned correctly
	if !clipboard
	{
		@error := 1
		return ""
	}
	return Clipboard
}
ClipPut( value ){
	Clipboard := value
	return (Clipboard = value)
}
; Console functions must be implemented
ControlDisable(title, text, controlID){
	Control, Disable,, %controlID%, %Title%, %Text%
	return !ErrorLevel
}
ControlEnable(title, text, controlID){
	Control, Enable,, %controlID%, %Title%, %Text%
	return !ErrorLevel
}
ControlMove(title, text, controlID, x, y, width="", height=""){
	ControlMove, %controlID%, %x%, %y%, %width%, %height%, %title%, %text%
	return !ErrorLevel
}
ControlSetText( title, text, controlID, new_text, flag=0 ){
	ControlSetText, %ControlID%, %new_text%, %title%, %text%
	e := errorLevel
	if flag
		WinSet, Redraw,, %title%, %text%
	return !e
}
Dec(hex, flag=1){ ; flag is not implemented
	pfi := A_FormatInteger
	SetFormat, IntegerFast, D
	num := ("0x" . hex)
	num += 0
	num .= ""
	SetFormat, IntegerFast, %pfi%
	return "" . num
}
DirCopy(source, dest, flag=0){
	FileCopyDir, % source, % dest, % flag
	return !ErrorLevel
}
DirCreate(path){
	FileCreateDir, % path
	Return !ErrorLevel
}
DirMove(source, dest, flag=0){
    FileMoveDir, %source%, %dest%, %flag%
    return !ErrorLevel
}
DirRemove(path, recurse=0){
	FileRemoveDir, %path%, %recurse%
	Return !ErrorLevel
}
DriveGetFileSystem(path){
	try
	{
		DriveGet, fs, fs, %path%
	}
	catch
	{
		@error := 1
		Return
	}
	Return fs
}
DriveGetLabel(path){
	Try
	{
		DriveGet, cap, Capacity, %path%
	}
	Catch
	{
		@error := 1
		Return
	}
	Return cap
}
Exp( expression ){
	return 2.71828182845905**expression
}
FileCopy(Source,Destination,Flag = 0){
    If Flag = 8
    {
        SplitPath, Source,, Folder
        If !InStr(FileExist(Folder),"D")
        {
            FileCreateDir, %Folder%
            If ErrorLevel
                Return, 0
        }
        Flag := 1
    }
    FileCopy, %Source%, %Destination%, %Flag%
    Return, !ErrorLevel
}
FileExists( path ){
	return !!FileExist(path)
}
FileSaveDialog( title, init_dir, filter, options="", default_name="", hwnd="" ) ; hwnd not supported for now
{
	FileSelectFile, out, S%options%, %init_Dir%\%Default_name%, %title%, %filter%
	if ErrorLevel
		@error := 1
	return out
}
FileRecycle(source){
	Try
		FileRecycle, %source%
	Catch
		Return 0
	Return 1
}
FileRecycleEmpty(source="")
{
	Try
	{
		FileRecycleEmpty %source%
	}
	Catch
	{
		Return 0
	}
	Return 1
}
HotkeySet(Hotkey, FunctionName=""){
    Global HotkeySet := Object()

    if !FunctionName
    {
        Try Hotkey, %Hotkey%, Off
        return 1 ; Not specified in docs, and hell if I'm installing AU3
    }
 
    Try Hotkey, %Hotkey%, HotkeySet, On
    catch
        return 0 ; failure
    if !IsFunc(functionName)
        return 0
    HotkeySet[Hotkey] := FunctionName
    return 1
 
    HotkeySet:
        f := HotkeySet[A_ThisHotkey]
        %f%()
    return
}
IsAdmin(){
	Return A_IsAdmin
}
IsArray(var){
	return IsObject(var)
}
IsObj(param){
	Return IsObject(param)
}
IsHWnd(param){
	Return WinExist("ahk_id" param)
}
IsNumber(param){
	If param is number
		Return 1
	Else
		Return 0
}
MouseClick(button, x="", y="", clicks=1, speed=10){
	If button in left,primary,main
		button := "L"
	If button in secondary,right
		button := "R"
	MouseClick, %button%, X, Y, clicks, Speed
	Return 1 ; Error checking should be done in this function, but that is of low importance
}
MouseDown(myButton){
	mainButtons := "Left,Main,Primary"
	secondaryButtons := "Right,Secondary"

	IfInString, mainButtons, %myButton%
	{
		Click Down
	}
	else IfInString, secondaryButtons, %myButton%
	{
		Click Down Right
	}
	else If (myButton = "Middle")
	{
		Click Down Middle
	}
	else
	{
		Return 0
	}
	Return 1
}
MouseGetPos( dimension="" ) {
	MouseGetPos, X, Y
	if (dimension = 0) ; X
		return X
	if (dimension = 1) ; Y
		return Y
	return {0: X, 1: Y}
}
MouseUp(myButton){
	mainButtons := "Left,Main,Primary"
	secondaryButtons := "Right,Secondary"

	IfInString, mainButtons, %myButton%
	{
		Click Up
	}
	else IfInString, secondaryButtons, %myButton%
	{
		Click Up Right
	}
	else If (myButton = "Middle")
	{
		Click Up Middle
	}
	else
	{
		Return 0
	}
	Return 1
}
MsgBox( flag, title, text, timeout=0, hwnd=0 ){ ; needs timeout to be implemented
	return DllCall("MessageBox", UPtr, hwnd
			, Str, Text
			, Str, Title
			, UInt,Flag)
}
ProcessClose( process ){
	Process, Close, %process%
	return !ErrorLevel
}
ProcessExists( process ){
	Process, Exist, %process%
	return ErrorLevel
}
ProcessList( name = "" ){
	out := {}
	if name
		Query := " WHERE NAME='" name "'"
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process" . Query)
		out[A_Index, 0] := process.name
		,out[A_Index, 1]:= process.processID
	out[0, 0] := out.MaxIndex()
	return out
}
ProcessSetPriority( process, priority ){
	Process, priority, %process%, % ["L", "B", "N", "A", "H", "R"][priority+1]
	return !ErrorLevel
}
ProcessWait( process, timeout="" ){
	Process, wait, %process%, %timeout%
	return ErrorLevel
}
ProcessWaitClose( process, timeout="" ){
	Process, WaitClose, %process%, %timeout%
	return ErrorLevel
}
Sleep(milliseconds){
	Sleep milliseconds
}
Send(text=""){
	Send % text
}
WinFlash(title, text="", flashes=4, delay=500){
	WinGet, ID, ID, %title%, %text%
	Loop % flashes
	{
		DllCall("FlashWindow", "UPtr", ID, "Int", 1)
		Sleep delay
	}
}
WinWaitActive(title, text="", Seconds=""){
	WinWaitActive, %title%, %text%, %Seconds%
	return !ErrorLevel
}
WinWaitNotActive(Title, Text="", Timeout=""){
   WinWaitNotActive, % Title, % Text, % Timeout 
   return !ErrorLevel
}




range(Start,End,Step = 1)
{
    Return, new Iterator(Start,End,Step = 1)
}
 
class Iterator
{
    __New(Start,End,Step = 1)
    {
        this.Start := Start
        this.End := End
        this.Step := Step
    }
 
    _NewEnum()
    {
        Return, new Iterator.Enumerator(this.Start,this.End,this.Step)
    }
 
    class Enumerator
    {
        __New(Start,End,Step)
        {
            this.Start := Start
            this.End := End
            this.Step := Step
            this.Index := Start
        }
 
        Next(ByRef Key)
        {
            Key := this.Index
            this.Index += this.Step
            Return, Key <= this.End
        }
    }
}





/*
	Title: Command Functions
		A wrapper set of functions for commands which have an output variable.

	License:
		- Version 1.41 <http://www.autohotkey.net/~polyethene/#functions>
		- Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
*/

IfBetween(ByRef var, LowerBound, UpperBound) {
	If var between %LowerBound% and %UpperBound%
		Return, true
}
IfNotBetween(ByRef var, LowerBound, UpperBound) {
	If var not between %LowerBound% and %UpperBound%
		Return, true
}
IfIn(ByRef var, MatchList) {
	If var in %MatchList%
		Return, true
}
IfNotIn(ByRef var, MatchList) {
	If var not in %MatchList%
		Return, true
}
IfContains(ByRef var, MatchList) {
	If var contains %MatchList%
		Return, true
}
IfNotContains(ByRef var, MatchList) {
	If var not contains %MatchList%
		Return, true
}
IfIs(ByRef var, type) {
	If var is %type%
		Return, true
}
IfIsNot(ByRef var, type) {
	If var is not %type%
		Return, true
}

ControlGet(Cmd, Value = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	ControlGet, v, %Cmd%, %Value%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}
ControlGetFocus(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	ControlGetFocus, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}
ControlGetText(Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	ControlGetText, v, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}
DriveGet(Cmd, Value = "") {
	DriveGet, v, %Cmd%, %Value%
	Return, v
}
DriveSpaceFree(Path) {
	DriveSpaceFree, v, %Path%
	Return, v
}
EnvGet(EnvVarName) {
	EnvGet, v, %EnvVarName%
	Return, v
}
FileGetAttrib(Filename = "") {
	FileGetAttrib, v, %Filename%
	Return, v
}
FileGetShortcut(LinkFile, ByRef OutTarget = "", ByRef OutDir = "", ByRef OutArgs = "", ByRef OutDescription = "", ByRef OutIcon = "", ByRef OutIconNum = "", ByRef OutRunState = "") {
	FileGetShortcut, %LinkFile%, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
}
FileGetSize(Filename = "", Units = "") {
	FileGetSize, v, %Filename%, %Units%
	Return, v
}
FileGetTime(Filename = "", WhichTime = "") {
	FileGetTime, v, %Filename%, %WhichTime%
	Return, v
}
FileGetVersion(Filename = "") {
	FileGetVersion, v, %Filename%
	Return, v
}
FileRead(Filename) {
	FileRead, v, %Filename%
	Return, v
}
FileReadLine(Filename, LineNum) {
	FileReadLine, v, %Filename%, %LineNum%
	Return, v
}
FileSelectFile(Options = "", RootDir = "", Prompt = "", Filter = "") {
	FileSelectFile, v, %Options%, %RootDir%, %Prompt%, %Filter%
	Return, v
}
FileSelectFolder(StartingFolder = "", Options = "", Prompt = "") {
	FileSelectFolder, v, %StartingFolder%, %Options%, %Prompt%
	Return, v
}
FormatTime(YYYYMMDDHH24MISS = "", Format = "") {
	FormatTime, v, %YYYYMMDDHH24MISS%, %Format%
	Return, v
}
GetKeyState(WhichKey , Mode = "") {
	GetKeyState, v, %WhichKey%, %Mode%
	Return, v
}
GuiControlGet(Subcommand = "", ControlID = "", Param4 = "") {
	GuiControlGet, v, %Subcommand%, %ControlID%, %Param4%
	Return, v
}
ImageSearch(ByRef OutputVarX, ByRef OutputVarY, X1, Y1, X2, Y2, ImageFile) {
	ImageSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, %ImageFile%
}
IniRead(Filename, Section, Key, Default = "") {
	IniRead, v, %Filename%, %Section%, %Key%, %Default%
	Return, v
}
Input(Options = "", EndKeys = "", MatchList = "") {
	Input, v, %Options%, %EndKeys%, %MatchList%
	Return, v
}
InputBox(Title = "", Prompt = "", HIDE = "", Width = "", Height = "", X = "", Y = "", Font = "", Timeout = "", Default = "") {
	InputBox, v, %Title%, %Prompt%, %HIDE%, %Width%, %Height%, %X%, %Y%, , %Timeout%, %Default%
	Return, v
}
PixelGetColor(X, Y, RGB = "") {
	PixelGetColor, v, %X%, %Y%, %RGB%
	Return, v
}
PixelSearch(ByRef OutputVarX, ByRef OutputVarY, X1, Y1, X2, Y2, ColorID, Variation = "", Mode = "") {
	PixelSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, %ColorID%, %Variation%, %Mode%
}
Random(Min = "", Max = "") {
	Random, v, %Min%, %Max%
	Return, v
}
RegRead(RootKey, SubKey, ValueName = "") {
	RegRead, v, %RootKey%, %SubKey%, %ValueName%
	Return, v
}
Run(Target, WorkingDir = "", Mode = "") {
	Run, %Target%, %WorkingDir%, %Mode%, v
	Return, v	
}
SoundGet(ComponentType = "", ControlType = "", DeviceNumber = "") {
	SoundGet, v, %ComponentType%, %ControlType%, %DeviceNumber%
	Return, v
}
SoundGetWaveVolume(DeviceNumber = "") {
	SoundGetWaveVolume, v, %DeviceNumber%
	Return, v
}
StatusBarGetText(Part = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	StatusBarGetText, v, %Part%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}
SplitPath(ByRef InputVar, ByRef OutFileName = "", ByRef OutDir = "", ByRef OutExtension = "", ByRef OutNameNoExt = "", ByRef OutDrive = "") {
	SplitPath, InputVar, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
}
StringGetPos(ByRef InputVar, SearchText, Mode = "", Offset = "") {
	StringGetPos, v, InputVar, %SearchText%, %Mode%, %Offset%
	Return, v
}
StringLeft(ByRef InputVar, Count) {
	StringLeft, v, InputVar, %Count%
	Return, v
}
StringLen(ByRef InputVar) {
	StringLen, v, InputVar
	Return, v
}
StringLower(ByRef InputVar, T = "") {
	StringLower, v, InputVar, %T%
	Return, v
}
StringMid(ByRef InputVar, StartChar, Count , L = "") {
	StringMid, v, InputVar, %StartChar%, %Count%, %L%
	Return, v
}
StringReplace(ByRef InputVar, SearchText, ReplaceText = "", All = "") {
	StringReplace, v, InputVar, %SearchText%, %ReplaceText%, %All%
	Return, v
}
StringRight(ByRef InputVar, Count) {
	StringRight, v, InputVar, %Count%
	Return, v
}
StringTrimLeft(ByRef InputVar, Count) {
	StringTrimLeft, v, InputVar, %Count%
	Return, v
}
StringTrimRight(ByRef InputVar, Count) {
	StringTrimRight, v, InputVar, %Count%
	Return, v
}
StringUpper(ByRef InputVar, T = "") {
	StringUpper, v, InputVar, %T%
	Return, v
}
SysGet(Subcommand, Param3 = "") {
	SysGet, v, %Subcommand%, %Param3%
	Return, v
}
Transform(Cmd, Value1, Value2 = "") {
	Transform, v, %Cmd%, %Value1%, %Value2%
	Return, v
}
WinGet(Cmd = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	WinGet, v, %Cmd%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}
WinGetActiveTitle() {
	WinGetActiveTitle, v
	Return, v
}
WinGetClass(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	WinGetClass, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}
WinGetText(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	WinGetText, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}
WinGetTitle(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
	WinGetTitle, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	Return, v
}