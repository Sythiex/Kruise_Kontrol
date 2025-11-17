@echo off
setlocal enableDelayedExpansion

REM Ensure jq is installed and available in PATH
where jq >nul 2>nul
if %errorlevel% neq 0 (
    echo jq is not installed. Please install jq and ensure it is in your PATH.
    exit /b 1
)

set "modFolder=Kruise_Kontrol_Updated"
set "jsonFile=%~dp0%modFolder%/info.json"

REM Parse the version property from the JSON file using jq
for /f "delims=" %%i in ('jq -r ".version" "%jsonFile%"') do (
    set version=%%i
    echo The version is: !version!
)

REM Check if the version was found
if "%version%"=="" (
    echo "version" property not found in the JSON file.
    exit /b 1
)

set "publishName=%modFolder%_%version%"
REM Create a temporary folder with the version name
if exist "%publishName%" (
    rmdir /s /q "%publishName%"
)
mkdir "%publishName%"

REM Copy the contents of %modFolder% into the versioned folder
xcopy /e /i /h "%modFolder%\*" "%publishName%\" > nul

REM Create the zip file with the versioned folder
REM powershell -Command "Compress-Archive -Path %publishName% -DestinationPath %publishName%.zip"
if exist "%publishName%.zip" (
    del "%publishName%.zip"
)
zip -FS -r "%publishName%.zip" "./%publishName%" > nul

REM Clean up by removing the temporary versioned folder
REM rmdir /s /q "%publishName%"

echo "%publishName%.zip" created.

if "%1"=="copy_to_mods" (
    xcopy /f /s /y "%publishName%.zip" "%appData%\Factorio\mods\" > nul
    echo "%publishName%.zip" copied to "%appData%\Factorio\mods\".
)

echo Task completed!