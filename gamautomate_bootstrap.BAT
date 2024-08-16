@echo off

:: Set up environment variables.
set "directory=C:\gamsync\automate\servicerecruitment1\"
set "group=ENTERGROUPEMAIL"
set "groupquery=%directory%\groupquery.csv"

:: Set up google drive environment variables.
set "googledrive=ENTERGOOGLEDRIVEID"
set "googledrivefolder=ENTERGOOGLEFOLDERID"

:: Set up folder and file export data.
set folderquery=%directory%folderquery.csv
set filequery=%directory%filequery.csv
set filevalidator=%directory%filevalidator.csv


:: PowerShell function for handling data.
set function_filename=%directory%function_filename.ps1
set function_log=%directory%function_log.ps1
set function_filevalidator=%directory%function_filevalidator.ps1
set function_foldervalidator=%directory%function_foldervalidator.ps1

:: Redirect output to the log file.
echo Starting process at %date% %time%

:: Step 1: Run GAM commands.
echo Running GAM commands...
cd "C:\gamadv-xtd3"
del "%directory%\*.csv"
gam user %group% print delegates > %groupquery%
gam csv %groupquery% gam user "~delegateAddress" print filelist filepath query "title='Meet Recordings'" id > %folderquery%
powershell.exe -ExecutionPolicy Bypass -File %function_foldervalidator%
gam csv %folderquery% gam user "~Owner" print filelist select "~id" fields name, id > %filequery%

:: Step 2: Execute the PowerShell script.
echo Executing PowerShell script...
powershell.exe -ExecutionPolicy Bypass -File %function_filename%

:: Step 3: Validate existing files and remove them from the transaction file.
gam user gads@nationalexpress.com print filelist select teamdrive "Recruitment" teamdrivefilename "Meeting Recordings" fields name > %filevalidator%
powershell.exe -ExecutionPolicy Bypass -File %function_filevalidator%

:: Step 4: Update permissions and copy files using GAM.
echo Updating permissions and copying files...
gam csv %folderquery% gam user gads@nationalexpress.com add drivefileacl %googledrive% user "~Owner" role manager
gam csv %filequery% gam user "~Owner" copy drivefile "~id" recursive parentid %googledrivefolder% newfilename ~newname

cd "%directory%"
powershell.exe -ExecutionPolicy Bypass -File %function_log%
echo Process completed at %date% %time%

Exit