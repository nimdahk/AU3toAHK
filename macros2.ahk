/*
__NeedsImplementation: Possible to retrieve; not implemented
__Dynamic: value is not constant; must be replaced with a function
*/

@AppDataCommonDir := A_AppDataCommonDir
@AppDataDir := A_AppData
@AutoItExe := A_AhkPath
Process, Exist
@AutoItPID := ErrorLevel
@AutoItVersion := A_AhkVer
@AutoItX64 := A_PtrSize = 8
@COM_EventObj := __NeedsImplementation
@CommonFilesDir := __NeedsImplementation
@Compiled := A_IsCompiled
@ComputerName := A_ComputerName
@ComSpec := ComSpec
@CPUArch := __NeedsImplementation
@CR := "`r"
@CRLF := "`r`n"
@DesktopCommonDir := A_DesktopCommon
@DesktopDir := A_Desktop
@DesktopHeight := A_ScreenHeight
@DesktopWidth := A_ScreenWidth
@DesktopDepth := __NeedsImplementation
@DesktopRefresh := __NeedsImplementation
@DocumentsCommonDir := SHGetFolderPath(0x002e)
@error := __Dynamic
@exitCode := __Dynamic
@exitMethod := __Dynamic
@extended := __Dynamic
@FavoritesCommonDir := SHGetFolderPath(0x001F)
@FavoritesDir := SHGetFolderPath(0x0006)
@GUI_CtrlId := __Dynamic
@GUI_CtrlHandle := __Dynamic
@GUI_DragId := __Dynamic
@GUI_DragFile := __Dynamic
@GUI_DropId := __Dynamic
@GUI_WinHandle := __Dynamic
EnvGet, @HomeDrive, HOMEDRIVE
EnvGet, @HomePath, HomePath
@HomeShare := __NeedsImplementation
@HOUR := __Dynamic
@HotKeyPressed := __Dynamic
@IPAddress1 := A_IPAddress1
@IPAddress2 := A_IPAddress2
@IPAddress3 := A_IPAddress3
@IPAddress4 := A_IPAddress4
@KBLayout := __NeedsImplementation
@LF := Chr(10)
@LogonDNSDomain := __NeedsImplementation
@LogonDomain := __NeedsImplementation
@LogonServer := __NeedsImplementation
@MDAY := __Dynamic
@MIN := __Dynamic
@MON := __Dynamic
@MSEC := __Dynamic
@MUILang := A_Language
@MyDocumentsDir := A_MyDocuments
@NumParams := __Dynamic
@OSArch := __NeedsImplementation ; **
@OSBuild := __NeedsImplementation ; **
@OSLang := __NeedsImplementation
@OSServicePack := __NeedsImplementation
@OSType := "WIN32_NT"
@OSVersion := A_OSVersion
@ProgramFilesDir := A_ProgramFiles
@ProgramsCommonDir := A_ProgramsCommon
@ProgramsDir := A_Programs
@ScriptDir := A_ScriptDir
@ScriptFullPath := A_ScriptFullPath
@ScriptLineNumber := __Dynamic
@ScriptName := A_ScriptName
@SEC := __Dynamic
@StartMenuCommonDir := A_StartMenuCommon
@StartMenuDir := A_StartMenu
@StartupCommonDir := A_StartupCommon
@StartupDir := A_Startup
/* __NeedsImplementation -- will be done when GUISetState and friends are completed
@SW_DISABLE := A_SW_DISABLE
@SW_ENABLE := A_SW_ENABLE
@SW_HIDE := A_SW_HIDE
@SW_LOCK := A_SW_LOCK
@SW_MAXIMIZE := A_SW_MAXIMIZE
@SW_MINIMIZE := A_SW_MINIMIZE
@SW_RESTORE := A_SW_RESTORE
@SW_SHOW := A_SW_SHOW
@SW_SHOWDEFAULT := A_SW_SHOWDEFAULT
@SW_SHOWMAXIMIZED := A_SW_SHOWMAXIMIZED
@SW_SHOWMINIMIZED := A_SW_SHOWMINIMIZED
@SW_SHOWMINNOACTIVE := A_SW_SHOWMINNOACTIVE
@SW_SHOWNA := A_SW_SHOWNA
@SW_SHOWNOACTIVATE := A_SW_SHOWNOACTIVATE
@SW_SHOWNORMAL := A_SW_SHOWNORMAL
@SW_UNLOCK := A_SW_UNLOCK
*/
@SystemDir := A_WinDir "\" System32 ; This is a bad idea
@TAB := A_TAB
@TempDir := A_Temp
@TRAY_ID := __Dynamic
@TrayIconFlashing := __Dynamic
@TrayIconVisible := __Dynamic
EnvGet, @UserProfileDir, USERPROFILE
@UserName := A_UserName
@WDAY := A_WDAY ; __Dynamic (this might work some of the time)
@WindowsDir := A_WinDir
@WorkingDir := A_WorkingDir
@YDAY := A_YDAY ; __Dynamic (this might work some of the time)
@YEAR := A_YEAR ; __Dynamic (this might work some of the time)

SHGetFolderPath(folder){
	VarSetCapacity(out, 255 << !!A_IsUnicode)
	DllCall("Shell32.dll\SHGetFolderPath"
			, UPtr, 0 		; hwndOwner is reserved
			, int, folder	; nFolder
			, UPtr, 0		; hToken can be NULL
			, UInt, 0		; dwFlags
			, Str, out)		; pszPath
	return out
}