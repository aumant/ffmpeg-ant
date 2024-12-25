@ECHO OFF
SET fpath=%~dp0
SET ffmpeg=%fpath%ffmpeg.exe
SET ffprobe=%fpath%ffprobe.exe
SET ffplay=%fpath%ffplay.exe
CLS
FOR %%i IN (%1) DO IF EXIST %%~si\NUL GOTO:MENUFOLDER

:MENUFILE

ECHO ____________ MENU FILE _______________
ECHO 1.  Convert to MP4 with best quality
ECHO 2.  Convert to MP4 with normal quality (low file size)
ECHO 3.  Convert to 720p MP4
ECHO -------------------------------------
ECHO 4.  Get selected file codecs info
ECHO 5.  Play selected file
ECHO 6.  Rename file to current date and time - title
ECHO -------------------------------------
ECHO 7.  Extract soundtrack
ECHO -------------------------------------
ECHO 8.  Show list of devices
ECHO 9.  Move flags to begining
ECHO _____________________________________
ECHO           PRESS 'Q' TO QUIT
ECHO.

SET INPUT=
SET /P INPUT=Please type in selected number:

IF /I '%INPUT%'=='1' GOTO:Selection1
IF /I '%INPUT%'=='2' GOTO:Selection2
IF /I '%INPUT%'=='3' GOTO:Selection3
IF /I '%INPUT%'=='4' GOTO:Selection4
IF /I '%INPUT%'=='5' GOTO:Selection5
IF /I '%INPUT%'=='6' GOTO:Selection6
IF /I '%INPUT%'=='7' GOTO:Selection7
IF /I '%INPUT%'=='8' GOTO:Selection8
IF /I '%INPUT%'=='9' GOTO:Selection9
IF /I '%INPUT%'=='q' GOTO:Quit

CLS

ECHO             INVALID INPUT
ECHO Please select a number from the Main
echo Menu [1-9] or select 'Q' to quit.
ECHO 
ECHO       PRESS ANY KEY TO CONTINUE

PAUSE > NUL
GOTO MENUFILE


:Selection1
%ffmpeg% -hide_banner -i %1 -vcodec libx264 -strict -2 -threads 0 -y %1.mp4
GOTO:Quit

:Selection2
%ffmpeg% -hide_banner -i %1 -filter:v yadif=0:-1:1 -pix_fmt yuv420p -c:v libx264 -preset medium -profile:v high -level 4.1 -qmin 30 -qmax 40 -bufsize 2M -strict -2 -y %1.mp4
GOTO:Quit

:Selection3
%ffmpeg% -hide_banner -i %1 -s hd720 -vcodec libx264 -strict -2 -threads 0 -y %1_720.mp4
GOTO:Quit

:Selection4
%ffmpeg% -hide_banner -i %1
GOTO:MENU

:Selection5
%ffplay% -i %1
GOTO:MENU

:Selection6
ren %1 %date:~-4%%date:~3,2%%date:~0,2%_%time:~-0,2%%time:~3,2%%time:~6,2%-%~n1%~x1
GOTO:Quit

:Selection7

%ffmpeg% -hide_banner -i %1 -vn -acodec copy %1_sound.m4a
GOTO:Quit

:Selection8

%ffmpeg% -list_devices true -f dshow -i dummy
GOTO:MENU

:Selection9

%ffmpeg% -hide_banner -i %1 -c copy -movflags +faststart -y %1.mp4

GOTO:Quit

:MENUFOLDER

ECHO ___________MENU FOLDER_____________
ECHO 1.  Convert to MP4 with best quality
ECHO 2.  Convert to MP4 with normal quality (low file size)
ECHO 3.  Convert to 720p MP4
ECHO 4.  Join videofiles and convert to MP4
ECHO -------------------------------------
ECHO 5.  Extract soundtracks from video
ECHO 6.  Convert sound files to MP3
ECHO _____________________________________
ECHO           PRESS 'Q' TO QUIT
ECHO.

SET INPUT=
SET /P INPUT=Please type in selected number:

IF /I '%INPUT%'=='1' GOTO:SelectionFolder1
IF /I '%INPUT%'=='2' GOTO:SelectionFolder2
IF /I '%INPUT%'=='3' GOTO:SelectionFolder3
IF /I '%INPUT%'=='4' GOTO:SelectionFolder4
IF /I '%INPUT%'=='5' GOTO:SelectionFolder5
IF /I '%INPUT%'=='6' GOTO:SelectionFolder6
IF /I '%INPUT%'=='7' GOTO:SelectionFolder7
IF /I '%INPUT%'=='8' GOTO:SelectionFolder8
IF /I '%INPUT%'=='9' GOTO:SelectionFolder9
IF /I '%INPUT%'=='q' GOTO:Quit

CLS

ECHO             INVALID INPUT
ECHO Please select a number from the Main
echo Menu [1-9] or select 'Q' to quit.
ECHO 
ECHO       PRESS ANY KEY TO CONTINUE

PAUSE > NUL
GOTO MENUFOLDER

:SelectionFolder1

set np=%~1_mp4
md "%np%"
for %%f in (%1\*.*) do (
	%ffmpeg% -hide_banner -i "%%f" -vcodec libx264 -strict -2 -threads 0 -y "%np%/%%~nf.mp4"
	echo _____________________________________
	echo Converted files are here: %np%
	)
GOTO:Quit

:SelectionFolder2
set np=%~1_mp4
md "%np%"
for %%f in (%1\*.*) do (
	%ffmpeg% -hide_banner -i "%%f" -filter:v yadif=0:-1:1 -pix_fmt yuv420p -c:v libx264 -preset medium -profile:v high -level 4.1 -qmin 30 -qmax 40 -bufsize 2M -strict -2 -y "%np%/%%~nf.mp4"
	echo _____________________________________
	echo Converted files are here: %np%
	)
GOTO:Quit

:SelectionFolder3
set np=%~1_mp4_720p
md "%np%"
for %%f in (%1\*.*) do (
	%ffmpeg% -hide_banner -i "%%f" -s hd720 -vcodec libx264 -strict -2 -threads 0 -y "%np%/%%~nf.mp4"
	echo _____________________________________
	echo Converted files are here: %np%
	)
GOTO:Quit

:SelectionFolder4

del %~dp0list.txt
for %%f in (%1\*.*) do echo file %%~nxf >>%~dp0list.txt
cd /D %1
%ffmpeg% -hide_banner -f concat -i %~dp0list.txt -vcodec libx264 -strict -2 -threads 0 -y %1.mp4
echo _____________________________________
echo Joined and converted files are here: %1.mp4
	
GOTO:Quit



:SelectionFolder5
set np=%~1_m4a
md "%np%"
for %%f in (%1\*.*) do (
	%ffmpeg% -hide_banner -i "%%f" -s hd720 -vn -acodec aac "%np%/%%~nf.m4a"
	echo _____________________________________
	echo Extracted soundtracks are here: %np%
	)
GOTO:Quit

:SelectionFolder6
set np=%~1_mp3
md "%np%"
for %%f in (%1\*.*) do (
	%ffmpeg% -hide_banner -i "%%f" -vn -acodec libmp3lame -ab 128k "%np%/%%~nf.mp3"
	echo _____________________________________
	echo Converted files are here: %np%
	)
GOTO:Quit

:SelectionFolder6
GOTO:Quit

:SelectionFolder7
GOTO:Quit

:SelectionFolder8
GOTO:Quit

:SelectionFolder9
GOTO:Quit


:Quit

ECHO _____________________________________
ECHO powered by FFmpeg
ECHO ---- created by anton@sozorov.ru ----
ECHO _____________________________________
ECHO        PRESS ANY KEY TO EXIT

PAUSE>NUL
EXIT