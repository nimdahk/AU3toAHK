/*
__NeedsImplementation: Possible to retrieve; not implemented
__Dynamic: value is not constant; must be replaced with a function
*/

global @AppDataCommonDir := A_AppDataCommonDir
global @AppDataDir := A_AppData
global @AutoItExe := A_AhkPath
Process, Exist
global @AutoItPID := ErrorLevel
global @AutoItVersion := A_AhkVer
global @AutoItX64 := A_PtrSize = 8
global @COM_EventObj := __NeedsImplementation
global @CommonFilesDir := __NeedsImplementation
global @Compiled := A_IsCompiled
global @ComputerName := A_ComputerName
global @ComSpec := ComSpec
global @CPUArch := __NeedsImplementation
global @CR := "`r"
global @CRLF := "`r`n"
global @DesktopCommonDir := A_DesktopCommon
global @DesktopDir := A_Desktop
global @DesktopHeight := A_ScreenHeight
global @DesktopWidth := A_ScreenWidth
global @DesktopDepth := __NeedsImplementation
global @DesktopRefresh := __NeedsImplementation
global @DocumentsCommonDir := SHGetFolderPath(0x002e)
global @error := __Dynamic
global @exitCode := __Dynamic
global @exitMethod := __Dynamic
global @extended := __Dynamic
global @FavoritesCommonDir := SHGetFolderPath(0x001F)
global @FavoritesDir := SHGetFolderPath(0x0006)
global @GUI_CtrlId := __Dynamic
global @GUI_CtrlHandle := __Dynamic
global @GUI_DragId := __Dynamic
global @GUI_DragFile := __Dynamic
global @GUI_DropId := __Dynamic
global @GUI_WinHandle := __Dynamic
global @HomeDrive
global @HomePath
EnvGet, @HomeDrive, HOMEDRIVE
EnvGet, @HomePath, HomePath
global @HomeShare := __NeedsImplementation
global @HOUR := __Dynamic
global @HotKeyPressed := __Dynamic
global @IPAddress1 := A_IPAddress1
global @IPAddress2 := A_IPAddress2
global @IPAddress3 := A_IPAddress3
global @IPAddress4 := A_IPAddress4
global @KBLayout := __NeedsImplementation
global @LF := Chr(10)
global @LogonDNSDomain := __NeedsImplementation
global @LogonDomain := __NeedsImplementation
global @LogonServer := __NeedsImplementation
global @MDAY := __Dynamic
global @MIN := __Dynamic
global @MON := __Dynamic
global @MSEC := __Dynamic
global @MUILang := A_Language
global @MyDocumentsDir := A_MyDocuments
global @NumParams := __Dynamic
global @OSArch := __NeedsImplementation ; **
global @OSBuild := __NeedsImplementation ; **
global @OSLang := __NeedsImplementation
global @OSServicePack := __NeedsImplementation
global @OSType := "WIN32_NT"
global @OSVersion := A_OSVersion
global @ProgramFilesDir := A_ProgramFiles
global @ProgramsCommonDir := A_ProgramsCommon
global @ProgramsDir := A_Programs
global @ScriptDir := A_ScriptDir
global @ScriptFullPath := A_ScriptFullPath
global @ScriptLineNumber := __Dynamic
global @ScriptName := A_ScriptName
global @SEC := __Dynamic
global @StartMenuCommonDir := A_StartMenuCommon
global @StartMenuDir := A_StartMenu
global @StartupCommonDir := A_StartupCommon
global @StartupDir := A_Startup
/* __NeedsImplementation -- will be done when GUISetState and friends are completed
global @SW_DISABLE := A_SW_DISABLE
global @SW_ENABLE := A_SW_ENABLE
global @SW_HIDE := A_SW_HIDE
global @SW_LOCK := A_SW_LOCK
global @SW_MAXIMIZE := A_SW_MAXIMIZE
global @SW_MINIMIZE := A_SW_MINIMIZE
global @SW_RESTORE := A_SW_RESTORE
global @SW_SHOW := A_SW_SHOW
global @SW_SHOWDEFAULT := A_SW_SHOWDEFAULT
global @SW_SHOWMAXIMIZED := A_SW_SHOWMAXIMIZED
global @SW_SHOWMINIMIZED := A_SW_SHOWMINIMIZED
global @SW_SHOWMINNOACTIVE := A_SW_SHOWMINNOACTIVE
global @SW_SHOWNA := A_SW_SHOWNA
global @SW_SHOWNOACTIVATE := A_SW_SHOWNOACTIVATE
global @SW_SHOWNORMAL := A_SW_SHOWNORMAL
global @SW_UNLOCK := A_SW_UNLOCK
*/
global @SystemDir := A_WinDir "\" System32 ; This is a bad idea
global @TAB := A_TAB
global @TempDir := A_Temp
global @TRAY_ID := __Dynamic
global @TrayIconFlashing := __Dynamic
global @TrayIconVisible := __Dynamic
global @UserProfileDir
EnvGet, @UserProfileDir, USERPROFILE
global @UserName := A_UserName
global @WDAY := A_WDAY ; __Dynamic (this might work some of the time)
global @WindowsDir := A_WinDir
global @WorkingDir := A_WorkingDir
global @YDAY := A_YDAY ; __Dynamic (this might work some of the time)
global @YEAR := A_YEAR ; __Dynamic (this might work some of the time)

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