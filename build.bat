@echo off
set "BASE=C:\Users\Hp\.gemini\antigravity\scratch\HydroStock"
set "CLASSES=%BASE%\src\main\webapp\WEB-INF\classes"
if not exist "%CLASSES%" mkdir "%CLASSES%"

set "CP=C:\xampp\tomcat\lib\servlet-api.jar;C:\xampp\tomcat\lib\jsp-api.jar;%BASE%\src\main\webapp\WEB-INF\lib\mysql-connector-j.jar;%BASE%\src\main\webapp\WEB-INF\lib\jstl-1.2.jar"

dir /s /b "%BASE%\src\main\java\*.java" > "%BASE%\sources.txt"
javac -encoding UTF-8 -cp "%CP%" -d "%CLASSES%" @"%BASE%\sources.txt"
echo Compilation returned code %ERRORLEVEL%
