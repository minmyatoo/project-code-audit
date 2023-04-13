@ECHO OFF
SETLOCAL

REM Define engine names
SET FIXME_ENGINE=codeclimate/codeclimate-fixme
SET ESLINT_ENGINE=codeclimate/codeclimate-eslint
SET STRUCTURE_ENGINE=codeclimate/codeclimate-structure
SET DUPLICATION_ENGINE=codeclimate/codeclimate-duplication
SET CORE_ENGINE=codeclimate/codeclimate

:MENU
CLS
ECHO.
ECHO Code Climate Bat Script (MIN MYAT OO)
ECHO ==========================
ECHO 1. Check Docker version
ECHO 2. Install CodeClimate engines
ECHO 3. Run Code Climate Analysis
ECHO 4. Export Report as HTML (report.html)
ECHO 5. Exit
ECHO.

SET /P CHOICE="Enter your choice (1-5): "

IF "%CHOICE%"=="1" (
    CALL :CHECK_DOCKER_VERSION
) ELSE IF "%CHOICE%"=="2" (
    CALL :INSTALL_CODECLIMATE_ENGINES
) ELSE IF "%CHOICE%"=="3" (
    CALL :RUN_ANALYSIS
) ELSE IF "%CHOICE%"=="4" (
    CALL :EXPORT_REPORT
) ELSE IF "%CHOICE%"=="5" (
    CALL :EXIT
) ELSE (
    ECHO Invalid choice. Please enter a number between 1 and 5.
    PAUSE
    GOTO MENU
)
GOTO MENU

:CHECK_DOCKER_VERSION
docker --version
PAUSE
GOTO :EOF

:INSTALL_CODECLIMATE_ENGINES
docker pull %FIXME_ENGINE%
docker pull %ESLINT_ENGINE%
docker pull %STRUCTURE_ENGINE%
docker pull %DUPLICATION_ENGINE%
docker pull %CORE_ENGINE%

REM Add any additional engine pull commands here
PAUSE
GOTO :EOF

:RUN_ANALYSIS
SET "CODECLIMATE_CODE=%CD:=/%"
SET "CODECLIMATE_CODE=%CODECLIMATE_CODE:C:=/c%"
SET "CODECLIMATE_TMP=%TEMP:=/%/codeclimate"
SET "CODECLIMATE_TMP=%CODECLIMATE_TMP:C:=/c%"

docker run ^
--interactive --rm ^
--env CODECLIMATE_CODE ^
--env CODECLIMATE_TMP ^
--env CODECLIMATE_DEBUG ^
--volume "%CODECLIMATE_CODE%":/code ^
--volume "%CODECLIMATE_TMP%":/tmp/cc ^
--volume /var/run/docker.sock:/var/run/docker.sock ^
%CORE_ENGINE% analyze

ECHO Process finished.
PAUSE
GOTO :EOF

:EXPORT_REPORT
SET "CODECLIMATE_CODE=%CD:=/%"
SET "CODECLIMATE_CODE=%CODECLIMATE_CODE:C:=/c%"
SET "CODECLIMATE_TMP=%TEMP:=/%/codeclimate"
SET "CODECLIMATE_TMP=%CODECLIMATE_TMP:C:=/c%"

docker run ^
--interactive --rm ^
--env CODECLIMATE_CODE ^
--env CODECLIMATE_TMP ^
--env CODECLIMATE_DEBUG ^
--volume "%CODECLIMATE_CODE%":/code ^
--volume "%CODECLIMATE_TMP%":/tmp/cc ^
--volume /var/run/docker.sock:/var/run/docker.sock ^
%CORE_ENGINE% analyze -f html > report.html

ECHO Report exported as report.html in the current directory.
PAUSE
GOTO :EOF

:EXIT
ENDLOCAL
