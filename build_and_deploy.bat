@echo off
echo =======================================================================
echo HydroStock: Building ^& Deploying to XAMPP Tomcat
echo =======================================================================

set "BASE=%~dp0"
set "CLASSES=%BASE%src\main\webapp\WEB-INF\classes"
set "TOMCAT_WEBAPPS=C:\xampp\tomcat\webapps\HydroStock"
set "TOMCAT_WAR=C:\xampp\tomcat\webapps\HydroStock.war"
set "CP=C:\xampp\tomcat\lib\servlet-api.jar;C:\xampp\tomcat\lib\jsp-api.jar;%BASE%src\main\webapp\WEB-INF\lib\mysql-connector-j.jar;%BASE%src\main\webapp\WEB-INF\lib\jstl-1.2.jar"

if not exist "%CLASSES%" mkdir "%CLASSES%"

echo 1. Compiling Java Classes...
dir /s /b "%BASE%src\main\java\*.java" > "%BASE%sources.txt"
javac -encoding UTF-8 -cp "%CP%" -d "%CLASSES%" @"%BASE%sources.txt"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java compilation failed! Please check errors above.
    pause
    exit /b %ERRORLEVEL%
)

echo [OK] Compilation successful!
echo.
echo 2. Deploying to XAMPP Tomcat webapps...
if not exist "%TOMCAT_WEBAPPS%" mkdir "%TOMCAT_WEBAPPS%"
"%SystemRoot%\System32\robocopy.exe" "%BASE%src\main\webapp" "%TOMCAT_WEBAPPS%" /E /IS /IT > nul
if %ERRORLEVEL% GEQ 8 (
    echo [ERROR] Deployment copy failed.
    exit /b %ERRORLEVEL%
)

echo 3. Packaging WAR for Tomcat auto-deploy...
"%JAVA_HOME%\bin\jar.exe" -cf "%TOMCAT_WAR%" -C "%BASE%src\main\webapp" .
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] WAR packaging failed.
    exit /b %ERRORLEVEL%
)

echo [OK] HydroStock deployed successfully to %TOMCAT_WEBAPPS%
echo.
echo Open in browser: http://localhost:8080/HydroStock
echo =======================================================================
pause
