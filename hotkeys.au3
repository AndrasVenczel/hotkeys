#RequireAdmin

#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <AutoItConstants.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <ProcessConstants.au3>
#include <WinAPI.au3>
#include <WinAPIFiles.au3>
#include <WinAPIHObj.au3>
#include <WinAPIProc.au3>
#include <WinAPISys.au3>
#include <WinAPIShellEx.au3>
#include <WinAPIGdi.au3>
#include <WinAPIMisc.au3>
#include <WinAPISysWin.au3>

HotKeySet("#^q", "HotKeyPressed")	;Quit
HotKeySet("#s", "HotKeyPressed")	;Activate next window
HotKeySet("#a", "HotKeyPressed")	;Activate previous window
HotKeySet("#m", "HotKeyPressed")	;Maximize all visible
HotKeySet("#^m", "HotKeyPressed")	;Maximize active window
HotKeySet("#^x", "HotKeyPressed")	;Maximize active window
HotKeySet("#x", "HotKeyPressed")	;Maximize active window
HotKeySet("#^!s", "HotKeyPressed")	;Save windows positions
HotKeySet("#^!r", "HotKeyPressed")	;Restore windows positions
HotKeySet("#^t", "HotKeyPressed")	;Set topmost
HotKeySet("#^!t", "HotKeyPressed")	;Keep window activated
HotKeySet("#i", "HotKeyPressed")	;Dump windows info to log file
HotKeySet("#c", "HotKeyPressed")	;Close active window
HotKeySet("#^!c", "HotKeyPressed")	;Close all visible windows of the active window's class
HotKeySet("#^!m", "HotKeyPressed")	;Maximize all visible windows of the active window's class
HotKeySet("#^!a", "HotKeyPressed")	;Arrange all visible windows of the active window's class
HotKeySet("#k", "HotKeyPressed")	;Toggle caption one window
HotKeySet("#^!k", "HotKeyPressed")	;Toggle caption all visible windows
HotKeySet("#b", "HotKeyPressed")	;Toggle border one window
HotKeySet("#^!b", "HotKeyPressed")	;Toggle border all visible windows
HotKeySet("#^1", "HotKeyPressed")	;Save desktop 1 executables
HotKeySet("#!1", "HotKeyPressed")	;Load desktop 1 executables
HotKeySet("#^2", "HotKeyPressed")	;Save desktop 2 executables
HotKeySet("#!2", "HotKeyPressed")	;Load desktop 2 executables
HotKeySet("#^3", "HotKeyPressed")	;Save desktop 3 executables
HotKeySet("#!3", "HotKeyPressed")	;Load desktop 3 executables
HotKeySet("#^4", "HotKeyPressed")	;Save desktop 4 executables
HotKeySet("#!4", "HotKeyPressed")	;Load desktop 4 executables
HotKeySet("#^5", "HotKeyPressed")	;Save desktop 5 executables
HotKeySet("#!5", "HotKeyPressed")	;Load desktop 5 executables
HotKeySet("#^6", "HotKeyPressed")	;Save desktop 6 executables
HotKeySet("#!6", "HotKeyPressed")	;Load desktop 6 executables
HotKeySet("#^7", "HotKeyPressed")	;Save desktop 7 executables
HotKeySet("#!7", "HotKeyPressed")	;Load desktop 7 executables
HotKeySet("#^8", "HotKeyPressed")	;Save desktop 8 executables
HotKeySet("#!8", "HotKeyPressed")	;Load desktop 8 executables
HotKeySet("#^9", "HotKeyPressed")	;Save desktop 9 executables
HotKeySet("#!9", "HotKeyPressed")	;Load desktop 9 executables
HotKeySet("#^0", "HotKeyPressed")	;Save desktop 0 executables
HotKeySet("#!0", "HotKeyPressed")	;Load desktop 0 executables
HotKeySet("#/", "HotKeyPressed")	;Display help
HotKeySet("#?", "HotKeyPressed")	;Display help
HotKeySet("#^!{LEFT}", "HotKeyPressed")		;Move window
HotKeySet("#^!{RIGHT}", "HotKeyPressed")	;Move window
HotKeySet("#^!{UP}", "HotKeyPressed")		;Move window
HotKeySet("#^!{DOWN}", "HotKeyPressed")		;Move window
HotKeySet("^!{RIGHT}", "HotKeyPressed")		 ;Arrange windows in tile layout on the monitor of the active windows. increase number of collumns
HotKeySet("^!{LEFT}", "HotKeyPressed")		 ;Arrange windows in tile layout on the monitor of the active windows. decrease number of collumns
HotKeySet("^!{UP}", "HotKeyPressed")		 ;Arrange windows in tile layout on the monitor of the active windows. increase number of lines
HotKeySet("^!{DOWN}", "HotKeyPressed")		 ;Arrange windows in tile layout on the monitor of the active windows. decrease number of lines
HotKeySet("^!{SPACE}", "HotKeyPressed")		 ;Center window around mouse
HotKeySet("#v", "HotKeyPressed")		 	;Tile vertical on active monitor
HotKeySet("#h", "HotKeyPressed")		 	;Tile horizontal on active monitor
HotKeySet("#^v", "HotKeyPressed")		 	;Tile vertical decrease master area
HotKeySet("#!v", "HotKeyPressed")		 	;Tile vertical increase master area
HotKeySet("#+v", "HotKeyPressed")			;Toggle window as master
HotKeySet("#^h", "HotKeyPressed")		 	;Tile horizontal decrease master area
HotKeySet("#!h", "HotKeyPressed")		 	;Tile horizontal increase master area
HotKeySet("#+h", "HotKeyPressed")			;Toggle window as master
HotKeySet("#;", "HotKeyPressed")			;Toggle repeat last command
HotKeySet("#{SPACE}", "HotKeyPressed")		;Toggle repeat last command
HotKeySet("+{SPACE}", "HotKeyPressed")		 ;Toggle new window follow mouse
HotKeySet("#^o", "HotKeyPressed")		 	;Tile best on active monitor
HotKeySet("#y", "HotKeyPressed")		 	;Execute script
HotKeySet("#^y", "HotKeyPressed")		 	;Edit script
HotKeySet("#^!y", "HotKeyPressed")		 	;Stop script
HotKeySet("#{TAB}", "HotKeyPressed")		;Next window only on this monitor
HotKeySet("#e", "HotKeyPressed")		;Move window to next monitor
HotKeySet("#{LEFT}", "HotKeyPressed")		;Move window to previous monitor


$logfile=FileOpen("log.txt", $FO_OVERWRITE)


Global $MouseMovePeriod=50	;Seconds

;1 Handle;2 State;3 PosX;4 PosY;5 width;6 height;
Global $WinSavedState[10000][6]
Global $winlist
Global $wincount
Global $topmostlist[10000][2]
Global $activewinhandle
Global $cycle=0
Global $Timer1=0
Global $Timer2=0
Global $Timer3=0	;Mouse moves periodically to prevent sleep
Global $Timer4=0	;Arrange vertical timer
Global $Timer4Max=7
Global $Timer5=0	;Repeat commands timer
Global $Timer5Max=1
Global $LastCmdRepeat=False
Global $LastCmd=0

Global $MoveStep=1
Global $TileCollumns=1
Global $TileRows=1
Global $WinSwitchIndex=0
Global $VisibleWindows[0]	;Array of handle of all visible windows
Global $IgnoreWindowTitles[0]	;Array of window titles to ignore in some places
Global $MasterPercentV=70
Global $MasterPercentH=70
Global $MasterWindows[0]	;Array of handle of windows that should be placed into a master location
Global $NewWindowFollowMouse=True
Global $bKeepWindowActive = False
Global $hKeepWindowActive

;Variables to move mouse periodically if not moved for $MouseMovePeriod
Global $MouseSavedX
Global $MouseSavedY

;Array of monitors that are part of the desktop
Global $monitors[0][0]

Global $SriptPID

$topmostlist[0][0]=0
ReadIgnore()
GetWindowList()

While True
	  Sleep(500)
	  Periodic()
Wend

Func LogAllWindows()
   For $i = 1 To $wincount
		 $winstate=WinStateToString($winlist[$i][1])
		 FileWriteLine($logfile, "Title: '"& $winlist[$i][0] & "' State: " & $winstate)
   Next
EndFunc

Func GetWindowList()
   $winlist=WinList()
   $wincount=$winlist[0][0]
   $activewinhandle=WinGetHandle("")
   Local $i=0
   While @error
	  $activewinhandle=WinGetHandle("")
	  $i += 1
	  if $i>10 Then
		 ExitLoop
	  EndIf
   WEnd
EndFunc

Func Quit()
   FileWriteLine($logfile, "Func Quit: ")
   FileClose($logfile)
   Exit
EndFunc

Func WinSetState_($hwnd, $state)
   WinSetState($hwnd, "", @SW_RESTORE)
   if BitAND($state, $WIN_STATE_VISIBLE) Then
	  WinSetState($hwnd, "", @SW_SHOW)
   Else
	  WinSetState($hwnd, "", @SW_HIDE)
   EndIf
   if BitAND($state, $WIN_STATE_ENABLED) Then
	  WinSetState($hwnd, "", @SW_ENABLE)
   Else
	  WinSetState($hwnd, "", @SW_DISABLE)
   EndIf
   if BitAND($state, $WIN_STATE_MINIMIZED) Then
	  WinSetState($hwnd, "", @SW_MINIMIZE)
   EndIf
   if BitAND($state, $WIN_STATE_MAXIMIZED) Then
	  WinSetState($hwnd, "", @SW_MAXIMIZE)
   EndIf

EndFunc


Func WinStateToString($hWnd)
;FileWriteLine($logfile, "Func WinStateToString($hWnd): ")
   Local $s=WinGetState($hwnd)
   Local $str=""
   if BitAND($s, $WIN_STATE_EXISTS) Then
	  $str=$str&"$WIN_STATE_EXISTS,"
   EndIf
   if BitAND($s, $WIN_STATE_VISIBLE) Then
	  $str=$str&"$WIN_STATE_VISIBLE,"
   EndIf
   if BitAND($s, $WIN_STATE_ENABLED) Then
	  $str=$str&"$WIN_STATE_ENABLED,"
   EndIf
   if BitAND($s, $WIN_STATE_ACTIVE) Then
	  $str=$str&"$WIN_STATE_ACTIVE,"
   EndIf
   if BitAND($s, $WIN_STATE_MINIMIZED) Then
	  $str=$str&"$WIN_STATE_MINIMIZED,"
   EndIf
   if BitAND($s, $WIN_STATE_MAXIMIZED) Then
	  $str=$str&"$WIN_STATE_MAXIMIZED,"
   EndIf
Return $str
EndFunc

Func LogWisibleWindows()
FileWriteLine($logfile, "Func LogWisibleWindows: ")
   For $i = 1 To $wincount
	  Local $title=$winlist[$i][0]
	  Local $h=$winlist[$i][1]
	  Local $s=WinGetState($h)

	  if BitAND($s, $WIN_STATE_VISIBLE ) And $title<>"" Then
		 FileWriteLine($logfile, "Title: '"& $title & "' State: " & WinStateToString($winlist[$i][1]))
	  EndIf
   Next
EndFunc

Func HotKeyPressed()
   ;ConsoleWrite("Hotkey: " & @HotKeyPressed & @CRLF)
   GetWindowList()
   Switch @HotKeyPressed
	  Case "#s"
		 ActivateNextWindow()
	  Case "#a"
		 ActivatePreviousWindow()
	  Case "#{TAB}"
		 ActivateNextWindowOnMonitor()
	  Case "#^q"
		 Quit()
	 Case "#m"
		 $LastCmd = 1
		 $Timer5 = 0
		 WinMaximizeVisible()
	  Case "#^!s"
		 WinSaveState()
	  Case "#^!r"
		 WinRestoreState()
	  Case "#^t"
		 WinToggleTopMost()
	  Case "#i"
		 LogWin()
	  Case "#c"
		 WinCloseActive()
	  Case "#^!c"
		 WinCloseByClass()
	  Case "#^!m"
		 WinMaximizeByClass()
	  Case "#^!a"
		 WinArrangeByClass()
	  Case "#k"
		 WinToggleCaption()
	  Case "#^!k"
		 WinToggleCaptionVisible()
	  Case "#^m"
		 WinMaximizeActive()
	  Case "#^x"
		 WinMaximizeActive()
	  Case "#x"
		 WinMaximizeActive()
	  Case "#^!{LEFT}"
		 WinMoveLeft()
	  Case "#^!{RIGHT}"
		 WinMoveRight()
	  Case "#^!{UP}"
		 WinMoveUp()
	  Case "#^!{DOWN}"
		 WinMoveDown()
	  Case "#^1"
		 SaveDesktop("1")
	  Case "#!1"
		 LoadDesktop("1")
	  Case "#^2"
		 SaveDesktop("2")
	  Case "#!2"
		 LoadDesktop("2")
	  Case "#^3"
		 SaveDesktop("3")
	  Case "#!3"
		 LoadDesktop("3")
	  Case "#^4"
		 SaveDesktop("4")
	  Case "#!4"
		 LoadDesktop("4")
	  Case "#^5"
		 SaveDesktop("5")
	  Case "#!5"
		 LoadDesktop("5")
	  Case "#^6"
		 SaveDesktop("6")
	  Case "#!6"
		 LoadDesktop("6")
	  Case "#^7"
		 SaveDesktop("7")
	  Case "#!7"
		 LoadDesktop("7")
	  Case "#^8"
		 SaveDesktop("8")
	  Case "#!8"
		 LoadDesktop("8")
	  Case "#^9"
		 SaveDesktop("9")
	  Case "#!9"
		 LoadDesktop("9")
	  Case "#^0"
		 SaveDesktop("0")
	  Case "#!0"
		 LoadDesktop("0")
	  Case "#/"
		 DisplayHelp()
	  Case "#?"
		 DisplayHelp()
	Case "^!{RIGHT}"
		TileWindows(-1, 0)
	Case "^!{LEFT}"
		TileWindows(1, 0)
	Case "^!{UP}"
		TileWindows(0, 1)
	Case "^!{DOWN}"
		TileWindows(0, -1)
   Case "#b"
	  WinToggleBorder()
   Case "#^!b"
	  WinToggleBorderVisible()
   Case "^!{SPACE}"
	  WinCenterMouse($activewinhandle)
	Case "#v"
		$LastCmd = 2
		$Timer5 = 0
		WinTileVertHoriz(True)
	Case "#h"
		$LastCmd = 3
		$Timer5 = 0
		WinTileVertHoriz(False)
	Case "#^v"
		$LastCmd = 4
		$Timer5 = 0
		WinTileVertMaster(-2)
	Case "#!v"
		$LastCmd = 4
		$Timer5 = 0
		WinTileVertMaster(2)
	Case "#+v"
		$LastCmd = 4
		$Timer5 = 0
		ToggleWindowMaster($activewinhandle)
		WinTileVertMaster(0)
	Case "#^h"
		$LastCmd = 5
		$Timer5 = 0
		WinTileHorizMaster(-2)
	Case "#!h"
		$LastCmd = 5
		$Timer5 = 0
		WinTileHorizMaster(2)
	Case "#+h"
		$LastCmd = 5
		$Timer5 = 0
		ToggleWindowMaster($activewinhandle)
		WinTileHorizMaster(0)
	Case "#;"
		RepeatLastCommand()
	Case "#{SPACE}"
		RepeatLastCommand()
	Case "+{SPACE}"
		NewWindowFollowMouseFunc()
	Case "#^!t"
		KeepWindowActive()
	Case "#^o"
		$LastCmd = 6
		TileAll()
	case "#y"
		ExecuteScript()
	case "#^y"
		EditScript()
	case "#^!y"
		StopScript()
	case "#e" ;"#{RIGHT}"
		MoveWindowToNextMonitor()
	case "#{LEFT}"
		MoveWindowToPrevMonitor()


   EndSwitch
EndFunc



Func NewWindowFollowMouseFunc()
	if not $NewWindowFollowMouse Then
		$NewWindowFollowMouse = True
		MsgBox(0, "New windows follow mouse", "ON", 1)
	Else
		$NewWindowFollowMouse = False
		MsgBox(0, "New windows follow mouse", "OFF", 1)
	EndIf
EndFunc

Func WinMaximizeVisible()
   ScanVisibleWindows()
	;FileWriteLine($logfile, "Func WinMaximizeVisible: ")
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $windows[0]
	For $i = 0 To UBound($VisibleWindows)-1
		Local $h=$VisibleWindows[$i]
		Local $title=WinGetTitle($h)
		Local $s=WinGetState($h)
		Local $wm = _WinAPI_MonitorFromWindow($h, $MONITOR_DEFAULTTONEAREST)
		if $wm = $monitor Then
			_ArrayAdd($windows, $h)
		 EndIf
	 Next

	Local $NumberOfWindows = UBound($windows) - 1

	For $i = 0 To $NumberOfWindows
		Local $h = $windows[$i]
		WinSetState($h, "", @SW_MAXIMIZE)
	Next
EndFunc

Func WinSaveState()
   FileWriteLine($logfile, "Func WinSaveState(): ")
   ;1 Handle;2 State;3 PosX;4 PosY;5 width;6 height; 7 topmost
   $c=0
   For $i = 1 To $wincount
	  Local $title=$winlist[$i][0]
	  Local $h=$winlist[$i][1]
	  Local $s=WinGetState($h)
	  Local $a=WinGetPos($h)

	  if BitAND($s, $WIN_STATE_VISIBLE) And $title<>"" Then
		 $c=$c+1
		 $WinSavedState[0][0]=$c		;Number of saved windows
		 $WinSavedState[$c][0]=$h		;Handle
		 $WinSavedState[$c][1]=$s		;State
		 $WinSavedState[$c][2]=$a[0]	;X
		 $WinSavedState[$c][3]=$a[1]	;Y
		 $WinSavedState[$c][4]=$a[2]	;W
		 $WinSavedState[$c][5]=$a[3]	;H
	  EndIf
   Next
   LogSavedState()
EndFunc

Func WinRestoreState()
FileWriteLine($logfile, "Func WinRestoreState(): ")
;1 Handle;2 State;3 PosX;4 PosY;5 width;6 height
   For $i = 1 To $WinSavedState[0][0]
	  Local $title=$winlist[$i][0]
	  Local $h=$WinSavedState[$i][0]
	  Local $s=$WinSavedState[$i][1]
	  For $j=1 to $wincount
		 if $winlist[$j][1]=$h Then
;			FileWriteLine($logfile, "WinRestoreState(): " & $winlist[$j][0] & " " & $WinSavedState[$i][0] & " " & $WinSavedState[$i][1] & " " & $WinSavedState[$i][2] & " " & $WinSavedState[$i][3] & " " & $WinSavedState[$i][4] & " " & $WinSavedState[$i][5])
			WinSetState_($h, $s)
			WinMove($h, "", $WinSavedState[$i][2], $WinSavedState[$i][3], $WinSavedState[$i][4], $WinSavedState[$i][5])
			;WinMove($h, "", 0, 0, 1000, 1000)
		 EndIf
	  Next
   Next
   LogSavedState()
EndFunc

Func LogSavedState()
   For $i = 1 To $WinSavedState[0][0]
	  FileWriteLine($logfile, "LogSavedState(): "  & $i & " " & $WinSavedState[$i][0] & " " & $WinSavedState[$i][1] & " " & $WinSavedState[$i][2] & " " & $WinSavedState[$i][3] & " " & $WinSavedState[$i][4] & " " & $WinSavedState[$i][5])
   Next
EndFunc

Func WinToggleTopMost()
	Local $h=$activewinhandle
	Local $found=0
	Local $foundindex=0
	Local $c=$topmostlist[0][0]
	for $j=1 to $c
		if $h=$topmostlist[$j][0] Then
		   $found=$h
		   $foundindex=$j
		EndIf
	 Next
	if $found Then
		If $topmostlist[$foundindex][1]=$WINDOWS_NOONTOP Then
		   $topmostlist[$foundindex][1]=$WINDOWS_ONTOP
		Else
		   $topmostlist[$foundindex][1]=$WINDOWS_NOONTOP
		EndIf
		WinSetOnTop($h, "", $topmostlist[$foundindex][1])
	Else
		$c=$c+1
		$topmostlist[$c][0]=$h
		$topmostlist[$c][1]=$WINDOWS_ONTOP
		$topmostlist[0][0]=$c
		WinSetOnTop($h, "", $WINDOWS_ONTOP)
	EndIf
EndFunc

;Return index in winlist of the active window
Func FindActiveWindow()
   Local $h=0
   Local $index=0
   For $i = 1 To $wincount
	  $h=$winlist[$i][1]
	  if WinActive($h) Then
		 $index=$i
		 $i=$wincount
		 ExitLoop
	  EndIf
   Next
   Return $index
EndFunc

Func LogVisible()
	FileWriteLine($logfile, "Visible windows")
	for $i=0 To UBound($VisibleWindows)-1
		$h = $VisibleWindows[$i]
		Local $class=_WinAPI_GetClassName($h)
		FileWriteLine($logfile, "Func LogVisible(): Handle=" & $h & " Title=" & WinGetTitle($h) & " Class=" & $class)
	Next
EndFunc

Func LogWin()
;   Local $index=FindActiveWindow()
	Local $h=$activewinhandle
	Local $class=_WinAPI_GetClassName($h)
	FileWriteLine($logfile, "Func LogWin(): Handle=" & $h & " Title=" & WinGetTitle($h) & " Class=" & $class)
	LogVisible()
EndFunc

Func FindClassRegexp($class)
   Local $file=FileOpen("Classes")
   Local $Result=""
   if $file>0 Then
	  While @error<>-1
		 Local $l = FileReadLine($file)
		 If @error = -1 Then
			ExitLoop
		 EndIf
		 If StringRegExp($class, $l) Then
			$Result=$l
			FileWriteLine($logfile, "FindClassRegexp(" & $class & ")" &"--->" & $Result)
		 EndIf
	  WEnd
   EndIf
   Return $Result
EndFunc

Func WinCloseByClass()
   FileWriteLine($logfile, "Func WinCloseByClass(): ")
   Local $index=FindActiveWindow()
   if $index Then
	  Local $h=$winlist[$index][1]
	  Local $c=_WinAPI_GetClassName($h)
	  Local $s=WinGetState($h)
	  Local $rgxp=FindClassRegexp($c)
	  For $i = 1 To $wincount
		 Local $hh=$winlist[$i][1]
		 Local $cc=_WinAPI_GetClassName($hh)
		 Local $match=0
		 if $rgxp<>"" Then
			If StringRegExp($cc, $rgxp) Then
			   $match=1
			EndIf
		 EndIf
		 if $cc=$c or $match>0 Then
			Local $ss=WinGetState($hh)
			if BitAND($ss, $WIN_STATE_VISIBLE) Then
			   FileWriteLine($logfile, "Closing: Name=" & $winlist[$i][0] & " Handle=" & $winlist[$i][1] & " Class=" & $cc)
			   WinClose($hh)
			EndIf
		 EndIf
	  Next
   EndIf
EndFunc

Func WinMaximizeByClass()
   FileWriteLine($logfile, "Func WinMaximizeByClass(): ")
	Local $h=$activewinhandle
	Local $c=_WinAPI_GetClassName($h)
	Local $s=WinGetState($h)
	Local $rgxp=FindClassRegexp($c)
	For $i = 1 To $wincount
		Local $hh=$winlist[$i][1]
		Local $cc=_WinAPI_GetClassName($hh)
		Local $match=0
		if $rgxp<>"" Then
			If StringRegExp($cc, $rgxp) Then
				$match=1
			EndIf
		EndIf
		if $cc=$c or $match>0 Then
			Local $ss=WinGetState($hh)
			if BitAND($ss, $WIN_STATE_VISIBLE) Then
				FileWriteLine($logfile, "Maximize: Name=" & $winlist[$i][0] & " Handle=" & $winlist[$i][1] & " Class=" & $cc)
				WinSetState($hh, "" , @SW_MAXIMIZE)
			EndIf
		EndIf
	Next

EndFunc

Func WinArrangeByClass()
	;ConsoleWrite("WinArrangeByClass()" & @CRLF)
	Local $mc = MonitorCount()
	;ConsoleWrite("$mc" & " = " & $mc & @CRLF)
	Local $DesktopX0=_WinAPI_GetSystemMetrics(76)	;SM_XVIRTUALSCREEN
	Local $DesktopY0=_WinAPI_GetSystemMetrics(77)	;SM_YVIRTUALSCREEN
	Local $DesktopSizeX=_WinAPI_GetSystemMetrics(78)	;SM_CXVIRTUALSCREEN
	Local $DesktopSizeY=_WinAPI_GetSystemMetrics(79)	;SM_CYVIRTUALSCREEN
	FileWriteLine($logfile, "Func WinArrangeByClass(): X0=" & $DesktopX0 & ", Y0=" & $DesktopY0 & ", Size X=" & $DesktopSizeX &", Size Y=" & $DesktopSizeY)
	Local $index=FindActiveWindow()
	Local $wc=0	;Number of windows that match the criteria
	Local $windows[0]
	if $index Then
		Local $h=$winlist[$index][1]
		Local $c=_WinAPI_GetClassName($h)
		Local $rgxp=FindClassRegexp($c)
		For $i = 1 To $wincount
			Local $hh=$winlist[$i][1]
			Local $cc=_WinAPI_GetClassName($hh)
			Local $ss=WinGetState($hh)
			Local $match=0
			if $rgxp<>"" Then
				If StringRegExp($cc, $rgxp) Then
					$match=1
				EndIf
			EndIf
			if $cc=$c or $match>0 Then
				if BitAND($ss, $WIN_STATE_VISIBLE) Then
					$wc=$wc+1
					_ArrayAdd($windows, $hh)
				EndIf
			EndIf
		Next
	EndIf

	Local $WinCountPerMonitor = Floor($wc / $mc)
	Local $WinCountDiff = $wc - $WinCountPerMonitor * $mc

	;ConsoleWrite("$wc" & " = " & $wc & @CRLF)
	;ConsoleWrite("$WinCountPerMonitor" & " = " & $WinCountPerMonitor & @CRLF)
	;ConsoleWrite("$WinCountDiff" & " = " & $WinCountDiff & @CRLF)

	Local $i = 0

	if $WinCountPerMonitor <= 0 Then
		$mc = 1
	EndIf

	For $m = 1 to $mc
		Local $monitorinfo = _WinAPI_GetMonitorInfo($monitors[$m][0])
		If not IsArray($monitorinfo) Then
			;ConsoleWrite("Not a monitor" & @CRLF)
			ExitLoop
		EndIf

		Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
		Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

		Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3) - $MonitorX0
		Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4) - $MonitorY0

		Local $wcm
		if $m = $mc Then
			$wcm = $WinCountPerMonitor + $WinCountDiff
		Else
			$wcm = $WinCountPerMonitor
		EndIf

		Local $divy=Floor(Sqrt($wcm))
		Local $divx=Floor($wcm/$divy)

		if $divx * $divy < $wcm Then
			$divx = $divx + 1
		EndIf

		Local $wSizeX=$MonitorSizeX/$divx
		Local $wSizeY=$MonitorSizeY/$divy

		Local $wPosX=$MonitorX0
		Local $wPosY=$MonitorY0
		Local $x = 0

		;ConsoleWrite("$wcm" & " = " & $wcm & @CRLF)
		for $j = $i to $i + $wcm -1
			Local $hh = $windows[$j]
			Local $winstyle = _WinAPI_GetWindowLong($hh, $GWL_STYLE)
			$winStyle = BitAND($winStyle, BitNOT($WS_THICKFRAME))
			_WinAPI_SetWindowLong($hh, $GWL_STYLE , $winStyle)
			WinMove($hh, "" , $wPosX, $wPosY, $wSizeX, $wSizeY)
			;ConsoleWrite("WinMove(" & $hh & ", " & $wPosX &", " & $wPosY & ", " & $wSizeX & ", " & $wSizeY &")" & @CRLF)
			$wPosX=$wPosX+$wSizeX
			$x=$x+1
			if $x>=$divx Then
			  ;WinMove($hh, "" , $wPosX, $wPosY, $DesktopSizeX-$wPosX-$wPosX, $wSizeY)
				$wPosY=$wPosY+$wSizeY
				$wPosX=$MonitorX0
				$x=0
			EndIf
		Next
		$i += $wcm
		if $i >= $wc Then
			ExitLoop
		EndIf
	Next
EndFunc


;Toggle window title bar for one window
Func WinToggleCaption()
   Local $h=$activewinhandle
   Local $style=_WinAPI_GetWindowLong($h, $GWL_STYLE)
   if BitAND($style, $WS_CAPTION) Then
		$style = BitAND($style, BitNOT($WS_CAPTION))
		_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
   Else
		$style = BitOr($style, $WS_CAPTION)
		_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
   EndIf
   Local $a=WinGetPos($h, "")
   WinMove($h, "" , $a[0]+1, $a[1], $a[2], $a[3])
   WinMove($h, "" , $a[0], $a[1], $a[2], $a[3])
   _WinAPI_RedrawWindow($h, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
EndFunc

;Toggle window title bar for all visible windows
Func WinToggleCaptionVisible()
   For $i = 1 To $wincount
	  Local $title=$winlist[$i][0]
	  Local $h=$winlist[$i][1]
	  Local $s=WinGetState($h)
	  if BitAND($s, $WIN_STATE_VISIBLE) And $title<>"" Then
		 Local $style=_WinAPI_GetWindowLong($h, $GWL_STYLE)
		 if BitAND($style, $WS_CAPTION) Then
			$style = BitAND($style, BitNOT($WS_CAPTION))
			_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
		 Else
			$style = BitOr($style, $WS_CAPTION)
			_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
		 EndIf
		 Local $a=WinGetPos($h, "")
		 WinMove($h, "" , $a[0]+1, $a[1], $a[2], $a[3])
		 WinMove($h, "" , $a[0], $a[1], $a[2], $a[3])
		 _WinAPI_RedrawWindow($h, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	  EndIf
   Next
EndFunc

Func WinMaximizeActive()
   $LastCmdRepeat=False
   Local $h=$activewinhandle
   Local $s = WinGetState($h)
   if BitAND($s, $WIN_STATE_MAXIMIZED) Then
	  WinSetState($h, "", @SW_RESTORE)
   Else
	  WinSetState($h, "", @SW_MAXIMIZE)
   EndIf
EndFunc

Func WinMoveLeft()
   Local $h=$activewinhandle
   Local $a = WinGetPos($h)
	$a[0] = $a[0] - $MoveStep
	WinMove($h, "", $a[0], $a[1])
	$Timer1=0
	$MoveStep = $MoveStep + 1
EndFunc

Func WinMoveRight()
   Local $h=$activewinhandle
   Local $a = WinGetPos($h)
   $a[0] = $a[0] + $MoveStep
   WinMove($h, "", $a[0], $a[1])
   $Timer1=0
	$MoveStep = $MoveStep + 1
EndFunc

Func WinMoveUp()
	Local $h=$activewinhandle
	Local $a = WinGetPos($h)
	$a[1] = $a[1] - $MoveStep
	WinMove($h, "", $a[0], $a[1])
	$Timer1=0
	$MoveStep = $MoveStep + 1
EndFunc

Func WinMoveDown()
   Local $h=$activewinhandle
   Local $a = WinGetPos($h)
   $a[1] = $a[1] + $MoveStep
   WinMove($h, "", $a[0], $a[1])
   $Timer1=0
	$MoveStep = $MoveStep + 1
EndFunc

Func Periodic()
	$cycle = $cycle + 1
	;Timer1
	if $Timer1 >= 1 Then
		$MoveStep = 1
	EndIf
	$Timer1 = $Timer1 + 1

	;Timer2
;	if $Timer2 >= 20 Then
;		ScanVisibleWindows()
;	EndIf
	$Timer2 = $Timer2 + 1

	;Timer3
	if $Timer3 >= ($MouseMovePeriod * 2) Then
		MoveMouse()
	EndIf
	$Timer3 = $Timer3 + 1

   ;Timer 4
	$Timer4 = $Timer4 + 1


   ;Timer 5
   if $Timer4 > $Timer4Max Then
	   $Timer5 = $Timer5 + 1
   EndIf

	if $Timer5 > $Timer5Max Then
		$Timer5 = 0
		SendLastCmd()
	EndIf

	MouseGetPos()

	;New window
	if $NewWindowFollowMouse Then
		Local $h = WinGetHandle("")
		if IsNewWindow($h) Then
			WinMoveToMouse($h)
			GetWindowList()
		EndIf
	EndIf

	;Keep window active
	if $bKeepWindowActive Then
		WinActivate($hKeepWindowActive)
	EndIf
EndFunc

Func MoveMouse()
	;ConsoleWrite("MoveMouse" & @CRLF)
	Local $a = MouseGetPos()
	if $MouseSavedX = $a[0] and $MouseSavedY = $a[1] Then
		;ConsoleWrite("MoveMouse:Moving" & @CRLF)
		MouseMove($a[0]+1, $a[1]+1)
		MouseMove($a[0]-1, $a[1]-1)
		MouseMove($a[0], $a[1])
	EndIf
	$MouseSavedX = $a[0]
	$MouseSavedY = $a[1]
	$Timer3 = 0
EndFunc


Func ScanVisibleWindows()
	$Timer2 = 0
	;ConsoleWrite("ScanVisibleWindows()" & @CRLF)
	;ConsoleWrite("Wincount: " & $wincount & @CRLF)

	_ArrayDelete($VisibleWindows, "0-" & String(UBound($VisibleWindows)-1))
	for $i = 1 to $wincount
 		Local $title=$winlist[$i][0]
		Local $h=$winlist[$i][1]
		Local $s=WinGetState($h)

		if BitAND($s, $WIN_STATE_VISIBLE) And $title<>""  Then
		   _ArrayAdd($VisibleWindows, $h)
		EndIf
	Next

	;Remove not existing and ignored windows
	;ConsoleWrite("Ubound: " & UBound($VisibleWindows)-1 & @CRLF)
	Local $wins[0]

	for $i=0 to UBound($VisibleWindows)-1
		Local $h = $VisibleWindows[$i]
		if WinExists($h) and (not IsIgnored($h)) Then
		   _ArrayAdd($wins, $h)
		EndIf
	Next
	$VisibleWindows = $wins
	_ArraySort($VisibleWindows)
EndFunc


Func IsVisibleWindow($h)
	;ConsoleWrite("IsVisibleWindow(" & $h & ")" & @CRLF)
	Local $i = _ArrayBinarySearch($VisibleWindows, $h)
	Local $r = False
	if $i >= 0 Then
		$r = True
	EndIf
	;ConsoleWrite("$r=" & $r & @CRLF)
	Return $r
EndFunc

Func IsNewWindow($h)
	;ConsoleWrite("IsNewWindow(" & $h & ")" & @CRLF)
	Local $r = True
	For $i = 1 To $wincount
		Local $hh=$winlist[$i][1]
		if $h = $hh Then
			$r = False
			ExitLoop
		EndIf
	Next
	;ConsoleWrite("$r=" & $r & @CRLF)
	Return $r
EndFunc

Func SaveDesktop($nr)
   Local $aAdjust
   Local $hToken = _WinAPI_OpenProcessToken(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
   _WinAPI_AdjustTokenPrivileges($hToken, $SE_DEBUG_NAME, $SE_PRIVILEGE_ENABLED, $aAdjust)

   FileWriteLine($logfile, "SaveDesktop(" & $nr & ")")
   Local $file = FileOpen($nr, $FO_OVERWRITE)
   if @error Then
	  Return
   EndIf
   For $i = 1 To $wincount
	  Local $title=$winlist[$i][0]
	  Local $h=$winlist[$i][1]
	  Local $s=WinGetState($h)
	  if BitAND($s, $WIN_STATE_VISIBLE) And $title<>"" Then
		 Local $a = WinGetPos($h)
		 Local $pid = WinGetProcess($h)
		 Local $class=_WinAPI_GetClassName($h)
		 Local $handle = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, 0, $pid)
		 if $handle > 0 Then
			Local $exe = _WinAPI_GetModuleFileNameEx($handle)
			Local $cmdline = _WinAPI_GetProcessCommandLine($pid)
			_WinAPI_CloseHandle($handle)
			FileWriteLine($logfile, "	" & "Title = " & $title & ", Handle = " & $h & ", PID = " & $pid & ", exe = " & $exe & ", X = " & $a[0] & ", Y = " & $a[1] & ", W = " & $a[2] & ", H = " & $a[3])
			FileWriteLine($file, $exe & "," & $cmdline & "," & $a[0] & "," &  $a[1] & "," & $a[2] & "," & $a[3] & "," & $class)
		 EndIf
	  EndIf
   Next
   FileClose($file)
   _WinAPI_AdjustTokenPrivileges($hToken, $aAdjust, 0, $aAdjust)
   _WinAPI_CloseHandle($hToken)
EndFunc

Func LoadDesktop($nr)
   FileWriteLine($logfile, "LoadDesktop(" & $nr & ")")
   Local $file = FileOpen($nr, $FO_READ)
   if @error Then
	  Return
   EndIf
   While True
	  Local $line = FileReadLine($file)
	  if @error Then
		 ExitLoop
	  EndIf
	  Local $splitted = StringSplit($line, ",")
	  Local $exe = $splitted[1]
	  Local $arg = $splitted[2]
	  Local $x = $splitted[3]
	  Local $y = $splitted[4]
	  Local $w = $splitted[5]
	  Local $h = $splitted[6]
	  Local $class = $splitted[7]
	  FileWriteLine($logfile, "	" & "exe = " & $exe & ", arg = " & $arg & ", X = " & $x & ", Y = " & $y & ", W = " & $w & ", H = " & $h & ", Class = " & $class)
	  _WinAPI_ShellExecute($exe, $arg, "", "open")
   WEnd
   FileClose($file)
   Sleep(5000)
   GetWindowList()
   ;Position windows
   Local $file = FileOpen($nr, $FO_READ)
   if @error Then
	  Return
   EndIf
	While True
		Local $line = FileReadLine($file)
		if @error Then
			ExitLoop
		EndIf
		Local $splitted = StringSplit($line, ",")
		Local $exe = $splitted[1]
		Local $arg = $splitted[2]
		Local $x = Number($splitted[3])
		Local $y = Number($splitted[4])
		Local $w = Number($splitted[5])
		Local $height = Number($splitted[6])
		Local $fclass = $splitted[7]
		For $i = 1 To $wincount
			Local $title=$winlist[$i][0]
			Local $h=$winlist[$i][1]
			Local $s=WinGetState($h)
			if BitAND($s, $WIN_STATE_VISIBLE) And $title<>"" And $h<>0 Then
				Local $class=_WinAPI_GetClassName($h)
				if $fclass = $class Then
					FileWriteLine($logfile, "	Moving window" & "exe = " & $exe & ", arg = " & $arg & ", X = " & $x & ", Y = " & $y & ", W = " & $w & ", H = " & $height & ", Class = " & $class)
					WinMove($h, "" , $x, $y, $w, $height)
					$winlist[$i][1]=0
					$i = $wincount
				EndIf
			EndIf
		Next
	WEnd
	FileClose($file)
EndFunc

Func DisplayHelp()
	Local $s
	$s = 	"Win+Ctrl+q	-	Quit" & @CRLF
	$s = $s & "Win+s		-	Activate next window" & @CRLF
	$s = $s & "Win+a	-		Activate previous window" & @CRLF
	$s = $s & "Win+m		-	Maximize all visible windows on active monitor" & @CRLF
	$s = $s & "Win+Ctrl+m	-	Maximize active window" & @CRLF
	$s = $s & "Win+Ctrl+x	-	Maximize active window" & @CRLF
	$s = $s & "Win+x		-	Maximize active window" & @CRLF
	$s = $s & "Win+Ctrl+Alt+s	-	Save windows positions" & @CRLF
	$s = $s & "Win+Ctrl+Alt+r	-	Restore windows positions" & @CRLF
	$s = $s & "Win+Ctrl+t	-	Set topmost for active window" & @CRLF
	$s = $s & "Win+Ctrl+Alt+t	-	Keep window activated" & @CRLF
	$s = $s & "Win+i		-	Dump windows info to log file" & @CRLF
	$s = $s & "Win+c		-	Close active window" & @CRLF
	$s = $s & "Win+Ctrl+Alt+c	-	Close all visible windows of the active window's class" & @CRLF
	$s = $s & "Win+Ctrl+Alt+m	-	Maximize all visible windows of the active window's class" & @CRLF
	$s = $s & "Win+Ctrl+Alt+a	-	Arrange all visible windows of the active window's class" & @CRLF
	$s = $s & "Win+k		-	Toggle caption for active window" & @CRLF
	$s = $s & "Win+Ctrl+Alt+k	-	Toggle caption all visible windows" & @CRLF
	$s = $s & "Win+b		-	Toggle border for active window" & @CRLF
	$s = $s & "Win+Ctrl+Alt+b	-	Toggle border all visible windows" & @CRLF
	$s = $s & "Win+Ctrl+1	-	Save desktop 1 executables" & @CRLF
	$s = $s & "Win+Alt+1	-	Load desktop 1 executables" & @CRLF
	$s = $s & "Win+Ctrl+2	-	Save desktop 2 executables" & @CRLF
	$s = $s & "Win+Alt+2	-	Load desktop 2 executables" & @CRLF
	$s = $s & "Win+Ctrl+3	-	Save desktop 3 executables" & @CRLF
	$s = $s & "Win+Alt+3	-	Load desktop 3 executables" & @CRLF
	$s = $s & "Win+Ctrl+4	-	Save desktop 4 executables" & @CRLF
	$s = $s & "Win+Alt+4	-	Load desktop 4 executables" & @CRLF
	$s = $s & "Win+Ctrl+5	-	Save desktop 5 executables" & @CRLF
	$s = $s & "Win+Alt+5	-	Load desktop 5 executables" & @CRLF
	$s = $s & "Win+Ctrl+6	-	Save desktop 6 executables" & @CRLF
	$s = $s & "Win+Alt+6	-	Load desktop 6 executables" & @CRLF
	$s = $s & "Win+Ctrl+7	-	Save desktop 7 executables" & @CRLF
	$s = $s & "Win+Alt+7	-	Load desktop 7 executables" & @CRLF
	$s = $s & "Win+Ctrl+8	-	Save desktop 8 executables" & @CRLF
	$s = $s & "Win+Alt+8	-	Load desktop 8 executables" & @CRLF
	$s = $s & "Win+Ctrl+9	-	Save desktop 9 executables" & @CRLF
	$s = $s & "Win+Alt+9	-	Load desktop 9 executables" & @CRLF
	$s = $s & "Win+Ctrl+0	-	Save desktop 0 executables" & @CRLF
	$s = $s & "Win+Alt+0	-	Load desktop 0 executables" & @CRLF
	$s = $s & "Win+Ctrl+Alt+LEFT	-	Move window LEFT" & @CRLF
	$s = $s & "Win+Ctrl+Alt+RIGHT	-	Move window RIGHT" & @CRLF
	$s = $s & "Win+Ctrl+Alt+UP	-	Move window UP" & @CRLF
	$s = $s & "Win+Ctrl+Alt+DOWN	-	Move window DOWN" & @CRLF
	$s = $s & "Ctrl+Alt+RIGHT	-	Arrange windows in tile layout on the monitor of the active windows. increase number of collumns" & @CRLF
	$s = $s & "Ctrl+Alt+LEFT	-	Arrange windows in tile layout on the monitor of the active windows. decrease number of collumns" & @CRLF
	$s = $s & "Ctrl+Alt+UP	-	Arrange windows in tile layout on the monitor of the active windows. increase number of lines" & @CRLF
	$s = $s & "Ctrl+Alt+DOWN	-	Arrange windows in tile layout on the monitor of the active windows. decrease number of lines" & @CRLF
	$s = $s & "Ctrl+Alt+SPACE	-	Move active window to mouse position" & @CRLF
	$s = $s & "Shift+SPACE	-	Toggle feature: Move newly created window to mouse position" & @CRLF
	$s = $s & "Win+V	-	Tile windows vertical" & @CRLF
	$s = $s & "Win+H	-	Tile windows horizontal" & @CRLF
	$s = $s & "Win+Ctrl+O	-	Tile windows best fit on active monitor" & @CRLF
	$s = $s & "Win+Ctrl+V	-	Tile vertical decrease master area" & @CRLF
	$s = $s & "Win+Alt+V	-	Tile vertical increase master area" & @CRLF
	$s = $s & "Win+Shift+V	-	Toggle window as master" & @CRLF
	$s = $s & "Win+Ctrl+H	-	Tile horizontal decrease master area" & @CRLF
	$s = $s & "Win+Alt+H	-	Tile horizontal increase master area" & @CRLF
	$s = $s & "Win+Shift+H	-	Toggle window as master" & @CRLF
	$s = $s & "Win+;	-	Periodically repeat last command" & @CRLF
	$s = $s & "Win+Y	-	Execute script" & @CRLF
	$s = $s & "Win+Ctrl+Y	-	Edit script" & @CRLF
	$s = $s & "Win+Ctrl+Alt+Y;	-	Stop script" & @CRLF
	$s = $s & "Win+/		-	Display help"

	MsgBox($MB_OK, "Hotkeys", $s)
EndFunc

Func TileWindows($Xicrement, $Yincrement)
   $LastCmdRepeat=False
   ScanVisibleWindows()
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3)-$MonitorX0
	Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4)-$MonitorY0

	;ConsoleWrite('$MonitorSizeX: ' & $MonitorSizeX & @CRLF)
	;ConsoleWrite('$MonitorSizeY: ' & $MonitorSizeY & @CRLF)

	Local $windows[0]
	For $i = 0 To UBound($VisibleWindows)-1
		Local $h=$VisibleWindows[$i]
		Local $title=WinGetTitle($h)
		Local $s=WinGetState($h)
		Local $wm = _WinAPI_MonitorFromWindow($h, $MONITOR_DEFAULTTONEAREST)
		if $wm = $monitor Then
				;;ConsoleWrite($title & @CRLF)
		 _ArrayAdd($windows, $h)
		 EndIf
	Next

	$TileCollumns = $TileCollumns + $Xicrement
	$TileRows = $TileRows + $Yincrement

	If $TileCollumns < 1 Then
		$TileCollumns = 1
	EndIf

	If $TileRows < 1 Then
		$TileRows = 1
	EndIf

	Local $NumberOfWindows = UBound($windows) - 1
	;ConsoleWrite("Number of windows: " & $NumberOfWindows & @CRLF)
	;ConsoleWrite("Collumns: " & $TileCollumns & @CRLF)
	;ConsoleWrite("Rows: " & $TileRows & @CRLF)

	Local $WinSizeX = Floor($MonitorSizeX/$TileCollumns)
	Local $WinSizeY = Floor($MonitorSizeY/$TileRows)
	;ConsoleWrite("$WinSizeX: " & $WinSizeX & @CRLF)
	;ConsoleWrite("$WinSizeY: " & $WinSizeY & @CRLF)

	Local $WinPosX = $MonitorX0
	Local $WinPosY = $MonitorY0

	For $i = 0 To $NumberOfWindows
		Local $h = $windows[$i]
		Local $s=WinGetState($h)
		if BitAND($s, $WIN_STATE_MAXIMIZED) Then
			WinSetState($h, "", @SW_RESTORE)
		EndIf
		Local $style = _WinAPI_GetWindowLong($h, $GWL_STYLE)

		;Local $ss = BitNOT(BitOR($WS_CAPTION, $WS_THICKFRAME, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SYSMENU))
		Local $ss = BitNOT(BitOR($WS_THICKFRAME, 0))

		$style = BitAND($style, $ss)

		_WinAPI_SetWindowLong($h, $GWL_STYLE , $style)
		WinMove($windows[$i], "", $WinPosX, $WinPosY, $WinSizeX, $WinSizeY)
		;ConsoleWrite("$WinPosX: " & $WinPosX & @CRLF)
		;ConsoleWrite("$WinPosY: " & $WinPosY & @CRLF)
		$WinPosX = $WinPosX + $WinSizeX
		if $WinPosX >= $MonitorSizeX + $MonitorX0 Then
			$WinPosX = $MonitorX0
			$WinPosY = $WinPosY + $WinSizeY
			if $WinPosY >= $MonitorSizeY + $MonitorY0 Then
				$WinPosY = $MonitorY0
			EndIf
		EndIf
	Next
 EndFunc

 ;Toggle window border for one window
Func WinToggleBorder()
   Local $h=$activewinhandle
   Local $style=_WinAPI_GetWindowLong($h, $GWL_STYLE)
   if BitAND($style, $WS_BORDER) Then
		$style = BitAND($style, BitNOT($WS_BORDER))
		_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
   Else
		$style = BitOr($style, $WS_OVERLAPPEDWINDOW)
		_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
   EndIf
   Local $a=WinGetPos($h, "")
   WinMove($h, "" , $a[0]+1, $a[1], $a[2], $a[3])
   WinMove($h, "" , $a[0], $a[1], $a[2], $a[3])
   _WinAPI_RedrawWindow($h, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
EndFunc

;Toggle window border for all visible windows
Func WinToggleBorderVisible()
   For $i = 1 To $wincount
	  Local $title=$winlist[$i][0]
	  Local $h=$winlist[$i][1]
	  Local $s=WinGetState($h)
	  if BitAND($s, $WIN_STATE_VISIBLE) And $title<>"" Then
		 Local $style=_WinAPI_GetWindowLong($h, $GWL_STYLE)
		 if BitAND($style, $WS_BORDER) Then
			$style = BitAND($style, BitNOT($WS_BORDER))
			_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
		 Else
			$style = BitOr($style, $WS_OVERLAPPEDWINDOW)
			_WinAPI_SetWindowLong($h, $GWL_STYLE, $style)
		 EndIf
		 Local $a=WinGetPos($h, "")
		 WinMove($h, "" , $a[0]+1, $a[1], $a[2], $a[3])
		 WinMove($h, "" , $a[0], $a[1], $a[2], $a[3])
		 _WinAPI_RedrawWindow($h, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	  EndIf
   Next
EndFunc

Func WinCloseActive()
   WinClose($activewinhandle)
EndFunc

Func ActivateNextWindow()
	ScanVisibleWindows()
	$Timer2 = 0

	if UBound($VisibleWindows)<=0 Then
		Return
	EndIf

	Local $nextwin = $activewinhandle
	Local $index = _ArrayBinarySearch($VisibleWindows, $activewinhandle)
	if @error Then
		$index = -1
	EndIf

	$index = $index + 1
	if $index<UBound($VisibleWindows) Then
		$nextwin = $VisibleWindows[$index]
	Else
		$index = 0
		$nextwin = $VisibleWindows[$index]
	EndIf
   ;ConsoleWrite("Active: " & WinGetTitle($activewinhandle) & @CRLF)
   ;ConsoleWrite("Next: " & WinGetTitle($nextwin) & @CRLF)
   WinActivate($nextwin)
EndFunc

Func ActivateNextWindowOnMonitor()
	ScanVisibleWindows()
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $windows[0]
	For $i = 0 To UBound($VisibleWindows)-1
		Local $h=$VisibleWindows[$i]
		Local $wm = _WinAPI_MonitorFromWindow($h, $MONITOR_DEFAULTTONEAREST)
		if $wm = $monitor Then
			_ArrayAdd($windows, $h)
		 EndIf
	 Next

	_ArraySort($windows)

	Local $NumberOfWindows = UBound($windows) - 1

	Local $nextwin = $activewinhandle
	Local $index = _ArrayBinarySearch($windows, $activewinhandle)
	if @error Then
		$index = -1
	EndIf

	$index = $index + 1
	if $index<UBound($windows) Then
		$nextwin = $windows[$index]
	Else
		$index = 0
		$nextwin = $windows[$index]
	EndIf
   ;ConsoleWrite("Active: " & WinGetTitle($activewinhandle) & @CRLF)
   ;ConsoleWrite("Next: " & WinGetTitle($nextwin) & @CRLF)
   WinActivate($nextwin)
EndFunc


Func ActivatePreviousWindow()
ScanVisibleWindows()
	$Timer2 = 0
	if UBound($VisibleWindows)<=0 Then
		Return
	EndIf

	Local $nextwin = $activewinhandle
	Local $index = _ArrayBinarySearch($VisibleWindows, $activewinhandle)
	if @error Then
		$index = 1
	EndIf

	$index = $index - 1
	if $index < 0 Then
		$index = UBound($VisibleWindows) -1
	EndIf
	$nextwin = $VisibleWindows[$index]
   ;ConsoleWrite("Active: " & WinGetTitle($activewinhandle) & @CRLF)
   ;ConsoleWrite("Next: " & WinGetTitle($nextwin) & @CRLF)
   WinActivate($nextwin)
EndFunc

Func ReadIgnore()
   Local $file=FileOpen("Ignore")
   if $file>0 Then
	  While @error<>-1
		 Local $l = FileReadLine($file)
		 If @error = -1 Then
			ExitLoop
		 EndIf
		 _ArrayAdd($IgnoreWindowTitles, $l)
	  WEnd
	  _ArraySort($IgnoreWindowTitles)
   EndIf
EndFunc

Func IsIgnored($h)
   Local $Title = WinGetTitle($h)
   for $i=0 To UBound($IgnoreWindowTitles)-1
	   if StringRegExp($Title, $IgnoreWindowTitles[$i]) Then
		  Return True
	  EndIf
	Next
   Return False
EndFunc

Func WinCenterMouse($h)
	Local $pos = WinGetPos($h)
	if @error Then
		Return
	EndIf

	Local $mp = MouseGetPos()
	Local $mx = $mp[0]
	Local $my = $mp[1]

	Local $x = $mx - $pos[2]/2
	Local $y = $my - $pos[3]/2


	Local $s=WinGetState($h)

	if BitAND($s, $WIN_STATE_MAXIMIZED) Then
		WinSetState($h, "", @SW_RESTORE)
	EndIf

	WinMove($h, "", $x, $y, $pos[2], $pos[3])
EndFunc

Func WinMoveToMouse($h)
	Local $pos = WinGetPos($h)
	if @error Then
		Return
	EndIf

	Local $mp = MouseGetPos()
	Local $tPos = _WinAPI_GetMousePos()
	;ConsoleWrite("X=" & DllStructGetData($tPos, "X")  & @CRLF)
	;ConsoleWrite("Y=" & DllStructGetData($tPos, "Y")  & @CRLF)
	Local $mx = $mp[0]
	Local $my = $mp[1]

	Local $x = $mx - $pos[2]/2
	Local $y = $my - $pos[3]/2


	Local $s=WinGetState($h)

	if BitAND($s, $WIN_STATE_MAXIMIZED) Then
		WinSetState($h, "", @SW_RESTORE)
	EndIf

	Local $monitor=_WinAPI_MonitorFromPoint($tPos, $MONITOR_DEFAULTTONEAREST)

 	;ConsoleWrite("$monitor=" & $monitor & @CRLF)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorX1 = DllStructGetData($monitorinfo[1], 3)
	Local $MonitorY1 = DllStructGetData($monitorinfo[1], 4)

	if $x < $MonitorX0 Then
		$x = $MonitorX0
	EndIf

	if $x + $pos[2] > $MonitorX1 Then
		$x = $MonitorX1 - $pos[2]
	EndIf

	if $y < $MonitorY0 Then
		$y = $MonitorY0
	EndIf

	if $y + $pos[3] > $MonitorY1 Then
		$y = $MonitorY1 - $pos[3]
	EndIf

	WinMove($h, "", $x, $y, $pos[2], $pos[3])
EndFunc


Func WinTileVertHoriz($vert)
   ScanVisibleWindows()
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3)-$MonitorX0
	Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4)-$MonitorY0

	;ConsoleWrite('$MonitorSizeX: ' & $MonitorSizeX & @CRLF)
	;ConsoleWrite('$MonitorSizeY: ' & $MonitorSizeY & @CRLF)

	Local $windows[0]
	For $i = 0 To UBound($VisibleWindows)-1
		Local $h=$VisibleWindows[$i]
		Local $title=WinGetTitle($h)
		Local $s=WinGetState($h)
		Local $wm = _WinAPI_MonitorFromWindow($h, $MONITOR_DEFAULTTONEAREST)
		if $wm = $monitor Then
				;;ConsoleWrite($title & @CRLF)
		 _ArrayAdd($windows, $h)
		 EndIf
	Next

	Local $NumberOfWindows = UBound($windows)-1
	;ConsoleWrite("Number of windows: " & $NumberOfWindows & @CRLF)
	;ConsoleWrite("Collumns: " & $TileCollumns & @CRLF)
	;ConsoleWrite("Rows: " & $TileRows & @CRLF)

	Local $WinSizeX
	Local $WinSizeY

	if $vert Then
		$WinSizeX = Floor($MonitorSizeX/($NumberOfWindows+1))
		$WinSizeY = Floor($MonitorSizeY)
	Else
		$WinSizeX = Floor($MonitorSizeX)
		$WinSizeY = Floor($MonitorSizeY/($NumberOfWindows+1))
	EndIf
	;ConsoleWrite("$WinSizeX: " & $WinSizeX & @CRLF)
	;ConsoleWrite("$WinSizeY: " & $WinSizeY & @CRLF)

	Local $WinPosX = $MonitorX0
	Local $WinPosY = $MonitorY0

	For $i = 0 To $NumberOfWindows
		Local $h = $windows[$i]
		Local $s=WinGetState($h)
		if BitAND($s, $WIN_STATE_MAXIMIZED) Then
			WinSetState($h, "", @SW_RESTORE)
		EndIf
		Local $style = _WinAPI_GetWindowLong($h, $GWL_STYLE)

		;Local $ss = BitNOT(BitOR($WS_CAPTION, $WS_THICKFRAME, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SYSMENU))
		Local $ss = BitNOT(BitOR($WS_THICKFRAME, 0))

		$style = BitAND($style, $ss)

		_WinAPI_SetWindowLong($h, $GWL_STYLE , $style)
		WinMove($windows[$i], "", $WinPosX, $WinPosY, $WinSizeX, $WinSizeY)
		;ConsoleWrite("$WinPosX: " & $WinPosX & @CRLF)
		;ConsoleWrite("$WinPosY: " & $WinPosY & @CRLF)
		$WinPosX = $WinPosX + $WinSizeX
		if $WinPosX >= $MonitorSizeX + $MonitorX0 Then
			$WinPosX = $MonitorX0
			$WinPosY = $WinPosY + $WinSizeY
			if $WinPosY >= $MonitorSizeY + $MonitorY0 Then
				$WinPosY = $MonitorY0
			EndIf
		EndIf
	Next
 EndFunc

Func WinTileVertMaster($Increment)
	ScanVisibleWindows()

	If $Timer4 > $Timer4Max Then
		;Prevent increment if hotkey not pressed recently
	   $Increment = 0
	   $Timer4 = 0
	EndIf
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3)-$MonitorX0
	Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4)-$MonitorY0

	;ConsoleWrite('$MonitorSizeX: ' & $MonitorSizeX & @CRLF)
	;ConsoleWrite('$MonitorSizeY: ' & $MonitorSizeY & @CRLF)

	Local $windows[0]
	Local $MasterWinNr = 0
	For $i = 0 To UBound($VisibleWindows)-1
		if $i >= UBound($VisibleWindows) Then
			ExitLoop
		EndIf
		Local $h=$VisibleWindows[$i]
		Local $title=WinGetTitle($h)
		Local $s=WinGetState($h)
		Local $wm = _WinAPI_MonitorFromWindow($h, $MONITOR_DEFAULTTONEAREST)
		if $wm = $monitor Then
			;ConsoleWrite($title & @CRLF)
			_ArrayAdd($windows, $h)
			if IsMasterWindow($h) Then
				$MasterWinNr = $MasterWinNr + 1
			EndIf
		 EndIf
	Next

	Local $NumberOfWindows = UBound($windows)

	if $NumberOfWindows < 1 Then
		Return
	EndIf

	$MasterPercentV = $MasterPercentV + $Increment


	if $MasterPercentV < 5 Then
		$MasterPercentV = 5
	EndIf

	if $MasterPercentV > 95 Then
		$MasterPercentV = 95
	EndIf

	If $MasterWinNr = 0 Then
		SetWindowMaster($activewinhandle)
		$MasterWinNr = 1
	EndIf


	Local $WinSizeTotalMasterX = Floor($MonitorSizeX * $MasterPercentV / 100)
	Local $WinSizeMasterX = Floor($WinSizeTotalMasterX / $MasterWinNr)

	Local $WinSizeMasterY = Floor($MonitorSizeY)

	;ConsoleWrite("Number of windows: " & $NumberOfWindows & @CRLF)
	;ConsoleWrite("$MasterPercentV" & " = " & $MasterPercentV & @CRLF)
	;ConsoleWrite("$MasterWinNr" & " = " & $MasterWinNr & @CRLF)
	;ConsoleWrite("$WinSizeMasterX" & " = " & $WinSizeMasterX & @CRLF)
	;ConsoleWrite("$WinSizeMasterY" & " = " & $WinSizeMasterY & @CRLF)
	;ConsoleWrite("$WinSizeTotalMasterX" & " = " & $WinSizeTotalMasterX & @CRLF)

	Local $WinPosX = $MonitorX0 + $WinSizeTotalMasterX
	Local $WinPosY = $MonitorY0

	Local $WinPosMasterX = $MonitorX0

	Local $WinSizeX
	Local $WinSizeY

	$WinSizeX = Floor($MonitorSizeX - $WinSizeTotalMasterX)
	Local $NumberOfWindowsSlave = $NumberOfWindows - $MasterWinNr

	;ConsoleWrite("$NumberOfWindowsSlave" & " = " & $NumberOfWindowsSlave & @CRLF)

	If $NumberOfWindowsSlave < 1 Then
			$NumberOfWindowsSlave = 1
	EndIf

	$WinSizeY = Floor($MonitorSizeY / $NumberOfWindowsSlave)


	For $i = 0 To $NumberOfWindows-1
		Local $h = $windows[$i]
		Local $s=WinGetState($h)
		if BitAND($s, $WIN_STATE_MAXIMIZED) Then
			WinSetState($h, "", @SW_RESTORE)
		EndIf

		Local $style = _WinAPI_GetWindowLong($h, $GWL_STYLE)

		;Local $ss = BitNOT(BitOR($WS_CAPTION, $WS_THICKFRAME, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SYSMENU))
		Local $ss = BitNOT(BitOR($WS_THICKFRAME, 0))
			$style = BitAND($style, $ss)
			_WinAPI_SetWindowLong($h, $GWL_STYLE , $style)
			if IsMasterWindow($h) Then
			;ConsoleWrite("MasterWin " & " = " & WinGetTitle($h) & @CRLF)
				if $NumberOfWindows = 1 Then
					WinMove($windows[$i], "", $WinPosMasterX, $MonitorY0, $MonitorSizeX, $MonitorSizeY)
				Else
					WinMove($windows[$i], "", $WinPosMasterX, $MonitorY0, $WinSizeMasterX, $WinSizeMasterY)
				EndIf
				$WinPosMasterX = $WinPosMasterX + $WinSizeMasterX
			Else
				WinMove($windows[$i], "", $WinPosX, $WinPosY, $WinSizeX, $WinSizeY)
				$WinPosX = $MonitorX0 + $WinSizeTotalMasterX
				$WinPosY = $WinPosY + $WinSizeY
			EndIf
			;ConsoleWrite("$WinPosX: " & $WinPosX & @CRLF)
			;ConsoleWrite("$WinPosY: " & $WinPosY & @CRLF)
			if $WinPosX >= $MonitorSizeX + $MonitorX0 Then
			$WinPosX = $MonitorX0 + $WinSizeMasterX
			$WinPosY = $WinPosY + $WinSizeY
			if $WinPosY >= $MonitorSizeY + $MonitorY0 Then
				$WinPosY = $MonitorY0
			EndIf
		EndIf
	Next
 EndFunc

Func SetWindowMaster($h)
	;ConsoleWrite("SetWindowMaster " & " = " & WinGetTitle($h) & @CRLF)
	if not IsMasterWindow($h) Then
		_ArrayAdd($MasterWindows, $h)
	EndIf
EndFunc

Func ResetWindowMaster($h)
	;ConsoleWrite("ResetWindowMaster " & " = " & WinGetTitle($h) & @CRLF)
	if IsMasterWindow($h) Then
		_ArrayDelete($MasterWindows, _ArrayBinarySearch($MasterWindows, $h))
	EndIf
EndFunc

Func IsMasterWindow($h)
	;ConsoleWrite("IsMasterWindow " & " = " & WinGetTitle($h) & @CRLF)
	_ArraySort($MasterWindows)
	Local $index = _ArrayBinarySearch($MasterWindows, $h)
	;ConsoleWrite("$index " & " = " & $index & @CRLF)

	Local $r = False
	if $index >= 0 Then
		$r = True
	EndIf
	;ConsoleWrite("$r " & " = " & $r & @CRLF)
	Return $r
EndFunc

Func ToggleWindowMaster($h)
	;ConsoleWrite("ToggleWindowMaster " & " = " & WinGetTitle($h) & @CRLF)
	if not IsMasterWindow($h) Then
		_ArrayAdd($MasterWindows, $h)
	Else
		_ArrayDelete($MasterWindows, _ArrayBinarySearch($MasterWindows, $h))
	EndIf
EndFunc



Func WinTileHorizMaster($Increment)
	ScanVisibleWindows()

	If $Timer4 > $Timer4Max Then
		;Prevent increment if hotkey not pressed recently
	   $Increment = 0
	   $Timer4 = 0
	EndIf
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3)-$MonitorX0
	Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4)-$MonitorY0

	;ConsoleWrite('$MonitorSizeX: ' & $MonitorSizeX & @CRLF)
	;ConsoleWrite('$MonitorSizeY: ' & $MonitorSizeY & @CRLF)

	Local $windows[0]
	Local $MasterWinNr = 0
	For $i = 0 To UBound($VisibleWindows)-1
		if $i >= UBound($VisibleWindows) Then
			ExitLoop
		EndIf
		Local $h=$VisibleWindows[$i]
		Local $title=WinGetTitle($h)
		Local $s=WinGetState($h)
		Local $wm = _WinAPI_MonitorFromWindow($h, $MONITOR_DEFAULTTONEAREST)
		if $wm = $monitor Then
			;ConsoleWrite($title & @CRLF)
			_ArrayAdd($windows, $h)
			if IsMasterWindow($h) Then
				$MasterWinNr = $MasterWinNr + 1
			EndIf
		 EndIf
	Next

	Local $NumberOfWindows = UBound($windows)

	if $NumberOfWindows < 1 Then
		Return
	EndIf

	$MasterPercentH = $MasterPercentH + $Increment


	if $MasterPercentH < 5 Then
		$MasterPercentH = 5
	EndIf

	if $MasterPercentH > 95 Then
		$MasterPercentH = 95
	EndIf

	If $MasterWinNr = 0 Then
		SetWindowMaster($activewinhandle)
		$MasterWinNr = 1
	EndIf


	Local $WinSizeTotalMasterX = Floor($MonitorSizeX * $MasterPercentH / 100)
	Local $WinSizeMasterX = Floor($WinSizeTotalMasterX)

	Local $WinSizeMasterY = Floor($MonitorSizeY / $MasterWinNr)

	;ConsoleWrite("Number of windows: " & $NumberOfWindows & @CRLF)
	;ConsoleWrite("$MasterPercentH" & " = " & $MasterPercentH & @CRLF)
	;ConsoleWrite("$MasterWinNr" & " = " & $MasterWinNr & @CRLF)
	;ConsoleWrite("$WinSizeMasterX" & " = " & $WinSizeMasterX & @CRLF)
	;ConsoleWrite("$WinSizeMasterY" & " = " & $WinSizeMasterY & @CRLF)
	;ConsoleWrite("$WinSizeTotalMasterX" & " = " & $WinSizeTotalMasterX & @CRLF)

	Local $WinPosX = $MonitorX0 + $WinSizeTotalMasterX
	Local $WinPosY = $MonitorY0

	Local $WinPosMasterX = $MonitorX0
	Local $WinPosMasterY = $MonitorY0

	Local $WinSizeX
	Local $WinSizeY

	Local $NumberOfWindowsSlave = $NumberOfWindows - $MasterWinNr

	;ConsoleWrite("$NumberOfWindowsSlave" & " = " & $NumberOfWindowsSlave & @CRLF)

	If $NumberOfWindowsSlave < 1 Then
			$NumberOfWindowsSlave = 1
		EndIf

	$WinSizeX = Floor(($MonitorSizeX - $WinSizeTotalMasterX) / $NumberOfWindowsSlave)
	$WinSizeY = $MonitorSizeY

	For $i = 0 To $NumberOfWindows-1
		Local $h = $windows[$i]
		Local $s=WinGetState($h)
		if BitAND($s, $WIN_STATE_MAXIMIZED) Then
			WinSetState($h, "", @SW_RESTORE)
		EndIf
		Local $style = _WinAPI_GetWindowLong($h, $GWL_STYLE)

		;Local $ss = BitNOT(BitOR($WS_CAPTION, $WS_THICKFRAME, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SYSMENU))
		Local $ss = BitNOT(BitOR($WS_THICKFRAME, 0))

		$style = BitAND($style, $ss)

		_WinAPI_SetWindowLong($h, $GWL_STYLE , $style)

		if IsMasterWindow($h) Then
			;ConsoleWrite("MasterWin " & " = " & WinGetTitle($h) & @CRLF)
			if $NumberOfWindows = 1 Then
				WinMove($windows[$i], "", $WinPosMasterX, $WinPosMasterY, $MonitorSizeX, $MonitorSizeY)
			Else
				WinMove($windows[$i], "", $WinPosMasterX, $WinPosMasterY, $WinSizeMasterX, $WinSizeMasterY)
			EndIf
			$WinPosMasterY = $WinPosMasterY + $WinSizeMasterY
		Else
			WinMove($windows[$i], "", $WinPosX, $WinPosY, $WinSizeX, $WinSizeY)
			$WinPosX = $WinPosX + $WinSizeX
		EndIf
		;ConsoleWrite("$WinPosX: " & $WinPosX & @CRLF)
		;ConsoleWrite("$WinPosY: " & $WinPosY & @CRLF)

		if $WinPosX >= $MonitorSizeX + $MonitorX0 Then
			$WinPosX = $MonitorX0 + $WinSizeMasterX
		EndIf
	Next
 EndFunc

;Return number of monitors and fills $monitors
Func MonitorCount()

;	Local $mc = 0
;	Local $i = 0
;	_ArrayDelete($monitors, "0-" & String(UBound($monitors)-1))
;	While 1
;       Local $aDevice = _WinAPI_EnumDisplayDevices("", $i)
;        If @error Or Not $aDevice[0] Then ExitLoop
;		If BitAND($aDevice[3], 1) Then
;			$mc += 1
;			_ArrayAdd($monitors, $i)
;		EndIf
;	$i += 1
;	WEnd
	$monitors = _WinAPI_EnumDisplayMonitors()
	Return $monitors[0][0]
EndFunc


Func RepeatLastCommand()
	;ConsoleWrite("RepeatLastCommand()")
	if $LastCmdRepeat Then
		$LastCmdRepeat = False
		MsgBox(0, "Cmd", "Repeat off", 1)
	Else
		$LastCmdRepeat = True
		MsgBox(0, "Cmd", "Repeat on", 1)
	EndIf
EndFunc

Func SendLastCmd()
	;ConsoleWrite("SendLastCmd()")
	;ConsoleWrite("$LastCmd=" & $LastCmd & @CRLF)
	if $LastCmdRepeat Then
		GetWindowList()
		Switch $LastCmd
			Case 1:
				WinMaximizeVisible()
			Case 2:
				WinTileVertHoriz(True)
			Case 3:
				WinTileVertHoriz(False)
			Case 4:
				WinTileVertMaster(0)
			Case 5:
				WinTileHorizMaster(0)
			Case 6:
				TileAll()
		EndSwitch
	EndIf
EndFunc

Func KeepWindowActive()
	if $bKeepWindowActive Then
		MsgBox(0, "Keep windows active", "OFF", 1)
		$bKeepWindowActive = False
	Else
		$bKeepWindowActive = True
		$hKeepWindowActive = $activewinhandle
		WinActivate($hKeepWindowActive)
		MsgBox(0, "Keep windows active", "ON", 1)
	EndIf
EndFunc

Func TileAll()
	;ConsoleWrite("TileAll()" & @CRLF)
	ScanVisibleWindows()
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3)-$MonitorX0
	Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4)-$MonitorY0

	;ConsoleWrite('$MonitorSizeX: ' & $MonitorSizeX & @CRLF)
	;ConsoleWrite('$MonitorSizeY: ' & $MonitorSizeY & @CRLF)

	;ConsoleWrite("$VisibleWindows = " & UBound($VisibleWindows) & @CRLF)
	Local $windows[0]
	For $i = 0 To UBound($VisibleWindows)-1
		Local $h=$VisibleWindows[$i]
		Local $title=WinGetTitle($h)
		Local $s=WinGetState($h)
		Local $wm = _WinAPI_MonitorFromWindow($h, $MONITOR_DEFAULTTONEAREST)
		if $wm = $monitor Then
				;ConsoleWrite($title & @CRLF)
		 _ArrayAdd($windows, $h)
		 EndIf
	Next

	Local $NumberOfWindows = UBound($windows)
 	Local $gy = Sqrt(Number($NumberOfWindows))
	Local $ggy = Ceiling($gy)
	Local $Collumns = $ggy
	Local $Rows = Ceiling($NumberOfWindows / $ggy)

	If $Collumns < 1 Then
		$Collumns = 1
	EndIf

	If $Rows < 1 Then
		$Rows = 1
	EndIf

	;ConsoleWrite("Number of windows: " & $NumberOfWindows & @CRLF)
	;ConsoleWrite("Collumns: " & $Collumns & @CRLF)
	;ConsoleWrite("Rows: " & $Rows & @CRLF)

	Local $WinSizeX = Floor($MonitorSizeX/$Collumns)
	Local $WinSizeY = Floor($MonitorSizeY/$Rows)

	;ConsoleWrite("$WinSizeX: " & $WinSizeX & @CRLF)
	;ConsoleWrite("$WinSizeY: " & $WinSizeY & @CRLF)

	Local $WinPosX = $MonitorX0
	Local $WinPosY = $MonitorY0

	Local $WinNrLastRow = $NumberOfWindows - $Collumns * ($Rows - 1)

	;ConsoleWrite("$WinNrLastRow: " & $WinNrLastRow & @CRLF)
	Local $WinSizeLastRow = Floor($MonitorSizeX/$WinNrLastRow)
	Local $CurrentRow = 1

	Local $col=1

	For $i = 0 To $NumberOfWindows - 1
		Local $h = $windows[$i]
		Local $s=WinGetState($h)
		if BitAND($s, $WIN_STATE_MAXIMIZED) Then
			WinSetState($h, "", @SW_RESTORE)
		EndIf

		Local $style = _WinAPI_GetWindowLong($h, $GWL_STYLE)

		;Local $ss = BitNOT(BitOR($WS_CAPTION, $WS_THICKFRAME, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SYSMENU))
		Local $ss = BitNOT(BitOR($WS_THICKFRAME, 0))

		$style = BitAND($style, $ss)

		_WinAPI_SetWindowLong($h, $GWL_STYLE , $style)
		WinMove($windows[$i], "", $WinPosX, $WinPosY, $WinSizeX, $WinSizeY)

		;ConsoleWrite("$WinPosX: " & $WinPosX & @CRLF)
		;ConsoleWrite("$WinPosY: " & $WinPosY & @CRLF)

		;ConsoleWrite("$col: " & $col & @CRLF)

		$WinPosX = $WinPosX + $WinSizeX
		if ($WinPosX >= $MonitorSizeX + $MonitorX0) Or $col>=$Collumns Then
			$WinPosX = $MonitorX0
			$WinPosY = $WinPosY + $WinSizeY
			if $WinPosY >= $MonitorSizeY + $MonitorY0 Then
				$WinPosY = $MonitorY0
			EndIf
			$CurrentRow += 1
			if $CurrentRow = $Rows Then
				$WinSizeX = $WinSizeLastRow
			EndIf
			$col=0
		EndIf
		$col+=1
	Next
EndFunc

Func ExecuteScript()
	;ConsoleWrite("ExecuteScript()" & @CRLF)
	$SriptPID = ShellExecute("script.au3")
EndFunc

Func EditScript()
	;ConsoleWrite("EditScript()" & @CRLF)
 	ShellExecute("C:\Program Files (x86)\AutoIt3\SciTE\SciTE.exe", "script.au3")
EndFunc

Func StopScript()
	;ConsoleWrite("StopScript()" & @CRLF)
 	ProcessClose($SriptPID)
EndFunc

Func MoveWindowToNextMonitor()
	;ConsoleWrite("MoveWindowToNextMonitor()" & @CRLF)
	ScanVisibleWindows()
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf
	Local $mc = MonitorCount()
	;ConsoleWrite("$mc" & " = " & $mc & @CRLF)
	Local $DesktopX0=_WinAPI_GetSystemMetrics(76)	;SM_XVIRTUALSCREEN
	Local $DesktopY0=_WinAPI_GetSystemMetrics(77)	;SM_YVIRTUALSCREEN
	Local $DesktopSizeX=_WinAPI_GetSystemMetrics(78)	;SM_CXVIRTUALSCREEN
	Local $DesktopSizeY=_WinAPI_GetSystemMetrics(79)	;SM_CYVIRTUALSCREEN

	Local $nextindex = 1

	For $m = 1 to $mc
		Local $monitorinfo2 = _WinAPI_GetMonitorInfo($monitors[$m][0])
		If not IsArray($monitorinfo2) Then
			;ConsoleWrite("Not a monitor" & @CRLF)
			ExitLoop
		EndIf

		$nextindex = $m
		if $monitorinfo[3] = $monitorinfo2[3] Then
			;ConsoleWrite("$m = " & $m  & @CRLF)
			$nextindex += 1
			if $nextindex > $mc Then
				$nextindex = 1
				ExitLoop
			EndIf
		EndIf

		Next

	;ConsoleWrite("$nextindex = " & $nextindex  & @CRLF)

	$monitorinfo = _WinAPI_GetMonitorInfo($monitors[$nextindex][0])

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3) - $MonitorX0
	Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4) - $MonitorY0


	Local $a = WinGetPos($activewinhandle)
	Local $wSizeX = $a[2]
	Local $wSizeY = $a[3]

	if $wSizeX > $MonitorSizeX Then
		$wSizeX = $MonitorSizeX
	EndIf

	if $wSizeY > $MonitorSizeY Then
		$wSizeY = $MonitorSizeY
	EndIf

	WinMove($activewinhandle, "", $MonitorX0, $MonitorY0, $wSizeX, $wSizeY)

	;ConsoleWrite("WinMove(" & $activewinhandle & ", " & $MonitorX0 &", " & $MonitorY0 & ", " & $wSizeX & ", " & $wSizeY &")" & @CRLF)

EndFunc
Func MoveWindowToPrevMonitor()
	;ConsoleWrite("MoveWindowToNextMonitor()" & @CRLF)
	ScanVisibleWindows()
	Local $monitor=_WinAPI_MonitorFromWindow($activewinhandle, $MONITOR_DEFAULTTONEAREST)
	Local $monitorinfo = _WinAPI_GetMonitorInfo($monitor)
	If not IsArray($monitorinfo) Then
		Return
	EndIf
	Local $mc = MonitorCount()
	;ConsoleWrite("$mc" & " = " & $mc & @CRLF)
	Local $DesktopX0=_WinAPI_GetSystemMetrics(76)	;SM_XVIRTUALSCREEN
	Local $DesktopY0=_WinAPI_GetSystemMetrics(77)	;SM_YVIRTUALSCREEN
	Local $DesktopSizeX=_WinAPI_GetSystemMetrics(78)	;SM_CXVIRTUALSCREEN
	Local $DesktopSizeY=_WinAPI_GetSystemMetrics(79)	;SM_CYVIRTUALSCREEN

	Local $nextindex = 1

	For $m = 1 to $mc
		Local $monitorinfo2 = _WinAPI_GetMonitorInfo($monitors[$m][0])
		If not IsArray($monitorinfo2) Then
			;ConsoleWrite("Not a monitor" & @CRLF)
			ExitLoop
		EndIf

		$nextindex = $m
		if $monitorinfo[3] = $monitorinfo2[3] Then
			;ConsoleWrite("$m = " & $m  & @CRLF)
			$nextindex -= 1
			if $nextindex < 1 Then
				$nextindex = $mc
				ExitLoop
			EndIf
		EndIf

		Next

	;ConsoleWrite("$nextindex = " & $nextindex  & @CRLF)

	$monitorinfo = _WinAPI_GetMonitorInfo($monitors[$nextindex][0])

	Local $MonitorX0 = DllStructGetData($monitorinfo[1], 1)
	Local $MonitorY0 = DllStructGetData($monitorinfo[1], 2)

	Local $MonitorSizeX=DllStructGetData($monitorinfo[1], 3) - $MonitorX0
	Local $MonitorSizeY=DllStructGetData($monitorinfo[1], 4) - $MonitorY0


	Local $a = WinGetPos($activewinhandle)
	Local $wSizeX = $a[2]
	Local $wSizeY = $a[3]

	if $wSizeX > $MonitorSizeX Then
		$wSizeX = $MonitorSizeX
	EndIf

	if $wSizeY > $MonitorSizeY Then
		$wSizeY = $MonitorSizeY
	EndIf

	WinMove($activewinhandle, "", $MonitorX0, $MonitorY0, $wSizeX, $wSizeY)

	;ConsoleWrite("WinMove(" & $activewinhandle & ", " & $MonitorX0 &", " & $MonitorY0 & ", " & $wSizeX & ", " & $wSizeY &")" & @CRLF)

EndFunc

