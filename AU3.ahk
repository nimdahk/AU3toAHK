; macros
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
	global @error, @extended
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

Sleep(milliseconds){
	Sleep milliseconds
}
Send(text=""){
	Send % text
}
WinWaitActive(title="", text="", ExcludeTitle="", ExcludeText=""){
	WinWaitActive, %title%, %text%, %ExcludeTitle%, %ExcludeText%
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
MouseGetPos(ByRef OutputVarX = "", ByRef OutputVarY = "", ByRef OutputVarWin = "", ByRef OutputVarControl = "", Mode = "") {
	MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, %Mode%
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